////////////////////////////////////////////////////////////
/// \file
///
/// \brief Project config file
///  
/// This file containes the project version and shared library macros  
///
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
//
// bool8_t library
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it freely,
// subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented;
//    you must not claim that you wrote the original software.
//    If you use this software in a product, an acknowledgment
//    in the product documentation would be appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such,
//    and must not be misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source distribution.
//
////////////////////////////////////////////////////////////

#ifndef bool8_t_CONFIG_HPP
#define bool8_t_CONFIG_HPP

#define bool8_t_VERSION_MAJOR 1
#define bool8_t_VERSION_MINOR 0
#define bool8_t_VERSION_PATCH 0

// if the library is shared
#if !defined(bool8_t_STATIC)

    #if defined(_WIN32) // Windows

        // Windows export flag
        #if defined(bool8_t_EXPORTS)
            #define bool8_t_API __declspec(dllexport)    
        #else
            #define bool8_t_API __declspec(dllimport)
        #endif

    #else // Linux, FreeBSD, Mac OS X

        // GCC 4 has special keywords for showing/hidding symbols,
        // the same keyword is used for both importing and exporting
        #if (__GNUC__ >= 4)
            #define bool8_t_API __attribute__ ((__visibility__ ("default")))
        #else
            #define bool8_t_API
        #endif

    #endif

#else

    // static build doesn't need import/export macros
    #define bool8_t_API 

#endif


#endif // bool8_t_CONFIG_HPP
