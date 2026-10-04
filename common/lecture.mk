# 講義MODE 共通ビルド規則
# 各節のフォルダの Makefile から include して使う
#   make                  : 全プリントを B4 横 2面付けの PDF（*.pdf）にする
#   make 1-A_〇〇.pdf     : 1枚だけ作る
#   make student          : 生徒用（解答非表示）で全プリントを作り直す
#   make teacher          : 教師用（解答表示）で全プリントを作り直す
#   make clean            : 中間ファイル（.build/）を消す
# A4 原稿と中間ファイルは .build/ に出力する
COMMON := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
export TEXINPUTS := .:$(COMMON)//:

BUILD := .build
SRC   := $(wildcard [0-9]*-*.tex)
PDF   := $(SRC:.tex=.pdf)
DEPS  := $(COMMON)/common-preamble.tex $(COMMON)/lecture-preamble.tex

ifeq ($(MODE),student)
  MODEDEF := \def\studentmode{}
endif

all: $(PDF)

# macOS 標準の make 3.81 は先に書いたパターン規則を優先するので，この規則を %.pdf より前に置く
$(BUILD)/%.pdf: %.tex $(DEPS) | $(BUILD)
	uplatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory=$(BUILD) -jobname='$*' '$(MODEDEF)\input{$<}'
	dvipdfmx -o '$@' '$(BUILD)/$*.dvi'

# A4 縦 2ページを左右に並べ，JIS B4 横（364mm × 257mm）に縮小して面付けする
%.pdf: $(BUILD)/%.pdf
	pdfjam --quiet --nup 2x1 --papersize '{364mm,257mm}' --outfile '$@' '$<'

$(BUILD):
	mkdir -p $@

student:
	@$(MAKE) -B all MODE=student

teacher:
	@$(MAKE) -B all

clean:
	rm -rf $(BUILD)

.SECONDARY:
.PHONY: all student teacher clean
