#lang scribble/manual
@require[phc-toolkit/scribblings/utils
         @for-label[xlist
                    typed/racket/base]]

@title{Splitting an xlist in its constituent sublists}
@(declare-exporting xlist)

@defform*[#:kind "match-expander"
          #:literals (^ * + - ∞)
          [(split-xlist pat τᵢ ...)
           (split-xlist pat τᵢ ... . rest)
           (split-xlist pat τᵢ ... #:rest rest)]
          #:grammar
          [(τᵢ type
               repeated-type)
           (repeated-type (code:line type ^ repeat)
                          (code:line type ^ {repeat})
                          (code:line type {repeat})
                          (code:line type superscripted-repeat)
                          (code:line type *)
                          (code:line type +)
                          (code:line superscripted-id))
           (repeat (code:line once)
                   (code:line nat)
                   (code:line nat +)
                   (code:line +)
                   (code:line nat - nat)
                   (code:line nat - ∞)
                   (code:line nat -)
                   (code:line - nat)
                   (code:line -)
                   (code:line - ∞)
                   (code:line *))]
          #:contracts
          [(nat (syntax/c exact-nonnegative-integer?))]]{
                                                           
 This match patterns splits an xlist into a list of lists, and matches the
 result against @racket[pat]. Each repeated element of the xlist is extracted
 into one of these sublists. The type for each sublist is determined base on
 the element's type and its @racket[_repeat]:
 @itemlist[
 @item{If the @racket[_repeat] for that element is @racket[once], then the
   element is inserted directly, without nesting it within a sublist. In
   contrast, it the @racket[_repeat] were @racket[1], the element would be
   inserted in a sublist of length one.}
 @item{If the @racket[_repeat] for that element is @racket[*] or an
   equivalent, the type of the sublist will be @racket[(Listof type)]}
 @item{If the @racket[_repeat] for that element is @racket[_n +] or an
   equivalent, the type of the sublist will be @racket[(xList type ^ _n +)]}
 @item{If the @racket[_repeat] for that element is @racket[_n] or an
   equivalent, the type of the sublist will be @racket[(xList type ^ _n)]}
 @item{If the @racket[_repeat] for that element is @racket[_from - _to] or an
   equivalent, the type of the sublist will be
   @racket[(xList type ^ _from - _to)]}]}
