% mathnote_cmyk.cls
% LuaLaTeX / LuaHBTeX 用の数学ノートクラスファイル
%
% 使い方（メインの .tex ファイル）:
%   \documentclass{mathnote_cmyk}
%   \usepackage{mathnote_cmyk}
%
% このファイルの役割:
%   文書の「骨格」 — ベースクラスの選択・用紙/余白・フォント・節番号の深さ
%   デザイン・マクロ類は mathnote.sty に委ねる

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mathnote_cmyk}[2026/08/10 B5 CMYK math note class based on ltjsarticle]

% ==============================================================
% § 0. ベースクラスの読み込み
% ==============================================================

% oneside / twoside はこのクラスで受け取る（既定は twoside）
%   \ExecuteOptions は「このクラスで \DeclareOption したオプション」しか
%   実行しないため，\DeclareOption* 経由で ltjsarticle に転送されない．
%   （＝従来の \ExecuteOptions{...,twoside} は無効で片面組のままだった）
\newif\ifmathnote@oneside
\DeclareOption{oneside}{\mathnote@onesidetrue}
\DeclareOption{twoside}{\mathnote@onesidefalse}

% 版面を A4 版と「完全相似」にするスイッチ（§2 の解説を参照）
%
% 【既定を similar に変更（2026/08/10）】
%   旧既定（行送りだけ s_l = 0.7817 で縮め，文字は s_f = 0.8338 で縮める）
%   では，ディスプレイ数式・tcolorbox・tikz 見出しなど「高さが文字サイズに
%   比例する要素」が s_f でしか縮まないため，行グリッド（s_l）に対して
%   1 ページあたり約 1 行ぶん余計に高さを食い，A4 版より 1 行少なく入る
%   ページが生じていた（実測：第 1 章冒頭ページで超過 ≒ 1.4 行分）．
%   縦方向をすべて同一比 s_f で縮める similar モードのみが A4 版と
%   改行・改ページ位置を完全に一致させられるため，これを既定とする．
%   旧挙動が必要な場合は \documentclass[nosimilar]{mathnote_cmyk}．
\newif\ifmathnote@similar
\mathnote@similartrue
\DeclareOption{similar}{\mathnote@similartrue}
\DeclareOption{nosimilar}{\mathnote@similarfalse}

% 未知のオプションはすべて ltjsarticle に転送する
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ltjsarticle}}

\ProcessOptions\relax

% デフォルトオプション（\documentclass[...] の指定が優先される）
\ifmathnote@oneside
  \PassOptionsToClass{oneside}{ltjsarticle}
\else
  \PassOptionsToClass{twoside}{ltjsarticle}
\fi
\PassOptionsToClass{b5paper,fleqn,9pt}{ltjsarticle}

\LoadClass{ltjsarticle}

% ---- 相似モード（既定）：9pt 時に 15 へ落とされる \n@baseline を 16 に戻す ----
% ltjsarticle は \ifdim\jsc@mpt<.92\p@（＝8pt/9pt）のとき行送り係数を
% 16 → 15 に変更する．これが「A4 と B5 で行数が揃わない」最大の原因なので，
% 相似モード（既定）では 11pt 版と同じ 16 に戻す（\normalsize を再実行して反映）．
% これにより行送り比 = 文字サイズ比 = 0.833790 となり，mathnote_cmyk.sty の
% \mnvpt も自動的に \mnpt に一致する（縦横とも完全な相似形）．
\ifmathnote@similar
  \def\n@baseline{16}
  \AtEndOfClass{\normalsize}
\fi

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
% § 2. ページレイアウト（版面は A4 版から換算して決める）
% ==============================================================
%
% 【方針】
%   1 ページに入る行数と，ページ下端に残る端数を A4 版（mathnote.cls，
%   A4・11pt）と一致させる．そのため版面は直接数値で書かず，
%   (a) に写した A4 版の値から換算して求める．
%   → A4 側の geometry をいじったら (a) を同じ値に書き直すだけでよい．
%
% 【換算比の根拠】ltjsarticle（jsclasses 系）では
%     \normalsize   = 10 x \jsc@magscale pt   （11pt→1.095，9pt→0.913）
%     \baselineskip = \n@baseline x \jsc@magscale pt
%     \topskip      = 1.38 x \normalsize
%   であり，しかも 8pt/9pt のときだけ \n@baseline が 16 → 15 に落ちる．
%   したがって A4(11pt) → B5(9pt) の縮小率は 1 つではなく 2 つある：
%       文字サイズ比 s_f = 0.913 / 1.095           = 0.833790
%       行送り比     s_l = (15x0.913)/(16x1.095)   = 0.781678
%   ・版面の幅   … s_f で縮める（1 行の字詰め \zw 数が A4 と揃う）
%   ・版面の高さ … \topskip はそのまま，残り（行が積み上がる部分）を
%                  s_l で縮める（1 ページの行数と端数が A4 と揃う）
%   \linespread は両版共通なので比には影響しない．
%
% 【similar モード（既定）】\n@baseline を 16 に戻すと s_l = s_f となり，
%   版面はちょうど A4 の 0.833790 倍の相似形になる（天地余白も自然な量に
%   収まる）．文字サイズに比例して決まる高さ（ディスプレイ数式の実体高，
%   ストラット，\mnmm/\mnpt 指定の箱の内部余白，tikz 見出し等）は s_l では
%   縮められないため，s_l ≠ s_f の旧既定では数式や箱を含むページで A4 版
%   より行数が減る．改ページ位置まで A4 と一致させられるのは similar のみ
%   なので既定とした．旧挙動は [nosimilar] オプションで選択できる．

% ---- (a) A4 版（mathnote.cls）の版面 ── A4 を直したらここも同じ値に ----
\newlength{\mn@Apaperw}\newlength{\mn@Apaperh}
\newlength{\mn@Ainner}\newlength{\mn@Aouter}
\newlength{\mn@Atop}\newlength{\mn@Abottom}
\newlength{\mn@Ahead}\newlength{\mn@Ahsep}\newlength{\mn@Afoot}
\setlength{\mn@Apaperw}{210truemm}   % A4 の紙幅
\setlength{\mn@Apaperh}{297truemm}   % A4 の紙高
\setlength{\mn@Ainner} {20truemm}
\setlength{\mn@Aouter} {20truemm}
\setlength{\mn@Atop}   {23truemm}
\setlength{\mn@Abottom}{22truemm}
\setlength{\mn@Ahead}  {12truemm}
\setlength{\mn@Ahsep}  {4truemm}
\setlength{\mn@Afoot}  {10truemm}    % A4 のクラス既定 0.03367x297mm ≒ 10mm

% ---- (b) 換算比 ----
\def\mn@fscale{0.833790}             % 文字サイズ比
\ifmathnote@similar
  \let\mn@lscale\mn@fscale           % 相似モード（既定）：行送り比 = 文字サイズ比
\else
  \def\mn@lscale{0.781678}           % nosimilar：\n@baseline が 15 のときの行送り比
\fi
\newlength{\mn@Atopskip}
% 【修正 2026/08/11】旧値 15.111pt（=1.38 x 10.95pt）は誤り．
%   ltjsarticle の \topskip は「和文サイズ」基準：
%     \topskip = 1.38 x 0.924715 x 10 x \jsc@magscale pt
%   （A4: 13.9734pt，B5: 11.6508pt．\topskip 自体が文字サイズ比で
%    厳密に相似なので，現在の \topskip を 1095/913 倍して A4 値を得る）
%   旧値のままだと版面の高さが約 0.94pt 不足し，A4 より先に
%   ページが埋まる（1 行少なく入る）ページが生じうる．
\setlength{\mn@Atopskip}{\dimexpr\topskip*1095/913\relax}

% ---- (c) B5 の版面を計算 ----
\newlength{\mn@tw}\newlength{\mn@th}\newlength{\mn@tmp}
\newlength{\mn@inner}\newlength{\mn@outer}
\newlength{\mn@top}\newlength{\mn@bottom}
\newlength{\mn@head}\newlength{\mn@hsep}\newlength{\mn@foot}

% 版面の幅 = A4 版面幅 x s_f
% 【修正 2026/08/11】小数近似 \mn@fscale（=0.833790）でなく整数比
%   913/1095（= 0.913/1.095 = 文字サイズ比の厳密値）で換算する．
%   （\dimexpr の a*b/c は 64bit 中間精度で計算されるので桁あふれしない）
\setlength{\mn@tmp}{\mn@Apaperw}
\addtolength{\mn@tmp}{-\mn@Ainner}
\addtolength{\mn@tmp}{-\mn@Aouter}
\setlength{\mn@tw}{\dimexpr\mn@tmp*913/1095\relax}

% 版面の高さ = \topskip + (A4 版面高 - A4 の \topskip) x s_l
\setlength{\mn@tmp}{\mn@Apaperh}
\addtolength{\mn@tmp}{-\mn@Atop}
\addtolength{\mn@tmp}{-\mn@Abottom}
\addtolength{\mn@tmp}{-\mn@Atopskip}
% 【修正 2026/08/11】高さも整数比で厳密に換算．
%   similar（既定）: 913/1095，nosimilar: (15x913)/(16x1095) = 913/1168
\ifmathnote@similar
  \setlength{\mn@th}{\dimexpr\mn@tmp*913/1095\relax}
\else
  \setlength{\mn@th}{\dimexpr\mn@tmp*913/1168\relax}
\fi
\addtolength{\mn@th}{\topskip}

% 左右の余白（A4 の inner : outer の比を保つ）
\setlength{\mn@tmp}{\paperwidth}
\addtolength{\mn@tmp}{-\mn@tw}
\@tempcnta=\mn@Ainner
\@tempcntb=\mn@Ainner \advance\@tempcntb\mn@Aouter
\setlength{\mn@inner}{\dimexpr\mn@tmp*\@tempcnta/\@tempcntb\relax}
\setlength{\mn@outer}{\mn@tmp}\addtolength{\mn@outer}{-\mn@inner}

% 天地の余白（A4 の top : bottom の比を保つ）
\setlength{\mn@tmp}{\paperheight}
\addtolength{\mn@tmp}{-\mn@th}
\@tempcnta=\mn@Atop
\@tempcntb=\mn@Atop \advance\@tempcntb\mn@Abottom
\setlength{\mn@top}{\dimexpr\mn@tmp*\@tempcnta/\@tempcntb\relax}
\setlength{\mn@bottom}{\mn@tmp}\addtolength{\mn@bottom}{-\mn@top}

% 柱・ノンブルまわりは文字サイズ比で縮める
\setlength{\mn@head}{\mn@fscale\mn@Ahead}
\setlength{\mn@hsep}{\mn@fscale\mn@Ahsep}
\setlength{\mn@foot}{\mn@fscale\mn@Afoot}

% twoside 時は inner = ノド側，outer = 小口側．
% 綴じ代が要るなら (a) の \mn@Ainner を増やす（A4 と一緒に動く）．
\RequirePackage[
  inner          = \mn@inner,
  outer          = \mn@outer,
  top            = \mn@top,
  bottom         = \mn@bottom,
  headheight     = \mn@head,
  headsep        = \mn@hsep,
  footskip       = \mn@foot,
  marginparwidth = 0pt
]{geometry}

% ---- (d) 確認用：組み上がりの版面と 1 ページの行数をログに出す ----
%   A4 版と同じ行数になっているかを .log で突き合わせるための情報．
%   A4 側は mathnote.cls を触らずに，linear_algebra.tex のプリアンブルへ
%   次を貼れば同じ情報が出る（確認が済んだら消してよい）：
%
%     \makeatletter
%     \AddToHook{begindocument/end}{\begingroup
%       \@tempcnta=\dimexpr\textheight-\topskip\relax
%       \@tempcntb=\baselineskip
%       \divide\@tempcnta\@tempcntb \advance\@tempcnta\@ne
%       \typeout{[A4] th=\the\textheight\space bls=\the\baselineskip
%                \space lines/page=\the\@tempcnta}\endgroup}
%     \makeatother
\newcommand{\mn@report}{%
  \begingroup
    \@tempcnta=\dimexpr\textheight-\topskip\relax
    \@tempcntb=\baselineskip
    \divide\@tempcnta\@tempcntb \advance\@tempcnta\@ne
    \typeout{[mathnote] textwidth=\the\textwidth\space textheight=\the\textheight}%
    \typeout{[mathnote] topskip=\the\topskip\space baselineskip=\the\baselineskip
             \space lines/page=\the\@tempcnta}%
  \endgroup}
\ifdefined\AddToHook
  \AddToHook{begindocument/end}{\mn@report}
\else
  \AtBeginDocument{\mn@report}
\fi

% 用紙サイズを PDF のメディアボックスに反映
\RequirePackage{bxpapersize}

% ==============================================================
% § 3. 節番号の深さ
% ==============================================================

% subsubsection まで番号を付与
\setcounter{secnumdepth}{3}
