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

#ifndef bool8_t_HPP
#define bool8_t_HPP

////////////////////////////////////////////////////////////
// Headers
////////////////////////////////////////////////////////////
#include "bool8_t/Config.hpp"

#if !defined(ARDUINO) 
    #include <cstdint>
#else
    #include "stdint.h"
#endif


////////////////////////////////////////////////////////////
/// \brief Efficient memory usage of the boolean type
///
////////////////////////////////////////////////////////////
class bool8_t_API bool8_t
{
public:

	////////////////////////////////////////////////////////////
	/// \brief Utility class for accessing boolean flags using indexing operator
	///
	////////////////////////////////////////////////////////////
    class bool8_t_API adapter
	{
	public:

		////////////////////////////////////////////////////////////
		/// \brief Main constructor
		///
		/// This constructor creates a boolian flag adaptor
		/// 
		/// \param index    Index of the flag
		/// \param instance Pointer to the bool8_t class
		///
		////////////////////////////////////////////////////////////
		adapter(uint8_t index, bool8_t* instance);

		////////////////////////////////////////////////////////////
		/// \brief Overload of assignment operator
		/// 
		/// \param right Boolean value assign to the flag
		/// 
		/// \return Reference to self
		///
		////////////////////////////////////////////////////////////
		adapter& operator =(bool right);

		////////////////////////////////////////////////////////////
		/// \brief Implicit conversion operator to bool
		///
		/// \return Flag converted to the boolean value
		///
		////////////////////////////////////////////////////////////
		operator bool() const;

	private:

		////////////////////////////////////////////////////////////
		// Member data
		////////////////////////////////////////////////////////////
		bool8_t* m_instance; ///< Pointer to the bool8_t class
		uint8_t m_index;     ///< Index of the boolean flag
	};


	////////////////////////////////////////////////////////////
	/// \brief Main constructor
	///
	/// This constructor creates an instance contained 8 boolean flags.
	/// 
	/// All flags is false by default.
	/// 
	/// \param val Combined logic value of the all flags
	///
	////////////////////////////////////////////////////////////
	bool8_t(bool val = false);

	////////////////////////////////////////////////////////////
	/// \brief Overload of assignment operator
	/// 
	/// \param right Instance to assign
	/// 
	/// \return Reference to self
	///
	////////////////////////////////////////////////////////////
	bool8_t& operator =(const bool8_t& right);

	////////////////////////////////////////////////////////////
	/// \brief Overload of indexing operator to access a boolean flag by its position
	///
	/// This function provides read-only access.
	///
	/// \param index Index of the flag to get
	///
	/// \return Flag at the position \a index
	///
	////////////////////////////////////////////////////////////
    bool8_t::adapter operator [](uint8_t index) const;

	////////////////////////////////////////////////////////////
	/// \brief Overload of indexing operator to access a boolean flag by its position
	///
	/// This function provides read-write access.
	///
	/// \param index Index of the flag to get
	///
	/// \return Flag at the position \a index
	///
	////////////////////////////////////////////////////////////
	bool8_t::adapter operator [](uint8_t index);

	////////////////////////////////////////////////////////////
	/// \brief Implicit conversion operator to bool
	///
	/// \return Combined logic value of the all flags
	///
	////////////////////////////////////////////////////////////
	operator bool();

	////////////////////////////////////////////////////////////
	/// \brief Overload of logical negation operator to get the instance contained inversed flags
	///
	/// All flags with the value false change the value to true and vice versa
	/// 
	/// \return Inversed instance
	///
	////////////////////////////////////////////////////////////
	bool8_t operator !();

	////////////////////////////////////////////////////////////
	/// \brief Inverse all flags
	/// 
	/// All flags with the value false change the value to true and vice versa
	///
	////////////////////////////////////////////////////////////
	void inverse();

	////////////////////////////////////////////////////////////
	/// \brief Get count of the boolean flags : 8
	///
	/// \return Count of the flags
	///
	////////////////////////////////////////////////////////////
	constexpr int flagCount() const { return 8; }

	////////////////////////////////////////////////////////////
	/// \brief Overload of equality operator to compare two instances
	///
	/// \param left  Left operand
	/// \param right Right operand
	///
	/// \return True if all flags are equal, false otherwise
	///
	////////////////////////////////////////////////////////////
	friend bool8_t_API bool operator ==(const bool8_t& left, const bool8_t& right);

	////////////////////////////////////////////////////////////
	/// \brief Overload of inequality operator to compare two instances
	///
	/// \param left  Left operand
	/// \param right Right operand
	///
	/// \return False if all flags are equal, True otherwise
	///
	////////////////////////////////////////////////////////////
	friend bool8_t_API bool operator !=(const bool8_t& left, const bool8_t& right);

	////////////////////////////////////////////////////////////
	// Bit field flags
	////////////////////////////////////////////////////////////
	uint8_t flag0 : 1; ///< Boolean flag 0
	uint8_t flag1 : 1; ///< Boolean flag 1
	uint8_t flag2 : 1; ///< Boolean flag 2
	uint8_t flag3 : 1; ///< Boolean flag 3
	uint8_t flag4 : 1; ///< Boolean flag 4
	uint8_t flag5 : 1; ///< Boolean flag 5 
	uint8_t flag6 : 1; ///< Boolean flag 6
	uint8_t flag7 : 1; ///< Boolean flag 7
};

#endif // !bool8_t_API


////////////////////////////////////////////////////////////
/// \class bool8_t
///
/// bool8_t - simple library for the efficient memory usage 
/// of the boolean type. It can be used as a standart bool type 
/// or as an 8 bool flags with a total size 1 byte.
///
////////////////////////////////////////////////////////////
