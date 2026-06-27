% mathnote.cls
% LuaLaTeX / LuaHBTeX 用の数学ノートクラスファイル
%
% 使い方（メインの .tex ファイル）:
%   \documentclass{mathnote}
%   \usepackage{mathnote}
%
% このファイルの役割:
%   文書の「骨格」 — ベースクラスの選択・用紙/余白・フォント・節番号の深さ
%   デザイン・マクロ類は mathnote.sty に委ねる

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mathnote}[2026/06/27 math note class based on ltjsarticle]

% ==============================================================
% § 0. ベースクラスの読み込み
% ==============================================================

% 未知のオプションはすべて ltjsarticle に転送する
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ltjsarticle}}

% デフォルトオプション（ユーザー指定で上書き可能）
\ExecuteOptions{a4paper,fleqn,11pt,twoside}
\ProcessOptions\relax

\LoadClass{ltjsarticle}

% ==============================================================
% § 1. フォント設定
% ==============================================================

% fontspec の日本語対応版（\setmainjfont 等を提供）
% ltjsarticle が luatexja を読み込むため、ここでは fontspec 拡張のみ
\RequirePackage{luatexja-fontspec}

% ---- 日本語フォント ----
% 本文：明朝，見出し：ゴシック（Hiragino ProN）
% BoldFont に W6 を指定することで \textbf が正しく太字になる
\setmainjfont[
    YokoFeatures = {JFM=jlreq},
    TateFeatures = {JFM=jlreqv},
    BoldFont     = {Hiragino Kaku Gothic ProN W6},
]{Hiragino Mincho ProN}

\setsansjfont[
    YokoFeatures = {JFM=jlreq},
    TateFeatures = {JFM=jlreqv},
    BoldFont     = {Hiragino Kaku Gothic ProN W6},
]{Hiragino Kaku Gothic ProN}

% ---- 英文フォント（Latin Modern 系） ----
% OpticalSize=0 で自動的な光学サイズ調整を無効化
\setmainfont{Latin Modern Roman}[%
    BoldFont       = lmroman10-bold,%
    BoldItalicFont = lmroman10-bolditalic,%
    ItalicFont     = lmromanslant10-regular,%
    SmallCapsFont  = lmromancaps10-regular,%
    SlantedFont    = lmromanslant10-regular,%
    FontFace       = {sb}{n}{lmromandemi10-regular},%
    OpticalSize    = 0%
]
\setsansfont{Latin Modern Sans}[%
    BoldFont   = lmsans10-bold,%
    ItalicFont = lmsans10-oblique%
]
\setmonofont{Latin Modern Mono}[%
    BoldFont   = lmmonolt10-bold,%
    ItalicFont = lmmono10-italic%
]

% 見出し（\section 等）のフォント
\renewcommand{\headfont}{\sffamily\bfseries}

% \emph を斜体でなく太字に変更（和文では斜体が使いにくいため）
\renewcommand{\emph}[1]{\textbf{#1}}

% ==============================================================
% § 2. ページレイアウト（余白・用紙サイズ）
% ==============================================================

\RequirePackage[
  left           = 20truemm,
  right          = 20truemm,
  top            = 23truemm,
  bottom         = 22truemm,
  headheight     = 12truemm,
  headsep        = 4truemm,
  marginparwidth = 0pt
]{geometry}

% 用紙サイズを PDF のメディアボックスに反映
\RequirePackage{bxpapersize}

% ==============================================================
% § 3. 節番号の深さ
% ==============================================================

% subsubsection まで番号を付与
\setcounter{secnumdepth}{3}
