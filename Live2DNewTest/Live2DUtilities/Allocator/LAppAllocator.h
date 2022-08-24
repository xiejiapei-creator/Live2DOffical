//
//  LAppAllocator.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LAppAllocator_h
#define LAppAllocator_h

#import "CubismFramework.hpp"
#import "ICubismAllocator.hpp"

/**
 * @brief 实现存储器位置的类
 *
 * 存储器确保释放处理的接口的实现
 * 从框架中被调用
 *
 */
class LAppAllocator : public Csm::ICubismAllocator
{
    /**
     * @brief  分配存储器区域
     *
     * @param[in]   size    想分配的尺寸
     * @return  指定的存储器区域
     */
    void* Allocate(const Csm::csmSizeType size);

    /**
     * @brief   释放存储器区域
     *
     * @param[in]   memory    释放内存
     */
    void Deallocate(void* memory);

    /**
     * @brief 重新分配内存区域
     *
     * @param[in]   size         想分配的尺寸
     * @param[in]   alignment    想分配的大小
     * @return  alignedAddress
     */
    void* AllocateAligned(const Csm::csmSizeType size, const Csm::csmUint32 alignment);

    /**
     * @brief 释放存储器区域
     *
     * @param[in]   alignedMemory    释放内存
     */
    void DeallocateAligned(void* alignedMemory);
};

#endif /* LAppAllocator_h */
