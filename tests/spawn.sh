#!/bin/bash
# spawn.sh — caminos de lanzamiento de procesos de nyx-shell (std/process):
# redirecciones <, > y >>, pipelines de 2 y 3 etapas, comando inexistente
# (127), códigos de salida de hijos, y la salida de builtins redirigida.
# Usa `nyx-shell -c`, sin PTY.
STACK="$(cd "$(dirname "$0")/.." && pwd)"
BIN="${NYX_SHELL_BIN:-$STACK/nyx-shell}"
[ -x "$BIN" ] || { echo "SKIP: $BIN not built (make build)"; exit 0; }
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
cd "$T" || exit 1
printf 'b\na\n' > in.txt

pass=0; fail=0
# check NOMBRE "comando" "salida esperada" CODIGO_ESPERADO
check() {
    local name="$1" cmd="$2" want="$3" wantrc="$4" got rc
    got=$(timeout 20 "$BIN" -c "$cmd" </dev/null 2>&1); rc=$?
    if [ "$got" == "$want" ] && [ "$rc" == "$wantrc" ]; then
        pass=$((pass+1))
    else
        fail=$((fail+1))
        echo "FAIL: $name"; echo "  cmd:  $cmd"
        echo "  want: [$want] rc=$wantrc"; echo "  got:  [$got] rc=$rc"
    fi
}

check "redirect <"          'sort < in.txt'                          $'a\nb' 0
check "redirect >"          'echo hi > o.txt; cat o.txt'             'hi' 0
check "redirect > trunca"   'echo uno > o.txt; echo dos > o.txt; cat o.txt' 'dos' 0
check "redirect >>"         'echo uno > o.txt; echo dos >> o.txt; cat o.txt' $'uno\ndos' 0
check "externo con >"       '/bin/echo ext > e.txt; cat e.txt'       'ext' 0
check "externo con >>"      '/bin/echo a >> e2.txt; /bin/echo b >> e2.txt; cat e2.txt' $'a\nb' 0
check "pwd > archivo"       'pwd > p.txt; cat p.txt'                 "$T" 0
check "echo -n > archivo"   'echo -n abc > n.txt; cat n.txt'         'abc' 0
check "< y > juntos"        'sort < in.txt > s.txt; cat s.txt'       $'a\nb' 0
check "pipeline de 2"       'printf "b\na\n" | sort'                 $'a\nb' 0
check "pipeline de 3"       'printf "c\nb\na\n" | sort | head -n 2'  $'a\nb' 0
check "pipeline < y >"      'cat < in.txt | sort > p3.txt; cat p3.txt' $'a\nb' 0
check "pipeline >>"         'echo x > pa.txt; echo y | cat >> pa.txt; cat pa.txt' $'x\ny' 0
check "inexistente"         'nonexist_cmd_zz'     'nyx-shell: nonexist_cmd_zz: command not found' 127
check "inexistente en pipe" 'nonexist_cmd_zz | cat' 'nyx-shell: nonexist_cmd_zz: command not found' 127
check "inexistente al final" 'cat | nonexist_cmd_zz' 'nyx-shell: nonexist_cmd_zz: command not found' 127
check "no ejecutable"       '/etc/passwd'         'nyx-shell: /etc/passwd: exec failed' 126
check "salida 7"            'sh -c "exit 7"'      '' 7
check "salida de señal"     'sh -c "kill -9 \$\$"' '' 137
check "pipeline: código del último" 'sh -c "exit 7" | cat' '' 0
check "pipeline: último falla" 'cat < in.txt | sh -c "cat >/dev/null; exit 5"' '' 5
check "entrada inexistente" 'sort < nofile'       'nyx-shell: nofile: No such file or directory' 1
check "entrada inexistente en pipe" 'sort < nofile | cat' 'nyx-shell: nofile: No such file or directory' 1
check "salida no abre"      'echo a | cat > /nonexistent_dir/x' 'nyx-shell: /nonexistent_dir/x: Cannot open' 1
check "builtin salida no abre" 'echo x > /nonexistent_dir/x' 'nyx-shell: /nonexistent_dir/x: Cannot open' 1
check "&& tras éxito"       'true && echo si'     'si' 0
check "|| tras fallo"       'sh -c "exit 1" || echo cae' 'cae' 0

echo "spawn: $pass PASS, $fail FAIL"
[ "$fail" == 0 ]
