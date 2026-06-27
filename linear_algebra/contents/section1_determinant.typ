#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

#set table(
  inset: 6pt,
  stroke: none
)

#show figure.where(
  kind: table
): set figure.caption(position: top)

#show figure.where(
  kind: image
): set figure.caption(position: bottom)

#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}
#let conf(
  title: none,
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  pagenumbering: "1",
  doc,
) = {
  set document(
    title: title,
    author: authors.map(author => content-to-string(author.name)),
    keywords: keywords,
  )
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
    columns: cols,
    )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  place(top, float: true, scope: "parent", clearance: 4mm)[
  #if title != none {
    align(center)[#block(inset: 2em)[
      #text(weight: "bold", size: 1.5em)[#title]
      #(if subtitle != none {
        parbreak()
        text(weight: "bold", size: 1.25em)[#subtitle]
      })
    ]]
  }

  #if authors != none and authors != [] {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  #if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  #if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }
  ]

  doc
}
#show: doc => conf(
  abstract: [このセクションでは「行列式」に関連する基本的な用語や概念を定義し，それらの関係性を明確にする．

],
  pagenumbering: "1",
  cols: 1,
  doc,
)


#heading(level: 1, numbering: none)[行列式]
<行列式>
=== 置換
<置換>
==== 置換の定義
<置換の定義>
まず，行列式を定義する際に必要となる#strong[置換];を定義しよう．

#block[
置換置換
$n$次の置換とは，集合${ 1 \, 2 \, dots.h \, n }$から集合${ 1 \, 2 \, dots.h \, n }$への全単射である．

置換$sigma$は，以下のように表されることが多い：
\$\$\\sigma = \\chikan{1, 2, \\cdots, n}{\\sigma(1), \\sigma(2), \\cdots, \\sigma(n)}\$\$
このように，上段の数字と下段の数字を対応させることで，置換を表す．

]
この定義だけでは，いまいち「置換」というものがイメージしにくいかもしれない．
そこで，具体例を挙げて説明しよう．

#block[
置換置換 $sigma$が，$1$を$2$，$2$を$3$，$3$を$1$に対応させるとする．
つまり，$sigma$は次のような写像である：
$ sigma : 1 arrow.r.bar 2 \, quad 2 arrow.r.bar 3 \, quad 3 arrow.r.bar 1 $
このとき，$sigma$は$3$次の置換であり，次のように表すことができる：
\$\$\\sigma = \\chikan{1, 2, 3}{2, 3, 1}\$\$

]
ここで，の$sigma$は
$ P_sigma = mat(delim: "(", 0, 1, 0; 0, 0, 1; 1, 0, 0) $
とは異なる概念であることに注意したい．たしかに
$ P_sigma vec(1, 2, 3) = vec(2, 3, 1) $
ではあるが，$sigma$は行列ではなく，$P_sigma$とは異なるものである．

また，置換を議論する際には，「動かさない文字は省略してよい」と約束することが多い．たとえば以下のような例である：
\$\$\\chikan{1, 2, 3, 4, 5}{3, 2, 4, 1, 5} = \\chikan\*{1, 2, 3, 4, 5}{3, 2, 4, 1, 5}\$\$

==== 置換の数え上げ
<置換の数え上げ>
ここまでで，置換の定義について確かめた．次に，「$3$次の置換はいくつあるか」という問いの答えを考えよう．
その過程で我々は，地道に置換を列挙していく方法をとる．まず，以下の命題を証明しよう．

#block[
n次の置換の個数n次の置換の個数 $n$次の置換は$n !$個ある．

]
#block[
#block[
#emph[Proof.]
$n$次の置換を考えるとき，まず$1$に対応する文字を$n$通りの文字の中から選ぶことができる．
次に，$2$に対応する文字を残りの$n - 1$通りの文字の中から選ぶことができる．
同様にして，$3 \, 4 \, dots.h \, n$にも文字を対応させていくと，$n$次の置換の個数は
$ n times (n - 1) times (n - 2) times dots.h.c times 1 = n ! $
個である．これが証明すべきことであった．~◻

]
]
そして，以下では$n$次の置換すべての集合を$S_n$で表すことにする．このとき，より，
\$\$\\abs{S\_n} = n!\$\$
である．ただし\$\\abs{S\_n}\$は$S_n$の元の個数を表す#footnote[この\$\\abs{S\_n}\$は$n (S_n)$や$\# S_n$とも表される．];．

$n$次の置換の個数がわかったので，具体的な数字での例を考えてみよう．

#block[
3次の置換3次の置換
3次の置換は，\$\\abs{S\_3} = 3! = 6\$より，下記の$6$個でつくされる．
\$\$\\begin{aligned}
    &\\chikan{1, 2, 3}{1, 2, 3}, \\\\
    &\\chikan{1, 2, 3}{1, 3, 2}, \\quad
    \\chikan{1, 2, 3}{2, 1, 3},\\quad 
    \\chikan{1, 2, 3}{3, 2, 1}, \\\\
    &\\chikan{1, 2, 3}{2, 3, 1},\\quad 
    \\chikan{1, 2, 3}{3, 1, 2}.
  
\\end{aligned}\$\$

]
$4$次以上の置換についても同様に数え上げることができる．

==== 置換の積と対称群
<置換の積と対称群>
#block[
置換の積置換の積
$sigma \, tau in S_n$に対して，写像の合成$sigma circle.stroked.tiny tau$を
$ (sigma circle.stroked.tiny tau) (i) = sigma (tau (i)) $
と定義する．このとき，$sigma circle.stroked.tiny tau$もまた$n$次の置換であり，これは$sigma$と$tau$の#strong[積];と呼ばれる．

]
　

#block[
置換の積置換の積 $sigma \, tau in S_3$を
\$\$\\sigma = \\chikan{1, 2, 3}{2, 3, 1}, \\quad
  \\tau = \\chikan{1, 2, 3}{3, 1, 2}\$\$
とする．このとき，$sigma circle.stroked.tiny tau$は次のように計算される：
$ (sigma circle.stroked.tiny tau) (1) & = sigma (tau (1)) = sigma (3) = 1 \,\
(sigma circle.stroked.tiny tau) (2) & = sigma (tau (2)) = sigma (1) = 2 \,\
(sigma circle.stroked.tiny tau) (3) & = sigma (tau (3)) = sigma (2) = 3 . $
よって， \$\$\\sigma \\circ \\tau = \\chikan{1, 2, 3}{1, 2, 3}\$\$

]
#block[
恒等置換恒等置換
$sigma in S_n$において，すべての$i in { 1 \, 2 \, dots.h \, n }$に対して$sigma (i) = i$を満たす置換$sigma$を#strong[恒等置換];とよび．
$ 1_n $ と表す．

]
#block[
恒等置換恒等置換 $3$次の恒等置換$1_3$は，次のように表される：
\$\$1\_3 = \\chikan{1, 2, 3}{1, 2, 3}\$\$
$4$次の恒等置換$1_4$は，次のように表される：
\$\$1\_4 = \\chikan{1, 2, 3, 4}{1, 2, 3, 4}\$\$

]
#block[
逆置換逆置換
$sigma in S_n$に対して，逆写像$sigma^(- 1)$を$sigma$の#strong[逆置換];とよび，次のように定義する：
$ sigma^(- 1) (sigma (i)) = i \, quad forall i in { 1 \, 2 \, dots.h \, n } $

]
#block[
逆置換逆置換 $sigma in S_3$を
\$\$\\sigma = \\chikan{1, 2, 3}{2, 3, 1}\$\$
とする．このとき，$sigma$の逆置換$sigma^(- 1)$は次のように計算される：
$ sigma^(- 1) (2) & = 1 \,\
sigma^(- 1) (3) & = 2 \,\
sigma^(- 1) (1) & = 3 . $ よって，
\$\$\\sigma^{-1} = \\chikan{1, 2, 3}{3, 1, 2}\$\$

]
#block[
$sigma \, tau \, rho in S_n$と写像$circle.stroked.tiny : S_n times S_n arrow.r S_n$に対して以下のことが成り立つ：

#block[
$(sigma circle.stroked.tiny tau) circle.stroked.tiny rho = sigma circle.stroked.tiny (tau circle.stroked.tiny rho)$となる#footnote[写像の合成についてこの命題が成り立つことは既知とする．];．<item:結合律>

恒等写像 $1_n$
が単位元として存在し，$1_n circle.stroked.tiny sigma = sigma circle.stroked.tiny 1_n = sigma$となる．<item:単位元の存在>

各元 $sigma$ は全単射であるため逆写像 $sigma^(- 1)$ が存在し，
$sigma circle.stroked.tiny sigma^(- 1) = sigma^(- 1) circle.stroked.tiny sigma = 1_n$となる．<item:逆元の存在>

]
このとき，$(S_n \, circle.stroked.tiny)$は#strong[群];をなすという#footnote[単に「$S_n$は群である」ともいうが，正確には$S_n$と二項演算$circle.stroked.tiny$の組$(S_n \, circle.stroked.tiny)$が群である．];．特にこれを
$n$ 次対称群と呼ぶ．

もし上記の3つの条件に加えて，任意の$sigma \, tau in S_n$に対して$sigma circle.stroked.tiny tau = tau circle.stroked.tiny sigma$が成り立つならば，$(S_n \, circle.stroked.tiny)$は#strong[可換群];であるというが，
$n gt.equiv 3$のとき，$(S_n \, circle.stroked.tiny)$は可換群ではない．

]
#block[
任意の$n in bb(N)$に対して，$S_n eq.not diameter$である．
なぜならば，恒等置換$1_n$が$S_n$の元としてただひとつ存在するからである．

]
#block[
置換の性質置換の性質
任意の関数$f : S_n arrow.r bb(C)$に対して，次が成り立つ：
$ sum_(sigma in S_n) f (sigma) = sum_(sigma in S_n) f (sigma^(- 1)) . $

]
#block[
#block[
#emph[Proof.] 写像 $phi : S_n arrow.r S_n$ を
$phi (sigma) = sigma^(- 1)$ で定める． 任意の $sigma in S_n$ に対し
$sigma^(- 1) in S_n$ であるから，$phi$ は確かに定義される．

さらに，任意の $sigma in S_n$ について
$ (phi circle.stroked.tiny phi) (sigma) = phi (phi (sigma)) = phi (sigma^(- 1)) = (sigma^(- 1))^(- 1) = sigma $
となるので，$phi circle.stroked.tiny phi = upright(i d)_(S_n)$ である．
よって $phi$ は逆写像として$phi$をもち，したがって全単射である．

$phi$は全単射であるから，$sigma$ が $S_n$ を動くとき
$tau = phi (sigma) = sigma^(- 1)$ もまた $S_n$
を重複なく動く．したがって
$ sum_(sigma in S_n) f (sigma^(- 1)) = sum_(sigma in S_n) f (phi (sigma)) = sum_(tau in S_n) f (tau) = sum_(sigma in S_n) f (sigma) $
であり，これが証明すべきことであった．~◻

]
]
は，${ sigma^(- 1) divides sigma in S_n } = S_n$という命題と同値である．ここではのちに行列式を定義する際に議論が容易になる形を採用した．
この命題は「$sigma$が$S_n$を動くとき，$sigma^(- 1)$もまた$S_n$を重複なく動く」という直感的な理解でも十分である．

#block[
互換互換
$sigma in S_n$が，ある$i \, j in { 1 \, 2 \, dots.h \, n }$に対して
$ sigma (i) = j \, quad sigma (j) = i $ かつ
$ sigma (k) = k \, quad forall k in { 1 \, 2 \, dots.h \, n } \\ { i \, j } $
を満たすとき，$sigma$を#strong[互換];と呼ぶ． このとき，互換$sigma$は
\$\$\\chikan{1, 2, \\cdots, i, \\cdots, j, \\cdots, n}{1, 2, \\cdots, j, \\cdots, i, \\cdots, n}\$\$
ともかけ，これ以下で$(i \, j)$とかく．

]
#block[
互換互換 $sigma in S_4$を
\$\$\\sigma = \\chikan{1, 2, 3, 4}{1, 3, 2, 4}\$\$
とする．このとき，$sigma$は$2$と$3$を入れ替え，$1$と$4$を動かさないので，$sigma$は互換であり，$(2 \, 3)$ともかける．

]
#block[
任意の$sigma in S_n$は，いくつかの互換の積として表される．

]
#block[
#block[
#emph[Proof.] $sigma in S_n$を任意にとる．

$sigma$ が恒等置換 $1_n$ であるとき，$sigma$は
$(1 \, 2) circle.stroked.tiny (1 \, 2)$
のように，同じ入れ替えを2回繰り返したものとみなせる．
したがって，$1_n$は互換の積として表せる．

$sigma$ が恒等置換でないとき，$i eq.not sigma (i)$ となる $i$ がある．
ここで，互換 $tau = (i \, sigma (i))$ を考え， 新たな置換
$sigma' = tau circle.stroked.tiny sigma$ を定める．
すると，$sigma' (i) = tau (sigma (i)) = i$ となるため， $sigma'$
によって自分自身に写される元の数が $1$ つ増加する．
この操作を繰り返すと，有限個の互換 $tau_1 \, tau_2 \, dots.h \, tau_k$
を用いて
$1_n = tau_k circle.stroked.tiny dots.h circle.stroked.tiny tau_1 circle.stroked.tiny sigma =$と表せる．
各互換 $tau_j$
の逆置換は自分自身（$tau_j^(- 1) = tau_j$）であるから，左から順に
$tau_k \, dots.h \, tau_1$
を乗じることで$sigma = tau_1 circle.stroked.tiny dots.h circle.stroked.tiny tau_k$が得られる．

よって，$sigma$ は互換の積として表される．~◻

]
]
ここで注意しておきたいのは，互換の積の表現は一通りに定まるとは限らないということである．たとえば，次のような例がある：

#block[
$sigma in S_3$を \$\$\\sigma = \\chikan{1, 2, 3}{3, 1, 2}\$\$
とする．このとき，$sigma$は互換の積として
$ sigma = (1 \, 3) circle.stroked.tiny (1 \, 2) $ とも
$ sigma = (2 \, 3) circle.stroked.tiny (1 \, 3) $ とも表せる．

]
このように，互換の積は一意に定まらないが，互換の積に含まれる互換の数の偶奇性は一定である．

#block[
置換の符号の偶奇置換の符号の偶奇
任意の$sigma in S_n$に対して，$sigma$を互換の積として表すとき，その互換の数の偶奇は$sigma$により決まり，互換の積の表現によらない．

]
#block[
#block[
#emph[Proof.] まず，多項式
$ Delta (x_1 \, x_2 \, dots.h \, x_n) & = product_(1 lt.equiv i < j lt.equiv n) (x_j - x_i)\
 & = {(x_2 - x_1) & (x_3 - x_1) & dots.h.c & (x_n - x_1)\
 & times (x_3 - x_2) & dots.h.c & (x_n - x_2)\
 &  & dots.down & dots.v\
 &  &  & times (x_n - x_(n - 1)) $
を考える#footnote[この多項式を差積という．以下，単に$Delta$とも記す．];．さらに，
$ Delta^sigma (x_1 \, x_2 \, dots.h \, x_n) & = product_(1 lt.equiv i < j lt.equiv n) (x_(sigma (j)) - x_(sigma (i)))\
 & = {(x_(sigma (2)) - x_(sigma (1))) & (x_(sigma (3)) - x_(sigma (1))) & dots.h.c & (x_(sigma (n)) - x_(sigma (1)))\
 & times (x_(sigma (3)) - x_(sigma (2))) & dots.h.c & (x_(sigma (n)) - x_(sigma (2)))\
 &  & dots.down & dots.v\
 &  &  & times (x_(sigma (n)) - x_(sigma (n - 1))) $ と定める．

ここで，$sigma$が互換$(i \, j)$であるとき，$Delta^sigma$は$Delta$のうち$(x_j - x_i)$の符号を反転させたものである．
したがって，$sigma = tau_1 tau_2 dots.h.c tau_s = rho_1 rho_2 dots.h.c rho_t$であるとき，
$ Delta^sigma (x_1 \, x_2 \, dots.h \, x_n) & = (- 1)^t Delta (x_1 \, x_2 \, dots.h \, x_n)\
 & = (- 1)^s Delta (x_1 \, x_2 \, dots.h \, x_n) $
が成り立つ．したがって，$(- 1)^s = (- 1)^t$が成り立ち，$s$と$t$の偶奇は一致する．
これが証明すべきことであった．~◻

]
]
今までの議論のまとめとして，用語を定義しよう：

#block[
置換の符号置換の符号
$sigma in S_n$が互換の積として表されるとき，その互換の数が偶数であれば$sigma$は#strong[偶置換];であり，奇数であれば#strong[奇置換];であるという．

また，$sigma$が偶置換であれば \$\$\\sgn(\\sigma) = 1\$\$
と定め，奇置換であれば \$\$\\sgn(\\sigma) = -1\$\$
と定める．この\$\\sgn(\\sigma)\$を$sigma$の#strong[符号];と呼ぶ．

]
#block[
で現れる \$\\sgn(\\sigma)\$ は，置換 $sigma$ の「符号」（sign /
signature）を表す記号である． 記号\$\\sgn\$は
"signum"（ラテン語で「しるし」）に由来し，実数 $x$ の符号を返す符号関数
\$\\sgn x\$ にも用いられる．
\$\\sgn\$は「サイン」「シグナム」「シグネチャー」「エス・ジー・エヌ」などと呼ばれることが多い．

]
#block[
置換の符号置換の符号 $sigma in S_3$を
\$\$\\sigma = \\chikan{1, 2, 3}{3, 1, 2}\$\$
とする．このとき，$sigma$は互換の積として
$ sigma = (1 \, 3) circle.stroked.tiny (1 \, 2) $
と表せるので，互換の個数は偶数である．ゆえに$sigma$は偶置換であり，
\$\$\\sgn(\\sigma) = 1\$\$

]
次に，多項式に対する置換の作用を厳密に定義することで，符号の性質を導こう．

#block[
多項式に対する置換の作用多項式に対する置換の作用 $n$ 変数多項式
$f (x_1 \, dots.h \, x_n)$ と置換 $sigma in S_n$ に対して，新たな多項式
$f^sigma$ を
$ f^sigma (x_1 \, dots.h \, x_n) = f (x_(sigma (1)) \, dots.h \, x_(sigma (n))) $
で定義する．このとき，$f^sigma$ を $f$ に対する置換 $sigma$
の#strong[作用];とよぶ．

]
この定義に基づくと，差積 $Delta$ に対する作用 $Delta^sigma$
は次のようにかける：
$ Delta^sigma = product_(1 lt.eq i < j lt.eq n) (x_(sigma (j)) - x_(sigma (i))) $
このとき，\$\\sgn(\\sigma)\$ は
\$\\Delta^\\sigma = \\sgn(\\sigma) \\Delta\$ を満たす定数である．

この定義のもとで，次の補題を証明しよう．

#block[
作用の合成作用の合成 任意の多項式 $f$ と置換 $sigma \, tau in S_n$
に対して，次式が成り立つ：
$ (f^tau)^sigma = f^(sigma circle.stroked.tiny tau) $

]
#block[
#emph[Proof.] $g = f^tau$ とおくと，定義より
$g (y_1 \, dots.h \, y_n) = f (y_(tau (1)) \, dots.h \, y_(tau (n)))$
である． ここで $y_k = x_(sigma (k))$ と置き換えて作用させると，
$ (f^tau)^sigma & = g (x_(sigma (1)) \, dots.h \, x_(sigma (n)))\
 & = f (x_(sigma (tau (1))) \, dots.h \, x_(sigma (tau (n))))\
 & = f (x_((sigma circle.stroked.tiny tau) (1)) \, dots.h \, x_((sigma circle.stroked.tiny tau) (n)))\
 & = f^(sigma circle.stroked.tiny tau) . $
これが証明すべきことであった．~◻

]
最後に，置換の符号の基本的な性質をまとめた命題を示す．

#block[
置換の符号の性質置換の符号の性質
任意の$sigma \, tau in S_n$に対して，次が成り立つ： \$\$\\begin{aligned}
     &\\sgn(1\_n)  = 1, \\\\
    &\\sgn(\\sigma \\circ \\tau) = \\sgn(\\sigma) \\cdot \\sgn(\\tau), \\\\
     &\\sgn(\\sigma^{-1}) = \\sgn(\\sigma).
  
\\end{aligned}\$\$

]
#block[
#block[
#emph[Proof.] 第1式について，
$ Delta^(1_n) (x_1 \, x_2 \, dots.h \, x_n) = Delta (x_1 \, x_2 \, dots.h \, x_n) $
なので，\$\\sgn(1\_n) = 1\$が成り立つ．

第2式について，から， 任意の置換 $sigma \, tau$ に対して
$(Delta^tau)^sigma = Delta^(sigma circle.stroked.tiny tau)$ が成り立つ．
これを用いると， \$\$\\begin{aligned}
  \\sgn(\\sigma \\circ \\tau) \\Delta &= \\Delta^{\\sigma \\circ \\tau} \\\\
  &= (\\Delta^\\tau)^\\sigma \\\\
  &= (\\sgn(\\tau) \\Delta)^\\sigma \\\\
  &= \\sgn(\\tau) (\\Delta^\\sigma) \\quad (\\text{\$\\sgn(\\tau)\$ は定数なので作用の外に出る}) \\\\
  &= \\sgn(\\tau) (\\sgn(\\sigma) \\Delta) \\\\
  &= (\\sgn(\\sigma) \\sgn(\\tau)) \\Delta
\\end{aligned}\$\$
したがって，\$\\sgn(\\sigma \\circ \\tau) = \\sgn(\\sigma) \\sgn(\\tau)\$
が成り立つ．

第3式について，$sigma circle.stroked.tiny sigma^(- 1) = 1_n$
であるから，いままでの結果を用いると， \$\$\\begin{aligned}
  \\sgn(\\sigma \\circ \\sigma^{-1}) &= \\sgn(1\_n) \\\\
  \\sgn(\\sigma) \\sgn(\\sigma^{-1}) &= 1
\\end{aligned}\$\$ \$\\sgn(\\sigma) \\in \\{1, -1\\}\$ より
\$\\sgn(\\sigma)^2 = 1\$ であるから，両辺に \$\\sgn(\\sigma)\$
を掛ければ \$\$\\sgn(\\sigma^{-1}) = \\sgn(\\sigma)\$\$ を得る．

以上の議論により，命題の3つの式がすべて成り立つことが示された．~◻

]
]
ここまでで「置換」と「置換の符号」についての議論を終えた．次章では，これらの概念を用いて行列式を定義しよう．

=== 行列式の定義と基本的性質
<行列式の定義と基本的性質>
==== 行列式の定義
<行列式の定義>
#block[
行列式行列式
$n$次正方行列$A = (a_(i j))$に対して，$A$の#strong[行列式];（determinant）を$det A$で表し，次のように定義する：
\$\$\\begin{aligned}
  \\det A &=\\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\prod\_{k=1}^n a\_{k\\sigma(k)} \\\\
  &=  \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\dotsm a\_{n\\sigma(n)}
  
\\end{aligned}\$\$
$det A$はしばしば\$\\abs{A}\$ともかく．$A$の成分を明記したい場合には下記のようにも表記する：
$ mat(delim: "||", a_11, a_12, dots.h.c, a_(1 n); a_21, a_22, dots.h.c, a_(2 n); dots.v, dots.v, dots.down, dots.v; a_(n 1), a_(n 2), dots.h.c, a_(n n)) $
また，$A$の$i$列目の列ベクトルについて
$ bold(a_i) = vec(a_(1 i), a_(2 i), dots.v, a_(n i)) $
のときは$det A$を下記のように表記することもある：
$ det (bold(a)_1 \, bold(a)_2 \, dots.h \, bold(a)_n) $

]
#block[
行列式の定義において，$sigma$が$S_n$を動くとき，$a_(1 sigma (1)) a_(2 sigma (2)) dots.h.c a_(n sigma (n))$は$A$の各行からちょうど1つずつ要素を選び，かつ各列からも1つずつ要素を選ぶような積である．
したがって，行列式は「各行・各列から1つずつ要素を選んでできる積」の符号付き和として解釈できる．

]
#block[
2次の行列式2次の行列式
$2$次正方行列$A = mat(delim: "(", a_11, a_12; a_21, a_22)$に対して，$A$の行列式は次のように計算される：
\$\$\\begin{aligned}
    \\det A &= \\sum\_{\\sigma \\in S\_2} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\\\
    &= \\sgn\\left( \\chikan{1, 2}{1, 2} \\right) a\_{11} a\_{22} + \\sgn\\left( \\chikan{1, 2}{2, 1} \\right) a\_{12} a\_{21} \\\\
    &= 1 \\cdot a\_{11} a\_{22} + (-1) \\cdot a\_{12} a\_{21} \\\\
    &= a\_{11} a\_{22} - a\_{12} a\_{21}.
  
\\end{aligned}\$\$

]
#block[
3次の行列式3次の行列式
$3$次正方行列$A = mat(delim: "(", a_11, a_12, a_13; a_21, a_22, a_23; a_31, a_32, a_33)$に対して，$A$の行列式は次のように計算される：
\$\$\\begin{aligned}
    \\det A &= \\sum\_{\\sigma \\in S\_3} \\sgn(\\sigma) \\cdot  a\_{1\\sigma(1)} a\_{2\\sigma(2)} a\_{3\\sigma(3)} \\\\
    &= \\sgn\\left( \\chikan{1, 2, 3}{1, 2, 3} \\right) a\_{11} a\_{22} a\_{33} + \\sgn\\left( \\chikan{1, 2, 3}{1, 3, 2} \\right) a\_{11} a\_{23} a\_{32} \\\\
    &\\quad + \\sgn\\left( \\chikan{1, 2, 3}{2, 1, 3} \\right) a\_{12} a\_{21} a\_{33} + \\sgn\\left( \\chikan{1, 2, 3}{3, 2, 1} \\right) a\_{13} a\_{22} a\_{31} \\\\
    &\\quad + \\sgn\\left( \\chikan{1, 2, 3}{2, 3, 1} \\right) a\_{12} a\_{23} a\_{31} + \\sgn\\left( \\chikan{1, 2, 3}{3, 1, 2} \\right) a\_{13} a\_{21} a\_{32} \\\\
    &= 1 \\cdot a\_{11} a\_{22} a\_{33} + (-1) \\cdot a\_{11} a\_{23} a\_{32} + (-1) \\cdot a\_{12} a\_{21} a\_{33} \\\\
    &\\quad + (-1) \\cdot a\_{13} a\_{22} a\_{31} + 1 \\cdot a\_{12} a\_{23} a\_{31} + 1 \\cdot a\_{13} a\_{21} a\_{32} \\\\
    &= a\_{11} a\_{22} a\_{33} + a\_{12} a\_{23} a\_{31} + a\_{13} a\_{21} a\_{32} - a\_{11} a\_{23} a\_{32} - a\_{12} a\_{21} a\_{33} - a\_{13} a\_{22} a\_{31}.
  
\\end{aligned}\$\$

]
#block[
転置行列の行列式転置行列の行列式
$n$次正方行列$A = (a_(i j))$に対して，次が成り立つ：
\$\$\\det A = \\sum\_{\\tau \\in S\_n} \\sgn (\\tau) \\cdot a\_{\\tau(1)1} a\_{\\tau(2)2} \\dotsm a\_{\\tau(n)n}\$\$

]
#block[
#block[
#emph[Proof.]
$sigma (k) = i$とおく．$sigma$が全単射であることにより，$sigma$の逆写像として$sigma^(- 1)$が存在し，
$sigma^(- 1) (i) = k$が成立する．このとき，以下の式が成り立つ：
$ a_(1 sigma (1)) a_(2 sigma (2)) dots.h.c a_(n sigma (n)) = a_(sigma^(- 1) (1) 1) a_(sigma^(- 1) (2) 2) dots.h.c a_(sigma^(- 1) (n) n) $
ただし，ここでは積の順序を適宜入れ替えた．

したがって，
\$\$\\det A = \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{\\sigma^{-1}(1)1} a\_{\\sigma^{-1}(2)2} \\dotsm a\_{\\sigma^{-1}(n)n}\$\$
であり，の第2式を用いると，
\$\$\\det A = \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma^{-1}) \\cdot a\_{\\sigma^{-1}(1)1} a\_{\\sigma^{-1}(2)2} \\dotsm a\_{\\sigma^{-1}(n)n}.\$\$
この右辺にの主張を適用すると，
\$\$\\det A = \\sum\_{\\sigma \\in S\_n} \\sgn (\\sigma ) \\cdot a\_{\\sigma(1)1} a\_{\\sigma(2)2} \\dotsm a\_{\\sigma(n)n}.\$\$
$sigma$を$tau$におきかえると，これが証明すべきことであった．~◻

]
]
ここで，転置行列の定義を思い出そう．は，行列$A$とその転置行列$A^(sans(T))$の行列式が等しいことを主張している．
すなわち， $ det A = det A^(sans(T)) $ である．

この事実が示唆することは「行列式は行ベクトルに関しても列ベクトルに関しても同様の性質が成り立つ」ということである．

==== 行列式の基本的性質
<行列式の基本的性質>
先に我々は，行列式を「各行・各列から1つずつ要素を選んでできる積」の符号付き和として解釈できると述べた．

この解釈はもちろん正しいのだが，以下では行列式を「多重線型性」「交代性」「正規化条件」を満たす関数として定義することを考える．

#block[
行列式の多重線型性行列式の多重線型性
$n$次正方行列$A = (a_(i j))$に対して，$i$行目を
$ bold(a_i) = bold(b_i) + bold(c)_i $ と分解したとき，次が成り立つ：
$ det (bold(a)_1 \, dots.h \, bold(a)_(i - 1) \, bold(a)_i \, bold(a)_(i + 1) \, dots.h \, bold(a)_n) = det (bold(a)_1 \, dots.h \, bold(a)_(i - 1) \, bold(b)_i \, bold(a)_(i + 1) \, dots.h \, bold(a)_n) + det (bold(a)_1 \, dots.h \, bold(a)_(i - 1) \, bold(c)_i \, bold(a)_(i + 1) \, dots.h \, bold(a)_n) $
また，任意の定数$k in bb(C)$に対して，次が成り立つ：
$ det (bold(a)_1 \, dots.h \, bold(a)_(i - 1) \, k bold(a)_i \, bold(a)_(i + 1) \, dots.h \, bold(a)_n) = k dot.op det (bold(a)_1 \, dots.h \, bold(a)_n) $

]
#block[
#block[
#emph[Proof.] 一つ目の主張について，行列式の定義から，
\$\$\\begin{aligned}
    &\\det(\\bm{a}\_1, \\dots, \\bm{a}\_{i-1}, \\bm{a}\_i, \\bm{a}\_{i+1}, \\dots, \\bm{a}\_n) \\\\
    =& \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\dotsm a\_{i\\sigma(i)} \\dotsm a\_{n\\sigma(n)} \\\\
    =& \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\dotsm (b\_{i\\sigma(i)} + c\_{i\\sigma(i)}) \\dotsm a\_{n\\sigma(n)} \\\\
    =& \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\dotsm b\_{i\\sigma(i)} \\dotsm a\_{n\\sigma(n)} 
    + \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\dotsm c\_{i\\sigma(i)} \\dotsm a\_{n\\sigma(n)} \\\\
    =& \\det(\\bm{a}\_1, \\dots, \\bm{a}\_{i-1}, \\bm{b}\_i, \\bm{a}\_{i+1}, \\dots, \\bm{a}\_n) 
     + \\det(\\bm{a}\_1, \\dots, \\bm{a}\_{i-1}, \\bm{c}\_i, \\bm{a}\_{i+1}, \\dots, \\bm{a}\_n).
  
\\end{aligned}\$\$ 二つ目の主張についても，行列式の定義から，
\$\$\\begin{aligned}
    &\\det(\\bm{a}\_1, \\dots, \\bm{a}\_{i-1}, k \\bm{a}\_i, \\bm{a}\_{i+1}, \\dots, \\bm{a}\_n) \\\\
    =& \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\dotsm (k a\_{i\\sigma(i)}) \\dotsm a\_{n\\sigma(n)} \\\\
    =& k \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1\\sigma(1)} a\_{2\\sigma(2)} \\dotsm a\_{i\\sigma(i)} \\dotsm a\_{n\\sigma(n)} \\\\
    =& k \\cdot \\det(\\bm{a}\_1, \\dots, \\bm{a}\_n).
  
\\end{aligned}\$\$
以上により，命題の両方の主張が成り立つことが示された．~◻

]
]
#block[
行列式の交代性行列式の交代性
$n$次正方行列$A = (bold(a)_1 \, bold(a)_2 \, dots.h \, bold(a)_n)$に置換$tau$を施した行列として
$A' = (bold(a)_(tau (1)) \, bold(a)_(tau (2)) \, dots.h \, bold(a)_(tau (n)))$を考えると，次が成り立つ：
\$\$\\det A \' = \\sgn (\\tau) \\cdot \\det A\$\$

]
この命題は，特に$tau$が互換$(i \, j)$であるとき，次のように書き直せる：
$ det A' = - det A $
これは，行列$A$の$i$行目と$j$行目を入れ替えた行列$A'$の行列式は，$A$の行列式の符号を反転させたものであることを意味する．

具体例を考えたところで，本題の証明に入ろう：

#block[
#block[
#emph[Proof.] 行列式の定義から， \$\$\\begin{aligned}
      \\det A \' = & \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{\\tau(1)\\sigma(1)} a\_{\\tau(2)\\sigma(2)} \\dotsm a\_{\\tau(n)\\sigma(n)} \\\\
      = & \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot a\_{1(\\sigma  \\tau^{-1})(1)} a\_{2(\\sigma  \\tau^{-1})(2)} \\dotsm a\_{n(\\sigma  \\tau^{-1})(n)}.
    
\\end{aligned}\$\$
ここで，\$\\sgn (\\sigma) = \\sgn (\\sigma \\tau^{-1} (\\tau))= \\sgn (\\sigma \\tau^{-1}) \\sgn (\\tau)\$が成り立つので，
\$\$\\begin{aligned}
      \\det A \' = & \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma  \\tau^{-1}) \\sgn (\\tau) \\cdot a\_{1(\\sigma  \\tau^{-1})(1)} a\_{2(\\sigma  \\tau^{-1})(2)} \\dotsm a\_{n(\\sigma  \\tau^{-1})(n)} \\\\
      = & \\sgn (\\tau) \\sum\_{\\sigma \\tau^{-1} \\in S\_n} \\sgn(\\sigma \\tau ^{-1}) \\cdot a\_{1\\sigma \\tau^{-1}(1)} a\_{2\\sigma \\tau^{-1}(2)} \\dotsm a\_{n\\sigma \\tau^{-1}(n)} \\\\
      = & \\sgn (\\tau) \\cdot \\det A.
    
\\end{aligned}\$\$
ここで，$sigma$が$S_n$を動くとき，$sigma tau^(- 1)$も$S_n$を動くことを用いた．

以上により，命題が正しいことが示された．~◻

]
]
先ほどの具体例は，から導ける系としてまとめておこう：

#block[
行列式の交代性の系①行列式の交代性の系1
$n$次正方行列$A = (bold(a)_1 \, bold(a)_2 \, dots.h \, bold(a)_n)$において，相異なる$2$つの行$bold(a)_i$と$bold(a)_j$を入れ替えた行列を$A'$とすると，次が成り立つ：
$ det A' = - det A $

]
また，から導けるもう一つの系を示そう：

#block[
行列式の交代性の系②行列式の交代性の系2
$n$次正方行列$A = (bold(a)_1 \, bold(a)_2 \, dots.h \, bold(a)_n)$において，もし$bold(a)_i = bold(a)_j$となる$i eq.not j$が存在すれば，次が成り立つ：
$ det A = 0 $

]
#block[
#block[
#emph[Proof.] $i$行目と$j$行目を入れ替えた行列を$A'$とすると，より
$ det A' = - det A $
一方で，$bold(a)_i = bold(a)_j$であるから，$A = A'$であり，
$ det A' = det A $ が成り立つ．以上より， $ det A = - det A $
が成り立ち，$det A = 0$が得られる．これが証明すべきことであった．~◻

]
]
#block[
行列式の正規化条件行列式の正規化条件
$n$次単位行列$E_n$に対して，次が成り立つ： $ det E_n = 1 $

]
#block[
#block[
#emph[Proof.] 行列式の定義から， \$\$\\begin{aligned}
    \\det E\_n &= \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) \\cdot e\_{1\\sigma(1)} e\_{2\\sigma(2)} \\dotsm e\_{n\\sigma(n)} \\\\
    &= \\sgn(1\_n) \\cdot e\_{11} e\_{22} \\dotsm e\_{nn} + \\sum\_{\\sigma \\in S\_n, \\sigma \\ne 1\_n} \\sgn(\\sigma) \\cdot e\_{1\\sigma(1)} e\_{2\\sigma(2)} \\dotsm e\_{n\\sigma(n)} \\\\
    &= 1 \\cdot 1 \\cdot 1 \\dotsm 1 + 0 \\\\
    &= 1.
  
\\end{aligned}\$\$
ここで，$sigma eq.not 1_n$であるとき，少なくとも一つの$k$に対して$sigma (k) eq.not k$が成り立ち，したがって$e_(k sigma (k)) = 0$であることを用いた．

以上の議論によって，命題が示された．~◻

]
]
#block[
行列式の特徴づけ行列式の特徴づけ
多重線型写像$F : bb(C)^n times bb(C)^n times dots.h times bb(C)^n arrow.r bb(C)$が交代性と正規化条件を満たすとき，$F$は写像$det$と一致する．

]
#block[
#block[
#emph[Proof.]
$bold(x)_j in bb(C)^n$をとり，行列$A = (bold(x)_1 \, bold(x)_2 \, dots.h \, bold(x)_n)$を考える．
また，必要に応じて以下では$bold(x)_j = sum_(i = 1)^n x_(i j) bold(e)_i$と表記し，
$bold(e)_i$は標準基底ベクトルとする．

まず，$F$が多重線型写像であることから，
$ F (bold(x)_1 \, bold(x)_2 \, dots.h \, bold(x)_n) & = (sum_(i_1 = 1)^n x_(i_11) bold(e)_(i_1) \, sum_(i_2 = 1)^n x_(i_22) bold(e)_(i_2) \, dots.h \, sum_(i_n = 1)^n x_(i_n n) bold(e)_(i_n))\
 & = sum_(i_1 = 1)^n sum_(i_2 = 1)^n dots.h.c sum_(i_n = 1)^n x_(i_11) x_(i_22) dots.h.c x_(i_n n) F (bold(e)_(i_1) \, bold(e)_(i_2) \, dots.h \, bold(e)_(i_n)) . $

ここで，もし$(i_1 \, i_2 \, dots.h \, i_n)$において，$i_k = i_l$となる$k eq.not l$が存在すれば，交代性から
$ F (bold(e)_(i_1) \, bold(e)_(i_2) \, dots.h \, bold(e)_(i_n)) = 0 $
が成り立つ．したがって，和の中で非零となるのは，$(i_1 \, i_2 \, dots.h \, i_n)$が${ 1 \, 2 \, dots.h \, n }$の置換である場合に限られる．
すなわち，ある$sigma in S_n$に対して$(i_1 \, i_2 \, dots.h \, i_n) = (sigma (1) \, sigma (2) \, dots.h \, sigma (n))$である場合に限られる．

したがって， \$\$\\begin{aligned}
    F (\\bm{x}\_1, \\bm{x}\_2, \\dots, \\bm{x}\_n)& = \\sum\_{\\sigma \\in S\_n} x\_{\\sigma(1)1} x\_{\\sigma(2)2} \\dotsm x\_{\\sigma(n)n} F(\\bm{e}\_{\\sigma(1)}, \\bm{e}\_{\\sigma(2)}, \\dots, \\bm{e}\_{\\sigma(n)}) \\\\
    & = \\sum\_{\\sigma \\in S\_n} x\_{\\sigma(1)1} x\_{\\sigma(2)2} \\dotsm x\_{\\sigma(n)n} \\sgn(\\sigma) F(\\bm{e}\_1, \\bm{e}\_2, \\dots, \\bm{e}\_n) \\\\
    & = F(\\bm{e}\_1, \\bm{e}\_2, \\dots, \\bm{e}\_n) \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) x\_{\\sigma(1)1} x\_{\\sigma(2)2} \\dotsm x\_{\\sigma(n)n}.
  
\\end{aligned}\$\$
ここで，正規化条件から$F (bold(e)_1 \, bold(e)_2 \, dots.h \, bold(e)_n) = 1$であることを用いると，
\$\$F (\\bm{x}\_1, \\bm{x}\_2, \\dots, \\bm{x}\_n) = \\sum\_{\\sigma \\in S\_n} \\sgn(\\sigma) x\_{\\sigma(1)1} x\_{\\sigma(2)2} \\dotsm x\_{\\sigma(n)n} = \\det A\$\$
が成り立つ．これが証明すべきことであった．~◻

]
]
以上の議論を踏まえると，行列式は下記のようにも定義できる：

#block[
行列式の「公理的な定義」行列式の「公理的な定義」
$n$次正方行列$A = (bold(a)_1 \, bold(a)_2 \, dots.h \, bold(a)_n)$に対して，行列式$det$は以下の3つの性質を満たす写像である：

#block[
$det$は各行に関して線型である．

任意の置換$tau in S_n$に対して，\$\\det(\\bm{a}\_{\\tau(1)}, \\bm{a}\_{\\tau(2)}, \\dots, \\bm{a}\_{\\tau(n)}) = \\sgn(\\tau) \\cdot \\det(\\bm{a}\_1, \\bm{a}\_2, \\dots, \\bm{a}\_n)\$が成り立つ．

単位行列$E_n$に対して，$det E_n = 1$が成り立つ．

]
]
ここまでで，行列式の「行列の成分による定義」と「公理的な定義」の2つをみてきた．これらの定義を整理すると以下のようになる．

#block[
|B1.6cm|L6.8cm|L6.8cm| & & \

& & \

& & \

& & \

]
