# 講義MODE ビルド
#   make          : A4 原稿（lecture.pdf）と B4 横 2面付け（lecture-b4.pdf）を作る
#   make student  : 生徒用（解答非表示）で作り直す
#   make teacher  : 教師用（解答表示）で作り直す
MAIN = lecture
DEPS = $(MAIN).tex lecture-preamble.tex common-preamble.tex

all: $(MAIN)-b4.pdf

$(MAIN).pdf: $(DEPS)
	uplatex -interaction=nonstopmode -file-line-error $(MAIN).tex
	dvipdfmx $(MAIN).dvi

# A4 縦 2ページを左右に並べ，JIS B4 横（364mm × 257mm）に縮小して面付けする
$(MAIN)-b4.pdf: $(MAIN).pdf
	pdfjam --quiet --nup 2x1 --papersize '{364mm,257mm}' --outfile $@ $<

student:
	@perl -i -pe 's/^\\showanswertrue/\\showanswerfalse/' common-preamble.tex
	@$(MAKE) -B all

teacher:
	@perl -i -pe 's/^\\showanswerfalse/\\showanswertrue/' common-preamble.tex
	@$(MAKE) -B all

clean:
	rm -f *.aux *.log *.dvi *.synctex.gz

.PHONY: all student teacher clean
