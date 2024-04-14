////////////////////////////////////////////////////////////
// bool8_t is a simple library for the efficient memory usage of the boolean type
// Copyright (c) 2024 Alex Filatov (alexfilatov.dev@gmail.com)
//
// This software is provided 'as-is', without any express or implied
// warranty. In no event will the authors be held liable for any damages
// arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it
// freely, subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented; you must not
// claim that you wrote the original software. If you use this software
// in a product, an acknowledgment in the product documentation would be
// appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such, and must not be
// misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source
// distribution.
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Headers
////////////////////////////////////////////////////////////
#include "bool8_t/bool8_t.hpp"

bool8_t::adapter::adapter(uint8_t index, bool8_t* instance) : m_index(index), m_instance(instance)
{
}

bool8_t::adapter& bool8_t::adapter::operator=(bool right)
{
    uint8_t flag = static_cast<uint8_t>(right);

    switch (m_index)
    {
        case 0:
            m_instance->flag0 = flag;
            break;
        case 1:
            m_instance->flag1 = flag;
            break;
        case 2:
            m_instance->flag2 = flag;
            break;
        case 3:
            m_instance->flag3 = flag;
            break;
        case 4:
            m_instance->flag4 = flag;
            break;
        case 5:
            m_instance->flag5 = flag;
            break;
        case 6:
            m_instance->flag6 = flag;
            break;
        case 7:
            m_instance->flag7 = flag;
            break;
    }

    return *this;
}

bool8_t::adapter::operator bool() const
{
    switch (m_index)
    {
        case 0:
            return static_cast<bool>(m_instance->flag0);
        case 1:
            return static_cast<bool>(m_instance->flag1);
        case 2:
            return static_cast<bool>(m_instance->flag2);
        case 3:
            return static_cast<bool>(m_instance->flag3);
        case 4:
            return static_cast<bool>(m_instance->flag4);
        case 5:
            return static_cast<bool>(m_instance->flag5);
        case 6:
            return static_cast<bool>(m_instance->flag6);
        case 7:
            return static_cast<bool>(m_instance->flag7);
        default:
            return false;
    }
}

////////////////////////////////////////////////////////////
bool8_t::bool8_t(bool val)
{
    flag0 = flag1 = flag2 = flag3 = flag4 = flag5 = flag6 = flag7 = static_cast<uint8_t>(val);
}

////////////////////////////////////////////////////////////
bool8_t& bool8_t::operator=(const bool8_t& right)
{
    flag0 = right.flag0;
    flag1 = right.flag1;
    flag2 = right.flag2;
    flag3 = right.flag3;
    flag4 = right.flag4;
    flag5 = right.flag5;
    flag6 = right.flag6;
    flag7 = right.flag7;

    return *this;
}

////////////////////////////////////////////////////////////
bool8_t::adapter bool8_t::operator[](uint8_t index) const
{
    return bool8_t::adapter(index, const_cast<bool8_t*>(this));
}

////////////////////////////////////////////////////////////
bool8_t::adapter bool8_t::operator[](uint8_t index)
{
    return bool8_t::adapter(index, this);
}

////////////////////////////////////////////////////////////
bool8_t::operator bool()
{
    return (flag0 && flag1 && flag2 && flag3 && flag4 && flag5 && flag6 && flag7);
}

////////////////////////////////////////////////////////////
bool8_t bool8_t::operator!()
{
    bool8_t newInstance = *this;
    newInstance.inverse();

    return newInstance;
}

////////////////////////////////////////////////////////////
void bool8_t::inverse()
{
    flag0 = !flag0;
    flag1 = !flag1;
    flag2 = !flag2;
    flag3 = !flag3;
    flag4 = !flag4;
    flag5 = !flag5;
    flag6 = !flag6;
    flag7 = !flag7;
}

////////////////////////////////////////////////////////////
bool8_t_API bool operator==(const bool8_t& left, const bool8_t& right)
{
    return (left.flag0 == right.flag0) && (left.flag1 == right.flag1) && (left.flag2 == right.flag2) &&
           (left.flag3 == right.flag3) && (left.flag4 == right.flag4) && (left.flag5 == right.flag5) &&
           (left.flag6 == right.flag6) && (left.flag7 == right.flag7);
}

////////////////////////////////////////////////////////////
bool8_t_API bool operator!=(const bool8_t& left, const bool8_t& right)
{
    return !operator==(left, right);
}
