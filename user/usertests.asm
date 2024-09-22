
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00009797          	auipc	a5,0x9
      14:	92878793          	addi	a5,a5,-1752 # 8938 <malloc+0x2494>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	739c                	ld	a5,32(a5)
      22:	fab43423          	sd	a1,-88(s0)
      26:	fac43823          	sd	a2,-80(s0)
      2a:	fad43c23          	sd	a3,-72(s0)
      2e:	fce43023          	sd	a4,-64(s0)
      32:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	00006097          	auipc	ra,0x6
      4e:	f7c080e7          	jalr	-132(ra) # 5fc6 <open>
    if(fd >= 0){
      52:	00055d63          	bgez	a0,6c <copyinstr1+0x6c>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      56:	04a1                	addi	s1,s1,8
      58:	ff4495e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      5c:	60e6                	ld	ra,88(sp)
      5e:	6446                	ld	s0,80(sp)
      60:	64a6                	ld	s1,72(sp)
      62:	6906                	ld	s2,64(sp)
      64:	79e2                	ld	s3,56(sp)
      66:	7a42                	ld	s4,48(sp)
      68:	6125                	addi	sp,sp,96
      6a:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      6c:	862a                	mv	a2,a0
      6e:	85ca                	mv	a1,s2
      70:	00006517          	auipc	a0,0x6
      74:	53050513          	addi	a0,a0,1328 # 65a0 <malloc+0xfc>
      78:	00006097          	auipc	ra,0x6
      7c:	370080e7          	jalr	880(ra) # 63e8 <printf>
      exit(1);
      80:	4505                	li	a0,1
      82:	00006097          	auipc	ra,0x6
      86:	f04080e7          	jalr	-252(ra) # 5f86 <exit>

000000000000008a <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      8a:	0000b797          	auipc	a5,0xb
      8e:	4de78793          	addi	a5,a5,1246 # b568 <uninit>
      92:	0000e697          	auipc	a3,0xe
      96:	be668693          	addi	a3,a3,-1050 # dc78 <buf>
    if(uninit[i] != '\0'){
      9a:	0007c703          	lbu	a4,0(a5)
      9e:	e709                	bnez	a4,a8 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      a0:	0785                	addi	a5,a5,1
      a2:	fed79ce3          	bne	a5,a3,9a <bsstest+0x10>
      a6:	8082                	ret
{
      a8:	1141                	addi	sp,sp,-16
      aa:	e406                	sd	ra,8(sp)
      ac:	e022                	sd	s0,0(sp)
      ae:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      b0:	85aa                	mv	a1,a0
      b2:	00006517          	auipc	a0,0x6
      b6:	50e50513          	addi	a0,a0,1294 # 65c0 <malloc+0x11c>
      ba:	00006097          	auipc	ra,0x6
      be:	32e080e7          	jalr	814(ra) # 63e8 <printf>
      exit(1);
      c2:	4505                	li	a0,1
      c4:	00006097          	auipc	ra,0x6
      c8:	ec2080e7          	jalr	-318(ra) # 5f86 <exit>

00000000000000cc <opentest>:
{
      cc:	1101                	addi	sp,sp,-32
      ce:	ec06                	sd	ra,24(sp)
      d0:	e822                	sd	s0,16(sp)
      d2:	e426                	sd	s1,8(sp)
      d4:	1000                	addi	s0,sp,32
      d6:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      d8:	4581                	li	a1,0
      da:	00006517          	auipc	a0,0x6
      de:	4fe50513          	addi	a0,a0,1278 # 65d8 <malloc+0x134>
      e2:	00006097          	auipc	ra,0x6
      e6:	ee4080e7          	jalr	-284(ra) # 5fc6 <open>
  if(fd < 0){
      ea:	02054663          	bltz	a0,116 <opentest+0x4a>
  close(fd);
      ee:	00006097          	auipc	ra,0x6
      f2:	ec0080e7          	jalr	-320(ra) # 5fae <close>
  fd = open("doesnotexist", 0);
      f6:	4581                	li	a1,0
      f8:	00006517          	auipc	a0,0x6
      fc:	50050513          	addi	a0,a0,1280 # 65f8 <malloc+0x154>
     100:	00006097          	auipc	ra,0x6
     104:	ec6080e7          	jalr	-314(ra) # 5fc6 <open>
  if(fd >= 0){
     108:	02055563          	bgez	a0,132 <opentest+0x66>
}
     10c:	60e2                	ld	ra,24(sp)
     10e:	6442                	ld	s0,16(sp)
     110:	64a2                	ld	s1,8(sp)
     112:	6105                	addi	sp,sp,32
     114:	8082                	ret
    printf("%s: open echo failed!\n", s);
     116:	85a6                	mv	a1,s1
     118:	00006517          	auipc	a0,0x6
     11c:	4c850513          	addi	a0,a0,1224 # 65e0 <malloc+0x13c>
     120:	00006097          	auipc	ra,0x6
     124:	2c8080e7          	jalr	712(ra) # 63e8 <printf>
    exit(1);
     128:	4505                	li	a0,1
     12a:	00006097          	auipc	ra,0x6
     12e:	e5c080e7          	jalr	-420(ra) # 5f86 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     132:	85a6                	mv	a1,s1
     134:	00006517          	auipc	a0,0x6
     138:	4d450513          	addi	a0,a0,1236 # 6608 <malloc+0x164>
     13c:	00006097          	auipc	ra,0x6
     140:	2ac080e7          	jalr	684(ra) # 63e8 <printf>
    exit(1);
     144:	4505                	li	a0,1
     146:	00006097          	auipc	ra,0x6
     14a:	e40080e7          	jalr	-448(ra) # 5f86 <exit>

000000000000014e <truncate2>:
{
     14e:	7179                	addi	sp,sp,-48
     150:	f406                	sd	ra,40(sp)
     152:	f022                	sd	s0,32(sp)
     154:	ec26                	sd	s1,24(sp)
     156:	e84a                	sd	s2,16(sp)
     158:	e44e                	sd	s3,8(sp)
     15a:	1800                	addi	s0,sp,48
     15c:	89aa                	mv	s3,a0
  unlink("truncfile");
     15e:	00006517          	auipc	a0,0x6
     162:	4d250513          	addi	a0,a0,1234 # 6630 <malloc+0x18c>
     166:	00006097          	auipc	ra,0x6
     16a:	e70080e7          	jalr	-400(ra) # 5fd6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     16e:	60100593          	li	a1,1537
     172:	00006517          	auipc	a0,0x6
     176:	4be50513          	addi	a0,a0,1214 # 6630 <malloc+0x18c>
     17a:	00006097          	auipc	ra,0x6
     17e:	e4c080e7          	jalr	-436(ra) # 5fc6 <open>
     182:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     184:	4611                	li	a2,4
     186:	00006597          	auipc	a1,0x6
     18a:	4ba58593          	addi	a1,a1,1210 # 6640 <malloc+0x19c>
     18e:	00006097          	auipc	ra,0x6
     192:	e18080e7          	jalr	-488(ra) # 5fa6 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     196:	40100593          	li	a1,1025
     19a:	00006517          	auipc	a0,0x6
     19e:	49650513          	addi	a0,a0,1174 # 6630 <malloc+0x18c>
     1a2:	00006097          	auipc	ra,0x6
     1a6:	e24080e7          	jalr	-476(ra) # 5fc6 <open>
     1aa:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     1ac:	4605                	li	a2,1
     1ae:	00006597          	auipc	a1,0x6
     1b2:	49a58593          	addi	a1,a1,1178 # 6648 <malloc+0x1a4>
     1b6:	8526                	mv	a0,s1
     1b8:	00006097          	auipc	ra,0x6
     1bc:	dee080e7          	jalr	-530(ra) # 5fa6 <write>
  if(n != -1){
     1c0:	57fd                	li	a5,-1
     1c2:	02f51b63          	bne	a0,a5,1f8 <truncate2+0xaa>
  unlink("truncfile");
     1c6:	00006517          	auipc	a0,0x6
     1ca:	46a50513          	addi	a0,a0,1130 # 6630 <malloc+0x18c>
     1ce:	00006097          	auipc	ra,0x6
     1d2:	e08080e7          	jalr	-504(ra) # 5fd6 <unlink>
  close(fd1);
     1d6:	8526                	mv	a0,s1
     1d8:	00006097          	auipc	ra,0x6
     1dc:	dd6080e7          	jalr	-554(ra) # 5fae <close>
  close(fd2);
     1e0:	854a                	mv	a0,s2
     1e2:	00006097          	auipc	ra,0x6
     1e6:	dcc080e7          	jalr	-564(ra) # 5fae <close>
}
     1ea:	70a2                	ld	ra,40(sp)
     1ec:	7402                	ld	s0,32(sp)
     1ee:	64e2                	ld	s1,24(sp)
     1f0:	6942                	ld	s2,16(sp)
     1f2:	69a2                	ld	s3,8(sp)
     1f4:	6145                	addi	sp,sp,48
     1f6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1f8:	862a                	mv	a2,a0
     1fa:	85ce                	mv	a1,s3
     1fc:	00006517          	auipc	a0,0x6
     200:	45450513          	addi	a0,a0,1108 # 6650 <malloc+0x1ac>
     204:	00006097          	auipc	ra,0x6
     208:	1e4080e7          	jalr	484(ra) # 63e8 <printf>
    exit(1);
     20c:	4505                	li	a0,1
     20e:	00006097          	auipc	ra,0x6
     212:	d78080e7          	jalr	-648(ra) # 5f86 <exit>

0000000000000216 <createtest>:
{
     216:	7139                	addi	sp,sp,-64
     218:	fc06                	sd	ra,56(sp)
     21a:	f822                	sd	s0,48(sp)
     21c:	f426                	sd	s1,40(sp)
     21e:	f04a                	sd	s2,32(sp)
     220:	ec4e                	sd	s3,24(sp)
     222:	e852                	sd	s4,16(sp)
     224:	0080                	addi	s0,sp,64
  name[0] = 'a';
     226:	06100793          	li	a5,97
     22a:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     22e:	fc040523          	sb	zero,-54(s0)
     232:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     236:	fc840a13          	addi	s4,s0,-56
     23a:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     23e:	06400913          	li	s2,100
    name[1] = '0' + i;
     242:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     246:	85ce                	mv	a1,s3
     248:	8552                	mv	a0,s4
     24a:	00006097          	auipc	ra,0x6
     24e:	d7c080e7          	jalr	-644(ra) # 5fc6 <open>
    close(fd);
     252:	00006097          	auipc	ra,0x6
     256:	d5c080e7          	jalr	-676(ra) # 5fae <close>
  for(i = 0; i < N; i++){
     25a:	2485                	addiw	s1,s1,1
     25c:	0ff4f493          	zext.b	s1,s1
     260:	ff2491e3          	bne	s1,s2,242 <createtest+0x2c>
  name[0] = 'a';
     264:	06100793          	li	a5,97
     268:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     26c:	fc040523          	sb	zero,-54(s0)
     270:	03000493          	li	s1,48
    unlink(name);
     274:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     278:	06400913          	li	s2,100
    name[1] = '0' + i;
     27c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     280:	854e                	mv	a0,s3
     282:	00006097          	auipc	ra,0x6
     286:	d54080e7          	jalr	-684(ra) # 5fd6 <unlink>
  for(i = 0; i < N; i++){
     28a:	2485                	addiw	s1,s1,1
     28c:	0ff4f493          	zext.b	s1,s1
     290:	ff2496e3          	bne	s1,s2,27c <createtest+0x66>
}
     294:	70e2                	ld	ra,56(sp)
     296:	7442                	ld	s0,48(sp)
     298:	74a2                	ld	s1,40(sp)
     29a:	7902                	ld	s2,32(sp)
     29c:	69e2                	ld	s3,24(sp)
     29e:	6a42                	ld	s4,16(sp)
     2a0:	6121                	addi	sp,sp,64
     2a2:	8082                	ret

00000000000002a4 <bigwrite>:
{
     2a4:	715d                	addi	sp,sp,-80
     2a6:	e486                	sd	ra,72(sp)
     2a8:	e0a2                	sd	s0,64(sp)
     2aa:	fc26                	sd	s1,56(sp)
     2ac:	f84a                	sd	s2,48(sp)
     2ae:	f44e                	sd	s3,40(sp)
     2b0:	f052                	sd	s4,32(sp)
     2b2:	ec56                	sd	s5,24(sp)
     2b4:	e85a                	sd	s6,16(sp)
     2b6:	e45e                	sd	s7,8(sp)
     2b8:	e062                	sd	s8,0(sp)
     2ba:	0880                	addi	s0,sp,80
     2bc:	8c2a                	mv	s8,a0
  unlink("bigwrite");
     2be:	00006517          	auipc	a0,0x6
     2c2:	3ba50513          	addi	a0,a0,954 # 6678 <malloc+0x1d4>
     2c6:	00006097          	auipc	ra,0x6
     2ca:	d10080e7          	jalr	-752(ra) # 5fd6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2ce:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2d2:	20200b93          	li	s7,514
     2d6:	00006a97          	auipc	s5,0x6
     2da:	3a2a8a93          	addi	s5,s5,930 # 6678 <malloc+0x1d4>
      int cc = write(fd, buf, sz);
     2de:	0000ea17          	auipc	s4,0xe
     2e2:	99aa0a13          	addi	s4,s4,-1638 # dc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2e6:	6b0d                	lui	s6,0x3
     2e8:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x97>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ec:	85de                	mv	a1,s7
     2ee:	8556                	mv	a0,s5
     2f0:	00006097          	auipc	ra,0x6
     2f4:	cd6080e7          	jalr	-810(ra) # 5fc6 <open>
     2f8:	892a                	mv	s2,a0
    if(fd < 0){
     2fa:	04054e63          	bltz	a0,356 <bigwrite+0xb2>
      int cc = write(fd, buf, sz);
     2fe:	8626                	mv	a2,s1
     300:	85d2                	mv	a1,s4
     302:	00006097          	auipc	ra,0x6
     306:	ca4080e7          	jalr	-860(ra) # 5fa6 <write>
     30a:	89aa                	mv	s3,a0
      if(cc != sz){
     30c:	06a49363          	bne	s1,a0,372 <bigwrite+0xce>
      int cc = write(fd, buf, sz);
     310:	8626                	mv	a2,s1
     312:	85d2                	mv	a1,s4
     314:	854a                	mv	a0,s2
     316:	00006097          	auipc	ra,0x6
     31a:	c90080e7          	jalr	-880(ra) # 5fa6 <write>
      if(cc != sz){
     31e:	04951b63          	bne	a0,s1,374 <bigwrite+0xd0>
    close(fd);
     322:	854a                	mv	a0,s2
     324:	00006097          	auipc	ra,0x6
     328:	c8a080e7          	jalr	-886(ra) # 5fae <close>
    unlink("bigwrite");
     32c:	8556                	mv	a0,s5
     32e:	00006097          	auipc	ra,0x6
     332:	ca8080e7          	jalr	-856(ra) # 5fd6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     336:	1d74849b          	addiw	s1,s1,471
     33a:	fb6499e3          	bne	s1,s6,2ec <bigwrite+0x48>
}
     33e:	60a6                	ld	ra,72(sp)
     340:	6406                	ld	s0,64(sp)
     342:	74e2                	ld	s1,56(sp)
     344:	7942                	ld	s2,48(sp)
     346:	79a2                	ld	s3,40(sp)
     348:	7a02                	ld	s4,32(sp)
     34a:	6ae2                	ld	s5,24(sp)
     34c:	6b42                	ld	s6,16(sp)
     34e:	6ba2                	ld	s7,8(sp)
     350:	6c02                	ld	s8,0(sp)
     352:	6161                	addi	sp,sp,80
     354:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     356:	85e2                	mv	a1,s8
     358:	00006517          	auipc	a0,0x6
     35c:	33050513          	addi	a0,a0,816 # 6688 <malloc+0x1e4>
     360:	00006097          	auipc	ra,0x6
     364:	088080e7          	jalr	136(ra) # 63e8 <printf>
      exit(1);
     368:	4505                	li	a0,1
     36a:	00006097          	auipc	ra,0x6
     36e:	c1c080e7          	jalr	-996(ra) # 5f86 <exit>
      if(cc != sz){
     372:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     374:	86aa                	mv	a3,a0
     376:	864e                	mv	a2,s3
     378:	85e2                	mv	a1,s8
     37a:	00006517          	auipc	a0,0x6
     37e:	32e50513          	addi	a0,a0,814 # 66a8 <malloc+0x204>
     382:	00006097          	auipc	ra,0x6
     386:	066080e7          	jalr	102(ra) # 63e8 <printf>
        exit(1);
     38a:	4505                	li	a0,1
     38c:	00006097          	auipc	ra,0x6
     390:	bfa080e7          	jalr	-1030(ra) # 5f86 <exit>

0000000000000394 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     394:	7139                	addi	sp,sp,-64
     396:	fc06                	sd	ra,56(sp)
     398:	f822                	sd	s0,48(sp)
     39a:	f426                	sd	s1,40(sp)
     39c:	f04a                	sd	s2,32(sp)
     39e:	ec4e                	sd	s3,24(sp)
     3a0:	e852                	sd	s4,16(sp)
     3a2:	e456                	sd	s5,8(sp)
     3a4:	e05a                	sd	s6,0(sp)
     3a6:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     3a8:	00006517          	auipc	a0,0x6
     3ac:	31850513          	addi	a0,a0,792 # 66c0 <malloc+0x21c>
     3b0:	00006097          	auipc	ra,0x6
     3b4:	c26080e7          	jalr	-986(ra) # 5fd6 <unlink>
     3b8:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100a93          	li	s5,513
     3c0:	00006997          	auipc	s3,0x6
     3c4:	30098993          	addi	s3,s3,768 # 66c0 <malloc+0x21c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     3c8:	4b05                	li	s6,1
     3ca:	5a7d                	li	s4,-1
     3cc:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     3d0:	85d6                	mv	a1,s5
     3d2:	854e                	mv	a0,s3
     3d4:	00006097          	auipc	ra,0x6
     3d8:	bf2080e7          	jalr	-1038(ra) # 5fc6 <open>
     3dc:	84aa                	mv	s1,a0
    if(fd < 0){
     3de:	06054b63          	bltz	a0,454 <badwrite+0xc0>
    write(fd, (char*)0xffffffffffL, 1);
     3e2:	865a                	mv	a2,s6
     3e4:	85d2                	mv	a1,s4
     3e6:	00006097          	auipc	ra,0x6
     3ea:	bc0080e7          	jalr	-1088(ra) # 5fa6 <write>
    close(fd);
     3ee:	8526                	mv	a0,s1
     3f0:	00006097          	auipc	ra,0x6
     3f4:	bbe080e7          	jalr	-1090(ra) # 5fae <close>
    unlink("junk");
     3f8:	854e                	mv	a0,s3
     3fa:	00006097          	auipc	ra,0x6
     3fe:	bdc080e7          	jalr	-1060(ra) # 5fd6 <unlink>
  for(int i = 0; i < assumed_free; i++){
     402:	397d                	addiw	s2,s2,-1
     404:	fc0916e3          	bnez	s2,3d0 <badwrite+0x3c>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     408:	20100593          	li	a1,513
     40c:	00006517          	auipc	a0,0x6
     410:	2b450513          	addi	a0,a0,692 # 66c0 <malloc+0x21c>
     414:	00006097          	auipc	ra,0x6
     418:	bb2080e7          	jalr	-1102(ra) # 5fc6 <open>
     41c:	84aa                	mv	s1,a0
  if(fd < 0){
     41e:	04054863          	bltz	a0,46e <badwrite+0xda>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     422:	4605                	li	a2,1
     424:	00006597          	auipc	a1,0x6
     428:	22458593          	addi	a1,a1,548 # 6648 <malloc+0x1a4>
     42c:	00006097          	auipc	ra,0x6
     430:	b7a080e7          	jalr	-1158(ra) # 5fa6 <write>
     434:	4785                	li	a5,1
     436:	04f50963          	beq	a0,a5,488 <badwrite+0xf4>
    printf("write failed\n");
     43a:	00006517          	auipc	a0,0x6
     43e:	2a650513          	addi	a0,a0,678 # 66e0 <malloc+0x23c>
     442:	00006097          	auipc	ra,0x6
     446:	fa6080e7          	jalr	-90(ra) # 63e8 <printf>
    exit(1);
     44a:	4505                	li	a0,1
     44c:	00006097          	auipc	ra,0x6
     450:	b3a080e7          	jalr	-1222(ra) # 5f86 <exit>
      printf("open junk failed\n");
     454:	00006517          	auipc	a0,0x6
     458:	27450513          	addi	a0,a0,628 # 66c8 <malloc+0x224>
     45c:	00006097          	auipc	ra,0x6
     460:	f8c080e7          	jalr	-116(ra) # 63e8 <printf>
      exit(1);
     464:	4505                	li	a0,1
     466:	00006097          	auipc	ra,0x6
     46a:	b20080e7          	jalr	-1248(ra) # 5f86 <exit>
    printf("open junk failed\n");
     46e:	00006517          	auipc	a0,0x6
     472:	25a50513          	addi	a0,a0,602 # 66c8 <malloc+0x224>
     476:	00006097          	auipc	ra,0x6
     47a:	f72080e7          	jalr	-142(ra) # 63e8 <printf>
    exit(1);
     47e:	4505                	li	a0,1
     480:	00006097          	auipc	ra,0x6
     484:	b06080e7          	jalr	-1274(ra) # 5f86 <exit>
  }
  close(fd);
     488:	8526                	mv	a0,s1
     48a:	00006097          	auipc	ra,0x6
     48e:	b24080e7          	jalr	-1244(ra) # 5fae <close>
  unlink("junk");
     492:	00006517          	auipc	a0,0x6
     496:	22e50513          	addi	a0,a0,558 # 66c0 <malloc+0x21c>
     49a:	00006097          	auipc	ra,0x6
     49e:	b3c080e7          	jalr	-1220(ra) # 5fd6 <unlink>

  exit(0);
     4a2:	4501                	li	a0,0
     4a4:	00006097          	auipc	ra,0x6
     4a8:	ae2080e7          	jalr	-1310(ra) # 5f86 <exit>

00000000000004ac <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     4be:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     4c0:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     4c4:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4c8:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     4cc:	40000a93          	li	s5,1024
    name[0] = 'z';
     4d0:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     4d4:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     4d8:	41f4d71b          	sraiw	a4,s1,0x1f
     4dc:	01b7571b          	srliw	a4,a4,0x1b
     4e0:	009707bb          	addw	a5,a4,s1
     4e4:	4057d69b          	sraiw	a3,a5,0x5
     4e8:	0306869b          	addiw	a3,a3,48
     4ec:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     4f0:	8bfd                	andi	a5,a5,31
     4f2:	9f99                	subw	a5,a5,a4
     4f4:	0307879b          	addiw	a5,a5,48
     4f8:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     4fc:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     500:	854a                	mv	a0,s2
     502:	00006097          	auipc	ra,0x6
     506:	ad4080e7          	jalr	-1324(ra) # 5fd6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     50a:	85d2                	mv	a1,s4
     50c:	854a                	mv	a0,s2
     50e:	00006097          	auipc	ra,0x6
     512:	ab8080e7          	jalr	-1352(ra) # 5fc6 <open>
    if(fd < 0){
     516:	00054963          	bltz	a0,528 <outofinodes+0x7c>
      // failure is eventually expected.
      break;
    }
    close(fd);
     51a:	00006097          	auipc	ra,0x6
     51e:	a94080e7          	jalr	-1388(ra) # 5fae <close>
  for(int i = 0; i < nzz; i++){
     522:	2485                	addiw	s1,s1,1
     524:	fb5496e3          	bne	s1,s5,4d0 <outofinodes+0x24>
     528:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     52a:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     52e:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     532:	40000993          	li	s3,1024
    name[0] = 'z';
     536:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     53a:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     53e:	41f4d71b          	sraiw	a4,s1,0x1f
     542:	01b7571b          	srliw	a4,a4,0x1b
     546:	009707bb          	addw	a5,a4,s1
     54a:	4057d69b          	sraiw	a3,a5,0x5
     54e:	0306869b          	addiw	a3,a3,48
     552:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     556:	8bfd                	andi	a5,a5,31
     558:	9f99                	subw	a5,a5,a4
     55a:	0307879b          	addiw	a5,a5,48
     55e:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     562:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     566:	8552                	mv	a0,s4
     568:	00006097          	auipc	ra,0x6
     56c:	a6e080e7          	jalr	-1426(ra) # 5fd6 <unlink>
  for(int i = 0; i < nzz; i++){
     570:	2485                	addiw	s1,s1,1
     572:	fd3492e3          	bne	s1,s3,536 <outofinodes+0x8a>
  }
}
     576:	60e6                	ld	ra,88(sp)
     578:	6446                	ld	s0,80(sp)
     57a:	64a6                	ld	s1,72(sp)
     57c:	6906                	ld	s2,64(sp)
     57e:	79e2                	ld	s3,56(sp)
     580:	7a42                	ld	s4,48(sp)
     582:	7aa2                	ld	s5,40(sp)
     584:	6125                	addi	sp,sp,96
     586:	8082                	ret

0000000000000588 <copyin>:
{
     588:	7175                	addi	sp,sp,-144
     58a:	e506                	sd	ra,136(sp)
     58c:	e122                	sd	s0,128(sp)
     58e:	fca6                	sd	s1,120(sp)
     590:	f8ca                	sd	s2,112(sp)
     592:	f4ce                	sd	s3,104(sp)
     594:	f0d2                	sd	s4,96(sp)
     596:	ecd6                	sd	s5,88(sp)
     598:	e8da                	sd	s6,80(sp)
     59a:	e4de                	sd	s7,72(sp)
     59c:	e0e2                	sd	s8,64(sp)
     59e:	fc66                	sd	s9,56(sp)
     5a0:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5a2:	00008797          	auipc	a5,0x8
     5a6:	39678793          	addi	a5,a5,918 # 8938 <malloc+0x2494>
     5aa:	638c                	ld	a1,0(a5)
     5ac:	6790                	ld	a2,8(a5)
     5ae:	6b94                	ld	a3,16(a5)
     5b0:	6f98                	ld	a4,24(a5)
     5b2:	739c                	ld	a5,32(a5)
     5b4:	f6b43c23          	sd	a1,-136(s0)
     5b8:	f8c43023          	sd	a2,-128(s0)
     5bc:	f8d43423          	sd	a3,-120(s0)
     5c0:	f8e43823          	sd	a4,-112(s0)
     5c4:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5c8:	f7840913          	addi	s2,s0,-136
     5cc:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5d0:	20100b13          	li	s6,513
     5d4:	00006a97          	auipc	s5,0x6
     5d8:	11ca8a93          	addi	s5,s5,284 # 66f0 <malloc+0x24c>
    int n = write(fd, (void*)addr, 8192);
     5dc:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     5de:	4c05                	li	s8,1
    if(pipe(fds) < 0){
     5e0:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     5e4:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5e8:	85da                	mv	a1,s6
     5ea:	8556                	mv	a0,s5
     5ec:	00006097          	auipc	ra,0x6
     5f0:	9da080e7          	jalr	-1574(ra) # 5fc6 <open>
     5f4:	84aa                	mv	s1,a0
    if(fd < 0){
     5f6:	08054a63          	bltz	a0,68a <copyin+0x102>
    int n = write(fd, (void*)addr, 8192);
     5fa:	8652                	mv	a2,s4
     5fc:	85ce                	mv	a1,s3
     5fe:	00006097          	auipc	ra,0x6
     602:	9a8080e7          	jalr	-1624(ra) # 5fa6 <write>
    if(n >= 0){
     606:	08055f63          	bgez	a0,6a4 <copyin+0x11c>
    close(fd);
     60a:	8526                	mv	a0,s1
     60c:	00006097          	auipc	ra,0x6
     610:	9a2080e7          	jalr	-1630(ra) # 5fae <close>
    unlink("copyin1");
     614:	8556                	mv	a0,s5
     616:	00006097          	auipc	ra,0x6
     61a:	9c0080e7          	jalr	-1600(ra) # 5fd6 <unlink>
    n = write(1, (char*)addr, 8192);
     61e:	8652                	mv	a2,s4
     620:	85ce                	mv	a1,s3
     622:	8562                	mv	a0,s8
     624:	00006097          	auipc	ra,0x6
     628:	982080e7          	jalr	-1662(ra) # 5fa6 <write>
    if(n > 0){
     62c:	08a04b63          	bgtz	a0,6c2 <copyin+0x13a>
    if(pipe(fds) < 0){
     630:	855e                	mv	a0,s7
     632:	00006097          	auipc	ra,0x6
     636:	964080e7          	jalr	-1692(ra) # 5f96 <pipe>
     63a:	0a054363          	bltz	a0,6e0 <copyin+0x158>
    n = write(fds[1], (char*)addr, 8192);
     63e:	8652                	mv	a2,s4
     640:	85ce                	mv	a1,s3
     642:	f7442503          	lw	a0,-140(s0)
     646:	00006097          	auipc	ra,0x6
     64a:	960080e7          	jalr	-1696(ra) # 5fa6 <write>
    if(n > 0){
     64e:	0aa04663          	bgtz	a0,6fa <copyin+0x172>
    close(fds[0]);
     652:	f7042503          	lw	a0,-144(s0)
     656:	00006097          	auipc	ra,0x6
     65a:	958080e7          	jalr	-1704(ra) # 5fae <close>
    close(fds[1]);
     65e:	f7442503          	lw	a0,-140(s0)
     662:	00006097          	auipc	ra,0x6
     666:	94c080e7          	jalr	-1716(ra) # 5fae <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     66a:	0921                	addi	s2,s2,8
     66c:	f7991ce3          	bne	s2,s9,5e4 <copyin+0x5c>
}
     670:	60aa                	ld	ra,136(sp)
     672:	640a                	ld	s0,128(sp)
     674:	74e6                	ld	s1,120(sp)
     676:	7946                	ld	s2,112(sp)
     678:	79a6                	ld	s3,104(sp)
     67a:	7a06                	ld	s4,96(sp)
     67c:	6ae6                	ld	s5,88(sp)
     67e:	6b46                	ld	s6,80(sp)
     680:	6ba6                	ld	s7,72(sp)
     682:	6c06                	ld	s8,64(sp)
     684:	7ce2                	ld	s9,56(sp)
     686:	6149                	addi	sp,sp,144
     688:	8082                	ret
      printf("open(copyin1) failed\n");
     68a:	00006517          	auipc	a0,0x6
     68e:	06e50513          	addi	a0,a0,110 # 66f8 <malloc+0x254>
     692:	00006097          	auipc	ra,0x6
     696:	d56080e7          	jalr	-682(ra) # 63e8 <printf>
      exit(1);
     69a:	4505                	li	a0,1
     69c:	00006097          	auipc	ra,0x6
     6a0:	8ea080e7          	jalr	-1814(ra) # 5f86 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     6a4:	862a                	mv	a2,a0
     6a6:	85ce                	mv	a1,s3
     6a8:	00006517          	auipc	a0,0x6
     6ac:	06850513          	addi	a0,a0,104 # 6710 <malloc+0x26c>
     6b0:	00006097          	auipc	ra,0x6
     6b4:	d38080e7          	jalr	-712(ra) # 63e8 <printf>
      exit(1);
     6b8:	4505                	li	a0,1
     6ba:	00006097          	auipc	ra,0x6
     6be:	8cc080e7          	jalr	-1844(ra) # 5f86 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6c2:	862a                	mv	a2,a0
     6c4:	85ce                	mv	a1,s3
     6c6:	00006517          	auipc	a0,0x6
     6ca:	07a50513          	addi	a0,a0,122 # 6740 <malloc+0x29c>
     6ce:	00006097          	auipc	ra,0x6
     6d2:	d1a080e7          	jalr	-742(ra) # 63e8 <printf>
      exit(1);
     6d6:	4505                	li	a0,1
     6d8:	00006097          	auipc	ra,0x6
     6dc:	8ae080e7          	jalr	-1874(ra) # 5f86 <exit>
      printf("pipe() failed\n");
     6e0:	00006517          	auipc	a0,0x6
     6e4:	09050513          	addi	a0,a0,144 # 6770 <malloc+0x2cc>
     6e8:	00006097          	auipc	ra,0x6
     6ec:	d00080e7          	jalr	-768(ra) # 63e8 <printf>
      exit(1);
     6f0:	4505                	li	a0,1
     6f2:	00006097          	auipc	ra,0x6
     6f6:	894080e7          	jalr	-1900(ra) # 5f86 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6fa:	862a                	mv	a2,a0
     6fc:	85ce                	mv	a1,s3
     6fe:	00006517          	auipc	a0,0x6
     702:	08250513          	addi	a0,a0,130 # 6780 <malloc+0x2dc>
     706:	00006097          	auipc	ra,0x6
     70a:	ce2080e7          	jalr	-798(ra) # 63e8 <printf>
      exit(1);
     70e:	4505                	li	a0,1
     710:	00006097          	auipc	ra,0x6
     714:	876080e7          	jalr	-1930(ra) # 5f86 <exit>

0000000000000718 <copyout>:
{
     718:	7135                	addi	sp,sp,-160
     71a:	ed06                	sd	ra,152(sp)
     71c:	e922                	sd	s0,144(sp)
     71e:	e526                	sd	s1,136(sp)
     720:	e14a                	sd	s2,128(sp)
     722:	fcce                	sd	s3,120(sp)
     724:	f8d2                	sd	s4,112(sp)
     726:	f4d6                	sd	s5,104(sp)
     728:	f0da                	sd	s6,96(sp)
     72a:	ecde                	sd	s7,88(sp)
     72c:	e8e2                	sd	s8,80(sp)
     72e:	e4e6                	sd	s9,72(sp)
     730:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     732:	00008797          	auipc	a5,0x8
     736:	20678793          	addi	a5,a5,518 # 8938 <malloc+0x2494>
     73a:	7788                	ld	a0,40(a5)
     73c:	7b8c                	ld	a1,48(a5)
     73e:	7f90                	ld	a2,56(a5)
     740:	63b4                	ld	a3,64(a5)
     742:	67b8                	ld	a4,72(a5)
     744:	6bbc                	ld	a5,80(a5)
     746:	f6a43823          	sd	a0,-144(s0)
     74a:	f6b43c23          	sd	a1,-136(s0)
     74e:	f8c43023          	sd	a2,-128(s0)
     752:	f8d43423          	sd	a3,-120(s0)
     756:	f8e43823          	sd	a4,-112(s0)
     75a:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     75e:	f7040913          	addi	s2,s0,-144
     762:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     766:	00006b17          	auipc	s6,0x6
     76a:	04ab0b13          	addi	s6,s6,74 # 67b0 <malloc+0x30c>
    int n = read(fd, (void*)addr, 8192);
     76e:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     770:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     774:	4a05                	li	s4,1
     776:	00006b97          	auipc	s7,0x6
     77a:	ed2b8b93          	addi	s7,s7,-302 # 6648 <malloc+0x1a4>
    uint64 addr = addrs[ai];
     77e:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     782:	4581                	li	a1,0
     784:	855a                	mv	a0,s6
     786:	00006097          	auipc	ra,0x6
     78a:	840080e7          	jalr	-1984(ra) # 5fc6 <open>
     78e:	84aa                	mv	s1,a0
    if(fd < 0){
     790:	08054663          	bltz	a0,81c <copyout+0x104>
    int n = read(fd, (void*)addr, 8192);
     794:	8656                	mv	a2,s5
     796:	85ce                	mv	a1,s3
     798:	00006097          	auipc	ra,0x6
     79c:	806080e7          	jalr	-2042(ra) # 5f9e <read>
    if(n > 0){
     7a0:	08a04b63          	bgtz	a0,836 <copyout+0x11e>
    close(fd);
     7a4:	8526                	mv	a0,s1
     7a6:	00006097          	auipc	ra,0x6
     7aa:	808080e7          	jalr	-2040(ra) # 5fae <close>
    if(pipe(fds) < 0){
     7ae:	8562                	mv	a0,s8
     7b0:	00005097          	auipc	ra,0x5
     7b4:	7e6080e7          	jalr	2022(ra) # 5f96 <pipe>
     7b8:	08054e63          	bltz	a0,854 <copyout+0x13c>
    n = write(fds[1], "x", 1);
     7bc:	8652                	mv	a2,s4
     7be:	85de                	mv	a1,s7
     7c0:	f6c42503          	lw	a0,-148(s0)
     7c4:	00005097          	auipc	ra,0x5
     7c8:	7e2080e7          	jalr	2018(ra) # 5fa6 <write>
    if(n != 1){
     7cc:	0b451163          	bne	a0,s4,86e <copyout+0x156>
    n = read(fds[0], (void*)addr, 8192);
     7d0:	8656                	mv	a2,s5
     7d2:	85ce                	mv	a1,s3
     7d4:	f6842503          	lw	a0,-152(s0)
     7d8:	00005097          	auipc	ra,0x5
     7dc:	7c6080e7          	jalr	1990(ra) # 5f9e <read>
    if(n > 0){
     7e0:	0aa04463          	bgtz	a0,888 <copyout+0x170>
    close(fds[0]);
     7e4:	f6842503          	lw	a0,-152(s0)
     7e8:	00005097          	auipc	ra,0x5
     7ec:	7c6080e7          	jalr	1990(ra) # 5fae <close>
    close(fds[1]);
     7f0:	f6c42503          	lw	a0,-148(s0)
     7f4:	00005097          	auipc	ra,0x5
     7f8:	7ba080e7          	jalr	1978(ra) # 5fae <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     7fc:	0921                	addi	s2,s2,8
     7fe:	f99910e3          	bne	s2,s9,77e <copyout+0x66>
}
     802:	60ea                	ld	ra,152(sp)
     804:	644a                	ld	s0,144(sp)
     806:	64aa                	ld	s1,136(sp)
     808:	690a                	ld	s2,128(sp)
     80a:	79e6                	ld	s3,120(sp)
     80c:	7a46                	ld	s4,112(sp)
     80e:	7aa6                	ld	s5,104(sp)
     810:	7b06                	ld	s6,96(sp)
     812:	6be6                	ld	s7,88(sp)
     814:	6c46                	ld	s8,80(sp)
     816:	6ca6                	ld	s9,72(sp)
     818:	610d                	addi	sp,sp,160
     81a:	8082                	ret
      printf("open(README) failed\n");
     81c:	00006517          	auipc	a0,0x6
     820:	f9c50513          	addi	a0,a0,-100 # 67b8 <malloc+0x314>
     824:	00006097          	auipc	ra,0x6
     828:	bc4080e7          	jalr	-1084(ra) # 63e8 <printf>
      exit(1);
     82c:	4505                	li	a0,1
     82e:	00005097          	auipc	ra,0x5
     832:	758080e7          	jalr	1880(ra) # 5f86 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     836:	862a                	mv	a2,a0
     838:	85ce                	mv	a1,s3
     83a:	00006517          	auipc	a0,0x6
     83e:	f9650513          	addi	a0,a0,-106 # 67d0 <malloc+0x32c>
     842:	00006097          	auipc	ra,0x6
     846:	ba6080e7          	jalr	-1114(ra) # 63e8 <printf>
      exit(1);
     84a:	4505                	li	a0,1
     84c:	00005097          	auipc	ra,0x5
     850:	73a080e7          	jalr	1850(ra) # 5f86 <exit>
      printf("pipe() failed\n");
     854:	00006517          	auipc	a0,0x6
     858:	f1c50513          	addi	a0,a0,-228 # 6770 <malloc+0x2cc>
     85c:	00006097          	auipc	ra,0x6
     860:	b8c080e7          	jalr	-1140(ra) # 63e8 <printf>
      exit(1);
     864:	4505                	li	a0,1
     866:	00005097          	auipc	ra,0x5
     86a:	720080e7          	jalr	1824(ra) # 5f86 <exit>
      printf("pipe write failed\n");
     86e:	00006517          	auipc	a0,0x6
     872:	f9250513          	addi	a0,a0,-110 # 6800 <malloc+0x35c>
     876:	00006097          	auipc	ra,0x6
     87a:	b72080e7          	jalr	-1166(ra) # 63e8 <printf>
      exit(1);
     87e:	4505                	li	a0,1
     880:	00005097          	auipc	ra,0x5
     884:	706080e7          	jalr	1798(ra) # 5f86 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     888:	862a                	mv	a2,a0
     88a:	85ce                	mv	a1,s3
     88c:	00006517          	auipc	a0,0x6
     890:	f8c50513          	addi	a0,a0,-116 # 6818 <malloc+0x374>
     894:	00006097          	auipc	ra,0x6
     898:	b54080e7          	jalr	-1196(ra) # 63e8 <printf>
      exit(1);
     89c:	4505                	li	a0,1
     89e:	00005097          	auipc	ra,0x5
     8a2:	6e8080e7          	jalr	1768(ra) # 5f86 <exit>

00000000000008a6 <truncate1>:
{
     8a6:	711d                	addi	sp,sp,-96
     8a8:	ec86                	sd	ra,88(sp)
     8aa:	e8a2                	sd	s0,80(sp)
     8ac:	e4a6                	sd	s1,72(sp)
     8ae:	e0ca                	sd	s2,64(sp)
     8b0:	fc4e                	sd	s3,56(sp)
     8b2:	f852                	sd	s4,48(sp)
     8b4:	f456                	sd	s5,40(sp)
     8b6:	1080                	addi	s0,sp,96
     8b8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     8ba:	00006517          	auipc	a0,0x6
     8be:	d7650513          	addi	a0,a0,-650 # 6630 <malloc+0x18c>
     8c2:	00005097          	auipc	ra,0x5
     8c6:	714080e7          	jalr	1812(ra) # 5fd6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     8ca:	60100593          	li	a1,1537
     8ce:	00006517          	auipc	a0,0x6
     8d2:	d6250513          	addi	a0,a0,-670 # 6630 <malloc+0x18c>
     8d6:	00005097          	auipc	ra,0x5
     8da:	6f0080e7          	jalr	1776(ra) # 5fc6 <open>
     8de:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     8e0:	4611                	li	a2,4
     8e2:	00006597          	auipc	a1,0x6
     8e6:	d5e58593          	addi	a1,a1,-674 # 6640 <malloc+0x19c>
     8ea:	00005097          	auipc	ra,0x5
     8ee:	6bc080e7          	jalr	1724(ra) # 5fa6 <write>
  close(fd1);
     8f2:	8526                	mv	a0,s1
     8f4:	00005097          	auipc	ra,0x5
     8f8:	6ba080e7          	jalr	1722(ra) # 5fae <close>
  int fd2 = open("truncfile", O_RDONLY);
     8fc:	4581                	li	a1,0
     8fe:	00006517          	auipc	a0,0x6
     902:	d3250513          	addi	a0,a0,-718 # 6630 <malloc+0x18c>
     906:	00005097          	auipc	ra,0x5
     90a:	6c0080e7          	jalr	1728(ra) # 5fc6 <open>
     90e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     910:	02000613          	li	a2,32
     914:	fa040593          	addi	a1,s0,-96
     918:	00005097          	auipc	ra,0x5
     91c:	686080e7          	jalr	1670(ra) # 5f9e <read>
  if(n != 4){
     920:	4791                	li	a5,4
     922:	0cf51e63          	bne	a0,a5,9fe <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     926:	40100593          	li	a1,1025
     92a:	00006517          	auipc	a0,0x6
     92e:	d0650513          	addi	a0,a0,-762 # 6630 <malloc+0x18c>
     932:	00005097          	auipc	ra,0x5
     936:	694080e7          	jalr	1684(ra) # 5fc6 <open>
     93a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     93c:	4581                	li	a1,0
     93e:	00006517          	auipc	a0,0x6
     942:	cf250513          	addi	a0,a0,-782 # 6630 <malloc+0x18c>
     946:	00005097          	auipc	ra,0x5
     94a:	680080e7          	jalr	1664(ra) # 5fc6 <open>
     94e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     950:	02000613          	li	a2,32
     954:	fa040593          	addi	a1,s0,-96
     958:	00005097          	auipc	ra,0x5
     95c:	646080e7          	jalr	1606(ra) # 5f9e <read>
     960:	8a2a                	mv	s4,a0
  if(n != 0){
     962:	ed4d                	bnez	a0,a1c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     964:	02000613          	li	a2,32
     968:	fa040593          	addi	a1,s0,-96
     96c:	8526                	mv	a0,s1
     96e:	00005097          	auipc	ra,0x5
     972:	630080e7          	jalr	1584(ra) # 5f9e <read>
     976:	8a2a                	mv	s4,a0
  if(n != 0){
     978:	e971                	bnez	a0,a4c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     97a:	4619                	li	a2,6
     97c:	00006597          	auipc	a1,0x6
     980:	f2c58593          	addi	a1,a1,-212 # 68a8 <malloc+0x404>
     984:	854e                	mv	a0,s3
     986:	00005097          	auipc	ra,0x5
     98a:	620080e7          	jalr	1568(ra) # 5fa6 <write>
  n = read(fd3, buf, sizeof(buf));
     98e:	02000613          	li	a2,32
     992:	fa040593          	addi	a1,s0,-96
     996:	854a                	mv	a0,s2
     998:	00005097          	auipc	ra,0x5
     99c:	606080e7          	jalr	1542(ra) # 5f9e <read>
  if(n != 6){
     9a0:	4799                	li	a5,6
     9a2:	0cf51d63          	bne	a0,a5,a7c <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     9a6:	02000613          	li	a2,32
     9aa:	fa040593          	addi	a1,s0,-96
     9ae:	8526                	mv	a0,s1
     9b0:	00005097          	auipc	ra,0x5
     9b4:	5ee080e7          	jalr	1518(ra) # 5f9e <read>
  if(n != 2){
     9b8:	4789                	li	a5,2
     9ba:	0ef51063          	bne	a0,a5,a9a <truncate1+0x1f4>
  unlink("truncfile");
     9be:	00006517          	auipc	a0,0x6
     9c2:	c7250513          	addi	a0,a0,-910 # 6630 <malloc+0x18c>
     9c6:	00005097          	auipc	ra,0x5
     9ca:	610080e7          	jalr	1552(ra) # 5fd6 <unlink>
  close(fd1);
     9ce:	854e                	mv	a0,s3
     9d0:	00005097          	auipc	ra,0x5
     9d4:	5de080e7          	jalr	1502(ra) # 5fae <close>
  close(fd2);
     9d8:	8526                	mv	a0,s1
     9da:	00005097          	auipc	ra,0x5
     9de:	5d4080e7          	jalr	1492(ra) # 5fae <close>
  close(fd3);
     9e2:	854a                	mv	a0,s2
     9e4:	00005097          	auipc	ra,0x5
     9e8:	5ca080e7          	jalr	1482(ra) # 5fae <close>
}
     9ec:	60e6                	ld	ra,88(sp)
     9ee:	6446                	ld	s0,80(sp)
     9f0:	64a6                	ld	s1,72(sp)
     9f2:	6906                	ld	s2,64(sp)
     9f4:	79e2                	ld	s3,56(sp)
     9f6:	7a42                	ld	s4,48(sp)
     9f8:	7aa2                	ld	s5,40(sp)
     9fa:	6125                	addi	sp,sp,96
     9fc:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     9fe:	862a                	mv	a2,a0
     a00:	85d6                	mv	a1,s5
     a02:	00006517          	auipc	a0,0x6
     a06:	e4650513          	addi	a0,a0,-442 # 6848 <malloc+0x3a4>
     a0a:	00006097          	auipc	ra,0x6
     a0e:	9de080e7          	jalr	-1570(ra) # 63e8 <printf>
    exit(1);
     a12:	4505                	li	a0,1
     a14:	00005097          	auipc	ra,0x5
     a18:	572080e7          	jalr	1394(ra) # 5f86 <exit>
    printf("aaa fd3=%d\n", fd3);
     a1c:	85ca                	mv	a1,s2
     a1e:	00006517          	auipc	a0,0x6
     a22:	e4a50513          	addi	a0,a0,-438 # 6868 <malloc+0x3c4>
     a26:	00006097          	auipc	ra,0x6
     a2a:	9c2080e7          	jalr	-1598(ra) # 63e8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a2e:	8652                	mv	a2,s4
     a30:	85d6                	mv	a1,s5
     a32:	00006517          	auipc	a0,0x6
     a36:	e4650513          	addi	a0,a0,-442 # 6878 <malloc+0x3d4>
     a3a:	00006097          	auipc	ra,0x6
     a3e:	9ae080e7          	jalr	-1618(ra) # 63e8 <printf>
    exit(1);
     a42:	4505                	li	a0,1
     a44:	00005097          	auipc	ra,0x5
     a48:	542080e7          	jalr	1346(ra) # 5f86 <exit>
    printf("bbb fd2=%d\n", fd2);
     a4c:	85a6                	mv	a1,s1
     a4e:	00006517          	auipc	a0,0x6
     a52:	e4a50513          	addi	a0,a0,-438 # 6898 <malloc+0x3f4>
     a56:	00006097          	auipc	ra,0x6
     a5a:	992080e7          	jalr	-1646(ra) # 63e8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a5e:	8652                	mv	a2,s4
     a60:	85d6                	mv	a1,s5
     a62:	00006517          	auipc	a0,0x6
     a66:	e1650513          	addi	a0,a0,-490 # 6878 <malloc+0x3d4>
     a6a:	00006097          	auipc	ra,0x6
     a6e:	97e080e7          	jalr	-1666(ra) # 63e8 <printf>
    exit(1);
     a72:	4505                	li	a0,1
     a74:	00005097          	auipc	ra,0x5
     a78:	512080e7          	jalr	1298(ra) # 5f86 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     a7c:	862a                	mv	a2,a0
     a7e:	85d6                	mv	a1,s5
     a80:	00006517          	auipc	a0,0x6
     a84:	e3050513          	addi	a0,a0,-464 # 68b0 <malloc+0x40c>
     a88:	00006097          	auipc	ra,0x6
     a8c:	960080e7          	jalr	-1696(ra) # 63e8 <printf>
    exit(1);
     a90:	4505                	li	a0,1
     a92:	00005097          	auipc	ra,0x5
     a96:	4f4080e7          	jalr	1268(ra) # 5f86 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     a9a:	862a                	mv	a2,a0
     a9c:	85d6                	mv	a1,s5
     a9e:	00006517          	auipc	a0,0x6
     aa2:	e3250513          	addi	a0,a0,-462 # 68d0 <malloc+0x42c>
     aa6:	00006097          	auipc	ra,0x6
     aaa:	942080e7          	jalr	-1726(ra) # 63e8 <printf>
    exit(1);
     aae:	4505                	li	a0,1
     ab0:	00005097          	auipc	ra,0x5
     ab4:	4d6080e7          	jalr	1238(ra) # 5f86 <exit>

0000000000000ab8 <writetest>:
{
     ab8:	715d                	addi	sp,sp,-80
     aba:	e486                	sd	ra,72(sp)
     abc:	e0a2                	sd	s0,64(sp)
     abe:	fc26                	sd	s1,56(sp)
     ac0:	f84a                	sd	s2,48(sp)
     ac2:	f44e                	sd	s3,40(sp)
     ac4:	f052                	sd	s4,32(sp)
     ac6:	ec56                	sd	s5,24(sp)
     ac8:	e85a                	sd	s6,16(sp)
     aca:	e45e                	sd	s7,8(sp)
     acc:	0880                	addi	s0,sp,80
     ace:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     ad0:	20200593          	li	a1,514
     ad4:	00006517          	auipc	a0,0x6
     ad8:	e1c50513          	addi	a0,a0,-484 # 68f0 <malloc+0x44c>
     adc:	00005097          	auipc	ra,0x5
     ae0:	4ea080e7          	jalr	1258(ra) # 5fc6 <open>
  if(fd < 0){
     ae4:	0a054d63          	bltz	a0,b9e <writetest+0xe6>
     ae8:	89aa                	mv	s3,a0
     aea:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     aec:	44a9                	li	s1,10
     aee:	00006a17          	auipc	s4,0x6
     af2:	e2aa0a13          	addi	s4,s4,-470 # 6918 <malloc+0x474>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     af6:	00006b17          	auipc	s6,0x6
     afa:	e5ab0b13          	addi	s6,s6,-422 # 6950 <malloc+0x4ac>
  for(i = 0; i < N; i++){
     afe:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     b02:	8626                	mv	a2,s1
     b04:	85d2                	mv	a1,s4
     b06:	854e                	mv	a0,s3
     b08:	00005097          	auipc	ra,0x5
     b0c:	49e080e7          	jalr	1182(ra) # 5fa6 <write>
     b10:	0a951563          	bne	a0,s1,bba <writetest+0x102>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b14:	8626                	mv	a2,s1
     b16:	85da                	mv	a1,s6
     b18:	854e                	mv	a0,s3
     b1a:	00005097          	auipc	ra,0x5
     b1e:	48c080e7          	jalr	1164(ra) # 5fa6 <write>
     b22:	0a951b63          	bne	a0,s1,bd8 <writetest+0x120>
  for(i = 0; i < N; i++){
     b26:	2905                	addiw	s2,s2,1
     b28:	fd591de3          	bne	s2,s5,b02 <writetest+0x4a>
  close(fd);
     b2c:	854e                	mv	a0,s3
     b2e:	00005097          	auipc	ra,0x5
     b32:	480080e7          	jalr	1152(ra) # 5fae <close>
  fd = open("small", O_RDONLY);
     b36:	4581                	li	a1,0
     b38:	00006517          	auipc	a0,0x6
     b3c:	db850513          	addi	a0,a0,-584 # 68f0 <malloc+0x44c>
     b40:	00005097          	auipc	ra,0x5
     b44:	486080e7          	jalr	1158(ra) # 5fc6 <open>
     b48:	84aa                	mv	s1,a0
  if(fd < 0){
     b4a:	0a054663          	bltz	a0,bf6 <writetest+0x13e>
  i = read(fd, buf, N*SZ*2);
     b4e:	7d000613          	li	a2,2000
     b52:	0000d597          	auipc	a1,0xd
     b56:	12658593          	addi	a1,a1,294 # dc78 <buf>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	444080e7          	jalr	1092(ra) # 5f9e <read>
  if(i != N*SZ*2){
     b62:	7d000793          	li	a5,2000
     b66:	0af51663          	bne	a0,a5,c12 <writetest+0x15a>
  close(fd);
     b6a:	8526                	mv	a0,s1
     b6c:	00005097          	auipc	ra,0x5
     b70:	442080e7          	jalr	1090(ra) # 5fae <close>
  if(unlink("small") < 0){
     b74:	00006517          	auipc	a0,0x6
     b78:	d7c50513          	addi	a0,a0,-644 # 68f0 <malloc+0x44c>
     b7c:	00005097          	auipc	ra,0x5
     b80:	45a080e7          	jalr	1114(ra) # 5fd6 <unlink>
     b84:	0a054563          	bltz	a0,c2e <writetest+0x176>
}
     b88:	60a6                	ld	ra,72(sp)
     b8a:	6406                	ld	s0,64(sp)
     b8c:	74e2                	ld	s1,56(sp)
     b8e:	7942                	ld	s2,48(sp)
     b90:	79a2                	ld	s3,40(sp)
     b92:	7a02                	ld	s4,32(sp)
     b94:	6ae2                	ld	s5,24(sp)
     b96:	6b42                	ld	s6,16(sp)
     b98:	6ba2                	ld	s7,8(sp)
     b9a:	6161                	addi	sp,sp,80
     b9c:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     b9e:	85de                	mv	a1,s7
     ba0:	00006517          	auipc	a0,0x6
     ba4:	d5850513          	addi	a0,a0,-680 # 68f8 <malloc+0x454>
     ba8:	00006097          	auipc	ra,0x6
     bac:	840080e7          	jalr	-1984(ra) # 63e8 <printf>
    exit(1);
     bb0:	4505                	li	a0,1
     bb2:	00005097          	auipc	ra,0x5
     bb6:	3d4080e7          	jalr	980(ra) # 5f86 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     bba:	864a                	mv	a2,s2
     bbc:	85de                	mv	a1,s7
     bbe:	00006517          	auipc	a0,0x6
     bc2:	d6a50513          	addi	a0,a0,-662 # 6928 <malloc+0x484>
     bc6:	00006097          	auipc	ra,0x6
     bca:	822080e7          	jalr	-2014(ra) # 63e8 <printf>
      exit(1);
     bce:	4505                	li	a0,1
     bd0:	00005097          	auipc	ra,0x5
     bd4:	3b6080e7          	jalr	950(ra) # 5f86 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     bd8:	864a                	mv	a2,s2
     bda:	85de                	mv	a1,s7
     bdc:	00006517          	auipc	a0,0x6
     be0:	d8450513          	addi	a0,a0,-636 # 6960 <malloc+0x4bc>
     be4:	00006097          	auipc	ra,0x6
     be8:	804080e7          	jalr	-2044(ra) # 63e8 <printf>
      exit(1);
     bec:	4505                	li	a0,1
     bee:	00005097          	auipc	ra,0x5
     bf2:	398080e7          	jalr	920(ra) # 5f86 <exit>
    printf("%s: error: open small failed!\n", s);
     bf6:	85de                	mv	a1,s7
     bf8:	00006517          	auipc	a0,0x6
     bfc:	d9050513          	addi	a0,a0,-624 # 6988 <malloc+0x4e4>
     c00:	00005097          	auipc	ra,0x5
     c04:	7e8080e7          	jalr	2024(ra) # 63e8 <printf>
    exit(1);
     c08:	4505                	li	a0,1
     c0a:	00005097          	auipc	ra,0x5
     c0e:	37c080e7          	jalr	892(ra) # 5f86 <exit>
    printf("%s: read failed\n", s);
     c12:	85de                	mv	a1,s7
     c14:	00006517          	auipc	a0,0x6
     c18:	d9450513          	addi	a0,a0,-620 # 69a8 <malloc+0x504>
     c1c:	00005097          	auipc	ra,0x5
     c20:	7cc080e7          	jalr	1996(ra) # 63e8 <printf>
    exit(1);
     c24:	4505                	li	a0,1
     c26:	00005097          	auipc	ra,0x5
     c2a:	360080e7          	jalr	864(ra) # 5f86 <exit>
    printf("%s: unlink small failed\n", s);
     c2e:	85de                	mv	a1,s7
     c30:	00006517          	auipc	a0,0x6
     c34:	d9050513          	addi	a0,a0,-624 # 69c0 <malloc+0x51c>
     c38:	00005097          	auipc	ra,0x5
     c3c:	7b0080e7          	jalr	1968(ra) # 63e8 <printf>
    exit(1);
     c40:	4505                	li	a0,1
     c42:	00005097          	auipc	ra,0x5
     c46:	344080e7          	jalr	836(ra) # 5f86 <exit>

0000000000000c4a <writebig>:
{
     c4a:	7139                	addi	sp,sp,-64
     c4c:	fc06                	sd	ra,56(sp)
     c4e:	f822                	sd	s0,48(sp)
     c50:	f426                	sd	s1,40(sp)
     c52:	f04a                	sd	s2,32(sp)
     c54:	ec4e                	sd	s3,24(sp)
     c56:	e852                	sd	s4,16(sp)
     c58:	e456                	sd	s5,8(sp)
     c5a:	e05a                	sd	s6,0(sp)
     c5c:	0080                	addi	s0,sp,64
     c5e:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     c60:	20200593          	li	a1,514
     c64:	00006517          	auipc	a0,0x6
     c68:	d7c50513          	addi	a0,a0,-644 # 69e0 <malloc+0x53c>
     c6c:	00005097          	auipc	ra,0x5
     c70:	35a080e7          	jalr	858(ra) # 5fc6 <open>
  if(fd < 0){
     c74:	08054263          	bltz	a0,cf8 <writebig+0xae>
     c78:	8a2a                	mv	s4,a0
     c7a:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     c7c:	0000d997          	auipc	s3,0xd
     c80:	ffc98993          	addi	s3,s3,-4 # dc78 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     c84:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     c88:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     c8c:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     c90:	864a                	mv	a2,s2
     c92:	85ce                	mv	a1,s3
     c94:	8552                	mv	a0,s4
     c96:	00005097          	auipc	ra,0x5
     c9a:	310080e7          	jalr	784(ra) # 5fa6 <write>
     c9e:	07251b63          	bne	a0,s2,d14 <writebig+0xca>
  for(i = 0; i < MAXFILE; i++){
     ca2:	2485                	addiw	s1,s1,1
     ca4:	ff5494e3          	bne	s1,s5,c8c <writebig+0x42>
  close(fd);
     ca8:	8552                	mv	a0,s4
     caa:	00005097          	auipc	ra,0x5
     cae:	304080e7          	jalr	772(ra) # 5fae <close>
  fd = open("big", O_RDONLY);
     cb2:	4581                	li	a1,0
     cb4:	00006517          	auipc	a0,0x6
     cb8:	d2c50513          	addi	a0,a0,-724 # 69e0 <malloc+0x53c>
     cbc:	00005097          	auipc	ra,0x5
     cc0:	30a080e7          	jalr	778(ra) # 5fc6 <open>
     cc4:	8a2a                	mv	s4,a0
  n = 0;
     cc6:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     cc8:	40000993          	li	s3,1024
     ccc:	0000d917          	auipc	s2,0xd
     cd0:	fac90913          	addi	s2,s2,-84 # dc78 <buf>
  if(fd < 0){
     cd4:	04054f63          	bltz	a0,d32 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     cd8:	864e                	mv	a2,s3
     cda:	85ca                	mv	a1,s2
     cdc:	8552                	mv	a0,s4
     cde:	00005097          	auipc	ra,0x5
     ce2:	2c0080e7          	jalr	704(ra) # 5f9e <read>
    if(i == 0){
     ce6:	c525                	beqz	a0,d4e <writebig+0x104>
    } else if(i != BSIZE){
     ce8:	0b351f63          	bne	a0,s3,da6 <writebig+0x15c>
    if(((int*)buf)[0] != n){
     cec:	00092683          	lw	a3,0(s2)
     cf0:	0c969a63          	bne	a3,s1,dc4 <writebig+0x17a>
    n++;
     cf4:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     cf6:	b7cd                	j	cd8 <writebig+0x8e>
    printf("%s: error: creat big failed!\n", s);
     cf8:	85da                	mv	a1,s6
     cfa:	00006517          	auipc	a0,0x6
     cfe:	cee50513          	addi	a0,a0,-786 # 69e8 <malloc+0x544>
     d02:	00005097          	auipc	ra,0x5
     d06:	6e6080e7          	jalr	1766(ra) # 63e8 <printf>
    exit(1);
     d0a:	4505                	li	a0,1
     d0c:	00005097          	auipc	ra,0x5
     d10:	27a080e7          	jalr	634(ra) # 5f86 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     d14:	8626                	mv	a2,s1
     d16:	85da                	mv	a1,s6
     d18:	00006517          	auipc	a0,0x6
     d1c:	cf050513          	addi	a0,a0,-784 # 6a08 <malloc+0x564>
     d20:	00005097          	auipc	ra,0x5
     d24:	6c8080e7          	jalr	1736(ra) # 63e8 <printf>
      exit(1);
     d28:	4505                	li	a0,1
     d2a:	00005097          	auipc	ra,0x5
     d2e:	25c080e7          	jalr	604(ra) # 5f86 <exit>
    printf("%s: error: open big failed!\n", s);
     d32:	85da                	mv	a1,s6
     d34:	00006517          	auipc	a0,0x6
     d38:	cfc50513          	addi	a0,a0,-772 # 6a30 <malloc+0x58c>
     d3c:	00005097          	auipc	ra,0x5
     d40:	6ac080e7          	jalr	1708(ra) # 63e8 <printf>
    exit(1);
     d44:	4505                	li	a0,1
     d46:	00005097          	auipc	ra,0x5
     d4a:	240080e7          	jalr	576(ra) # 5f86 <exit>
      if(n != MAXFILE){
     d4e:	10c00793          	li	a5,268
     d52:	02f49b63          	bne	s1,a5,d88 <writebig+0x13e>
  close(fd);
     d56:	8552                	mv	a0,s4
     d58:	00005097          	auipc	ra,0x5
     d5c:	256080e7          	jalr	598(ra) # 5fae <close>
  if(unlink("big") < 0){
     d60:	00006517          	auipc	a0,0x6
     d64:	c8050513          	addi	a0,a0,-896 # 69e0 <malloc+0x53c>
     d68:	00005097          	auipc	ra,0x5
     d6c:	26e080e7          	jalr	622(ra) # 5fd6 <unlink>
     d70:	06054963          	bltz	a0,de2 <writebig+0x198>
}
     d74:	70e2                	ld	ra,56(sp)
     d76:	7442                	ld	s0,48(sp)
     d78:	74a2                	ld	s1,40(sp)
     d7a:	7902                	ld	s2,32(sp)
     d7c:	69e2                	ld	s3,24(sp)
     d7e:	6a42                	ld	s4,16(sp)
     d80:	6aa2                	ld	s5,8(sp)
     d82:	6b02                	ld	s6,0(sp)
     d84:	6121                	addi	sp,sp,64
     d86:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     d88:	8626                	mv	a2,s1
     d8a:	85da                	mv	a1,s6
     d8c:	00006517          	auipc	a0,0x6
     d90:	cc450513          	addi	a0,a0,-828 # 6a50 <malloc+0x5ac>
     d94:	00005097          	auipc	ra,0x5
     d98:	654080e7          	jalr	1620(ra) # 63e8 <printf>
        exit(1);
     d9c:	4505                	li	a0,1
     d9e:	00005097          	auipc	ra,0x5
     da2:	1e8080e7          	jalr	488(ra) # 5f86 <exit>
      printf("%s: read failed %d\n", s, i);
     da6:	862a                	mv	a2,a0
     da8:	85da                	mv	a1,s6
     daa:	00006517          	auipc	a0,0x6
     dae:	cce50513          	addi	a0,a0,-818 # 6a78 <malloc+0x5d4>
     db2:	00005097          	auipc	ra,0x5
     db6:	636080e7          	jalr	1590(ra) # 63e8 <printf>
      exit(1);
     dba:	4505                	li	a0,1
     dbc:	00005097          	auipc	ra,0x5
     dc0:	1ca080e7          	jalr	458(ra) # 5f86 <exit>
      printf("%s: read content of block %d is %d\n", s,
     dc4:	8626                	mv	a2,s1
     dc6:	85da                	mv	a1,s6
     dc8:	00006517          	auipc	a0,0x6
     dcc:	cc850513          	addi	a0,a0,-824 # 6a90 <malloc+0x5ec>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	618080e7          	jalr	1560(ra) # 63e8 <printf>
      exit(1);
     dd8:	4505                	li	a0,1
     dda:	00005097          	auipc	ra,0x5
     dde:	1ac080e7          	jalr	428(ra) # 5f86 <exit>
    printf("%s: unlink big failed\n", s);
     de2:	85da                	mv	a1,s6
     de4:	00006517          	auipc	a0,0x6
     de8:	cd450513          	addi	a0,a0,-812 # 6ab8 <malloc+0x614>
     dec:	00005097          	auipc	ra,0x5
     df0:	5fc080e7          	jalr	1532(ra) # 63e8 <printf>
    exit(1);
     df4:	4505                	li	a0,1
     df6:	00005097          	auipc	ra,0x5
     dfa:	190080e7          	jalr	400(ra) # 5f86 <exit>

0000000000000dfe <unlinkread>:
{
     dfe:	7179                	addi	sp,sp,-48
     e00:	f406                	sd	ra,40(sp)
     e02:	f022                	sd	s0,32(sp)
     e04:	ec26                	sd	s1,24(sp)
     e06:	e84a                	sd	s2,16(sp)
     e08:	e44e                	sd	s3,8(sp)
     e0a:	1800                	addi	s0,sp,48
     e0c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     e0e:	20200593          	li	a1,514
     e12:	00006517          	auipc	a0,0x6
     e16:	cbe50513          	addi	a0,a0,-834 # 6ad0 <malloc+0x62c>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	1ac080e7          	jalr	428(ra) # 5fc6 <open>
  if(fd < 0){
     e22:	0e054563          	bltz	a0,f0c <unlinkread+0x10e>
     e26:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     e28:	4615                	li	a2,5
     e2a:	00006597          	auipc	a1,0x6
     e2e:	cd658593          	addi	a1,a1,-810 # 6b00 <malloc+0x65c>
     e32:	00005097          	auipc	ra,0x5
     e36:	174080e7          	jalr	372(ra) # 5fa6 <write>
  close(fd);
     e3a:	8526                	mv	a0,s1
     e3c:	00005097          	auipc	ra,0x5
     e40:	172080e7          	jalr	370(ra) # 5fae <close>
  fd = open("unlinkread", O_RDWR);
     e44:	4589                	li	a1,2
     e46:	00006517          	auipc	a0,0x6
     e4a:	c8a50513          	addi	a0,a0,-886 # 6ad0 <malloc+0x62c>
     e4e:	00005097          	auipc	ra,0x5
     e52:	178080e7          	jalr	376(ra) # 5fc6 <open>
     e56:	84aa                	mv	s1,a0
  if(fd < 0){
     e58:	0c054863          	bltz	a0,f28 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     e5c:	00006517          	auipc	a0,0x6
     e60:	c7450513          	addi	a0,a0,-908 # 6ad0 <malloc+0x62c>
     e64:	00005097          	auipc	ra,0x5
     e68:	172080e7          	jalr	370(ra) # 5fd6 <unlink>
     e6c:	ed61                	bnez	a0,f44 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     e6e:	20200593          	li	a1,514
     e72:	00006517          	auipc	a0,0x6
     e76:	c5e50513          	addi	a0,a0,-930 # 6ad0 <malloc+0x62c>
     e7a:	00005097          	auipc	ra,0x5
     e7e:	14c080e7          	jalr	332(ra) # 5fc6 <open>
     e82:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     e84:	460d                	li	a2,3
     e86:	00006597          	auipc	a1,0x6
     e8a:	cc258593          	addi	a1,a1,-830 # 6b48 <malloc+0x6a4>
     e8e:	00005097          	auipc	ra,0x5
     e92:	118080e7          	jalr	280(ra) # 5fa6 <write>
  close(fd1);
     e96:	854a                	mv	a0,s2
     e98:	00005097          	auipc	ra,0x5
     e9c:	116080e7          	jalr	278(ra) # 5fae <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ea0:	660d                	lui	a2,0x3
     ea2:	0000d597          	auipc	a1,0xd
     ea6:	dd658593          	addi	a1,a1,-554 # dc78 <buf>
     eaa:	8526                	mv	a0,s1
     eac:	00005097          	auipc	ra,0x5
     eb0:	0f2080e7          	jalr	242(ra) # 5f9e <read>
     eb4:	4795                	li	a5,5
     eb6:	0af51563          	bne	a0,a5,f60 <unlinkread+0x162>
  if(buf[0] != 'h'){
     eba:	0000d717          	auipc	a4,0xd
     ebe:	dbe74703          	lbu	a4,-578(a4) # dc78 <buf>
     ec2:	06800793          	li	a5,104
     ec6:	0af71b63          	bne	a4,a5,f7c <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     eca:	4629                	li	a2,10
     ecc:	0000d597          	auipc	a1,0xd
     ed0:	dac58593          	addi	a1,a1,-596 # dc78 <buf>
     ed4:	8526                	mv	a0,s1
     ed6:	00005097          	auipc	ra,0x5
     eda:	0d0080e7          	jalr	208(ra) # 5fa6 <write>
     ede:	47a9                	li	a5,10
     ee0:	0af51c63          	bne	a0,a5,f98 <unlinkread+0x19a>
  close(fd);
     ee4:	8526                	mv	a0,s1
     ee6:	00005097          	auipc	ra,0x5
     eea:	0c8080e7          	jalr	200(ra) # 5fae <close>
  unlink("unlinkread");
     eee:	00006517          	auipc	a0,0x6
     ef2:	be250513          	addi	a0,a0,-1054 # 6ad0 <malloc+0x62c>
     ef6:	00005097          	auipc	ra,0x5
     efa:	0e0080e7          	jalr	224(ra) # 5fd6 <unlink>
}
     efe:	70a2                	ld	ra,40(sp)
     f00:	7402                	ld	s0,32(sp)
     f02:	64e2                	ld	s1,24(sp)
     f04:	6942                	ld	s2,16(sp)
     f06:	69a2                	ld	s3,8(sp)
     f08:	6145                	addi	sp,sp,48
     f0a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     f0c:	85ce                	mv	a1,s3
     f0e:	00006517          	auipc	a0,0x6
     f12:	bd250513          	addi	a0,a0,-1070 # 6ae0 <malloc+0x63c>
     f16:	00005097          	auipc	ra,0x5
     f1a:	4d2080e7          	jalr	1234(ra) # 63e8 <printf>
    exit(1);
     f1e:	4505                	li	a0,1
     f20:	00005097          	auipc	ra,0x5
     f24:	066080e7          	jalr	102(ra) # 5f86 <exit>
    printf("%s: open unlinkread failed\n", s);
     f28:	85ce                	mv	a1,s3
     f2a:	00006517          	auipc	a0,0x6
     f2e:	bde50513          	addi	a0,a0,-1058 # 6b08 <malloc+0x664>
     f32:	00005097          	auipc	ra,0x5
     f36:	4b6080e7          	jalr	1206(ra) # 63e8 <printf>
    exit(1);
     f3a:	4505                	li	a0,1
     f3c:	00005097          	auipc	ra,0x5
     f40:	04a080e7          	jalr	74(ra) # 5f86 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     f44:	85ce                	mv	a1,s3
     f46:	00006517          	auipc	a0,0x6
     f4a:	be250513          	addi	a0,a0,-1054 # 6b28 <malloc+0x684>
     f4e:	00005097          	auipc	ra,0x5
     f52:	49a080e7          	jalr	1178(ra) # 63e8 <printf>
    exit(1);
     f56:	4505                	li	a0,1
     f58:	00005097          	auipc	ra,0x5
     f5c:	02e080e7          	jalr	46(ra) # 5f86 <exit>
    printf("%s: unlinkread read failed", s);
     f60:	85ce                	mv	a1,s3
     f62:	00006517          	auipc	a0,0x6
     f66:	bee50513          	addi	a0,a0,-1042 # 6b50 <malloc+0x6ac>
     f6a:	00005097          	auipc	ra,0x5
     f6e:	47e080e7          	jalr	1150(ra) # 63e8 <printf>
    exit(1);
     f72:	4505                	li	a0,1
     f74:	00005097          	auipc	ra,0x5
     f78:	012080e7          	jalr	18(ra) # 5f86 <exit>
    printf("%s: unlinkread wrong data\n", s);
     f7c:	85ce                	mv	a1,s3
     f7e:	00006517          	auipc	a0,0x6
     f82:	bf250513          	addi	a0,a0,-1038 # 6b70 <malloc+0x6cc>
     f86:	00005097          	auipc	ra,0x5
     f8a:	462080e7          	jalr	1122(ra) # 63e8 <printf>
    exit(1);
     f8e:	4505                	li	a0,1
     f90:	00005097          	auipc	ra,0x5
     f94:	ff6080e7          	jalr	-10(ra) # 5f86 <exit>
    printf("%s: unlinkread write failed\n", s);
     f98:	85ce                	mv	a1,s3
     f9a:	00006517          	auipc	a0,0x6
     f9e:	bf650513          	addi	a0,a0,-1034 # 6b90 <malloc+0x6ec>
     fa2:	00005097          	auipc	ra,0x5
     fa6:	446080e7          	jalr	1094(ra) # 63e8 <printf>
    exit(1);
     faa:	4505                	li	a0,1
     fac:	00005097          	auipc	ra,0x5
     fb0:	fda080e7          	jalr	-38(ra) # 5f86 <exit>

0000000000000fb4 <linktest>:
{
     fb4:	1101                	addi	sp,sp,-32
     fb6:	ec06                	sd	ra,24(sp)
     fb8:	e822                	sd	s0,16(sp)
     fba:	e426                	sd	s1,8(sp)
     fbc:	e04a                	sd	s2,0(sp)
     fbe:	1000                	addi	s0,sp,32
     fc0:	892a                	mv	s2,a0
  unlink("lf1");
     fc2:	00006517          	auipc	a0,0x6
     fc6:	bee50513          	addi	a0,a0,-1042 # 6bb0 <malloc+0x70c>
     fca:	00005097          	auipc	ra,0x5
     fce:	00c080e7          	jalr	12(ra) # 5fd6 <unlink>
  unlink("lf2");
     fd2:	00006517          	auipc	a0,0x6
     fd6:	be650513          	addi	a0,a0,-1050 # 6bb8 <malloc+0x714>
     fda:	00005097          	auipc	ra,0x5
     fde:	ffc080e7          	jalr	-4(ra) # 5fd6 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     fe2:	20200593          	li	a1,514
     fe6:	00006517          	auipc	a0,0x6
     fea:	bca50513          	addi	a0,a0,-1078 # 6bb0 <malloc+0x70c>
     fee:	00005097          	auipc	ra,0x5
     ff2:	fd8080e7          	jalr	-40(ra) # 5fc6 <open>
  if(fd < 0){
     ff6:	10054763          	bltz	a0,1104 <linktest+0x150>
     ffa:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     ffc:	4615                	li	a2,5
     ffe:	00006597          	auipc	a1,0x6
    1002:	b0258593          	addi	a1,a1,-1278 # 6b00 <malloc+0x65c>
    1006:	00005097          	auipc	ra,0x5
    100a:	fa0080e7          	jalr	-96(ra) # 5fa6 <write>
    100e:	4795                	li	a5,5
    1010:	10f51863          	bne	a0,a5,1120 <linktest+0x16c>
  close(fd);
    1014:	8526                	mv	a0,s1
    1016:	00005097          	auipc	ra,0x5
    101a:	f98080e7          	jalr	-104(ra) # 5fae <close>
  if(link("lf1", "lf2") < 0){
    101e:	00006597          	auipc	a1,0x6
    1022:	b9a58593          	addi	a1,a1,-1126 # 6bb8 <malloc+0x714>
    1026:	00006517          	auipc	a0,0x6
    102a:	b8a50513          	addi	a0,a0,-1142 # 6bb0 <malloc+0x70c>
    102e:	00005097          	auipc	ra,0x5
    1032:	fb8080e7          	jalr	-72(ra) # 5fe6 <link>
    1036:	10054363          	bltz	a0,113c <linktest+0x188>
  unlink("lf1");
    103a:	00006517          	auipc	a0,0x6
    103e:	b7650513          	addi	a0,a0,-1162 # 6bb0 <malloc+0x70c>
    1042:	00005097          	auipc	ra,0x5
    1046:	f94080e7          	jalr	-108(ra) # 5fd6 <unlink>
  if(open("lf1", 0) >= 0){
    104a:	4581                	li	a1,0
    104c:	00006517          	auipc	a0,0x6
    1050:	b6450513          	addi	a0,a0,-1180 # 6bb0 <malloc+0x70c>
    1054:	00005097          	auipc	ra,0x5
    1058:	f72080e7          	jalr	-142(ra) # 5fc6 <open>
    105c:	0e055e63          	bgez	a0,1158 <linktest+0x1a4>
  fd = open("lf2", 0);
    1060:	4581                	li	a1,0
    1062:	00006517          	auipc	a0,0x6
    1066:	b5650513          	addi	a0,a0,-1194 # 6bb8 <malloc+0x714>
    106a:	00005097          	auipc	ra,0x5
    106e:	f5c080e7          	jalr	-164(ra) # 5fc6 <open>
    1072:	84aa                	mv	s1,a0
  if(fd < 0){
    1074:	10054063          	bltz	a0,1174 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1078:	660d                	lui	a2,0x3
    107a:	0000d597          	auipc	a1,0xd
    107e:	bfe58593          	addi	a1,a1,-1026 # dc78 <buf>
    1082:	00005097          	auipc	ra,0x5
    1086:	f1c080e7          	jalr	-228(ra) # 5f9e <read>
    108a:	4795                	li	a5,5
    108c:	10f51263          	bne	a0,a5,1190 <linktest+0x1dc>
  close(fd);
    1090:	8526                	mv	a0,s1
    1092:	00005097          	auipc	ra,0x5
    1096:	f1c080e7          	jalr	-228(ra) # 5fae <close>
  if(link("lf2", "lf2") >= 0){
    109a:	00006597          	auipc	a1,0x6
    109e:	b1e58593          	addi	a1,a1,-1250 # 6bb8 <malloc+0x714>
    10a2:	852e                	mv	a0,a1
    10a4:	00005097          	auipc	ra,0x5
    10a8:	f42080e7          	jalr	-190(ra) # 5fe6 <link>
    10ac:	10055063          	bgez	a0,11ac <linktest+0x1f8>
  unlink("lf2");
    10b0:	00006517          	auipc	a0,0x6
    10b4:	b0850513          	addi	a0,a0,-1272 # 6bb8 <malloc+0x714>
    10b8:	00005097          	auipc	ra,0x5
    10bc:	f1e080e7          	jalr	-226(ra) # 5fd6 <unlink>
  if(link("lf2", "lf1") >= 0){
    10c0:	00006597          	auipc	a1,0x6
    10c4:	af058593          	addi	a1,a1,-1296 # 6bb0 <malloc+0x70c>
    10c8:	00006517          	auipc	a0,0x6
    10cc:	af050513          	addi	a0,a0,-1296 # 6bb8 <malloc+0x714>
    10d0:	00005097          	auipc	ra,0x5
    10d4:	f16080e7          	jalr	-234(ra) # 5fe6 <link>
    10d8:	0e055863          	bgez	a0,11c8 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    10dc:	00006597          	auipc	a1,0x6
    10e0:	ad458593          	addi	a1,a1,-1324 # 6bb0 <malloc+0x70c>
    10e4:	00006517          	auipc	a0,0x6
    10e8:	bdc50513          	addi	a0,a0,-1060 # 6cc0 <malloc+0x81c>
    10ec:	00005097          	auipc	ra,0x5
    10f0:	efa080e7          	jalr	-262(ra) # 5fe6 <link>
    10f4:	0e055863          	bgez	a0,11e4 <linktest+0x230>
}
    10f8:	60e2                	ld	ra,24(sp)
    10fa:	6442                	ld	s0,16(sp)
    10fc:	64a2                	ld	s1,8(sp)
    10fe:	6902                	ld	s2,0(sp)
    1100:	6105                	addi	sp,sp,32
    1102:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1104:	85ca                	mv	a1,s2
    1106:	00006517          	auipc	a0,0x6
    110a:	aba50513          	addi	a0,a0,-1350 # 6bc0 <malloc+0x71c>
    110e:	00005097          	auipc	ra,0x5
    1112:	2da080e7          	jalr	730(ra) # 63e8 <printf>
    exit(1);
    1116:	4505                	li	a0,1
    1118:	00005097          	auipc	ra,0x5
    111c:	e6e080e7          	jalr	-402(ra) # 5f86 <exit>
    printf("%s: write lf1 failed\n", s);
    1120:	85ca                	mv	a1,s2
    1122:	00006517          	auipc	a0,0x6
    1126:	ab650513          	addi	a0,a0,-1354 # 6bd8 <malloc+0x734>
    112a:	00005097          	auipc	ra,0x5
    112e:	2be080e7          	jalr	702(ra) # 63e8 <printf>
    exit(1);
    1132:	4505                	li	a0,1
    1134:	00005097          	auipc	ra,0x5
    1138:	e52080e7          	jalr	-430(ra) # 5f86 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    113c:	85ca                	mv	a1,s2
    113e:	00006517          	auipc	a0,0x6
    1142:	ab250513          	addi	a0,a0,-1358 # 6bf0 <malloc+0x74c>
    1146:	00005097          	auipc	ra,0x5
    114a:	2a2080e7          	jalr	674(ra) # 63e8 <printf>
    exit(1);
    114e:	4505                	li	a0,1
    1150:	00005097          	auipc	ra,0x5
    1154:	e36080e7          	jalr	-458(ra) # 5f86 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1158:	85ca                	mv	a1,s2
    115a:	00006517          	auipc	a0,0x6
    115e:	ab650513          	addi	a0,a0,-1354 # 6c10 <malloc+0x76c>
    1162:	00005097          	auipc	ra,0x5
    1166:	286080e7          	jalr	646(ra) # 63e8 <printf>
    exit(1);
    116a:	4505                	li	a0,1
    116c:	00005097          	auipc	ra,0x5
    1170:	e1a080e7          	jalr	-486(ra) # 5f86 <exit>
    printf("%s: open lf2 failed\n", s);
    1174:	85ca                	mv	a1,s2
    1176:	00006517          	auipc	a0,0x6
    117a:	aca50513          	addi	a0,a0,-1334 # 6c40 <malloc+0x79c>
    117e:	00005097          	auipc	ra,0x5
    1182:	26a080e7          	jalr	618(ra) # 63e8 <printf>
    exit(1);
    1186:	4505                	li	a0,1
    1188:	00005097          	auipc	ra,0x5
    118c:	dfe080e7          	jalr	-514(ra) # 5f86 <exit>
    printf("%s: read lf2 failed\n", s);
    1190:	85ca                	mv	a1,s2
    1192:	00006517          	auipc	a0,0x6
    1196:	ac650513          	addi	a0,a0,-1338 # 6c58 <malloc+0x7b4>
    119a:	00005097          	auipc	ra,0x5
    119e:	24e080e7          	jalr	590(ra) # 63e8 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	00005097          	auipc	ra,0x5
    11a8:	de2080e7          	jalr	-542(ra) # 5f86 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    11ac:	85ca                	mv	a1,s2
    11ae:	00006517          	auipc	a0,0x6
    11b2:	ac250513          	addi	a0,a0,-1342 # 6c70 <malloc+0x7cc>
    11b6:	00005097          	auipc	ra,0x5
    11ba:	232080e7          	jalr	562(ra) # 63e8 <printf>
    exit(1);
    11be:	4505                	li	a0,1
    11c0:	00005097          	auipc	ra,0x5
    11c4:	dc6080e7          	jalr	-570(ra) # 5f86 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    11c8:	85ca                	mv	a1,s2
    11ca:	00006517          	auipc	a0,0x6
    11ce:	ace50513          	addi	a0,a0,-1330 # 6c98 <malloc+0x7f4>
    11d2:	00005097          	auipc	ra,0x5
    11d6:	216080e7          	jalr	534(ra) # 63e8 <printf>
    exit(1);
    11da:	4505                	li	a0,1
    11dc:	00005097          	auipc	ra,0x5
    11e0:	daa080e7          	jalr	-598(ra) # 5f86 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    11e4:	85ca                	mv	a1,s2
    11e6:	00006517          	auipc	a0,0x6
    11ea:	ae250513          	addi	a0,a0,-1310 # 6cc8 <malloc+0x824>
    11ee:	00005097          	auipc	ra,0x5
    11f2:	1fa080e7          	jalr	506(ra) # 63e8 <printf>
    exit(1);
    11f6:	4505                	li	a0,1
    11f8:	00005097          	auipc	ra,0x5
    11fc:	d8e080e7          	jalr	-626(ra) # 5f86 <exit>

0000000000001200 <validatetest>:
{
    1200:	7139                	addi	sp,sp,-64
    1202:	fc06                	sd	ra,56(sp)
    1204:	f822                	sd	s0,48(sp)
    1206:	f426                	sd	s1,40(sp)
    1208:	f04a                	sd	s2,32(sp)
    120a:	ec4e                	sd	s3,24(sp)
    120c:	e852                	sd	s4,16(sp)
    120e:	e456                	sd	s5,8(sp)
    1210:	e05a                	sd	s6,0(sp)
    1212:	0080                	addi	s0,sp,64
    1214:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1216:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1218:	00006997          	auipc	s3,0x6
    121c:	ad098993          	addi	s3,s3,-1328 # 6ce8 <malloc+0x844>
    1220:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1222:	6a85                	lui	s5,0x1
    1224:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1228:	85a6                	mv	a1,s1
    122a:	854e                	mv	a0,s3
    122c:	00005097          	auipc	ra,0x5
    1230:	dba080e7          	jalr	-582(ra) # 5fe6 <link>
    1234:	01251f63          	bne	a0,s2,1252 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1238:	94d6                	add	s1,s1,s5
    123a:	ff4497e3          	bne	s1,s4,1228 <validatetest+0x28>
}
    123e:	70e2                	ld	ra,56(sp)
    1240:	7442                	ld	s0,48(sp)
    1242:	74a2                	ld	s1,40(sp)
    1244:	7902                	ld	s2,32(sp)
    1246:	69e2                	ld	s3,24(sp)
    1248:	6a42                	ld	s4,16(sp)
    124a:	6aa2                	ld	s5,8(sp)
    124c:	6b02                	ld	s6,0(sp)
    124e:	6121                	addi	sp,sp,64
    1250:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1252:	85da                	mv	a1,s6
    1254:	00006517          	auipc	a0,0x6
    1258:	aa450513          	addi	a0,a0,-1372 # 6cf8 <malloc+0x854>
    125c:	00005097          	auipc	ra,0x5
    1260:	18c080e7          	jalr	396(ra) # 63e8 <printf>
      exit(1);
    1264:	4505                	li	a0,1
    1266:	00005097          	auipc	ra,0x5
    126a:	d20080e7          	jalr	-736(ra) # 5f86 <exit>

000000000000126e <bigdir>:
{
    126e:	711d                	addi	sp,sp,-96
    1270:	ec86                	sd	ra,88(sp)
    1272:	e8a2                	sd	s0,80(sp)
    1274:	e4a6                	sd	s1,72(sp)
    1276:	e0ca                	sd	s2,64(sp)
    1278:	fc4e                	sd	s3,56(sp)
    127a:	f852                	sd	s4,48(sp)
    127c:	f456                	sd	s5,40(sp)
    127e:	f05a                	sd	s6,32(sp)
    1280:	ec5e                	sd	s7,24(sp)
    1282:	1080                	addi	s0,sp,96
    1284:	89aa                	mv	s3,a0
  unlink("bd");
    1286:	00006517          	auipc	a0,0x6
    128a:	a9250513          	addi	a0,a0,-1390 # 6d18 <malloc+0x874>
    128e:	00005097          	auipc	ra,0x5
    1292:	d48080e7          	jalr	-696(ra) # 5fd6 <unlink>
  fd = open("bd", O_CREATE);
    1296:	20000593          	li	a1,512
    129a:	00006517          	auipc	a0,0x6
    129e:	a7e50513          	addi	a0,a0,-1410 # 6d18 <malloc+0x874>
    12a2:	00005097          	auipc	ra,0x5
    12a6:	d24080e7          	jalr	-732(ra) # 5fc6 <open>
  if(fd < 0){
    12aa:	0c054c63          	bltz	a0,1382 <bigdir+0x114>
  close(fd);
    12ae:	00005097          	auipc	ra,0x5
    12b2:	d00080e7          	jalr	-768(ra) # 5fae <close>
  for(i = 0; i < N; i++){
    12b6:	4901                	li	s2,0
    name[0] = 'x';
    12b8:	07800b13          	li	s6,120
    if(link("bd", name) != 0){
    12bc:	fa040a93          	addi	s5,s0,-96
    12c0:	00006a17          	auipc	s4,0x6
    12c4:	a58a0a13          	addi	s4,s4,-1448 # 6d18 <malloc+0x874>
  for(i = 0; i < N; i++){
    12c8:	1f400b93          	li	s7,500
    name[0] = 'x';
    12cc:	fb640023          	sb	s6,-96(s0)
    name[1] = '0' + (i / 64);
    12d0:	41f9571b          	sraiw	a4,s2,0x1f
    12d4:	01a7571b          	srliw	a4,a4,0x1a
    12d8:	012707bb          	addw	a5,a4,s2
    12dc:	4067d69b          	sraiw	a3,a5,0x6
    12e0:	0306869b          	addiw	a3,a3,48
    12e4:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    12e8:	03f7f793          	andi	a5,a5,63
    12ec:	9f99                	subw	a5,a5,a4
    12ee:	0307879b          	addiw	a5,a5,48
    12f2:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    12f6:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
    12fa:	85d6                	mv	a1,s5
    12fc:	8552                	mv	a0,s4
    12fe:	00005097          	auipc	ra,0x5
    1302:	ce8080e7          	jalr	-792(ra) # 5fe6 <link>
    1306:	84aa                	mv	s1,a0
    1308:	e959                	bnez	a0,139e <bigdir+0x130>
  for(i = 0; i < N; i++){
    130a:	2905                	addiw	s2,s2,1
    130c:	fd7910e3          	bne	s2,s7,12cc <bigdir+0x5e>
  unlink("bd");
    1310:	00006517          	auipc	a0,0x6
    1314:	a0850513          	addi	a0,a0,-1528 # 6d18 <malloc+0x874>
    1318:	00005097          	auipc	ra,0x5
    131c:	cbe080e7          	jalr	-834(ra) # 5fd6 <unlink>
    name[0] = 'x';
    1320:	07800a13          	li	s4,120
    if(unlink(name) != 0){
    1324:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
    1328:	1f400a93          	li	s5,500
    name[0] = 'x';
    132c:	fb440023          	sb	s4,-96(s0)
    name[1] = '0' + (i / 64);
    1330:	41f4d71b          	sraiw	a4,s1,0x1f
    1334:	01a7571b          	srliw	a4,a4,0x1a
    1338:	009707bb          	addw	a5,a4,s1
    133c:	4067d69b          	sraiw	a3,a5,0x6
    1340:	0306869b          	addiw	a3,a3,48
    1344:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    1348:	03f7f793          	andi	a5,a5,63
    134c:	9f99                	subw	a5,a5,a4
    134e:	0307879b          	addiw	a5,a5,48
    1352:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    1356:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
    135a:	854a                	mv	a0,s2
    135c:	00005097          	auipc	ra,0x5
    1360:	c7a080e7          	jalr	-902(ra) # 5fd6 <unlink>
    1364:	ed31                	bnez	a0,13c0 <bigdir+0x152>
  for(i = 0; i < N; i++){
    1366:	2485                	addiw	s1,s1,1
    1368:	fd5492e3          	bne	s1,s5,132c <bigdir+0xbe>
}
    136c:	60e6                	ld	ra,88(sp)
    136e:	6446                	ld	s0,80(sp)
    1370:	64a6                	ld	s1,72(sp)
    1372:	6906                	ld	s2,64(sp)
    1374:	79e2                	ld	s3,56(sp)
    1376:	7a42                	ld	s4,48(sp)
    1378:	7aa2                	ld	s5,40(sp)
    137a:	7b02                	ld	s6,32(sp)
    137c:	6be2                	ld	s7,24(sp)
    137e:	6125                	addi	sp,sp,96
    1380:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1382:	85ce                	mv	a1,s3
    1384:	00006517          	auipc	a0,0x6
    1388:	99c50513          	addi	a0,a0,-1636 # 6d20 <malloc+0x87c>
    138c:	00005097          	auipc	ra,0x5
    1390:	05c080e7          	jalr	92(ra) # 63e8 <printf>
    exit(1);
    1394:	4505                	li	a0,1
    1396:	00005097          	auipc	ra,0x5
    139a:	bf0080e7          	jalr	-1040(ra) # 5f86 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    139e:	fa040693          	addi	a3,s0,-96
    13a2:	864a                	mv	a2,s2
    13a4:	85ce                	mv	a1,s3
    13a6:	00006517          	auipc	a0,0x6
    13aa:	99a50513          	addi	a0,a0,-1638 # 6d40 <malloc+0x89c>
    13ae:	00005097          	auipc	ra,0x5
    13b2:	03a080e7          	jalr	58(ra) # 63e8 <printf>
      exit(1);
    13b6:	4505                	li	a0,1
    13b8:	00005097          	auipc	ra,0x5
    13bc:	bce080e7          	jalr	-1074(ra) # 5f86 <exit>
      printf("%s: bigdir unlink failed", s);
    13c0:	85ce                	mv	a1,s3
    13c2:	00006517          	auipc	a0,0x6
    13c6:	9a650513          	addi	a0,a0,-1626 # 6d68 <malloc+0x8c4>
    13ca:	00005097          	auipc	ra,0x5
    13ce:	01e080e7          	jalr	30(ra) # 63e8 <printf>
      exit(1);
    13d2:	4505                	li	a0,1
    13d4:	00005097          	auipc	ra,0x5
    13d8:	bb2080e7          	jalr	-1102(ra) # 5f86 <exit>

00000000000013dc <pgbug>:
{
    13dc:	7179                	addi	sp,sp,-48
    13de:	f406                	sd	ra,40(sp)
    13e0:	f022                	sd	s0,32(sp)
    13e2:	ec26                	sd	s1,24(sp)
    13e4:	1800                	addi	s0,sp,48
  argv[0] = 0;
    13e6:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    13ea:	00009497          	auipc	s1,0x9
    13ee:	c1648493          	addi	s1,s1,-1002 # a000 <big>
    13f2:	fd840593          	addi	a1,s0,-40
    13f6:	6088                	ld	a0,0(s1)
    13f8:	00005097          	auipc	ra,0x5
    13fc:	bc6080e7          	jalr	-1082(ra) # 5fbe <exec>
  pipe(big);
    1400:	6088                	ld	a0,0(s1)
    1402:	00005097          	auipc	ra,0x5
    1406:	b94080e7          	jalr	-1132(ra) # 5f96 <pipe>
  exit(0);
    140a:	4501                	li	a0,0
    140c:	00005097          	auipc	ra,0x5
    1410:	b7a080e7          	jalr	-1158(ra) # 5f86 <exit>

0000000000001414 <badarg>:
{
    1414:	7139                	addi	sp,sp,-64
    1416:	fc06                	sd	ra,56(sp)
    1418:	f822                	sd	s0,48(sp)
    141a:	f426                	sd	s1,40(sp)
    141c:	f04a                	sd	s2,32(sp)
    141e:	ec4e                	sd	s3,24(sp)
    1420:	e852                	sd	s4,16(sp)
    1422:	0080                	addi	s0,sp,64
    1424:	64b1                	lui	s1,0xc
    1426:	35048493          	addi	s1,s1,848 # c350 <uninit+0xde8>
    argv[0] = (char*)0xffffffff;
    142a:	597d                	li	s2,-1
    142c:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1430:	fc040a13          	addi	s4,s0,-64
    1434:	00005997          	auipc	s3,0x5
    1438:	1a498993          	addi	s3,s3,420 # 65d8 <malloc+0x134>
    argv[0] = (char*)0xffffffff;
    143c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1440:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1444:	85d2                	mv	a1,s4
    1446:	854e                	mv	a0,s3
    1448:	00005097          	auipc	ra,0x5
    144c:	b76080e7          	jalr	-1162(ra) # 5fbe <exec>
  for(int i = 0; i < 50000; i++){
    1450:	34fd                	addiw	s1,s1,-1
    1452:	f4ed                	bnez	s1,143c <badarg+0x28>
  exit(0);
    1454:	4501                	li	a0,0
    1456:	00005097          	auipc	ra,0x5
    145a:	b30080e7          	jalr	-1232(ra) # 5f86 <exit>

000000000000145e <copyinstr2>:
{
    145e:	7155                	addi	sp,sp,-208
    1460:	e586                	sd	ra,200(sp)
    1462:	e1a2                	sd	s0,192(sp)
    1464:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1466:	f6840793          	addi	a5,s0,-152
    146a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    146e:	07800713          	li	a4,120
    1472:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1476:	0785                	addi	a5,a5,1
    1478:	fed79de3          	bne	a5,a3,1472 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    147c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1480:	f6840513          	addi	a0,s0,-152
    1484:	00005097          	auipc	ra,0x5
    1488:	b52080e7          	jalr	-1198(ra) # 5fd6 <unlink>
  if(ret != -1){
    148c:	57fd                	li	a5,-1
    148e:	0ef51063          	bne	a0,a5,156e <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1492:	20100593          	li	a1,513
    1496:	f6840513          	addi	a0,s0,-152
    149a:	00005097          	auipc	ra,0x5
    149e:	b2c080e7          	jalr	-1236(ra) # 5fc6 <open>
  if(fd != -1){
    14a2:	57fd                	li	a5,-1
    14a4:	0ef51563          	bne	a0,a5,158e <copyinstr2+0x130>
  ret = link(b, b);
    14a8:	f6840513          	addi	a0,s0,-152
    14ac:	85aa                	mv	a1,a0
    14ae:	00005097          	auipc	ra,0x5
    14b2:	b38080e7          	jalr	-1224(ra) # 5fe6 <link>
  if(ret != -1){
    14b6:	57fd                	li	a5,-1
    14b8:	0ef51b63          	bne	a0,a5,15ae <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    14bc:	00007797          	auipc	a5,0x7
    14c0:	9fc78793          	addi	a5,a5,-1540 # 7eb8 <malloc+0x1a14>
    14c4:	f4f43c23          	sd	a5,-168(s0)
    14c8:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    14cc:	f5840593          	addi	a1,s0,-168
    14d0:	f6840513          	addi	a0,s0,-152
    14d4:	00005097          	auipc	ra,0x5
    14d8:	aea080e7          	jalr	-1302(ra) # 5fbe <exec>
  if(ret != -1){
    14dc:	57fd                	li	a5,-1
    14de:	0ef51963          	bne	a0,a5,15d0 <copyinstr2+0x172>
  int pid = fork();
    14e2:	00005097          	auipc	ra,0x5
    14e6:	a9c080e7          	jalr	-1380(ra) # 5f7e <fork>
  if(pid < 0){
    14ea:	10054363          	bltz	a0,15f0 <copyinstr2+0x192>
  if(pid == 0){
    14ee:	12051463          	bnez	a0,1616 <copyinstr2+0x1b8>
    14f2:	00009797          	auipc	a5,0x9
    14f6:	06e78793          	addi	a5,a5,110 # a560 <big.0>
    14fa:	0000a697          	auipc	a3,0xa
    14fe:	06668693          	addi	a3,a3,102 # b560 <big.0+0x1000>
      big[i] = 'x';
    1502:	07800713          	li	a4,120
    1506:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    150a:	0785                	addi	a5,a5,1
    150c:	fed79de3          	bne	a5,a3,1506 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1510:	0000a797          	auipc	a5,0xa
    1514:	04078823          	sb	zero,80(a5) # b560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1518:	00007797          	auipc	a5,0x7
    151c:	42078793          	addi	a5,a5,1056 # 8938 <malloc+0x2494>
    1520:	6fb0                	ld	a2,88(a5)
    1522:	73b4                	ld	a3,96(a5)
    1524:	77b8                	ld	a4,104(a5)
    1526:	7bbc                	ld	a5,112(a5)
    1528:	f2c43823          	sd	a2,-208(s0)
    152c:	f2d43c23          	sd	a3,-200(s0)
    1530:	f4e43023          	sd	a4,-192(s0)
    1534:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1538:	f3040593          	addi	a1,s0,-208
    153c:	00005517          	auipc	a0,0x5
    1540:	09c50513          	addi	a0,a0,156 # 65d8 <malloc+0x134>
    1544:	00005097          	auipc	ra,0x5
    1548:	a7a080e7          	jalr	-1414(ra) # 5fbe <exec>
    if(ret != -1){
    154c:	57fd                	li	a5,-1
    154e:	0af50e63          	beq	a0,a5,160a <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1552:	85be                	mv	a1,a5
    1554:	00006517          	auipc	a0,0x6
    1558:	8bc50513          	addi	a0,a0,-1860 # 6e10 <malloc+0x96c>
    155c:	00005097          	auipc	ra,0x5
    1560:	e8c080e7          	jalr	-372(ra) # 63e8 <printf>
      exit(1);
    1564:	4505                	li	a0,1
    1566:	00005097          	auipc	ra,0x5
    156a:	a20080e7          	jalr	-1504(ra) # 5f86 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    156e:	862a                	mv	a2,a0
    1570:	f6840593          	addi	a1,s0,-152
    1574:	00006517          	auipc	a0,0x6
    1578:	81450513          	addi	a0,a0,-2028 # 6d88 <malloc+0x8e4>
    157c:	00005097          	auipc	ra,0x5
    1580:	e6c080e7          	jalr	-404(ra) # 63e8 <printf>
    exit(1);
    1584:	4505                	li	a0,1
    1586:	00005097          	auipc	ra,0x5
    158a:	a00080e7          	jalr	-1536(ra) # 5f86 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    158e:	862a                	mv	a2,a0
    1590:	f6840593          	addi	a1,s0,-152
    1594:	00006517          	auipc	a0,0x6
    1598:	81450513          	addi	a0,a0,-2028 # 6da8 <malloc+0x904>
    159c:	00005097          	auipc	ra,0x5
    15a0:	e4c080e7          	jalr	-436(ra) # 63e8 <printf>
    exit(1);
    15a4:	4505                	li	a0,1
    15a6:	00005097          	auipc	ra,0x5
    15aa:	9e0080e7          	jalr	-1568(ra) # 5f86 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    15ae:	f6840593          	addi	a1,s0,-152
    15b2:	86aa                	mv	a3,a0
    15b4:	862e                	mv	a2,a1
    15b6:	00006517          	auipc	a0,0x6
    15ba:	81250513          	addi	a0,a0,-2030 # 6dc8 <malloc+0x924>
    15be:	00005097          	auipc	ra,0x5
    15c2:	e2a080e7          	jalr	-470(ra) # 63e8 <printf>
    exit(1);
    15c6:	4505                	li	a0,1
    15c8:	00005097          	auipc	ra,0x5
    15cc:	9be080e7          	jalr	-1602(ra) # 5f86 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    15d0:	863e                	mv	a2,a5
    15d2:	f6840593          	addi	a1,s0,-152
    15d6:	00006517          	auipc	a0,0x6
    15da:	81a50513          	addi	a0,a0,-2022 # 6df0 <malloc+0x94c>
    15de:	00005097          	auipc	ra,0x5
    15e2:	e0a080e7          	jalr	-502(ra) # 63e8 <printf>
    exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00005097          	auipc	ra,0x5
    15ec:	99e080e7          	jalr	-1634(ra) # 5f86 <exit>
    printf("fork failed\n");
    15f0:	00007517          	auipc	a0,0x7
    15f4:	de850513          	addi	a0,a0,-536 # 83d8 <malloc+0x1f34>
    15f8:	00005097          	auipc	ra,0x5
    15fc:	df0080e7          	jalr	-528(ra) # 63e8 <printf>
    exit(1);
    1600:	4505                	li	a0,1
    1602:	00005097          	auipc	ra,0x5
    1606:	984080e7          	jalr	-1660(ra) # 5f86 <exit>
    exit(747); // OK
    160a:	2eb00513          	li	a0,747
    160e:	00005097          	auipc	ra,0x5
    1612:	978080e7          	jalr	-1672(ra) # 5f86 <exit>
  int st = 0;
    1616:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    161a:	f5440513          	addi	a0,s0,-172
    161e:	00005097          	auipc	ra,0x5
    1622:	970080e7          	jalr	-1680(ra) # 5f8e <wait>
  if(st != 747){
    1626:	f5442703          	lw	a4,-172(s0)
    162a:	2eb00793          	li	a5,747
    162e:	00f71663          	bne	a4,a5,163a <copyinstr2+0x1dc>
}
    1632:	60ae                	ld	ra,200(sp)
    1634:	640e                	ld	s0,192(sp)
    1636:	6169                	addi	sp,sp,208
    1638:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    163a:	00005517          	auipc	a0,0x5
    163e:	7fe50513          	addi	a0,a0,2046 # 6e38 <malloc+0x994>
    1642:	00005097          	auipc	ra,0x5
    1646:	da6080e7          	jalr	-602(ra) # 63e8 <printf>
    exit(1);
    164a:	4505                	li	a0,1
    164c:	00005097          	auipc	ra,0x5
    1650:	93a080e7          	jalr	-1734(ra) # 5f86 <exit>

0000000000001654 <truncate3>:
{
    1654:	7175                	addi	sp,sp,-144
    1656:	e506                	sd	ra,136(sp)
    1658:	e122                	sd	s0,128(sp)
    165a:	ecd6                	sd	s5,88(sp)
    165c:	0900                	addi	s0,sp,144
    165e:	8aaa                	mv	s5,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1660:	60100593          	li	a1,1537
    1664:	00005517          	auipc	a0,0x5
    1668:	fcc50513          	addi	a0,a0,-52 # 6630 <malloc+0x18c>
    166c:	00005097          	auipc	ra,0x5
    1670:	95a080e7          	jalr	-1702(ra) # 5fc6 <open>
    1674:	00005097          	auipc	ra,0x5
    1678:	93a080e7          	jalr	-1734(ra) # 5fae <close>
  pid = fork();
    167c:	00005097          	auipc	ra,0x5
    1680:	902080e7          	jalr	-1790(ra) # 5f7e <fork>
  if(pid < 0){
    1684:	08054b63          	bltz	a0,171a <truncate3+0xc6>
  if(pid == 0){
    1688:	ed65                	bnez	a0,1780 <truncate3+0x12c>
    168a:	fca6                	sd	s1,120(sp)
    168c:	f8ca                	sd	s2,112(sp)
    168e:	f4ce                	sd	s3,104(sp)
    1690:	f0d2                	sd	s4,96(sp)
    1692:	e8da                	sd	s6,80(sp)
    1694:	e4de                	sd	s7,72(sp)
    1696:	e0e2                	sd	s8,64(sp)
    1698:	fc66                	sd	s9,56(sp)
    169a:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    169e:	4b05                	li	s6,1
    16a0:	00005997          	auipc	s3,0x5
    16a4:	f9098993          	addi	s3,s3,-112 # 6630 <malloc+0x18c>
      int n = write(fd, "1234567890", 10);
    16a8:	4a29                	li	s4,10
    16aa:	00005b97          	auipc	s7,0x5
    16ae:	7eeb8b93          	addi	s7,s7,2030 # 6e98 <malloc+0x9f4>
      read(fd, buf, sizeof(buf));
    16b2:	f7840c93          	addi	s9,s0,-136
    16b6:	02000c13          	li	s8,32
      int fd = open("truncfile", O_WRONLY);
    16ba:	85da                	mv	a1,s6
    16bc:	854e                	mv	a0,s3
    16be:	00005097          	auipc	ra,0x5
    16c2:	908080e7          	jalr	-1784(ra) # 5fc6 <open>
    16c6:	84aa                	mv	s1,a0
      if(fd < 0){
    16c8:	06054f63          	bltz	a0,1746 <truncate3+0xf2>
      int n = write(fd, "1234567890", 10);
    16cc:	8652                	mv	a2,s4
    16ce:	85de                	mv	a1,s7
    16d0:	00005097          	auipc	ra,0x5
    16d4:	8d6080e7          	jalr	-1834(ra) # 5fa6 <write>
      if(n != 10){
    16d8:	09451563          	bne	a0,s4,1762 <truncate3+0x10e>
      close(fd);
    16dc:	8526                	mv	a0,s1
    16de:	00005097          	auipc	ra,0x5
    16e2:	8d0080e7          	jalr	-1840(ra) # 5fae <close>
      fd = open("truncfile", O_RDONLY);
    16e6:	4581                	li	a1,0
    16e8:	854e                	mv	a0,s3
    16ea:	00005097          	auipc	ra,0x5
    16ee:	8dc080e7          	jalr	-1828(ra) # 5fc6 <open>
    16f2:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    16f4:	8662                	mv	a2,s8
    16f6:	85e6                	mv	a1,s9
    16f8:	00005097          	auipc	ra,0x5
    16fc:	8a6080e7          	jalr	-1882(ra) # 5f9e <read>
      close(fd);
    1700:	8526                	mv	a0,s1
    1702:	00005097          	auipc	ra,0x5
    1706:	8ac080e7          	jalr	-1876(ra) # 5fae <close>
    for(int i = 0; i < 100; i++){
    170a:	397d                	addiw	s2,s2,-1
    170c:	fa0917e3          	bnez	s2,16ba <truncate3+0x66>
    exit(0);
    1710:	4501                	li	a0,0
    1712:	00005097          	auipc	ra,0x5
    1716:	874080e7          	jalr	-1932(ra) # 5f86 <exit>
    171a:	fca6                	sd	s1,120(sp)
    171c:	f8ca                	sd	s2,112(sp)
    171e:	f4ce                	sd	s3,104(sp)
    1720:	f0d2                	sd	s4,96(sp)
    1722:	e8da                	sd	s6,80(sp)
    1724:	e4de                	sd	s7,72(sp)
    1726:	e0e2                	sd	s8,64(sp)
    1728:	fc66                	sd	s9,56(sp)
    printf("%s: fork failed\n", s);
    172a:	85d6                	mv	a1,s5
    172c:	00005517          	auipc	a0,0x5
    1730:	73c50513          	addi	a0,a0,1852 # 6e68 <malloc+0x9c4>
    1734:	00005097          	auipc	ra,0x5
    1738:	cb4080e7          	jalr	-844(ra) # 63e8 <printf>
    exit(1);
    173c:	4505                	li	a0,1
    173e:	00005097          	auipc	ra,0x5
    1742:	848080e7          	jalr	-1976(ra) # 5f86 <exit>
        printf("%s: open failed\n", s);
    1746:	85d6                	mv	a1,s5
    1748:	00005517          	auipc	a0,0x5
    174c:	73850513          	addi	a0,a0,1848 # 6e80 <malloc+0x9dc>
    1750:	00005097          	auipc	ra,0x5
    1754:	c98080e7          	jalr	-872(ra) # 63e8 <printf>
        exit(1);
    1758:	4505                	li	a0,1
    175a:	00005097          	auipc	ra,0x5
    175e:	82c080e7          	jalr	-2004(ra) # 5f86 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1762:	862a                	mv	a2,a0
    1764:	85d6                	mv	a1,s5
    1766:	00005517          	auipc	a0,0x5
    176a:	74250513          	addi	a0,a0,1858 # 6ea8 <malloc+0xa04>
    176e:	00005097          	auipc	ra,0x5
    1772:	c7a080e7          	jalr	-902(ra) # 63e8 <printf>
        exit(1);
    1776:	4505                	li	a0,1
    1778:	00005097          	auipc	ra,0x5
    177c:	80e080e7          	jalr	-2034(ra) # 5f86 <exit>
    1780:	fca6                	sd	s1,120(sp)
    1782:	f8ca                	sd	s2,112(sp)
    1784:	f4ce                	sd	s3,104(sp)
    1786:	f0d2                	sd	s4,96(sp)
    1788:	e8da                	sd	s6,80(sp)
    178a:	e4de                	sd	s7,72(sp)
    178c:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1790:	60100b13          	li	s6,1537
    1794:	00005a17          	auipc	s4,0x5
    1798:	e9ca0a13          	addi	s4,s4,-356 # 6630 <malloc+0x18c>
    int n = write(fd, "xxx", 3);
    179c:	498d                	li	s3,3
    179e:	00005b97          	auipc	s7,0x5
    17a2:	72ab8b93          	addi	s7,s7,1834 # 6ec8 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    17a6:	85da                	mv	a1,s6
    17a8:	8552                	mv	a0,s4
    17aa:	00005097          	auipc	ra,0x5
    17ae:	81c080e7          	jalr	-2020(ra) # 5fc6 <open>
    17b2:	84aa                	mv	s1,a0
    if(fd < 0){
    17b4:	04054863          	bltz	a0,1804 <truncate3+0x1b0>
    int n = write(fd, "xxx", 3);
    17b8:	864e                	mv	a2,s3
    17ba:	85de                	mv	a1,s7
    17bc:	00004097          	auipc	ra,0x4
    17c0:	7ea080e7          	jalr	2026(ra) # 5fa6 <write>
    if(n != 3){
    17c4:	07351063          	bne	a0,s3,1824 <truncate3+0x1d0>
    close(fd);
    17c8:	8526                	mv	a0,s1
    17ca:	00004097          	auipc	ra,0x4
    17ce:	7e4080e7          	jalr	2020(ra) # 5fae <close>
  for(int i = 0; i < 150; i++){
    17d2:	397d                	addiw	s2,s2,-1
    17d4:	fc0919e3          	bnez	s2,17a6 <truncate3+0x152>
    17d8:	e0e2                	sd	s8,64(sp)
    17da:	fc66                	sd	s9,56(sp)
  wait(&xstatus);
    17dc:	f9c40513          	addi	a0,s0,-100
    17e0:	00004097          	auipc	ra,0x4
    17e4:	7ae080e7          	jalr	1966(ra) # 5f8e <wait>
  unlink("truncfile");
    17e8:	00005517          	auipc	a0,0x5
    17ec:	e4850513          	addi	a0,a0,-440 # 6630 <malloc+0x18c>
    17f0:	00004097          	auipc	ra,0x4
    17f4:	7e6080e7          	jalr	2022(ra) # 5fd6 <unlink>
  exit(xstatus);
    17f8:	f9c42503          	lw	a0,-100(s0)
    17fc:	00004097          	auipc	ra,0x4
    1800:	78a080e7          	jalr	1930(ra) # 5f86 <exit>
    1804:	e0e2                	sd	s8,64(sp)
    1806:	fc66                	sd	s9,56(sp)
      printf("%s: open failed\n", s);
    1808:	85d6                	mv	a1,s5
    180a:	00005517          	auipc	a0,0x5
    180e:	67650513          	addi	a0,a0,1654 # 6e80 <malloc+0x9dc>
    1812:	00005097          	auipc	ra,0x5
    1816:	bd6080e7          	jalr	-1066(ra) # 63e8 <printf>
      exit(1);
    181a:	4505                	li	a0,1
    181c:	00004097          	auipc	ra,0x4
    1820:	76a080e7          	jalr	1898(ra) # 5f86 <exit>
    1824:	e0e2                	sd	s8,64(sp)
    1826:	fc66                	sd	s9,56(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    1828:	862a                	mv	a2,a0
    182a:	85d6                	mv	a1,s5
    182c:	00005517          	auipc	a0,0x5
    1830:	6a450513          	addi	a0,a0,1700 # 6ed0 <malloc+0xa2c>
    1834:	00005097          	auipc	ra,0x5
    1838:	bb4080e7          	jalr	-1100(ra) # 63e8 <printf>
      exit(1);
    183c:	4505                	li	a0,1
    183e:	00004097          	auipc	ra,0x4
    1842:	748080e7          	jalr	1864(ra) # 5f86 <exit>

0000000000001846 <exectest>:
{
    1846:	715d                	addi	sp,sp,-80
    1848:	e486                	sd	ra,72(sp)
    184a:	e0a2                	sd	s0,64(sp)
    184c:	f84a                	sd	s2,48(sp)
    184e:	0880                	addi	s0,sp,80
    1850:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1852:	00005797          	auipc	a5,0x5
    1856:	d8678793          	addi	a5,a5,-634 # 65d8 <malloc+0x134>
    185a:	fcf43023          	sd	a5,-64(s0)
    185e:	00005797          	auipc	a5,0x5
    1862:	69278793          	addi	a5,a5,1682 # 6ef0 <malloc+0xa4c>
    1866:	fcf43423          	sd	a5,-56(s0)
    186a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    186e:	00005517          	auipc	a0,0x5
    1872:	68a50513          	addi	a0,a0,1674 # 6ef8 <malloc+0xa54>
    1876:	00004097          	auipc	ra,0x4
    187a:	760080e7          	jalr	1888(ra) # 5fd6 <unlink>
  pid = fork();
    187e:	00004097          	auipc	ra,0x4
    1882:	700080e7          	jalr	1792(ra) # 5f7e <fork>
  if(pid < 0) {
    1886:	04054763          	bltz	a0,18d4 <exectest+0x8e>
    188a:	fc26                	sd	s1,56(sp)
    188c:	84aa                	mv	s1,a0
  if(pid == 0) {
    188e:	ed41                	bnez	a0,1926 <exectest+0xe0>
    close(1);
    1890:	4505                	li	a0,1
    1892:	00004097          	auipc	ra,0x4
    1896:	71c080e7          	jalr	1820(ra) # 5fae <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    189a:	20100593          	li	a1,513
    189e:	00005517          	auipc	a0,0x5
    18a2:	65a50513          	addi	a0,a0,1626 # 6ef8 <malloc+0xa54>
    18a6:	00004097          	auipc	ra,0x4
    18aa:	720080e7          	jalr	1824(ra) # 5fc6 <open>
    if(fd < 0) {
    18ae:	04054263          	bltz	a0,18f2 <exectest+0xac>
    if(fd != 1) {
    18b2:	4785                	li	a5,1
    18b4:	04f50d63          	beq	a0,a5,190e <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    18b8:	85ca                	mv	a1,s2
    18ba:	00005517          	auipc	a0,0x5
    18be:	65e50513          	addi	a0,a0,1630 # 6f18 <malloc+0xa74>
    18c2:	00005097          	auipc	ra,0x5
    18c6:	b26080e7          	jalr	-1242(ra) # 63e8 <printf>
      exit(1);
    18ca:	4505                	li	a0,1
    18cc:	00004097          	auipc	ra,0x4
    18d0:	6ba080e7          	jalr	1722(ra) # 5f86 <exit>
    18d4:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    18d6:	85ca                	mv	a1,s2
    18d8:	00005517          	auipc	a0,0x5
    18dc:	59050513          	addi	a0,a0,1424 # 6e68 <malloc+0x9c4>
    18e0:	00005097          	auipc	ra,0x5
    18e4:	b08080e7          	jalr	-1272(ra) # 63e8 <printf>
     exit(1);
    18e8:	4505                	li	a0,1
    18ea:	00004097          	auipc	ra,0x4
    18ee:	69c080e7          	jalr	1692(ra) # 5f86 <exit>
      printf("%s: create failed\n", s);
    18f2:	85ca                	mv	a1,s2
    18f4:	00005517          	auipc	a0,0x5
    18f8:	60c50513          	addi	a0,a0,1548 # 6f00 <malloc+0xa5c>
    18fc:	00005097          	auipc	ra,0x5
    1900:	aec080e7          	jalr	-1300(ra) # 63e8 <printf>
      exit(1);
    1904:	4505                	li	a0,1
    1906:	00004097          	auipc	ra,0x4
    190a:	680080e7          	jalr	1664(ra) # 5f86 <exit>
    if(exec("echo", echoargv) < 0){
    190e:	fc040593          	addi	a1,s0,-64
    1912:	00005517          	auipc	a0,0x5
    1916:	cc650513          	addi	a0,a0,-826 # 65d8 <malloc+0x134>
    191a:	00004097          	auipc	ra,0x4
    191e:	6a4080e7          	jalr	1700(ra) # 5fbe <exec>
    1922:	02054163          	bltz	a0,1944 <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    1926:	fdc40513          	addi	a0,s0,-36
    192a:	00004097          	auipc	ra,0x4
    192e:	664080e7          	jalr	1636(ra) # 5f8e <wait>
    1932:	02951763          	bne	a0,s1,1960 <exectest+0x11a>
  if(xstatus != 0)
    1936:	fdc42503          	lw	a0,-36(s0)
    193a:	cd0d                	beqz	a0,1974 <exectest+0x12e>
    exit(xstatus);
    193c:	00004097          	auipc	ra,0x4
    1940:	64a080e7          	jalr	1610(ra) # 5f86 <exit>
      printf("%s: exec echo failed\n", s);
    1944:	85ca                	mv	a1,s2
    1946:	00005517          	auipc	a0,0x5
    194a:	5e250513          	addi	a0,a0,1506 # 6f28 <malloc+0xa84>
    194e:	00005097          	auipc	ra,0x5
    1952:	a9a080e7          	jalr	-1382(ra) # 63e8 <printf>
      exit(1);
    1956:	4505                	li	a0,1
    1958:	00004097          	auipc	ra,0x4
    195c:	62e080e7          	jalr	1582(ra) # 5f86 <exit>
    printf("%s: wait failed!\n", s);
    1960:	85ca                	mv	a1,s2
    1962:	00005517          	auipc	a0,0x5
    1966:	5de50513          	addi	a0,a0,1502 # 6f40 <malloc+0xa9c>
    196a:	00005097          	auipc	ra,0x5
    196e:	a7e080e7          	jalr	-1410(ra) # 63e8 <printf>
    1972:	b7d1                	j	1936 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    1974:	4581                	li	a1,0
    1976:	00005517          	auipc	a0,0x5
    197a:	58250513          	addi	a0,a0,1410 # 6ef8 <malloc+0xa54>
    197e:	00004097          	auipc	ra,0x4
    1982:	648080e7          	jalr	1608(ra) # 5fc6 <open>
  if(fd < 0) {
    1986:	02054a63          	bltz	a0,19ba <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    198a:	4609                	li	a2,2
    198c:	fb840593          	addi	a1,s0,-72
    1990:	00004097          	auipc	ra,0x4
    1994:	60e080e7          	jalr	1550(ra) # 5f9e <read>
    1998:	4789                	li	a5,2
    199a:	02f50e63          	beq	a0,a5,19d6 <exectest+0x190>
    printf("%s: read failed\n", s);
    199e:	85ca                	mv	a1,s2
    19a0:	00005517          	auipc	a0,0x5
    19a4:	00850513          	addi	a0,a0,8 # 69a8 <malloc+0x504>
    19a8:	00005097          	auipc	ra,0x5
    19ac:	a40080e7          	jalr	-1472(ra) # 63e8 <printf>
    exit(1);
    19b0:	4505                	li	a0,1
    19b2:	00004097          	auipc	ra,0x4
    19b6:	5d4080e7          	jalr	1492(ra) # 5f86 <exit>
    printf("%s: open failed\n", s);
    19ba:	85ca                	mv	a1,s2
    19bc:	00005517          	auipc	a0,0x5
    19c0:	4c450513          	addi	a0,a0,1220 # 6e80 <malloc+0x9dc>
    19c4:	00005097          	auipc	ra,0x5
    19c8:	a24080e7          	jalr	-1500(ra) # 63e8 <printf>
    exit(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	5b8080e7          	jalr	1464(ra) # 5f86 <exit>
  unlink("echo-ok");
    19d6:	00005517          	auipc	a0,0x5
    19da:	52250513          	addi	a0,a0,1314 # 6ef8 <malloc+0xa54>
    19de:	00004097          	auipc	ra,0x4
    19e2:	5f8080e7          	jalr	1528(ra) # 5fd6 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    19e6:	fb844703          	lbu	a4,-72(s0)
    19ea:	04f00793          	li	a5,79
    19ee:	00f71863          	bne	a4,a5,19fe <exectest+0x1b8>
    19f2:	fb944703          	lbu	a4,-71(s0)
    19f6:	04b00793          	li	a5,75
    19fa:	02f70063          	beq	a4,a5,1a1a <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    19fe:	85ca                	mv	a1,s2
    1a00:	00005517          	auipc	a0,0x5
    1a04:	55850513          	addi	a0,a0,1368 # 6f58 <malloc+0xab4>
    1a08:	00005097          	auipc	ra,0x5
    1a0c:	9e0080e7          	jalr	-1568(ra) # 63e8 <printf>
    exit(1);
    1a10:	4505                	li	a0,1
    1a12:	00004097          	auipc	ra,0x4
    1a16:	574080e7          	jalr	1396(ra) # 5f86 <exit>
    exit(0);
    1a1a:	4501                	li	a0,0
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	56a080e7          	jalr	1386(ra) # 5f86 <exit>

0000000000001a24 <pipe1>:
{
    1a24:	711d                	addi	sp,sp,-96
    1a26:	ec86                	sd	ra,88(sp)
    1a28:	e8a2                	sd	s0,80(sp)
    1a2a:	e0ca                	sd	s2,64(sp)
    1a2c:	1080                	addi	s0,sp,96
    1a2e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1a30:	fa840513          	addi	a0,s0,-88
    1a34:	00004097          	auipc	ra,0x4
    1a38:	562080e7          	jalr	1378(ra) # 5f96 <pipe>
    1a3c:	ed2d                	bnez	a0,1ab6 <pipe1+0x92>
    1a3e:	e4a6                	sd	s1,72(sp)
    1a40:	f852                	sd	s4,48(sp)
    1a42:	84aa                	mv	s1,a0
  pid = fork();
    1a44:	00004097          	auipc	ra,0x4
    1a48:	53a080e7          	jalr	1338(ra) # 5f7e <fork>
    1a4c:	8a2a                	mv	s4,a0
  if(pid == 0){
    1a4e:	c949                	beqz	a0,1ae0 <pipe1+0xbc>
  } else if(pid > 0){
    1a50:	18a05d63          	blez	a0,1bea <pipe1+0x1c6>
    1a54:	fc4e                	sd	s3,56(sp)
    1a56:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1a58:	fac42503          	lw	a0,-84(s0)
    1a5c:	00004097          	auipc	ra,0x4
    1a60:	552080e7          	jalr	1362(ra) # 5fae <close>
    total = 0;
    1a64:	8a26                	mv	s4,s1
    cc = 1;
    1a66:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1a68:	0000ca97          	auipc	s5,0xc
    1a6c:	210a8a93          	addi	s5,s5,528 # dc78 <buf>
    1a70:	864e                	mv	a2,s3
    1a72:	85d6                	mv	a1,s5
    1a74:	fa842503          	lw	a0,-88(s0)
    1a78:	00004097          	auipc	ra,0x4
    1a7c:	526080e7          	jalr	1318(ra) # 5f9e <read>
    1a80:	10a05963          	blez	a0,1b92 <pipe1+0x16e>
    1a84:	0000c717          	auipc	a4,0xc
    1a88:	1f470713          	addi	a4,a4,500 # dc78 <buf>
    1a8c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1a90:	00074683          	lbu	a3,0(a4)
    1a94:	0ff4f793          	zext.b	a5,s1
    1a98:	2485                	addiw	s1,s1,1
    1a9a:	0cf69a63          	bne	a3,a5,1b6e <pipe1+0x14a>
      for(i = 0; i < n; i++){
    1a9e:	0705                	addi	a4,a4,1
    1aa0:	fec498e3          	bne	s1,a2,1a90 <pipe1+0x6c>
      total += n;
    1aa4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1aa8:	0019999b          	slliw	s3,s3,0x1
      if(cc > sizeof(buf))
    1aac:	678d                	lui	a5,0x3
    1aae:	fd37f1e3          	bgeu	a5,s3,1a70 <pipe1+0x4c>
        cc = sizeof(buf);
    1ab2:	89be                	mv	s3,a5
    1ab4:	bf75                	j	1a70 <pipe1+0x4c>
    1ab6:	e4a6                	sd	s1,72(sp)
    1ab8:	fc4e                	sd	s3,56(sp)
    1aba:	f852                	sd	s4,48(sp)
    1abc:	f456                	sd	s5,40(sp)
    1abe:	f05a                	sd	s6,32(sp)
    1ac0:	ec5e                	sd	s7,24(sp)
    1ac2:	e862                	sd	s8,16(sp)
    printf("%s: pipe() failed\n", s);
    1ac4:	85ca                	mv	a1,s2
    1ac6:	00005517          	auipc	a0,0x5
    1aca:	4aa50513          	addi	a0,a0,1194 # 6f70 <malloc+0xacc>
    1ace:	00005097          	auipc	ra,0x5
    1ad2:	91a080e7          	jalr	-1766(ra) # 63e8 <printf>
    exit(1);
    1ad6:	4505                	li	a0,1
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	4ae080e7          	jalr	1198(ra) # 5f86 <exit>
    1ae0:	fc4e                	sd	s3,56(sp)
    1ae2:	f456                	sd	s5,40(sp)
    1ae4:	f05a                	sd	s6,32(sp)
    1ae6:	ec5e                	sd	s7,24(sp)
    1ae8:	e862                	sd	s8,16(sp)
    close(fds[0]);
    1aea:	fa842503          	lw	a0,-88(s0)
    1aee:	00004097          	auipc	ra,0x4
    1af2:	4c0080e7          	jalr	1216(ra) # 5fae <close>
    for(n = 0; n < N; n++){
    1af6:	0000cb97          	auipc	s7,0xc
    1afa:	182b8b93          	addi	s7,s7,386 # dc78 <buf>
    1afe:	417004bb          	negw	s1,s7
    1b02:	0ff4f493          	zext.b	s1,s1
    1b06:	409b8993          	addi	s3,s7,1033
      if(write(fds[1], buf, SZ) != SZ){
    1b0a:	40900a93          	li	s5,1033
    1b0e:	8c5e                	mv	s8,s7
    for(n = 0; n < N; n++){
    1b10:	6b05                	lui	s6,0x1
    1b12:	42db0b13          	addi	s6,s6,1069 # 142d <badarg+0x19>
{
    1b16:	87de                	mv	a5,s7
        buf[i] = seq++;
    1b18:	0097873b          	addw	a4,a5,s1
    1b1c:	00e78023          	sb	a4,0(a5) # 3000 <sbrklast+0xa8>
      for(i = 0; i < SZ; i++)
    1b20:	0785                	addi	a5,a5,1
    1b22:	ff379be3          	bne	a5,s3,1b18 <pipe1+0xf4>
    1b26:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1b2a:	8656                	mv	a2,s5
    1b2c:	85e2                	mv	a1,s8
    1b2e:	fac42503          	lw	a0,-84(s0)
    1b32:	00004097          	auipc	ra,0x4
    1b36:	474080e7          	jalr	1140(ra) # 5fa6 <write>
    1b3a:	01551c63          	bne	a0,s5,1b52 <pipe1+0x12e>
    for(n = 0; n < N; n++){
    1b3e:	24a5                	addiw	s1,s1,9
    1b40:	0ff4f493          	zext.b	s1,s1
    1b44:	fd6a19e3          	bne	s4,s6,1b16 <pipe1+0xf2>
    exit(0);
    1b48:	4501                	li	a0,0
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	43c080e7          	jalr	1084(ra) # 5f86 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1b52:	85ca                	mv	a1,s2
    1b54:	00005517          	auipc	a0,0x5
    1b58:	43450513          	addi	a0,a0,1076 # 6f88 <malloc+0xae4>
    1b5c:	00005097          	auipc	ra,0x5
    1b60:	88c080e7          	jalr	-1908(ra) # 63e8 <printf>
        exit(1);
    1b64:	4505                	li	a0,1
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	420080e7          	jalr	1056(ra) # 5f86 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1b6e:	85ca                	mv	a1,s2
    1b70:	00005517          	auipc	a0,0x5
    1b74:	43050513          	addi	a0,a0,1072 # 6fa0 <malloc+0xafc>
    1b78:	00005097          	auipc	ra,0x5
    1b7c:	870080e7          	jalr	-1936(ra) # 63e8 <printf>
          return;
    1b80:	64a6                	ld	s1,72(sp)
    1b82:	79e2                	ld	s3,56(sp)
    1b84:	7a42                	ld	s4,48(sp)
    1b86:	7aa2                	ld	s5,40(sp)
}
    1b88:	60e6                	ld	ra,88(sp)
    1b8a:	6446                	ld	s0,80(sp)
    1b8c:	6906                	ld	s2,64(sp)
    1b8e:	6125                	addi	sp,sp,96
    1b90:	8082                	ret
    if(total != N * SZ){
    1b92:	6785                	lui	a5,0x1
    1b94:	42d78793          	addi	a5,a5,1069 # 142d <badarg+0x19>
    1b98:	02fa0463          	beq	s4,a5,1bc0 <pipe1+0x19c>
    1b9c:	f05a                	sd	s6,32(sp)
    1b9e:	ec5e                	sd	s7,24(sp)
    1ba0:	e862                	sd	s8,16(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1ba2:	8652                	mv	a2,s4
    1ba4:	85ca                	mv	a1,s2
    1ba6:	00005517          	auipc	a0,0x5
    1baa:	41250513          	addi	a0,a0,1042 # 6fb8 <malloc+0xb14>
    1bae:	00005097          	auipc	ra,0x5
    1bb2:	83a080e7          	jalr	-1990(ra) # 63e8 <printf>
      exit(1);
    1bb6:	4505                	li	a0,1
    1bb8:	00004097          	auipc	ra,0x4
    1bbc:	3ce080e7          	jalr	974(ra) # 5f86 <exit>
    1bc0:	f05a                	sd	s6,32(sp)
    1bc2:	ec5e                	sd	s7,24(sp)
    1bc4:	e862                	sd	s8,16(sp)
    close(fds[0]);
    1bc6:	fa842503          	lw	a0,-88(s0)
    1bca:	00004097          	auipc	ra,0x4
    1bce:	3e4080e7          	jalr	996(ra) # 5fae <close>
    wait(&xstatus);
    1bd2:	fa440513          	addi	a0,s0,-92
    1bd6:	00004097          	auipc	ra,0x4
    1bda:	3b8080e7          	jalr	952(ra) # 5f8e <wait>
    exit(xstatus);
    1bde:	fa442503          	lw	a0,-92(s0)
    1be2:	00004097          	auipc	ra,0x4
    1be6:	3a4080e7          	jalr	932(ra) # 5f86 <exit>
    1bea:	fc4e                	sd	s3,56(sp)
    1bec:	f456                	sd	s5,40(sp)
    1bee:	f05a                	sd	s6,32(sp)
    1bf0:	ec5e                	sd	s7,24(sp)
    1bf2:	e862                	sd	s8,16(sp)
    printf("%s: fork() failed\n", s);
    1bf4:	85ca                	mv	a1,s2
    1bf6:	00005517          	auipc	a0,0x5
    1bfa:	3e250513          	addi	a0,a0,994 # 6fd8 <malloc+0xb34>
    1bfe:	00004097          	auipc	ra,0x4
    1c02:	7ea080e7          	jalr	2026(ra) # 63e8 <printf>
    exit(1);
    1c06:	4505                	li	a0,1
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	37e080e7          	jalr	894(ra) # 5f86 <exit>

0000000000001c10 <exitwait>:
{
    1c10:	715d                	addi	sp,sp,-80
    1c12:	e486                	sd	ra,72(sp)
    1c14:	e0a2                	sd	s0,64(sp)
    1c16:	fc26                	sd	s1,56(sp)
    1c18:	f84a                	sd	s2,48(sp)
    1c1a:	f44e                	sd	s3,40(sp)
    1c1c:	f052                	sd	s4,32(sp)
    1c1e:	ec56                	sd	s5,24(sp)
    1c20:	0880                	addi	s0,sp,80
    1c22:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    1c24:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    1c26:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    1c2a:	06400a13          	li	s4,100
    pid = fork();
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	350080e7          	jalr	848(ra) # 5f7e <fork>
    1c36:	84aa                	mv	s1,a0
    if(pid < 0){
    1c38:	02054a63          	bltz	a0,1c6c <exitwait+0x5c>
    if(pid){
    1c3c:	c151                	beqz	a0,1cc0 <exitwait+0xb0>
      if(wait(&xstate) != pid){
    1c3e:	854e                	mv	a0,s3
    1c40:	00004097          	auipc	ra,0x4
    1c44:	34e080e7          	jalr	846(ra) # 5f8e <wait>
    1c48:	04951063          	bne	a0,s1,1c88 <exitwait+0x78>
      if(i != xstate) {
    1c4c:	fbc42783          	lw	a5,-68(s0)
    1c50:	05279a63          	bne	a5,s2,1ca4 <exitwait+0x94>
  for(i = 0; i < 100; i++){
    1c54:	2905                	addiw	s2,s2,1
    1c56:	fd491ce3          	bne	s2,s4,1c2e <exitwait+0x1e>
}
    1c5a:	60a6                	ld	ra,72(sp)
    1c5c:	6406                	ld	s0,64(sp)
    1c5e:	74e2                	ld	s1,56(sp)
    1c60:	7942                	ld	s2,48(sp)
    1c62:	79a2                	ld	s3,40(sp)
    1c64:	7a02                	ld	s4,32(sp)
    1c66:	6ae2                	ld	s5,24(sp)
    1c68:	6161                	addi	sp,sp,80
    1c6a:	8082                	ret
      printf("%s: fork failed\n", s);
    1c6c:	85d6                	mv	a1,s5
    1c6e:	00005517          	auipc	a0,0x5
    1c72:	1fa50513          	addi	a0,a0,506 # 6e68 <malloc+0x9c4>
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	772080e7          	jalr	1906(ra) # 63e8 <printf>
      exit(1);
    1c7e:	4505                	li	a0,1
    1c80:	00004097          	auipc	ra,0x4
    1c84:	306080e7          	jalr	774(ra) # 5f86 <exit>
        printf("%s: wait wrong pid\n", s);
    1c88:	85d6                	mv	a1,s5
    1c8a:	00005517          	auipc	a0,0x5
    1c8e:	36650513          	addi	a0,a0,870 # 6ff0 <malloc+0xb4c>
    1c92:	00004097          	auipc	ra,0x4
    1c96:	756080e7          	jalr	1878(ra) # 63e8 <printf>
        exit(1);
    1c9a:	4505                	li	a0,1
    1c9c:	00004097          	auipc	ra,0x4
    1ca0:	2ea080e7          	jalr	746(ra) # 5f86 <exit>
        printf("%s: wait wrong exit status\n", s);
    1ca4:	85d6                	mv	a1,s5
    1ca6:	00005517          	auipc	a0,0x5
    1caa:	36250513          	addi	a0,a0,866 # 7008 <malloc+0xb64>
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	73a080e7          	jalr	1850(ra) # 63e8 <printf>
        exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	2ce080e7          	jalr	718(ra) # 5f86 <exit>
      exit(i);
    1cc0:	854a                	mv	a0,s2
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	2c4080e7          	jalr	708(ra) # 5f86 <exit>

0000000000001cca <twochildren>:
{
    1cca:	1101                	addi	sp,sp,-32
    1ccc:	ec06                	sd	ra,24(sp)
    1cce:	e822                	sd	s0,16(sp)
    1cd0:	e426                	sd	s1,8(sp)
    1cd2:	e04a                	sd	s2,0(sp)
    1cd4:	1000                	addi	s0,sp,32
    1cd6:	892a                	mv	s2,a0
    1cd8:	3e800493          	li	s1,1000
    int pid1 = fork();
    1cdc:	00004097          	auipc	ra,0x4
    1ce0:	2a2080e7          	jalr	674(ra) # 5f7e <fork>
    if(pid1 < 0){
    1ce4:	02054c63          	bltz	a0,1d1c <twochildren+0x52>
    if(pid1 == 0){
    1ce8:	c921                	beqz	a0,1d38 <twochildren+0x6e>
      int pid2 = fork();
    1cea:	00004097          	auipc	ra,0x4
    1cee:	294080e7          	jalr	660(ra) # 5f7e <fork>
      if(pid2 < 0){
    1cf2:	04054763          	bltz	a0,1d40 <twochildren+0x76>
      if(pid2 == 0){
    1cf6:	c13d                	beqz	a0,1d5c <twochildren+0x92>
        wait(0);
    1cf8:	4501                	li	a0,0
    1cfa:	00004097          	auipc	ra,0x4
    1cfe:	294080e7          	jalr	660(ra) # 5f8e <wait>
        wait(0);
    1d02:	4501                	li	a0,0
    1d04:	00004097          	auipc	ra,0x4
    1d08:	28a080e7          	jalr	650(ra) # 5f8e <wait>
  for(int i = 0; i < 1000; i++){
    1d0c:	34fd                	addiw	s1,s1,-1
    1d0e:	f4f9                	bnez	s1,1cdc <twochildren+0x12>
}
    1d10:	60e2                	ld	ra,24(sp)
    1d12:	6442                	ld	s0,16(sp)
    1d14:	64a2                	ld	s1,8(sp)
    1d16:	6902                	ld	s2,0(sp)
    1d18:	6105                	addi	sp,sp,32
    1d1a:	8082                	ret
      printf("%s: fork failed\n", s);
    1d1c:	85ca                	mv	a1,s2
    1d1e:	00005517          	auipc	a0,0x5
    1d22:	14a50513          	addi	a0,a0,330 # 6e68 <malloc+0x9c4>
    1d26:	00004097          	auipc	ra,0x4
    1d2a:	6c2080e7          	jalr	1730(ra) # 63e8 <printf>
      exit(1);
    1d2e:	4505                	li	a0,1
    1d30:	00004097          	auipc	ra,0x4
    1d34:	256080e7          	jalr	598(ra) # 5f86 <exit>
      exit(0);
    1d38:	00004097          	auipc	ra,0x4
    1d3c:	24e080e7          	jalr	590(ra) # 5f86 <exit>
        printf("%s: fork failed\n", s);
    1d40:	85ca                	mv	a1,s2
    1d42:	00005517          	auipc	a0,0x5
    1d46:	12650513          	addi	a0,a0,294 # 6e68 <malloc+0x9c4>
    1d4a:	00004097          	auipc	ra,0x4
    1d4e:	69e080e7          	jalr	1694(ra) # 63e8 <printf>
        exit(1);
    1d52:	4505                	li	a0,1
    1d54:	00004097          	auipc	ra,0x4
    1d58:	232080e7          	jalr	562(ra) # 5f86 <exit>
        exit(0);
    1d5c:	00004097          	auipc	ra,0x4
    1d60:	22a080e7          	jalr	554(ra) # 5f86 <exit>

0000000000001d64 <forkfork>:
{
    1d64:	7179                	addi	sp,sp,-48
    1d66:	f406                	sd	ra,40(sp)
    1d68:	f022                	sd	s0,32(sp)
    1d6a:	ec26                	sd	s1,24(sp)
    1d6c:	1800                	addi	s0,sp,48
    1d6e:	84aa                	mv	s1,a0
    int pid = fork();
    1d70:	00004097          	auipc	ra,0x4
    1d74:	20e080e7          	jalr	526(ra) # 5f7e <fork>
    if(pid < 0){
    1d78:	04054163          	bltz	a0,1dba <forkfork+0x56>
    if(pid == 0){
    1d7c:	cd29                	beqz	a0,1dd6 <forkfork+0x72>
    int pid = fork();
    1d7e:	00004097          	auipc	ra,0x4
    1d82:	200080e7          	jalr	512(ra) # 5f7e <fork>
    if(pid < 0){
    1d86:	02054a63          	bltz	a0,1dba <forkfork+0x56>
    if(pid == 0){
    1d8a:	c531                	beqz	a0,1dd6 <forkfork+0x72>
    wait(&xstatus);
    1d8c:	fdc40513          	addi	a0,s0,-36
    1d90:	00004097          	auipc	ra,0x4
    1d94:	1fe080e7          	jalr	510(ra) # 5f8e <wait>
    if(xstatus != 0) {
    1d98:	fdc42783          	lw	a5,-36(s0)
    1d9c:	ebbd                	bnez	a5,1e12 <forkfork+0xae>
    wait(&xstatus);
    1d9e:	fdc40513          	addi	a0,s0,-36
    1da2:	00004097          	auipc	ra,0x4
    1da6:	1ec080e7          	jalr	492(ra) # 5f8e <wait>
    if(xstatus != 0) {
    1daa:	fdc42783          	lw	a5,-36(s0)
    1dae:	e3b5                	bnez	a5,1e12 <forkfork+0xae>
}
    1db0:	70a2                	ld	ra,40(sp)
    1db2:	7402                	ld	s0,32(sp)
    1db4:	64e2                	ld	s1,24(sp)
    1db6:	6145                	addi	sp,sp,48
    1db8:	8082                	ret
      printf("%s: fork failed", s);
    1dba:	85a6                	mv	a1,s1
    1dbc:	00005517          	auipc	a0,0x5
    1dc0:	26c50513          	addi	a0,a0,620 # 7028 <malloc+0xb84>
    1dc4:	00004097          	auipc	ra,0x4
    1dc8:	624080e7          	jalr	1572(ra) # 63e8 <printf>
      exit(1);
    1dcc:	4505                	li	a0,1
    1dce:	00004097          	auipc	ra,0x4
    1dd2:	1b8080e7          	jalr	440(ra) # 5f86 <exit>
{
    1dd6:	0c800493          	li	s1,200
        int pid1 = fork();
    1dda:	00004097          	auipc	ra,0x4
    1dde:	1a4080e7          	jalr	420(ra) # 5f7e <fork>
        if(pid1 < 0){
    1de2:	00054f63          	bltz	a0,1e00 <forkfork+0x9c>
        if(pid1 == 0){
    1de6:	c115                	beqz	a0,1e0a <forkfork+0xa6>
        wait(0);
    1de8:	4501                	li	a0,0
    1dea:	00004097          	auipc	ra,0x4
    1dee:	1a4080e7          	jalr	420(ra) # 5f8e <wait>
      for(int j = 0; j < 200; j++){
    1df2:	34fd                	addiw	s1,s1,-1
    1df4:	f0fd                	bnez	s1,1dda <forkfork+0x76>
      exit(0);
    1df6:	4501                	li	a0,0
    1df8:	00004097          	auipc	ra,0x4
    1dfc:	18e080e7          	jalr	398(ra) # 5f86 <exit>
          exit(1);
    1e00:	4505                	li	a0,1
    1e02:	00004097          	auipc	ra,0x4
    1e06:	184080e7          	jalr	388(ra) # 5f86 <exit>
          exit(0);
    1e0a:	00004097          	auipc	ra,0x4
    1e0e:	17c080e7          	jalr	380(ra) # 5f86 <exit>
      printf("%s: fork in child failed", s);
    1e12:	85a6                	mv	a1,s1
    1e14:	00005517          	auipc	a0,0x5
    1e18:	22450513          	addi	a0,a0,548 # 7038 <malloc+0xb94>
    1e1c:	00004097          	auipc	ra,0x4
    1e20:	5cc080e7          	jalr	1484(ra) # 63e8 <printf>
      exit(1);
    1e24:	4505                	li	a0,1
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	160080e7          	jalr	352(ra) # 5f86 <exit>

0000000000001e2e <reparent2>:
{
    1e2e:	1101                	addi	sp,sp,-32
    1e30:	ec06                	sd	ra,24(sp)
    1e32:	e822                	sd	s0,16(sp)
    1e34:	e426                	sd	s1,8(sp)
    1e36:	1000                	addi	s0,sp,32
    1e38:	32000493          	li	s1,800
    int pid1 = fork();
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	142080e7          	jalr	322(ra) # 5f7e <fork>
    if(pid1 < 0){
    1e44:	00054f63          	bltz	a0,1e62 <reparent2+0x34>
    if(pid1 == 0){
    1e48:	c915                	beqz	a0,1e7c <reparent2+0x4e>
    wait(0);
    1e4a:	4501                	li	a0,0
    1e4c:	00004097          	auipc	ra,0x4
    1e50:	142080e7          	jalr	322(ra) # 5f8e <wait>
  for(int i = 0; i < 800; i++){
    1e54:	34fd                	addiw	s1,s1,-1
    1e56:	f0fd                	bnez	s1,1e3c <reparent2+0xe>
  exit(0);
    1e58:	4501                	li	a0,0
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	12c080e7          	jalr	300(ra) # 5f86 <exit>
      printf("fork failed\n");
    1e62:	00006517          	auipc	a0,0x6
    1e66:	57650513          	addi	a0,a0,1398 # 83d8 <malloc+0x1f34>
    1e6a:	00004097          	auipc	ra,0x4
    1e6e:	57e080e7          	jalr	1406(ra) # 63e8 <printf>
      exit(1);
    1e72:	4505                	li	a0,1
    1e74:	00004097          	auipc	ra,0x4
    1e78:	112080e7          	jalr	274(ra) # 5f86 <exit>
      fork();
    1e7c:	00004097          	auipc	ra,0x4
    1e80:	102080e7          	jalr	258(ra) # 5f7e <fork>
      fork();
    1e84:	00004097          	auipc	ra,0x4
    1e88:	0fa080e7          	jalr	250(ra) # 5f7e <fork>
      exit(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	0f8080e7          	jalr	248(ra) # 5f86 <exit>

0000000000001e96 <createdelete>:
{
    1e96:	7175                	addi	sp,sp,-144
    1e98:	e506                	sd	ra,136(sp)
    1e9a:	e122                	sd	s0,128(sp)
    1e9c:	fca6                	sd	s1,120(sp)
    1e9e:	f8ca                	sd	s2,112(sp)
    1ea0:	f4ce                	sd	s3,104(sp)
    1ea2:	f0d2                	sd	s4,96(sp)
    1ea4:	ecd6                	sd	s5,88(sp)
    1ea6:	e8da                	sd	s6,80(sp)
    1ea8:	e4de                	sd	s7,72(sp)
    1eaa:	e0e2                	sd	s8,64(sp)
    1eac:	fc66                	sd	s9,56(sp)
    1eae:	f86a                	sd	s10,48(sp)
    1eb0:	0900                	addi	s0,sp,144
    1eb2:	8d2a                	mv	s10,a0
  for(pi = 0; pi < NCHILD; pi++){
    1eb4:	4901                	li	s2,0
    1eb6:	4991                	li	s3,4
    pid = fork();
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	0c6080e7          	jalr	198(ra) # 5f7e <fork>
    1ec0:	84aa                	mv	s1,a0
    if(pid < 0){
    1ec2:	04054063          	bltz	a0,1f02 <createdelete+0x6c>
    if(pid == 0){
    1ec6:	cd21                	beqz	a0,1f1e <createdelete+0x88>
  for(pi = 0; pi < NCHILD; pi++){
    1ec8:	2905                	addiw	s2,s2,1
    1eca:	ff3917e3          	bne	s2,s3,1eb8 <createdelete+0x22>
    1ece:	4491                	li	s1,4
    wait(&xstatus);
    1ed0:	f7c40993          	addi	s3,s0,-132
    1ed4:	854e                	mv	a0,s3
    1ed6:	00004097          	auipc	ra,0x4
    1eda:	0b8080e7          	jalr	184(ra) # 5f8e <wait>
    if(xstatus != 0)
    1ede:	f7c42903          	lw	s2,-132(s0)
    1ee2:	0e091463          	bnez	s2,1fca <createdelete+0x134>
  for(pi = 0; pi < NCHILD; pi++){
    1ee6:	34fd                	addiw	s1,s1,-1
    1ee8:	f4f5                	bnez	s1,1ed4 <createdelete+0x3e>
  name[0] = name[1] = name[2] = 0;
    1eea:	f8040123          	sb	zero,-126(s0)
    1eee:	03000993          	li	s3,48
    1ef2:	5afd                	li	s5,-1
    1ef4:	07000c93          	li	s9,112
      if((i == 0 || i >= N/2) && fd < 0){
    1ef8:	4ba5                	li	s7,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1efa:	4c21                	li	s8,8
    for(pi = 0; pi < NCHILD; pi++){
    1efc:	07400b13          	li	s6,116
    1f00:	a295                	j	2064 <createdelete+0x1ce>
      printf("%s: fork failed\n", s);
    1f02:	85ea                	mv	a1,s10
    1f04:	00005517          	auipc	a0,0x5
    1f08:	f6450513          	addi	a0,a0,-156 # 6e68 <malloc+0x9c4>
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	4dc080e7          	jalr	1244(ra) # 63e8 <printf>
      exit(1);
    1f14:	4505                	li	a0,1
    1f16:	00004097          	auipc	ra,0x4
    1f1a:	070080e7          	jalr	112(ra) # 5f86 <exit>
      name[0] = 'p' + pi;
    1f1e:	0709091b          	addiw	s2,s2,112
    1f22:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1f26:	f8040123          	sb	zero,-126(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1f2a:	f8040913          	addi	s2,s0,-128
    1f2e:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1f32:	4a51                	li	s4,20
    1f34:	a081                	j	1f74 <createdelete+0xde>
          printf("%s: create failed\n", s);
    1f36:	85ea                	mv	a1,s10
    1f38:	00005517          	auipc	a0,0x5
    1f3c:	fc850513          	addi	a0,a0,-56 # 6f00 <malloc+0xa5c>
    1f40:	00004097          	auipc	ra,0x4
    1f44:	4a8080e7          	jalr	1192(ra) # 63e8 <printf>
          exit(1);
    1f48:	4505                	li	a0,1
    1f4a:	00004097          	auipc	ra,0x4
    1f4e:	03c080e7          	jalr	60(ra) # 5f86 <exit>
          name[1] = '0' + (i / 2);
    1f52:	01f4d79b          	srliw	a5,s1,0x1f
    1f56:	9fa5                	addw	a5,a5,s1
    1f58:	4017d79b          	sraiw	a5,a5,0x1
    1f5c:	0307879b          	addiw	a5,a5,48
    1f60:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1f64:	854a                	mv	a0,s2
    1f66:	00004097          	auipc	ra,0x4
    1f6a:	070080e7          	jalr	112(ra) # 5fd6 <unlink>
    1f6e:	04054063          	bltz	a0,1fae <createdelete+0x118>
      for(i = 0; i < N; i++){
    1f72:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1f74:	0304879b          	addiw	a5,s1,48
    1f78:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1f7c:	85ce                	mv	a1,s3
    1f7e:	854a                	mv	a0,s2
    1f80:	00004097          	auipc	ra,0x4
    1f84:	046080e7          	jalr	70(ra) # 5fc6 <open>
        if(fd < 0){
    1f88:	fa0547e3          	bltz	a0,1f36 <createdelete+0xa0>
        close(fd);
    1f8c:	00004097          	auipc	ra,0x4
    1f90:	022080e7          	jalr	34(ra) # 5fae <close>
        if(i > 0 && (i % 2 ) == 0){
    1f94:	fc905fe3          	blez	s1,1f72 <createdelete+0xdc>
    1f98:	0014f793          	andi	a5,s1,1
    1f9c:	dbdd                	beqz	a5,1f52 <createdelete+0xbc>
      for(i = 0; i < N; i++){
    1f9e:	2485                	addiw	s1,s1,1
    1fa0:	fd449ae3          	bne	s1,s4,1f74 <createdelete+0xde>
      exit(0);
    1fa4:	4501                	li	a0,0
    1fa6:	00004097          	auipc	ra,0x4
    1faa:	fe0080e7          	jalr	-32(ra) # 5f86 <exit>
            printf("%s: unlink failed\n", s);
    1fae:	85ea                	mv	a1,s10
    1fb0:	00005517          	auipc	a0,0x5
    1fb4:	0a850513          	addi	a0,a0,168 # 7058 <malloc+0xbb4>
    1fb8:	00004097          	auipc	ra,0x4
    1fbc:	430080e7          	jalr	1072(ra) # 63e8 <printf>
            exit(1);
    1fc0:	4505                	li	a0,1
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	fc4080e7          	jalr	-60(ra) # 5f86 <exit>
      exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	00004097          	auipc	ra,0x4
    1fd0:	fba080e7          	jalr	-70(ra) # 5f86 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1fd4:	f8040613          	addi	a2,s0,-128
    1fd8:	85ea                	mv	a1,s10
    1fda:	00005517          	auipc	a0,0x5
    1fde:	09650513          	addi	a0,a0,150 # 7070 <malloc+0xbcc>
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	406080e7          	jalr	1030(ra) # 63e8 <printf>
        exit(1);
    1fea:	4505                	li	a0,1
    1fec:	00004097          	auipc	ra,0x4
    1ff0:	f9a080e7          	jalr	-102(ra) # 5f86 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ff4:	035c7e63          	bgeu	s8,s5,2030 <createdelete+0x19a>
      if(fd >= 0)
    1ff8:	02055763          	bgez	a0,2026 <createdelete+0x190>
    for(pi = 0; pi < NCHILD; pi++){
    1ffc:	2485                	addiw	s1,s1,1
    1ffe:	0ff4f493          	zext.b	s1,s1
    2002:	05648963          	beq	s1,s6,2054 <createdelete+0x1be>
      name[0] = 'p' + pi;
    2006:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    200a:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    200e:	4581                	li	a1,0
    2010:	8552                	mv	a0,s4
    2012:	00004097          	auipc	ra,0x4
    2016:	fb4080e7          	jalr	-76(ra) # 5fc6 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    201a:	00090463          	beqz	s2,2022 <createdelete+0x18c>
    201e:	fd2bdbe3          	bge	s7,s2,1ff4 <createdelete+0x15e>
    2022:	fa0549e3          	bltz	a0,1fd4 <createdelete+0x13e>
        close(fd);
    2026:	00004097          	auipc	ra,0x4
    202a:	f88080e7          	jalr	-120(ra) # 5fae <close>
    202e:	b7f9                	j	1ffc <createdelete+0x166>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2030:	fc0546e3          	bltz	a0,1ffc <createdelete+0x166>
        printf("%s: oops createdelete %s did exist\n", s, name);
    2034:	f8040613          	addi	a2,s0,-128
    2038:	85ea                	mv	a1,s10
    203a:	00005517          	auipc	a0,0x5
    203e:	05e50513          	addi	a0,a0,94 # 7098 <malloc+0xbf4>
    2042:	00004097          	auipc	ra,0x4
    2046:	3a6080e7          	jalr	934(ra) # 63e8 <printf>
        exit(1);
    204a:	4505                	li	a0,1
    204c:	00004097          	auipc	ra,0x4
    2050:	f3a080e7          	jalr	-198(ra) # 5f86 <exit>
  for(i = 0; i < N; i++){
    2054:	2905                	addiw	s2,s2,1
    2056:	2a85                	addiw	s5,s5,1
    2058:	2985                	addiw	s3,s3,1
    205a:	0ff9f993          	zext.b	s3,s3
    205e:	47d1                	li	a5,20
    2060:	00f90663          	beq	s2,a5,206c <createdelete+0x1d6>
    for(pi = 0; pi < NCHILD; pi++){
    2064:	84e6                	mv	s1,s9
      fd = open(name, 0);
    2066:	f8040a13          	addi	s4,s0,-128
    206a:	bf71                	j	2006 <createdelete+0x170>
    206c:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    2070:	07000b13          	li	s6,112
      unlink(name);
    2074:	f8040a13          	addi	s4,s0,-128
    for(pi = 0; pi < NCHILD; pi++){
    2078:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    207c:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    2080:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    2082:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    2086:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    208a:	8552                	mv	a0,s4
    208c:	00004097          	auipc	ra,0x4
    2090:	f4a080e7          	jalr	-182(ra) # 5fd6 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    2094:	2485                	addiw	s1,s1,1
    2096:	0ff4f493          	zext.b	s1,s1
    209a:	ff3494e3          	bne	s1,s3,2082 <createdelete+0x1ec>
  for(i = 0; i < N; i++){
    209e:	2905                	addiw	s2,s2,1
    20a0:	0ff97913          	zext.b	s2,s2
    20a4:	fd591ee3          	bne	s2,s5,2080 <createdelete+0x1ea>
}
    20a8:	60aa                	ld	ra,136(sp)
    20aa:	640a                	ld	s0,128(sp)
    20ac:	74e6                	ld	s1,120(sp)
    20ae:	7946                	ld	s2,112(sp)
    20b0:	79a6                	ld	s3,104(sp)
    20b2:	7a06                	ld	s4,96(sp)
    20b4:	6ae6                	ld	s5,88(sp)
    20b6:	6b46                	ld	s6,80(sp)
    20b8:	6ba6                	ld	s7,72(sp)
    20ba:	6c06                	ld	s8,64(sp)
    20bc:	7ce2                	ld	s9,56(sp)
    20be:	7d42                	ld	s10,48(sp)
    20c0:	6149                	addi	sp,sp,144
    20c2:	8082                	ret

00000000000020c4 <linkunlink>:
{
    20c4:	711d                	addi	sp,sp,-96
    20c6:	ec86                	sd	ra,88(sp)
    20c8:	e8a2                	sd	s0,80(sp)
    20ca:	e4a6                	sd	s1,72(sp)
    20cc:	e0ca                	sd	s2,64(sp)
    20ce:	fc4e                	sd	s3,56(sp)
    20d0:	f852                	sd	s4,48(sp)
    20d2:	f456                	sd	s5,40(sp)
    20d4:	f05a                	sd	s6,32(sp)
    20d6:	ec5e                	sd	s7,24(sp)
    20d8:	e862                	sd	s8,16(sp)
    20da:	e466                	sd	s9,8(sp)
    20dc:	e06a                	sd	s10,0(sp)
    20de:	1080                	addi	s0,sp,96
    20e0:	84aa                	mv	s1,a0
  unlink("x");
    20e2:	00004517          	auipc	a0,0x4
    20e6:	56650513          	addi	a0,a0,1382 # 6648 <malloc+0x1a4>
    20ea:	00004097          	auipc	ra,0x4
    20ee:	eec080e7          	jalr	-276(ra) # 5fd6 <unlink>
  pid = fork();
    20f2:	00004097          	auipc	ra,0x4
    20f6:	e8c080e7          	jalr	-372(ra) # 5f7e <fork>
  if(pid < 0){
    20fa:	04054363          	bltz	a0,2140 <linkunlink+0x7c>
    20fe:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    2100:	06100913          	li	s2,97
    2104:	c111                	beqz	a0,2108 <linkunlink+0x44>
    2106:	4905                	li	s2,1
    2108:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    210c:	41c65ab7          	lui	s5,0x41c65
    2110:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c541f5>
    2114:	6a0d                	lui	s4,0x3
    2116:	039a0a1b          	addiw	s4,s4,57 # 3039 <sbrk8000+0xd>
    if((x % 3) == 0){
    211a:	000ab9b7          	lui	s3,0xab
    211e:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99e33>
    2122:	09b2                	slli	s3,s3,0xc
    2124:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    2128:	4b85                	li	s7,1
      unlink("x");
    212a:	00004b17          	auipc	s6,0x4
    212e:	51eb0b13          	addi	s6,s6,1310 # 6648 <malloc+0x1a4>
      link("cat", "x");
    2132:	00005c97          	auipc	s9,0x5
    2136:	f8ec8c93          	addi	s9,s9,-114 # 70c0 <malloc+0xc1c>
      close(open("x", O_RDWR | O_CREATE));
    213a:	20200c13          	li	s8,514
    213e:	a089                	j	2180 <linkunlink+0xbc>
    printf("%s: fork failed\n", s);
    2140:	85a6                	mv	a1,s1
    2142:	00005517          	auipc	a0,0x5
    2146:	d2650513          	addi	a0,a0,-730 # 6e68 <malloc+0x9c4>
    214a:	00004097          	auipc	ra,0x4
    214e:	29e080e7          	jalr	670(ra) # 63e8 <printf>
    exit(1);
    2152:	4505                	li	a0,1
    2154:	00004097          	auipc	ra,0x4
    2158:	e32080e7          	jalr	-462(ra) # 5f86 <exit>
      close(open("x", O_RDWR | O_CREATE));
    215c:	85e2                	mv	a1,s8
    215e:	855a                	mv	a0,s6
    2160:	00004097          	auipc	ra,0x4
    2164:	e66080e7          	jalr	-410(ra) # 5fc6 <open>
    2168:	00004097          	auipc	ra,0x4
    216c:	e46080e7          	jalr	-442(ra) # 5fae <close>
    2170:	a031                	j	217c <linkunlink+0xb8>
      unlink("x");
    2172:	855a                	mv	a0,s6
    2174:	00004097          	auipc	ra,0x4
    2178:	e62080e7          	jalr	-414(ra) # 5fd6 <unlink>
  for(i = 0; i < 100; i++){
    217c:	34fd                	addiw	s1,s1,-1
    217e:	c895                	beqz	s1,21b2 <linkunlink+0xee>
    x = x * 1103515245 + 12345;
    2180:	035907bb          	mulw	a5,s2,s5
    2184:	00fa07bb          	addw	a5,s4,a5
    2188:	893e                	mv	s2,a5
    if((x % 3) == 0){
    218a:	02079713          	slli	a4,a5,0x20
    218e:	9301                	srli	a4,a4,0x20
    2190:	03370733          	mul	a4,a4,s3
    2194:	9305                	srli	a4,a4,0x21
    2196:	0017169b          	slliw	a3,a4,0x1
    219a:	9f35                	addw	a4,a4,a3
    219c:	9f99                	subw	a5,a5,a4
    219e:	dfdd                	beqz	a5,215c <linkunlink+0x98>
    } else if((x % 3) == 1){
    21a0:	fd7799e3          	bne	a5,s7,2172 <linkunlink+0xae>
      link("cat", "x");
    21a4:	85da                	mv	a1,s6
    21a6:	8566                	mv	a0,s9
    21a8:	00004097          	auipc	ra,0x4
    21ac:	e3e080e7          	jalr	-450(ra) # 5fe6 <link>
    21b0:	b7f1                	j	217c <linkunlink+0xb8>
  if(pid)
    21b2:	020d0563          	beqz	s10,21dc <linkunlink+0x118>
    wait(0);
    21b6:	4501                	li	a0,0
    21b8:	00004097          	auipc	ra,0x4
    21bc:	dd6080e7          	jalr	-554(ra) # 5f8e <wait>
}
    21c0:	60e6                	ld	ra,88(sp)
    21c2:	6446                	ld	s0,80(sp)
    21c4:	64a6                	ld	s1,72(sp)
    21c6:	6906                	ld	s2,64(sp)
    21c8:	79e2                	ld	s3,56(sp)
    21ca:	7a42                	ld	s4,48(sp)
    21cc:	7aa2                	ld	s5,40(sp)
    21ce:	7b02                	ld	s6,32(sp)
    21d0:	6be2                	ld	s7,24(sp)
    21d2:	6c42                	ld	s8,16(sp)
    21d4:	6ca2                	ld	s9,8(sp)
    21d6:	6d02                	ld	s10,0(sp)
    21d8:	6125                	addi	sp,sp,96
    21da:	8082                	ret
    exit(0);
    21dc:	4501                	li	a0,0
    21de:	00004097          	auipc	ra,0x4
    21e2:	da8080e7          	jalr	-600(ra) # 5f86 <exit>

00000000000021e6 <forktest>:
{
    21e6:	7179                	addi	sp,sp,-48
    21e8:	f406                	sd	ra,40(sp)
    21ea:	f022                	sd	s0,32(sp)
    21ec:	ec26                	sd	s1,24(sp)
    21ee:	e84a                	sd	s2,16(sp)
    21f0:	e44e                	sd	s3,8(sp)
    21f2:	1800                	addi	s0,sp,48
    21f4:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    21f6:	4481                	li	s1,0
    21f8:	3e800913          	li	s2,1000
    pid = fork();
    21fc:	00004097          	auipc	ra,0x4
    2200:	d82080e7          	jalr	-638(ra) # 5f7e <fork>
    if(pid < 0)
    2204:	08054263          	bltz	a0,2288 <forktest+0xa2>
    if(pid == 0)
    2208:	c115                	beqz	a0,222c <forktest+0x46>
  for(n=0; n<N; n++){
    220a:	2485                	addiw	s1,s1,1
    220c:	ff2498e3          	bne	s1,s2,21fc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2210:	85ce                	mv	a1,s3
    2212:	00005517          	auipc	a0,0x5
    2216:	efe50513          	addi	a0,a0,-258 # 7110 <malloc+0xc6c>
    221a:	00004097          	auipc	ra,0x4
    221e:	1ce080e7          	jalr	462(ra) # 63e8 <printf>
    exit(1);
    2222:	4505                	li	a0,1
    2224:	00004097          	auipc	ra,0x4
    2228:	d62080e7          	jalr	-670(ra) # 5f86 <exit>
      exit(0);
    222c:	00004097          	auipc	ra,0x4
    2230:	d5a080e7          	jalr	-678(ra) # 5f86 <exit>
    printf("%s: no fork at all!\n", s);
    2234:	85ce                	mv	a1,s3
    2236:	00005517          	auipc	a0,0x5
    223a:	e9250513          	addi	a0,a0,-366 # 70c8 <malloc+0xc24>
    223e:	00004097          	auipc	ra,0x4
    2242:	1aa080e7          	jalr	426(ra) # 63e8 <printf>
    exit(1);
    2246:	4505                	li	a0,1
    2248:	00004097          	auipc	ra,0x4
    224c:	d3e080e7          	jalr	-706(ra) # 5f86 <exit>
      printf("%s: wait stopped early\n", s);
    2250:	85ce                	mv	a1,s3
    2252:	00005517          	auipc	a0,0x5
    2256:	e8e50513          	addi	a0,a0,-370 # 70e0 <malloc+0xc3c>
    225a:	00004097          	auipc	ra,0x4
    225e:	18e080e7          	jalr	398(ra) # 63e8 <printf>
      exit(1);
    2262:	4505                	li	a0,1
    2264:	00004097          	auipc	ra,0x4
    2268:	d22080e7          	jalr	-734(ra) # 5f86 <exit>
    printf("%s: wait got too many\n", s);
    226c:	85ce                	mv	a1,s3
    226e:	00005517          	auipc	a0,0x5
    2272:	e8a50513          	addi	a0,a0,-374 # 70f8 <malloc+0xc54>
    2276:	00004097          	auipc	ra,0x4
    227a:	172080e7          	jalr	370(ra) # 63e8 <printf>
    exit(1);
    227e:	4505                	li	a0,1
    2280:	00004097          	auipc	ra,0x4
    2284:	d06080e7          	jalr	-762(ra) # 5f86 <exit>
  if (n == 0) {
    2288:	d4d5                	beqz	s1,2234 <forktest+0x4e>
    if(wait(0) < 0){
    228a:	4501                	li	a0,0
    228c:	00004097          	auipc	ra,0x4
    2290:	d02080e7          	jalr	-766(ra) # 5f8e <wait>
    2294:	fa054ee3          	bltz	a0,2250 <forktest+0x6a>
  for(; n > 0; n--){
    2298:	34fd                	addiw	s1,s1,-1
    229a:	fe9048e3          	bgtz	s1,228a <forktest+0xa4>
  if(wait(0) != -1){
    229e:	4501                	li	a0,0
    22a0:	00004097          	auipc	ra,0x4
    22a4:	cee080e7          	jalr	-786(ra) # 5f8e <wait>
    22a8:	57fd                	li	a5,-1
    22aa:	fcf511e3          	bne	a0,a5,226c <forktest+0x86>
}
    22ae:	70a2                	ld	ra,40(sp)
    22b0:	7402                	ld	s0,32(sp)
    22b2:	64e2                	ld	s1,24(sp)
    22b4:	6942                	ld	s2,16(sp)
    22b6:	69a2                	ld	s3,8(sp)
    22b8:	6145                	addi	sp,sp,48
    22ba:	8082                	ret

00000000000022bc <kernmem>:
{
    22bc:	715d                	addi	sp,sp,-80
    22be:	e486                	sd	ra,72(sp)
    22c0:	e0a2                	sd	s0,64(sp)
    22c2:	fc26                	sd	s1,56(sp)
    22c4:	f84a                	sd	s2,48(sp)
    22c6:	f44e                	sd	s3,40(sp)
    22c8:	f052                	sd	s4,32(sp)
    22ca:	ec56                	sd	s5,24(sp)
    22cc:	e85a                	sd	s6,16(sp)
    22ce:	0880                	addi	s0,sp,80
    22d0:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    22d2:	4485                	li	s1,1
    22d4:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    22d6:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    22da:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    22dc:	69b1                	lui	s3,0xc
    22de:	35098993          	addi	s3,s3,848 # c350 <uninit+0xde8>
    22e2:	1003d937          	lui	s2,0x1003d
    22e6:	090e                	slli	s2,s2,0x3
    22e8:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c808>
    pid = fork();
    22ec:	00004097          	auipc	ra,0x4
    22f0:	c92080e7          	jalr	-878(ra) # 5f7e <fork>
    if(pid < 0){
    22f4:	02054963          	bltz	a0,2326 <kernmem+0x6a>
    if(pid == 0){
    22f8:	c529                	beqz	a0,2342 <kernmem+0x86>
    wait(&xstatus);
    22fa:	8556                	mv	a0,s5
    22fc:	00004097          	auipc	ra,0x4
    2300:	c92080e7          	jalr	-878(ra) # 5f8e <wait>
    if(xstatus != -1)  // did kernel kill child?
    2304:	fbc42783          	lw	a5,-68(s0)
    2308:	05479e63          	bne	a5,s4,2364 <kernmem+0xa8>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    230c:	94ce                	add	s1,s1,s3
    230e:	fd249fe3          	bne	s1,s2,22ec <kernmem+0x30>
}
    2312:	60a6                	ld	ra,72(sp)
    2314:	6406                	ld	s0,64(sp)
    2316:	74e2                	ld	s1,56(sp)
    2318:	7942                	ld	s2,48(sp)
    231a:	79a2                	ld	s3,40(sp)
    231c:	7a02                	ld	s4,32(sp)
    231e:	6ae2                	ld	s5,24(sp)
    2320:	6b42                	ld	s6,16(sp)
    2322:	6161                	addi	sp,sp,80
    2324:	8082                	ret
      printf("%s: fork failed\n", s);
    2326:	85da                	mv	a1,s6
    2328:	00005517          	auipc	a0,0x5
    232c:	b4050513          	addi	a0,a0,-1216 # 6e68 <malloc+0x9c4>
    2330:	00004097          	auipc	ra,0x4
    2334:	0b8080e7          	jalr	184(ra) # 63e8 <printf>
      exit(1);
    2338:	4505                	li	a0,1
    233a:	00004097          	auipc	ra,0x4
    233e:	c4c080e7          	jalr	-948(ra) # 5f86 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    2342:	0004c683          	lbu	a3,0(s1)
    2346:	8626                	mv	a2,s1
    2348:	85da                	mv	a1,s6
    234a:	00005517          	auipc	a0,0x5
    234e:	dee50513          	addi	a0,a0,-530 # 7138 <malloc+0xc94>
    2352:	00004097          	auipc	ra,0x4
    2356:	096080e7          	jalr	150(ra) # 63e8 <printf>
      exit(1);
    235a:	4505                	li	a0,1
    235c:	00004097          	auipc	ra,0x4
    2360:	c2a080e7          	jalr	-982(ra) # 5f86 <exit>
      exit(1);
    2364:	4505                	li	a0,1
    2366:	00004097          	auipc	ra,0x4
    236a:	c20080e7          	jalr	-992(ra) # 5f86 <exit>

000000000000236e <MAXVAplus>:
{
    236e:	7139                	addi	sp,sp,-64
    2370:	fc06                	sd	ra,56(sp)
    2372:	f822                	sd	s0,48(sp)
    2374:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    2376:	4785                	li	a5,1
    2378:	179a                	slli	a5,a5,0x26
    237a:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    237e:	fc843783          	ld	a5,-56(s0)
    2382:	c3b9                	beqz	a5,23c8 <MAXVAplus+0x5a>
    2384:	f426                	sd	s1,40(sp)
    2386:	f04a                	sd	s2,32(sp)
    2388:	ec4e                	sd	s3,24(sp)
    238a:	89aa                	mv	s3,a0
    wait(&xstatus);
    238c:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    2390:	54fd                	li	s1,-1
    pid = fork();
    2392:	00004097          	auipc	ra,0x4
    2396:	bec080e7          	jalr	-1044(ra) # 5f7e <fork>
    if(pid < 0){
    239a:	02054b63          	bltz	a0,23d0 <MAXVAplus+0x62>
    if(pid == 0){
    239e:	c539                	beqz	a0,23ec <MAXVAplus+0x7e>
    wait(&xstatus);
    23a0:	854a                	mv	a0,s2
    23a2:	00004097          	auipc	ra,0x4
    23a6:	bec080e7          	jalr	-1044(ra) # 5f8e <wait>
    if(xstatus != -1)  // did kernel kill child?
    23aa:	fc442783          	lw	a5,-60(s0)
    23ae:	06979563          	bne	a5,s1,2418 <MAXVAplus+0xaa>
  for( ; a != 0; a <<= 1){
    23b2:	fc843783          	ld	a5,-56(s0)
    23b6:	0786                	slli	a5,a5,0x1
    23b8:	fcf43423          	sd	a5,-56(s0)
    23bc:	fc843783          	ld	a5,-56(s0)
    23c0:	fbe9                	bnez	a5,2392 <MAXVAplus+0x24>
    23c2:	74a2                	ld	s1,40(sp)
    23c4:	7902                	ld	s2,32(sp)
    23c6:	69e2                	ld	s3,24(sp)
}
    23c8:	70e2                	ld	ra,56(sp)
    23ca:	7442                	ld	s0,48(sp)
    23cc:	6121                	addi	sp,sp,64
    23ce:	8082                	ret
      printf("%s: fork failed\n", s);
    23d0:	85ce                	mv	a1,s3
    23d2:	00005517          	auipc	a0,0x5
    23d6:	a9650513          	addi	a0,a0,-1386 # 6e68 <malloc+0x9c4>
    23da:	00004097          	auipc	ra,0x4
    23de:	00e080e7          	jalr	14(ra) # 63e8 <printf>
      exit(1);
    23e2:	4505                	li	a0,1
    23e4:	00004097          	auipc	ra,0x4
    23e8:	ba2080e7          	jalr	-1118(ra) # 5f86 <exit>
      *(char*)a = 99;
    23ec:	fc843783          	ld	a5,-56(s0)
    23f0:	06300713          	li	a4,99
    23f4:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    23f8:	fc843603          	ld	a2,-56(s0)
    23fc:	85ce                	mv	a1,s3
    23fe:	00005517          	auipc	a0,0x5
    2402:	d5a50513          	addi	a0,a0,-678 # 7158 <malloc+0xcb4>
    2406:	00004097          	auipc	ra,0x4
    240a:	fe2080e7          	jalr	-30(ra) # 63e8 <printf>
      exit(1);
    240e:	4505                	li	a0,1
    2410:	00004097          	auipc	ra,0x4
    2414:	b76080e7          	jalr	-1162(ra) # 5f86 <exit>
      exit(1);
    2418:	4505                	li	a0,1
    241a:	00004097          	auipc	ra,0x4
    241e:	b6c080e7          	jalr	-1172(ra) # 5f86 <exit>

0000000000002422 <stacktest>:
{
    2422:	7179                	addi	sp,sp,-48
    2424:	f406                	sd	ra,40(sp)
    2426:	f022                	sd	s0,32(sp)
    2428:	ec26                	sd	s1,24(sp)
    242a:	1800                	addi	s0,sp,48
    242c:	84aa                	mv	s1,a0
  pid = fork();
    242e:	00004097          	auipc	ra,0x4
    2432:	b50080e7          	jalr	-1200(ra) # 5f7e <fork>
  if(pid == 0) {
    2436:	c115                	beqz	a0,245a <stacktest+0x38>
  } else if(pid < 0){
    2438:	04054463          	bltz	a0,2480 <stacktest+0x5e>
  wait(&xstatus);
    243c:	fdc40513          	addi	a0,s0,-36
    2440:	00004097          	auipc	ra,0x4
    2444:	b4e080e7          	jalr	-1202(ra) # 5f8e <wait>
  if(xstatus == -1)  // kernel killed child?
    2448:	fdc42503          	lw	a0,-36(s0)
    244c:	57fd                	li	a5,-1
    244e:	04f50763          	beq	a0,a5,249c <stacktest+0x7a>
    exit(xstatus);
    2452:	00004097          	auipc	ra,0x4
    2456:	b34080e7          	jalr	-1228(ra) # 5f86 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    245a:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    245c:	77fd                	lui	a5,0xfffff
    245e:	97ba                	add	a5,a5,a4
    2460:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee388>
    2464:	85a6                	mv	a1,s1
    2466:	00005517          	auipc	a0,0x5
    246a:	d0a50513          	addi	a0,a0,-758 # 7170 <malloc+0xccc>
    246e:	00004097          	auipc	ra,0x4
    2472:	f7a080e7          	jalr	-134(ra) # 63e8 <printf>
    exit(1);
    2476:	4505                	li	a0,1
    2478:	00004097          	auipc	ra,0x4
    247c:	b0e080e7          	jalr	-1266(ra) # 5f86 <exit>
    printf("%s: fork failed\n", s);
    2480:	85a6                	mv	a1,s1
    2482:	00005517          	auipc	a0,0x5
    2486:	9e650513          	addi	a0,a0,-1562 # 6e68 <malloc+0x9c4>
    248a:	00004097          	auipc	ra,0x4
    248e:	f5e080e7          	jalr	-162(ra) # 63e8 <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	00004097          	auipc	ra,0x4
    2498:	af2080e7          	jalr	-1294(ra) # 5f86 <exit>
    exit(0);
    249c:	4501                	li	a0,0
    249e:	00004097          	auipc	ra,0x4
    24a2:	ae8080e7          	jalr	-1304(ra) # 5f86 <exit>

00000000000024a6 <nowrite>:
{
    24a6:	7159                	addi	sp,sp,-112
    24a8:	f486                	sd	ra,104(sp)
    24aa:	f0a2                	sd	s0,96(sp)
    24ac:	eca6                	sd	s1,88(sp)
    24ae:	e8ca                	sd	s2,80(sp)
    24b0:	e4ce                	sd	s3,72(sp)
    24b2:	e0d2                	sd	s4,64(sp)
    24b4:	1880                	addi	s0,sp,112
    24b6:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    24b8:	00006797          	auipc	a5,0x6
    24bc:	48078793          	addi	a5,a5,1152 # 8938 <malloc+0x2494>
    24c0:	7788                	ld	a0,40(a5)
    24c2:	7b8c                	ld	a1,48(a5)
    24c4:	7f90                	ld	a2,56(a5)
    24c6:	63b4                	ld	a3,64(a5)
    24c8:	67b8                	ld	a4,72(a5)
    24ca:	6bbc                	ld	a5,80(a5)
    24cc:	f8a43c23          	sd	a0,-104(s0)
    24d0:	fab43023          	sd	a1,-96(s0)
    24d4:	fac43423          	sd	a2,-88(s0)
    24d8:	fad43823          	sd	a3,-80(s0)
    24dc:	fae43c23          	sd	a4,-72(s0)
    24e0:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    24e4:	4481                	li	s1,0
    wait(&xstatus);
    24e6:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    24ea:	4999                	li	s3,6
    pid = fork();
    24ec:	00004097          	auipc	ra,0x4
    24f0:	a92080e7          	jalr	-1390(ra) # 5f7e <fork>
    if(pid == 0) {
    24f4:	c11d                	beqz	a0,251a <nowrite+0x74>
    } else if(pid < 0){
    24f6:	04054963          	bltz	a0,2548 <nowrite+0xa2>
    wait(&xstatus);
    24fa:	854a                	mv	a0,s2
    24fc:	00004097          	auipc	ra,0x4
    2500:	a92080e7          	jalr	-1390(ra) # 5f8e <wait>
    if(xstatus == 0){
    2504:	fcc42783          	lw	a5,-52(s0)
    2508:	cfb1                	beqz	a5,2564 <nowrite+0xbe>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    250a:	2485                	addiw	s1,s1,1
    250c:	ff3490e3          	bne	s1,s3,24ec <nowrite+0x46>
  exit(0);
    2510:	4501                	li	a0,0
    2512:	00004097          	auipc	ra,0x4
    2516:	a74080e7          	jalr	-1420(ra) # 5f86 <exit>
      volatile int *addr = (int *) addrs[ai];
    251a:	048e                	slli	s1,s1,0x3
    251c:	fd048793          	addi	a5,s1,-48
    2520:	008784b3          	add	s1,a5,s0
    2524:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    2528:	47a9                	li	a5,10
    252a:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    252c:	85d2                	mv	a1,s4
    252e:	00005517          	auipc	a0,0x5
    2532:	c6a50513          	addi	a0,a0,-918 # 7198 <malloc+0xcf4>
    2536:	00004097          	auipc	ra,0x4
    253a:	eb2080e7          	jalr	-334(ra) # 63e8 <printf>
      exit(0);
    253e:	4501                	li	a0,0
    2540:	00004097          	auipc	ra,0x4
    2544:	a46080e7          	jalr	-1466(ra) # 5f86 <exit>
      printf("%s: fork failed\n", s);
    2548:	85d2                	mv	a1,s4
    254a:	00005517          	auipc	a0,0x5
    254e:	91e50513          	addi	a0,a0,-1762 # 6e68 <malloc+0x9c4>
    2552:	00004097          	auipc	ra,0x4
    2556:	e96080e7          	jalr	-362(ra) # 63e8 <printf>
      exit(1);
    255a:	4505                	li	a0,1
    255c:	00004097          	auipc	ra,0x4
    2560:	a2a080e7          	jalr	-1494(ra) # 5f86 <exit>
      exit(1);
    2564:	4505                	li	a0,1
    2566:	00004097          	auipc	ra,0x4
    256a:	a20080e7          	jalr	-1504(ra) # 5f86 <exit>

000000000000256e <manywrites>:
{
    256e:	7159                	addi	sp,sp,-112
    2570:	f486                	sd	ra,104(sp)
    2572:	f0a2                	sd	s0,96(sp)
    2574:	eca6                	sd	s1,88(sp)
    2576:	e8ca                	sd	s2,80(sp)
    2578:	e4ce                	sd	s3,72(sp)
    257a:	fc56                	sd	s5,56(sp)
    257c:	1880                	addi	s0,sp,112
    257e:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    2580:	4901                	li	s2,0
    2582:	4991                	li	s3,4
    int pid = fork();
    2584:	00004097          	auipc	ra,0x4
    2588:	9fa080e7          	jalr	-1542(ra) # 5f7e <fork>
    258c:	84aa                	mv	s1,a0
    if(pid < 0){
    258e:	04054163          	bltz	a0,25d0 <manywrites+0x62>
    if(pid == 0){
    2592:	c135                	beqz	a0,25f6 <manywrites+0x88>
  for(int ci = 0; ci < nchildren; ci++){
    2594:	2905                	addiw	s2,s2,1
    2596:	ff3917e3          	bne	s2,s3,2584 <manywrites+0x16>
    259a:	4491                	li	s1,4
    wait(&st);
    259c:	f9840913          	addi	s2,s0,-104
    int st = 0;
    25a0:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    25a4:	854a                	mv	a0,s2
    25a6:	00004097          	auipc	ra,0x4
    25aa:	9e8080e7          	jalr	-1560(ra) # 5f8e <wait>
    if(st != 0)
    25ae:	f9842503          	lw	a0,-104(s0)
    25b2:	12051063          	bnez	a0,26d2 <manywrites+0x164>
  for(int ci = 0; ci < nchildren; ci++){
    25b6:	34fd                	addiw	s1,s1,-1
    25b8:	f4e5                	bnez	s1,25a0 <manywrites+0x32>
    25ba:	e0d2                	sd	s4,64(sp)
    25bc:	f85a                	sd	s6,48(sp)
    25be:	f45e                	sd	s7,40(sp)
    25c0:	f062                	sd	s8,32(sp)
    25c2:	ec66                	sd	s9,24(sp)
    25c4:	e86a                	sd	s10,16(sp)
  exit(0);
    25c6:	4501                	li	a0,0
    25c8:	00004097          	auipc	ra,0x4
    25cc:	9be080e7          	jalr	-1602(ra) # 5f86 <exit>
    25d0:	e0d2                	sd	s4,64(sp)
    25d2:	f85a                	sd	s6,48(sp)
    25d4:	f45e                	sd	s7,40(sp)
    25d6:	f062                	sd	s8,32(sp)
    25d8:	ec66                	sd	s9,24(sp)
    25da:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    25dc:	00006517          	auipc	a0,0x6
    25e0:	dfc50513          	addi	a0,a0,-516 # 83d8 <malloc+0x1f34>
    25e4:	00004097          	auipc	ra,0x4
    25e8:	e04080e7          	jalr	-508(ra) # 63e8 <printf>
      exit(1);
    25ec:	4505                	li	a0,1
    25ee:	00004097          	auipc	ra,0x4
    25f2:	998080e7          	jalr	-1640(ra) # 5f86 <exit>
    25f6:	e0d2                	sd	s4,64(sp)
    25f8:	f85a                	sd	s6,48(sp)
    25fa:	f45e                	sd	s7,40(sp)
    25fc:	f062                	sd	s8,32(sp)
    25fe:	ec66                	sd	s9,24(sp)
    2600:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    2602:	06200793          	li	a5,98
    2606:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    260a:	0619079b          	addiw	a5,s2,97
    260e:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    2612:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    2616:	f9840513          	addi	a0,s0,-104
    261a:	00004097          	auipc	ra,0x4
    261e:	9bc080e7          	jalr	-1604(ra) # 5fd6 <unlink>
    2622:	4d79                	li	s10,30
          int fd = open(name, O_CREATE | O_RDWR);
    2624:	f9840c13          	addi	s8,s0,-104
    2628:	20200b93          	li	s7,514
          int cc = write(fd, buf, sz);
    262c:	6b0d                	lui	s6,0x3
    262e:	0000bc97          	auipc	s9,0xb
    2632:	64ac8c93          	addi	s9,s9,1610 # dc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2636:	8a26                	mv	s4,s1
          int fd = open(name, O_CREATE | O_RDWR);
    2638:	85de                	mv	a1,s7
    263a:	8562                	mv	a0,s8
    263c:	00004097          	auipc	ra,0x4
    2640:	98a080e7          	jalr	-1654(ra) # 5fc6 <open>
    2644:	89aa                	mv	s3,a0
          if(fd < 0){
    2646:	04054663          	bltz	a0,2692 <manywrites+0x124>
          int cc = write(fd, buf, sz);
    264a:	865a                	mv	a2,s6
    264c:	85e6                	mv	a1,s9
    264e:	00004097          	auipc	ra,0x4
    2652:	958080e7          	jalr	-1704(ra) # 5fa6 <write>
          if(cc != sz){
    2656:	05651e63          	bne	a0,s6,26b2 <manywrites+0x144>
          close(fd);
    265a:	854e                	mv	a0,s3
    265c:	00004097          	auipc	ra,0x4
    2660:	952080e7          	jalr	-1710(ra) # 5fae <close>
        for(int i = 0; i < ci+1; i++){
    2664:	2a05                	addiw	s4,s4,1
    2666:	fd4959e3          	bge	s2,s4,2638 <manywrites+0xca>
        unlink(name);
    266a:	f9840513          	addi	a0,s0,-104
    266e:	00004097          	auipc	ra,0x4
    2672:	968080e7          	jalr	-1688(ra) # 5fd6 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2676:	3d7d                	addiw	s10,s10,-1
    2678:	fa0d1fe3          	bnez	s10,2636 <manywrites+0xc8>
      unlink(name);
    267c:	f9840513          	addi	a0,s0,-104
    2680:	00004097          	auipc	ra,0x4
    2684:	956080e7          	jalr	-1706(ra) # 5fd6 <unlink>
      exit(0);
    2688:	4501                	li	a0,0
    268a:	00004097          	auipc	ra,0x4
    268e:	8fc080e7          	jalr	-1796(ra) # 5f86 <exit>
            printf("%s: cannot create %s\n", s, name);
    2692:	f9840613          	addi	a2,s0,-104
    2696:	85d6                	mv	a1,s5
    2698:	00005517          	auipc	a0,0x5
    269c:	b2050513          	addi	a0,a0,-1248 # 71b8 <malloc+0xd14>
    26a0:	00004097          	auipc	ra,0x4
    26a4:	d48080e7          	jalr	-696(ra) # 63e8 <printf>
            exit(1);
    26a8:	4505                	li	a0,1
    26aa:	00004097          	auipc	ra,0x4
    26ae:	8dc080e7          	jalr	-1828(ra) # 5f86 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    26b2:	86aa                	mv	a3,a0
    26b4:	660d                	lui	a2,0x3
    26b6:	85d6                	mv	a1,s5
    26b8:	00004517          	auipc	a0,0x4
    26bc:	ff050513          	addi	a0,a0,-16 # 66a8 <malloc+0x204>
    26c0:	00004097          	auipc	ra,0x4
    26c4:	d28080e7          	jalr	-728(ra) # 63e8 <printf>
            exit(1);
    26c8:	4505                	li	a0,1
    26ca:	00004097          	auipc	ra,0x4
    26ce:	8bc080e7          	jalr	-1860(ra) # 5f86 <exit>
    26d2:	e0d2                	sd	s4,64(sp)
    26d4:	f85a                	sd	s6,48(sp)
    26d6:	f45e                	sd	s7,40(sp)
    26d8:	f062                	sd	s8,32(sp)
    26da:	ec66                	sd	s9,24(sp)
    26dc:	e86a                	sd	s10,16(sp)
      exit(st);
    26de:	00004097          	auipc	ra,0x4
    26e2:	8a8080e7          	jalr	-1880(ra) # 5f86 <exit>

00000000000026e6 <copyinstr3>:
{
    26e6:	7179                	addi	sp,sp,-48
    26e8:	f406                	sd	ra,40(sp)
    26ea:	f022                	sd	s0,32(sp)
    26ec:	ec26                	sd	s1,24(sp)
    26ee:	1800                	addi	s0,sp,48
  sbrk(8192);
    26f0:	6509                	lui	a0,0x2
    26f2:	00004097          	auipc	ra,0x4
    26f6:	91c080e7          	jalr	-1764(ra) # 600e <sbrk>
  uint64 top = (uint64) sbrk(0);
    26fa:	4501                	li	a0,0
    26fc:	00004097          	auipc	ra,0x4
    2700:	912080e7          	jalr	-1774(ra) # 600e <sbrk>
  if((top % PGSIZE) != 0){
    2704:	03451793          	slli	a5,a0,0x34
    2708:	e3c9                	bnez	a5,278a <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    270a:	4501                	li	a0,0
    270c:	00004097          	auipc	ra,0x4
    2710:	902080e7          	jalr	-1790(ra) # 600e <sbrk>
  if(top % PGSIZE){
    2714:	03451793          	slli	a5,a0,0x34
    2718:	e7c1                	bnez	a5,27a0 <copyinstr3+0xba>
  char *b = (char *) (top - 1);
    271a:	fff50493          	addi	s1,a0,-1 # 1fff <createdelete+0x169>
  *b = 'x';
    271e:	07800793          	li	a5,120
    2722:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2726:	8526                	mv	a0,s1
    2728:	00004097          	auipc	ra,0x4
    272c:	8ae080e7          	jalr	-1874(ra) # 5fd6 <unlink>
  if(ret != -1){
    2730:	57fd                	li	a5,-1
    2732:	08f51463          	bne	a0,a5,27ba <copyinstr3+0xd4>
  int fd = open(b, O_CREATE | O_WRONLY);
    2736:	20100593          	li	a1,513
    273a:	8526                	mv	a0,s1
    273c:	00004097          	auipc	ra,0x4
    2740:	88a080e7          	jalr	-1910(ra) # 5fc6 <open>
  if(fd != -1){
    2744:	57fd                	li	a5,-1
    2746:	08f51963          	bne	a0,a5,27d8 <copyinstr3+0xf2>
  ret = link(b, b);
    274a:	85a6                	mv	a1,s1
    274c:	8526                	mv	a0,s1
    274e:	00004097          	auipc	ra,0x4
    2752:	898080e7          	jalr	-1896(ra) # 5fe6 <link>
  if(ret != -1){
    2756:	57fd                	li	a5,-1
    2758:	08f51f63          	bne	a0,a5,27f6 <copyinstr3+0x110>
  char *args[] = { "xx", 0 };
    275c:	00005797          	auipc	a5,0x5
    2760:	75c78793          	addi	a5,a5,1884 # 7eb8 <malloc+0x1a14>
    2764:	fcf43823          	sd	a5,-48(s0)
    2768:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    276c:	fd040593          	addi	a1,s0,-48
    2770:	8526                	mv	a0,s1
    2772:	00004097          	auipc	ra,0x4
    2776:	84c080e7          	jalr	-1972(ra) # 5fbe <exec>
  if(ret != -1){
    277a:	57fd                	li	a5,-1
    277c:	08f51d63          	bne	a0,a5,2816 <copyinstr3+0x130>
}
    2780:	70a2                	ld	ra,40(sp)
    2782:	7402                	ld	s0,32(sp)
    2784:	64e2                	ld	s1,24(sp)
    2786:	6145                	addi	sp,sp,48
    2788:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    278a:	6785                	lui	a5,0x1
    278c:	fff78713          	addi	a4,a5,-1 # fff <linktest+0x4b>
    2790:	8d79                	and	a0,a0,a4
    2792:	40a7853b          	subw	a0,a5,a0
    2796:	00004097          	auipc	ra,0x4
    279a:	878080e7          	jalr	-1928(ra) # 600e <sbrk>
    279e:	b7b5                	j	270a <copyinstr3+0x24>
    printf("oops\n");
    27a0:	00005517          	auipc	a0,0x5
    27a4:	a3050513          	addi	a0,a0,-1488 # 71d0 <malloc+0xd2c>
    27a8:	00004097          	auipc	ra,0x4
    27ac:	c40080e7          	jalr	-960(ra) # 63e8 <printf>
    exit(1);
    27b0:	4505                	li	a0,1
    27b2:	00003097          	auipc	ra,0x3
    27b6:	7d4080e7          	jalr	2004(ra) # 5f86 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    27ba:	862a                	mv	a2,a0
    27bc:	85a6                	mv	a1,s1
    27be:	00004517          	auipc	a0,0x4
    27c2:	5ca50513          	addi	a0,a0,1482 # 6d88 <malloc+0x8e4>
    27c6:	00004097          	auipc	ra,0x4
    27ca:	c22080e7          	jalr	-990(ra) # 63e8 <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	00003097          	auipc	ra,0x3
    27d4:	7b6080e7          	jalr	1974(ra) # 5f86 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    27d8:	862a                	mv	a2,a0
    27da:	85a6                	mv	a1,s1
    27dc:	00004517          	auipc	a0,0x4
    27e0:	5cc50513          	addi	a0,a0,1484 # 6da8 <malloc+0x904>
    27e4:	00004097          	auipc	ra,0x4
    27e8:	c04080e7          	jalr	-1020(ra) # 63e8 <printf>
    exit(1);
    27ec:	4505                	li	a0,1
    27ee:	00003097          	auipc	ra,0x3
    27f2:	798080e7          	jalr	1944(ra) # 5f86 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    27f6:	86aa                	mv	a3,a0
    27f8:	8626                	mv	a2,s1
    27fa:	85a6                	mv	a1,s1
    27fc:	00004517          	auipc	a0,0x4
    2800:	5cc50513          	addi	a0,a0,1484 # 6dc8 <malloc+0x924>
    2804:	00004097          	auipc	ra,0x4
    2808:	be4080e7          	jalr	-1052(ra) # 63e8 <printf>
    exit(1);
    280c:	4505                	li	a0,1
    280e:	00003097          	auipc	ra,0x3
    2812:	778080e7          	jalr	1912(ra) # 5f86 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2816:	863e                	mv	a2,a5
    2818:	85a6                	mv	a1,s1
    281a:	00004517          	auipc	a0,0x4
    281e:	5d650513          	addi	a0,a0,1494 # 6df0 <malloc+0x94c>
    2822:	00004097          	auipc	ra,0x4
    2826:	bc6080e7          	jalr	-1082(ra) # 63e8 <printf>
    exit(1);
    282a:	4505                	li	a0,1
    282c:	00003097          	auipc	ra,0x3
    2830:	75a080e7          	jalr	1882(ra) # 5f86 <exit>

0000000000002834 <rwsbrk>:
{
    2834:	1101                	addi	sp,sp,-32
    2836:	ec06                	sd	ra,24(sp)
    2838:	e822                	sd	s0,16(sp)
    283a:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    283c:	6509                	lui	a0,0x2
    283e:	00003097          	auipc	ra,0x3
    2842:	7d0080e7          	jalr	2000(ra) # 600e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2846:	57fd                	li	a5,-1
    2848:	06f50463          	beq	a0,a5,28b0 <rwsbrk+0x7c>
    284c:	e426                	sd	s1,8(sp)
    284e:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2850:	7579                	lui	a0,0xffffe
    2852:	00003097          	auipc	ra,0x3
    2856:	7bc080e7          	jalr	1980(ra) # 600e <sbrk>
    285a:	57fd                	li	a5,-1
    285c:	06f50963          	beq	a0,a5,28ce <rwsbrk+0x9a>
    2860:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2862:	20100593          	li	a1,513
    2866:	00005517          	auipc	a0,0x5
    286a:	9aa50513          	addi	a0,a0,-1622 # 7210 <malloc+0xd6c>
    286e:	00003097          	auipc	ra,0x3
    2872:	758080e7          	jalr	1880(ra) # 5fc6 <open>
    2876:	892a                	mv	s2,a0
  if(fd < 0){
    2878:	06054963          	bltz	a0,28ea <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    287c:	6785                	lui	a5,0x1
    287e:	94be                	add	s1,s1,a5
    2880:	40000613          	li	a2,1024
    2884:	85a6                	mv	a1,s1
    2886:	00003097          	auipc	ra,0x3
    288a:	720080e7          	jalr	1824(ra) # 5fa6 <write>
    288e:	862a                	mv	a2,a0
  if(n >= 0){
    2890:	06054a63          	bltz	a0,2904 <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    2894:	85a6                	mv	a1,s1
    2896:	00005517          	auipc	a0,0x5
    289a:	99a50513          	addi	a0,a0,-1638 # 7230 <malloc+0xd8c>
    289e:	00004097          	auipc	ra,0x4
    28a2:	b4a080e7          	jalr	-1206(ra) # 63e8 <printf>
    exit(1);
    28a6:	4505                	li	a0,1
    28a8:	00003097          	auipc	ra,0x3
    28ac:	6de080e7          	jalr	1758(ra) # 5f86 <exit>
    28b0:	e426                	sd	s1,8(sp)
    28b2:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    28b4:	00005517          	auipc	a0,0x5
    28b8:	92450513          	addi	a0,a0,-1756 # 71d8 <malloc+0xd34>
    28bc:	00004097          	auipc	ra,0x4
    28c0:	b2c080e7          	jalr	-1236(ra) # 63e8 <printf>
    exit(1);
    28c4:	4505                	li	a0,1
    28c6:	00003097          	auipc	ra,0x3
    28ca:	6c0080e7          	jalr	1728(ra) # 5f86 <exit>
    28ce:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    28d0:	00005517          	auipc	a0,0x5
    28d4:	92050513          	addi	a0,a0,-1760 # 71f0 <malloc+0xd4c>
    28d8:	00004097          	auipc	ra,0x4
    28dc:	b10080e7          	jalr	-1264(ra) # 63e8 <printf>
    exit(1);
    28e0:	4505                	li	a0,1
    28e2:	00003097          	auipc	ra,0x3
    28e6:	6a4080e7          	jalr	1700(ra) # 5f86 <exit>
    printf("open(rwsbrk) failed\n");
    28ea:	00005517          	auipc	a0,0x5
    28ee:	92e50513          	addi	a0,a0,-1746 # 7218 <malloc+0xd74>
    28f2:	00004097          	auipc	ra,0x4
    28f6:	af6080e7          	jalr	-1290(ra) # 63e8 <printf>
    exit(1);
    28fa:	4505                	li	a0,1
    28fc:	00003097          	auipc	ra,0x3
    2900:	68a080e7          	jalr	1674(ra) # 5f86 <exit>
  close(fd);
    2904:	854a                	mv	a0,s2
    2906:	00003097          	auipc	ra,0x3
    290a:	6a8080e7          	jalr	1704(ra) # 5fae <close>
  unlink("rwsbrk");
    290e:	00005517          	auipc	a0,0x5
    2912:	90250513          	addi	a0,a0,-1790 # 7210 <malloc+0xd6c>
    2916:	00003097          	auipc	ra,0x3
    291a:	6c0080e7          	jalr	1728(ra) # 5fd6 <unlink>
  fd = open("README", O_RDONLY);
    291e:	4581                	li	a1,0
    2920:	00004517          	auipc	a0,0x4
    2924:	e9050513          	addi	a0,a0,-368 # 67b0 <malloc+0x30c>
    2928:	00003097          	auipc	ra,0x3
    292c:	69e080e7          	jalr	1694(ra) # 5fc6 <open>
    2930:	892a                	mv	s2,a0
  if(fd < 0){
    2932:	02054963          	bltz	a0,2964 <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2936:	4629                	li	a2,10
    2938:	85a6                	mv	a1,s1
    293a:	00003097          	auipc	ra,0x3
    293e:	664080e7          	jalr	1636(ra) # 5f9e <read>
    2942:	862a                	mv	a2,a0
  if(n >= 0){
    2944:	02054d63          	bltz	a0,297e <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    2948:	85a6                	mv	a1,s1
    294a:	00005517          	auipc	a0,0x5
    294e:	91650513          	addi	a0,a0,-1770 # 7260 <malloc+0xdbc>
    2952:	00004097          	auipc	ra,0x4
    2956:	a96080e7          	jalr	-1386(ra) # 63e8 <printf>
    exit(1);
    295a:	4505                	li	a0,1
    295c:	00003097          	auipc	ra,0x3
    2960:	62a080e7          	jalr	1578(ra) # 5f86 <exit>
    printf("open(rwsbrk) failed\n");
    2964:	00005517          	auipc	a0,0x5
    2968:	8b450513          	addi	a0,a0,-1868 # 7218 <malloc+0xd74>
    296c:	00004097          	auipc	ra,0x4
    2970:	a7c080e7          	jalr	-1412(ra) # 63e8 <printf>
    exit(1);
    2974:	4505                	li	a0,1
    2976:	00003097          	auipc	ra,0x3
    297a:	610080e7          	jalr	1552(ra) # 5f86 <exit>
  close(fd);
    297e:	854a                	mv	a0,s2
    2980:	00003097          	auipc	ra,0x3
    2984:	62e080e7          	jalr	1582(ra) # 5fae <close>
  exit(0);
    2988:	4501                	li	a0,0
    298a:	00003097          	auipc	ra,0x3
    298e:	5fc080e7          	jalr	1532(ra) # 5f86 <exit>

0000000000002992 <sbrkbasic>:
{
    2992:	715d                	addi	sp,sp,-80
    2994:	e486                	sd	ra,72(sp)
    2996:	e0a2                	sd	s0,64(sp)
    2998:	ec56                	sd	s5,24(sp)
    299a:	0880                	addi	s0,sp,80
    299c:	8aaa                	mv	s5,a0
  pid = fork();
    299e:	00003097          	auipc	ra,0x3
    29a2:	5e0080e7          	jalr	1504(ra) # 5f7e <fork>
  if(pid < 0){
    29a6:	04054063          	bltz	a0,29e6 <sbrkbasic+0x54>
  if(pid == 0){
    29aa:	e925                	bnez	a0,2a1a <sbrkbasic+0x88>
    a = sbrk(TOOMUCH);
    29ac:	40000537          	lui	a0,0x40000
    29b0:	00003097          	auipc	ra,0x3
    29b4:	65e080e7          	jalr	1630(ra) # 600e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    29b8:	57fd                	li	a5,-1
    29ba:	04f50763          	beq	a0,a5,2a08 <sbrkbasic+0x76>
    29be:	fc26                	sd	s1,56(sp)
    29c0:	f84a                	sd	s2,48(sp)
    29c2:	f44e                	sd	s3,40(sp)
    29c4:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    29c6:	400007b7          	lui	a5,0x40000
    29ca:	97aa                	add	a5,a5,a0
      *b = 99;
    29cc:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    29d0:	6705                	lui	a4,0x1
      *b = 99;
    29d2:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    29d6:	953a                	add	a0,a0,a4
    29d8:	fef51de3          	bne	a0,a5,29d2 <sbrkbasic+0x40>
    exit(1);
    29dc:	4505                	li	a0,1
    29de:	00003097          	auipc	ra,0x3
    29e2:	5a8080e7          	jalr	1448(ra) # 5f86 <exit>
    29e6:	fc26                	sd	s1,56(sp)
    29e8:	f84a                	sd	s2,48(sp)
    29ea:	f44e                	sd	s3,40(sp)
    29ec:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    29ee:	00005517          	auipc	a0,0x5
    29f2:	89a50513          	addi	a0,a0,-1894 # 7288 <malloc+0xde4>
    29f6:	00004097          	auipc	ra,0x4
    29fa:	9f2080e7          	jalr	-1550(ra) # 63e8 <printf>
    exit(1);
    29fe:	4505                	li	a0,1
    2a00:	00003097          	auipc	ra,0x3
    2a04:	586080e7          	jalr	1414(ra) # 5f86 <exit>
    2a08:	fc26                	sd	s1,56(sp)
    2a0a:	f84a                	sd	s2,48(sp)
    2a0c:	f44e                	sd	s3,40(sp)
    2a0e:	f052                	sd	s4,32(sp)
      exit(0);
    2a10:	4501                	li	a0,0
    2a12:	00003097          	auipc	ra,0x3
    2a16:	574080e7          	jalr	1396(ra) # 5f86 <exit>
  wait(&xstatus);
    2a1a:	fbc40513          	addi	a0,s0,-68
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	570080e7          	jalr	1392(ra) # 5f8e <wait>
  if(xstatus == 1){
    2a26:	fbc42703          	lw	a4,-68(s0)
    2a2a:	4785                	li	a5,1
    2a2c:	02f70263          	beq	a4,a5,2a50 <sbrkbasic+0xbe>
    2a30:	fc26                	sd	s1,56(sp)
    2a32:	f84a                	sd	s2,48(sp)
    2a34:	f44e                	sd	s3,40(sp)
    2a36:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    2a38:	4501                	li	a0,0
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	5d4080e7          	jalr	1492(ra) # 600e <sbrk>
    2a42:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2a44:	4901                	li	s2,0
    b = sbrk(1);
    2a46:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2a48:	6a05                	lui	s4,0x1
    2a4a:	388a0a13          	addi	s4,s4,904 # 1388 <bigdir+0x11a>
    2a4e:	a025                	j	2a76 <sbrkbasic+0xe4>
    2a50:	fc26                	sd	s1,56(sp)
    2a52:	f84a                	sd	s2,48(sp)
    2a54:	f44e                	sd	s3,40(sp)
    2a56:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2a58:	85d6                	mv	a1,s5
    2a5a:	00005517          	auipc	a0,0x5
    2a5e:	84e50513          	addi	a0,a0,-1970 # 72a8 <malloc+0xe04>
    2a62:	00004097          	auipc	ra,0x4
    2a66:	986080e7          	jalr	-1658(ra) # 63e8 <printf>
    exit(1);
    2a6a:	4505                	li	a0,1
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	51a080e7          	jalr	1306(ra) # 5f86 <exit>
    2a74:	84be                	mv	s1,a5
    b = sbrk(1);
    2a76:	854e                	mv	a0,s3
    2a78:	00003097          	auipc	ra,0x3
    2a7c:	596080e7          	jalr	1430(ra) # 600e <sbrk>
    if(b != a){
    2a80:	04951b63          	bne	a0,s1,2ad6 <sbrkbasic+0x144>
    *b = 1;
    2a84:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2a88:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2a8c:	2905                	addiw	s2,s2,1
    2a8e:	ff4913e3          	bne	s2,s4,2a74 <sbrkbasic+0xe2>
  pid = fork();
    2a92:	00003097          	auipc	ra,0x3
    2a96:	4ec080e7          	jalr	1260(ra) # 5f7e <fork>
    2a9a:	892a                	mv	s2,a0
  if(pid < 0){
    2a9c:	04054e63          	bltz	a0,2af8 <sbrkbasic+0x166>
  c = sbrk(1);
    2aa0:	4505                	li	a0,1
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	56c080e7          	jalr	1388(ra) # 600e <sbrk>
  c = sbrk(1);
    2aaa:	4505                	li	a0,1
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	562080e7          	jalr	1378(ra) # 600e <sbrk>
  if(c != a + 1){
    2ab4:	0489                	addi	s1,s1,2
    2ab6:	04a48f63          	beq	s1,a0,2b14 <sbrkbasic+0x182>
    printf("%s: sbrk test failed post-fork\n", s);
    2aba:	85d6                	mv	a1,s5
    2abc:	00005517          	auipc	a0,0x5
    2ac0:	84c50513          	addi	a0,a0,-1972 # 7308 <malloc+0xe64>
    2ac4:	00004097          	auipc	ra,0x4
    2ac8:	924080e7          	jalr	-1756(ra) # 63e8 <printf>
    exit(1);
    2acc:	4505                	li	a0,1
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	4b8080e7          	jalr	1208(ra) # 5f86 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2ad6:	872a                	mv	a4,a0
    2ad8:	86a6                	mv	a3,s1
    2ada:	864a                	mv	a2,s2
    2adc:	85d6                	mv	a1,s5
    2ade:	00004517          	auipc	a0,0x4
    2ae2:	7ea50513          	addi	a0,a0,2026 # 72c8 <malloc+0xe24>
    2ae6:	00004097          	auipc	ra,0x4
    2aea:	902080e7          	jalr	-1790(ra) # 63e8 <printf>
      exit(1);
    2aee:	4505                	li	a0,1
    2af0:	00003097          	auipc	ra,0x3
    2af4:	496080e7          	jalr	1174(ra) # 5f86 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2af8:	85d6                	mv	a1,s5
    2afa:	00004517          	auipc	a0,0x4
    2afe:	7ee50513          	addi	a0,a0,2030 # 72e8 <malloc+0xe44>
    2b02:	00004097          	auipc	ra,0x4
    2b06:	8e6080e7          	jalr	-1818(ra) # 63e8 <printf>
    exit(1);
    2b0a:	4505                	li	a0,1
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	47a080e7          	jalr	1146(ra) # 5f86 <exit>
  if(pid == 0)
    2b14:	00091763          	bnez	s2,2b22 <sbrkbasic+0x190>
    exit(0);
    2b18:	4501                	li	a0,0
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	46c080e7          	jalr	1132(ra) # 5f86 <exit>
  wait(&xstatus);
    2b22:	fbc40513          	addi	a0,s0,-68
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	468080e7          	jalr	1128(ra) # 5f8e <wait>
  exit(xstatus);
    2b2e:	fbc42503          	lw	a0,-68(s0)
    2b32:	00003097          	auipc	ra,0x3
    2b36:	454080e7          	jalr	1108(ra) # 5f86 <exit>

0000000000002b3a <sbrkmuch>:
{
    2b3a:	7179                	addi	sp,sp,-48
    2b3c:	f406                	sd	ra,40(sp)
    2b3e:	f022                	sd	s0,32(sp)
    2b40:	ec26                	sd	s1,24(sp)
    2b42:	e84a                	sd	s2,16(sp)
    2b44:	e44e                	sd	s3,8(sp)
    2b46:	e052                	sd	s4,0(sp)
    2b48:	1800                	addi	s0,sp,48
    2b4a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2b4c:	4501                	li	a0,0
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	4c0080e7          	jalr	1216(ra) # 600e <sbrk>
    2b56:	892a                	mv	s2,a0
  a = sbrk(0);
    2b58:	4501                	li	a0,0
    2b5a:	00003097          	auipc	ra,0x3
    2b5e:	4b4080e7          	jalr	1204(ra) # 600e <sbrk>
    2b62:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2b64:	06400537          	lui	a0,0x6400
    2b68:	9d05                	subw	a0,a0,s1
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	4a4080e7          	jalr	1188(ra) # 600e <sbrk>
  if (p != a) {
    2b72:	0ca49863          	bne	s1,a0,2c42 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2b76:	4501                	li	a0,0
    2b78:	00003097          	auipc	ra,0x3
    2b7c:	496080e7          	jalr	1174(ra) # 600e <sbrk>
    2b80:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2b82:	00a4f963          	bgeu	s1,a0,2b94 <sbrkmuch+0x5a>
    *pp = 1;
    2b86:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2b88:	6705                	lui	a4,0x1
    *pp = 1;
    2b8a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2b8e:	94ba                	add	s1,s1,a4
    2b90:	fef4ede3          	bltu	s1,a5,2b8a <sbrkmuch+0x50>
  *lastaddr = 99;
    2b94:	064007b7          	lui	a5,0x6400
    2b98:	06300713          	li	a4,99
    2b9c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef387>
  a = sbrk(0);
    2ba0:	4501                	li	a0,0
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	46c080e7          	jalr	1132(ra) # 600e <sbrk>
    2baa:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2bac:	757d                	lui	a0,0xfffff
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	460080e7          	jalr	1120(ra) # 600e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2bb6:	57fd                	li	a5,-1
    2bb8:	0af50363          	beq	a0,a5,2c5e <sbrkmuch+0x124>
  c = sbrk(0);
    2bbc:	4501                	li	a0,0
    2bbe:	00003097          	auipc	ra,0x3
    2bc2:	450080e7          	jalr	1104(ra) # 600e <sbrk>
  if(c != a - PGSIZE){
    2bc6:	77fd                	lui	a5,0xfffff
    2bc8:	97a6                	add	a5,a5,s1
    2bca:	0af51863          	bne	a0,a5,2c7a <sbrkmuch+0x140>
  a = sbrk(0);
    2bce:	4501                	li	a0,0
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	43e080e7          	jalr	1086(ra) # 600e <sbrk>
    2bd8:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2bda:	6505                	lui	a0,0x1
    2bdc:	00003097          	auipc	ra,0x3
    2be0:	432080e7          	jalr	1074(ra) # 600e <sbrk>
    2be4:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2be6:	0aa49a63          	bne	s1,a0,2c9a <sbrkmuch+0x160>
    2bea:	4501                	li	a0,0
    2bec:	00003097          	auipc	ra,0x3
    2bf0:	422080e7          	jalr	1058(ra) # 600e <sbrk>
    2bf4:	6785                	lui	a5,0x1
    2bf6:	97a6                	add	a5,a5,s1
    2bf8:	0af51163          	bne	a0,a5,2c9a <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2bfc:	064007b7          	lui	a5,0x6400
    2c00:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef387>
    2c04:	06300793          	li	a5,99
    2c08:	0af70963          	beq	a4,a5,2cba <sbrkmuch+0x180>
  a = sbrk(0);
    2c0c:	4501                	li	a0,0
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	400080e7          	jalr	1024(ra) # 600e <sbrk>
    2c16:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2c18:	4501                	li	a0,0
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	3f4080e7          	jalr	1012(ra) # 600e <sbrk>
    2c22:	40a9053b          	subw	a0,s2,a0
    2c26:	00003097          	auipc	ra,0x3
    2c2a:	3e8080e7          	jalr	1000(ra) # 600e <sbrk>
  if(c != a){
    2c2e:	0aa49463          	bne	s1,a0,2cd6 <sbrkmuch+0x19c>
}
    2c32:	70a2                	ld	ra,40(sp)
    2c34:	7402                	ld	s0,32(sp)
    2c36:	64e2                	ld	s1,24(sp)
    2c38:	6942                	ld	s2,16(sp)
    2c3a:	69a2                	ld	s3,8(sp)
    2c3c:	6a02                	ld	s4,0(sp)
    2c3e:	6145                	addi	sp,sp,48
    2c40:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2c42:	85ce                	mv	a1,s3
    2c44:	00004517          	auipc	a0,0x4
    2c48:	6e450513          	addi	a0,a0,1764 # 7328 <malloc+0xe84>
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	79c080e7          	jalr	1948(ra) # 63e8 <printf>
    exit(1);
    2c54:	4505                	li	a0,1
    2c56:	00003097          	auipc	ra,0x3
    2c5a:	330080e7          	jalr	816(ra) # 5f86 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2c5e:	85ce                	mv	a1,s3
    2c60:	00004517          	auipc	a0,0x4
    2c64:	71050513          	addi	a0,a0,1808 # 7370 <malloc+0xecc>
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	780080e7          	jalr	1920(ra) # 63e8 <printf>
    exit(1);
    2c70:	4505                	li	a0,1
    2c72:	00003097          	auipc	ra,0x3
    2c76:	314080e7          	jalr	788(ra) # 5f86 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2c7a:	86aa                	mv	a3,a0
    2c7c:	8626                	mv	a2,s1
    2c7e:	85ce                	mv	a1,s3
    2c80:	00004517          	auipc	a0,0x4
    2c84:	71050513          	addi	a0,a0,1808 # 7390 <malloc+0xeec>
    2c88:	00003097          	auipc	ra,0x3
    2c8c:	760080e7          	jalr	1888(ra) # 63e8 <printf>
    exit(1);
    2c90:	4505                	li	a0,1
    2c92:	00003097          	auipc	ra,0x3
    2c96:	2f4080e7          	jalr	756(ra) # 5f86 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2c9a:	86d2                	mv	a3,s4
    2c9c:	8626                	mv	a2,s1
    2c9e:	85ce                	mv	a1,s3
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	73050513          	addi	a0,a0,1840 # 73d0 <malloc+0xf2c>
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	740080e7          	jalr	1856(ra) # 63e8 <printf>
    exit(1);
    2cb0:	4505                	li	a0,1
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	2d4080e7          	jalr	724(ra) # 5f86 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2cba:	85ce                	mv	a1,s3
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	74450513          	addi	a0,a0,1860 # 7400 <malloc+0xf5c>
    2cc4:	00003097          	auipc	ra,0x3
    2cc8:	724080e7          	jalr	1828(ra) # 63e8 <printf>
    exit(1);
    2ccc:	4505                	li	a0,1
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	2b8080e7          	jalr	696(ra) # 5f86 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2cd6:	86aa                	mv	a3,a0
    2cd8:	8626                	mv	a2,s1
    2cda:	85ce                	mv	a1,s3
    2cdc:	00004517          	auipc	a0,0x4
    2ce0:	75c50513          	addi	a0,a0,1884 # 7438 <malloc+0xf94>
    2ce4:	00003097          	auipc	ra,0x3
    2ce8:	704080e7          	jalr	1796(ra) # 63e8 <printf>
    exit(1);
    2cec:	4505                	li	a0,1
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	298080e7          	jalr	664(ra) # 5f86 <exit>

0000000000002cf6 <sbrkarg>:
{
    2cf6:	7179                	addi	sp,sp,-48
    2cf8:	f406                	sd	ra,40(sp)
    2cfa:	f022                	sd	s0,32(sp)
    2cfc:	ec26                	sd	s1,24(sp)
    2cfe:	e84a                	sd	s2,16(sp)
    2d00:	e44e                	sd	s3,8(sp)
    2d02:	1800                	addi	s0,sp,48
    2d04:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2d06:	6505                	lui	a0,0x1
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	306080e7          	jalr	774(ra) # 600e <sbrk>
    2d10:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2d12:	20100593          	li	a1,513
    2d16:	00004517          	auipc	a0,0x4
    2d1a:	74a50513          	addi	a0,a0,1866 # 7460 <malloc+0xfbc>
    2d1e:	00003097          	auipc	ra,0x3
    2d22:	2a8080e7          	jalr	680(ra) # 5fc6 <open>
    2d26:	84aa                	mv	s1,a0
  unlink("sbrk");
    2d28:	00004517          	auipc	a0,0x4
    2d2c:	73850513          	addi	a0,a0,1848 # 7460 <malloc+0xfbc>
    2d30:	00003097          	auipc	ra,0x3
    2d34:	2a6080e7          	jalr	678(ra) # 5fd6 <unlink>
  if(fd < 0)  {
    2d38:	0404c163          	bltz	s1,2d7a <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2d3c:	6605                	lui	a2,0x1
    2d3e:	85ca                	mv	a1,s2
    2d40:	8526                	mv	a0,s1
    2d42:	00003097          	auipc	ra,0x3
    2d46:	264080e7          	jalr	612(ra) # 5fa6 <write>
    2d4a:	04054663          	bltz	a0,2d96 <sbrkarg+0xa0>
  close(fd);
    2d4e:	8526                	mv	a0,s1
    2d50:	00003097          	auipc	ra,0x3
    2d54:	25e080e7          	jalr	606(ra) # 5fae <close>
  a = sbrk(PGSIZE);
    2d58:	6505                	lui	a0,0x1
    2d5a:	00003097          	auipc	ra,0x3
    2d5e:	2b4080e7          	jalr	692(ra) # 600e <sbrk>
  if(pipe((int *) a) != 0){
    2d62:	00003097          	auipc	ra,0x3
    2d66:	234080e7          	jalr	564(ra) # 5f96 <pipe>
    2d6a:	e521                	bnez	a0,2db2 <sbrkarg+0xbc>
}
    2d6c:	70a2                	ld	ra,40(sp)
    2d6e:	7402                	ld	s0,32(sp)
    2d70:	64e2                	ld	s1,24(sp)
    2d72:	6942                	ld	s2,16(sp)
    2d74:	69a2                	ld	s3,8(sp)
    2d76:	6145                	addi	sp,sp,48
    2d78:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2d7a:	85ce                	mv	a1,s3
    2d7c:	00004517          	auipc	a0,0x4
    2d80:	6ec50513          	addi	a0,a0,1772 # 7468 <malloc+0xfc4>
    2d84:	00003097          	auipc	ra,0x3
    2d88:	664080e7          	jalr	1636(ra) # 63e8 <printf>
    exit(1);
    2d8c:	4505                	li	a0,1
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	1f8080e7          	jalr	504(ra) # 5f86 <exit>
    printf("%s: write sbrk failed\n", s);
    2d96:	85ce                	mv	a1,s3
    2d98:	00004517          	auipc	a0,0x4
    2d9c:	6e850513          	addi	a0,a0,1768 # 7480 <malloc+0xfdc>
    2da0:	00003097          	auipc	ra,0x3
    2da4:	648080e7          	jalr	1608(ra) # 63e8 <printf>
    exit(1);
    2da8:	4505                	li	a0,1
    2daa:	00003097          	auipc	ra,0x3
    2dae:	1dc080e7          	jalr	476(ra) # 5f86 <exit>
    printf("%s: pipe() failed\n", s);
    2db2:	85ce                	mv	a1,s3
    2db4:	00004517          	auipc	a0,0x4
    2db8:	1bc50513          	addi	a0,a0,444 # 6f70 <malloc+0xacc>
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	62c080e7          	jalr	1580(ra) # 63e8 <printf>
    exit(1);
    2dc4:	4505                	li	a0,1
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	1c0080e7          	jalr	448(ra) # 5f86 <exit>

0000000000002dce <argptest>:
{
    2dce:	1101                	addi	sp,sp,-32
    2dd0:	ec06                	sd	ra,24(sp)
    2dd2:	e822                	sd	s0,16(sp)
    2dd4:	e426                	sd	s1,8(sp)
    2dd6:	e04a                	sd	s2,0(sp)
    2dd8:	1000                	addi	s0,sp,32
    2dda:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2ddc:	4581                	li	a1,0
    2dde:	00004517          	auipc	a0,0x4
    2de2:	6ba50513          	addi	a0,a0,1722 # 7498 <malloc+0xff4>
    2de6:	00003097          	auipc	ra,0x3
    2dea:	1e0080e7          	jalr	480(ra) # 5fc6 <open>
  if (fd < 0) {
    2dee:	02054b63          	bltz	a0,2e24 <argptest+0x56>
    2df2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2df4:	4501                	li	a0,0
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	218080e7          	jalr	536(ra) # 600e <sbrk>
    2dfe:	567d                	li	a2,-1
    2e00:	00c505b3          	add	a1,a0,a2
    2e04:	8526                	mv	a0,s1
    2e06:	00003097          	auipc	ra,0x3
    2e0a:	198080e7          	jalr	408(ra) # 5f9e <read>
  close(fd);
    2e0e:	8526                	mv	a0,s1
    2e10:	00003097          	auipc	ra,0x3
    2e14:	19e080e7          	jalr	414(ra) # 5fae <close>
}
    2e18:	60e2                	ld	ra,24(sp)
    2e1a:	6442                	ld	s0,16(sp)
    2e1c:	64a2                	ld	s1,8(sp)
    2e1e:	6902                	ld	s2,0(sp)
    2e20:	6105                	addi	sp,sp,32
    2e22:	8082                	ret
    printf("%s: open failed\n", s);
    2e24:	85ca                	mv	a1,s2
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	05a50513          	addi	a0,a0,90 # 6e80 <malloc+0x9dc>
    2e2e:	00003097          	auipc	ra,0x3
    2e32:	5ba080e7          	jalr	1466(ra) # 63e8 <printf>
    exit(1);
    2e36:	4505                	li	a0,1
    2e38:	00003097          	auipc	ra,0x3
    2e3c:	14e080e7          	jalr	334(ra) # 5f86 <exit>

0000000000002e40 <sbrkbugs>:
{
    2e40:	1141                	addi	sp,sp,-16
    2e42:	e406                	sd	ra,8(sp)
    2e44:	e022                	sd	s0,0(sp)
    2e46:	0800                	addi	s0,sp,16
  int pid = fork();
    2e48:	00003097          	auipc	ra,0x3
    2e4c:	136080e7          	jalr	310(ra) # 5f7e <fork>
  if(pid < 0){
    2e50:	02054263          	bltz	a0,2e74 <sbrkbugs+0x34>
  if(pid == 0){
    2e54:	ed0d                	bnez	a0,2e8e <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2e56:	00003097          	auipc	ra,0x3
    2e5a:	1b8080e7          	jalr	440(ra) # 600e <sbrk>
    sbrk(-sz);
    2e5e:	40a0053b          	negw	a0,a0
    2e62:	00003097          	auipc	ra,0x3
    2e66:	1ac080e7          	jalr	428(ra) # 600e <sbrk>
    exit(0);
    2e6a:	4501                	li	a0,0
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	11a080e7          	jalr	282(ra) # 5f86 <exit>
    printf("fork failed\n");
    2e74:	00005517          	auipc	a0,0x5
    2e78:	56450513          	addi	a0,a0,1380 # 83d8 <malloc+0x1f34>
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	56c080e7          	jalr	1388(ra) # 63e8 <printf>
    exit(1);
    2e84:	4505                	li	a0,1
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	100080e7          	jalr	256(ra) # 5f86 <exit>
  wait(0);
    2e8e:	4501                	li	a0,0
    2e90:	00003097          	auipc	ra,0x3
    2e94:	0fe080e7          	jalr	254(ra) # 5f8e <wait>
  pid = fork();
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	0e6080e7          	jalr	230(ra) # 5f7e <fork>
  if(pid < 0){
    2ea0:	02054563          	bltz	a0,2eca <sbrkbugs+0x8a>
  if(pid == 0){
    2ea4:	e121                	bnez	a0,2ee4 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2ea6:	00003097          	auipc	ra,0x3
    2eaa:	168080e7          	jalr	360(ra) # 600e <sbrk>
    sbrk(-(sz - 3500));
    2eae:	6785                	lui	a5,0x1
    2eb0:	dac7879b          	addiw	a5,a5,-596 # dac <writebig+0x162>
    2eb4:	40a7853b          	subw	a0,a5,a0
    2eb8:	00003097          	auipc	ra,0x3
    2ebc:	156080e7          	jalr	342(ra) # 600e <sbrk>
    exit(0);
    2ec0:	4501                	li	a0,0
    2ec2:	00003097          	auipc	ra,0x3
    2ec6:	0c4080e7          	jalr	196(ra) # 5f86 <exit>
    printf("fork failed\n");
    2eca:	00005517          	auipc	a0,0x5
    2ece:	50e50513          	addi	a0,a0,1294 # 83d8 <malloc+0x1f34>
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	516080e7          	jalr	1302(ra) # 63e8 <printf>
    exit(1);
    2eda:	4505                	li	a0,1
    2edc:	00003097          	auipc	ra,0x3
    2ee0:	0aa080e7          	jalr	170(ra) # 5f86 <exit>
  wait(0);
    2ee4:	4501                	li	a0,0
    2ee6:	00003097          	auipc	ra,0x3
    2eea:	0a8080e7          	jalr	168(ra) # 5f8e <wait>
  pid = fork();
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	090080e7          	jalr	144(ra) # 5f7e <fork>
  if(pid < 0){
    2ef6:	02054a63          	bltz	a0,2f2a <sbrkbugs+0xea>
  if(pid == 0){
    2efa:	e529                	bnez	a0,2f44 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2efc:	00003097          	auipc	ra,0x3
    2f00:	112080e7          	jalr	274(ra) # 600e <sbrk>
    2f04:	67ad                	lui	a5,0xb
    2f06:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x2a0>
    2f0a:	40a7853b          	subw	a0,a5,a0
    2f0e:	00003097          	auipc	ra,0x3
    2f12:	100080e7          	jalr	256(ra) # 600e <sbrk>
    sbrk(-10);
    2f16:	5559                	li	a0,-10
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	0f6080e7          	jalr	246(ra) # 600e <sbrk>
    exit(0);
    2f20:	4501                	li	a0,0
    2f22:	00003097          	auipc	ra,0x3
    2f26:	064080e7          	jalr	100(ra) # 5f86 <exit>
    printf("fork failed\n");
    2f2a:	00005517          	auipc	a0,0x5
    2f2e:	4ae50513          	addi	a0,a0,1198 # 83d8 <malloc+0x1f34>
    2f32:	00003097          	auipc	ra,0x3
    2f36:	4b6080e7          	jalr	1206(ra) # 63e8 <printf>
    exit(1);
    2f3a:	4505                	li	a0,1
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	04a080e7          	jalr	74(ra) # 5f86 <exit>
  wait(0);
    2f44:	4501                	li	a0,0
    2f46:	00003097          	auipc	ra,0x3
    2f4a:	048080e7          	jalr	72(ra) # 5f8e <wait>
  exit(0);
    2f4e:	4501                	li	a0,0
    2f50:	00003097          	auipc	ra,0x3
    2f54:	036080e7          	jalr	54(ra) # 5f86 <exit>

0000000000002f58 <sbrklast>:
{
    2f58:	7179                	addi	sp,sp,-48
    2f5a:	f406                	sd	ra,40(sp)
    2f5c:	f022                	sd	s0,32(sp)
    2f5e:	ec26                	sd	s1,24(sp)
    2f60:	e84a                	sd	s2,16(sp)
    2f62:	e44e                	sd	s3,8(sp)
    2f64:	e052                	sd	s4,0(sp)
    2f66:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2f68:	4501                	li	a0,0
    2f6a:	00003097          	auipc	ra,0x3
    2f6e:	0a4080e7          	jalr	164(ra) # 600e <sbrk>
  if((top % 4096) != 0)
    2f72:	03451793          	slli	a5,a0,0x34
    2f76:	ebd9                	bnez	a5,300c <sbrklast+0xb4>
  sbrk(4096);
    2f78:	6505                	lui	a0,0x1
    2f7a:	00003097          	auipc	ra,0x3
    2f7e:	094080e7          	jalr	148(ra) # 600e <sbrk>
  sbrk(10);
    2f82:	4529                	li	a0,10
    2f84:	00003097          	auipc	ra,0x3
    2f88:	08a080e7          	jalr	138(ra) # 600e <sbrk>
  sbrk(-20);
    2f8c:	5531                	li	a0,-20
    2f8e:	00003097          	auipc	ra,0x3
    2f92:	080080e7          	jalr	128(ra) # 600e <sbrk>
  top = (uint64) sbrk(0);
    2f96:	4501                	li	a0,0
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	076080e7          	jalr	118(ra) # 600e <sbrk>
    2fa0:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2fa2:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xc>
  p[0] = 'x';
    2fa6:	07800a13          	li	s4,120
    2faa:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2fae:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2fb2:	20200593          	li	a1,514
    2fb6:	854a                	mv	a0,s2
    2fb8:	00003097          	auipc	ra,0x3
    2fbc:	00e080e7          	jalr	14(ra) # 5fc6 <open>
    2fc0:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2fc2:	4605                	li	a2,1
    2fc4:	85ca                	mv	a1,s2
    2fc6:	00003097          	auipc	ra,0x3
    2fca:	fe0080e7          	jalr	-32(ra) # 5fa6 <write>
  close(fd);
    2fce:	854e                	mv	a0,s3
    2fd0:	00003097          	auipc	ra,0x3
    2fd4:	fde080e7          	jalr	-34(ra) # 5fae <close>
  fd = open(p, O_RDWR);
    2fd8:	4589                	li	a1,2
    2fda:	854a                	mv	a0,s2
    2fdc:	00003097          	auipc	ra,0x3
    2fe0:	fea080e7          	jalr	-22(ra) # 5fc6 <open>
  p[0] = '\0';
    2fe4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2fe8:	4605                	li	a2,1
    2fea:	85ca                	mv	a1,s2
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	fb2080e7          	jalr	-78(ra) # 5f9e <read>
  if(p[0] != 'x')
    2ff4:	fc04c783          	lbu	a5,-64(s1)
    2ff8:	03479563          	bne	a5,s4,3022 <sbrklast+0xca>
}
    2ffc:	70a2                	ld	ra,40(sp)
    2ffe:	7402                	ld	s0,32(sp)
    3000:	64e2                	ld	s1,24(sp)
    3002:	6942                	ld	s2,16(sp)
    3004:	69a2                	ld	s3,8(sp)
    3006:	6a02                	ld	s4,0(sp)
    3008:	6145                	addi	sp,sp,48
    300a:	8082                	ret
    sbrk(4096 - (top % 4096));
    300c:	6785                	lui	a5,0x1
    300e:	fff78713          	addi	a4,a5,-1 # fff <linktest+0x4b>
    3012:	8d79                	and	a0,a0,a4
    3014:	40a7853b          	subw	a0,a5,a0
    3018:	00003097          	auipc	ra,0x3
    301c:	ff6080e7          	jalr	-10(ra) # 600e <sbrk>
    3020:	bfa1                	j	2f78 <sbrklast+0x20>
    exit(1);
    3022:	4505                	li	a0,1
    3024:	00003097          	auipc	ra,0x3
    3028:	f62080e7          	jalr	-158(ra) # 5f86 <exit>

000000000000302c <sbrk8000>:
{
    302c:	1141                	addi	sp,sp,-16
    302e:	e406                	sd	ra,8(sp)
    3030:	e022                	sd	s0,0(sp)
    3032:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    3034:	80000537          	lui	a0,0x80000
    3038:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef38c>
    303a:	00003097          	auipc	ra,0x3
    303e:	fd4080e7          	jalr	-44(ra) # 600e <sbrk>
  volatile char *top = sbrk(0);
    3042:	4501                	li	a0,0
    3044:	00003097          	auipc	ra,0x3
    3048:	fca080e7          	jalr	-54(ra) # 600e <sbrk>
  *(top-1) = *(top-1) + 1;
    304c:	fff54783          	lbu	a5,-1(a0)
    3050:	0785                	addi	a5,a5,1
    3052:	0ff7f793          	zext.b	a5,a5
    3056:	fef50fa3          	sb	a5,-1(a0)
}
    305a:	60a2                	ld	ra,8(sp)
    305c:	6402                	ld	s0,0(sp)
    305e:	0141                	addi	sp,sp,16
    3060:	8082                	ret

0000000000003062 <execout>:
{
    3062:	711d                	addi	sp,sp,-96
    3064:	ec86                	sd	ra,88(sp)
    3066:	e8a2                	sd	s0,80(sp)
    3068:	e4a6                	sd	s1,72(sp)
    306a:	e0ca                	sd	s2,64(sp)
    306c:	fc4e                	sd	s3,56(sp)
    306e:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    3070:	4901                	li	s2,0
    3072:	49bd                	li	s3,15
    int pid = fork();
    3074:	00003097          	auipc	ra,0x3
    3078:	f0a080e7          	jalr	-246(ra) # 5f7e <fork>
    307c:	84aa                	mv	s1,a0
    if(pid < 0){
    307e:	02054263          	bltz	a0,30a2 <execout+0x40>
    } else if(pid == 0){
    3082:	cd1d                	beqz	a0,30c0 <execout+0x5e>
      wait((int*)0);
    3084:	4501                	li	a0,0
    3086:	00003097          	auipc	ra,0x3
    308a:	f08080e7          	jalr	-248(ra) # 5f8e <wait>
  for(int avail = 0; avail < 15; avail++){
    308e:	2905                	addiw	s2,s2,1
    3090:	ff3912e3          	bne	s2,s3,3074 <execout+0x12>
    3094:	f852                	sd	s4,48(sp)
    3096:	f456                	sd	s5,40(sp)
  exit(0);
    3098:	4501                	li	a0,0
    309a:	00003097          	auipc	ra,0x3
    309e:	eec080e7          	jalr	-276(ra) # 5f86 <exit>
    30a2:	f852                	sd	s4,48(sp)
    30a4:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    30a6:	00005517          	auipc	a0,0x5
    30aa:	33250513          	addi	a0,a0,818 # 83d8 <malloc+0x1f34>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	33a080e7          	jalr	826(ra) # 63e8 <printf>
      exit(1);
    30b6:	4505                	li	a0,1
    30b8:	00003097          	auipc	ra,0x3
    30bc:	ece080e7          	jalr	-306(ra) # 5f86 <exit>
    30c0:	f852                	sd	s4,48(sp)
    30c2:	f456                	sd	s5,40(sp)
        uint64 a = (uint64) sbrk(4096);
    30c4:	6985                	lui	s3,0x1
        if(a == 0xffffffffffffffffLL)
    30c6:	5a7d                	li	s4,-1
        *(char*)(a + 4096 - 1) = 1;
    30c8:	4a85                	li	s5,1
        uint64 a = (uint64) sbrk(4096);
    30ca:	854e                	mv	a0,s3
    30cc:	00003097          	auipc	ra,0x3
    30d0:	f42080e7          	jalr	-190(ra) # 600e <sbrk>
        if(a == 0xffffffffffffffffLL)
    30d4:	01450663          	beq	a0,s4,30e0 <execout+0x7e>
        *(char*)(a + 4096 - 1) = 1;
    30d8:	954e                	add	a0,a0,s3
    30da:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    30de:	b7f5                	j	30ca <execout+0x68>
        sbrk(-4096);
    30e0:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    30e2:	01205a63          	blez	s2,30f6 <execout+0x94>
        sbrk(-4096);
    30e6:	854e                	mv	a0,s3
    30e8:	00003097          	auipc	ra,0x3
    30ec:	f26080e7          	jalr	-218(ra) # 600e <sbrk>
      for(int i = 0; i < avail; i++)
    30f0:	2485                	addiw	s1,s1,1
    30f2:	ff249ae3          	bne	s1,s2,30e6 <execout+0x84>
      close(1);
    30f6:	4505                	li	a0,1
    30f8:	00003097          	auipc	ra,0x3
    30fc:	eb6080e7          	jalr	-330(ra) # 5fae <close>
      char *args[] = { "echo", "x", 0 };
    3100:	00003517          	auipc	a0,0x3
    3104:	4d850513          	addi	a0,a0,1240 # 65d8 <malloc+0x134>
    3108:	faa43423          	sd	a0,-88(s0)
    310c:	00003797          	auipc	a5,0x3
    3110:	53c78793          	addi	a5,a5,1340 # 6648 <malloc+0x1a4>
    3114:	faf43823          	sd	a5,-80(s0)
    3118:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    311c:	fa840593          	addi	a1,s0,-88
    3120:	00003097          	auipc	ra,0x3
    3124:	e9e080e7          	jalr	-354(ra) # 5fbe <exec>
      exit(0);
    3128:	4501                	li	a0,0
    312a:	00003097          	auipc	ra,0x3
    312e:	e5c080e7          	jalr	-420(ra) # 5f86 <exit>

0000000000003132 <fourteen>:
{
    3132:	1101                	addi	sp,sp,-32
    3134:	ec06                	sd	ra,24(sp)
    3136:	e822                	sd	s0,16(sp)
    3138:	e426                	sd	s1,8(sp)
    313a:	1000                	addi	s0,sp,32
    313c:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    313e:	00004517          	auipc	a0,0x4
    3142:	53250513          	addi	a0,a0,1330 # 7670 <malloc+0x11cc>
    3146:	00003097          	auipc	ra,0x3
    314a:	ea8080e7          	jalr	-344(ra) # 5fee <mkdir>
    314e:	e165                	bnez	a0,322e <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3150:	00004517          	auipc	a0,0x4
    3154:	37850513          	addi	a0,a0,888 # 74c8 <malloc+0x1024>
    3158:	00003097          	auipc	ra,0x3
    315c:	e96080e7          	jalr	-362(ra) # 5fee <mkdir>
    3160:	e56d                	bnez	a0,324a <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3162:	20000593          	li	a1,512
    3166:	00004517          	auipc	a0,0x4
    316a:	3ba50513          	addi	a0,a0,954 # 7520 <malloc+0x107c>
    316e:	00003097          	auipc	ra,0x3
    3172:	e58080e7          	jalr	-424(ra) # 5fc6 <open>
  if(fd < 0){
    3176:	0e054863          	bltz	a0,3266 <fourteen+0x134>
  close(fd);
    317a:	00003097          	auipc	ra,0x3
    317e:	e34080e7          	jalr	-460(ra) # 5fae <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3182:	4581                	li	a1,0
    3184:	00004517          	auipc	a0,0x4
    3188:	41450513          	addi	a0,a0,1044 # 7598 <malloc+0x10f4>
    318c:	00003097          	auipc	ra,0x3
    3190:	e3a080e7          	jalr	-454(ra) # 5fc6 <open>
  if(fd < 0){
    3194:	0e054763          	bltz	a0,3282 <fourteen+0x150>
  close(fd);
    3198:	00003097          	auipc	ra,0x3
    319c:	e16080e7          	jalr	-490(ra) # 5fae <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    31a0:	00004517          	auipc	a0,0x4
    31a4:	46850513          	addi	a0,a0,1128 # 7608 <malloc+0x1164>
    31a8:	00003097          	auipc	ra,0x3
    31ac:	e46080e7          	jalr	-442(ra) # 5fee <mkdir>
    31b0:	c57d                	beqz	a0,329e <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    31b2:	00004517          	auipc	a0,0x4
    31b6:	4ae50513          	addi	a0,a0,1198 # 7660 <malloc+0x11bc>
    31ba:	00003097          	auipc	ra,0x3
    31be:	e34080e7          	jalr	-460(ra) # 5fee <mkdir>
    31c2:	cd65                	beqz	a0,32ba <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    31c4:	00004517          	auipc	a0,0x4
    31c8:	49c50513          	addi	a0,a0,1180 # 7660 <malloc+0x11bc>
    31cc:	00003097          	auipc	ra,0x3
    31d0:	e0a080e7          	jalr	-502(ra) # 5fd6 <unlink>
  unlink("12345678901234/12345678901234");
    31d4:	00004517          	auipc	a0,0x4
    31d8:	43450513          	addi	a0,a0,1076 # 7608 <malloc+0x1164>
    31dc:	00003097          	auipc	ra,0x3
    31e0:	dfa080e7          	jalr	-518(ra) # 5fd6 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    31e4:	00004517          	auipc	a0,0x4
    31e8:	3b450513          	addi	a0,a0,948 # 7598 <malloc+0x10f4>
    31ec:	00003097          	auipc	ra,0x3
    31f0:	dea080e7          	jalr	-534(ra) # 5fd6 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    31f4:	00004517          	auipc	a0,0x4
    31f8:	32c50513          	addi	a0,a0,812 # 7520 <malloc+0x107c>
    31fc:	00003097          	auipc	ra,0x3
    3200:	dda080e7          	jalr	-550(ra) # 5fd6 <unlink>
  unlink("12345678901234/123456789012345");
    3204:	00004517          	auipc	a0,0x4
    3208:	2c450513          	addi	a0,a0,708 # 74c8 <malloc+0x1024>
    320c:	00003097          	auipc	ra,0x3
    3210:	dca080e7          	jalr	-566(ra) # 5fd6 <unlink>
  unlink("12345678901234");
    3214:	00004517          	auipc	a0,0x4
    3218:	45c50513          	addi	a0,a0,1116 # 7670 <malloc+0x11cc>
    321c:	00003097          	auipc	ra,0x3
    3220:	dba080e7          	jalr	-582(ra) # 5fd6 <unlink>
}
    3224:	60e2                	ld	ra,24(sp)
    3226:	6442                	ld	s0,16(sp)
    3228:	64a2                	ld	s1,8(sp)
    322a:	6105                	addi	sp,sp,32
    322c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    322e:	85a6                	mv	a1,s1
    3230:	00004517          	auipc	a0,0x4
    3234:	27050513          	addi	a0,a0,624 # 74a0 <malloc+0xffc>
    3238:	00003097          	auipc	ra,0x3
    323c:	1b0080e7          	jalr	432(ra) # 63e8 <printf>
    exit(1);
    3240:	4505                	li	a0,1
    3242:	00003097          	auipc	ra,0x3
    3246:	d44080e7          	jalr	-700(ra) # 5f86 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    324a:	85a6                	mv	a1,s1
    324c:	00004517          	auipc	a0,0x4
    3250:	29c50513          	addi	a0,a0,668 # 74e8 <malloc+0x1044>
    3254:	00003097          	auipc	ra,0x3
    3258:	194080e7          	jalr	404(ra) # 63e8 <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	00003097          	auipc	ra,0x3
    3262:	d28080e7          	jalr	-728(ra) # 5f86 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3266:	85a6                	mv	a1,s1
    3268:	00004517          	auipc	a0,0x4
    326c:	2e850513          	addi	a0,a0,744 # 7550 <malloc+0x10ac>
    3270:	00003097          	auipc	ra,0x3
    3274:	178080e7          	jalr	376(ra) # 63e8 <printf>
    exit(1);
    3278:	4505                	li	a0,1
    327a:	00003097          	auipc	ra,0x3
    327e:	d0c080e7          	jalr	-756(ra) # 5f86 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3282:	85a6                	mv	a1,s1
    3284:	00004517          	auipc	a0,0x4
    3288:	34450513          	addi	a0,a0,836 # 75c8 <malloc+0x1124>
    328c:	00003097          	auipc	ra,0x3
    3290:	15c080e7          	jalr	348(ra) # 63e8 <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	00003097          	auipc	ra,0x3
    329a:	cf0080e7          	jalr	-784(ra) # 5f86 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    329e:	85a6                	mv	a1,s1
    32a0:	00004517          	auipc	a0,0x4
    32a4:	38850513          	addi	a0,a0,904 # 7628 <malloc+0x1184>
    32a8:	00003097          	auipc	ra,0x3
    32ac:	140080e7          	jalr	320(ra) # 63e8 <printf>
    exit(1);
    32b0:	4505                	li	a0,1
    32b2:	00003097          	auipc	ra,0x3
    32b6:	cd4080e7          	jalr	-812(ra) # 5f86 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    32ba:	85a6                	mv	a1,s1
    32bc:	00004517          	auipc	a0,0x4
    32c0:	3c450513          	addi	a0,a0,964 # 7680 <malloc+0x11dc>
    32c4:	00003097          	auipc	ra,0x3
    32c8:	124080e7          	jalr	292(ra) # 63e8 <printf>
    exit(1);
    32cc:	4505                	li	a0,1
    32ce:	00003097          	auipc	ra,0x3
    32d2:	cb8080e7          	jalr	-840(ra) # 5f86 <exit>

00000000000032d6 <diskfull>:
{
    32d6:	b6010113          	addi	sp,sp,-1184
    32da:	48113c23          	sd	ra,1176(sp)
    32de:	48813823          	sd	s0,1168(sp)
    32e2:	48913423          	sd	s1,1160(sp)
    32e6:	49213023          	sd	s2,1152(sp)
    32ea:	47313c23          	sd	s3,1144(sp)
    32ee:	47413823          	sd	s4,1136(sp)
    32f2:	47513423          	sd	s5,1128(sp)
    32f6:	47613023          	sd	s6,1120(sp)
    32fa:	45713c23          	sd	s7,1112(sp)
    32fe:	45813823          	sd	s8,1104(sp)
    3302:	45913423          	sd	s9,1096(sp)
    3306:	45a13023          	sd	s10,1088(sp)
    330a:	43b13c23          	sd	s11,1080(sp)
    330e:	4a010413          	addi	s0,sp,1184
    3312:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    3316:	00004517          	auipc	a0,0x4
    331a:	3a250513          	addi	a0,a0,930 # 76b8 <malloc+0x1214>
    331e:	00003097          	auipc	ra,0x3
    3322:	cb8080e7          	jalr	-840(ra) # 5fd6 <unlink>
    3326:	03000a93          	li	s5,48
    name[0] = 'b';
    332a:	06200d13          	li	s10,98
    name[1] = 'i';
    332e:	06900c93          	li	s9,105
    name[2] = 'g';
    3332:	06700c13          	li	s8,103
    unlink(name);
    3336:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    333a:	60200b93          	li	s7,1538
    333e:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    3342:	b9040a13          	addi	s4,s0,-1136
    3346:	aa79                	j	34e4 <diskfull+0x20e>
      printf("%s: could not create file %s\n", s, name);
    3348:	b7040613          	addi	a2,s0,-1168
    334c:	b6843583          	ld	a1,-1176(s0)
    3350:	00004517          	auipc	a0,0x4
    3354:	37850513          	addi	a0,a0,888 # 76c8 <malloc+0x1224>
    3358:	00003097          	auipc	ra,0x3
    335c:	090080e7          	jalr	144(ra) # 63e8 <printf>
      break;
    3360:	a819                	j	3376 <diskfull+0xa0>
        close(fd);
    3362:	854e                	mv	a0,s3
    3364:	00003097          	auipc	ra,0x3
    3368:	c4a080e7          	jalr	-950(ra) # 5fae <close>
    close(fd);
    336c:	854e                	mv	a0,s3
    336e:	00003097          	auipc	ra,0x3
    3372:	c40080e7          	jalr	-960(ra) # 5fae <close>
  for(int i = 0; i < nzz; i++){
    3376:	4481                	li	s1,0
    name[0] = 'z';
    3378:	07a00993          	li	s3,122
    unlink(name);
    337c:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3380:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    3384:	08000a93          	li	s5,128
    name[0] = 'z';
    3388:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    338c:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    3390:	41f4d71b          	sraiw	a4,s1,0x1f
    3394:	01b7571b          	srliw	a4,a4,0x1b
    3398:	009707bb          	addw	a5,a4,s1
    339c:	4057d69b          	sraiw	a3,a5,0x5
    33a0:	0306869b          	addiw	a3,a3,48
    33a4:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    33a8:	8bfd                	andi	a5,a5,31
    33aa:	9f99                	subw	a5,a5,a4
    33ac:	0307879b          	addiw	a5,a5,48
    33b0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33b4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33b8:	854a                	mv	a0,s2
    33ba:	00003097          	auipc	ra,0x3
    33be:	c1c080e7          	jalr	-996(ra) # 5fd6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33c2:	85d2                	mv	a1,s4
    33c4:	854a                	mv	a0,s2
    33c6:	00003097          	auipc	ra,0x3
    33ca:	c00080e7          	jalr	-1024(ra) # 5fc6 <open>
    if(fd < 0)
    33ce:	00054963          	bltz	a0,33e0 <diskfull+0x10a>
    close(fd);
    33d2:	00003097          	auipc	ra,0x3
    33d6:	bdc080e7          	jalr	-1060(ra) # 5fae <close>
  for(int i = 0; i < nzz; i++){
    33da:	2485                	addiw	s1,s1,1
    33dc:	fb5496e3          	bne	s1,s5,3388 <diskfull+0xb2>
  if(mkdir("diskfulldir") == 0)
    33e0:	00004517          	auipc	a0,0x4
    33e4:	2d850513          	addi	a0,a0,728 # 76b8 <malloc+0x1214>
    33e8:	00003097          	auipc	ra,0x3
    33ec:	c06080e7          	jalr	-1018(ra) # 5fee <mkdir>
    33f0:	14050163          	beqz	a0,3532 <diskfull+0x25c>
  unlink("diskfulldir");
    33f4:	00004517          	auipc	a0,0x4
    33f8:	2c450513          	addi	a0,a0,708 # 76b8 <malloc+0x1214>
    33fc:	00003097          	auipc	ra,0x3
    3400:	bda080e7          	jalr	-1062(ra) # 5fd6 <unlink>
  for(int i = 0; i < nzz; i++){
    3404:	4481                	li	s1,0
    name[0] = 'z';
    3406:	07a00913          	li	s2,122
    unlink(name);
    340a:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    340e:	08000993          	li	s3,128
    name[0] = 'z';
    3412:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    3416:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    341a:	41f4d71b          	sraiw	a4,s1,0x1f
    341e:	01b7571b          	srliw	a4,a4,0x1b
    3422:	009707bb          	addw	a5,a4,s1
    3426:	4057d69b          	sraiw	a3,a5,0x5
    342a:	0306869b          	addiw	a3,a3,48
    342e:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    3432:	8bfd                	andi	a5,a5,31
    3434:	9f99                	subw	a5,a5,a4
    3436:	0307879b          	addiw	a5,a5,48
    343a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    343e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3442:	8552                	mv	a0,s4
    3444:	00003097          	auipc	ra,0x3
    3448:	b92080e7          	jalr	-1134(ra) # 5fd6 <unlink>
  for(int i = 0; i < nzz; i++){
    344c:	2485                	addiw	s1,s1,1
    344e:	fd3492e3          	bne	s1,s3,3412 <diskfull+0x13c>
    3452:	03000493          	li	s1,48
    name[0] = 'b';
    3456:	06200b13          	li	s6,98
    name[1] = 'i';
    345a:	06900a93          	li	s5,105
    name[2] = 'g';
    345e:	06700a13          	li	s4,103
    unlink(name);
    3462:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    3466:	07f00913          	li	s2,127
    name[0] = 'b';
    346a:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    346e:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3472:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    3476:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    347a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    347e:	854e                	mv	a0,s3
    3480:	00003097          	auipc	ra,0x3
    3484:	b56080e7          	jalr	-1194(ra) # 5fd6 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    3488:	2485                	addiw	s1,s1,1
    348a:	0ff4f493          	zext.b	s1,s1
    348e:	fd249ee3          	bne	s1,s2,346a <diskfull+0x194>
}
    3492:	49813083          	ld	ra,1176(sp)
    3496:	49013403          	ld	s0,1168(sp)
    349a:	48813483          	ld	s1,1160(sp)
    349e:	48013903          	ld	s2,1152(sp)
    34a2:	47813983          	ld	s3,1144(sp)
    34a6:	47013a03          	ld	s4,1136(sp)
    34aa:	46813a83          	ld	s5,1128(sp)
    34ae:	46013b03          	ld	s6,1120(sp)
    34b2:	45813b83          	ld	s7,1112(sp)
    34b6:	45013c03          	ld	s8,1104(sp)
    34ba:	44813c83          	ld	s9,1096(sp)
    34be:	44013d03          	ld	s10,1088(sp)
    34c2:	43813d83          	ld	s11,1080(sp)
    34c6:	4a010113          	addi	sp,sp,1184
    34ca:	8082                	ret
    close(fd);
    34cc:	854e                	mv	a0,s3
    34ce:	00003097          	auipc	ra,0x3
    34d2:	ae0080e7          	jalr	-1312(ra) # 5fae <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    34d6:	2a85                	addiw	s5,s5,1
    34d8:	0ffafa93          	zext.b	s5,s5
    34dc:	07f00793          	li	a5,127
    34e0:	e8fa8be3          	beq	s5,a5,3376 <diskfull+0xa0>
    name[0] = 'b';
    34e4:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    34e8:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    34ec:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    34f0:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    34f4:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    34f8:	855a                	mv	a0,s6
    34fa:	00003097          	auipc	ra,0x3
    34fe:	adc080e7          	jalr	-1316(ra) # 5fd6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3502:	85de                	mv	a1,s7
    3504:	855a                	mv	a0,s6
    3506:	00003097          	auipc	ra,0x3
    350a:	ac0080e7          	jalr	-1344(ra) # 5fc6 <open>
    350e:	89aa                	mv	s3,a0
    if(fd < 0){
    3510:	e2054ce3          	bltz	a0,3348 <diskfull+0x72>
    3514:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    3516:	40000913          	li	s2,1024
    351a:	864a                	mv	a2,s2
    351c:	85d2                	mv	a1,s4
    351e:	854e                	mv	a0,s3
    3520:	00003097          	auipc	ra,0x3
    3524:	a86080e7          	jalr	-1402(ra) # 5fa6 <write>
    3528:	e3251de3          	bne	a0,s2,3362 <diskfull+0x8c>
    for(int i = 0; i < MAXFILE; i++){
    352c:	34fd                	addiw	s1,s1,-1
    352e:	f4f5                	bnez	s1,351a <diskfull+0x244>
    3530:	bf71                	j	34cc <diskfull+0x1f6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    3532:	b6843583          	ld	a1,-1176(s0)
    3536:	00004517          	auipc	a0,0x4
    353a:	1b250513          	addi	a0,a0,434 # 76e8 <malloc+0x1244>
    353e:	00003097          	auipc	ra,0x3
    3542:	eaa080e7          	jalr	-342(ra) # 63e8 <printf>
    3546:	b57d                	j	33f4 <diskfull+0x11e>

0000000000003548 <iputtest>:
{
    3548:	1101                	addi	sp,sp,-32
    354a:	ec06                	sd	ra,24(sp)
    354c:	e822                	sd	s0,16(sp)
    354e:	e426                	sd	s1,8(sp)
    3550:	1000                	addi	s0,sp,32
    3552:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3554:	00004517          	auipc	a0,0x4
    3558:	1c450513          	addi	a0,a0,452 # 7718 <malloc+0x1274>
    355c:	00003097          	auipc	ra,0x3
    3560:	a92080e7          	jalr	-1390(ra) # 5fee <mkdir>
    3564:	04054563          	bltz	a0,35ae <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3568:	00004517          	auipc	a0,0x4
    356c:	1b050513          	addi	a0,a0,432 # 7718 <malloc+0x1274>
    3570:	00003097          	auipc	ra,0x3
    3574:	a86080e7          	jalr	-1402(ra) # 5ff6 <chdir>
    3578:	04054963          	bltz	a0,35ca <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    357c:	00004517          	auipc	a0,0x4
    3580:	1dc50513          	addi	a0,a0,476 # 7758 <malloc+0x12b4>
    3584:	00003097          	auipc	ra,0x3
    3588:	a52080e7          	jalr	-1454(ra) # 5fd6 <unlink>
    358c:	04054d63          	bltz	a0,35e6 <iputtest+0x9e>
  if(chdir("/") < 0){
    3590:	00004517          	auipc	a0,0x4
    3594:	1f850513          	addi	a0,a0,504 # 7788 <malloc+0x12e4>
    3598:	00003097          	auipc	ra,0x3
    359c:	a5e080e7          	jalr	-1442(ra) # 5ff6 <chdir>
    35a0:	06054163          	bltz	a0,3602 <iputtest+0xba>
}
    35a4:	60e2                	ld	ra,24(sp)
    35a6:	6442                	ld	s0,16(sp)
    35a8:	64a2                	ld	s1,8(sp)
    35aa:	6105                	addi	sp,sp,32
    35ac:	8082                	ret
    printf("%s: mkdir failed\n", s);
    35ae:	85a6                	mv	a1,s1
    35b0:	00004517          	auipc	a0,0x4
    35b4:	17050513          	addi	a0,a0,368 # 7720 <malloc+0x127c>
    35b8:	00003097          	auipc	ra,0x3
    35bc:	e30080e7          	jalr	-464(ra) # 63e8 <printf>
    exit(1);
    35c0:	4505                	li	a0,1
    35c2:	00003097          	auipc	ra,0x3
    35c6:	9c4080e7          	jalr	-1596(ra) # 5f86 <exit>
    printf("%s: chdir iputdir failed\n", s);
    35ca:	85a6                	mv	a1,s1
    35cc:	00004517          	auipc	a0,0x4
    35d0:	16c50513          	addi	a0,a0,364 # 7738 <malloc+0x1294>
    35d4:	00003097          	auipc	ra,0x3
    35d8:	e14080e7          	jalr	-492(ra) # 63e8 <printf>
    exit(1);
    35dc:	4505                	li	a0,1
    35de:	00003097          	auipc	ra,0x3
    35e2:	9a8080e7          	jalr	-1624(ra) # 5f86 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    35e6:	85a6                	mv	a1,s1
    35e8:	00004517          	auipc	a0,0x4
    35ec:	18050513          	addi	a0,a0,384 # 7768 <malloc+0x12c4>
    35f0:	00003097          	auipc	ra,0x3
    35f4:	df8080e7          	jalr	-520(ra) # 63e8 <printf>
    exit(1);
    35f8:	4505                	li	a0,1
    35fa:	00003097          	auipc	ra,0x3
    35fe:	98c080e7          	jalr	-1652(ra) # 5f86 <exit>
    printf("%s: chdir / failed\n", s);
    3602:	85a6                	mv	a1,s1
    3604:	00004517          	auipc	a0,0x4
    3608:	18c50513          	addi	a0,a0,396 # 7790 <malloc+0x12ec>
    360c:	00003097          	auipc	ra,0x3
    3610:	ddc080e7          	jalr	-548(ra) # 63e8 <printf>
    exit(1);
    3614:	4505                	li	a0,1
    3616:	00003097          	auipc	ra,0x3
    361a:	970080e7          	jalr	-1680(ra) # 5f86 <exit>

000000000000361e <exitiputtest>:
{
    361e:	7179                	addi	sp,sp,-48
    3620:	f406                	sd	ra,40(sp)
    3622:	f022                	sd	s0,32(sp)
    3624:	ec26                	sd	s1,24(sp)
    3626:	1800                	addi	s0,sp,48
    3628:	84aa                	mv	s1,a0
  pid = fork();
    362a:	00003097          	auipc	ra,0x3
    362e:	954080e7          	jalr	-1708(ra) # 5f7e <fork>
  if(pid < 0){
    3632:	04054663          	bltz	a0,367e <exitiputtest+0x60>
  if(pid == 0){
    3636:	ed45                	bnez	a0,36ee <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3638:	00004517          	auipc	a0,0x4
    363c:	0e050513          	addi	a0,a0,224 # 7718 <malloc+0x1274>
    3640:	00003097          	auipc	ra,0x3
    3644:	9ae080e7          	jalr	-1618(ra) # 5fee <mkdir>
    3648:	04054963          	bltz	a0,369a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    364c:	00004517          	auipc	a0,0x4
    3650:	0cc50513          	addi	a0,a0,204 # 7718 <malloc+0x1274>
    3654:	00003097          	auipc	ra,0x3
    3658:	9a2080e7          	jalr	-1630(ra) # 5ff6 <chdir>
    365c:	04054d63          	bltz	a0,36b6 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3660:	00004517          	auipc	a0,0x4
    3664:	0f850513          	addi	a0,a0,248 # 7758 <malloc+0x12b4>
    3668:	00003097          	auipc	ra,0x3
    366c:	96e080e7          	jalr	-1682(ra) # 5fd6 <unlink>
    3670:	06054163          	bltz	a0,36d2 <exitiputtest+0xb4>
    exit(0);
    3674:	4501                	li	a0,0
    3676:	00003097          	auipc	ra,0x3
    367a:	910080e7          	jalr	-1776(ra) # 5f86 <exit>
    printf("%s: fork failed\n", s);
    367e:	85a6                	mv	a1,s1
    3680:	00003517          	auipc	a0,0x3
    3684:	7e850513          	addi	a0,a0,2024 # 6e68 <malloc+0x9c4>
    3688:	00003097          	auipc	ra,0x3
    368c:	d60080e7          	jalr	-672(ra) # 63e8 <printf>
    exit(1);
    3690:	4505                	li	a0,1
    3692:	00003097          	auipc	ra,0x3
    3696:	8f4080e7          	jalr	-1804(ra) # 5f86 <exit>
      printf("%s: mkdir failed\n", s);
    369a:	85a6                	mv	a1,s1
    369c:	00004517          	auipc	a0,0x4
    36a0:	08450513          	addi	a0,a0,132 # 7720 <malloc+0x127c>
    36a4:	00003097          	auipc	ra,0x3
    36a8:	d44080e7          	jalr	-700(ra) # 63e8 <printf>
      exit(1);
    36ac:	4505                	li	a0,1
    36ae:	00003097          	auipc	ra,0x3
    36b2:	8d8080e7          	jalr	-1832(ra) # 5f86 <exit>
      printf("%s: child chdir failed\n", s);
    36b6:	85a6                	mv	a1,s1
    36b8:	00004517          	auipc	a0,0x4
    36bc:	0f050513          	addi	a0,a0,240 # 77a8 <malloc+0x1304>
    36c0:	00003097          	auipc	ra,0x3
    36c4:	d28080e7          	jalr	-728(ra) # 63e8 <printf>
      exit(1);
    36c8:	4505                	li	a0,1
    36ca:	00003097          	auipc	ra,0x3
    36ce:	8bc080e7          	jalr	-1860(ra) # 5f86 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    36d2:	85a6                	mv	a1,s1
    36d4:	00004517          	auipc	a0,0x4
    36d8:	09450513          	addi	a0,a0,148 # 7768 <malloc+0x12c4>
    36dc:	00003097          	auipc	ra,0x3
    36e0:	d0c080e7          	jalr	-756(ra) # 63e8 <printf>
      exit(1);
    36e4:	4505                	li	a0,1
    36e6:	00003097          	auipc	ra,0x3
    36ea:	8a0080e7          	jalr	-1888(ra) # 5f86 <exit>
  wait(&xstatus);
    36ee:	fdc40513          	addi	a0,s0,-36
    36f2:	00003097          	auipc	ra,0x3
    36f6:	89c080e7          	jalr	-1892(ra) # 5f8e <wait>
  exit(xstatus);
    36fa:	fdc42503          	lw	a0,-36(s0)
    36fe:	00003097          	auipc	ra,0x3
    3702:	888080e7          	jalr	-1912(ra) # 5f86 <exit>

0000000000003706 <dirtest>:
{
    3706:	1101                	addi	sp,sp,-32
    3708:	ec06                	sd	ra,24(sp)
    370a:	e822                	sd	s0,16(sp)
    370c:	e426                	sd	s1,8(sp)
    370e:	1000                	addi	s0,sp,32
    3710:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3712:	00004517          	auipc	a0,0x4
    3716:	0ae50513          	addi	a0,a0,174 # 77c0 <malloc+0x131c>
    371a:	00003097          	auipc	ra,0x3
    371e:	8d4080e7          	jalr	-1836(ra) # 5fee <mkdir>
    3722:	04054563          	bltz	a0,376c <dirtest+0x66>
  if(chdir("dir0") < 0){
    3726:	00004517          	auipc	a0,0x4
    372a:	09a50513          	addi	a0,a0,154 # 77c0 <malloc+0x131c>
    372e:	00003097          	auipc	ra,0x3
    3732:	8c8080e7          	jalr	-1848(ra) # 5ff6 <chdir>
    3736:	04054963          	bltz	a0,3788 <dirtest+0x82>
  if(chdir("..") < 0){
    373a:	00004517          	auipc	a0,0x4
    373e:	0a650513          	addi	a0,a0,166 # 77e0 <malloc+0x133c>
    3742:	00003097          	auipc	ra,0x3
    3746:	8b4080e7          	jalr	-1868(ra) # 5ff6 <chdir>
    374a:	04054d63          	bltz	a0,37a4 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    374e:	00004517          	auipc	a0,0x4
    3752:	07250513          	addi	a0,a0,114 # 77c0 <malloc+0x131c>
    3756:	00003097          	auipc	ra,0x3
    375a:	880080e7          	jalr	-1920(ra) # 5fd6 <unlink>
    375e:	06054163          	bltz	a0,37c0 <dirtest+0xba>
}
    3762:	60e2                	ld	ra,24(sp)
    3764:	6442                	ld	s0,16(sp)
    3766:	64a2                	ld	s1,8(sp)
    3768:	6105                	addi	sp,sp,32
    376a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    376c:	85a6                	mv	a1,s1
    376e:	00004517          	auipc	a0,0x4
    3772:	fb250513          	addi	a0,a0,-78 # 7720 <malloc+0x127c>
    3776:	00003097          	auipc	ra,0x3
    377a:	c72080e7          	jalr	-910(ra) # 63e8 <printf>
    exit(1);
    377e:	4505                	li	a0,1
    3780:	00003097          	auipc	ra,0x3
    3784:	806080e7          	jalr	-2042(ra) # 5f86 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3788:	85a6                	mv	a1,s1
    378a:	00004517          	auipc	a0,0x4
    378e:	03e50513          	addi	a0,a0,62 # 77c8 <malloc+0x1324>
    3792:	00003097          	auipc	ra,0x3
    3796:	c56080e7          	jalr	-938(ra) # 63e8 <printf>
    exit(1);
    379a:	4505                	li	a0,1
    379c:	00002097          	auipc	ra,0x2
    37a0:	7ea080e7          	jalr	2026(ra) # 5f86 <exit>
    printf("%s: chdir .. failed\n", s);
    37a4:	85a6                	mv	a1,s1
    37a6:	00004517          	auipc	a0,0x4
    37aa:	04250513          	addi	a0,a0,66 # 77e8 <malloc+0x1344>
    37ae:	00003097          	auipc	ra,0x3
    37b2:	c3a080e7          	jalr	-966(ra) # 63e8 <printf>
    exit(1);
    37b6:	4505                	li	a0,1
    37b8:	00002097          	auipc	ra,0x2
    37bc:	7ce080e7          	jalr	1998(ra) # 5f86 <exit>
    printf("%s: unlink dir0 failed\n", s);
    37c0:	85a6                	mv	a1,s1
    37c2:	00004517          	auipc	a0,0x4
    37c6:	03e50513          	addi	a0,a0,62 # 7800 <malloc+0x135c>
    37ca:	00003097          	auipc	ra,0x3
    37ce:	c1e080e7          	jalr	-994(ra) # 63e8 <printf>
    exit(1);
    37d2:	4505                	li	a0,1
    37d4:	00002097          	auipc	ra,0x2
    37d8:	7b2080e7          	jalr	1970(ra) # 5f86 <exit>

00000000000037dc <subdir>:
{
    37dc:	1101                	addi	sp,sp,-32
    37de:	ec06                	sd	ra,24(sp)
    37e0:	e822                	sd	s0,16(sp)
    37e2:	e426                	sd	s1,8(sp)
    37e4:	e04a                	sd	s2,0(sp)
    37e6:	1000                	addi	s0,sp,32
    37e8:	892a                	mv	s2,a0
  unlink("ff");
    37ea:	00004517          	auipc	a0,0x4
    37ee:	15e50513          	addi	a0,a0,350 # 7948 <malloc+0x14a4>
    37f2:	00002097          	auipc	ra,0x2
    37f6:	7e4080e7          	jalr	2020(ra) # 5fd6 <unlink>
  if(mkdir("dd") != 0){
    37fa:	00004517          	auipc	a0,0x4
    37fe:	01e50513          	addi	a0,a0,30 # 7818 <malloc+0x1374>
    3802:	00002097          	auipc	ra,0x2
    3806:	7ec080e7          	jalr	2028(ra) # 5fee <mkdir>
    380a:	38051663          	bnez	a0,3b96 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    380e:	20200593          	li	a1,514
    3812:	00004517          	auipc	a0,0x4
    3816:	02650513          	addi	a0,a0,38 # 7838 <malloc+0x1394>
    381a:	00002097          	auipc	ra,0x2
    381e:	7ac080e7          	jalr	1964(ra) # 5fc6 <open>
    3822:	84aa                	mv	s1,a0
  if(fd < 0){
    3824:	38054763          	bltz	a0,3bb2 <subdir+0x3d6>
  write(fd, "ff", 2);
    3828:	4609                	li	a2,2
    382a:	00004597          	auipc	a1,0x4
    382e:	11e58593          	addi	a1,a1,286 # 7948 <malloc+0x14a4>
    3832:	00002097          	auipc	ra,0x2
    3836:	774080e7          	jalr	1908(ra) # 5fa6 <write>
  close(fd);
    383a:	8526                	mv	a0,s1
    383c:	00002097          	auipc	ra,0x2
    3840:	772080e7          	jalr	1906(ra) # 5fae <close>
  if(unlink("dd") >= 0){
    3844:	00004517          	auipc	a0,0x4
    3848:	fd450513          	addi	a0,a0,-44 # 7818 <malloc+0x1374>
    384c:	00002097          	auipc	ra,0x2
    3850:	78a080e7          	jalr	1930(ra) # 5fd6 <unlink>
    3854:	36055d63          	bgez	a0,3bce <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3858:	00004517          	auipc	a0,0x4
    385c:	03850513          	addi	a0,a0,56 # 7890 <malloc+0x13ec>
    3860:	00002097          	auipc	ra,0x2
    3864:	78e080e7          	jalr	1934(ra) # 5fee <mkdir>
    3868:	38051163          	bnez	a0,3bea <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    386c:	20200593          	li	a1,514
    3870:	00004517          	auipc	a0,0x4
    3874:	04850513          	addi	a0,a0,72 # 78b8 <malloc+0x1414>
    3878:	00002097          	auipc	ra,0x2
    387c:	74e080e7          	jalr	1870(ra) # 5fc6 <open>
    3880:	84aa                	mv	s1,a0
  if(fd < 0){
    3882:	38054263          	bltz	a0,3c06 <subdir+0x42a>
  write(fd, "FF", 2);
    3886:	4609                	li	a2,2
    3888:	00004597          	auipc	a1,0x4
    388c:	06058593          	addi	a1,a1,96 # 78e8 <malloc+0x1444>
    3890:	00002097          	auipc	ra,0x2
    3894:	716080e7          	jalr	1814(ra) # 5fa6 <write>
  close(fd);
    3898:	8526                	mv	a0,s1
    389a:	00002097          	auipc	ra,0x2
    389e:	714080e7          	jalr	1812(ra) # 5fae <close>
  fd = open("dd/dd/../ff", 0);
    38a2:	4581                	li	a1,0
    38a4:	00004517          	auipc	a0,0x4
    38a8:	04c50513          	addi	a0,a0,76 # 78f0 <malloc+0x144c>
    38ac:	00002097          	auipc	ra,0x2
    38b0:	71a080e7          	jalr	1818(ra) # 5fc6 <open>
    38b4:	84aa                	mv	s1,a0
  if(fd < 0){
    38b6:	36054663          	bltz	a0,3c22 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    38ba:	660d                	lui	a2,0x3
    38bc:	0000a597          	auipc	a1,0xa
    38c0:	3bc58593          	addi	a1,a1,956 # dc78 <buf>
    38c4:	00002097          	auipc	ra,0x2
    38c8:	6da080e7          	jalr	1754(ra) # 5f9e <read>
  if(cc != 2 || buf[0] != 'f'){
    38cc:	4789                	li	a5,2
    38ce:	36f51863          	bne	a0,a5,3c3e <subdir+0x462>
    38d2:	0000a717          	auipc	a4,0xa
    38d6:	3a674703          	lbu	a4,934(a4) # dc78 <buf>
    38da:	06600793          	li	a5,102
    38de:	36f71063          	bne	a4,a5,3c3e <subdir+0x462>
  close(fd);
    38e2:	8526                	mv	a0,s1
    38e4:	00002097          	auipc	ra,0x2
    38e8:	6ca080e7          	jalr	1738(ra) # 5fae <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    38ec:	00004597          	auipc	a1,0x4
    38f0:	05458593          	addi	a1,a1,84 # 7940 <malloc+0x149c>
    38f4:	00004517          	auipc	a0,0x4
    38f8:	fc450513          	addi	a0,a0,-60 # 78b8 <malloc+0x1414>
    38fc:	00002097          	auipc	ra,0x2
    3900:	6ea080e7          	jalr	1770(ra) # 5fe6 <link>
    3904:	34051b63          	bnez	a0,3c5a <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3908:	00004517          	auipc	a0,0x4
    390c:	fb050513          	addi	a0,a0,-80 # 78b8 <malloc+0x1414>
    3910:	00002097          	auipc	ra,0x2
    3914:	6c6080e7          	jalr	1734(ra) # 5fd6 <unlink>
    3918:	34051f63          	bnez	a0,3c76 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    391c:	4581                	li	a1,0
    391e:	00004517          	auipc	a0,0x4
    3922:	f9a50513          	addi	a0,a0,-102 # 78b8 <malloc+0x1414>
    3926:	00002097          	auipc	ra,0x2
    392a:	6a0080e7          	jalr	1696(ra) # 5fc6 <open>
    392e:	36055263          	bgez	a0,3c92 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3932:	00004517          	auipc	a0,0x4
    3936:	ee650513          	addi	a0,a0,-282 # 7818 <malloc+0x1374>
    393a:	00002097          	auipc	ra,0x2
    393e:	6bc080e7          	jalr	1724(ra) # 5ff6 <chdir>
    3942:	36051663          	bnez	a0,3cae <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3946:	00004517          	auipc	a0,0x4
    394a:	09250513          	addi	a0,a0,146 # 79d8 <malloc+0x1534>
    394e:	00002097          	auipc	ra,0x2
    3952:	6a8080e7          	jalr	1704(ra) # 5ff6 <chdir>
    3956:	36051a63          	bnez	a0,3cca <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    395a:	00004517          	auipc	a0,0x4
    395e:	0ae50513          	addi	a0,a0,174 # 7a08 <malloc+0x1564>
    3962:	00002097          	auipc	ra,0x2
    3966:	694080e7          	jalr	1684(ra) # 5ff6 <chdir>
    396a:	36051e63          	bnez	a0,3ce6 <subdir+0x50a>
  if(chdir("./..") != 0){
    396e:	00004517          	auipc	a0,0x4
    3972:	0d250513          	addi	a0,a0,210 # 7a40 <malloc+0x159c>
    3976:	00002097          	auipc	ra,0x2
    397a:	680080e7          	jalr	1664(ra) # 5ff6 <chdir>
    397e:	38051263          	bnez	a0,3d02 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3982:	4581                	li	a1,0
    3984:	00004517          	auipc	a0,0x4
    3988:	fbc50513          	addi	a0,a0,-68 # 7940 <malloc+0x149c>
    398c:	00002097          	auipc	ra,0x2
    3990:	63a080e7          	jalr	1594(ra) # 5fc6 <open>
    3994:	84aa                	mv	s1,a0
  if(fd < 0){
    3996:	38054463          	bltz	a0,3d1e <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    399a:	660d                	lui	a2,0x3
    399c:	0000a597          	auipc	a1,0xa
    39a0:	2dc58593          	addi	a1,a1,732 # dc78 <buf>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	5fa080e7          	jalr	1530(ra) # 5f9e <read>
    39ac:	4789                	li	a5,2
    39ae:	38f51663          	bne	a0,a5,3d3a <subdir+0x55e>
  close(fd);
    39b2:	8526                	mv	a0,s1
    39b4:	00002097          	auipc	ra,0x2
    39b8:	5fa080e7          	jalr	1530(ra) # 5fae <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    39bc:	4581                	li	a1,0
    39be:	00004517          	auipc	a0,0x4
    39c2:	efa50513          	addi	a0,a0,-262 # 78b8 <malloc+0x1414>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	600080e7          	jalr	1536(ra) # 5fc6 <open>
    39ce:	38055463          	bgez	a0,3d56 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    39d2:	20200593          	li	a1,514
    39d6:	00004517          	auipc	a0,0x4
    39da:	0fa50513          	addi	a0,a0,250 # 7ad0 <malloc+0x162c>
    39de:	00002097          	auipc	ra,0x2
    39e2:	5e8080e7          	jalr	1512(ra) # 5fc6 <open>
    39e6:	38055663          	bgez	a0,3d72 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    39ea:	20200593          	li	a1,514
    39ee:	00004517          	auipc	a0,0x4
    39f2:	11250513          	addi	a0,a0,274 # 7b00 <malloc+0x165c>
    39f6:	00002097          	auipc	ra,0x2
    39fa:	5d0080e7          	jalr	1488(ra) # 5fc6 <open>
    39fe:	38055863          	bgez	a0,3d8e <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3a02:	20000593          	li	a1,512
    3a06:	00004517          	auipc	a0,0x4
    3a0a:	e1250513          	addi	a0,a0,-494 # 7818 <malloc+0x1374>
    3a0e:	00002097          	auipc	ra,0x2
    3a12:	5b8080e7          	jalr	1464(ra) # 5fc6 <open>
    3a16:	38055a63          	bgez	a0,3daa <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3a1a:	4589                	li	a1,2
    3a1c:	00004517          	auipc	a0,0x4
    3a20:	dfc50513          	addi	a0,a0,-516 # 7818 <malloc+0x1374>
    3a24:	00002097          	auipc	ra,0x2
    3a28:	5a2080e7          	jalr	1442(ra) # 5fc6 <open>
    3a2c:	38055d63          	bgez	a0,3dc6 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3a30:	4585                	li	a1,1
    3a32:	00004517          	auipc	a0,0x4
    3a36:	de650513          	addi	a0,a0,-538 # 7818 <malloc+0x1374>
    3a3a:	00002097          	auipc	ra,0x2
    3a3e:	58c080e7          	jalr	1420(ra) # 5fc6 <open>
    3a42:	3a055063          	bgez	a0,3de2 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3a46:	00004597          	auipc	a1,0x4
    3a4a:	14a58593          	addi	a1,a1,330 # 7b90 <malloc+0x16ec>
    3a4e:	00004517          	auipc	a0,0x4
    3a52:	08250513          	addi	a0,a0,130 # 7ad0 <malloc+0x162c>
    3a56:	00002097          	auipc	ra,0x2
    3a5a:	590080e7          	jalr	1424(ra) # 5fe6 <link>
    3a5e:	3a050063          	beqz	a0,3dfe <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3a62:	00004597          	auipc	a1,0x4
    3a66:	12e58593          	addi	a1,a1,302 # 7b90 <malloc+0x16ec>
    3a6a:	00004517          	auipc	a0,0x4
    3a6e:	09650513          	addi	a0,a0,150 # 7b00 <malloc+0x165c>
    3a72:	00002097          	auipc	ra,0x2
    3a76:	574080e7          	jalr	1396(ra) # 5fe6 <link>
    3a7a:	3a050063          	beqz	a0,3e1a <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3a7e:	00004597          	auipc	a1,0x4
    3a82:	ec258593          	addi	a1,a1,-318 # 7940 <malloc+0x149c>
    3a86:	00004517          	auipc	a0,0x4
    3a8a:	db250513          	addi	a0,a0,-590 # 7838 <malloc+0x1394>
    3a8e:	00002097          	auipc	ra,0x2
    3a92:	558080e7          	jalr	1368(ra) # 5fe6 <link>
    3a96:	3a050063          	beqz	a0,3e36 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3a9a:	00004517          	auipc	a0,0x4
    3a9e:	03650513          	addi	a0,a0,54 # 7ad0 <malloc+0x162c>
    3aa2:	00002097          	auipc	ra,0x2
    3aa6:	54c080e7          	jalr	1356(ra) # 5fee <mkdir>
    3aaa:	3a050463          	beqz	a0,3e52 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3aae:	00004517          	auipc	a0,0x4
    3ab2:	05250513          	addi	a0,a0,82 # 7b00 <malloc+0x165c>
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	538080e7          	jalr	1336(ra) # 5fee <mkdir>
    3abe:	3a050863          	beqz	a0,3e6e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	e7e50513          	addi	a0,a0,-386 # 7940 <malloc+0x149c>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	524080e7          	jalr	1316(ra) # 5fee <mkdir>
    3ad2:	3a050c63          	beqz	a0,3e8a <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3ad6:	00004517          	auipc	a0,0x4
    3ada:	02a50513          	addi	a0,a0,42 # 7b00 <malloc+0x165c>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	4f8080e7          	jalr	1272(ra) # 5fd6 <unlink>
    3ae6:	3c050063          	beqz	a0,3ea6 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3aea:	00004517          	auipc	a0,0x4
    3aee:	fe650513          	addi	a0,a0,-26 # 7ad0 <malloc+0x162c>
    3af2:	00002097          	auipc	ra,0x2
    3af6:	4e4080e7          	jalr	1252(ra) # 5fd6 <unlink>
    3afa:	3c050463          	beqz	a0,3ec2 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3afe:	00004517          	auipc	a0,0x4
    3b02:	d3a50513          	addi	a0,a0,-710 # 7838 <malloc+0x1394>
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	4f0080e7          	jalr	1264(ra) # 5ff6 <chdir>
    3b0e:	3c050863          	beqz	a0,3ede <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3b12:	00004517          	auipc	a0,0x4
    3b16:	1ce50513          	addi	a0,a0,462 # 7ce0 <malloc+0x183c>
    3b1a:	00002097          	auipc	ra,0x2
    3b1e:	4dc080e7          	jalr	1244(ra) # 5ff6 <chdir>
    3b22:	3c050c63          	beqz	a0,3efa <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3b26:	00004517          	auipc	a0,0x4
    3b2a:	e1a50513          	addi	a0,a0,-486 # 7940 <malloc+0x149c>
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	4a8080e7          	jalr	1192(ra) # 5fd6 <unlink>
    3b36:	3e051063          	bnez	a0,3f16 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3b3a:	00004517          	auipc	a0,0x4
    3b3e:	cfe50513          	addi	a0,a0,-770 # 7838 <malloc+0x1394>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	494080e7          	jalr	1172(ra) # 5fd6 <unlink>
    3b4a:	3e051463          	bnez	a0,3f32 <subdir+0x756>
  if(unlink("dd") == 0){
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	cca50513          	addi	a0,a0,-822 # 7818 <malloc+0x1374>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	480080e7          	jalr	1152(ra) # 5fd6 <unlink>
    3b5e:	3e050863          	beqz	a0,3f4e <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3b62:	00004517          	auipc	a0,0x4
    3b66:	1ee50513          	addi	a0,a0,494 # 7d50 <malloc+0x18ac>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	46c080e7          	jalr	1132(ra) # 5fd6 <unlink>
    3b72:	3e054c63          	bltz	a0,3f6a <subdir+0x78e>
  if(unlink("dd") < 0){
    3b76:	00004517          	auipc	a0,0x4
    3b7a:	ca250513          	addi	a0,a0,-862 # 7818 <malloc+0x1374>
    3b7e:	00002097          	auipc	ra,0x2
    3b82:	458080e7          	jalr	1112(ra) # 5fd6 <unlink>
    3b86:	40054063          	bltz	a0,3f86 <subdir+0x7aa>
}
    3b8a:	60e2                	ld	ra,24(sp)
    3b8c:	6442                	ld	s0,16(sp)
    3b8e:	64a2                	ld	s1,8(sp)
    3b90:	6902                	ld	s2,0(sp)
    3b92:	6105                	addi	sp,sp,32
    3b94:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3b96:	85ca                	mv	a1,s2
    3b98:	00004517          	auipc	a0,0x4
    3b9c:	c8850513          	addi	a0,a0,-888 # 7820 <malloc+0x137c>
    3ba0:	00003097          	auipc	ra,0x3
    3ba4:	848080e7          	jalr	-1976(ra) # 63e8 <printf>
    exit(1);
    3ba8:	4505                	li	a0,1
    3baa:	00002097          	auipc	ra,0x2
    3bae:	3dc080e7          	jalr	988(ra) # 5f86 <exit>
    printf("%s: create dd/ff failed\n", s);
    3bb2:	85ca                	mv	a1,s2
    3bb4:	00004517          	auipc	a0,0x4
    3bb8:	c8c50513          	addi	a0,a0,-884 # 7840 <malloc+0x139c>
    3bbc:	00003097          	auipc	ra,0x3
    3bc0:	82c080e7          	jalr	-2004(ra) # 63e8 <printf>
    exit(1);
    3bc4:	4505                	li	a0,1
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	3c0080e7          	jalr	960(ra) # 5f86 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3bce:	85ca                	mv	a1,s2
    3bd0:	00004517          	auipc	a0,0x4
    3bd4:	c9050513          	addi	a0,a0,-880 # 7860 <malloc+0x13bc>
    3bd8:	00003097          	auipc	ra,0x3
    3bdc:	810080e7          	jalr	-2032(ra) # 63e8 <printf>
    exit(1);
    3be0:	4505                	li	a0,1
    3be2:	00002097          	auipc	ra,0x2
    3be6:	3a4080e7          	jalr	932(ra) # 5f86 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3bea:	85ca                	mv	a1,s2
    3bec:	00004517          	auipc	a0,0x4
    3bf0:	cac50513          	addi	a0,a0,-852 # 7898 <malloc+0x13f4>
    3bf4:	00002097          	auipc	ra,0x2
    3bf8:	7f4080e7          	jalr	2036(ra) # 63e8 <printf>
    exit(1);
    3bfc:	4505                	li	a0,1
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	388080e7          	jalr	904(ra) # 5f86 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3c06:	85ca                	mv	a1,s2
    3c08:	00004517          	auipc	a0,0x4
    3c0c:	cc050513          	addi	a0,a0,-832 # 78c8 <malloc+0x1424>
    3c10:	00002097          	auipc	ra,0x2
    3c14:	7d8080e7          	jalr	2008(ra) # 63e8 <printf>
    exit(1);
    3c18:	4505                	li	a0,1
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	36c080e7          	jalr	876(ra) # 5f86 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3c22:	85ca                	mv	a1,s2
    3c24:	00004517          	auipc	a0,0x4
    3c28:	cdc50513          	addi	a0,a0,-804 # 7900 <malloc+0x145c>
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	7bc080e7          	jalr	1980(ra) # 63e8 <printf>
    exit(1);
    3c34:	4505                	li	a0,1
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	350080e7          	jalr	848(ra) # 5f86 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3c3e:	85ca                	mv	a1,s2
    3c40:	00004517          	auipc	a0,0x4
    3c44:	ce050513          	addi	a0,a0,-800 # 7920 <malloc+0x147c>
    3c48:	00002097          	auipc	ra,0x2
    3c4c:	7a0080e7          	jalr	1952(ra) # 63e8 <printf>
    exit(1);
    3c50:	4505                	li	a0,1
    3c52:	00002097          	auipc	ra,0x2
    3c56:	334080e7          	jalr	820(ra) # 5f86 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3c5a:	85ca                	mv	a1,s2
    3c5c:	00004517          	auipc	a0,0x4
    3c60:	cf450513          	addi	a0,a0,-780 # 7950 <malloc+0x14ac>
    3c64:	00002097          	auipc	ra,0x2
    3c68:	784080e7          	jalr	1924(ra) # 63e8 <printf>
    exit(1);
    3c6c:	4505                	li	a0,1
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	318080e7          	jalr	792(ra) # 5f86 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3c76:	85ca                	mv	a1,s2
    3c78:	00004517          	auipc	a0,0x4
    3c7c:	d0050513          	addi	a0,a0,-768 # 7978 <malloc+0x14d4>
    3c80:	00002097          	auipc	ra,0x2
    3c84:	768080e7          	jalr	1896(ra) # 63e8 <printf>
    exit(1);
    3c88:	4505                	li	a0,1
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	2fc080e7          	jalr	764(ra) # 5f86 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3c92:	85ca                	mv	a1,s2
    3c94:	00004517          	auipc	a0,0x4
    3c98:	d0450513          	addi	a0,a0,-764 # 7998 <malloc+0x14f4>
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	74c080e7          	jalr	1868(ra) # 63e8 <printf>
    exit(1);
    3ca4:	4505                	li	a0,1
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	2e0080e7          	jalr	736(ra) # 5f86 <exit>
    printf("%s: chdir dd failed\n", s);
    3cae:	85ca                	mv	a1,s2
    3cb0:	00004517          	auipc	a0,0x4
    3cb4:	d1050513          	addi	a0,a0,-752 # 79c0 <malloc+0x151c>
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	730080e7          	jalr	1840(ra) # 63e8 <printf>
    exit(1);
    3cc0:	4505                	li	a0,1
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	2c4080e7          	jalr	708(ra) # 5f86 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3cca:	85ca                	mv	a1,s2
    3ccc:	00004517          	auipc	a0,0x4
    3cd0:	d1c50513          	addi	a0,a0,-740 # 79e8 <malloc+0x1544>
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	714080e7          	jalr	1812(ra) # 63e8 <printf>
    exit(1);
    3cdc:	4505                	li	a0,1
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	2a8080e7          	jalr	680(ra) # 5f86 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    3ce6:	85ca                	mv	a1,s2
    3ce8:	00004517          	auipc	a0,0x4
    3cec:	d3050513          	addi	a0,a0,-720 # 7a18 <malloc+0x1574>
    3cf0:	00002097          	auipc	ra,0x2
    3cf4:	6f8080e7          	jalr	1784(ra) # 63e8 <printf>
    exit(1);
    3cf8:	4505                	li	a0,1
    3cfa:	00002097          	auipc	ra,0x2
    3cfe:	28c080e7          	jalr	652(ra) # 5f86 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3d02:	85ca                	mv	a1,s2
    3d04:	00004517          	auipc	a0,0x4
    3d08:	d4450513          	addi	a0,a0,-700 # 7a48 <malloc+0x15a4>
    3d0c:	00002097          	auipc	ra,0x2
    3d10:	6dc080e7          	jalr	1756(ra) # 63e8 <printf>
    exit(1);
    3d14:	4505                	li	a0,1
    3d16:	00002097          	auipc	ra,0x2
    3d1a:	270080e7          	jalr	624(ra) # 5f86 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3d1e:	85ca                	mv	a1,s2
    3d20:	00004517          	auipc	a0,0x4
    3d24:	d4050513          	addi	a0,a0,-704 # 7a60 <malloc+0x15bc>
    3d28:	00002097          	auipc	ra,0x2
    3d2c:	6c0080e7          	jalr	1728(ra) # 63e8 <printf>
    exit(1);
    3d30:	4505                	li	a0,1
    3d32:	00002097          	auipc	ra,0x2
    3d36:	254080e7          	jalr	596(ra) # 5f86 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3d3a:	85ca                	mv	a1,s2
    3d3c:	00004517          	auipc	a0,0x4
    3d40:	d4450513          	addi	a0,a0,-700 # 7a80 <malloc+0x15dc>
    3d44:	00002097          	auipc	ra,0x2
    3d48:	6a4080e7          	jalr	1700(ra) # 63e8 <printf>
    exit(1);
    3d4c:	4505                	li	a0,1
    3d4e:	00002097          	auipc	ra,0x2
    3d52:	238080e7          	jalr	568(ra) # 5f86 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3d56:	85ca                	mv	a1,s2
    3d58:	00004517          	auipc	a0,0x4
    3d5c:	d4850513          	addi	a0,a0,-696 # 7aa0 <malloc+0x15fc>
    3d60:	00002097          	auipc	ra,0x2
    3d64:	688080e7          	jalr	1672(ra) # 63e8 <printf>
    exit(1);
    3d68:	4505                	li	a0,1
    3d6a:	00002097          	auipc	ra,0x2
    3d6e:	21c080e7          	jalr	540(ra) # 5f86 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3d72:	85ca                	mv	a1,s2
    3d74:	00004517          	auipc	a0,0x4
    3d78:	d6c50513          	addi	a0,a0,-660 # 7ae0 <malloc+0x163c>
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	66c080e7          	jalr	1644(ra) # 63e8 <printf>
    exit(1);
    3d84:	4505                	li	a0,1
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	200080e7          	jalr	512(ra) # 5f86 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3d8e:	85ca                	mv	a1,s2
    3d90:	00004517          	auipc	a0,0x4
    3d94:	d8050513          	addi	a0,a0,-640 # 7b10 <malloc+0x166c>
    3d98:	00002097          	auipc	ra,0x2
    3d9c:	650080e7          	jalr	1616(ra) # 63e8 <printf>
    exit(1);
    3da0:	4505                	li	a0,1
    3da2:	00002097          	auipc	ra,0x2
    3da6:	1e4080e7          	jalr	484(ra) # 5f86 <exit>
    printf("%s: create dd succeeded!\n", s);
    3daa:	85ca                	mv	a1,s2
    3dac:	00004517          	auipc	a0,0x4
    3db0:	d8450513          	addi	a0,a0,-636 # 7b30 <malloc+0x168c>
    3db4:	00002097          	auipc	ra,0x2
    3db8:	634080e7          	jalr	1588(ra) # 63e8 <printf>
    exit(1);
    3dbc:	4505                	li	a0,1
    3dbe:	00002097          	auipc	ra,0x2
    3dc2:	1c8080e7          	jalr	456(ra) # 5f86 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3dc6:	85ca                	mv	a1,s2
    3dc8:	00004517          	auipc	a0,0x4
    3dcc:	d8850513          	addi	a0,a0,-632 # 7b50 <malloc+0x16ac>
    3dd0:	00002097          	auipc	ra,0x2
    3dd4:	618080e7          	jalr	1560(ra) # 63e8 <printf>
    exit(1);
    3dd8:	4505                	li	a0,1
    3dda:	00002097          	auipc	ra,0x2
    3dde:	1ac080e7          	jalr	428(ra) # 5f86 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3de2:	85ca                	mv	a1,s2
    3de4:	00004517          	auipc	a0,0x4
    3de8:	d8c50513          	addi	a0,a0,-628 # 7b70 <malloc+0x16cc>
    3dec:	00002097          	auipc	ra,0x2
    3df0:	5fc080e7          	jalr	1532(ra) # 63e8 <printf>
    exit(1);
    3df4:	4505                	li	a0,1
    3df6:	00002097          	auipc	ra,0x2
    3dfa:	190080e7          	jalr	400(ra) # 5f86 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3dfe:	85ca                	mv	a1,s2
    3e00:	00004517          	auipc	a0,0x4
    3e04:	da050513          	addi	a0,a0,-608 # 7ba0 <malloc+0x16fc>
    3e08:	00002097          	auipc	ra,0x2
    3e0c:	5e0080e7          	jalr	1504(ra) # 63e8 <printf>
    exit(1);
    3e10:	4505                	li	a0,1
    3e12:	00002097          	auipc	ra,0x2
    3e16:	174080e7          	jalr	372(ra) # 5f86 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3e1a:	85ca                	mv	a1,s2
    3e1c:	00004517          	auipc	a0,0x4
    3e20:	dac50513          	addi	a0,a0,-596 # 7bc8 <malloc+0x1724>
    3e24:	00002097          	auipc	ra,0x2
    3e28:	5c4080e7          	jalr	1476(ra) # 63e8 <printf>
    exit(1);
    3e2c:	4505                	li	a0,1
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	158080e7          	jalr	344(ra) # 5f86 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3e36:	85ca                	mv	a1,s2
    3e38:	00004517          	auipc	a0,0x4
    3e3c:	db850513          	addi	a0,a0,-584 # 7bf0 <malloc+0x174c>
    3e40:	00002097          	auipc	ra,0x2
    3e44:	5a8080e7          	jalr	1448(ra) # 63e8 <printf>
    exit(1);
    3e48:	4505                	li	a0,1
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	13c080e7          	jalr	316(ra) # 5f86 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3e52:	85ca                	mv	a1,s2
    3e54:	00004517          	auipc	a0,0x4
    3e58:	dc450513          	addi	a0,a0,-572 # 7c18 <malloc+0x1774>
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	58c080e7          	jalr	1420(ra) # 63e8 <printf>
    exit(1);
    3e64:	4505                	li	a0,1
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	120080e7          	jalr	288(ra) # 5f86 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3e6e:	85ca                	mv	a1,s2
    3e70:	00004517          	auipc	a0,0x4
    3e74:	dc850513          	addi	a0,a0,-568 # 7c38 <malloc+0x1794>
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	570080e7          	jalr	1392(ra) # 63e8 <printf>
    exit(1);
    3e80:	4505                	li	a0,1
    3e82:	00002097          	auipc	ra,0x2
    3e86:	104080e7          	jalr	260(ra) # 5f86 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3e8a:	85ca                	mv	a1,s2
    3e8c:	00004517          	auipc	a0,0x4
    3e90:	dcc50513          	addi	a0,a0,-564 # 7c58 <malloc+0x17b4>
    3e94:	00002097          	auipc	ra,0x2
    3e98:	554080e7          	jalr	1364(ra) # 63e8 <printf>
    exit(1);
    3e9c:	4505                	li	a0,1
    3e9e:	00002097          	auipc	ra,0x2
    3ea2:	0e8080e7          	jalr	232(ra) # 5f86 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3ea6:	85ca                	mv	a1,s2
    3ea8:	00004517          	auipc	a0,0x4
    3eac:	dd850513          	addi	a0,a0,-552 # 7c80 <malloc+0x17dc>
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	538080e7          	jalr	1336(ra) # 63e8 <printf>
    exit(1);
    3eb8:	4505                	li	a0,1
    3eba:	00002097          	auipc	ra,0x2
    3ebe:	0cc080e7          	jalr	204(ra) # 5f86 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3ec2:	85ca                	mv	a1,s2
    3ec4:	00004517          	auipc	a0,0x4
    3ec8:	ddc50513          	addi	a0,a0,-548 # 7ca0 <malloc+0x17fc>
    3ecc:	00002097          	auipc	ra,0x2
    3ed0:	51c080e7          	jalr	1308(ra) # 63e8 <printf>
    exit(1);
    3ed4:	4505                	li	a0,1
    3ed6:	00002097          	auipc	ra,0x2
    3eda:	0b0080e7          	jalr	176(ra) # 5f86 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3ede:	85ca                	mv	a1,s2
    3ee0:	00004517          	auipc	a0,0x4
    3ee4:	de050513          	addi	a0,a0,-544 # 7cc0 <malloc+0x181c>
    3ee8:	00002097          	auipc	ra,0x2
    3eec:	500080e7          	jalr	1280(ra) # 63e8 <printf>
    exit(1);
    3ef0:	4505                	li	a0,1
    3ef2:	00002097          	auipc	ra,0x2
    3ef6:	094080e7          	jalr	148(ra) # 5f86 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3efa:	85ca                	mv	a1,s2
    3efc:	00004517          	auipc	a0,0x4
    3f00:	dec50513          	addi	a0,a0,-532 # 7ce8 <malloc+0x1844>
    3f04:	00002097          	auipc	ra,0x2
    3f08:	4e4080e7          	jalr	1252(ra) # 63e8 <printf>
    exit(1);
    3f0c:	4505                	li	a0,1
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	078080e7          	jalr	120(ra) # 5f86 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3f16:	85ca                	mv	a1,s2
    3f18:	00004517          	auipc	a0,0x4
    3f1c:	a6050513          	addi	a0,a0,-1440 # 7978 <malloc+0x14d4>
    3f20:	00002097          	auipc	ra,0x2
    3f24:	4c8080e7          	jalr	1224(ra) # 63e8 <printf>
    exit(1);
    3f28:	4505                	li	a0,1
    3f2a:	00002097          	auipc	ra,0x2
    3f2e:	05c080e7          	jalr	92(ra) # 5f86 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3f32:	85ca                	mv	a1,s2
    3f34:	00004517          	auipc	a0,0x4
    3f38:	dd450513          	addi	a0,a0,-556 # 7d08 <malloc+0x1864>
    3f3c:	00002097          	auipc	ra,0x2
    3f40:	4ac080e7          	jalr	1196(ra) # 63e8 <printf>
    exit(1);
    3f44:	4505                	li	a0,1
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	040080e7          	jalr	64(ra) # 5f86 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3f4e:	85ca                	mv	a1,s2
    3f50:	00004517          	auipc	a0,0x4
    3f54:	dd850513          	addi	a0,a0,-552 # 7d28 <malloc+0x1884>
    3f58:	00002097          	auipc	ra,0x2
    3f5c:	490080e7          	jalr	1168(ra) # 63e8 <printf>
    exit(1);
    3f60:	4505                	li	a0,1
    3f62:	00002097          	auipc	ra,0x2
    3f66:	024080e7          	jalr	36(ra) # 5f86 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3f6a:	85ca                	mv	a1,s2
    3f6c:	00004517          	auipc	a0,0x4
    3f70:	dec50513          	addi	a0,a0,-532 # 7d58 <malloc+0x18b4>
    3f74:	00002097          	auipc	ra,0x2
    3f78:	474080e7          	jalr	1140(ra) # 63e8 <printf>
    exit(1);
    3f7c:	4505                	li	a0,1
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	008080e7          	jalr	8(ra) # 5f86 <exit>
    printf("%s: unlink dd failed\n", s);
    3f86:	85ca                	mv	a1,s2
    3f88:	00004517          	auipc	a0,0x4
    3f8c:	df050513          	addi	a0,a0,-528 # 7d78 <malloc+0x18d4>
    3f90:	00002097          	auipc	ra,0x2
    3f94:	458080e7          	jalr	1112(ra) # 63e8 <printf>
    exit(1);
    3f98:	4505                	li	a0,1
    3f9a:	00002097          	auipc	ra,0x2
    3f9e:	fec080e7          	jalr	-20(ra) # 5f86 <exit>

0000000000003fa2 <rmdot>:
{
    3fa2:	1101                	addi	sp,sp,-32
    3fa4:	ec06                	sd	ra,24(sp)
    3fa6:	e822                	sd	s0,16(sp)
    3fa8:	e426                	sd	s1,8(sp)
    3faa:	1000                	addi	s0,sp,32
    3fac:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3fae:	00004517          	auipc	a0,0x4
    3fb2:	de250513          	addi	a0,a0,-542 # 7d90 <malloc+0x18ec>
    3fb6:	00002097          	auipc	ra,0x2
    3fba:	038080e7          	jalr	56(ra) # 5fee <mkdir>
    3fbe:	e549                	bnez	a0,4048 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3fc0:	00004517          	auipc	a0,0x4
    3fc4:	dd050513          	addi	a0,a0,-560 # 7d90 <malloc+0x18ec>
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	02e080e7          	jalr	46(ra) # 5ff6 <chdir>
    3fd0:	e951                	bnez	a0,4064 <rmdot+0xc2>
  if(unlink(".") == 0){
    3fd2:	00003517          	auipc	a0,0x3
    3fd6:	cee50513          	addi	a0,a0,-786 # 6cc0 <malloc+0x81c>
    3fda:	00002097          	auipc	ra,0x2
    3fde:	ffc080e7          	jalr	-4(ra) # 5fd6 <unlink>
    3fe2:	cd59                	beqz	a0,4080 <rmdot+0xde>
  if(unlink("..") == 0){
    3fe4:	00003517          	auipc	a0,0x3
    3fe8:	7fc50513          	addi	a0,a0,2044 # 77e0 <malloc+0x133c>
    3fec:	00002097          	auipc	ra,0x2
    3ff0:	fea080e7          	jalr	-22(ra) # 5fd6 <unlink>
    3ff4:	c545                	beqz	a0,409c <rmdot+0xfa>
  if(chdir("/") != 0){
    3ff6:	00003517          	auipc	a0,0x3
    3ffa:	79250513          	addi	a0,a0,1938 # 7788 <malloc+0x12e4>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	ff8080e7          	jalr	-8(ra) # 5ff6 <chdir>
    4006:	e94d                	bnez	a0,40b8 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    4008:	00004517          	auipc	a0,0x4
    400c:	df050513          	addi	a0,a0,-528 # 7df8 <malloc+0x1954>
    4010:	00002097          	auipc	ra,0x2
    4014:	fc6080e7          	jalr	-58(ra) # 5fd6 <unlink>
    4018:	cd55                	beqz	a0,40d4 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    401a:	00004517          	auipc	a0,0x4
    401e:	e0650513          	addi	a0,a0,-506 # 7e20 <malloc+0x197c>
    4022:	00002097          	auipc	ra,0x2
    4026:	fb4080e7          	jalr	-76(ra) # 5fd6 <unlink>
    402a:	c179                	beqz	a0,40f0 <rmdot+0x14e>
  if(unlink("dots") != 0){
    402c:	00004517          	auipc	a0,0x4
    4030:	d6450513          	addi	a0,a0,-668 # 7d90 <malloc+0x18ec>
    4034:	00002097          	auipc	ra,0x2
    4038:	fa2080e7          	jalr	-94(ra) # 5fd6 <unlink>
    403c:	e961                	bnez	a0,410c <rmdot+0x16a>
}
    403e:	60e2                	ld	ra,24(sp)
    4040:	6442                	ld	s0,16(sp)
    4042:	64a2                	ld	s1,8(sp)
    4044:	6105                	addi	sp,sp,32
    4046:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    4048:	85a6                	mv	a1,s1
    404a:	00004517          	auipc	a0,0x4
    404e:	d4e50513          	addi	a0,a0,-690 # 7d98 <malloc+0x18f4>
    4052:	00002097          	auipc	ra,0x2
    4056:	396080e7          	jalr	918(ra) # 63e8 <printf>
    exit(1);
    405a:	4505                	li	a0,1
    405c:	00002097          	auipc	ra,0x2
    4060:	f2a080e7          	jalr	-214(ra) # 5f86 <exit>
    printf("%s: chdir dots failed\n", s);
    4064:	85a6                	mv	a1,s1
    4066:	00004517          	auipc	a0,0x4
    406a:	d4a50513          	addi	a0,a0,-694 # 7db0 <malloc+0x190c>
    406e:	00002097          	auipc	ra,0x2
    4072:	37a080e7          	jalr	890(ra) # 63e8 <printf>
    exit(1);
    4076:	4505                	li	a0,1
    4078:	00002097          	auipc	ra,0x2
    407c:	f0e080e7          	jalr	-242(ra) # 5f86 <exit>
    printf("%s: rm . worked!\n", s);
    4080:	85a6                	mv	a1,s1
    4082:	00004517          	auipc	a0,0x4
    4086:	d4650513          	addi	a0,a0,-698 # 7dc8 <malloc+0x1924>
    408a:	00002097          	auipc	ra,0x2
    408e:	35e080e7          	jalr	862(ra) # 63e8 <printf>
    exit(1);
    4092:	4505                	li	a0,1
    4094:	00002097          	auipc	ra,0x2
    4098:	ef2080e7          	jalr	-270(ra) # 5f86 <exit>
    printf("%s: rm .. worked!\n", s);
    409c:	85a6                	mv	a1,s1
    409e:	00004517          	auipc	a0,0x4
    40a2:	d4250513          	addi	a0,a0,-702 # 7de0 <malloc+0x193c>
    40a6:	00002097          	auipc	ra,0x2
    40aa:	342080e7          	jalr	834(ra) # 63e8 <printf>
    exit(1);
    40ae:	4505                	li	a0,1
    40b0:	00002097          	auipc	ra,0x2
    40b4:	ed6080e7          	jalr	-298(ra) # 5f86 <exit>
    printf("%s: chdir / failed\n", s);
    40b8:	85a6                	mv	a1,s1
    40ba:	00003517          	auipc	a0,0x3
    40be:	6d650513          	addi	a0,a0,1750 # 7790 <malloc+0x12ec>
    40c2:	00002097          	auipc	ra,0x2
    40c6:	326080e7          	jalr	806(ra) # 63e8 <printf>
    exit(1);
    40ca:	4505                	li	a0,1
    40cc:	00002097          	auipc	ra,0x2
    40d0:	eba080e7          	jalr	-326(ra) # 5f86 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    40d4:	85a6                	mv	a1,s1
    40d6:	00004517          	auipc	a0,0x4
    40da:	d2a50513          	addi	a0,a0,-726 # 7e00 <malloc+0x195c>
    40de:	00002097          	auipc	ra,0x2
    40e2:	30a080e7          	jalr	778(ra) # 63e8 <printf>
    exit(1);
    40e6:	4505                	li	a0,1
    40e8:	00002097          	auipc	ra,0x2
    40ec:	e9e080e7          	jalr	-354(ra) # 5f86 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    40f0:	85a6                	mv	a1,s1
    40f2:	00004517          	auipc	a0,0x4
    40f6:	d3650513          	addi	a0,a0,-714 # 7e28 <malloc+0x1984>
    40fa:	00002097          	auipc	ra,0x2
    40fe:	2ee080e7          	jalr	750(ra) # 63e8 <printf>
    exit(1);
    4102:	4505                	li	a0,1
    4104:	00002097          	auipc	ra,0x2
    4108:	e82080e7          	jalr	-382(ra) # 5f86 <exit>
    printf("%s: unlink dots failed!\n", s);
    410c:	85a6                	mv	a1,s1
    410e:	00004517          	auipc	a0,0x4
    4112:	d3a50513          	addi	a0,a0,-710 # 7e48 <malloc+0x19a4>
    4116:	00002097          	auipc	ra,0x2
    411a:	2d2080e7          	jalr	722(ra) # 63e8 <printf>
    exit(1);
    411e:	4505                	li	a0,1
    4120:	00002097          	auipc	ra,0x2
    4124:	e66080e7          	jalr	-410(ra) # 5f86 <exit>

0000000000004128 <dirfile>:
{
    4128:	1101                	addi	sp,sp,-32
    412a:	ec06                	sd	ra,24(sp)
    412c:	e822                	sd	s0,16(sp)
    412e:	e426                	sd	s1,8(sp)
    4130:	e04a                	sd	s2,0(sp)
    4132:	1000                	addi	s0,sp,32
    4134:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4136:	20000593          	li	a1,512
    413a:	00004517          	auipc	a0,0x4
    413e:	d2e50513          	addi	a0,a0,-722 # 7e68 <malloc+0x19c4>
    4142:	00002097          	auipc	ra,0x2
    4146:	e84080e7          	jalr	-380(ra) # 5fc6 <open>
  if(fd < 0){
    414a:	0e054d63          	bltz	a0,4244 <dirfile+0x11c>
  close(fd);
    414e:	00002097          	auipc	ra,0x2
    4152:	e60080e7          	jalr	-416(ra) # 5fae <close>
  if(chdir("dirfile") == 0){
    4156:	00004517          	auipc	a0,0x4
    415a:	d1250513          	addi	a0,a0,-750 # 7e68 <malloc+0x19c4>
    415e:	00002097          	auipc	ra,0x2
    4162:	e98080e7          	jalr	-360(ra) # 5ff6 <chdir>
    4166:	cd6d                	beqz	a0,4260 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4168:	4581                	li	a1,0
    416a:	00004517          	auipc	a0,0x4
    416e:	d4650513          	addi	a0,a0,-698 # 7eb0 <malloc+0x1a0c>
    4172:	00002097          	auipc	ra,0x2
    4176:	e54080e7          	jalr	-428(ra) # 5fc6 <open>
  if(fd >= 0){
    417a:	10055163          	bgez	a0,427c <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    417e:	20000593          	li	a1,512
    4182:	00004517          	auipc	a0,0x4
    4186:	d2e50513          	addi	a0,a0,-722 # 7eb0 <malloc+0x1a0c>
    418a:	00002097          	auipc	ra,0x2
    418e:	e3c080e7          	jalr	-452(ra) # 5fc6 <open>
  if(fd >= 0){
    4192:	10055363          	bgez	a0,4298 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4196:	00004517          	auipc	a0,0x4
    419a:	d1a50513          	addi	a0,a0,-742 # 7eb0 <malloc+0x1a0c>
    419e:	00002097          	auipc	ra,0x2
    41a2:	e50080e7          	jalr	-432(ra) # 5fee <mkdir>
    41a6:	10050763          	beqz	a0,42b4 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    41aa:	00004517          	auipc	a0,0x4
    41ae:	d0650513          	addi	a0,a0,-762 # 7eb0 <malloc+0x1a0c>
    41b2:	00002097          	auipc	ra,0x2
    41b6:	e24080e7          	jalr	-476(ra) # 5fd6 <unlink>
    41ba:	10050b63          	beqz	a0,42d0 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    41be:	00004597          	auipc	a1,0x4
    41c2:	cf258593          	addi	a1,a1,-782 # 7eb0 <malloc+0x1a0c>
    41c6:	00002517          	auipc	a0,0x2
    41ca:	5ea50513          	addi	a0,a0,1514 # 67b0 <malloc+0x30c>
    41ce:	00002097          	auipc	ra,0x2
    41d2:	e18080e7          	jalr	-488(ra) # 5fe6 <link>
    41d6:	10050b63          	beqz	a0,42ec <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    41da:	00004517          	auipc	a0,0x4
    41de:	c8e50513          	addi	a0,a0,-882 # 7e68 <malloc+0x19c4>
    41e2:	00002097          	auipc	ra,0x2
    41e6:	df4080e7          	jalr	-524(ra) # 5fd6 <unlink>
    41ea:	10051f63          	bnez	a0,4308 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    41ee:	4589                	li	a1,2
    41f0:	00003517          	auipc	a0,0x3
    41f4:	ad050513          	addi	a0,a0,-1328 # 6cc0 <malloc+0x81c>
    41f8:	00002097          	auipc	ra,0x2
    41fc:	dce080e7          	jalr	-562(ra) # 5fc6 <open>
  if(fd >= 0){
    4200:	12055263          	bgez	a0,4324 <dirfile+0x1fc>
  fd = open(".", 0);
    4204:	4581                	li	a1,0
    4206:	00003517          	auipc	a0,0x3
    420a:	aba50513          	addi	a0,a0,-1350 # 6cc0 <malloc+0x81c>
    420e:	00002097          	auipc	ra,0x2
    4212:	db8080e7          	jalr	-584(ra) # 5fc6 <open>
    4216:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    4218:	4605                	li	a2,1
    421a:	00002597          	auipc	a1,0x2
    421e:	42e58593          	addi	a1,a1,1070 # 6648 <malloc+0x1a4>
    4222:	00002097          	auipc	ra,0x2
    4226:	d84080e7          	jalr	-636(ra) # 5fa6 <write>
    422a:	10a04b63          	bgtz	a0,4340 <dirfile+0x218>
  close(fd);
    422e:	8526                	mv	a0,s1
    4230:	00002097          	auipc	ra,0x2
    4234:	d7e080e7          	jalr	-642(ra) # 5fae <close>
}
    4238:	60e2                	ld	ra,24(sp)
    423a:	6442                	ld	s0,16(sp)
    423c:	64a2                	ld	s1,8(sp)
    423e:	6902                	ld	s2,0(sp)
    4240:	6105                	addi	sp,sp,32
    4242:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4244:	85ca                	mv	a1,s2
    4246:	00004517          	auipc	a0,0x4
    424a:	c2a50513          	addi	a0,a0,-982 # 7e70 <malloc+0x19cc>
    424e:	00002097          	auipc	ra,0x2
    4252:	19a080e7          	jalr	410(ra) # 63e8 <printf>
    exit(1);
    4256:	4505                	li	a0,1
    4258:	00002097          	auipc	ra,0x2
    425c:	d2e080e7          	jalr	-722(ra) # 5f86 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4260:	85ca                	mv	a1,s2
    4262:	00004517          	auipc	a0,0x4
    4266:	c2e50513          	addi	a0,a0,-978 # 7e90 <malloc+0x19ec>
    426a:	00002097          	auipc	ra,0x2
    426e:	17e080e7          	jalr	382(ra) # 63e8 <printf>
    exit(1);
    4272:	4505                	li	a0,1
    4274:	00002097          	auipc	ra,0x2
    4278:	d12080e7          	jalr	-750(ra) # 5f86 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    427c:	85ca                	mv	a1,s2
    427e:	00004517          	auipc	a0,0x4
    4282:	c4250513          	addi	a0,a0,-958 # 7ec0 <malloc+0x1a1c>
    4286:	00002097          	auipc	ra,0x2
    428a:	162080e7          	jalr	354(ra) # 63e8 <printf>
    exit(1);
    428e:	4505                	li	a0,1
    4290:	00002097          	auipc	ra,0x2
    4294:	cf6080e7          	jalr	-778(ra) # 5f86 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4298:	85ca                	mv	a1,s2
    429a:	00004517          	auipc	a0,0x4
    429e:	c2650513          	addi	a0,a0,-986 # 7ec0 <malloc+0x1a1c>
    42a2:	00002097          	auipc	ra,0x2
    42a6:	146080e7          	jalr	326(ra) # 63e8 <printf>
    exit(1);
    42aa:	4505                	li	a0,1
    42ac:	00002097          	auipc	ra,0x2
    42b0:	cda080e7          	jalr	-806(ra) # 5f86 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    42b4:	85ca                	mv	a1,s2
    42b6:	00004517          	auipc	a0,0x4
    42ba:	c3250513          	addi	a0,a0,-974 # 7ee8 <malloc+0x1a44>
    42be:	00002097          	auipc	ra,0x2
    42c2:	12a080e7          	jalr	298(ra) # 63e8 <printf>
    exit(1);
    42c6:	4505                	li	a0,1
    42c8:	00002097          	auipc	ra,0x2
    42cc:	cbe080e7          	jalr	-834(ra) # 5f86 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    42d0:	85ca                	mv	a1,s2
    42d2:	00004517          	auipc	a0,0x4
    42d6:	c3e50513          	addi	a0,a0,-962 # 7f10 <malloc+0x1a6c>
    42da:	00002097          	auipc	ra,0x2
    42de:	10e080e7          	jalr	270(ra) # 63e8 <printf>
    exit(1);
    42e2:	4505                	li	a0,1
    42e4:	00002097          	auipc	ra,0x2
    42e8:	ca2080e7          	jalr	-862(ra) # 5f86 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    42ec:	85ca                	mv	a1,s2
    42ee:	00004517          	auipc	a0,0x4
    42f2:	c4a50513          	addi	a0,a0,-950 # 7f38 <malloc+0x1a94>
    42f6:	00002097          	auipc	ra,0x2
    42fa:	0f2080e7          	jalr	242(ra) # 63e8 <printf>
    exit(1);
    42fe:	4505                	li	a0,1
    4300:	00002097          	auipc	ra,0x2
    4304:	c86080e7          	jalr	-890(ra) # 5f86 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4308:	85ca                	mv	a1,s2
    430a:	00004517          	auipc	a0,0x4
    430e:	c5650513          	addi	a0,a0,-938 # 7f60 <malloc+0x1abc>
    4312:	00002097          	auipc	ra,0x2
    4316:	0d6080e7          	jalr	214(ra) # 63e8 <printf>
    exit(1);
    431a:	4505                	li	a0,1
    431c:	00002097          	auipc	ra,0x2
    4320:	c6a080e7          	jalr	-918(ra) # 5f86 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4324:	85ca                	mv	a1,s2
    4326:	00004517          	auipc	a0,0x4
    432a:	c5a50513          	addi	a0,a0,-934 # 7f80 <malloc+0x1adc>
    432e:	00002097          	auipc	ra,0x2
    4332:	0ba080e7          	jalr	186(ra) # 63e8 <printf>
    exit(1);
    4336:	4505                	li	a0,1
    4338:	00002097          	auipc	ra,0x2
    433c:	c4e080e7          	jalr	-946(ra) # 5f86 <exit>
    printf("%s: write . succeeded!\n", s);
    4340:	85ca                	mv	a1,s2
    4342:	00004517          	auipc	a0,0x4
    4346:	c6650513          	addi	a0,a0,-922 # 7fa8 <malloc+0x1b04>
    434a:	00002097          	auipc	ra,0x2
    434e:	09e080e7          	jalr	158(ra) # 63e8 <printf>
    exit(1);
    4352:	4505                	li	a0,1
    4354:	00002097          	auipc	ra,0x2
    4358:	c32080e7          	jalr	-974(ra) # 5f86 <exit>

000000000000435c <iref>:
{
    435c:	715d                	addi	sp,sp,-80
    435e:	e486                	sd	ra,72(sp)
    4360:	e0a2                	sd	s0,64(sp)
    4362:	fc26                	sd	s1,56(sp)
    4364:	f84a                	sd	s2,48(sp)
    4366:	f44e                	sd	s3,40(sp)
    4368:	f052                	sd	s4,32(sp)
    436a:	ec56                	sd	s5,24(sp)
    436c:	e85a                	sd	s6,16(sp)
    436e:	e45e                	sd	s7,8(sp)
    4370:	0880                	addi	s0,sp,80
    4372:	8baa                	mv	s7,a0
    4374:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4378:	00004a97          	auipc	s5,0x4
    437c:	c48a8a93          	addi	s5,s5,-952 # 7fc0 <malloc+0x1b1c>
    mkdir("");
    4380:	00003497          	auipc	s1,0x3
    4384:	74848493          	addi	s1,s1,1864 # 7ac8 <malloc+0x1624>
    link("README", "");
    4388:	00002b17          	auipc	s6,0x2
    438c:	428b0b13          	addi	s6,s6,1064 # 67b0 <malloc+0x30c>
    fd = open("", O_CREATE);
    4390:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    4394:	00004997          	auipc	s3,0x4
    4398:	b2498993          	addi	s3,s3,-1244 # 7eb8 <malloc+0x1a14>
    439c:	a891                	j	43f0 <iref+0x94>
      printf("%s: mkdir irefd failed\n", s);
    439e:	85de                	mv	a1,s7
    43a0:	00004517          	auipc	a0,0x4
    43a4:	c2850513          	addi	a0,a0,-984 # 7fc8 <malloc+0x1b24>
    43a8:	00002097          	auipc	ra,0x2
    43ac:	040080e7          	jalr	64(ra) # 63e8 <printf>
      exit(1);
    43b0:	4505                	li	a0,1
    43b2:	00002097          	auipc	ra,0x2
    43b6:	bd4080e7          	jalr	-1068(ra) # 5f86 <exit>
      printf("%s: chdir irefd failed\n", s);
    43ba:	85de                	mv	a1,s7
    43bc:	00004517          	auipc	a0,0x4
    43c0:	c2450513          	addi	a0,a0,-988 # 7fe0 <malloc+0x1b3c>
    43c4:	00002097          	auipc	ra,0x2
    43c8:	024080e7          	jalr	36(ra) # 63e8 <printf>
      exit(1);
    43cc:	4505                	li	a0,1
    43ce:	00002097          	auipc	ra,0x2
    43d2:	bb8080e7          	jalr	-1096(ra) # 5f86 <exit>
      close(fd);
    43d6:	00002097          	auipc	ra,0x2
    43da:	bd8080e7          	jalr	-1064(ra) # 5fae <close>
    43de:	a881                	j	442e <iref+0xd2>
    unlink("xx");
    43e0:	854e                	mv	a0,s3
    43e2:	00002097          	auipc	ra,0x2
    43e6:	bf4080e7          	jalr	-1036(ra) # 5fd6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    43ea:	397d                	addiw	s2,s2,-1
    43ec:	04090e63          	beqz	s2,4448 <iref+0xec>
    if(mkdir("irefd") != 0){
    43f0:	8556                	mv	a0,s5
    43f2:	00002097          	auipc	ra,0x2
    43f6:	bfc080e7          	jalr	-1028(ra) # 5fee <mkdir>
    43fa:	f155                	bnez	a0,439e <iref+0x42>
    if(chdir("irefd") != 0){
    43fc:	8556                	mv	a0,s5
    43fe:	00002097          	auipc	ra,0x2
    4402:	bf8080e7          	jalr	-1032(ra) # 5ff6 <chdir>
    4406:	f955                	bnez	a0,43ba <iref+0x5e>
    mkdir("");
    4408:	8526                	mv	a0,s1
    440a:	00002097          	auipc	ra,0x2
    440e:	be4080e7          	jalr	-1052(ra) # 5fee <mkdir>
    link("README", "");
    4412:	85a6                	mv	a1,s1
    4414:	855a                	mv	a0,s6
    4416:	00002097          	auipc	ra,0x2
    441a:	bd0080e7          	jalr	-1072(ra) # 5fe6 <link>
    fd = open("", O_CREATE);
    441e:	85d2                	mv	a1,s4
    4420:	8526                	mv	a0,s1
    4422:	00002097          	auipc	ra,0x2
    4426:	ba4080e7          	jalr	-1116(ra) # 5fc6 <open>
    if(fd >= 0)
    442a:	fa0556e3          	bgez	a0,43d6 <iref+0x7a>
    fd = open("xx", O_CREATE);
    442e:	85d2                	mv	a1,s4
    4430:	854e                	mv	a0,s3
    4432:	00002097          	auipc	ra,0x2
    4436:	b94080e7          	jalr	-1132(ra) # 5fc6 <open>
    if(fd >= 0)
    443a:	fa0543e3          	bltz	a0,43e0 <iref+0x84>
      close(fd);
    443e:	00002097          	auipc	ra,0x2
    4442:	b70080e7          	jalr	-1168(ra) # 5fae <close>
    4446:	bf69                	j	43e0 <iref+0x84>
    4448:	03300493          	li	s1,51
    chdir("..");
    444c:	00003997          	auipc	s3,0x3
    4450:	39498993          	addi	s3,s3,916 # 77e0 <malloc+0x133c>
    unlink("irefd");
    4454:	00004917          	auipc	s2,0x4
    4458:	b6c90913          	addi	s2,s2,-1172 # 7fc0 <malloc+0x1b1c>
    chdir("..");
    445c:	854e                	mv	a0,s3
    445e:	00002097          	auipc	ra,0x2
    4462:	b98080e7          	jalr	-1128(ra) # 5ff6 <chdir>
    unlink("irefd");
    4466:	854a                	mv	a0,s2
    4468:	00002097          	auipc	ra,0x2
    446c:	b6e080e7          	jalr	-1170(ra) # 5fd6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4470:	34fd                	addiw	s1,s1,-1
    4472:	f4ed                	bnez	s1,445c <iref+0x100>
  chdir("/");
    4474:	00003517          	auipc	a0,0x3
    4478:	31450513          	addi	a0,a0,788 # 7788 <malloc+0x12e4>
    447c:	00002097          	auipc	ra,0x2
    4480:	b7a080e7          	jalr	-1158(ra) # 5ff6 <chdir>
}
    4484:	60a6                	ld	ra,72(sp)
    4486:	6406                	ld	s0,64(sp)
    4488:	74e2                	ld	s1,56(sp)
    448a:	7942                	ld	s2,48(sp)
    448c:	79a2                	ld	s3,40(sp)
    448e:	7a02                	ld	s4,32(sp)
    4490:	6ae2                	ld	s5,24(sp)
    4492:	6b42                	ld	s6,16(sp)
    4494:	6ba2                	ld	s7,8(sp)
    4496:	6161                	addi	sp,sp,80
    4498:	8082                	ret

000000000000449a <openiputtest>:
{
    449a:	7179                	addi	sp,sp,-48
    449c:	f406                	sd	ra,40(sp)
    449e:	f022                	sd	s0,32(sp)
    44a0:	ec26                	sd	s1,24(sp)
    44a2:	1800                	addi	s0,sp,48
    44a4:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    44a6:	00004517          	auipc	a0,0x4
    44aa:	b5250513          	addi	a0,a0,-1198 # 7ff8 <malloc+0x1b54>
    44ae:	00002097          	auipc	ra,0x2
    44b2:	b40080e7          	jalr	-1216(ra) # 5fee <mkdir>
    44b6:	04054263          	bltz	a0,44fa <openiputtest+0x60>
  pid = fork();
    44ba:	00002097          	auipc	ra,0x2
    44be:	ac4080e7          	jalr	-1340(ra) # 5f7e <fork>
  if(pid < 0){
    44c2:	04054a63          	bltz	a0,4516 <openiputtest+0x7c>
  if(pid == 0){
    44c6:	e93d                	bnez	a0,453c <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    44c8:	4589                	li	a1,2
    44ca:	00004517          	auipc	a0,0x4
    44ce:	b2e50513          	addi	a0,a0,-1234 # 7ff8 <malloc+0x1b54>
    44d2:	00002097          	auipc	ra,0x2
    44d6:	af4080e7          	jalr	-1292(ra) # 5fc6 <open>
    if(fd >= 0){
    44da:	04054c63          	bltz	a0,4532 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    44de:	85a6                	mv	a1,s1
    44e0:	00004517          	auipc	a0,0x4
    44e4:	b3850513          	addi	a0,a0,-1224 # 8018 <malloc+0x1b74>
    44e8:	00002097          	auipc	ra,0x2
    44ec:	f00080e7          	jalr	-256(ra) # 63e8 <printf>
      exit(1);
    44f0:	4505                	li	a0,1
    44f2:	00002097          	auipc	ra,0x2
    44f6:	a94080e7          	jalr	-1388(ra) # 5f86 <exit>
    printf("%s: mkdir oidir failed\n", s);
    44fa:	85a6                	mv	a1,s1
    44fc:	00004517          	auipc	a0,0x4
    4500:	b0450513          	addi	a0,a0,-1276 # 8000 <malloc+0x1b5c>
    4504:	00002097          	auipc	ra,0x2
    4508:	ee4080e7          	jalr	-284(ra) # 63e8 <printf>
    exit(1);
    450c:	4505                	li	a0,1
    450e:	00002097          	auipc	ra,0x2
    4512:	a78080e7          	jalr	-1416(ra) # 5f86 <exit>
    printf("%s: fork failed\n", s);
    4516:	85a6                	mv	a1,s1
    4518:	00003517          	auipc	a0,0x3
    451c:	95050513          	addi	a0,a0,-1712 # 6e68 <malloc+0x9c4>
    4520:	00002097          	auipc	ra,0x2
    4524:	ec8080e7          	jalr	-312(ra) # 63e8 <printf>
    exit(1);
    4528:	4505                	li	a0,1
    452a:	00002097          	auipc	ra,0x2
    452e:	a5c080e7          	jalr	-1444(ra) # 5f86 <exit>
    exit(0);
    4532:	4501                	li	a0,0
    4534:	00002097          	auipc	ra,0x2
    4538:	a52080e7          	jalr	-1454(ra) # 5f86 <exit>
  sleep(1);
    453c:	4505                	li	a0,1
    453e:	00002097          	auipc	ra,0x2
    4542:	ad8080e7          	jalr	-1320(ra) # 6016 <sleep>
  if(unlink("oidir") != 0){
    4546:	00004517          	auipc	a0,0x4
    454a:	ab250513          	addi	a0,a0,-1358 # 7ff8 <malloc+0x1b54>
    454e:	00002097          	auipc	ra,0x2
    4552:	a88080e7          	jalr	-1400(ra) # 5fd6 <unlink>
    4556:	cd19                	beqz	a0,4574 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4558:	85a6                	mv	a1,s1
    455a:	00003517          	auipc	a0,0x3
    455e:	afe50513          	addi	a0,a0,-1282 # 7058 <malloc+0xbb4>
    4562:	00002097          	auipc	ra,0x2
    4566:	e86080e7          	jalr	-378(ra) # 63e8 <printf>
    exit(1);
    456a:	4505                	li	a0,1
    456c:	00002097          	auipc	ra,0x2
    4570:	a1a080e7          	jalr	-1510(ra) # 5f86 <exit>
  wait(&xstatus);
    4574:	fdc40513          	addi	a0,s0,-36
    4578:	00002097          	auipc	ra,0x2
    457c:	a16080e7          	jalr	-1514(ra) # 5f8e <wait>
  exit(xstatus);
    4580:	fdc42503          	lw	a0,-36(s0)
    4584:	00002097          	auipc	ra,0x2
    4588:	a02080e7          	jalr	-1534(ra) # 5f86 <exit>

000000000000458c <forkforkfork>:
{
    458c:	1101                	addi	sp,sp,-32
    458e:	ec06                	sd	ra,24(sp)
    4590:	e822                	sd	s0,16(sp)
    4592:	e426                	sd	s1,8(sp)
    4594:	1000                	addi	s0,sp,32
    4596:	84aa                	mv	s1,a0
  unlink("stopforking");
    4598:	00004517          	auipc	a0,0x4
    459c:	aa850513          	addi	a0,a0,-1368 # 8040 <malloc+0x1b9c>
    45a0:	00002097          	auipc	ra,0x2
    45a4:	a36080e7          	jalr	-1482(ra) # 5fd6 <unlink>
  int pid = fork();
    45a8:	00002097          	auipc	ra,0x2
    45ac:	9d6080e7          	jalr	-1578(ra) # 5f7e <fork>
  if(pid < 0){
    45b0:	04054563          	bltz	a0,45fa <forkforkfork+0x6e>
  if(pid == 0){
    45b4:	c12d                	beqz	a0,4616 <forkforkfork+0x8a>
  sleep(20); // two seconds
    45b6:	4551                	li	a0,20
    45b8:	00002097          	auipc	ra,0x2
    45bc:	a5e080e7          	jalr	-1442(ra) # 6016 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    45c0:	20200593          	li	a1,514
    45c4:	00004517          	auipc	a0,0x4
    45c8:	a7c50513          	addi	a0,a0,-1412 # 8040 <malloc+0x1b9c>
    45cc:	00002097          	auipc	ra,0x2
    45d0:	9fa080e7          	jalr	-1542(ra) # 5fc6 <open>
    45d4:	00002097          	auipc	ra,0x2
    45d8:	9da080e7          	jalr	-1574(ra) # 5fae <close>
  wait(0);
    45dc:	4501                	li	a0,0
    45de:	00002097          	auipc	ra,0x2
    45e2:	9b0080e7          	jalr	-1616(ra) # 5f8e <wait>
  sleep(10); // one second
    45e6:	4529                	li	a0,10
    45e8:	00002097          	auipc	ra,0x2
    45ec:	a2e080e7          	jalr	-1490(ra) # 6016 <sleep>
}
    45f0:	60e2                	ld	ra,24(sp)
    45f2:	6442                	ld	s0,16(sp)
    45f4:	64a2                	ld	s1,8(sp)
    45f6:	6105                	addi	sp,sp,32
    45f8:	8082                	ret
    printf("%s: fork failed", s);
    45fa:	85a6                	mv	a1,s1
    45fc:	00003517          	auipc	a0,0x3
    4600:	a2c50513          	addi	a0,a0,-1492 # 7028 <malloc+0xb84>
    4604:	00002097          	auipc	ra,0x2
    4608:	de4080e7          	jalr	-540(ra) # 63e8 <printf>
    exit(1);
    460c:	4505                	li	a0,1
    460e:	00002097          	auipc	ra,0x2
    4612:	978080e7          	jalr	-1672(ra) # 5f86 <exit>
      int fd = open("stopforking", 0);
    4616:	00004497          	auipc	s1,0x4
    461a:	a2a48493          	addi	s1,s1,-1494 # 8040 <malloc+0x1b9c>
    461e:	4581                	li	a1,0
    4620:	8526                	mv	a0,s1
    4622:	00002097          	auipc	ra,0x2
    4626:	9a4080e7          	jalr	-1628(ra) # 5fc6 <open>
      if(fd >= 0){
    462a:	02055763          	bgez	a0,4658 <forkforkfork+0xcc>
      if(fork() < 0){
    462e:	00002097          	auipc	ra,0x2
    4632:	950080e7          	jalr	-1712(ra) # 5f7e <fork>
    4636:	fe0554e3          	bgez	a0,461e <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    463a:	20200593          	li	a1,514
    463e:	00004517          	auipc	a0,0x4
    4642:	a0250513          	addi	a0,a0,-1534 # 8040 <malloc+0x1b9c>
    4646:	00002097          	auipc	ra,0x2
    464a:	980080e7          	jalr	-1664(ra) # 5fc6 <open>
    464e:	00002097          	auipc	ra,0x2
    4652:	960080e7          	jalr	-1696(ra) # 5fae <close>
    4656:	b7e1                	j	461e <forkforkfork+0x92>
        exit(0);
    4658:	4501                	li	a0,0
    465a:	00002097          	auipc	ra,0x2
    465e:	92c080e7          	jalr	-1748(ra) # 5f86 <exit>

0000000000004662 <killstatus>:
{
    4662:	715d                	addi	sp,sp,-80
    4664:	e486                	sd	ra,72(sp)
    4666:	e0a2                	sd	s0,64(sp)
    4668:	fc26                	sd	s1,56(sp)
    466a:	f84a                	sd	s2,48(sp)
    466c:	f44e                	sd	s3,40(sp)
    466e:	f052                	sd	s4,32(sp)
    4670:	ec56                	sd	s5,24(sp)
    4672:	e85a                	sd	s6,16(sp)
    4674:	0880                	addi	s0,sp,80
    4676:	8b2a                	mv	s6,a0
    4678:	06400913          	li	s2,100
    sleep(1);
    467c:	4a85                	li	s5,1
    wait(&xst);
    467e:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    4682:	59fd                	li	s3,-1
    int pid1 = fork();
    4684:	00002097          	auipc	ra,0x2
    4688:	8fa080e7          	jalr	-1798(ra) # 5f7e <fork>
    468c:	84aa                	mv	s1,a0
    if(pid1 < 0){
    468e:	02054e63          	bltz	a0,46ca <killstatus+0x68>
    if(pid1 == 0){
    4692:	c931                	beqz	a0,46e6 <killstatus+0x84>
    sleep(1);
    4694:	8556                	mv	a0,s5
    4696:	00002097          	auipc	ra,0x2
    469a:	980080e7          	jalr	-1664(ra) # 6016 <sleep>
    kill(pid1);
    469e:	8526                	mv	a0,s1
    46a0:	00002097          	auipc	ra,0x2
    46a4:	916080e7          	jalr	-1770(ra) # 5fb6 <kill>
    wait(&xst);
    46a8:	8552                	mv	a0,s4
    46aa:	00002097          	auipc	ra,0x2
    46ae:	8e4080e7          	jalr	-1820(ra) # 5f8e <wait>
    if(xst != -1) {
    46b2:	fbc42783          	lw	a5,-68(s0)
    46b6:	03379d63          	bne	a5,s3,46f0 <killstatus+0x8e>
  for(int i = 0; i < 100; i++){
    46ba:	397d                	addiw	s2,s2,-1
    46bc:	fc0914e3          	bnez	s2,4684 <killstatus+0x22>
  exit(0);
    46c0:	4501                	li	a0,0
    46c2:	00002097          	auipc	ra,0x2
    46c6:	8c4080e7          	jalr	-1852(ra) # 5f86 <exit>
      printf("%s: fork failed\n", s);
    46ca:	85da                	mv	a1,s6
    46cc:	00002517          	auipc	a0,0x2
    46d0:	79c50513          	addi	a0,a0,1948 # 6e68 <malloc+0x9c4>
    46d4:	00002097          	auipc	ra,0x2
    46d8:	d14080e7          	jalr	-748(ra) # 63e8 <printf>
      exit(1);
    46dc:	4505                	li	a0,1
    46de:	00002097          	auipc	ra,0x2
    46e2:	8a8080e7          	jalr	-1880(ra) # 5f86 <exit>
        getpid();
    46e6:	00002097          	auipc	ra,0x2
    46ea:	920080e7          	jalr	-1760(ra) # 6006 <getpid>
      while(1) {
    46ee:	bfe5                	j	46e6 <killstatus+0x84>
       printf("%s: status should be -1\n", s);
    46f0:	85da                	mv	a1,s6
    46f2:	00004517          	auipc	a0,0x4
    46f6:	95e50513          	addi	a0,a0,-1698 # 8050 <malloc+0x1bac>
    46fa:	00002097          	auipc	ra,0x2
    46fe:	cee080e7          	jalr	-786(ra) # 63e8 <printf>
       exit(1);
    4702:	4505                	li	a0,1
    4704:	00002097          	auipc	ra,0x2
    4708:	882080e7          	jalr	-1918(ra) # 5f86 <exit>

000000000000470c <preempt>:
{
    470c:	7139                	addi	sp,sp,-64
    470e:	fc06                	sd	ra,56(sp)
    4710:	f822                	sd	s0,48(sp)
    4712:	f426                	sd	s1,40(sp)
    4714:	f04a                	sd	s2,32(sp)
    4716:	ec4e                	sd	s3,24(sp)
    4718:	e852                	sd	s4,16(sp)
    471a:	0080                	addi	s0,sp,64
    471c:	892a                	mv	s2,a0
  pid1 = fork();
    471e:	00002097          	auipc	ra,0x2
    4722:	860080e7          	jalr	-1952(ra) # 5f7e <fork>
  if(pid1 < 0) {
    4726:	00054563          	bltz	a0,4730 <preempt+0x24>
    472a:	84aa                	mv	s1,a0
  if(pid1 == 0)
    472c:	e105                	bnez	a0,474c <preempt+0x40>
    for(;;)
    472e:	a001                	j	472e <preempt+0x22>
    printf("%s: fork failed", s);
    4730:	85ca                	mv	a1,s2
    4732:	00003517          	auipc	a0,0x3
    4736:	8f650513          	addi	a0,a0,-1802 # 7028 <malloc+0xb84>
    473a:	00002097          	auipc	ra,0x2
    473e:	cae080e7          	jalr	-850(ra) # 63e8 <printf>
    exit(1);
    4742:	4505                	li	a0,1
    4744:	00002097          	auipc	ra,0x2
    4748:	842080e7          	jalr	-1982(ra) # 5f86 <exit>
  pid2 = fork();
    474c:	00002097          	auipc	ra,0x2
    4750:	832080e7          	jalr	-1998(ra) # 5f7e <fork>
    4754:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4756:	00054463          	bltz	a0,475e <preempt+0x52>
  if(pid2 == 0)
    475a:	e105                	bnez	a0,477a <preempt+0x6e>
    for(;;)
    475c:	a001                	j	475c <preempt+0x50>
    printf("%s: fork failed\n", s);
    475e:	85ca                	mv	a1,s2
    4760:	00002517          	auipc	a0,0x2
    4764:	70850513          	addi	a0,a0,1800 # 6e68 <malloc+0x9c4>
    4768:	00002097          	auipc	ra,0x2
    476c:	c80080e7          	jalr	-896(ra) # 63e8 <printf>
    exit(1);
    4770:	4505                	li	a0,1
    4772:	00002097          	auipc	ra,0x2
    4776:	814080e7          	jalr	-2028(ra) # 5f86 <exit>
  pipe(pfds);
    477a:	fc840513          	addi	a0,s0,-56
    477e:	00002097          	auipc	ra,0x2
    4782:	818080e7          	jalr	-2024(ra) # 5f96 <pipe>
  pid3 = fork();
    4786:	00001097          	auipc	ra,0x1
    478a:	7f8080e7          	jalr	2040(ra) # 5f7e <fork>
    478e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4790:	02054e63          	bltz	a0,47cc <preempt+0xc0>
  if(pid3 == 0){
    4794:	e525                	bnez	a0,47fc <preempt+0xf0>
    close(pfds[0]);
    4796:	fc842503          	lw	a0,-56(s0)
    479a:	00002097          	auipc	ra,0x2
    479e:	814080e7          	jalr	-2028(ra) # 5fae <close>
    if(write(pfds[1], "x", 1) != 1)
    47a2:	4605                	li	a2,1
    47a4:	00002597          	auipc	a1,0x2
    47a8:	ea458593          	addi	a1,a1,-348 # 6648 <malloc+0x1a4>
    47ac:	fcc42503          	lw	a0,-52(s0)
    47b0:	00001097          	auipc	ra,0x1
    47b4:	7f6080e7          	jalr	2038(ra) # 5fa6 <write>
    47b8:	4785                	li	a5,1
    47ba:	02f51763          	bne	a0,a5,47e8 <preempt+0xdc>
    close(pfds[1]);
    47be:	fcc42503          	lw	a0,-52(s0)
    47c2:	00001097          	auipc	ra,0x1
    47c6:	7ec080e7          	jalr	2028(ra) # 5fae <close>
    for(;;)
    47ca:	a001                	j	47ca <preempt+0xbe>
     printf("%s: fork failed\n", s);
    47cc:	85ca                	mv	a1,s2
    47ce:	00002517          	auipc	a0,0x2
    47d2:	69a50513          	addi	a0,a0,1690 # 6e68 <malloc+0x9c4>
    47d6:	00002097          	auipc	ra,0x2
    47da:	c12080e7          	jalr	-1006(ra) # 63e8 <printf>
     exit(1);
    47de:	4505                	li	a0,1
    47e0:	00001097          	auipc	ra,0x1
    47e4:	7a6080e7          	jalr	1958(ra) # 5f86 <exit>
      printf("%s: preempt write error", s);
    47e8:	85ca                	mv	a1,s2
    47ea:	00004517          	auipc	a0,0x4
    47ee:	88650513          	addi	a0,a0,-1914 # 8070 <malloc+0x1bcc>
    47f2:	00002097          	auipc	ra,0x2
    47f6:	bf6080e7          	jalr	-1034(ra) # 63e8 <printf>
    47fa:	b7d1                	j	47be <preempt+0xb2>
  close(pfds[1]);
    47fc:	fcc42503          	lw	a0,-52(s0)
    4800:	00001097          	auipc	ra,0x1
    4804:	7ae080e7          	jalr	1966(ra) # 5fae <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4808:	660d                	lui	a2,0x3
    480a:	00009597          	auipc	a1,0x9
    480e:	46e58593          	addi	a1,a1,1134 # dc78 <buf>
    4812:	fc842503          	lw	a0,-56(s0)
    4816:	00001097          	auipc	ra,0x1
    481a:	788080e7          	jalr	1928(ra) # 5f9e <read>
    481e:	4785                	li	a5,1
    4820:	02f50363          	beq	a0,a5,4846 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4824:	85ca                	mv	a1,s2
    4826:	00004517          	auipc	a0,0x4
    482a:	86250513          	addi	a0,a0,-1950 # 8088 <malloc+0x1be4>
    482e:	00002097          	auipc	ra,0x2
    4832:	bba080e7          	jalr	-1094(ra) # 63e8 <printf>
}
    4836:	70e2                	ld	ra,56(sp)
    4838:	7442                	ld	s0,48(sp)
    483a:	74a2                	ld	s1,40(sp)
    483c:	7902                	ld	s2,32(sp)
    483e:	69e2                	ld	s3,24(sp)
    4840:	6a42                	ld	s4,16(sp)
    4842:	6121                	addi	sp,sp,64
    4844:	8082                	ret
  close(pfds[0]);
    4846:	fc842503          	lw	a0,-56(s0)
    484a:	00001097          	auipc	ra,0x1
    484e:	764080e7          	jalr	1892(ra) # 5fae <close>
  printf("kill... ");
    4852:	00004517          	auipc	a0,0x4
    4856:	84e50513          	addi	a0,a0,-1970 # 80a0 <malloc+0x1bfc>
    485a:	00002097          	auipc	ra,0x2
    485e:	b8e080e7          	jalr	-1138(ra) # 63e8 <printf>
  kill(pid1);
    4862:	8526                	mv	a0,s1
    4864:	00001097          	auipc	ra,0x1
    4868:	752080e7          	jalr	1874(ra) # 5fb6 <kill>
  kill(pid2);
    486c:	854e                	mv	a0,s3
    486e:	00001097          	auipc	ra,0x1
    4872:	748080e7          	jalr	1864(ra) # 5fb6 <kill>
  kill(pid3);
    4876:	8552                	mv	a0,s4
    4878:	00001097          	auipc	ra,0x1
    487c:	73e080e7          	jalr	1854(ra) # 5fb6 <kill>
  printf("wait... ");
    4880:	00004517          	auipc	a0,0x4
    4884:	83050513          	addi	a0,a0,-2000 # 80b0 <malloc+0x1c0c>
    4888:	00002097          	auipc	ra,0x2
    488c:	b60080e7          	jalr	-1184(ra) # 63e8 <printf>
  wait(0);
    4890:	4501                	li	a0,0
    4892:	00001097          	auipc	ra,0x1
    4896:	6fc080e7          	jalr	1788(ra) # 5f8e <wait>
  wait(0);
    489a:	4501                	li	a0,0
    489c:	00001097          	auipc	ra,0x1
    48a0:	6f2080e7          	jalr	1778(ra) # 5f8e <wait>
  wait(0);
    48a4:	4501                	li	a0,0
    48a6:	00001097          	auipc	ra,0x1
    48aa:	6e8080e7          	jalr	1768(ra) # 5f8e <wait>
    48ae:	b761                	j	4836 <preempt+0x12a>

00000000000048b0 <reparent>:
{
    48b0:	7179                	addi	sp,sp,-48
    48b2:	f406                	sd	ra,40(sp)
    48b4:	f022                	sd	s0,32(sp)
    48b6:	ec26                	sd	s1,24(sp)
    48b8:	e84a                	sd	s2,16(sp)
    48ba:	e44e                	sd	s3,8(sp)
    48bc:	e052                	sd	s4,0(sp)
    48be:	1800                	addi	s0,sp,48
    48c0:	89aa                	mv	s3,a0
  int master_pid = getpid();
    48c2:	00001097          	auipc	ra,0x1
    48c6:	744080e7          	jalr	1860(ra) # 6006 <getpid>
    48ca:	8a2a                	mv	s4,a0
    48cc:	0c800913          	li	s2,200
    int pid = fork();
    48d0:	00001097          	auipc	ra,0x1
    48d4:	6ae080e7          	jalr	1710(ra) # 5f7e <fork>
    48d8:	84aa                	mv	s1,a0
    if(pid < 0){
    48da:	02054263          	bltz	a0,48fe <reparent+0x4e>
    if(pid){
    48de:	cd21                	beqz	a0,4936 <reparent+0x86>
      if(wait(0) != pid){
    48e0:	4501                	li	a0,0
    48e2:	00001097          	auipc	ra,0x1
    48e6:	6ac080e7          	jalr	1708(ra) # 5f8e <wait>
    48ea:	02951863          	bne	a0,s1,491a <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    48ee:	397d                	addiw	s2,s2,-1
    48f0:	fe0910e3          	bnez	s2,48d0 <reparent+0x20>
  exit(0);
    48f4:	4501                	li	a0,0
    48f6:	00001097          	auipc	ra,0x1
    48fa:	690080e7          	jalr	1680(ra) # 5f86 <exit>
      printf("%s: fork failed\n", s);
    48fe:	85ce                	mv	a1,s3
    4900:	00002517          	auipc	a0,0x2
    4904:	56850513          	addi	a0,a0,1384 # 6e68 <malloc+0x9c4>
    4908:	00002097          	auipc	ra,0x2
    490c:	ae0080e7          	jalr	-1312(ra) # 63e8 <printf>
      exit(1);
    4910:	4505                	li	a0,1
    4912:	00001097          	auipc	ra,0x1
    4916:	674080e7          	jalr	1652(ra) # 5f86 <exit>
        printf("%s: wait wrong pid\n", s);
    491a:	85ce                	mv	a1,s3
    491c:	00002517          	auipc	a0,0x2
    4920:	6d450513          	addi	a0,a0,1748 # 6ff0 <malloc+0xb4c>
    4924:	00002097          	auipc	ra,0x2
    4928:	ac4080e7          	jalr	-1340(ra) # 63e8 <printf>
        exit(1);
    492c:	4505                	li	a0,1
    492e:	00001097          	auipc	ra,0x1
    4932:	658080e7          	jalr	1624(ra) # 5f86 <exit>
      int pid2 = fork();
    4936:	00001097          	auipc	ra,0x1
    493a:	648080e7          	jalr	1608(ra) # 5f7e <fork>
      if(pid2 < 0){
    493e:	00054763          	bltz	a0,494c <reparent+0x9c>
      exit(0);
    4942:	4501                	li	a0,0
    4944:	00001097          	auipc	ra,0x1
    4948:	642080e7          	jalr	1602(ra) # 5f86 <exit>
        kill(master_pid);
    494c:	8552                	mv	a0,s4
    494e:	00001097          	auipc	ra,0x1
    4952:	668080e7          	jalr	1640(ra) # 5fb6 <kill>
        exit(1);
    4956:	4505                	li	a0,1
    4958:	00001097          	auipc	ra,0x1
    495c:	62e080e7          	jalr	1582(ra) # 5f86 <exit>

0000000000004960 <sbrkfail>:
{
    4960:	7175                	addi	sp,sp,-144
    4962:	e506                	sd	ra,136(sp)
    4964:	e122                	sd	s0,128(sp)
    4966:	fca6                	sd	s1,120(sp)
    4968:	f8ca                	sd	s2,112(sp)
    496a:	f4ce                	sd	s3,104(sp)
    496c:	f0d2                	sd	s4,96(sp)
    496e:	ecd6                	sd	s5,88(sp)
    4970:	e8da                	sd	s6,80(sp)
    4972:	e4de                	sd	s7,72(sp)
    4974:	0900                	addi	s0,sp,144
    4976:	8baa                	mv	s7,a0
  if(pipe(fds) != 0){
    4978:	fa040513          	addi	a0,s0,-96
    497c:	00001097          	auipc	ra,0x1
    4980:	61a080e7          	jalr	1562(ra) # 5f96 <pipe>
    4984:	e919                	bnez	a0,499a <sbrkfail+0x3a>
    4986:	f7040493          	addi	s1,s0,-144
    498a:	f9840993          	addi	s3,s0,-104
    498e:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4990:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    4992:	f9f40b13          	addi	s6,s0,-97
    4996:	4a85                	li	s5,1
    4998:	a08d                	j	49fa <sbrkfail+0x9a>
    printf("%s: pipe() failed\n", s);
    499a:	85de                	mv	a1,s7
    499c:	00002517          	auipc	a0,0x2
    49a0:	5d450513          	addi	a0,a0,1492 # 6f70 <malloc+0xacc>
    49a4:	00002097          	auipc	ra,0x2
    49a8:	a44080e7          	jalr	-1468(ra) # 63e8 <printf>
    exit(1);
    49ac:	4505                	li	a0,1
    49ae:	00001097          	auipc	ra,0x1
    49b2:	5d8080e7          	jalr	1496(ra) # 5f86 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    49b6:	00001097          	auipc	ra,0x1
    49ba:	658080e7          	jalr	1624(ra) # 600e <sbrk>
    49be:	064007b7          	lui	a5,0x6400
    49c2:	40a7853b          	subw	a0,a5,a0
    49c6:	00001097          	auipc	ra,0x1
    49ca:	648080e7          	jalr	1608(ra) # 600e <sbrk>
      write(fds[1], "x", 1);
    49ce:	4605                	li	a2,1
    49d0:	00002597          	auipc	a1,0x2
    49d4:	c7858593          	addi	a1,a1,-904 # 6648 <malloc+0x1a4>
    49d8:	fa442503          	lw	a0,-92(s0)
    49dc:	00001097          	auipc	ra,0x1
    49e0:	5ca080e7          	jalr	1482(ra) # 5fa6 <write>
      for(;;) sleep(1000);
    49e4:	3e800493          	li	s1,1000
    49e8:	8526                	mv	a0,s1
    49ea:	00001097          	auipc	ra,0x1
    49ee:	62c080e7          	jalr	1580(ra) # 6016 <sleep>
    49f2:	bfdd                	j	49e8 <sbrkfail+0x88>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    49f4:	0911                	addi	s2,s2,4
    49f6:	03390463          	beq	s2,s3,4a1e <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    49fa:	00001097          	auipc	ra,0x1
    49fe:	584080e7          	jalr	1412(ra) # 5f7e <fork>
    4a02:	00a92023          	sw	a0,0(s2)
    4a06:	d945                	beqz	a0,49b6 <sbrkfail+0x56>
    if(pids[i] != -1)
    4a08:	ff4506e3          	beq	a0,s4,49f4 <sbrkfail+0x94>
      read(fds[0], &scratch, 1);
    4a0c:	8656                	mv	a2,s5
    4a0e:	85da                	mv	a1,s6
    4a10:	fa042503          	lw	a0,-96(s0)
    4a14:	00001097          	auipc	ra,0x1
    4a18:	58a080e7          	jalr	1418(ra) # 5f9e <read>
    4a1c:	bfe1                	j	49f4 <sbrkfail+0x94>
  c = sbrk(PGSIZE);
    4a1e:	6505                	lui	a0,0x1
    4a20:	00001097          	auipc	ra,0x1
    4a24:	5ee080e7          	jalr	1518(ra) # 600e <sbrk>
    4a28:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4a2a:	597d                	li	s2,-1
    4a2c:	a021                	j	4a34 <sbrkfail+0xd4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4a2e:	0491                	addi	s1,s1,4
    4a30:	01348f63          	beq	s1,s3,4a4e <sbrkfail+0xee>
    if(pids[i] == -1)
    4a34:	4088                	lw	a0,0(s1)
    4a36:	ff250ce3          	beq	a0,s2,4a2e <sbrkfail+0xce>
    kill(pids[i]);
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	57c080e7          	jalr	1404(ra) # 5fb6 <kill>
    wait(0);
    4a42:	4501                	li	a0,0
    4a44:	00001097          	auipc	ra,0x1
    4a48:	54a080e7          	jalr	1354(ra) # 5f8e <wait>
    4a4c:	b7cd                	j	4a2e <sbrkfail+0xce>
  if(c == (char*)0xffffffffffffffffL){
    4a4e:	57fd                	li	a5,-1
    4a50:	04fa0363          	beq	s4,a5,4a96 <sbrkfail+0x136>
  pid = fork();
    4a54:	00001097          	auipc	ra,0x1
    4a58:	52a080e7          	jalr	1322(ra) # 5f7e <fork>
    4a5c:	84aa                	mv	s1,a0
  if(pid < 0){
    4a5e:	04054a63          	bltz	a0,4ab2 <sbrkfail+0x152>
  if(pid == 0){
    4a62:	c535                	beqz	a0,4ace <sbrkfail+0x16e>
  wait(&xstatus);
    4a64:	fac40513          	addi	a0,s0,-84
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	526080e7          	jalr	1318(ra) # 5f8e <wait>
  if(xstatus != -1 && xstatus != 2)
    4a70:	fac42783          	lw	a5,-84(s0)
    4a74:	577d                	li	a4,-1
    4a76:	00e78563          	beq	a5,a4,4a80 <sbrkfail+0x120>
    4a7a:	4709                	li	a4,2
    4a7c:	08e79f63          	bne	a5,a4,4b1a <sbrkfail+0x1ba>
}
    4a80:	60aa                	ld	ra,136(sp)
    4a82:	640a                	ld	s0,128(sp)
    4a84:	74e6                	ld	s1,120(sp)
    4a86:	7946                	ld	s2,112(sp)
    4a88:	79a6                	ld	s3,104(sp)
    4a8a:	7a06                	ld	s4,96(sp)
    4a8c:	6ae6                	ld	s5,88(sp)
    4a8e:	6b46                	ld	s6,80(sp)
    4a90:	6ba6                	ld	s7,72(sp)
    4a92:	6149                	addi	sp,sp,144
    4a94:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4a96:	85de                	mv	a1,s7
    4a98:	00003517          	auipc	a0,0x3
    4a9c:	62850513          	addi	a0,a0,1576 # 80c0 <malloc+0x1c1c>
    4aa0:	00002097          	auipc	ra,0x2
    4aa4:	948080e7          	jalr	-1720(ra) # 63e8 <printf>
    exit(1);
    4aa8:	4505                	li	a0,1
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	4dc080e7          	jalr	1244(ra) # 5f86 <exit>
    printf("%s: fork failed\n", s);
    4ab2:	85de                	mv	a1,s7
    4ab4:	00002517          	auipc	a0,0x2
    4ab8:	3b450513          	addi	a0,a0,948 # 6e68 <malloc+0x9c4>
    4abc:	00002097          	auipc	ra,0x2
    4ac0:	92c080e7          	jalr	-1748(ra) # 63e8 <printf>
    exit(1);
    4ac4:	4505                	li	a0,1
    4ac6:	00001097          	auipc	ra,0x1
    4aca:	4c0080e7          	jalr	1216(ra) # 5f86 <exit>
    a = sbrk(0);
    4ace:	4501                	li	a0,0
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	53e080e7          	jalr	1342(ra) # 600e <sbrk>
    4ad8:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4ada:	3e800537          	lui	a0,0x3e800
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	530080e7          	jalr	1328(ra) # 600e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4ae6:	87ca                	mv	a5,s2
    4ae8:	3e800737          	lui	a4,0x3e800
    4aec:	993a                	add	s2,s2,a4
    4aee:	6705                	lui	a4,0x1
      n += *(a+i);
    4af0:	0007c603          	lbu	a2,0(a5) # 6400000 <base+0x63ef388>
    4af4:	9e25                	addw	a2,a2,s1
    4af6:	84b2                	mv	s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4af8:	97ba                	add	a5,a5,a4
    4afa:	fef91be3          	bne	s2,a5,4af0 <sbrkfail+0x190>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4afe:	85de                	mv	a1,s7
    4b00:	00003517          	auipc	a0,0x3
    4b04:	5e050513          	addi	a0,a0,1504 # 80e0 <malloc+0x1c3c>
    4b08:	00002097          	auipc	ra,0x2
    4b0c:	8e0080e7          	jalr	-1824(ra) # 63e8 <printf>
    exit(1);
    4b10:	4505                	li	a0,1
    4b12:	00001097          	auipc	ra,0x1
    4b16:	474080e7          	jalr	1140(ra) # 5f86 <exit>
    exit(1);
    4b1a:	4505                	li	a0,1
    4b1c:	00001097          	auipc	ra,0x1
    4b20:	46a080e7          	jalr	1130(ra) # 5f86 <exit>

0000000000004b24 <mem>:
{
    4b24:	7139                	addi	sp,sp,-64
    4b26:	fc06                	sd	ra,56(sp)
    4b28:	f822                	sd	s0,48(sp)
    4b2a:	f426                	sd	s1,40(sp)
    4b2c:	f04a                	sd	s2,32(sp)
    4b2e:	ec4e                	sd	s3,24(sp)
    4b30:	0080                	addi	s0,sp,64
    4b32:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4b34:	00001097          	auipc	ra,0x1
    4b38:	44a080e7          	jalr	1098(ra) # 5f7e <fork>
    m1 = 0;
    4b3c:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4b3e:	6909                	lui	s2,0x2
    4b40:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x2b>
  if((pid = fork()) == 0){
    4b44:	c115                	beqz	a0,4b68 <mem+0x44>
    wait(&xstatus);
    4b46:	fcc40513          	addi	a0,s0,-52
    4b4a:	00001097          	auipc	ra,0x1
    4b4e:	444080e7          	jalr	1092(ra) # 5f8e <wait>
    if(xstatus == -1){
    4b52:	fcc42503          	lw	a0,-52(s0)
    4b56:	57fd                	li	a5,-1
    4b58:	06f50363          	beq	a0,a5,4bbe <mem+0x9a>
    exit(xstatus);
    4b5c:	00001097          	auipc	ra,0x1
    4b60:	42a080e7          	jalr	1066(ra) # 5f86 <exit>
      *(char**)m2 = m1;
    4b64:	e104                	sd	s1,0(a0)
      m1 = m2;
    4b66:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4b68:	854a                	mv	a0,s2
    4b6a:	00002097          	auipc	ra,0x2
    4b6e:	93a080e7          	jalr	-1734(ra) # 64a4 <malloc>
    4b72:	f96d                	bnez	a0,4b64 <mem+0x40>
    while(m1){
    4b74:	c881                	beqz	s1,4b84 <mem+0x60>
      m2 = *(char**)m1;
    4b76:	8526                	mv	a0,s1
    4b78:	6084                	ld	s1,0(s1)
      free(m1);
    4b7a:	00002097          	auipc	ra,0x2
    4b7e:	8a4080e7          	jalr	-1884(ra) # 641e <free>
    while(m1){
    4b82:	f8f5                	bnez	s1,4b76 <mem+0x52>
    m1 = malloc(1024*20);
    4b84:	6515                	lui	a0,0x5
    4b86:	00002097          	auipc	ra,0x2
    4b8a:	91e080e7          	jalr	-1762(ra) # 64a4 <malloc>
    if(m1 == 0){
    4b8e:	c911                	beqz	a0,4ba2 <mem+0x7e>
    free(m1);
    4b90:	00002097          	auipc	ra,0x2
    4b94:	88e080e7          	jalr	-1906(ra) # 641e <free>
    exit(0);
    4b98:	4501                	li	a0,0
    4b9a:	00001097          	auipc	ra,0x1
    4b9e:	3ec080e7          	jalr	1004(ra) # 5f86 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    4ba2:	85ce                	mv	a1,s3
    4ba4:	00003517          	auipc	a0,0x3
    4ba8:	56c50513          	addi	a0,a0,1388 # 8110 <malloc+0x1c6c>
    4bac:	00002097          	auipc	ra,0x2
    4bb0:	83c080e7          	jalr	-1988(ra) # 63e8 <printf>
      exit(1);
    4bb4:	4505                	li	a0,1
    4bb6:	00001097          	auipc	ra,0x1
    4bba:	3d0080e7          	jalr	976(ra) # 5f86 <exit>
      exit(0);
    4bbe:	4501                	li	a0,0
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	3c6080e7          	jalr	966(ra) # 5f86 <exit>

0000000000004bc8 <sharedfd>:
{
    4bc8:	7119                	addi	sp,sp,-128
    4bca:	fc86                	sd	ra,120(sp)
    4bcc:	f8a2                	sd	s0,112(sp)
    4bce:	e0da                	sd	s6,64(sp)
    4bd0:	0100                	addi	s0,sp,128
    4bd2:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    4bd4:	00003517          	auipc	a0,0x3
    4bd8:	55c50513          	addi	a0,a0,1372 # 8130 <malloc+0x1c8c>
    4bdc:	00001097          	auipc	ra,0x1
    4be0:	3fa080e7          	jalr	1018(ra) # 5fd6 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4be4:	20200593          	li	a1,514
    4be8:	00003517          	auipc	a0,0x3
    4bec:	54850513          	addi	a0,a0,1352 # 8130 <malloc+0x1c8c>
    4bf0:	00001097          	auipc	ra,0x1
    4bf4:	3d6080e7          	jalr	982(ra) # 5fc6 <open>
  if(fd < 0){
    4bf8:	06054363          	bltz	a0,4c5e <sharedfd+0x96>
    4bfc:	f4a6                	sd	s1,104(sp)
    4bfe:	f0ca                	sd	s2,96(sp)
    4c00:	ecce                	sd	s3,88(sp)
    4c02:	e8d2                	sd	s4,80(sp)
    4c04:	e4d6                	sd	s5,72(sp)
    4c06:	89aa                	mv	s3,a0
  pid = fork();
    4c08:	00001097          	auipc	ra,0x1
    4c0c:	376080e7          	jalr	886(ra) # 5f7e <fork>
    4c10:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4c12:	07000593          	li	a1,112
    4c16:	e119                	bnez	a0,4c1c <sharedfd+0x54>
    4c18:	06300593          	li	a1,99
    4c1c:	4629                	li	a2,10
    4c1e:	f9040513          	addi	a0,s0,-112
    4c22:	00001097          	auipc	ra,0x1
    4c26:	142080e7          	jalr	322(ra) # 5d64 <memset>
    4c2a:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4c2e:	f9040a13          	addi	s4,s0,-112
    4c32:	4929                	li	s2,10
    4c34:	864a                	mv	a2,s2
    4c36:	85d2                	mv	a1,s4
    4c38:	854e                	mv	a0,s3
    4c3a:	00001097          	auipc	ra,0x1
    4c3e:	36c080e7          	jalr	876(ra) # 5fa6 <write>
    4c42:	05251463          	bne	a0,s2,4c8a <sharedfd+0xc2>
  for(i = 0; i < N; i++){
    4c46:	34fd                	addiw	s1,s1,-1
    4c48:	f4f5                	bnez	s1,4c34 <sharedfd+0x6c>
  if(pid == 0) {
    4c4a:	060a9163          	bnez	s5,4cac <sharedfd+0xe4>
    4c4e:	fc5e                	sd	s7,56(sp)
    4c50:	f862                	sd	s8,48(sp)
    4c52:	f466                	sd	s9,40(sp)
    exit(0);
    4c54:	4501                	li	a0,0
    4c56:	00001097          	auipc	ra,0x1
    4c5a:	330080e7          	jalr	816(ra) # 5f86 <exit>
    4c5e:	f4a6                	sd	s1,104(sp)
    4c60:	f0ca                	sd	s2,96(sp)
    4c62:	ecce                	sd	s3,88(sp)
    4c64:	e8d2                	sd	s4,80(sp)
    4c66:	e4d6                	sd	s5,72(sp)
    4c68:	fc5e                	sd	s7,56(sp)
    4c6a:	f862                	sd	s8,48(sp)
    4c6c:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4c6e:	85da                	mv	a1,s6
    4c70:	00003517          	auipc	a0,0x3
    4c74:	4d050513          	addi	a0,a0,1232 # 8140 <malloc+0x1c9c>
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	770080e7          	jalr	1904(ra) # 63e8 <printf>
    exit(1);
    4c80:	4505                	li	a0,1
    4c82:	00001097          	auipc	ra,0x1
    4c86:	304080e7          	jalr	772(ra) # 5f86 <exit>
    4c8a:	fc5e                	sd	s7,56(sp)
    4c8c:	f862                	sd	s8,48(sp)
    4c8e:	f466                	sd	s9,40(sp)
      printf("%s: write sharedfd failed\n", s);
    4c90:	85da                	mv	a1,s6
    4c92:	00003517          	auipc	a0,0x3
    4c96:	4d650513          	addi	a0,a0,1238 # 8168 <malloc+0x1cc4>
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	74e080e7          	jalr	1870(ra) # 63e8 <printf>
      exit(1);
    4ca2:	4505                	li	a0,1
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	2e2080e7          	jalr	738(ra) # 5f86 <exit>
    wait(&xstatus);
    4cac:	f8c40513          	addi	a0,s0,-116
    4cb0:	00001097          	auipc	ra,0x1
    4cb4:	2de080e7          	jalr	734(ra) # 5f8e <wait>
    if(xstatus != 0)
    4cb8:	f8c42a03          	lw	s4,-116(s0)
    4cbc:	000a0a63          	beqz	s4,4cd0 <sharedfd+0x108>
    4cc0:	fc5e                	sd	s7,56(sp)
    4cc2:	f862                	sd	s8,48(sp)
    4cc4:	f466                	sd	s9,40(sp)
      exit(xstatus);
    4cc6:	8552                	mv	a0,s4
    4cc8:	00001097          	auipc	ra,0x1
    4ccc:	2be080e7          	jalr	702(ra) # 5f86 <exit>
    4cd0:	fc5e                	sd	s7,56(sp)
  close(fd);
    4cd2:	854e                	mv	a0,s3
    4cd4:	00001097          	auipc	ra,0x1
    4cd8:	2da080e7          	jalr	730(ra) # 5fae <close>
  fd = open("sharedfd", 0);
    4cdc:	4581                	li	a1,0
    4cde:	00003517          	auipc	a0,0x3
    4ce2:	45250513          	addi	a0,a0,1106 # 8130 <malloc+0x1c8c>
    4ce6:	00001097          	auipc	ra,0x1
    4cea:	2e0080e7          	jalr	736(ra) # 5fc6 <open>
    4cee:	8baa                	mv	s7,a0
  nc = np = 0;
    4cf0:	89d2                	mv	s3,s4
  if(fd < 0){
    4cf2:	02054963          	bltz	a0,4d24 <sharedfd+0x15c>
    4cf6:	f862                	sd	s8,48(sp)
    4cf8:	f466                	sd	s9,40(sp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4cfa:	f9040c93          	addi	s9,s0,-112
    4cfe:	4c29                	li	s8,10
    4d00:	f9a40913          	addi	s2,s0,-102
      if(buf[i] == 'c')
    4d04:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4d08:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4d0c:	8662                	mv	a2,s8
    4d0e:	85e6                	mv	a1,s9
    4d10:	855e                	mv	a0,s7
    4d12:	00001097          	auipc	ra,0x1
    4d16:	28c080e7          	jalr	652(ra) # 5f9e <read>
    4d1a:	04a05163          	blez	a0,4d5c <sharedfd+0x194>
    4d1e:	f9040793          	addi	a5,s0,-112
    4d22:	a02d                	j	4d4c <sharedfd+0x184>
    4d24:	f862                	sd	s8,48(sp)
    4d26:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for reading\n", s);
    4d28:	85da                	mv	a1,s6
    4d2a:	00003517          	auipc	a0,0x3
    4d2e:	45e50513          	addi	a0,a0,1118 # 8188 <malloc+0x1ce4>
    4d32:	00001097          	auipc	ra,0x1
    4d36:	6b6080e7          	jalr	1718(ra) # 63e8 <printf>
    exit(1);
    4d3a:	4505                	li	a0,1
    4d3c:	00001097          	auipc	ra,0x1
    4d40:	24a080e7          	jalr	586(ra) # 5f86 <exit>
        nc++;
    4d44:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    4d46:	0785                	addi	a5,a5,1
    4d48:	fd2782e3          	beq	a5,s2,4d0c <sharedfd+0x144>
      if(buf[i] == 'c')
    4d4c:	0007c703          	lbu	a4,0(a5)
    4d50:	fe970ae3          	beq	a4,s1,4d44 <sharedfd+0x17c>
      if(buf[i] == 'p')
    4d54:	ff5719e3          	bne	a4,s5,4d46 <sharedfd+0x17e>
        np++;
    4d58:	2985                	addiw	s3,s3,1
    4d5a:	b7f5                	j	4d46 <sharedfd+0x17e>
  close(fd);
    4d5c:	855e                	mv	a0,s7
    4d5e:	00001097          	auipc	ra,0x1
    4d62:	250080e7          	jalr	592(ra) # 5fae <close>
  unlink("sharedfd");
    4d66:	00003517          	auipc	a0,0x3
    4d6a:	3ca50513          	addi	a0,a0,970 # 8130 <malloc+0x1c8c>
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	268080e7          	jalr	616(ra) # 5fd6 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4d76:	6789                	lui	a5,0x2
    4d78:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x2a>
    4d7c:	00fa1763          	bne	s4,a5,4d8a <sharedfd+0x1c2>
    4d80:	6789                	lui	a5,0x2
    4d82:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x2a>
    4d86:	02f98063          	beq	s3,a5,4da6 <sharedfd+0x1de>
    printf("%s: nc/np test fails\n", s);
    4d8a:	85da                	mv	a1,s6
    4d8c:	00003517          	auipc	a0,0x3
    4d90:	42450513          	addi	a0,a0,1060 # 81b0 <malloc+0x1d0c>
    4d94:	00001097          	auipc	ra,0x1
    4d98:	654080e7          	jalr	1620(ra) # 63e8 <printf>
    exit(1);
    4d9c:	4505                	li	a0,1
    4d9e:	00001097          	auipc	ra,0x1
    4da2:	1e8080e7          	jalr	488(ra) # 5f86 <exit>
    exit(0);
    4da6:	4501                	li	a0,0
    4da8:	00001097          	auipc	ra,0x1
    4dac:	1de080e7          	jalr	478(ra) # 5f86 <exit>

0000000000004db0 <fourfiles>:
{
    4db0:	7135                	addi	sp,sp,-160
    4db2:	ed06                	sd	ra,152(sp)
    4db4:	e922                	sd	s0,144(sp)
    4db6:	e526                	sd	s1,136(sp)
    4db8:	e14a                	sd	s2,128(sp)
    4dba:	fcce                	sd	s3,120(sp)
    4dbc:	f8d2                	sd	s4,112(sp)
    4dbe:	f4d6                	sd	s5,104(sp)
    4dc0:	f0da                	sd	s6,96(sp)
    4dc2:	ecde                	sd	s7,88(sp)
    4dc4:	e8e2                	sd	s8,80(sp)
    4dc6:	e4e6                	sd	s9,72(sp)
    4dc8:	e0ea                	sd	s10,64(sp)
    4dca:	fc6e                	sd	s11,56(sp)
    4dcc:	1100                	addi	s0,sp,160
    4dce:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4dd0:	00003797          	auipc	a5,0x3
    4dd4:	3f878793          	addi	a5,a5,1016 # 81c8 <malloc+0x1d24>
    4dd8:	f6f43823          	sd	a5,-144(s0)
    4ddc:	00003797          	auipc	a5,0x3
    4de0:	3f478793          	addi	a5,a5,1012 # 81d0 <malloc+0x1d2c>
    4de4:	f6f43c23          	sd	a5,-136(s0)
    4de8:	00003797          	auipc	a5,0x3
    4dec:	3f078793          	addi	a5,a5,1008 # 81d8 <malloc+0x1d34>
    4df0:	f8f43023          	sd	a5,-128(s0)
    4df4:	00003797          	auipc	a5,0x3
    4df8:	3ec78793          	addi	a5,a5,1004 # 81e0 <malloc+0x1d3c>
    4dfc:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4e00:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4e04:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4e06:	4481                	li	s1,0
    4e08:	4a11                	li	s4,4
    fname = names[pi];
    4e0a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4e0e:	854e                	mv	a0,s3
    4e10:	00001097          	auipc	ra,0x1
    4e14:	1c6080e7          	jalr	454(ra) # 5fd6 <unlink>
    pid = fork();
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	166080e7          	jalr	358(ra) # 5f7e <fork>
    if(pid < 0){
    4e20:	04054263          	bltz	a0,4e64 <fourfiles+0xb4>
    if(pid == 0){
    4e24:	cd31                	beqz	a0,4e80 <fourfiles+0xd0>
  for(pi = 0; pi < NCHILD; pi++){
    4e26:	2485                	addiw	s1,s1,1
    4e28:	0921                	addi	s2,s2,8
    4e2a:	ff4490e3          	bne	s1,s4,4e0a <fourfiles+0x5a>
    4e2e:	4491                	li	s1,4
    wait(&xstatus);
    4e30:	f6c40913          	addi	s2,s0,-148
    4e34:	854a                	mv	a0,s2
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	158080e7          	jalr	344(ra) # 5f8e <wait>
    if(xstatus != 0)
    4e3e:	f6c42b03          	lw	s6,-148(s0)
    4e42:	0c0b1863          	bnez	s6,4f12 <fourfiles+0x162>
  for(pi = 0; pi < NCHILD; pi++){
    4e46:	34fd                	addiw	s1,s1,-1
    4e48:	f4f5                	bnez	s1,4e34 <fourfiles+0x84>
    4e4a:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e4e:	6a8d                	lui	s5,0x3
    4e50:	00009a17          	auipc	s4,0x9
    4e54:	e28a0a13          	addi	s4,s4,-472 # dc78 <buf>
    if(total != N*SZ){
    4e58:	6d05                	lui	s10,0x1
    4e5a:	770d0d13          	addi	s10,s10,1904 # 1770 <truncate3+0x11c>
  for(i = 0; i < NCHILD; i++){
    4e5e:	03400d93          	li	s11,52
    4e62:	a8dd                	j	4f58 <fourfiles+0x1a8>
      printf("%s: fork failed\n", s);
    4e64:	85e6                	mv	a1,s9
    4e66:	00002517          	auipc	a0,0x2
    4e6a:	00250513          	addi	a0,a0,2 # 6e68 <malloc+0x9c4>
    4e6e:	00001097          	auipc	ra,0x1
    4e72:	57a080e7          	jalr	1402(ra) # 63e8 <printf>
      exit(1);
    4e76:	4505                	li	a0,1
    4e78:	00001097          	auipc	ra,0x1
    4e7c:	10e080e7          	jalr	270(ra) # 5f86 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4e80:	20200593          	li	a1,514
    4e84:	854e                	mv	a0,s3
    4e86:	00001097          	auipc	ra,0x1
    4e8a:	140080e7          	jalr	320(ra) # 5fc6 <open>
    4e8e:	892a                	mv	s2,a0
      if(fd < 0){
    4e90:	04054663          	bltz	a0,4edc <fourfiles+0x12c>
      memset(buf, '0'+pi, SZ);
    4e94:	1f400613          	li	a2,500
    4e98:	0304859b          	addiw	a1,s1,48
    4e9c:	00009517          	auipc	a0,0x9
    4ea0:	ddc50513          	addi	a0,a0,-548 # dc78 <buf>
    4ea4:	00001097          	auipc	ra,0x1
    4ea8:	ec0080e7          	jalr	-320(ra) # 5d64 <memset>
    4eac:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4eae:	1f400993          	li	s3,500
    4eb2:	00009a17          	auipc	s4,0x9
    4eb6:	dc6a0a13          	addi	s4,s4,-570 # dc78 <buf>
    4eba:	864e                	mv	a2,s3
    4ebc:	85d2                	mv	a1,s4
    4ebe:	854a                	mv	a0,s2
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	0e6080e7          	jalr	230(ra) # 5fa6 <write>
    4ec8:	85aa                	mv	a1,a0
    4eca:	03351763          	bne	a0,s3,4ef8 <fourfiles+0x148>
      for(i = 0; i < N; i++){
    4ece:	34fd                	addiw	s1,s1,-1
    4ed0:	f4ed                	bnez	s1,4eba <fourfiles+0x10a>
      exit(0);
    4ed2:	4501                	li	a0,0
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	0b2080e7          	jalr	178(ra) # 5f86 <exit>
        printf("%s: create failed\n", s);
    4edc:	85e6                	mv	a1,s9
    4ede:	00002517          	auipc	a0,0x2
    4ee2:	02250513          	addi	a0,a0,34 # 6f00 <malloc+0xa5c>
    4ee6:	00001097          	auipc	ra,0x1
    4eea:	502080e7          	jalr	1282(ra) # 63e8 <printf>
        exit(1);
    4eee:	4505                	li	a0,1
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	096080e7          	jalr	150(ra) # 5f86 <exit>
          printf("write failed %d\n", n);
    4ef8:	00003517          	auipc	a0,0x3
    4efc:	2f050513          	addi	a0,a0,752 # 81e8 <malloc+0x1d44>
    4f00:	00001097          	auipc	ra,0x1
    4f04:	4e8080e7          	jalr	1256(ra) # 63e8 <printf>
          exit(1);
    4f08:	4505                	li	a0,1
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	07c080e7          	jalr	124(ra) # 5f86 <exit>
      exit(xstatus);
    4f12:	855a                	mv	a0,s6
    4f14:	00001097          	auipc	ra,0x1
    4f18:	072080e7          	jalr	114(ra) # 5f86 <exit>
          printf("%s: wrong char\n", s);
    4f1c:	85e6                	mv	a1,s9
    4f1e:	00003517          	auipc	a0,0x3
    4f22:	2e250513          	addi	a0,a0,738 # 8200 <malloc+0x1d5c>
    4f26:	00001097          	auipc	ra,0x1
    4f2a:	4c2080e7          	jalr	1218(ra) # 63e8 <printf>
          exit(1);
    4f2e:	4505                	li	a0,1
    4f30:	00001097          	auipc	ra,0x1
    4f34:	056080e7          	jalr	86(ra) # 5f86 <exit>
    close(fd);
    4f38:	854e                	mv	a0,s3
    4f3a:	00001097          	auipc	ra,0x1
    4f3e:	074080e7          	jalr	116(ra) # 5fae <close>
    if(total != N*SZ){
    4f42:	05a91e63          	bne	s2,s10,4f9e <fourfiles+0x1ee>
    unlink(fname);
    4f46:	8562                	mv	a0,s8
    4f48:	00001097          	auipc	ra,0x1
    4f4c:	08e080e7          	jalr	142(ra) # 5fd6 <unlink>
  for(i = 0; i < NCHILD; i++){
    4f50:	0ba1                	addi	s7,s7,8
    4f52:	2485                	addiw	s1,s1,1
    4f54:	07b48363          	beq	s1,s11,4fba <fourfiles+0x20a>
    fname = names[i];
    4f58:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4f5c:	4581                	li	a1,0
    4f5e:	8562                	mv	a0,s8
    4f60:	00001097          	auipc	ra,0x1
    4f64:	066080e7          	jalr	102(ra) # 5fc6 <open>
    4f68:	89aa                	mv	s3,a0
    total = 0;
    4f6a:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4f6c:	8656                	mv	a2,s5
    4f6e:	85d2                	mv	a1,s4
    4f70:	854e                	mv	a0,s3
    4f72:	00001097          	auipc	ra,0x1
    4f76:	02c080e7          	jalr	44(ra) # 5f9e <read>
    4f7a:	faa05fe3          	blez	a0,4f38 <fourfiles+0x188>
    4f7e:	00009797          	auipc	a5,0x9
    4f82:	cfa78793          	addi	a5,a5,-774 # dc78 <buf>
    4f86:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4f8a:	0007c703          	lbu	a4,0(a5)
    4f8e:	f89717e3          	bne	a4,s1,4f1c <fourfiles+0x16c>
      for(j = 0; j < n; j++){
    4f92:	0785                	addi	a5,a5,1
    4f94:	fed79be3          	bne	a5,a3,4f8a <fourfiles+0x1da>
      total += n;
    4f98:	00a9093b          	addw	s2,s2,a0
    4f9c:	bfc1                	j	4f6c <fourfiles+0x1bc>
      printf("wrong length %d\n", total);
    4f9e:	85ca                	mv	a1,s2
    4fa0:	00003517          	auipc	a0,0x3
    4fa4:	27050513          	addi	a0,a0,624 # 8210 <malloc+0x1d6c>
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	440080e7          	jalr	1088(ra) # 63e8 <printf>
      exit(1);
    4fb0:	4505                	li	a0,1
    4fb2:	00001097          	auipc	ra,0x1
    4fb6:	fd4080e7          	jalr	-44(ra) # 5f86 <exit>
}
    4fba:	60ea                	ld	ra,152(sp)
    4fbc:	644a                	ld	s0,144(sp)
    4fbe:	64aa                	ld	s1,136(sp)
    4fc0:	690a                	ld	s2,128(sp)
    4fc2:	79e6                	ld	s3,120(sp)
    4fc4:	7a46                	ld	s4,112(sp)
    4fc6:	7aa6                	ld	s5,104(sp)
    4fc8:	7b06                	ld	s6,96(sp)
    4fca:	6be6                	ld	s7,88(sp)
    4fcc:	6c46                	ld	s8,80(sp)
    4fce:	6ca6                	ld	s9,72(sp)
    4fd0:	6d06                	ld	s10,64(sp)
    4fd2:	7de2                	ld	s11,56(sp)
    4fd4:	610d                	addi	sp,sp,160
    4fd6:	8082                	ret

0000000000004fd8 <concreate>:
{
    4fd8:	7171                	addi	sp,sp,-176
    4fda:	f506                	sd	ra,168(sp)
    4fdc:	f122                	sd	s0,160(sp)
    4fde:	ed26                	sd	s1,152(sp)
    4fe0:	e94a                	sd	s2,144(sp)
    4fe2:	e54e                	sd	s3,136(sp)
    4fe4:	e152                	sd	s4,128(sp)
    4fe6:	fcd6                	sd	s5,120(sp)
    4fe8:	f8da                	sd	s6,112(sp)
    4fea:	f4de                	sd	s7,104(sp)
    4fec:	f0e2                	sd	s8,96(sp)
    4fee:	ece6                	sd	s9,88(sp)
    4ff0:	e8ea                	sd	s10,80(sp)
    4ff2:	1900                	addi	s0,sp,176
    4ff4:	8baa                	mv	s7,a0
  file[0] = 'C';
    4ff6:	04300793          	li	a5,67
    4ffa:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    4ffe:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    5002:	4901                	li	s2,0
    unlink(file);
    5004:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    5008:	55555b37          	lui	s6,0x55555
    500c:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555448de>
    5010:	4c05                	li	s8,1
      fd = open(file, O_CREATE | O_RDWR);
    5012:	20200c93          	li	s9,514
      link("C0", file);
    5016:	00003d17          	auipc	s10,0x3
    501a:	212d0d13          	addi	s10,s10,530 # 8228 <malloc+0x1d84>
      wait(&xstatus);
    501e:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    5022:	02800a13          	li	s4,40
    5026:	a4dd                	j	530c <concreate+0x334>
      link("C0", file);
    5028:	85ce                	mv	a1,s3
    502a:	856a                	mv	a0,s10
    502c:	00001097          	auipc	ra,0x1
    5030:	fba080e7          	jalr	-70(ra) # 5fe6 <link>
    if(pid == 0) {
    5034:	a4c1                	j	52f4 <concreate+0x31c>
    } else if(pid == 0 && (i % 5) == 1){
    5036:	666667b7          	lui	a5,0x66666
    503a:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666559ef>
    503e:	02f907b3          	mul	a5,s2,a5
    5042:	9785                	srai	a5,a5,0x21
    5044:	41f9571b          	sraiw	a4,s2,0x1f
    5048:	9f99                	subw	a5,a5,a4
    504a:	0027971b          	slliw	a4,a5,0x2
    504e:	9fb9                	addw	a5,a5,a4
    5050:	40f9093b          	subw	s2,s2,a5
    5054:	4785                	li	a5,1
    5056:	02f90b63          	beq	s2,a5,508c <concreate+0xb4>
      fd = open(file, O_CREATE | O_RDWR);
    505a:	20200593          	li	a1,514
    505e:	f9840513          	addi	a0,s0,-104
    5062:	00001097          	auipc	ra,0x1
    5066:	f64080e7          	jalr	-156(ra) # 5fc6 <open>
      if(fd < 0){
    506a:	26055c63          	bgez	a0,52e2 <concreate+0x30a>
        printf("concreate create %s failed\n", file);
    506e:	f9840593          	addi	a1,s0,-104
    5072:	00003517          	auipc	a0,0x3
    5076:	1be50513          	addi	a0,a0,446 # 8230 <malloc+0x1d8c>
    507a:	00001097          	auipc	ra,0x1
    507e:	36e080e7          	jalr	878(ra) # 63e8 <printf>
        exit(1);
    5082:	4505                	li	a0,1
    5084:	00001097          	auipc	ra,0x1
    5088:	f02080e7          	jalr	-254(ra) # 5f86 <exit>
      link("C0", file);
    508c:	f9840593          	addi	a1,s0,-104
    5090:	00003517          	auipc	a0,0x3
    5094:	19850513          	addi	a0,a0,408 # 8228 <malloc+0x1d84>
    5098:	00001097          	auipc	ra,0x1
    509c:	f4e080e7          	jalr	-178(ra) # 5fe6 <link>
      exit(0);
    50a0:	4501                	li	a0,0
    50a2:	00001097          	auipc	ra,0x1
    50a6:	ee4080e7          	jalr	-284(ra) # 5f86 <exit>
        exit(1);
    50aa:	4505                	li	a0,1
    50ac:	00001097          	auipc	ra,0x1
    50b0:	eda080e7          	jalr	-294(ra) # 5f86 <exit>
  memset(fa, 0, sizeof(fa));
    50b4:	02800613          	li	a2,40
    50b8:	4581                	li	a1,0
    50ba:	f7040513          	addi	a0,s0,-144
    50be:	00001097          	auipc	ra,0x1
    50c2:	ca6080e7          	jalr	-858(ra) # 5d64 <memset>
  fd = open(".", 0);
    50c6:	4581                	li	a1,0
    50c8:	00002517          	auipc	a0,0x2
    50cc:	bf850513          	addi	a0,a0,-1032 # 6cc0 <malloc+0x81c>
    50d0:	00001097          	auipc	ra,0x1
    50d4:	ef6080e7          	jalr	-266(ra) # 5fc6 <open>
    50d8:	892a                	mv	s2,a0
  n = 0;
    50da:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    50dc:	f6040a13          	addi	s4,s0,-160
    50e0:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    50e2:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    50e6:	02700c13          	li	s8,39
      fa[i] = 1;
    50ea:	4c85                	li	s9,1
  while(read(fd, &de, sizeof(de)) > 0){
    50ec:	864e                	mv	a2,s3
    50ee:	85d2                	mv	a1,s4
    50f0:	854a                	mv	a0,s2
    50f2:	00001097          	auipc	ra,0x1
    50f6:	eac080e7          	jalr	-340(ra) # 5f9e <read>
    50fa:	06a05f63          	blez	a0,5178 <concreate+0x1a0>
    if(de.inum == 0)
    50fe:	f6045783          	lhu	a5,-160(s0)
    5102:	d7ed                	beqz	a5,50ec <concreate+0x114>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5104:	f6244783          	lbu	a5,-158(s0)
    5108:	ff5792e3          	bne	a5,s5,50ec <concreate+0x114>
    510c:	f6444783          	lbu	a5,-156(s0)
    5110:	fff1                	bnez	a5,50ec <concreate+0x114>
      i = de.name[1] - '0';
    5112:	f6344783          	lbu	a5,-157(s0)
    5116:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    511a:	00fc6f63          	bltu	s8,a5,5138 <concreate+0x160>
      if(fa[i]){
    511e:	fa078713          	addi	a4,a5,-96
    5122:	9722                	add	a4,a4,s0
    5124:	fd074703          	lbu	a4,-48(a4) # fd0 <linktest+0x1c>
    5128:	eb05                	bnez	a4,5158 <concreate+0x180>
      fa[i] = 1;
    512a:	fa078793          	addi	a5,a5,-96
    512e:	97a2                	add	a5,a5,s0
    5130:	fd978823          	sb	s9,-48(a5)
      n++;
    5134:	2b05                	addiw	s6,s6,1
    5136:	bf5d                	j	50ec <concreate+0x114>
        printf("%s: concreate weird file %s\n", s, de.name);
    5138:	f6240613          	addi	a2,s0,-158
    513c:	85de                	mv	a1,s7
    513e:	00003517          	auipc	a0,0x3
    5142:	11250513          	addi	a0,a0,274 # 8250 <malloc+0x1dac>
    5146:	00001097          	auipc	ra,0x1
    514a:	2a2080e7          	jalr	674(ra) # 63e8 <printf>
        exit(1);
    514e:	4505                	li	a0,1
    5150:	00001097          	auipc	ra,0x1
    5154:	e36080e7          	jalr	-458(ra) # 5f86 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    5158:	f6240613          	addi	a2,s0,-158
    515c:	85de                	mv	a1,s7
    515e:	00003517          	auipc	a0,0x3
    5162:	11250513          	addi	a0,a0,274 # 8270 <malloc+0x1dcc>
    5166:	00001097          	auipc	ra,0x1
    516a:	282080e7          	jalr	642(ra) # 63e8 <printf>
        exit(1);
    516e:	4505                	li	a0,1
    5170:	00001097          	auipc	ra,0x1
    5174:	e16080e7          	jalr	-490(ra) # 5f86 <exit>
  close(fd);
    5178:	854a                	mv	a0,s2
    517a:	00001097          	auipc	ra,0x1
    517e:	e34080e7          	jalr	-460(ra) # 5fae <close>
  if(n != N){
    5182:	02800793          	li	a5,40
    5186:	00fb1b63          	bne	s6,a5,519c <concreate+0x1c4>
    if(((i % 3) == 0 && pid == 0) ||
    518a:	55555a37          	lui	s4,0x55555
    518e:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555448de>
      close(open(file, 0));
    5192:	f9840993          	addi	s3,s0,-104
    if(((i % 3) == 0 && pid == 0) ||
    5196:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    5198:	8abe                	mv	s5,a5
    519a:	a0d9                	j	5260 <concreate+0x288>
    printf("%s: concreate not enough files in directory listing\n", s);
    519c:	85de                	mv	a1,s7
    519e:	00003517          	auipc	a0,0x3
    51a2:	0fa50513          	addi	a0,a0,250 # 8298 <malloc+0x1df4>
    51a6:	00001097          	auipc	ra,0x1
    51aa:	242080e7          	jalr	578(ra) # 63e8 <printf>
    exit(1);
    51ae:	4505                	li	a0,1
    51b0:	00001097          	auipc	ra,0x1
    51b4:	dd6080e7          	jalr	-554(ra) # 5f86 <exit>
      printf("%s: fork failed\n", s);
    51b8:	85de                	mv	a1,s7
    51ba:	00002517          	auipc	a0,0x2
    51be:	cae50513          	addi	a0,a0,-850 # 6e68 <malloc+0x9c4>
    51c2:	00001097          	auipc	ra,0x1
    51c6:	226080e7          	jalr	550(ra) # 63e8 <printf>
      exit(1);
    51ca:	4505                	li	a0,1
    51cc:	00001097          	auipc	ra,0x1
    51d0:	dba080e7          	jalr	-582(ra) # 5f86 <exit>
      close(open(file, 0));
    51d4:	4581                	li	a1,0
    51d6:	854e                	mv	a0,s3
    51d8:	00001097          	auipc	ra,0x1
    51dc:	dee080e7          	jalr	-530(ra) # 5fc6 <open>
    51e0:	00001097          	auipc	ra,0x1
    51e4:	dce080e7          	jalr	-562(ra) # 5fae <close>
      close(open(file, 0));
    51e8:	4581                	li	a1,0
    51ea:	854e                	mv	a0,s3
    51ec:	00001097          	auipc	ra,0x1
    51f0:	dda080e7          	jalr	-550(ra) # 5fc6 <open>
    51f4:	00001097          	auipc	ra,0x1
    51f8:	dba080e7          	jalr	-582(ra) # 5fae <close>
      close(open(file, 0));
    51fc:	4581                	li	a1,0
    51fe:	854e                	mv	a0,s3
    5200:	00001097          	auipc	ra,0x1
    5204:	dc6080e7          	jalr	-570(ra) # 5fc6 <open>
    5208:	00001097          	auipc	ra,0x1
    520c:	da6080e7          	jalr	-602(ra) # 5fae <close>
      close(open(file, 0));
    5210:	4581                	li	a1,0
    5212:	854e                	mv	a0,s3
    5214:	00001097          	auipc	ra,0x1
    5218:	db2080e7          	jalr	-590(ra) # 5fc6 <open>
    521c:	00001097          	auipc	ra,0x1
    5220:	d92080e7          	jalr	-622(ra) # 5fae <close>
      close(open(file, 0));
    5224:	4581                	li	a1,0
    5226:	854e                	mv	a0,s3
    5228:	00001097          	auipc	ra,0x1
    522c:	d9e080e7          	jalr	-610(ra) # 5fc6 <open>
    5230:	00001097          	auipc	ra,0x1
    5234:	d7e080e7          	jalr	-642(ra) # 5fae <close>
      close(open(file, 0));
    5238:	4581                	li	a1,0
    523a:	854e                	mv	a0,s3
    523c:	00001097          	auipc	ra,0x1
    5240:	d8a080e7          	jalr	-630(ra) # 5fc6 <open>
    5244:	00001097          	auipc	ra,0x1
    5248:	d6a080e7          	jalr	-662(ra) # 5fae <close>
    if(pid == 0)
    524c:	08090663          	beqz	s2,52d8 <concreate+0x300>
      wait(0);
    5250:	4501                	li	a0,0
    5252:	00001097          	auipc	ra,0x1
    5256:	d3c080e7          	jalr	-708(ra) # 5f8e <wait>
  for(i = 0; i < N; i++){
    525a:	2485                	addiw	s1,s1,1
    525c:	0f548d63          	beq	s1,s5,5356 <concreate+0x37e>
    file[1] = '0' + i;
    5260:	0304879b          	addiw	a5,s1,48
    5264:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    5268:	00001097          	auipc	ra,0x1
    526c:	d16080e7          	jalr	-746(ra) # 5f7e <fork>
    5270:	892a                	mv	s2,a0
    if(pid < 0){
    5272:	f40543e3          	bltz	a0,51b8 <concreate+0x1e0>
    if(((i % 3) == 0 && pid == 0) ||
    5276:	03448733          	mul	a4,s1,s4
    527a:	9301                	srli	a4,a4,0x20
    527c:	41f4d79b          	sraiw	a5,s1,0x1f
    5280:	9f1d                	subw	a4,a4,a5
    5282:	0017179b          	slliw	a5,a4,0x1
    5286:	9fb9                	addw	a5,a5,a4
    5288:	40f487bb          	subw	a5,s1,a5
    528c:	873e                	mv	a4,a5
    528e:	8fc9                	or	a5,a5,a0
    5290:	2781                	sext.w	a5,a5
    5292:	d3a9                	beqz	a5,51d4 <concreate+0x1fc>
    5294:	01671363          	bne	a4,s6,529a <concreate+0x2c2>
       ((i % 3) == 1 && pid != 0)){
    5298:	fd15                	bnez	a0,51d4 <concreate+0x1fc>
      unlink(file);
    529a:	854e                	mv	a0,s3
    529c:	00001097          	auipc	ra,0x1
    52a0:	d3a080e7          	jalr	-710(ra) # 5fd6 <unlink>
      unlink(file);
    52a4:	854e                	mv	a0,s3
    52a6:	00001097          	auipc	ra,0x1
    52aa:	d30080e7          	jalr	-720(ra) # 5fd6 <unlink>
      unlink(file);
    52ae:	854e                	mv	a0,s3
    52b0:	00001097          	auipc	ra,0x1
    52b4:	d26080e7          	jalr	-730(ra) # 5fd6 <unlink>
      unlink(file);
    52b8:	854e                	mv	a0,s3
    52ba:	00001097          	auipc	ra,0x1
    52be:	d1c080e7          	jalr	-740(ra) # 5fd6 <unlink>
      unlink(file);
    52c2:	854e                	mv	a0,s3
    52c4:	00001097          	auipc	ra,0x1
    52c8:	d12080e7          	jalr	-750(ra) # 5fd6 <unlink>
      unlink(file);
    52cc:	854e                	mv	a0,s3
    52ce:	00001097          	auipc	ra,0x1
    52d2:	d08080e7          	jalr	-760(ra) # 5fd6 <unlink>
    52d6:	bf9d                	j	524c <concreate+0x274>
      exit(0);
    52d8:	4501                	li	a0,0
    52da:	00001097          	auipc	ra,0x1
    52de:	cac080e7          	jalr	-852(ra) # 5f86 <exit>
      close(fd);
    52e2:	00001097          	auipc	ra,0x1
    52e6:	ccc080e7          	jalr	-820(ra) # 5fae <close>
    if(pid == 0) {
    52ea:	bb5d                	j	50a0 <concreate+0xc8>
      close(fd);
    52ec:	00001097          	auipc	ra,0x1
    52f0:	cc2080e7          	jalr	-830(ra) # 5fae <close>
      wait(&xstatus);
    52f4:	8556                	mv	a0,s5
    52f6:	00001097          	auipc	ra,0x1
    52fa:	c98080e7          	jalr	-872(ra) # 5f8e <wait>
      if(xstatus != 0)
    52fe:	f5c42483          	lw	s1,-164(s0)
    5302:	da0494e3          	bnez	s1,50aa <concreate+0xd2>
  for(i = 0; i < N; i++){
    5306:	2905                	addiw	s2,s2,1
    5308:	db4906e3          	beq	s2,s4,50b4 <concreate+0xdc>
    file[1] = '0' + i;
    530c:	0309079b          	addiw	a5,s2,48
    5310:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    5314:	854e                	mv	a0,s3
    5316:	00001097          	auipc	ra,0x1
    531a:	cc0080e7          	jalr	-832(ra) # 5fd6 <unlink>
    pid = fork();
    531e:	00001097          	auipc	ra,0x1
    5322:	c60080e7          	jalr	-928(ra) # 5f7e <fork>
    if(pid && (i % 3) == 1){
    5326:	d00508e3          	beqz	a0,5036 <concreate+0x5e>
    532a:	036907b3          	mul	a5,s2,s6
    532e:	9381                	srli	a5,a5,0x20
    5330:	41f9571b          	sraiw	a4,s2,0x1f
    5334:	9f99                	subw	a5,a5,a4
    5336:	0017971b          	slliw	a4,a5,0x1
    533a:	9fb9                	addw	a5,a5,a4
    533c:	40f907bb          	subw	a5,s2,a5
    5340:	cf8784e3          	beq	a5,s8,5028 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    5344:	85e6                	mv	a1,s9
    5346:	854e                	mv	a0,s3
    5348:	00001097          	auipc	ra,0x1
    534c:	c7e080e7          	jalr	-898(ra) # 5fc6 <open>
      if(fd < 0){
    5350:	f8055ee3          	bgez	a0,52ec <concreate+0x314>
    5354:	bb29                	j	506e <concreate+0x96>
}
    5356:	70aa                	ld	ra,168(sp)
    5358:	740a                	ld	s0,160(sp)
    535a:	64ea                	ld	s1,152(sp)
    535c:	694a                	ld	s2,144(sp)
    535e:	69aa                	ld	s3,136(sp)
    5360:	6a0a                	ld	s4,128(sp)
    5362:	7ae6                	ld	s5,120(sp)
    5364:	7b46                	ld	s6,112(sp)
    5366:	7ba6                	ld	s7,104(sp)
    5368:	7c06                	ld	s8,96(sp)
    536a:	6ce6                	ld	s9,88(sp)
    536c:	6d46                	ld	s10,80(sp)
    536e:	614d                	addi	sp,sp,176
    5370:	8082                	ret

0000000000005372 <bigfile>:
{
    5372:	7139                	addi	sp,sp,-64
    5374:	fc06                	sd	ra,56(sp)
    5376:	f822                	sd	s0,48(sp)
    5378:	f426                	sd	s1,40(sp)
    537a:	f04a                	sd	s2,32(sp)
    537c:	ec4e                	sd	s3,24(sp)
    537e:	e852                	sd	s4,16(sp)
    5380:	e456                	sd	s5,8(sp)
    5382:	e05a                	sd	s6,0(sp)
    5384:	0080                	addi	s0,sp,64
    5386:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    5388:	00003517          	auipc	a0,0x3
    538c:	f4850513          	addi	a0,a0,-184 # 82d0 <malloc+0x1e2c>
    5390:	00001097          	auipc	ra,0x1
    5394:	c46080e7          	jalr	-954(ra) # 5fd6 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5398:	20200593          	li	a1,514
    539c:	00003517          	auipc	a0,0x3
    53a0:	f3450513          	addi	a0,a0,-204 # 82d0 <malloc+0x1e2c>
    53a4:	00001097          	auipc	ra,0x1
    53a8:	c22080e7          	jalr	-990(ra) # 5fc6 <open>
  if(fd < 0){
    53ac:	0a054463          	bltz	a0,5454 <bigfile+0xe2>
    53b0:	8a2a                	mv	s4,a0
    53b2:	4481                	li	s1,0
    memset(buf, i, SZ);
    53b4:	25800913          	li	s2,600
    53b8:	00009997          	auipc	s3,0x9
    53bc:	8c098993          	addi	s3,s3,-1856 # dc78 <buf>
  for(i = 0; i < N; i++){
    53c0:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    53c2:	864a                	mv	a2,s2
    53c4:	85a6                	mv	a1,s1
    53c6:	854e                	mv	a0,s3
    53c8:	00001097          	auipc	ra,0x1
    53cc:	99c080e7          	jalr	-1636(ra) # 5d64 <memset>
    if(write(fd, buf, SZ) != SZ){
    53d0:	864a                	mv	a2,s2
    53d2:	85ce                	mv	a1,s3
    53d4:	8552                	mv	a0,s4
    53d6:	00001097          	auipc	ra,0x1
    53da:	bd0080e7          	jalr	-1072(ra) # 5fa6 <write>
    53de:	09251963          	bne	a0,s2,5470 <bigfile+0xfe>
  for(i = 0; i < N; i++){
    53e2:	2485                	addiw	s1,s1,1
    53e4:	fd549fe3          	bne	s1,s5,53c2 <bigfile+0x50>
  close(fd);
    53e8:	8552                	mv	a0,s4
    53ea:	00001097          	auipc	ra,0x1
    53ee:	bc4080e7          	jalr	-1084(ra) # 5fae <close>
  fd = open("bigfile.dat", 0);
    53f2:	4581                	li	a1,0
    53f4:	00003517          	auipc	a0,0x3
    53f8:	edc50513          	addi	a0,a0,-292 # 82d0 <malloc+0x1e2c>
    53fc:	00001097          	auipc	ra,0x1
    5400:	bca080e7          	jalr	-1078(ra) # 5fc6 <open>
    5404:	8aaa                	mv	s5,a0
  total = 0;
    5406:	4a01                	li	s4,0
  for(i = 0; ; i++){
    5408:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    540a:	12c00993          	li	s3,300
    540e:	00009917          	auipc	s2,0x9
    5412:	86a90913          	addi	s2,s2,-1942 # dc78 <buf>
  if(fd < 0){
    5416:	06054b63          	bltz	a0,548c <bigfile+0x11a>
    cc = read(fd, buf, SZ/2);
    541a:	864e                	mv	a2,s3
    541c:	85ca                	mv	a1,s2
    541e:	8556                	mv	a0,s5
    5420:	00001097          	auipc	ra,0x1
    5424:	b7e080e7          	jalr	-1154(ra) # 5f9e <read>
    if(cc < 0){
    5428:	08054063          	bltz	a0,54a8 <bigfile+0x136>
    if(cc == 0)
    542c:	c961                	beqz	a0,54fc <bigfile+0x18a>
    if(cc != SZ/2){
    542e:	09351b63          	bne	a0,s3,54c4 <bigfile+0x152>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5432:	01f4d79b          	srliw	a5,s1,0x1f
    5436:	9fa5                	addw	a5,a5,s1
    5438:	4017d79b          	sraiw	a5,a5,0x1
    543c:	00094703          	lbu	a4,0(s2)
    5440:	0af71063          	bne	a4,a5,54e0 <bigfile+0x16e>
    5444:	12b94703          	lbu	a4,299(s2)
    5448:	08f71c63          	bne	a4,a5,54e0 <bigfile+0x16e>
    total += cc;
    544c:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    5450:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5452:	b7e1                	j	541a <bigfile+0xa8>
    printf("%s: cannot create bigfile", s);
    5454:	85da                	mv	a1,s6
    5456:	00003517          	auipc	a0,0x3
    545a:	e8a50513          	addi	a0,a0,-374 # 82e0 <malloc+0x1e3c>
    545e:	00001097          	auipc	ra,0x1
    5462:	f8a080e7          	jalr	-118(ra) # 63e8 <printf>
    exit(1);
    5466:	4505                	li	a0,1
    5468:	00001097          	auipc	ra,0x1
    546c:	b1e080e7          	jalr	-1250(ra) # 5f86 <exit>
      printf("%s: write bigfile failed\n", s);
    5470:	85da                	mv	a1,s6
    5472:	00003517          	auipc	a0,0x3
    5476:	e8e50513          	addi	a0,a0,-370 # 8300 <malloc+0x1e5c>
    547a:	00001097          	auipc	ra,0x1
    547e:	f6e080e7          	jalr	-146(ra) # 63e8 <printf>
      exit(1);
    5482:	4505                	li	a0,1
    5484:	00001097          	auipc	ra,0x1
    5488:	b02080e7          	jalr	-1278(ra) # 5f86 <exit>
    printf("%s: cannot open bigfile\n", s);
    548c:	85da                	mv	a1,s6
    548e:	00003517          	auipc	a0,0x3
    5492:	e9250513          	addi	a0,a0,-366 # 8320 <malloc+0x1e7c>
    5496:	00001097          	auipc	ra,0x1
    549a:	f52080e7          	jalr	-174(ra) # 63e8 <printf>
    exit(1);
    549e:	4505                	li	a0,1
    54a0:	00001097          	auipc	ra,0x1
    54a4:	ae6080e7          	jalr	-1306(ra) # 5f86 <exit>
      printf("%s: read bigfile failed\n", s);
    54a8:	85da                	mv	a1,s6
    54aa:	00003517          	auipc	a0,0x3
    54ae:	e9650513          	addi	a0,a0,-362 # 8340 <malloc+0x1e9c>
    54b2:	00001097          	auipc	ra,0x1
    54b6:	f36080e7          	jalr	-202(ra) # 63e8 <printf>
      exit(1);
    54ba:	4505                	li	a0,1
    54bc:	00001097          	auipc	ra,0x1
    54c0:	aca080e7          	jalr	-1334(ra) # 5f86 <exit>
      printf("%s: short read bigfile\n", s);
    54c4:	85da                	mv	a1,s6
    54c6:	00003517          	auipc	a0,0x3
    54ca:	e9a50513          	addi	a0,a0,-358 # 8360 <malloc+0x1ebc>
    54ce:	00001097          	auipc	ra,0x1
    54d2:	f1a080e7          	jalr	-230(ra) # 63e8 <printf>
      exit(1);
    54d6:	4505                	li	a0,1
    54d8:	00001097          	auipc	ra,0x1
    54dc:	aae080e7          	jalr	-1362(ra) # 5f86 <exit>
      printf("%s: read bigfile wrong data\n", s);
    54e0:	85da                	mv	a1,s6
    54e2:	00003517          	auipc	a0,0x3
    54e6:	e9650513          	addi	a0,a0,-362 # 8378 <malloc+0x1ed4>
    54ea:	00001097          	auipc	ra,0x1
    54ee:	efe080e7          	jalr	-258(ra) # 63e8 <printf>
      exit(1);
    54f2:	4505                	li	a0,1
    54f4:	00001097          	auipc	ra,0x1
    54f8:	a92080e7          	jalr	-1390(ra) # 5f86 <exit>
  close(fd);
    54fc:	8556                	mv	a0,s5
    54fe:	00001097          	auipc	ra,0x1
    5502:	ab0080e7          	jalr	-1360(ra) # 5fae <close>
  if(total != N*SZ){
    5506:	678d                	lui	a5,0x3
    5508:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkbugs+0xa0>
    550c:	02fa1463          	bne	s4,a5,5534 <bigfile+0x1c2>
  unlink("bigfile.dat");
    5510:	00003517          	auipc	a0,0x3
    5514:	dc050513          	addi	a0,a0,-576 # 82d0 <malloc+0x1e2c>
    5518:	00001097          	auipc	ra,0x1
    551c:	abe080e7          	jalr	-1346(ra) # 5fd6 <unlink>
}
    5520:	70e2                	ld	ra,56(sp)
    5522:	7442                	ld	s0,48(sp)
    5524:	74a2                	ld	s1,40(sp)
    5526:	7902                	ld	s2,32(sp)
    5528:	69e2                	ld	s3,24(sp)
    552a:	6a42                	ld	s4,16(sp)
    552c:	6aa2                	ld	s5,8(sp)
    552e:	6b02                	ld	s6,0(sp)
    5530:	6121                	addi	sp,sp,64
    5532:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5534:	85da                	mv	a1,s6
    5536:	00003517          	auipc	a0,0x3
    553a:	e6250513          	addi	a0,a0,-414 # 8398 <malloc+0x1ef4>
    553e:	00001097          	auipc	ra,0x1
    5542:	eaa080e7          	jalr	-342(ra) # 63e8 <printf>
    exit(1);
    5546:	4505                	li	a0,1
    5548:	00001097          	auipc	ra,0x1
    554c:	a3e080e7          	jalr	-1474(ra) # 5f86 <exit>

0000000000005550 <bigargtest>:
{
    5550:	7121                	addi	sp,sp,-448
    5552:	ff06                	sd	ra,440(sp)
    5554:	fb22                	sd	s0,432(sp)
    5556:	f726                	sd	s1,424(sp)
    5558:	0380                	addi	s0,sp,448
    555a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    555c:	00003517          	auipc	a0,0x3
    5560:	e5c50513          	addi	a0,a0,-420 # 83b8 <malloc+0x1f14>
    5564:	00001097          	auipc	ra,0x1
    5568:	a72080e7          	jalr	-1422(ra) # 5fd6 <unlink>
  pid = fork();
    556c:	00001097          	auipc	ra,0x1
    5570:	a12080e7          	jalr	-1518(ra) # 5f7e <fork>
  if(pid == 0){
    5574:	c121                	beqz	a0,55b4 <bigargtest+0x64>
  } else if(pid < 0){
    5576:	0a054a63          	bltz	a0,562a <bigargtest+0xda>
  wait(&xstatus);
    557a:	fdc40513          	addi	a0,s0,-36
    557e:	00001097          	auipc	ra,0x1
    5582:	a10080e7          	jalr	-1520(ra) # 5f8e <wait>
  if(xstatus != 0)
    5586:	fdc42503          	lw	a0,-36(s0)
    558a:	ed55                	bnez	a0,5646 <bigargtest+0xf6>
  fd = open("bigarg-ok", 0);
    558c:	4581                	li	a1,0
    558e:	00003517          	auipc	a0,0x3
    5592:	e2a50513          	addi	a0,a0,-470 # 83b8 <malloc+0x1f14>
    5596:	00001097          	auipc	ra,0x1
    559a:	a30080e7          	jalr	-1488(ra) # 5fc6 <open>
  if(fd < 0){
    559e:	0a054863          	bltz	a0,564e <bigargtest+0xfe>
  close(fd);
    55a2:	00001097          	auipc	ra,0x1
    55a6:	a0c080e7          	jalr	-1524(ra) # 5fae <close>
}
    55aa:	70fa                	ld	ra,440(sp)
    55ac:	745a                	ld	s0,432(sp)
    55ae:	74ba                	ld	s1,424(sp)
    55b0:	6139                	addi	sp,sp,448
    55b2:	8082                	ret
    memset(big, ' ', sizeof(big));
    55b4:	19000613          	li	a2,400
    55b8:	02000593          	li	a1,32
    55bc:	e4840513          	addi	a0,s0,-440
    55c0:	00000097          	auipc	ra,0x0
    55c4:	7a4080e7          	jalr	1956(ra) # 5d64 <memset>
    big[sizeof(big)-1] = '\0';
    55c8:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    55cc:	00005797          	auipc	a5,0x5
    55d0:	e9478793          	addi	a5,a5,-364 # a460 <args.1>
    55d4:	00005697          	auipc	a3,0x5
    55d8:	f8468693          	addi	a3,a3,-124 # a558 <args.1+0xf8>
      args[i] = big;
    55dc:	e4840713          	addi	a4,s0,-440
    55e0:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    55e2:	07a1                	addi	a5,a5,8
    55e4:	fed79ee3          	bne	a5,a3,55e0 <bigargtest+0x90>
    args[MAXARG-1] = 0;
    55e8:	00005597          	auipc	a1,0x5
    55ec:	e7858593          	addi	a1,a1,-392 # a460 <args.1>
    55f0:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    55f4:	00001517          	auipc	a0,0x1
    55f8:	fe450513          	addi	a0,a0,-28 # 65d8 <malloc+0x134>
    55fc:	00001097          	auipc	ra,0x1
    5600:	9c2080e7          	jalr	-1598(ra) # 5fbe <exec>
    fd = open("bigarg-ok", O_CREATE);
    5604:	20000593          	li	a1,512
    5608:	00003517          	auipc	a0,0x3
    560c:	db050513          	addi	a0,a0,-592 # 83b8 <malloc+0x1f14>
    5610:	00001097          	auipc	ra,0x1
    5614:	9b6080e7          	jalr	-1610(ra) # 5fc6 <open>
    close(fd);
    5618:	00001097          	auipc	ra,0x1
    561c:	996080e7          	jalr	-1642(ra) # 5fae <close>
    exit(0);
    5620:	4501                	li	a0,0
    5622:	00001097          	auipc	ra,0x1
    5626:	964080e7          	jalr	-1692(ra) # 5f86 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    562a:	85a6                	mv	a1,s1
    562c:	00003517          	auipc	a0,0x3
    5630:	d9c50513          	addi	a0,a0,-612 # 83c8 <malloc+0x1f24>
    5634:	00001097          	auipc	ra,0x1
    5638:	db4080e7          	jalr	-588(ra) # 63e8 <printf>
    exit(1);
    563c:	4505                	li	a0,1
    563e:	00001097          	auipc	ra,0x1
    5642:	948080e7          	jalr	-1720(ra) # 5f86 <exit>
    exit(xstatus);
    5646:	00001097          	auipc	ra,0x1
    564a:	940080e7          	jalr	-1728(ra) # 5f86 <exit>
    printf("%s: bigarg test failed!\n", s);
    564e:	85a6                	mv	a1,s1
    5650:	00003517          	auipc	a0,0x3
    5654:	d9850513          	addi	a0,a0,-616 # 83e8 <malloc+0x1f44>
    5658:	00001097          	auipc	ra,0x1
    565c:	d90080e7          	jalr	-624(ra) # 63e8 <printf>
    exit(1);
    5660:	4505                	li	a0,1
    5662:	00001097          	auipc	ra,0x1
    5666:	924080e7          	jalr	-1756(ra) # 5f86 <exit>

000000000000566a <fsfull>:
{
    566a:	7171                	addi	sp,sp,-176
    566c:	f506                	sd	ra,168(sp)
    566e:	f122                	sd	s0,160(sp)
    5670:	ed26                	sd	s1,152(sp)
    5672:	e94a                	sd	s2,144(sp)
    5674:	e54e                	sd	s3,136(sp)
    5676:	e152                	sd	s4,128(sp)
    5678:	fcd6                	sd	s5,120(sp)
    567a:	f8da                	sd	s6,112(sp)
    567c:	f4de                	sd	s7,104(sp)
    567e:	f0e2                	sd	s8,96(sp)
    5680:	ece6                	sd	s9,88(sp)
    5682:	e8ea                	sd	s10,80(sp)
    5684:	e4ee                	sd	s11,72(sp)
    5686:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    5688:	00003517          	auipc	a0,0x3
    568c:	d8050513          	addi	a0,a0,-640 # 8408 <malloc+0x1f64>
    5690:	00001097          	auipc	ra,0x1
    5694:	d58080e7          	jalr	-680(ra) # 63e8 <printf>
  for(nfiles = 0; ; nfiles++){
    5698:	4481                	li	s1,0
    name[0] = 'f';
    569a:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    569e:	10625cb7          	lui	s9,0x10625
    56a2:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061415b>
    name[2] = '0' + (nfiles % 1000) / 100;
    56a6:	51eb8ab7          	lui	s5,0x51eb8
    56aa:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea78a7>
    name[3] = '0' + (nfiles % 100) / 10;
    56ae:	66666a37          	lui	s4,0x66666
    56b2:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666559ef>
    printf("writing %s\n", name);
    56b6:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    56ba:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    56be:	039487b3          	mul	a5,s1,s9
    56c2:	9799                	srai	a5,a5,0x26
    56c4:	41f4d69b          	sraiw	a3,s1,0x1f
    56c8:	9f95                	subw	a5,a5,a3
    56ca:	0307871b          	addiw	a4,a5,48
    56ce:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    56d2:	3e800713          	li	a4,1000
    56d6:	02f707bb          	mulw	a5,a4,a5
    56da:	40f487bb          	subw	a5,s1,a5
    56de:	03578733          	mul	a4,a5,s5
    56e2:	9715                	srai	a4,a4,0x25
    56e4:	41f7d79b          	sraiw	a5,a5,0x1f
    56e8:	40f707bb          	subw	a5,a4,a5
    56ec:	0307879b          	addiw	a5,a5,48
    56f0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    56f4:	035487b3          	mul	a5,s1,s5
    56f8:	9795                	srai	a5,a5,0x25
    56fa:	9f95                	subw	a5,a5,a3
    56fc:	06400713          	li	a4,100
    5700:	02f707bb          	mulw	a5,a4,a5
    5704:	40f487bb          	subw	a5,s1,a5
    5708:	03478733          	mul	a4,a5,s4
    570c:	9709                	srai	a4,a4,0x22
    570e:	41f7d79b          	sraiw	a5,a5,0x1f
    5712:	40f707bb          	subw	a5,a4,a5
    5716:	0307879b          	addiw	a5,a5,48
    571a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    571e:	03448733          	mul	a4,s1,s4
    5722:	9709                	srai	a4,a4,0x22
    5724:	9f15                	subw	a4,a4,a3
    5726:	0027179b          	slliw	a5,a4,0x2
    572a:	9fb9                	addw	a5,a5,a4
    572c:	0017979b          	slliw	a5,a5,0x1
    5730:	40f487bb          	subw	a5,s1,a5
    5734:	0307879b          	addiw	a5,a5,48
    5738:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    573c:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5740:	85ea                	mv	a1,s10
    5742:	00003517          	auipc	a0,0x3
    5746:	cd650513          	addi	a0,a0,-810 # 8418 <malloc+0x1f74>
    574a:	00001097          	auipc	ra,0x1
    574e:	c9e080e7          	jalr	-866(ra) # 63e8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5752:	20200593          	li	a1,514
    5756:	856a                	mv	a0,s10
    5758:	00001097          	auipc	ra,0x1
    575c:	86e080e7          	jalr	-1938(ra) # 5fc6 <open>
    5760:	892a                	mv	s2,a0
    if(fd < 0){
    5762:	0e055e63          	bgez	a0,585e <fsfull+0x1f4>
      printf("open %s failed\n", name);
    5766:	f5040593          	addi	a1,s0,-176
    576a:	00003517          	auipc	a0,0x3
    576e:	cbe50513          	addi	a0,a0,-834 # 8428 <malloc+0x1f84>
    5772:	00001097          	auipc	ra,0x1
    5776:	c76080e7          	jalr	-906(ra) # 63e8 <printf>
    name[0] = 'f';
    577a:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    577e:	10625a37          	lui	s4,0x10625
    5782:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061415b>
    name[2] = '0' + (nfiles % 1000) / 100;
    5786:	3e800b93          	li	s7,1000
    578a:	51eb89b7          	lui	s3,0x51eb8
    578e:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea78a7>
    name[3] = '0' + (nfiles % 100) / 10;
    5792:	06400b13          	li	s6,100
    5796:	66666937          	lui	s2,0x66666
    579a:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666559ef>
    unlink(name);
    579e:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    57a2:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    57a6:	034487b3          	mul	a5,s1,s4
    57aa:	9799                	srai	a5,a5,0x26
    57ac:	41f4d69b          	sraiw	a3,s1,0x1f
    57b0:	9f95                	subw	a5,a5,a3
    57b2:	0307871b          	addiw	a4,a5,48
    57b6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    57ba:	02fb87bb          	mulw	a5,s7,a5
    57be:	40f487bb          	subw	a5,s1,a5
    57c2:	03378733          	mul	a4,a5,s3
    57c6:	9715                	srai	a4,a4,0x25
    57c8:	41f7d79b          	sraiw	a5,a5,0x1f
    57cc:	40f707bb          	subw	a5,a4,a5
    57d0:	0307879b          	addiw	a5,a5,48
    57d4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    57d8:	033487b3          	mul	a5,s1,s3
    57dc:	9795                	srai	a5,a5,0x25
    57de:	9f95                	subw	a5,a5,a3
    57e0:	02fb07bb          	mulw	a5,s6,a5
    57e4:	40f487bb          	subw	a5,s1,a5
    57e8:	03278733          	mul	a4,a5,s2
    57ec:	9709                	srai	a4,a4,0x22
    57ee:	41f7d79b          	sraiw	a5,a5,0x1f
    57f2:	40f707bb          	subw	a5,a4,a5
    57f6:	0307879b          	addiw	a5,a5,48
    57fa:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    57fe:	03248733          	mul	a4,s1,s2
    5802:	9709                	srai	a4,a4,0x22
    5804:	9f15                	subw	a4,a4,a3
    5806:	0027179b          	slliw	a5,a4,0x2
    580a:	9fb9                	addw	a5,a5,a4
    580c:	0017979b          	slliw	a5,a5,0x1
    5810:	40f487bb          	subw	a5,s1,a5
    5814:	0307879b          	addiw	a5,a5,48
    5818:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    581c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5820:	8556                	mv	a0,s5
    5822:	00000097          	auipc	ra,0x0
    5826:	7b4080e7          	jalr	1972(ra) # 5fd6 <unlink>
    nfiles--;
    582a:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    582c:	f604dbe3          	bgez	s1,57a2 <fsfull+0x138>
  printf("fsfull test finished\n");
    5830:	00003517          	auipc	a0,0x3
    5834:	c1850513          	addi	a0,a0,-1000 # 8448 <malloc+0x1fa4>
    5838:	00001097          	auipc	ra,0x1
    583c:	bb0080e7          	jalr	-1104(ra) # 63e8 <printf>
}
    5840:	70aa                	ld	ra,168(sp)
    5842:	740a                	ld	s0,160(sp)
    5844:	64ea                	ld	s1,152(sp)
    5846:	694a                	ld	s2,144(sp)
    5848:	69aa                	ld	s3,136(sp)
    584a:	6a0a                	ld	s4,128(sp)
    584c:	7ae6                	ld	s5,120(sp)
    584e:	7b46                	ld	s6,112(sp)
    5850:	7ba6                	ld	s7,104(sp)
    5852:	7c06                	ld	s8,96(sp)
    5854:	6ce6                	ld	s9,88(sp)
    5856:	6d46                	ld	s10,80(sp)
    5858:	6da6                	ld	s11,72(sp)
    585a:	614d                	addi	sp,sp,176
    585c:	8082                	ret
    int total = 0;
    585e:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    5860:	40000c13          	li	s8,1024
    5864:	00008b97          	auipc	s7,0x8
    5868:	414b8b93          	addi	s7,s7,1044 # dc78 <buf>
      if(cc < BSIZE)
    586c:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    5870:	8662                	mv	a2,s8
    5872:	85de                	mv	a1,s7
    5874:	854a                	mv	a0,s2
    5876:	00000097          	auipc	ra,0x0
    587a:	730080e7          	jalr	1840(ra) # 5fa6 <write>
      if(cc < BSIZE)
    587e:	00ab5563          	bge	s6,a0,5888 <fsfull+0x21e>
      total += cc;
    5882:	00a989bb          	addw	s3,s3,a0
    while(1){
    5886:	b7ed                	j	5870 <fsfull+0x206>
    printf("wrote %d bytes\n", total);
    5888:	85ce                	mv	a1,s3
    588a:	00003517          	auipc	a0,0x3
    588e:	bae50513          	addi	a0,a0,-1106 # 8438 <malloc+0x1f94>
    5892:	00001097          	auipc	ra,0x1
    5896:	b56080e7          	jalr	-1194(ra) # 63e8 <printf>
    close(fd);
    589a:	854a                	mv	a0,s2
    589c:	00000097          	auipc	ra,0x0
    58a0:	712080e7          	jalr	1810(ra) # 5fae <close>
    if(total == 0)
    58a4:	ec098be3          	beqz	s3,577a <fsfull+0x110>
  for(nfiles = 0; ; nfiles++){
    58a8:	2485                	addiw	s1,s1,1
    58aa:	bd01                	j	56ba <fsfull+0x50>

00000000000058ac <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    58ac:	7179                	addi	sp,sp,-48
    58ae:	f406                	sd	ra,40(sp)
    58b0:	f022                	sd	s0,32(sp)
    58b2:	ec26                	sd	s1,24(sp)
    58b4:	e84a                	sd	s2,16(sp)
    58b6:	1800                	addi	s0,sp,48
    58b8:	84aa                	mv	s1,a0
    58ba:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    58bc:	00003517          	auipc	a0,0x3
    58c0:	ba450513          	addi	a0,a0,-1116 # 8460 <malloc+0x1fbc>
    58c4:	00001097          	auipc	ra,0x1
    58c8:	b24080e7          	jalr	-1244(ra) # 63e8 <printf>
  if((pid = fork()) < 0) {
    58cc:	00000097          	auipc	ra,0x0
    58d0:	6b2080e7          	jalr	1714(ra) # 5f7e <fork>
    58d4:	02054e63          	bltz	a0,5910 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    58d8:	c929                	beqz	a0,592a <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    58da:	fdc40513          	addi	a0,s0,-36
    58de:	00000097          	auipc	ra,0x0
    58e2:	6b0080e7          	jalr	1712(ra) # 5f8e <wait>
    if(xstatus != 0) 
    58e6:	fdc42783          	lw	a5,-36(s0)
    58ea:	c7b9                	beqz	a5,5938 <run+0x8c>
      printf("FAILED\n");
    58ec:	00003517          	auipc	a0,0x3
    58f0:	b9c50513          	addi	a0,a0,-1124 # 8488 <malloc+0x1fe4>
    58f4:	00001097          	auipc	ra,0x1
    58f8:	af4080e7          	jalr	-1292(ra) # 63e8 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    58fc:	fdc42503          	lw	a0,-36(s0)
  }
}
    5900:	00153513          	seqz	a0,a0
    5904:	70a2                	ld	ra,40(sp)
    5906:	7402                	ld	s0,32(sp)
    5908:	64e2                	ld	s1,24(sp)
    590a:	6942                	ld	s2,16(sp)
    590c:	6145                	addi	sp,sp,48
    590e:	8082                	ret
    printf("runtest: fork error\n");
    5910:	00003517          	auipc	a0,0x3
    5914:	b6050513          	addi	a0,a0,-1184 # 8470 <malloc+0x1fcc>
    5918:	00001097          	auipc	ra,0x1
    591c:	ad0080e7          	jalr	-1328(ra) # 63e8 <printf>
    exit(1);
    5920:	4505                	li	a0,1
    5922:	00000097          	auipc	ra,0x0
    5926:	664080e7          	jalr	1636(ra) # 5f86 <exit>
    f(s);
    592a:	854a                	mv	a0,s2
    592c:	9482                	jalr	s1
    exit(0);
    592e:	4501                	li	a0,0
    5930:	00000097          	auipc	ra,0x0
    5934:	656080e7          	jalr	1622(ra) # 5f86 <exit>
      printf("OK\n");
    5938:	00003517          	auipc	a0,0x3
    593c:	b5850513          	addi	a0,a0,-1192 # 8490 <malloc+0x1fec>
    5940:	00001097          	auipc	ra,0x1
    5944:	aa8080e7          	jalr	-1368(ra) # 63e8 <printf>
    5948:	bf55                	j	58fc <run+0x50>

000000000000594a <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    594a:	7179                	addi	sp,sp,-48
    594c:	f406                	sd	ra,40(sp)
    594e:	f022                	sd	s0,32(sp)
    5950:	ec26                	sd	s1,24(sp)
    5952:	1800                	addi	s0,sp,48
    5954:	84aa                	mv	s1,a0
  for (struct test *t = tests; t->s != 0; t++) {
    5956:	6508                	ld	a0,8(a0)
    5958:	c12d                	beqz	a0,59ba <runtests+0x70>
    595a:	e84a                	sd	s2,16(sp)
    595c:	e44e                	sd	s3,8(sp)
    595e:	e052                	sd	s4,0(sp)
    5960:	892e                	mv	s2,a1
    5962:	89b2                	mv	s3,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    5964:	4a09                	li	s4,2
    5966:	a021                	j	596e <runtests+0x24>
  for (struct test *t = tests; t->s != 0; t++) {
    5968:	04c1                	addi	s1,s1,16
    596a:	6488                	ld	a0,8(s1)
    596c:	cd1d                	beqz	a0,59aa <runtests+0x60>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    596e:	00090863          	beqz	s2,597e <runtests+0x34>
    5972:	85ca                	mv	a1,s2
    5974:	00000097          	auipc	ra,0x0
    5978:	392080e7          	jalr	914(ra) # 5d06 <strcmp>
    597c:	f575                	bnez	a0,5968 <runtests+0x1e>
      if(!run(t->f, t->s)){
    597e:	648c                	ld	a1,8(s1)
    5980:	6088                	ld	a0,0(s1)
    5982:	00000097          	auipc	ra,0x0
    5986:	f2a080e7          	jalr	-214(ra) # 58ac <run>
    598a:	fd79                	bnez	a0,5968 <runtests+0x1e>
        if(continuous != 2){
    598c:	fd498ee3          	beq	s3,s4,5968 <runtests+0x1e>
          printf("SOME TESTS FAILED\n");
    5990:	00003517          	auipc	a0,0x3
    5994:	b0850513          	addi	a0,a0,-1272 # 8498 <malloc+0x1ff4>
    5998:	00001097          	auipc	ra,0x1
    599c:	a50080e7          	jalr	-1456(ra) # 63e8 <printf>
          return 1;
    59a0:	4505                	li	a0,1
    59a2:	6942                	ld	s2,16(sp)
    59a4:	69a2                	ld	s3,8(sp)
    59a6:	6a02                	ld	s4,0(sp)
    59a8:	a021                	j	59b0 <runtests+0x66>
    59aa:	6942                	ld	s2,16(sp)
    59ac:	69a2                	ld	s3,8(sp)
    59ae:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return 0;
}
    59b0:	70a2                	ld	ra,40(sp)
    59b2:	7402                	ld	s0,32(sp)
    59b4:	64e2                	ld	s1,24(sp)
    59b6:	6145                	addi	sp,sp,48
    59b8:	8082                	ret
  return 0;
    59ba:	4501                	li	a0,0
    59bc:	bfd5                	j	59b0 <runtests+0x66>

00000000000059be <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    59be:	7139                	addi	sp,sp,-64
    59c0:	fc06                	sd	ra,56(sp)
    59c2:	f822                	sd	s0,48(sp)
    59c4:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    59c6:	fc840513          	addi	a0,s0,-56
    59ca:	00000097          	auipc	ra,0x0
    59ce:	5cc080e7          	jalr	1484(ra) # 5f96 <pipe>
    59d2:	06054b63          	bltz	a0,5a48 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    59d6:	00000097          	auipc	ra,0x0
    59da:	5a8080e7          	jalr	1448(ra) # 5f7e <fork>

  if(pid < 0){
    59de:	08054663          	bltz	a0,5a6a <countfree+0xac>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    59e2:	e955                	bnez	a0,5a96 <countfree+0xd8>
    59e4:	f426                	sd	s1,40(sp)
    59e6:	f04a                	sd	s2,32(sp)
    59e8:	ec4e                	sd	s3,24(sp)
    59ea:	e852                	sd	s4,16(sp)
    close(fds[0]);
    59ec:	fc842503          	lw	a0,-56(s0)
    59f0:	00000097          	auipc	ra,0x0
    59f4:	5be080e7          	jalr	1470(ra) # 5fae <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    59f8:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    59fa:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    59fc:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    59fe:	00001a17          	auipc	s4,0x1
    5a02:	c4aa0a13          	addi	s4,s4,-950 # 6648 <malloc+0x1a4>
      uint64 a = (uint64) sbrk(4096);
    5a06:	854a                	mv	a0,s2
    5a08:	00000097          	auipc	ra,0x0
    5a0c:	606080e7          	jalr	1542(ra) # 600e <sbrk>
      if(a == 0xffffffffffffffff){
    5a10:	07350e63          	beq	a0,s3,5a8c <countfree+0xce>
      *(char *)(a + 4096 - 1) = 1;
    5a14:	954a                	add	a0,a0,s2
    5a16:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    5a1a:	8626                	mv	a2,s1
    5a1c:	85d2                	mv	a1,s4
    5a1e:	fcc42503          	lw	a0,-52(s0)
    5a22:	00000097          	auipc	ra,0x0
    5a26:	584080e7          	jalr	1412(ra) # 5fa6 <write>
    5a2a:	fc950ee3          	beq	a0,s1,5a06 <countfree+0x48>
        printf("write() failed in countfree()\n");
    5a2e:	00003517          	auipc	a0,0x3
    5a32:	ac250513          	addi	a0,a0,-1342 # 84f0 <malloc+0x204c>
    5a36:	00001097          	auipc	ra,0x1
    5a3a:	9b2080e7          	jalr	-1614(ra) # 63e8 <printf>
        exit(1);
    5a3e:	4505                	li	a0,1
    5a40:	00000097          	auipc	ra,0x0
    5a44:	546080e7          	jalr	1350(ra) # 5f86 <exit>
    5a48:	f426                	sd	s1,40(sp)
    5a4a:	f04a                	sd	s2,32(sp)
    5a4c:	ec4e                	sd	s3,24(sp)
    5a4e:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    5a50:	00003517          	auipc	a0,0x3
    5a54:	a6050513          	addi	a0,a0,-1440 # 84b0 <malloc+0x200c>
    5a58:	00001097          	auipc	ra,0x1
    5a5c:	990080e7          	jalr	-1648(ra) # 63e8 <printf>
    exit(1);
    5a60:	4505                	li	a0,1
    5a62:	00000097          	auipc	ra,0x0
    5a66:	524080e7          	jalr	1316(ra) # 5f86 <exit>
    5a6a:	f426                	sd	s1,40(sp)
    5a6c:	f04a                	sd	s2,32(sp)
    5a6e:	ec4e                	sd	s3,24(sp)
    5a70:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    5a72:	00003517          	auipc	a0,0x3
    5a76:	a5e50513          	addi	a0,a0,-1442 # 84d0 <malloc+0x202c>
    5a7a:	00001097          	auipc	ra,0x1
    5a7e:	96e080e7          	jalr	-1682(ra) # 63e8 <printf>
    exit(1);
    5a82:	4505                	li	a0,1
    5a84:	00000097          	auipc	ra,0x0
    5a88:	502080e7          	jalr	1282(ra) # 5f86 <exit>
      }
    }

    exit(0);
    5a8c:	4501                	li	a0,0
    5a8e:	00000097          	auipc	ra,0x0
    5a92:	4f8080e7          	jalr	1272(ra) # 5f86 <exit>
    5a96:	f426                	sd	s1,40(sp)
    5a98:	f04a                	sd	s2,32(sp)
    5a9a:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    5a9c:	fcc42503          	lw	a0,-52(s0)
    5aa0:	00000097          	auipc	ra,0x0
    5aa4:	50e080e7          	jalr	1294(ra) # 5fae <close>

  int n = 0;
    5aa8:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5aaa:	fc740993          	addi	s3,s0,-57
    5aae:	4905                	li	s2,1
    5ab0:	864a                	mv	a2,s2
    5ab2:	85ce                	mv	a1,s3
    5ab4:	fc842503          	lw	a0,-56(s0)
    5ab8:	00000097          	auipc	ra,0x0
    5abc:	4e6080e7          	jalr	1254(ra) # 5f9e <read>
    if(cc < 0){
    5ac0:	00054563          	bltz	a0,5aca <countfree+0x10c>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5ac4:	c10d                	beqz	a0,5ae6 <countfree+0x128>
      break;
    n += 1;
    5ac6:	2485                	addiw	s1,s1,1
  while(1){
    5ac8:	b7e5                	j	5ab0 <countfree+0xf2>
    5aca:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    5acc:	00003517          	auipc	a0,0x3
    5ad0:	a4450513          	addi	a0,a0,-1468 # 8510 <malloc+0x206c>
    5ad4:	00001097          	auipc	ra,0x1
    5ad8:	914080e7          	jalr	-1772(ra) # 63e8 <printf>
      exit(1);
    5adc:	4505                	li	a0,1
    5ade:	00000097          	auipc	ra,0x0
    5ae2:	4a8080e7          	jalr	1192(ra) # 5f86 <exit>
  }

  close(fds[0]);
    5ae6:	fc842503          	lw	a0,-56(s0)
    5aea:	00000097          	auipc	ra,0x0
    5aee:	4c4080e7          	jalr	1220(ra) # 5fae <close>
  wait((int*)0);
    5af2:	4501                	li	a0,0
    5af4:	00000097          	auipc	ra,0x0
    5af8:	49a080e7          	jalr	1178(ra) # 5f8e <wait>
  
  return n;
}
    5afc:	8526                	mv	a0,s1
    5afe:	74a2                	ld	s1,40(sp)
    5b00:	7902                	ld	s2,32(sp)
    5b02:	69e2                	ld	s3,24(sp)
    5b04:	70e2                	ld	ra,56(sp)
    5b06:	7442                	ld	s0,48(sp)
    5b08:	6121                	addi	sp,sp,64
    5b0a:	8082                	ret

0000000000005b0c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5b0c:	711d                	addi	sp,sp,-96
    5b0e:	ec86                	sd	ra,88(sp)
    5b10:	e8a2                	sd	s0,80(sp)
    5b12:	e4a6                	sd	s1,72(sp)
    5b14:	e0ca                	sd	s2,64(sp)
    5b16:	fc4e                	sd	s3,56(sp)
    5b18:	f852                	sd	s4,48(sp)
    5b1a:	f456                	sd	s5,40(sp)
    5b1c:	f05a                	sd	s6,32(sp)
    5b1e:	ec5e                	sd	s7,24(sp)
    5b20:	e862                	sd	s8,16(sp)
    5b22:	e466                	sd	s9,8(sp)
    5b24:	e06a                	sd	s10,0(sp)
    5b26:	1080                	addi	s0,sp,96
    5b28:	8aaa                	mv	s5,a0
    5b2a:	892e                	mv	s2,a1
    5b2c:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    5b2e:	00003b97          	auipc	s7,0x3
    5b32:	a02b8b93          	addi	s7,s7,-1534 # 8530 <malloc+0x208c>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    5b36:	00004b17          	auipc	s6,0x4
    5b3a:	4dab0b13          	addi	s6,s6,1242 # a010 <quicktests>
      if(continuous != 2) {
    5b3e:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    5b40:	00005c17          	auipc	s8,0x5
    5b44:	8a0c0c13          	addi	s8,s8,-1888 # a3e0 <slowtests>
        printf("usertests slow tests starting\n");
    5b48:	00003d17          	auipc	s10,0x3
    5b4c:	a00d0d13          	addi	s10,s10,-1536 # 8548 <malloc+0x20a4>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5b50:	00003c97          	auipc	s9,0x3
    5b54:	a18c8c93          	addi	s9,s9,-1512 # 8568 <malloc+0x20c4>
    5b58:	a839                	j	5b76 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    5b5a:	856a                	mv	a0,s10
    5b5c:	00001097          	auipc	ra,0x1
    5b60:	88c080e7          	jalr	-1908(ra) # 63e8 <printf>
    5b64:	a089                	j	5ba6 <drivetests+0x9a>
    if((free1 = countfree()) < free0) {
    5b66:	00000097          	auipc	ra,0x0
    5b6a:	e58080e7          	jalr	-424(ra) # 59be <countfree>
    5b6e:	04954863          	blt	a0,s1,5bbe <drivetests+0xb2>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    5b72:	06090363          	beqz	s2,5bd8 <drivetests+0xcc>
    printf("usertests starting\n");
    5b76:	855e                	mv	a0,s7
    5b78:	00001097          	auipc	ra,0x1
    5b7c:	870080e7          	jalr	-1936(ra) # 63e8 <printf>
    int free0 = countfree();
    5b80:	00000097          	auipc	ra,0x0
    5b84:	e3e080e7          	jalr	-450(ra) # 59be <countfree>
    5b88:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    5b8a:	864a                	mv	a2,s2
    5b8c:	85ce                	mv	a1,s3
    5b8e:	855a                	mv	a0,s6
    5b90:	00000097          	auipc	ra,0x0
    5b94:	dba080e7          	jalr	-582(ra) # 594a <runtests>
    5b98:	c119                	beqz	a0,5b9e <drivetests+0x92>
      if(continuous != 2) {
    5b9a:	03491d63          	bne	s2,s4,5bd4 <drivetests+0xc8>
    if(!quick) {
    5b9e:	fc0a94e3          	bnez	s5,5b66 <drivetests+0x5a>
      if (justone == 0)
    5ba2:	fa098ce3          	beqz	s3,5b5a <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    5ba6:	864a                	mv	a2,s2
    5ba8:	85ce                	mv	a1,s3
    5baa:	8562                	mv	a0,s8
    5bac:	00000097          	auipc	ra,0x0
    5bb0:	d9e080e7          	jalr	-610(ra) # 594a <runtests>
    5bb4:	d94d                	beqz	a0,5b66 <drivetests+0x5a>
        if(continuous != 2) {
    5bb6:	fb4908e3          	beq	s2,s4,5b66 <drivetests+0x5a>
          return 1;
    5bba:	4505                	li	a0,1
    5bbc:	a839                	j	5bda <drivetests+0xce>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5bbe:	8626                	mv	a2,s1
    5bc0:	85aa                	mv	a1,a0
    5bc2:	8566                	mv	a0,s9
    5bc4:	00001097          	auipc	ra,0x1
    5bc8:	824080e7          	jalr	-2012(ra) # 63e8 <printf>
      if(continuous != 2) {
    5bcc:	fb4905e3          	beq	s2,s4,5b76 <drivetests+0x6a>
        return 1;
    5bd0:	4505                	li	a0,1
    5bd2:	a021                	j	5bda <drivetests+0xce>
        return 1;
    5bd4:	4505                	li	a0,1
    5bd6:	a011                	j	5bda <drivetests+0xce>
  return 0;
    5bd8:	854a                	mv	a0,s2
}
    5bda:	60e6                	ld	ra,88(sp)
    5bdc:	6446                	ld	s0,80(sp)
    5bde:	64a6                	ld	s1,72(sp)
    5be0:	6906                	ld	s2,64(sp)
    5be2:	79e2                	ld	s3,56(sp)
    5be4:	7a42                	ld	s4,48(sp)
    5be6:	7aa2                	ld	s5,40(sp)
    5be8:	7b02                	ld	s6,32(sp)
    5bea:	6be2                	ld	s7,24(sp)
    5bec:	6c42                	ld	s8,16(sp)
    5bee:	6ca2                	ld	s9,8(sp)
    5bf0:	6d02                	ld	s10,0(sp)
    5bf2:	6125                	addi	sp,sp,96
    5bf4:	8082                	ret

0000000000005bf6 <main>:

int
main(int argc, char *argv[])
{
    5bf6:	1101                	addi	sp,sp,-32
    5bf8:	ec06                	sd	ra,24(sp)
    5bfa:	e822                	sd	s0,16(sp)
    5bfc:	e426                	sd	s1,8(sp)
    5bfe:	e04a                	sd	s2,0(sp)
    5c00:	1000                	addi	s0,sp,32
    5c02:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5c04:	4789                	li	a5,2
    5c06:	02f50263          	beq	a0,a5,5c2a <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5c0a:	4785                	li	a5,1
    5c0c:	08a7c063          	blt	a5,a0,5c8c <main+0x96>
  char *justone = 0;
    5c10:	4601                	li	a2,0
  int quick = 0;
    5c12:	4501                	li	a0,0
  int continuous = 0;
    5c14:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5c16:	00000097          	auipc	ra,0x0
    5c1a:	ef6080e7          	jalr	-266(ra) # 5b0c <drivetests>
    5c1e:	c951                	beqz	a0,5cb2 <main+0xbc>
    exit(1);
    5c20:	4505                	li	a0,1
    5c22:	00000097          	auipc	ra,0x0
    5c26:	364080e7          	jalr	868(ra) # 5f86 <exit>
    5c2a:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5c2c:	00003597          	auipc	a1,0x3
    5c30:	96c58593          	addi	a1,a1,-1684 # 8598 <malloc+0x20f4>
    5c34:	00893503          	ld	a0,8(s2) # 1008 <linktest+0x54>
    5c38:	00000097          	auipc	ra,0x0
    5c3c:	0ce080e7          	jalr	206(ra) # 5d06 <strcmp>
    5c40:	85aa                	mv	a1,a0
    5c42:	e501                	bnez	a0,5c4a <main+0x54>
  char *justone = 0;
    5c44:	4601                	li	a2,0
    quick = 1;
    5c46:	4505                	li	a0,1
    5c48:	b7f9                	j	5c16 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5c4a:	00003597          	auipc	a1,0x3
    5c4e:	95658593          	addi	a1,a1,-1706 # 85a0 <malloc+0x20fc>
    5c52:	00893503          	ld	a0,8(s2)
    5c56:	00000097          	auipc	ra,0x0
    5c5a:	0b0080e7          	jalr	176(ra) # 5d06 <strcmp>
    5c5e:	c521                	beqz	a0,5ca6 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5c60:	00003597          	auipc	a1,0x3
    5c64:	99058593          	addi	a1,a1,-1648 # 85f0 <malloc+0x214c>
    5c68:	00893503          	ld	a0,8(s2)
    5c6c:	00000097          	auipc	ra,0x0
    5c70:	09a080e7          	jalr	154(ra) # 5d06 <strcmp>
    5c74:	cd05                	beqz	a0,5cac <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5c76:	00893603          	ld	a2,8(s2)
    5c7a:	00064703          	lbu	a4,0(a2) # 3000 <sbrklast+0xa8>
    5c7e:	02d00793          	li	a5,45
    5c82:	00f70563          	beq	a4,a5,5c8c <main+0x96>
  int quick = 0;
    5c86:	4501                	li	a0,0
  int continuous = 0;
    5c88:	4581                	li	a1,0
    5c8a:	b771                	j	5c16 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5c8c:	00003517          	auipc	a0,0x3
    5c90:	91c50513          	addi	a0,a0,-1764 # 85a8 <malloc+0x2104>
    5c94:	00000097          	auipc	ra,0x0
    5c98:	754080e7          	jalr	1876(ra) # 63e8 <printf>
    exit(1);
    5c9c:	4505                	li	a0,1
    5c9e:	00000097          	auipc	ra,0x0
    5ca2:	2e8080e7          	jalr	744(ra) # 5f86 <exit>
  char *justone = 0;
    5ca6:	4601                	li	a2,0
    continuous = 1;
    5ca8:	4585                	li	a1,1
    5caa:	b7b5                	j	5c16 <main+0x20>
    continuous = 2;
    5cac:	85a6                	mv	a1,s1
  char *justone = 0;
    5cae:	4601                	li	a2,0
    5cb0:	b79d                	j	5c16 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5cb2:	00003517          	auipc	a0,0x3
    5cb6:	92650513          	addi	a0,a0,-1754 # 85d8 <malloc+0x2134>
    5cba:	00000097          	auipc	ra,0x0
    5cbe:	72e080e7          	jalr	1838(ra) # 63e8 <printf>
  exit(0);
    5cc2:	4501                	li	a0,0
    5cc4:	00000097          	auipc	ra,0x0
    5cc8:	2c2080e7          	jalr	706(ra) # 5f86 <exit>

0000000000005ccc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    5ccc:	1141                	addi	sp,sp,-16
    5cce:	e406                	sd	ra,8(sp)
    5cd0:	e022                	sd	s0,0(sp)
    5cd2:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5cd4:	00000097          	auipc	ra,0x0
    5cd8:	f22080e7          	jalr	-222(ra) # 5bf6 <main>
  exit(0);
    5cdc:	4501                	li	a0,0
    5cde:	00000097          	auipc	ra,0x0
    5ce2:	2a8080e7          	jalr	680(ra) # 5f86 <exit>

0000000000005ce6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5ce6:	1141                	addi	sp,sp,-16
    5ce8:	e406                	sd	ra,8(sp)
    5cea:	e022                	sd	s0,0(sp)
    5cec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5cee:	87aa                	mv	a5,a0
    5cf0:	0585                	addi	a1,a1,1
    5cf2:	0785                	addi	a5,a5,1
    5cf4:	fff5c703          	lbu	a4,-1(a1)
    5cf8:	fee78fa3          	sb	a4,-1(a5)
    5cfc:	fb75                	bnez	a4,5cf0 <strcpy+0xa>
    ;
  return os;
}
    5cfe:	60a2                	ld	ra,8(sp)
    5d00:	6402                	ld	s0,0(sp)
    5d02:	0141                	addi	sp,sp,16
    5d04:	8082                	ret

0000000000005d06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5d06:	1141                	addi	sp,sp,-16
    5d08:	e406                	sd	ra,8(sp)
    5d0a:	e022                	sd	s0,0(sp)
    5d0c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5d0e:	00054783          	lbu	a5,0(a0)
    5d12:	cb91                	beqz	a5,5d26 <strcmp+0x20>
    5d14:	0005c703          	lbu	a4,0(a1)
    5d18:	00f71763          	bne	a4,a5,5d26 <strcmp+0x20>
    p++, q++;
    5d1c:	0505                	addi	a0,a0,1
    5d1e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5d20:	00054783          	lbu	a5,0(a0)
    5d24:	fbe5                	bnez	a5,5d14 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    5d26:	0005c503          	lbu	a0,0(a1)
}
    5d2a:	40a7853b          	subw	a0,a5,a0
    5d2e:	60a2                	ld	ra,8(sp)
    5d30:	6402                	ld	s0,0(sp)
    5d32:	0141                	addi	sp,sp,16
    5d34:	8082                	ret

0000000000005d36 <strlen>:

uint
strlen(const char *s)
{
    5d36:	1141                	addi	sp,sp,-16
    5d38:	e406                	sd	ra,8(sp)
    5d3a:	e022                	sd	s0,0(sp)
    5d3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5d3e:	00054783          	lbu	a5,0(a0)
    5d42:	cf99                	beqz	a5,5d60 <strlen+0x2a>
    5d44:	0505                	addi	a0,a0,1
    5d46:	87aa                	mv	a5,a0
    5d48:	86be                	mv	a3,a5
    5d4a:	0785                	addi	a5,a5,1
    5d4c:	fff7c703          	lbu	a4,-1(a5)
    5d50:	ff65                	bnez	a4,5d48 <strlen+0x12>
    5d52:	40a6853b          	subw	a0,a3,a0
    5d56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    5d58:	60a2                	ld	ra,8(sp)
    5d5a:	6402                	ld	s0,0(sp)
    5d5c:	0141                	addi	sp,sp,16
    5d5e:	8082                	ret
  for(n = 0; s[n]; n++)
    5d60:	4501                	li	a0,0
    5d62:	bfdd                	j	5d58 <strlen+0x22>

0000000000005d64 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5d64:	1141                	addi	sp,sp,-16
    5d66:	e406                	sd	ra,8(sp)
    5d68:	e022                	sd	s0,0(sp)
    5d6a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5d6c:	ca19                	beqz	a2,5d82 <memset+0x1e>
    5d6e:	87aa                	mv	a5,a0
    5d70:	1602                	slli	a2,a2,0x20
    5d72:	9201                	srli	a2,a2,0x20
    5d74:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5d78:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5d7c:	0785                	addi	a5,a5,1
    5d7e:	fee79de3          	bne	a5,a4,5d78 <memset+0x14>
  }
  return dst;
}
    5d82:	60a2                	ld	ra,8(sp)
    5d84:	6402                	ld	s0,0(sp)
    5d86:	0141                	addi	sp,sp,16
    5d88:	8082                	ret

0000000000005d8a <strchr>:

char*
strchr(const char *s, char c)
{
    5d8a:	1141                	addi	sp,sp,-16
    5d8c:	e406                	sd	ra,8(sp)
    5d8e:	e022                	sd	s0,0(sp)
    5d90:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5d92:	00054783          	lbu	a5,0(a0)
    5d96:	cf81                	beqz	a5,5dae <strchr+0x24>
    if(*s == c)
    5d98:	00f58763          	beq	a1,a5,5da6 <strchr+0x1c>
  for(; *s; s++)
    5d9c:	0505                	addi	a0,a0,1
    5d9e:	00054783          	lbu	a5,0(a0)
    5da2:	fbfd                	bnez	a5,5d98 <strchr+0xe>
      return (char*)s;
  return 0;
    5da4:	4501                	li	a0,0
}
    5da6:	60a2                	ld	ra,8(sp)
    5da8:	6402                	ld	s0,0(sp)
    5daa:	0141                	addi	sp,sp,16
    5dac:	8082                	ret
  return 0;
    5dae:	4501                	li	a0,0
    5db0:	bfdd                	j	5da6 <strchr+0x1c>

0000000000005db2 <gets>:

char*
gets(char *buf, int max)
{
    5db2:	7159                	addi	sp,sp,-112
    5db4:	f486                	sd	ra,104(sp)
    5db6:	f0a2                	sd	s0,96(sp)
    5db8:	eca6                	sd	s1,88(sp)
    5dba:	e8ca                	sd	s2,80(sp)
    5dbc:	e4ce                	sd	s3,72(sp)
    5dbe:	e0d2                	sd	s4,64(sp)
    5dc0:	fc56                	sd	s5,56(sp)
    5dc2:	f85a                	sd	s6,48(sp)
    5dc4:	f45e                	sd	s7,40(sp)
    5dc6:	f062                	sd	s8,32(sp)
    5dc8:	ec66                	sd	s9,24(sp)
    5dca:	e86a                	sd	s10,16(sp)
    5dcc:	1880                	addi	s0,sp,112
    5dce:	8caa                	mv	s9,a0
    5dd0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5dd2:	892a                	mv	s2,a0
    5dd4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    5dd6:	f9f40b13          	addi	s6,s0,-97
    5dda:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5ddc:	4ba9                	li	s7,10
    5dde:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
    5de0:	8d26                	mv	s10,s1
    5de2:	0014899b          	addiw	s3,s1,1
    5de6:	84ce                	mv	s1,s3
    5de8:	0349d763          	bge	s3,s4,5e16 <gets+0x64>
    cc = read(0, &c, 1);
    5dec:	8656                	mv	a2,s5
    5dee:	85da                	mv	a1,s6
    5df0:	4501                	li	a0,0
    5df2:	00000097          	auipc	ra,0x0
    5df6:	1ac080e7          	jalr	428(ra) # 5f9e <read>
    if(cc < 1)
    5dfa:	00a05e63          	blez	a0,5e16 <gets+0x64>
    buf[i++] = c;
    5dfe:	f9f44783          	lbu	a5,-97(s0)
    5e02:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5e06:	01778763          	beq	a5,s7,5e14 <gets+0x62>
    5e0a:	0905                	addi	s2,s2,1
    5e0c:	fd879ae3          	bne	a5,s8,5de0 <gets+0x2e>
    buf[i++] = c;
    5e10:	8d4e                	mv	s10,s3
    5e12:	a011                	j	5e16 <gets+0x64>
    5e14:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
    5e16:	9d66                	add	s10,s10,s9
    5e18:	000d0023          	sb	zero,0(s10)
  return buf;
}
    5e1c:	8566                	mv	a0,s9
    5e1e:	70a6                	ld	ra,104(sp)
    5e20:	7406                	ld	s0,96(sp)
    5e22:	64e6                	ld	s1,88(sp)
    5e24:	6946                	ld	s2,80(sp)
    5e26:	69a6                	ld	s3,72(sp)
    5e28:	6a06                	ld	s4,64(sp)
    5e2a:	7ae2                	ld	s5,56(sp)
    5e2c:	7b42                	ld	s6,48(sp)
    5e2e:	7ba2                	ld	s7,40(sp)
    5e30:	7c02                	ld	s8,32(sp)
    5e32:	6ce2                	ld	s9,24(sp)
    5e34:	6d42                	ld	s10,16(sp)
    5e36:	6165                	addi	sp,sp,112
    5e38:	8082                	ret

0000000000005e3a <stat>:

int
stat(const char *n, struct stat *st)
{
    5e3a:	1101                	addi	sp,sp,-32
    5e3c:	ec06                	sd	ra,24(sp)
    5e3e:	e822                	sd	s0,16(sp)
    5e40:	e04a                	sd	s2,0(sp)
    5e42:	1000                	addi	s0,sp,32
    5e44:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5e46:	4581                	li	a1,0
    5e48:	00000097          	auipc	ra,0x0
    5e4c:	17e080e7          	jalr	382(ra) # 5fc6 <open>
  if(fd < 0)
    5e50:	02054663          	bltz	a0,5e7c <stat+0x42>
    5e54:	e426                	sd	s1,8(sp)
    5e56:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5e58:	85ca                	mv	a1,s2
    5e5a:	00000097          	auipc	ra,0x0
    5e5e:	184080e7          	jalr	388(ra) # 5fde <fstat>
    5e62:	892a                	mv	s2,a0
  close(fd);
    5e64:	8526                	mv	a0,s1
    5e66:	00000097          	auipc	ra,0x0
    5e6a:	148080e7          	jalr	328(ra) # 5fae <close>
  return r;
    5e6e:	64a2                	ld	s1,8(sp)
}
    5e70:	854a                	mv	a0,s2
    5e72:	60e2                	ld	ra,24(sp)
    5e74:	6442                	ld	s0,16(sp)
    5e76:	6902                	ld	s2,0(sp)
    5e78:	6105                	addi	sp,sp,32
    5e7a:	8082                	ret
    return -1;
    5e7c:	597d                	li	s2,-1
    5e7e:	bfcd                	j	5e70 <stat+0x36>

0000000000005e80 <atoi>:

int
atoi(const char *s)
{
    5e80:	1141                	addi	sp,sp,-16
    5e82:	e406                	sd	ra,8(sp)
    5e84:	e022                	sd	s0,0(sp)
    5e86:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5e88:	00054683          	lbu	a3,0(a0)
    5e8c:	fd06879b          	addiw	a5,a3,-48
    5e90:	0ff7f793          	zext.b	a5,a5
    5e94:	4625                	li	a2,9
    5e96:	02f66963          	bltu	a2,a5,5ec8 <atoi+0x48>
    5e9a:	872a                	mv	a4,a0
  n = 0;
    5e9c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5e9e:	0705                	addi	a4,a4,1
    5ea0:	0025179b          	slliw	a5,a0,0x2
    5ea4:	9fa9                	addw	a5,a5,a0
    5ea6:	0017979b          	slliw	a5,a5,0x1
    5eaa:	9fb5                	addw	a5,a5,a3
    5eac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5eb0:	00074683          	lbu	a3,0(a4)
    5eb4:	fd06879b          	addiw	a5,a3,-48
    5eb8:	0ff7f793          	zext.b	a5,a5
    5ebc:	fef671e3          	bgeu	a2,a5,5e9e <atoi+0x1e>
  return n;
}
    5ec0:	60a2                	ld	ra,8(sp)
    5ec2:	6402                	ld	s0,0(sp)
    5ec4:	0141                	addi	sp,sp,16
    5ec6:	8082                	ret
  n = 0;
    5ec8:	4501                	li	a0,0
    5eca:	bfdd                	j	5ec0 <atoi+0x40>

0000000000005ecc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5ecc:	1141                	addi	sp,sp,-16
    5ece:	e406                	sd	ra,8(sp)
    5ed0:	e022                	sd	s0,0(sp)
    5ed2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5ed4:	02b57563          	bgeu	a0,a1,5efe <memmove+0x32>
    while(n-- > 0)
    5ed8:	00c05f63          	blez	a2,5ef6 <memmove+0x2a>
    5edc:	1602                	slli	a2,a2,0x20
    5ede:	9201                	srli	a2,a2,0x20
    5ee0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5ee4:	872a                	mv	a4,a0
      *dst++ = *src++;
    5ee6:	0585                	addi	a1,a1,1
    5ee8:	0705                	addi	a4,a4,1
    5eea:	fff5c683          	lbu	a3,-1(a1)
    5eee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5ef2:	fee79ae3          	bne	a5,a4,5ee6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5ef6:	60a2                	ld	ra,8(sp)
    5ef8:	6402                	ld	s0,0(sp)
    5efa:	0141                	addi	sp,sp,16
    5efc:	8082                	ret
    dst += n;
    5efe:	00c50733          	add	a4,a0,a2
    src += n;
    5f02:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5f04:	fec059e3          	blez	a2,5ef6 <memmove+0x2a>
    5f08:	fff6079b          	addiw	a5,a2,-1
    5f0c:	1782                	slli	a5,a5,0x20
    5f0e:	9381                	srli	a5,a5,0x20
    5f10:	fff7c793          	not	a5,a5
    5f14:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5f16:	15fd                	addi	a1,a1,-1
    5f18:	177d                	addi	a4,a4,-1
    5f1a:	0005c683          	lbu	a3,0(a1)
    5f1e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5f22:	fef71ae3          	bne	a4,a5,5f16 <memmove+0x4a>
    5f26:	bfc1                	j	5ef6 <memmove+0x2a>

0000000000005f28 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5f28:	1141                	addi	sp,sp,-16
    5f2a:	e406                	sd	ra,8(sp)
    5f2c:	e022                	sd	s0,0(sp)
    5f2e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5f30:	ca0d                	beqz	a2,5f62 <memcmp+0x3a>
    5f32:	fff6069b          	addiw	a3,a2,-1
    5f36:	1682                	slli	a3,a3,0x20
    5f38:	9281                	srli	a3,a3,0x20
    5f3a:	0685                	addi	a3,a3,1
    5f3c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5f3e:	00054783          	lbu	a5,0(a0)
    5f42:	0005c703          	lbu	a4,0(a1)
    5f46:	00e79863          	bne	a5,a4,5f56 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
    5f4a:	0505                	addi	a0,a0,1
    p2++;
    5f4c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5f4e:	fed518e3          	bne	a0,a3,5f3e <memcmp+0x16>
  }
  return 0;
    5f52:	4501                	li	a0,0
    5f54:	a019                	j	5f5a <memcmp+0x32>
      return *p1 - *p2;
    5f56:	40e7853b          	subw	a0,a5,a4
}
    5f5a:	60a2                	ld	ra,8(sp)
    5f5c:	6402                	ld	s0,0(sp)
    5f5e:	0141                	addi	sp,sp,16
    5f60:	8082                	ret
  return 0;
    5f62:	4501                	li	a0,0
    5f64:	bfdd                	j	5f5a <memcmp+0x32>

0000000000005f66 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5f66:	1141                	addi	sp,sp,-16
    5f68:	e406                	sd	ra,8(sp)
    5f6a:	e022                	sd	s0,0(sp)
    5f6c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5f6e:	00000097          	auipc	ra,0x0
    5f72:	f5e080e7          	jalr	-162(ra) # 5ecc <memmove>
}
    5f76:	60a2                	ld	ra,8(sp)
    5f78:	6402                	ld	s0,0(sp)
    5f7a:	0141                	addi	sp,sp,16
    5f7c:	8082                	ret

0000000000005f7e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5f7e:	4885                	li	a7,1
 ecall
    5f80:	00000073          	ecall
 ret
    5f84:	8082                	ret

0000000000005f86 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5f86:	4889                	li	a7,2
 ecall
    5f88:	00000073          	ecall
 ret
    5f8c:	8082                	ret

0000000000005f8e <wait>:
.global wait
wait:
 li a7, SYS_wait
    5f8e:	488d                	li	a7,3
 ecall
    5f90:	00000073          	ecall
 ret
    5f94:	8082                	ret

0000000000005f96 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5f96:	4891                	li	a7,4
 ecall
    5f98:	00000073          	ecall
 ret
    5f9c:	8082                	ret

0000000000005f9e <read>:
.global read
read:
 li a7, SYS_read
    5f9e:	4895                	li	a7,5
 ecall
    5fa0:	00000073          	ecall
 ret
    5fa4:	8082                	ret

0000000000005fa6 <write>:
.global write
write:
 li a7, SYS_write
    5fa6:	48c1                	li	a7,16
 ecall
    5fa8:	00000073          	ecall
 ret
    5fac:	8082                	ret

0000000000005fae <close>:
.global close
close:
 li a7, SYS_close
    5fae:	48d5                	li	a7,21
 ecall
    5fb0:	00000073          	ecall
 ret
    5fb4:	8082                	ret

0000000000005fb6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5fb6:	4899                	li	a7,6
 ecall
    5fb8:	00000073          	ecall
 ret
    5fbc:	8082                	ret

0000000000005fbe <exec>:
.global exec
exec:
 li a7, SYS_exec
    5fbe:	489d                	li	a7,7
 ecall
    5fc0:	00000073          	ecall
 ret
    5fc4:	8082                	ret

0000000000005fc6 <open>:
.global open
open:
 li a7, SYS_open
    5fc6:	48bd                	li	a7,15
 ecall
    5fc8:	00000073          	ecall
 ret
    5fcc:	8082                	ret

0000000000005fce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5fce:	48c5                	li	a7,17
 ecall
    5fd0:	00000073          	ecall
 ret
    5fd4:	8082                	ret

0000000000005fd6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5fd6:	48c9                	li	a7,18
 ecall
    5fd8:	00000073          	ecall
 ret
    5fdc:	8082                	ret

0000000000005fde <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5fde:	48a1                	li	a7,8
 ecall
    5fe0:	00000073          	ecall
 ret
    5fe4:	8082                	ret

0000000000005fe6 <link>:
.global link
link:
 li a7, SYS_link
    5fe6:	48cd                	li	a7,19
 ecall
    5fe8:	00000073          	ecall
 ret
    5fec:	8082                	ret

0000000000005fee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5fee:	48d1                	li	a7,20
 ecall
    5ff0:	00000073          	ecall
 ret
    5ff4:	8082                	ret

0000000000005ff6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5ff6:	48a5                	li	a7,9
 ecall
    5ff8:	00000073          	ecall
 ret
    5ffc:	8082                	ret

0000000000005ffe <dup>:
.global dup
dup:
 li a7, SYS_dup
    5ffe:	48a9                	li	a7,10
 ecall
    6000:	00000073          	ecall
 ret
    6004:	8082                	ret

0000000000006006 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    6006:	48ad                	li	a7,11
 ecall
    6008:	00000073          	ecall
 ret
    600c:	8082                	ret

000000000000600e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    600e:	48b1                	li	a7,12
 ecall
    6010:	00000073          	ecall
 ret
    6014:	8082                	ret

0000000000006016 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    6016:	48b5                	li	a7,13
 ecall
    6018:	00000073          	ecall
 ret
    601c:	8082                	ret

000000000000601e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    601e:	48b9                	li	a7,14
 ecall
    6020:	00000073          	ecall
 ret
    6024:	8082                	ret

0000000000006026 <trace>:
.global trace
trace:
 li a7, SYS_trace
    6026:	48d9                	li	a7,22
 ecall
    6028:	00000073          	ecall
 ret
    602c:	8082                	ret

000000000000602e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
    602e:	48dd                	li	a7,23
 ecall
    6030:	00000073          	ecall
 ret
    6034:	8082                	ret

0000000000006036 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    6036:	1101                	addi	sp,sp,-32
    6038:	ec06                	sd	ra,24(sp)
    603a:	e822                	sd	s0,16(sp)
    603c:	1000                	addi	s0,sp,32
    603e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    6042:	4605                	li	a2,1
    6044:	fef40593          	addi	a1,s0,-17
    6048:	00000097          	auipc	ra,0x0
    604c:	f5e080e7          	jalr	-162(ra) # 5fa6 <write>
}
    6050:	60e2                	ld	ra,24(sp)
    6052:	6442                	ld	s0,16(sp)
    6054:	6105                	addi	sp,sp,32
    6056:	8082                	ret

0000000000006058 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    6058:	7139                	addi	sp,sp,-64
    605a:	fc06                	sd	ra,56(sp)
    605c:	f822                	sd	s0,48(sp)
    605e:	f426                	sd	s1,40(sp)
    6060:	f04a                	sd	s2,32(sp)
    6062:	ec4e                	sd	s3,24(sp)
    6064:	0080                	addi	s0,sp,64
    6066:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    6068:	c299                	beqz	a3,606e <printint+0x16>
    606a:	0805c063          	bltz	a1,60ea <printint+0x92>
  neg = 0;
    606e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    6070:	fc040313          	addi	t1,s0,-64
  neg = 0;
    6074:	869a                	mv	a3,t1
  i = 0;
    6076:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    6078:	00003817          	auipc	a6,0x3
    607c:	93880813          	addi	a6,a6,-1736 # 89b0 <digits>
    6080:	88be                	mv	a7,a5
    6082:	0017851b          	addiw	a0,a5,1
    6086:	87aa                	mv	a5,a0
    6088:	02c5f73b          	remuw	a4,a1,a2
    608c:	1702                	slli	a4,a4,0x20
    608e:	9301                	srli	a4,a4,0x20
    6090:	9742                	add	a4,a4,a6
    6092:	00074703          	lbu	a4,0(a4)
    6096:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    609a:	872e                	mv	a4,a1
    609c:	02c5d5bb          	divuw	a1,a1,a2
    60a0:	0685                	addi	a3,a3,1
    60a2:	fcc77fe3          	bgeu	a4,a2,6080 <printint+0x28>
  if(neg)
    60a6:	000e0c63          	beqz	t3,60be <printint+0x66>
    buf[i++] = '-';
    60aa:	fd050793          	addi	a5,a0,-48
    60ae:	00878533          	add	a0,a5,s0
    60b2:	02d00793          	li	a5,45
    60b6:	fef50823          	sb	a5,-16(a0)
    60ba:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    60be:	fff7899b          	addiw	s3,a5,-1
    60c2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    60c6:	fff4c583          	lbu	a1,-1(s1)
    60ca:	854a                	mv	a0,s2
    60cc:	00000097          	auipc	ra,0x0
    60d0:	f6a080e7          	jalr	-150(ra) # 6036 <putc>
  while(--i >= 0)
    60d4:	39fd                	addiw	s3,s3,-1
    60d6:	14fd                	addi	s1,s1,-1
    60d8:	fe09d7e3          	bgez	s3,60c6 <printint+0x6e>
}
    60dc:	70e2                	ld	ra,56(sp)
    60de:	7442                	ld	s0,48(sp)
    60e0:	74a2                	ld	s1,40(sp)
    60e2:	7902                	ld	s2,32(sp)
    60e4:	69e2                	ld	s3,24(sp)
    60e6:	6121                	addi	sp,sp,64
    60e8:	8082                	ret
    x = -xx;
    60ea:	40b005bb          	negw	a1,a1
    neg = 1;
    60ee:	4e05                	li	t3,1
    x = -xx;
    60f0:	b741                	j	6070 <printint+0x18>

00000000000060f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    60f2:	711d                	addi	sp,sp,-96
    60f4:	ec86                	sd	ra,88(sp)
    60f6:	e8a2                	sd	s0,80(sp)
    60f8:	e4a6                	sd	s1,72(sp)
    60fa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    60fc:	0005c483          	lbu	s1,0(a1)
    6100:	2a048863          	beqz	s1,63b0 <vprintf+0x2be>
    6104:	e0ca                	sd	s2,64(sp)
    6106:	fc4e                	sd	s3,56(sp)
    6108:	f852                	sd	s4,48(sp)
    610a:	f456                	sd	s5,40(sp)
    610c:	f05a                	sd	s6,32(sp)
    610e:	ec5e                	sd	s7,24(sp)
    6110:	e862                	sd	s8,16(sp)
    6112:	e466                	sd	s9,8(sp)
    6114:	8b2a                	mv	s6,a0
    6116:	8a2e                	mv	s4,a1
    6118:	8bb2                	mv	s7,a2
  state = 0;
    611a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    611c:	4901                	li	s2,0
    611e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    6120:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    6124:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    6128:	06c00c93          	li	s9,108
    612c:	a01d                	j	6152 <vprintf+0x60>
        putc(fd, c0);
    612e:	85a6                	mv	a1,s1
    6130:	855a                	mv	a0,s6
    6132:	00000097          	auipc	ra,0x0
    6136:	f04080e7          	jalr	-252(ra) # 6036 <putc>
    613a:	a019                	j	6140 <vprintf+0x4e>
    } else if(state == '%'){
    613c:	03598363          	beq	s3,s5,6162 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
    6140:	0019079b          	addiw	a5,s2,1
    6144:	893e                	mv	s2,a5
    6146:	873e                	mv	a4,a5
    6148:	97d2                	add	a5,a5,s4
    614a:	0007c483          	lbu	s1,0(a5)
    614e:	24048963          	beqz	s1,63a0 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
    6152:	0004879b          	sext.w	a5,s1
    if(state == 0){
    6156:	fe0993e3          	bnez	s3,613c <vprintf+0x4a>
      if(c0 == '%'){
    615a:	fd579ae3          	bne	a5,s5,612e <vprintf+0x3c>
        state = '%';
    615e:	89be                	mv	s3,a5
    6160:	b7c5                	j	6140 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
    6162:	00ea06b3          	add	a3,s4,a4
    6166:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    616a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    616c:	c681                	beqz	a3,6174 <vprintf+0x82>
    616e:	9752                	add	a4,a4,s4
    6170:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    6174:	05878063          	beq	a5,s8,61b4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    6178:	05978c63          	beq	a5,s9,61d0 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    617c:	07500713          	li	a4,117
    6180:	10e78063          	beq	a5,a4,6280 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    6184:	07800713          	li	a4,120
    6188:	14e78863          	beq	a5,a4,62d8 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    618c:	07000713          	li	a4,112
    6190:	18e78163          	beq	a5,a4,6312 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    6194:	07300713          	li	a4,115
    6198:	1ce78663          	beq	a5,a4,6364 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    619c:	02500713          	li	a4,37
    61a0:	04e79863          	bne	a5,a4,61f0 <vprintf+0xfe>
        putc(fd, '%');
    61a4:	85ba                	mv	a1,a4
    61a6:	855a                	mv	a0,s6
    61a8:	00000097          	auipc	ra,0x0
    61ac:	e8e080e7          	jalr	-370(ra) # 6036 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    61b0:	4981                	li	s3,0
    61b2:	b779                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
    61b4:	008b8493          	addi	s1,s7,8
    61b8:	4685                	li	a3,1
    61ba:	4629                	li	a2,10
    61bc:	000ba583          	lw	a1,0(s7)
    61c0:	855a                	mv	a0,s6
    61c2:	00000097          	auipc	ra,0x0
    61c6:	e96080e7          	jalr	-362(ra) # 6058 <printint>
    61ca:	8ba6                	mv	s7,s1
      state = 0;
    61cc:	4981                	li	s3,0
    61ce:	bf8d                	j	6140 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
    61d0:	06400793          	li	a5,100
    61d4:	02f68d63          	beq	a3,a5,620e <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    61d8:	06c00793          	li	a5,108
    61dc:	04f68863          	beq	a3,a5,622c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
    61e0:	07500793          	li	a5,117
    61e4:	0af68c63          	beq	a3,a5,629c <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
    61e8:	07800793          	li	a5,120
    61ec:	10f68463          	beq	a3,a5,62f4 <vprintf+0x202>
        putc(fd, '%');
    61f0:	02500593          	li	a1,37
    61f4:	855a                	mv	a0,s6
    61f6:	00000097          	auipc	ra,0x0
    61fa:	e40080e7          	jalr	-448(ra) # 6036 <putc>
        putc(fd, c0);
    61fe:	85a6                	mv	a1,s1
    6200:	855a                	mv	a0,s6
    6202:	00000097          	auipc	ra,0x0
    6206:	e34080e7          	jalr	-460(ra) # 6036 <putc>
      state = 0;
    620a:	4981                	li	s3,0
    620c:	bf15                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
    620e:	008b8493          	addi	s1,s7,8
    6212:	4685                	li	a3,1
    6214:	4629                	li	a2,10
    6216:	000ba583          	lw	a1,0(s7)
    621a:	855a                	mv	a0,s6
    621c:	00000097          	auipc	ra,0x0
    6220:	e3c080e7          	jalr	-452(ra) # 6058 <printint>
        i += 1;
    6224:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    6226:	8ba6                	mv	s7,s1
      state = 0;
    6228:	4981                	li	s3,0
        i += 1;
    622a:	bf19                	j	6140 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    622c:	06400793          	li	a5,100
    6230:	02f60963          	beq	a2,a5,6262 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    6234:	07500793          	li	a5,117
    6238:	08f60163          	beq	a2,a5,62ba <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    623c:	07800793          	li	a5,120
    6240:	faf618e3          	bne	a2,a5,61f0 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
    6244:	008b8493          	addi	s1,s7,8
    6248:	4681                	li	a3,0
    624a:	4641                	li	a2,16
    624c:	000ba583          	lw	a1,0(s7)
    6250:	855a                	mv	a0,s6
    6252:	00000097          	auipc	ra,0x0
    6256:	e06080e7          	jalr	-506(ra) # 6058 <printint>
        i += 2;
    625a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    625c:	8ba6                	mv	s7,s1
      state = 0;
    625e:	4981                	li	s3,0
        i += 2;
    6260:	b5c5                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
    6262:	008b8493          	addi	s1,s7,8
    6266:	4685                	li	a3,1
    6268:	4629                	li	a2,10
    626a:	000ba583          	lw	a1,0(s7)
    626e:	855a                	mv	a0,s6
    6270:	00000097          	auipc	ra,0x0
    6274:	de8080e7          	jalr	-536(ra) # 6058 <printint>
        i += 2;
    6278:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    627a:	8ba6                	mv	s7,s1
      state = 0;
    627c:	4981                	li	s3,0
        i += 2;
    627e:	b5c9                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
    6280:	008b8493          	addi	s1,s7,8
    6284:	4681                	li	a3,0
    6286:	4629                	li	a2,10
    6288:	000ba583          	lw	a1,0(s7)
    628c:	855a                	mv	a0,s6
    628e:	00000097          	auipc	ra,0x0
    6292:	dca080e7          	jalr	-566(ra) # 6058 <printint>
    6296:	8ba6                	mv	s7,s1
      state = 0;
    6298:	4981                	li	s3,0
    629a:	b55d                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
    629c:	008b8493          	addi	s1,s7,8
    62a0:	4681                	li	a3,0
    62a2:	4629                	li	a2,10
    62a4:	000ba583          	lw	a1,0(s7)
    62a8:	855a                	mv	a0,s6
    62aa:	00000097          	auipc	ra,0x0
    62ae:	dae080e7          	jalr	-594(ra) # 6058 <printint>
        i += 1;
    62b2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    62b4:	8ba6                	mv	s7,s1
      state = 0;
    62b6:	4981                	li	s3,0
        i += 1;
    62b8:	b561                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
    62ba:	008b8493          	addi	s1,s7,8
    62be:	4681                	li	a3,0
    62c0:	4629                	li	a2,10
    62c2:	000ba583          	lw	a1,0(s7)
    62c6:	855a                	mv	a0,s6
    62c8:	00000097          	auipc	ra,0x0
    62cc:	d90080e7          	jalr	-624(ra) # 6058 <printint>
        i += 2;
    62d0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    62d2:	8ba6                	mv	s7,s1
      state = 0;
    62d4:	4981                	li	s3,0
        i += 2;
    62d6:	b5ad                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
    62d8:	008b8493          	addi	s1,s7,8
    62dc:	4681                	li	a3,0
    62de:	4641                	li	a2,16
    62e0:	000ba583          	lw	a1,0(s7)
    62e4:	855a                	mv	a0,s6
    62e6:	00000097          	auipc	ra,0x0
    62ea:	d72080e7          	jalr	-654(ra) # 6058 <printint>
    62ee:	8ba6                	mv	s7,s1
      state = 0;
    62f0:	4981                	li	s3,0
    62f2:	b5b9                	j	6140 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
    62f4:	008b8493          	addi	s1,s7,8
    62f8:	4681                	li	a3,0
    62fa:	4641                	li	a2,16
    62fc:	000ba583          	lw	a1,0(s7)
    6300:	855a                	mv	a0,s6
    6302:	00000097          	auipc	ra,0x0
    6306:	d56080e7          	jalr	-682(ra) # 6058 <printint>
        i += 1;
    630a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    630c:	8ba6                	mv	s7,s1
      state = 0;
    630e:	4981                	li	s3,0
        i += 1;
    6310:	bd05                	j	6140 <vprintf+0x4e>
    6312:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    6314:	008b8d13          	addi	s10,s7,8
    6318:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    631c:	03000593          	li	a1,48
    6320:	855a                	mv	a0,s6
    6322:	00000097          	auipc	ra,0x0
    6326:	d14080e7          	jalr	-748(ra) # 6036 <putc>
  putc(fd, 'x');
    632a:	07800593          	li	a1,120
    632e:	855a                	mv	a0,s6
    6330:	00000097          	auipc	ra,0x0
    6334:	d06080e7          	jalr	-762(ra) # 6036 <putc>
    6338:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    633a:	00002b97          	auipc	s7,0x2
    633e:	676b8b93          	addi	s7,s7,1654 # 89b0 <digits>
    6342:	03c9d793          	srli	a5,s3,0x3c
    6346:	97de                	add	a5,a5,s7
    6348:	0007c583          	lbu	a1,0(a5)
    634c:	855a                	mv	a0,s6
    634e:	00000097          	auipc	ra,0x0
    6352:	ce8080e7          	jalr	-792(ra) # 6036 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    6356:	0992                	slli	s3,s3,0x4
    6358:	34fd                	addiw	s1,s1,-1
    635a:	f4e5                	bnez	s1,6342 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
    635c:	8bea                	mv	s7,s10
      state = 0;
    635e:	4981                	li	s3,0
    6360:	6d02                	ld	s10,0(sp)
    6362:	bbf9                	j	6140 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
    6364:	008b8993          	addi	s3,s7,8
    6368:	000bb483          	ld	s1,0(s7)
    636c:	c085                	beqz	s1,638c <vprintf+0x29a>
        for(; *s; s++)
    636e:	0004c583          	lbu	a1,0(s1)
    6372:	c585                	beqz	a1,639a <vprintf+0x2a8>
          putc(fd, *s);
    6374:	855a                	mv	a0,s6
    6376:	00000097          	auipc	ra,0x0
    637a:	cc0080e7          	jalr	-832(ra) # 6036 <putc>
        for(; *s; s++)
    637e:	0485                	addi	s1,s1,1
    6380:	0004c583          	lbu	a1,0(s1)
    6384:	f9e5                	bnez	a1,6374 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
    6386:	8bce                	mv	s7,s3
      state = 0;
    6388:	4981                	li	s3,0
    638a:	bb5d                	j	6140 <vprintf+0x4e>
          s = "(null)";
    638c:	00002497          	auipc	s1,0x2
    6390:	5a448493          	addi	s1,s1,1444 # 8930 <malloc+0x248c>
        for(; *s; s++)
    6394:	02800593          	li	a1,40
    6398:	bff1                	j	6374 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
    639a:	8bce                	mv	s7,s3
      state = 0;
    639c:	4981                	li	s3,0
    639e:	b34d                	j	6140 <vprintf+0x4e>
    63a0:	6906                	ld	s2,64(sp)
    63a2:	79e2                	ld	s3,56(sp)
    63a4:	7a42                	ld	s4,48(sp)
    63a6:	7aa2                	ld	s5,40(sp)
    63a8:	7b02                	ld	s6,32(sp)
    63aa:	6be2                	ld	s7,24(sp)
    63ac:	6c42                	ld	s8,16(sp)
    63ae:	6ca2                	ld	s9,8(sp)
    }
  }
}
    63b0:	60e6                	ld	ra,88(sp)
    63b2:	6446                	ld	s0,80(sp)
    63b4:	64a6                	ld	s1,72(sp)
    63b6:	6125                	addi	sp,sp,96
    63b8:	8082                	ret

00000000000063ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    63ba:	715d                	addi	sp,sp,-80
    63bc:	ec06                	sd	ra,24(sp)
    63be:	e822                	sd	s0,16(sp)
    63c0:	1000                	addi	s0,sp,32
    63c2:	e010                	sd	a2,0(s0)
    63c4:	e414                	sd	a3,8(s0)
    63c6:	e818                	sd	a4,16(s0)
    63c8:	ec1c                	sd	a5,24(s0)
    63ca:	03043023          	sd	a6,32(s0)
    63ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    63d2:	8622                	mv	a2,s0
    63d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    63d8:	00000097          	auipc	ra,0x0
    63dc:	d1a080e7          	jalr	-742(ra) # 60f2 <vprintf>
}
    63e0:	60e2                	ld	ra,24(sp)
    63e2:	6442                	ld	s0,16(sp)
    63e4:	6161                	addi	sp,sp,80
    63e6:	8082                	ret

00000000000063e8 <printf>:

void
printf(const char *fmt, ...)
{
    63e8:	711d                	addi	sp,sp,-96
    63ea:	ec06                	sd	ra,24(sp)
    63ec:	e822                	sd	s0,16(sp)
    63ee:	1000                	addi	s0,sp,32
    63f0:	e40c                	sd	a1,8(s0)
    63f2:	e810                	sd	a2,16(s0)
    63f4:	ec14                	sd	a3,24(s0)
    63f6:	f018                	sd	a4,32(s0)
    63f8:	f41c                	sd	a5,40(s0)
    63fa:	03043823          	sd	a6,48(s0)
    63fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    6402:	00840613          	addi	a2,s0,8
    6406:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    640a:	85aa                	mv	a1,a0
    640c:	4505                	li	a0,1
    640e:	00000097          	auipc	ra,0x0
    6412:	ce4080e7          	jalr	-796(ra) # 60f2 <vprintf>
}
    6416:	60e2                	ld	ra,24(sp)
    6418:	6442                	ld	s0,16(sp)
    641a:	6125                	addi	sp,sp,96
    641c:	8082                	ret

000000000000641e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    641e:	1141                	addi	sp,sp,-16
    6420:	e406                	sd	ra,8(sp)
    6422:	e022                	sd	s0,0(sp)
    6424:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6426:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    642a:	00004797          	auipc	a5,0x4
    642e:	0267b783          	ld	a5,38(a5) # a450 <freep>
    6432:	a02d                	j	645c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    6434:	4618                	lw	a4,8(a2)
    6436:	9f2d                	addw	a4,a4,a1
    6438:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    643c:	6398                	ld	a4,0(a5)
    643e:	6310                	ld	a2,0(a4)
    6440:	a83d                	j	647e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6442:	ff852703          	lw	a4,-8(a0)
    6446:	9f31                	addw	a4,a4,a2
    6448:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    644a:	ff053683          	ld	a3,-16(a0)
    644e:	a091                	j	6492 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6450:	6398                	ld	a4,0(a5)
    6452:	00e7e463          	bltu	a5,a4,645a <free+0x3c>
    6456:	00e6ea63          	bltu	a3,a4,646a <free+0x4c>
{
    645a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    645c:	fed7fae3          	bgeu	a5,a3,6450 <free+0x32>
    6460:	6398                	ld	a4,0(a5)
    6462:	00e6e463          	bltu	a3,a4,646a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6466:	fee7eae3          	bltu	a5,a4,645a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    646a:	ff852583          	lw	a1,-8(a0)
    646e:	6390                	ld	a2,0(a5)
    6470:	02059813          	slli	a6,a1,0x20
    6474:	01c85713          	srli	a4,a6,0x1c
    6478:	9736                	add	a4,a4,a3
    647a:	fae60de3          	beq	a2,a4,6434 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    647e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6482:	4790                	lw	a2,8(a5)
    6484:	02061593          	slli	a1,a2,0x20
    6488:	01c5d713          	srli	a4,a1,0x1c
    648c:	973e                	add	a4,a4,a5
    648e:	fae68ae3          	beq	a3,a4,6442 <free+0x24>
    p->s.ptr = bp->s.ptr;
    6492:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    6494:	00004717          	auipc	a4,0x4
    6498:	faf73e23          	sd	a5,-68(a4) # a450 <freep>
}
    649c:	60a2                	ld	ra,8(sp)
    649e:	6402                	ld	s0,0(sp)
    64a0:	0141                	addi	sp,sp,16
    64a2:	8082                	ret

00000000000064a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    64a4:	7139                	addi	sp,sp,-64
    64a6:	fc06                	sd	ra,56(sp)
    64a8:	f822                	sd	s0,48(sp)
    64aa:	f04a                	sd	s2,32(sp)
    64ac:	ec4e                	sd	s3,24(sp)
    64ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    64b0:	02051993          	slli	s3,a0,0x20
    64b4:	0209d993          	srli	s3,s3,0x20
    64b8:	09bd                	addi	s3,s3,15
    64ba:	0049d993          	srli	s3,s3,0x4
    64be:	2985                	addiw	s3,s3,1
    64c0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    64c2:	00004517          	auipc	a0,0x4
    64c6:	f8e53503          	ld	a0,-114(a0) # a450 <freep>
    64ca:	c905                	beqz	a0,64fa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    64cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    64ce:	4798                	lw	a4,8(a5)
    64d0:	09377a63          	bgeu	a4,s3,6564 <malloc+0xc0>
    64d4:	f426                	sd	s1,40(sp)
    64d6:	e852                	sd	s4,16(sp)
    64d8:	e456                	sd	s5,8(sp)
    64da:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    64dc:	8a4e                	mv	s4,s3
    64de:	6705                	lui	a4,0x1
    64e0:	00e9f363          	bgeu	s3,a4,64e6 <malloc+0x42>
    64e4:	6a05                	lui	s4,0x1
    64e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    64ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    64ee:	00004497          	auipc	s1,0x4
    64f2:	f6248493          	addi	s1,s1,-158 # a450 <freep>
  if(p == (char*)-1)
    64f6:	5afd                	li	s5,-1
    64f8:	a089                	j	653a <malloc+0x96>
    64fa:	f426                	sd	s1,40(sp)
    64fc:	e852                	sd	s4,16(sp)
    64fe:	e456                	sd	s5,8(sp)
    6500:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    6502:	0000a797          	auipc	a5,0xa
    6506:	77678793          	addi	a5,a5,1910 # 10c78 <base>
    650a:	00004717          	auipc	a4,0x4
    650e:	f4f73323          	sd	a5,-186(a4) # a450 <freep>
    6512:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6514:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6518:	b7d1                	j	64dc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    651a:	6398                	ld	a4,0(a5)
    651c:	e118                	sd	a4,0(a0)
    651e:	a8b9                	j	657c <malloc+0xd8>
  hp->s.size = nu;
    6520:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6524:	0541                	addi	a0,a0,16
    6526:	00000097          	auipc	ra,0x0
    652a:	ef8080e7          	jalr	-264(ra) # 641e <free>
  return freep;
    652e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    6530:	c135                	beqz	a0,6594 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6532:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6534:	4798                	lw	a4,8(a5)
    6536:	03277363          	bgeu	a4,s2,655c <malloc+0xb8>
    if(p == freep)
    653a:	6098                	ld	a4,0(s1)
    653c:	853e                	mv	a0,a5
    653e:	fef71ae3          	bne	a4,a5,6532 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    6542:	8552                	mv	a0,s4
    6544:	00000097          	auipc	ra,0x0
    6548:	aca080e7          	jalr	-1334(ra) # 600e <sbrk>
  if(p == (char*)-1)
    654c:	fd551ae3          	bne	a0,s5,6520 <malloc+0x7c>
        return 0;
    6550:	4501                	li	a0,0
    6552:	74a2                	ld	s1,40(sp)
    6554:	6a42                	ld	s4,16(sp)
    6556:	6aa2                	ld	s5,8(sp)
    6558:	6b02                	ld	s6,0(sp)
    655a:	a03d                	j	6588 <malloc+0xe4>
    655c:	74a2                	ld	s1,40(sp)
    655e:	6a42                	ld	s4,16(sp)
    6560:	6aa2                	ld	s5,8(sp)
    6562:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    6564:	fae90be3          	beq	s2,a4,651a <malloc+0x76>
        p->s.size -= nunits;
    6568:	4137073b          	subw	a4,a4,s3
    656c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    656e:	02071693          	slli	a3,a4,0x20
    6572:	01c6d713          	srli	a4,a3,0x1c
    6576:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6578:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    657c:	00004717          	auipc	a4,0x4
    6580:	eca73a23          	sd	a0,-300(a4) # a450 <freep>
      return (void*)(p + 1);
    6584:	01078513          	addi	a0,a5,16
  }
}
    6588:	70e2                	ld	ra,56(sp)
    658a:	7442                	ld	s0,48(sp)
    658c:	7902                	ld	s2,32(sp)
    658e:	69e2                	ld	s3,24(sp)
    6590:	6121                	addi	sp,sp,64
    6592:	8082                	ret
    6594:	74a2                	ld	s1,40(sp)
    6596:	6a42                	ld	s4,16(sp)
    6598:	6aa2                	ld	s5,8(sp)
    659a:	6b02                	ld	s6,0(sp)
    659c:	b7f5                	j	6588 <malloc+0xe4>
