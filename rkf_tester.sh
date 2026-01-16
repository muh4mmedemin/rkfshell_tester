GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

LOG_FILE="rkfmlog.txt"

cleanup() {
    rm -f mini_out.txt minierr_out.txt bash_out.txt basherr_out.txt
}

run_test(){
	CMD="$1"
	touch mini_out.txt minierr_out.txt bash_out.txt basherr_out.txt $LOG_FILE
	echo -n "$CMD" | bash > bash_out.txt 2> basherr_out.txt
	EXIT_BASH=$?


	echo -n "$CMD" | .././minishell > mini_out.txt 2> minierr_out.txt
	EXIT_MINI=$?

	DIFF_OUT=$(diff bash_out.txt mini_out.txt)
	DIFF_ERR=$(diff basherr_out.txt minierr_out.txt)

	if [ "$DIFF_OUT" == "" ] && [ "$EXIT_BASH" -eq "$EXIT_MINI" ]; then
		echo -e "DIFF_OUT : ${GREEN}[OK]${RESET} : $CMD"
	else
		echo -e "DIFF_OUT : ${RED}[KO]${RESET} : $CMD"
		echo "----------------- HATA DETAYI -----------------" >> $LOG_FILE
		echo "Komut: $CMD" >> $LOG_FILE
		echo "--- Beklenen (BASH) ---" >> $LOG_FILE
		cat bash_out.txt >> $LOG_FILE
		echo "--- Alınan (MINISHELL) ---" >> $LOG_FILE
		cat mini_out.txt >> $LOG_FILE
		echo "--- Exit Kodları ---" >> $LOG_FILE
		echo "Bash: $EXIT_BASH | Mini: $EXIT_MINI" >> $LOG_FILE
		echo "--- Diff Value ---" >> $LOG_FILE
		echo "Çıktı Farkı: $DIFF_OUT" >> $LOG_FILE
		echo "-----------------------------------------------" >> $LOG_FILE
	fi
	cleanup
}
# Basic Test
echo "--- Basic Test ---"
run_test "ls"
run_test "pwd"
run_test "cat Makefile"

# Builtin Test
echo "--- Builtin Test ---"
run_test "echo selam ben"
run_test "echo -n hahahaha awdwdawdaw dw n-n-n--n-n"
run_test "echo"
run_test "echo -n"
run_test "echo -n-n-n-nn-n n"
run_test "echo -nnnnnnn -n -n -n -n -n -n -n -n -n -n -n -nnnnn-nnnnn bunu deneyen tosun "
run_test "echo -nnnnnnnnnnnnnnn"
run_test "export TEST=12313 | grep TEST"
run_test "export TEST | grep TEST"
run_test "export TEST=| grep TEST"
run_test "export TEST=12313 | grep TESTT"
run_test "export ş"
run_test "export =asdasdasdas"
run_test "export _test=test"
run_test "export _test=test | grep _test"
run_test "cd asdas aasasdas"
run_test "cd .."
run_test "cd /root/"
run_test "cd | cd asdas adsdasd"


# Pipe Test
run_test "cat Makefile | wc -l"
run_test "cat Makefile | wc -l | ls -a"
run_test "asdsadadad"
run_test "lsssss"
run_test ""
#run_test ""