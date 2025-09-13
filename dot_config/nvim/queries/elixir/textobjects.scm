; extends

; attr definitions
(call
  target: (identifier) @_attr_name
  (arguments
    (atom) @_start
    (_)* @_end)
  (#eq? @_attr_name "attr")
  (#make-range! "attr.inner" @_start @_end)) @attr.outer

; Individual attr call
(call
  target: (identifier) @_attr_name
  (#eq? @_attr_name "attr")) @attr.outer

; HEEx sigils (both ~H and ~L)
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @heex.inner
  (#any-of? @_sigil_name "H" "L")) @heex.outer

; Function definitions with HEEx
(call
  target: (identifier) @_defp
  (arguments)
  (do_block
    (sigil
      (sigil_name) @_sigil_name
      (quoted_content) @function_heex.inner
      (#any-of? @_sigil_name "H" "L")) @function_heex.outer)
  (#any-of? @_defp "defp" "def")) @function_with_heex.outer

