/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Compilation:

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/llvm-test.cpp \
        $(usr/x86_64-w64-mingw32.static/bin/llvm-config.exe --cxxflags --libs core support irreader --system-libs) \
        -o usr/x86_64-w64-mingw32.static/bin/test-llvm.exe
*/

#include <iostream>

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"

int main() {
    llvm::LLVMContext Context;

    llvm::Module M("test_module", Context);
    llvm::IRBuilder<> Builder(Context);

    std::cout << "LLVM Context + Module created successfully\n";
    std::cout << "Module name: " << M.getName().str() << "\n";

    return 0;
}
