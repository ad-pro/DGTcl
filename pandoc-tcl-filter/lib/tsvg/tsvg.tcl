#!/usr/bin/env tclsh
##############################################################################
#  Created By    : Dr. Detlef Groth
#  Created       : Sat Aug 28 09:52:16 2021
#  Last Modified : <210828.2122>
#
#  Description	 : Minimal tcl package to write SVG code and write it to 
#                  a file.
#
#  Notes         : TODO - start and end flags to open and close a tag
#                       - text if tk is loaded
#
#  History       : 
#                - 2021-08-28 - Version 0.1
#	
##############################################################################
#
#  Copyright (c) 2021 Dr. Detlef Groth.
# 
#  License: MIT 
# 
##############################################################################


#' NAME 
#' 
#' _tsvg_ - package to create svg files with a syntax close to Tcl and to SVG.
#' 
#' ## SYNOPSIS
#' 
#' ```
#' package require tsvg
#' tsvg set width 100
#' tsvg set height 100
#' # Tcl like syntax
#' tsvg circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill salmon
#' tsvg text x 29 y 45 Hello
#' tsvg text x 27 y 65 World!
#' tsvg write hello-world.svg
#' tsvg set code ""
#' # SVG like syntax
#' tsvg circle cx="50" cy="50" r="45" stroke="black" \
#'    stroke-width="2" fill="light blue"
#' tsvg text x="29" y="45" Hello
#' tsvg text x="27" y="65" World!
#' ```
#' 
#' ## METHODS
#' 
#' The package provides one command _tsvg_ which can hold currently just a single 
#' svg code. All commands will be evaluated within the tsvg namespace, all unknown 
#' methods which are all will be forwarded to the standard tsvg::tag method and produce 
#' svg code out of them. So _tsvg dummy hello_ will produce _&gt;dummy&lt>hello&lt/&gt;_.
#' 
#' The following public variables can be modified sing _tsvg set varname_:
#' 
#' > - _code_ - the variable collecting the svg code, usually you will only set this variable by hand to remove all existing svg code after doing an image by calling _tsvg set ""_.
#'   - _footer_ - the standard SVG-XML footer, should be usually not changed.
#'   - _header_ - the standard SVG-XML header, should be usually not changed.
#'   - _height_ - the image height used for writing out the svg file, default: 100
#'   - _width_ - the image width used for writing out the svg file, default: 100
#' 
#' The follwing methods are implemented:
#' 
#' __tsvg demo__ 
#' 
#' > Writes the "Hello World!" string into a file hello-world.svg in the current directory.
#'
#' __tsvg figure__ _filename_ _width_ _height_
#' 
#' > Writes the current svg code into the given filename with the 
#'   given width and height settings. 
#' 
#' __tsvg write__ _filename_
#' 
#' > writes the current svg code into the given filename with the current width and height settings.
#' 
#' __tsvg tag__ tagname _args_
#' 
#' > Creates the given tagname and adds all remaining arguments as attibutes if they come 
#'   in pairs. If the numer of arguments is odd, the last argument will be placed within 
#'   the XML tags.
#'
#' The following functions are just implemented for avoiding name clashes because some existing Tcl/Tk 
#' functions have the same name. They should be not used directly.
#' 
#' > - _tsvg text_
#' 
#' The following function(s) are private and should not be used directly by the user of
#' this package.
#' 
#' > - _tsvg TagFix_
#' 
#' ## EXAMPLES
#' 
#' The typical Hello World example:
#'
#' ```{.tsvg}
#' tsvg circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill salmon
#' tsvg text x 29 y 45 Hello
#' tsvg text x 27 y 65 World!
#' tsvg write hello-world.svg
#' ```
#' 
#' ![](hello-world.svg)
#' 
#' To continue with an other image you have first to clean up the previous image:
#' 
#' ```{.tsvg}
#' tsvg set code "" ;# clear 
#' tsvg set width 200 ;# new size as on the webpage
#' tsvg set height 250 
#' tsvg rect x="10" y="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
#' tsvg rect x="60" y="10" rx="10" ry="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
#' tsvg circle cx="25" cy="75" r="20" stroke="red" fill="transparent" stroke-width="5"
#' tsvg ellipse cx="75" cy="75" rx="20" ry="5" stroke="red" fill="transparent" stroke-width="5"
#' tsvg line x1="10" x2="50" y1="110" y2="150" stroke="orange" stroke-width="5"
#' tsvg polyline points="60 110 65 120 70 115 75 130 80 125 85 140 90 135 95 150 100 145" \
#'     stroke="orange" fill="transparent" stroke-width="5"
#' tsvg polygon points="50 160 55 180 70 180 60 190 65 205 50 195 35 205 40 190 30 180 45 180" \
#'     stroke="green" fill="transparent" stroke-width="5"
#' tsvg path d="M20,230 Q40,205 50,230 T90,230" fill="none" stroke="blue" stroke-width="5"
#' tsvg write basic-shapes.svg
#' ```
#' 
#' ![](basic-shapes.svg)
#' 
#' ## Extending
#' 
#' If you need to extend the package or to fix nameclashes with other packages you can 
#' just write your own procedures. For instance if one package you are working with would
#' import an _rect_ command you would call this using the _tsvg rect_ command to fix this issue you just have to  implement your own _tsvg rect_ procedure like this:
#' 
#' ```
#' tsvg proc rect {args} {
#'     set self [self]
#'     $self tag rect {*}$args
#' }
#' ```
#' 
#' ## Documentation
#' 
#' The documentation for this HTML file was created using the pandoc-tcl-filter and the filter for the tsg package as follows:
#'
#' ```
#'  perl -ne "s/^#' ?(.*)/\$$1/ and print " lib/tsvg/tsvg.tcl > tsvg.md
#'  pandoc tsvg.md -s  \
#'     --metadata title="tsvg package documentation"  \
#'     -o tsvg.html  --filter pandoc-tcl-filter.tcl \
#'     --css mini.css
#'  htmlark -o lib/tsvg/tsvg.html tsvg.html
#' ```
#' 
#' ## ChangeLog
#' 
#' * 2021-08-28 Version 0.1 with docu uplpaded to GitHub
#'     
#' ## SEE ALSO
#' 
#' * [Readme.html](../../Readme.html) - more information about pandoc Tcl filters
#' * [Tclers Wiki page](https://wiki.tcl-lang.org/page/tsvg) - place for discussion
#' 
#' ## AUTHOR
#' 
#' Dr. Detlef Groth, Caputh-Schwielowsee, Germany, detlef(_at_)dgroth(_dot_).de
#' 
#' ## License
#' 
#' ```
#' MIT License
#' 
#' Copyright (c) 2021 Dr. Detlef Groth, Caputh-Schwielowsee, Germany
#' 
#' Permission is hereby granted, free of charge, to any person obtaining a copy
#' of this software and associated documentation files (the "Software"), to deal
#' in the Software without restriction, including without limitation the rights
#' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#' copies of the Software, and to permit persons to whom the Software is
#' furnished to do so, subject to the following conditions:
#' 
#' The above copyright notice and this permission notice shall be included in all
#' copies or substantial portions of the Software.
#' 
#' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#' SOFTWARE.
#' ```
#' 


package provide tsvg 0.1

# minimal OOP
proc thingy name {
    proc $name args "namespace eval $name \$args"
} 

# does not work
interp alias {} self {} namespace current 

;# our object
thingy tsvg

;# some variables
tsvg set code "" ;# the svg code
tsvg set header {<?xml version="1.0" encoding="utf-8" standalone="yes"?>
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" height="__HEIGHT__" width="__WIDTH__">}    
tsvg set footer {</svg>}
tsvg set width 100
tsvg set height 100

tsvg proc tag {args} {
    set self [self]
    variable code
    set args [$self TagFix $args]
    set tag [lindex $args 0]
    set args [lrange $args 1 end]
    set ret "\n<$tag"
    set val ""
    # new check if attr="val" syntax  
    if {[regexp {=} [lindex $args 0]]} {
        set nargs [list]
        foreach kval $args {
            set idx [string first = $kval]
            set key [string range $kval 0 $idx-1]
            set val [string range $kval $idx+2 end-1]
            lappend nargs $key
            lappend nargs $val
        }
        set args $nargs
    } 
    # end of new check
    foreach {key val} $args {
       if {$val eq ""} {
           append ret ">\n$key\n</$tag>\n"
           break
       } else {
           append ret " $key=\"$val\""
       }
    }
    if {$val ne ""} {
        append ret " />\n"
    }
    append code $ret
}

tsvg proc TagFix {args} { 
    set nargs [list]
    set args {*}$args
    set flag false
    for {set i 0} {$i < [llength $args]} {incr i 1} {
        if {!$flag && [regexp {=".+"} [lindex $args $i]]} { ;#"
            lappend nargs [lindex $args $i]
        } elseif {!$flag && [regexp {="} [lindex $args $i]]} { ;#"
            set flag true
            set qarg "[lindex $args $i] "
        } elseif {$flag && [regexp {"} [lindex $args $i]]} { ;#"
            set flag false
            append qarg "[lindex $args $i]"
            lappend nargs $qarg
        } elseif {$flag} {
            append qarg " [lindex $args $i]"
        } else {
            lappend nargs [lindex $args $i]
        }
    }
    return $nargs
}

namespace eval tsvg {
    namespace unknown tsvg::tag
}

tsvg proc text {args} {
    set self [self]
    $self tag text {*}$args
}
tsvg proc write {filename} {
    variable width
    variable height
    variable header
    variable footer
    variable code
    set out [open $filename w 0600]
    set head [regsub {__HEIGHT__} $header $height]
    set head [regsub {__WIDTH__} $head $width]
    puts $out $head
    puts $out $code
    puts $out $footer
    close $out
}

tsvg proc figure {filename width height args} {
    set self [self]
    $self set width $width
    $self set height $height
    $self write $filename.svg
    return $filename.svg
}

tsvg proc demo {} {
    set self [self]
    $self circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill salmon
    $self text x 29 y 45 Hello
    $self text x 27 y 65 World!
    #$self figure 
    $self write hello-world.svg
    puts "Writing file hello-world.svg done!"
    $self set code ""
    $self set width 200 
    $self set height 250 
    $self rect x="10" y="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
    $self rect x="60" y="10" rx="10" ry="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
    $self circle cx="25" cy="75" r="20" stroke="red" fill="transparent" stroke-width="5"
    $self ellipse cx="75" cy="75" rx="20" ry="5" stroke="red" fill="transparent" stroke-width="5"
    $self line x1="10" x2="50" y1="110" y2="150" stroke="orange" stroke-width="5"
    $self polyline points="60 110 65 120 70 115 75 130 80 125 85 140 90 135 95 150 100 145" \
           stroke="orange" fill="transparent" stroke-width="5"
    $self polygon points="50 160 55 180 70 180 60 190 65 205 50 195 35 205 40 190 30 180 45 180" \
          stroke="green" fill="transparent" stroke-width="5"
    $self path d="M20,230 Q40,205 50,230 T90,230" fill="none" stroke="blue" stroke-width="5"
    $self write basic-shapes.svg
    puts "Writing file basic-shapes.svg done!"
}

                   
if {[info exists argv0] && $argv0 eq [info script] && [regexp tsvg.tcl $argv0]} {
    #package require Tk
    tsvg demo
}

