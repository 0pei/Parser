# Parser
### Environmental Setup
```
sudo apt install gcc flex bison python3 git
```
### Judge Score
```
python3 judge/judge.py
```
### Debug
```
make clean && make
./myparser < input/in01_arithmetic.c >| tmp.out
diff -y tmp.out answer/in01_arithmetic.out
```
