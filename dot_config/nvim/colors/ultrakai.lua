-- this is my personal colorscheme based on monokai called 'ultrakai'

local colors = {
  bg = "#272822",
  fg = "#E8E8E3",
  yellow = "#E6DB74",
  cyan = "#66d9ef",
  green = "#A6E22D",
  orange = "#FD9720",
  purple = "#ae81ff",
  magenta = "#F92772",
  blue = "#66d9ef",
  red = "#e73c50",
  grey = "#75715E",

  -- Additional colors from vim version
  white = "#E8E8E3",
  white2 = "#d8d8d3",
  black = "#272822",
  lightblack = "#2D2E27",
  lightblack2 = "#383a3e",
  lightblack3 = "#3f4145",
  darkblack = "#211F1C",
  br_grey = "#a1a29c",
  lightgrey = "#575b61",
  darkgrey = "#64645e",
  warmgrey = "#75715E",
  pink = "#F92772",
  aqua = "#66d9ef",
  purered = "#ff0000",
  darkred = "#5f0000",

  -- Diff colors
  addfg = "#d7ffaf",
  addbg = "#5f875f",
  delfg = "#ff8b8b",
  delbg = "#f75f5f",
  changefg = "#d7d7ff",
  changebg = "#5f5f87",

  -- Bright colors
  br_green = "#9EC400",
  br_yellow = "#E7C547",
  br_blue = "#7AA6DA",
  br_purple = "#B77EE0",
  br_cyan = "#54CED6",
  br_white = "#FFFFFF",
}

local highlights = {
  -- Editor
  Normal = { fg = colors.white, bg = colors.black },
  ColorColumn = { bg = colors.lightblack },
  Conceal = { fg = colors.grey },
  Cursor = { fg = colors.black, bg = colors.white },
  CursorColumn = { bg = colors.lightblack2 },
  CursorLine = { bg = colors.lightblack2 },
  NonText = { fg = colors.lightgrey },
  Visual = { bg = colors.lightgrey },
  Search = { fg = colors.black, bg = colors.yellow },
  MatchParen = { fg = colors.purple, bold = true },
  Question = { fg = colors.yellow },
  ModeMsg = { fg = colors.yellow },
  MoreMsg = { fg = colors.yellow },
  ErrorMsg = { fg = colors.black, bg = colors.red, standout = true },
  WarningMsg = { fg = colors.red },
  VertSplit = { fg = colors.darkgrey, bg = colors.darkblack },
  WinSeparator = { fg = colors.darkgrey, bg = colors.darkblack },

  -- Line numbers
  LineNr = { fg = colors.grey, bg = colors.lightblack },
  CursorLineNr = { fg = colors.orange, bg = colors.lightblack },
  SignColumn = { bg = colors.lightblack },

  -- Statusline
  StatusLine = { fg = colors.black, bg = colors.lightgrey },
  StatusLineNC = { fg = colors.lightgrey, bg = colors.darkblack },
  TabLine = { fg = colors.lightgrey, bg = colors.lightblack },
  TabLineSel = { fg = colors.darkblack, bg = colors.warmgrey, bold = true },
  TabLineFill = { bg = colors.lightblack },

  -- Spell
  SpellBad = { fg = colors.red, undercurl = true },
  SpellCap = { fg = colors.purple, underline = true },
  SpellRare = { fg = colors.aqua, underline = true },
  SpellLocal = { fg = colors.pink, underline = true },

  -- Misc
  SpecialKey = { fg = colors.pink },
  Title = { fg = colors.yellow },
  Directory = { fg = colors.aqua },

  -- Diff
  DiffAdd = { fg = colors.addfg, bg = colors.addbg },
  DiffDelete = { fg = colors.delfg, bg = colors.delbg },
  DiffChange = { fg = colors.changefg, bg = colors.changebg },
  DiffText = { fg = colors.black, bg = colors.aqua },

  -- Folding
  Folded = { fg = colors.warmgrey, bg = colors.darkblack },
  FoldColumn = { bg = colors.darkblack },

  -- Popup menu
  Pmenu = { fg = colors.white2, bg = colors.darkblack },
  PmenuSel = { fg = colors.aqua, bg = colors.darkblack, reverse = true, bold = true },
  PmenuThumb = { fg = colors.lightblack, bg = colors.grey },

  -- Floating
  NormalFloat = { fg = colors.white2, bg = colors.darkblack },

  -- Terminal
  TermCursor = { fg = colors.black, bg = colors.white },
  TermCursorNC = { fg = colors.black, bg = colors.white },
  EndOfBuffer = { fg = colors.black },

  -- Generic Syntax Highlighting (matching vim exactly)
  Constant = { fg = colors.purple },
  Number = { fg = colors.purple },
  Float = { fg = colors.purple },
  Boolean = { fg = colors.purple },
  Character = { fg = colors.yellow },
  String = { fg = colors.yellow },

  Type = { fg = colors.aqua },
  Structure = { fg = colors.aqua },
  StorageClass = { fg = colors.aqua },
  Typedef = { fg = colors.aqua },

  Identifier = { fg = colors.green },
  Function = { fg = colors.green },

  Statement = { fg = colors.pink },
  Operator = { fg = colors.pink },
  Label = { fg = colors.pink },
  Keyword = { fg = colors.pink },
  Conditional = { fg = colors.pink },
  Repeat = { fg = colors.pink },
  Exception = { fg = colors.pink },

  PreProc = { fg = colors.green },
  Include = { fg = colors.pink },
  Define = { fg = colors.pink },
  Macro = { fg = colors.green },
  PreCondit = { fg = colors.green },

  Special = { fg = colors.purple },
  SpecialChar = { fg = colors.pink },
  Delimiter = { fg = colors.pink },
  SpecialComment = { fg = colors.aqua },
  Tag = { fg = colors.pink },
  Debug = { fg = colors.red },

  Todo = { fg = colors.orange, bold = true, italic = true },
  Comment = { fg = colors.warmgrey, italic = true },

  Underlined = { fg = colors.green },
  Ignore = {},
  Error = { fg = colors.purered, bg = colors.lightblack3 },

  -- TreeSitter (matching vim decisions)
  ["@variable"] = { fg = colors.white },
  ["@variable.builtin"] = { fg = colors.purple },
  ["@variable.parameter"] = { fg = colors.orange },
  ["@variable.parameter.builtin"] = { fg = colors.orange },
  ["@variable.member"] = { fg = colors.white },

  ["@constant"] = { fg = colors.orange },
  ["@constant.builtin"] = { fg = colors.aqua },
  ["@constant.macro"] = { fg = colors.green },

  ["@module"] = { fg = colors.aqua },
  ["@label"] = { fg = colors.pink },

  ["@string"] = { fg = colors.yellow },
  ["@string.regexp"] = { fg = colors.yellow },
  ["@string.escape"] = { fg = colors.purple },
  ["@string.special"] = { fg = colors.pink },

  ["@character"] = { fg = colors.yellow },
  ["@character.special"] = { fg = colors.purple },

  ["@number"] = { fg = colors.purple },
  ["@boolean"] = { fg = colors.purple },
  ["@float"] = { fg = colors.purple },

  ["@function"] = { fg = colors.white },
  ["@function.builtin"] = { fg = colors.aqua },
  ["@function.call"] = { fg = colors.green },
  ["@function.macro"] = { fg = colors.green },

  ["@method"] = { fg = colors.green },
  ["@method.call"] = { fg = colors.green },

  ["@constructor"] = { fg = colors.aqua, italic = true },
  ["@parameter"] = { fg = colors.orange },

  ["@keyword"] = { fg = colors.pink },
  ["@keyword.function"] = { fg = colors.pink },
  ["@keyword.operator"] = { fg = colors.pink },
  ["@keyword.return"] = { fg = colors.pink },
  ["@keyword.import"] = { fg = colors.pink },

  ["@conditional"] = { fg = colors.pink },
  ["@repeat"] = { fg = colors.pink },
  ["@debug"] = { fg = colors.red },
  ["@exception"] = { fg = colors.pink },

  ["@type"] = { fg = colors.aqua, italic = true },
  ["@type.builtin"] = { fg = colors.aqua },
  ["@type.qualifier"] = { fg = colors.pink },
  ["@type.definition"] = { fg = colors.aqua },

  ["@storageclass"] = { fg = colors.aqua },
  ["@attribute"] = { fg = colors.purple },
  ["@attribute.builtin"] = { fg = colors.purple },
  ["@field"] = { fg = colors.white },
  ["@property"] = { fg = colors.green },

  ["@include"] = { fg = colors.pink },
  ["@preproc"] = { fg = colors.green },
  ["@define"] = { fg = colors.pink },
  ["@macro"] = { fg = colors.green },

  ["@operator"] = { fg = colors.pink },

  ["@punctuation.delimiter"] = { fg = colors.white },
  ["@punctuation.bracket"] = { fg = colors.white },
  ["@punctuation.special"] = { fg = colors.purple },

  ["@comment"] = { fg = colors.warmgrey, italic = true },
  ["@comment.documentation"] = { fg = colors.warmgrey, italic = true },

  ["@tag"] = { fg = colors.pink },
  ["@tag.builtin"] = { fg = colors.pink },
  ["@tag.attribute"] = { fg = colors.green },
  ["@tag.delimiter"] = { fg = colors.white },

  -- LSP Diagnostics (using colors from coc section)
  DiagnosticError = { fg = colors.purered },
  DiagnosticWarn = { fg = colors.orange },
  DiagnosticInfo = { fg = colors.aqua },
  DiagnosticHint = { fg = colors.aqua },
  DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = colors.orange },
  DiagnosticUnderlineInfo = { undercurl = true, sp = colors.orange },
  DiagnosticUnderlineHint = { undercurl = true, sp = colors.orange },

  -- Git
  GitSignsAdd = { fg = colors.green },
  GitSignsChange = { fg = colors.yellow },
  GitSignsDelete = { fg = colors.red },
}

local setup = function()
  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  -- Set colorscheme name
  vim.g.colors_name = "ultrakai"

  -- Apply highlights
  for group, options in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, options)
  end
end

setup()
