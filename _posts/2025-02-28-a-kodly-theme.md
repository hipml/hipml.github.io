---
layout: post
category: projects
---

There was a time, back around 2010, when Emacs wasn't yet the center of my digital universe. I was slugging through coursework using Xcode (yes, really) as my primary editor. This setup served me well enough until I hit my compilers course, where we were working in OCaml. Suddenly, Xcode's limitations became apparent, and I found myself hunting for an alternative.

That's when I discovered [Kod](https://github.com/rsms/kod?utm_source=taoofmac.com&utm_medium=web&utm_campaign=unsolicited_traffic&utm_content=external_link), billed as the "programmer's editor for OS X." I likely stumbled upon it through either Hacker News or early Reddit. During the [Snow Leopard](https://en.wikipedia.org/wiki/Mac_OS_X_Snow_Leopard) era, Kod was admittedly rough around the edges -- it lacked many features found in [Notepad++](https://notepad-plus-plus.org/) (my then-go-to on Windows) and crashed with alarming frequency.

But there was something special about it. The syntax highlighting was exceptional, perfectly suited for OCaml. Despite its flaws, I fell head over heels for this [quirky little editor](https://rsms.me/why-i-wrote-a-programmers-text-editor).

![Screenshot of Kod](images/kod.png)

Recently, while immersed in research, memories of Kod resurfaced. Though the project has long since been abandoned, its aesthetic left such an impression that I've created an Emacs theme inspired by it—bringing a piece of that nostalgia into my current workflow.

I tried building the defunct Kod project on Sequoia, but without success. Several dependencies have vanished into the digital ether, making a complete rebuild impossible. All I had to work with were a handful of screenshots and the original source code.

![Screenshot of Kod, 2](images/kod2.png)

Despite these limitations, I'm pleased with how the theme turned out. While not an exact replica -- Emacs' treesitter doesn't distinguish between language types and user types the way Kod did -- it captures the essence of what made Kod's aesthetic so appealing.

You can find my Kod-inspired Emacs theme [here](https://github.com/hipml/system-dotfiles/blob/main/emacs/themes/kodly-theme.el).

![Screenshot of Kodly for Emacs](images/kod3.png)
