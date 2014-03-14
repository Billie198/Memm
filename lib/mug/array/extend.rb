
class Array

	##
	# Extend this Array.
	#
	# In the first form, when a +size+ and an optional +obj+ are sent,
	# the array is extended with +size+ copies of +obj+. Take notice that
	# all elements will reference the same object +obj+.
	#
	# The second form appends a copy of the array passed as a parameter
	# (the array is generated by calling #to_ary on the parameter).
	# @see #concat
	# @see #+
	#
	# In the last form, the array is extended by the given size. Each new
	# element in the array is created by passing the element's index to the
	# given block and storing the return value.
	#
	# @call-seq extend!(size=0, obj=nil)
	# @call-seq extend!(array)
	# @call-seq extend!(size) {|index| block }
	#
	def extend! size, *rest
		raise ArgumentError, "wrong number of arguments (#{rest.length+1} for 1..2)" if rest.length > 1

		# Same logic as array.c/rb_ary_initialize
		if rest.empty? && !size.is_a?(Fixnum)
			warn 'warning: given block not used' if block_given?
			concat size.to_ary
			return self
		end

		raise ArgumentError, 'negative size' if size < 0

		a = length
		b = a+size
		if block_given?
			warn 'warning: block supersedes default value argument' if !rest.empty?
			fill(a...b) {|i| yield i }
		else
			obj = rest[0]
			fill(a...b) { obj }
		end
	end

	# @see #extend!
	def extend *args, &block
		dup.extend! *args, &block
	end

end

=begin
Copyright (c) 2014, Matthew Kerwin <matthew@kerwin.net.au>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
=end

