//
//  LAppAllocator.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LAppAllocator.h"
#import <Foundation/Foundation.h>

using namespace Csm;

void* LAppAllocator::Allocate(const csmSizeType  size)
{
    return malloc(size);
}

void LAppAllocator::Deallocate(void* memory)
{
    free(memory);
}

void* LAppAllocator::AllocateAligned(const csmSizeType size, const csmUint32 alignment)
{
    size_t offset, shift, alignedAddress;
    void* allocation;
    void** preamble;

    offset = alignment - 1 + sizeof(void*);

    allocation = Allocate(size + static_cast<csmUint32>(offset));

    alignedAddress = reinterpret_cast<size_t>(allocation) + sizeof(void*);

    shift = alignedAddress % alignment;

    if (shift)
    {
        alignedAddress += (alignment - shift);
    }

    preamble = reinterpret_cast<void**>(alignedAddress);
    preamble[-1] = allocation;

    return reinterpret_cast<void*>(alignedAddress);
}

void LAppAllocator::DeallocateAligned(void* alignedMemory)
{
    void** preamble;

    preamble = static_cast<void**>(alignedMemory);

    Deallocate(preamble[-1]);
}

