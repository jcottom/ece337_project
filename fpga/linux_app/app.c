#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>

#include "PCIE.h"

//MAX BUFFER FOR DMA
#define MAXDMA 32

//BASE ADDRESS FOR CONTROL REGISTER
#define CRA 0x00000000		// This is the starting address of the Custom Slave module. This maps to the address space of the custom module in the Qsys subsystem.

//BASE ADDRESS TO SDRAM
#define SDRAM 0x08000000	// This is the starting address of the SDRAM controller. This maps to the address space of the SDRAM controller in the Qsys subsystem.
#define START_BYTE 0xF00BF00B
#define RWSIZE (32 / 8)
PCIE_BAR pcie_bars[] = { PCIE_BAR0, PCIE_BAR1 , PCIE_BAR2 , PCIE_BAR3 , PCIE_BAR4 , PCIE_BAR5 };

void test32( PCIE_HANDLE hPCIe, DWORD addr );
void testDMA( PCIE_HANDLE hPCIe, DWORD addr);
void testMixed( PCIE_HANDLE hPCIe, DWORD addr );
void readImageData(char* filename, BYTE data[64]);
void writeToSDRAM(PCIE_HANDLE hPCIe, DWORD addr, BYTE data[64]);

int main(void)
{
  void *lib_handle;
  PCIE_HANDLE hPCIe;
  BYTE im [64];

  lib_handle = PCIE_Load();		// Dynamically Load the PCIE library
  if (!lib_handle)
    {
      printf("PCIE_Load failed\n");
      return 0;
    }
  hPCIe = PCIE_Open(0,0,0);		// Every device is a like a file in UNIX. Opens the PCIE device for reading/writing

  if (!hPCIe)
    {
      printf("PCIE_Open failed\n");
      return 0;
    }

  /*
  //test CRA
  printf("Testing the configuration registers for the Custom Slave Module\n");
  test32(hPCIe, CRA);			// Test the Configuration Registers for reads and writes
  printf("*******************************************************************************\n");
  //test SDRAM
  printf("************Testing the SDRAM for reads and writes through the DMA ************\n");
  testDMA(hPCIe,CRA);			// Test the SDRAM for reads and writes

  printf("************Testing the SDRAM for writes through the DMA and reads through the Custom Slave Module ************\n");
  testMixed(hPCIe, CRA);
  */

  printf("************Testing the SDRAM for writing image data************\n");
  readImageData("./images.data", im);
  writeToSDRAM(hPCIe, SDRAM, im);
  return 0;
}

//Tests 16 consecutive PCIE_Write32 to addresses mapping to the Custom Slave

void test32( PCIE_HANDLE hPCIe, DWORD addr )
{
  BOOL bPass;
  DWORD testVal = 0xf;
  DWORD readVal;

  WORD i = 0;
  for (i = 0; i < 16 ; i++ )
    {
      printf("Testing register %d at addr %x with value %x\n", i, addr, testVal);
      bPass = PCIE_Write32( hPCIe, pcie_bars[0], addr, testVal);
      if (!bPass)
        {
          printf("test FAILED: write did not return success");
          return;
        }
      bPass = PCIE_Read32( hPCIe, pcie_bars[0], addr, &readVal);
      if (!bPass)
        {
          printf("test FAILED: read did not return success");
          return;
        }
      if (testVal == readVal)
        {
          printf("Test PASSED: expected %x, received %x\n", testVal, readVal);
        }
      else
        {
          printf("Test FAILED: expected %x, received %x\n", testVal, readVal);
        }
      testVal = testVal + 1;
      addr = addr + 4;
    }
  return;
}

//tests DMA write of buffer to addresses in the SDRAM
//
void testDMA( PCIE_HANDLE hPCIe, DWORD addr)
{
  BOOL bPass;
  UCHAR testArray[MAXDMA]; // each entry 8bits (WORD)
  UCHAR readArray[MAXDMA];

  WORD i = 0;

  while ( i < MAXDMA )
    {
      testArray[i] = i;//  + 0x0f;
      i++;
    }

  bPass = PCIE_DmaWrite(hPCIe, addr, testArray, MAXDMA);// * RWSIZE );
  if (!bPass)
    {
      printf("test FAILED: write did not return success");
      return;
    }
  bPass = PCIE_DmaRead(hPCIe, addr, readArray, MAXDMA);// * RWSIZE );
  if (!bPass)
    {
      printf("test FAILED: read did not return success");
      return;
    }
  i = 0;
  while ( i < MAXDMA )
    {
      if (testArray[i] == readArray[i])
        {
          printf("Test PASSED: expected %x, received %x\n", testArray[i], readArray[i]);
        }
      else
        {
          printf("Test FAILED: expected %x, received %x\n", testArray[i], readArray[i]);
        }
      i++;
    }
	return;
}

void testMixed( PCIE_HANDLE hPCIe, DWORD addr ){
  BOOL bPass;
  BYTE testArray[MAXDMA]; // each entry 8bits (WORD)
  BYTE readVal;

  WORD i = 0;
  BYTE c = 0;

  while ( c < MAXDMA ) {
      testArray[i] = c;//  + 0x0f;
      i++;
      c++;
    }

  bPass = PCIE_DmaWrite(hPCIe, addr, testArray, MAXDMA);
  if (!bPass) {
      printf("test FAILED: write did not return success\n");
      return;
    }
  i = 0;
  while ( i < MAXDMA ) {
      bPass = PCIE_Read8( hPCIe, pcie_bars[0], addr, &readVal);
      if (!bPass) {
          printf("test FAILED: read did not return success\n");
          return;
        }
      if (testArray[i] == readVal) {
          printf("Test PASSED: expected %x, received %x\n", testArray[i], readVal);
        }
      else {
          printf("Test FAILED: expected %x, received %x\n", testArray[i], readVal);
        }
      addr = addr + 1;
      i = i + 1;
    }
  return;
}

void readImageData(char* filename, BYTE data[64]){
  FILE* fp;

  fp = fopen(filename, "r");
  if(!fp){
    printf("Could not open %s for reading\n", filename);
    return;
  }

  fread(data, sizeof(BYTE), 64, fp);

  return;
}

void writeToSDRAM(PCIE_HANDLE hPCIe, DWORD addr, BYTE data[64]){
  BOOL bPass;
  BYTE readArray[64];

  WORD i = 0;

  bPass = PCIE_DmaWrite(hPCIe, addr, data, 64);// * RWSIZE );
  if (!bPass)
    {
      printf("test FAILED: write did not return success");
      return;
    }
  bPass = PCIE_DmaRead(hPCIe, addr, readArray, 64);// * RWSIZE );
  if (!bPass)
    {
      printf("test FAILED: read did not return success");
      return;
    }
  i = 0;
  while ( i < 64 )
    {
      if (data[i] == readArray[i])
        {
          printf("Test PASSED: expected %x, received %x\n", data[i], readArray[i]);
        }
      else
        {
          printf("Test FAILED: expected %x, received %x\n", data[i], readArray[i]);
        }
      i++;
    }
	return;
}
