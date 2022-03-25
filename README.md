# Golang1.16-Clang-Dalvik-branchmark
The branchmark was made on termux(app on android) on samsung galaxy tab s2 (android 7, aarch64). <br> 
run dalvik is according: https://computerbitsdaily.blogspot.com/2021/06/Run-Java-on-Android-Using-Termux.html.<br>
At begining I implemented naive algoritmus at these cases was golang faster than c++, after advise I was improve alg. and try again.<br> 
In final competition c++ is winning almost 1.69x  faster than single thread golang and 7.40x  faster than java, but golang have very easy paralerism (golang has easy concurency, but it can be transform to paral. easy too), therefore in this "cheating kategory" is winning golang 1.16 almost 1.75x single thread c++ and 13.08x faster than java......<br>

# conclusion
1. Although selection of language is important, the programing skills are the more important. 
2. The Golang is efficient enough to be core of android app.
