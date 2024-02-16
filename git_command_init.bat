chcp 65001
set LOGFILE="c:\1C_REPO_EDT\git_log_init.txt"
cd /D "c:\1C_REPO_GIT" >> %LOGFILE% 2>&1
git init >> %LOGFILE% 2>&1
git remote add origin https://kot-omka:HTJBui1234@github.com/kot-omka/TEDO >> %LOGFILE% 2>&1
git fetch origin >> %LOGFILE% 2>&1
git config --local core.quotepath false >> %LOGFILE% 2>&1
git config --local gui.encoding utf-8 >> %LOGFILE% 2>&1
git config --local i18n.commitEncoding utf-8 >> %LOGFILE% 2>&1
git config --local diff.renameLimit 1 >> %LOGFILE% 2>&1
git config --local diff.renames false >> %LOGFILE% 2>&1
git config --local core.autocrlf true >> %LOGFILE% 2>&1
git config --local core.safecrlf warn >> %LOGFILE% 2>&1
git status >> %LOGFILE% 2>&1
