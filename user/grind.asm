
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	00000097          	auipc	ra,0x0
      a2:	f62080e7          	jalr	-158(ra) # 0 <do_rand>
}
      a6:	60a2                	ld	ra,8(sp)
      a8:	6402                	ld	s0,0(sp)
      aa:	0141                	addi	sp,sp,16
      ac:	8082                	ret

00000000000000ae <go>:

void
go(int which_child)
{
      ae:	7171                	addi	sp,sp,-176
      b0:	f506                	sd	ra,168(sp)
      b2:	f122                	sd	s0,160(sp)
      b4:	ed26                	sd	s1,152(sp)
      b6:	1900                	addi	s0,sp,176
      b8:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      ba:	4501                	li	a0,0
      bc:	00001097          	auipc	ra,0x1
      c0:	eda080e7          	jalr	-294(ra) # f96 <sbrk>
      c4:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c8:	00001517          	auipc	a0,0x1
      cc:	46850513          	addi	a0,a0,1128 # 1530 <malloc+0x104>
      d0:	00001097          	auipc	ra,0x1
      d4:	ea6080e7          	jalr	-346(ra) # f76 <mkdir>
  if(chdir("grindir") != 0){
      d8:	00001517          	auipc	a0,0x1
      dc:	45850513          	addi	a0,a0,1112 # 1530 <malloc+0x104>
      e0:	00001097          	auipc	ra,0x1
      e4:	e9e080e7          	jalr	-354(ra) # f7e <chdir>
      e8:	c905                	beqz	a0,118 <go+0x6a>
      ea:	e94a                	sd	s2,144(sp)
      ec:	e54e                	sd	s3,136(sp)
      ee:	e152                	sd	s4,128(sp)
      f0:	fcd6                	sd	s5,120(sp)
      f2:	f8da                	sd	s6,112(sp)
      f4:	f4de                	sd	s7,104(sp)
      f6:	f0e2                	sd	s8,96(sp)
      f8:	ece6                	sd	s9,88(sp)
      fa:	e8ea                	sd	s10,80(sp)
      fc:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      fe:	00001517          	auipc	a0,0x1
     102:	43a50513          	addi	a0,a0,1082 # 1538 <malloc+0x10c>
     106:	00001097          	auipc	ra,0x1
     10a:	26a080e7          	jalr	618(ra) # 1370 <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00001097          	auipc	ra,0x1
     114:	dfe080e7          	jalr	-514(ra) # f0e <exit>
     118:	e94a                	sd	s2,144(sp)
     11a:	e54e                	sd	s3,136(sp)
     11c:	e152                	sd	s4,128(sp)
     11e:	fcd6                	sd	s5,120(sp)
     120:	f8da                	sd	s6,112(sp)
     122:	f4de                	sd	s7,104(sp)
     124:	f0e2                	sd	s8,96(sp)
     126:	ece6                	sd	s9,88(sp)
     128:	e8ea                	sd	s10,80(sp)
     12a:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     12c:	00001517          	auipc	a0,0x1
     130:	43450513          	addi	a0,a0,1076 # 1560 <malloc+0x134>
     134:	00001097          	auipc	ra,0x1
     138:	e4a080e7          	jalr	-438(ra) # f7e <chdir>
     13c:	00001c17          	auipc	s8,0x1
     140:	434c0c13          	addi	s8,s8,1076 # 1570 <malloc+0x144>
     144:	c489                	beqz	s1,14e <go+0xa0>
     146:	00001c17          	auipc	s8,0x1
     14a:	422c0c13          	addi	s8,s8,1058 # 1568 <malloc+0x13c>
  uint64 iters = 0;
     14e:	4481                	li	s1,0
  int fd = -1;
     150:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     152:	e353f7b7          	lui	a5,0xe353f
     156:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe353d3c7>
     15a:	20c4a9b7          	lui	s3,0x20c4a
     15e:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x20c4779e>
     162:	1982                	slli	s3,s3,0x20
     164:	99be                	add	s3,s3,a5
     166:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
     16a:	4b85                	li	s7,1
    int what = rand() % 23;
     16c:	b2164a37          	lui	s4,0xb2164
     170:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     174:	4ad9                	li	s5,22
     176:	00001917          	auipc	s2,0x1
     17a:	6ca90913          	addi	s2,s2,1738 # 1840 <malloc+0x414>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     17e:	f6840d93          	addi	s11,s0,-152
     182:	a839                	j	1a0 <go+0xf2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     184:	20200593          	li	a1,514
     188:	00001517          	auipc	a0,0x1
     18c:	3f050513          	addi	a0,a0,1008 # 1578 <malloc+0x14c>
     190:	00001097          	auipc	ra,0x1
     194:	dbe080e7          	jalr	-578(ra) # f4e <open>
     198:	00001097          	auipc	ra,0x1
     19c:	d9e080e7          	jalr	-610(ra) # f36 <close>
    iters++;
     1a0:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     1a2:	0024d793          	srli	a5,s1,0x2
     1a6:	0337b7b3          	mulhu	a5,a5,s3
     1aa:	8391                	srli	a5,a5,0x4
     1ac:	036787b3          	mul	a5,a5,s6
     1b0:	00f49963          	bne	s1,a5,1c2 <go+0x114>
      write(1, which_child?"B":"A", 1);
     1b4:	865e                	mv	a2,s7
     1b6:	85e2                	mv	a1,s8
     1b8:	855e                	mv	a0,s7
     1ba:	00001097          	auipc	ra,0x1
     1be:	d74080e7          	jalr	-652(ra) # f2e <write>
    int what = rand() % 23;
     1c2:	00000097          	auipc	ra,0x0
     1c6:	ecc080e7          	jalr	-308(ra) # 8e <rand>
     1ca:	034507b3          	mul	a5,a0,s4
     1ce:	9381                	srli	a5,a5,0x20
     1d0:	9fa9                	addw	a5,a5,a0
     1d2:	4047d79b          	sraiw	a5,a5,0x4
     1d6:	41f5571b          	sraiw	a4,a0,0x1f
     1da:	9f99                	subw	a5,a5,a4
     1dc:	0017971b          	slliw	a4,a5,0x1
     1e0:	9f3d                	addw	a4,a4,a5
     1e2:	0037171b          	slliw	a4,a4,0x3
     1e6:	40f707bb          	subw	a5,a4,a5
     1ea:	9d1d                	subw	a0,a0,a5
     1ec:	faaaeae3          	bltu	s5,a0,1a0 <go+0xf2>
     1f0:	02051793          	slli	a5,a0,0x20
     1f4:	01e7d513          	srli	a0,a5,0x1e
     1f8:	954a                	add	a0,a0,s2
     1fa:	411c                	lw	a5,0(a0)
     1fc:	97ca                	add	a5,a5,s2
     1fe:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     200:	20200593          	li	a1,514
     204:	00001517          	auipc	a0,0x1
     208:	38450513          	addi	a0,a0,900 # 1588 <malloc+0x15c>
     20c:	00001097          	auipc	ra,0x1
     210:	d42080e7          	jalr	-702(ra) # f4e <open>
     214:	00001097          	auipc	ra,0x1
     218:	d22080e7          	jalr	-734(ra) # f36 <close>
     21c:	b751                	j	1a0 <go+0xf2>
      unlink("grindir/../a");
     21e:	00001517          	auipc	a0,0x1
     222:	35a50513          	addi	a0,a0,858 # 1578 <malloc+0x14c>
     226:	00001097          	auipc	ra,0x1
     22a:	d38080e7          	jalr	-712(ra) # f5e <unlink>
     22e:	bf8d                	j	1a0 <go+0xf2>
      if(chdir("grindir") != 0){
     230:	00001517          	auipc	a0,0x1
     234:	30050513          	addi	a0,a0,768 # 1530 <malloc+0x104>
     238:	00001097          	auipc	ra,0x1
     23c:	d46080e7          	jalr	-698(ra) # f7e <chdir>
     240:	e115                	bnez	a0,264 <go+0x1b6>
      unlink("../b");
     242:	00001517          	auipc	a0,0x1
     246:	35e50513          	addi	a0,a0,862 # 15a0 <malloc+0x174>
     24a:	00001097          	auipc	ra,0x1
     24e:	d14080e7          	jalr	-748(ra) # f5e <unlink>
      chdir("/");
     252:	00001517          	auipc	a0,0x1
     256:	30e50513          	addi	a0,a0,782 # 1560 <malloc+0x134>
     25a:	00001097          	auipc	ra,0x1
     25e:	d24080e7          	jalr	-732(ra) # f7e <chdir>
     262:	bf3d                	j	1a0 <go+0xf2>
        printf("grind: chdir grindir failed\n");
     264:	00001517          	auipc	a0,0x1
     268:	2d450513          	addi	a0,a0,724 # 1538 <malloc+0x10c>
     26c:	00001097          	auipc	ra,0x1
     270:	104080e7          	jalr	260(ra) # 1370 <printf>
        exit(1);
     274:	4505                	li	a0,1
     276:	00001097          	auipc	ra,0x1
     27a:	c98080e7          	jalr	-872(ra) # f0e <exit>
      close(fd);
     27e:	8566                	mv	a0,s9
     280:	00001097          	auipc	ra,0x1
     284:	cb6080e7          	jalr	-842(ra) # f36 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     288:	20200593          	li	a1,514
     28c:	00001517          	auipc	a0,0x1
     290:	31c50513          	addi	a0,a0,796 # 15a8 <malloc+0x17c>
     294:	00001097          	auipc	ra,0x1
     298:	cba080e7          	jalr	-838(ra) # f4e <open>
     29c:	8caa                	mv	s9,a0
     29e:	b709                	j	1a0 <go+0xf2>
      close(fd);
     2a0:	8566                	mv	a0,s9
     2a2:	00001097          	auipc	ra,0x1
     2a6:	c94080e7          	jalr	-876(ra) # f36 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2aa:	20200593          	li	a1,514
     2ae:	00001517          	auipc	a0,0x1
     2b2:	30a50513          	addi	a0,a0,778 # 15b8 <malloc+0x18c>
     2b6:	00001097          	auipc	ra,0x1
     2ba:	c98080e7          	jalr	-872(ra) # f4e <open>
     2be:	8caa                	mv	s9,a0
     2c0:	b5c5                	j	1a0 <go+0xf2>
      write(fd, buf, sizeof(buf));
     2c2:	3e700613          	li	a2,999
     2c6:	00002597          	auipc	a1,0x2
     2ca:	d5a58593          	addi	a1,a1,-678 # 2020 <buf.0>
     2ce:	8566                	mv	a0,s9
     2d0:	00001097          	auipc	ra,0x1
     2d4:	c5e080e7          	jalr	-930(ra) # f2e <write>
     2d8:	b5e1                	j	1a0 <go+0xf2>
      read(fd, buf, sizeof(buf));
     2da:	3e700613          	li	a2,999
     2de:	00002597          	auipc	a1,0x2
     2e2:	d4258593          	addi	a1,a1,-702 # 2020 <buf.0>
     2e6:	8566                	mv	a0,s9
     2e8:	00001097          	auipc	ra,0x1
     2ec:	c3e080e7          	jalr	-962(ra) # f26 <read>
     2f0:	bd45                	j	1a0 <go+0xf2>
      mkdir("grindir/../a");
     2f2:	00001517          	auipc	a0,0x1
     2f6:	28650513          	addi	a0,a0,646 # 1578 <malloc+0x14c>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	c7c080e7          	jalr	-900(ra) # f76 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     302:	20200593          	li	a1,514
     306:	00001517          	auipc	a0,0x1
     30a:	2ca50513          	addi	a0,a0,714 # 15d0 <malloc+0x1a4>
     30e:	00001097          	auipc	ra,0x1
     312:	c40080e7          	jalr	-960(ra) # f4e <open>
     316:	00001097          	auipc	ra,0x1
     31a:	c20080e7          	jalr	-992(ra) # f36 <close>
      unlink("a/a");
     31e:	00001517          	auipc	a0,0x1
     322:	2c250513          	addi	a0,a0,706 # 15e0 <malloc+0x1b4>
     326:	00001097          	auipc	ra,0x1
     32a:	c38080e7          	jalr	-968(ra) # f5e <unlink>
     32e:	bd8d                	j	1a0 <go+0xf2>
      mkdir("/../b");
     330:	00001517          	auipc	a0,0x1
     334:	2b850513          	addi	a0,a0,696 # 15e8 <malloc+0x1bc>
     338:	00001097          	auipc	ra,0x1
     33c:	c3e080e7          	jalr	-962(ra) # f76 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     340:	20200593          	li	a1,514
     344:	00001517          	auipc	a0,0x1
     348:	2ac50513          	addi	a0,a0,684 # 15f0 <malloc+0x1c4>
     34c:	00001097          	auipc	ra,0x1
     350:	c02080e7          	jalr	-1022(ra) # f4e <open>
     354:	00001097          	auipc	ra,0x1
     358:	be2080e7          	jalr	-1054(ra) # f36 <close>
      unlink("b/b");
     35c:	00001517          	auipc	a0,0x1
     360:	2a450513          	addi	a0,a0,676 # 1600 <malloc+0x1d4>
     364:	00001097          	auipc	ra,0x1
     368:	bfa080e7          	jalr	-1030(ra) # f5e <unlink>
     36c:	bd15                	j	1a0 <go+0xf2>
      unlink("b");
     36e:	00001517          	auipc	a0,0x1
     372:	29a50513          	addi	a0,a0,666 # 1608 <malloc+0x1dc>
     376:	00001097          	auipc	ra,0x1
     37a:	be8080e7          	jalr	-1048(ra) # f5e <unlink>
      link("../grindir/./../a", "../b");
     37e:	00001597          	auipc	a1,0x1
     382:	22258593          	addi	a1,a1,546 # 15a0 <malloc+0x174>
     386:	00001517          	auipc	a0,0x1
     38a:	28a50513          	addi	a0,a0,650 # 1610 <malloc+0x1e4>
     38e:	00001097          	auipc	ra,0x1
     392:	be0080e7          	jalr	-1056(ra) # f6e <link>
     396:	b529                	j	1a0 <go+0xf2>
      unlink("../grindir/../a");
     398:	00001517          	auipc	a0,0x1
     39c:	29050513          	addi	a0,a0,656 # 1628 <malloc+0x1fc>
     3a0:	00001097          	auipc	ra,0x1
     3a4:	bbe080e7          	jalr	-1090(ra) # f5e <unlink>
      link(".././b", "/grindir/../a");
     3a8:	00001597          	auipc	a1,0x1
     3ac:	20058593          	addi	a1,a1,512 # 15a8 <malloc+0x17c>
     3b0:	00001517          	auipc	a0,0x1
     3b4:	28850513          	addi	a0,a0,648 # 1638 <malloc+0x20c>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	bb6080e7          	jalr	-1098(ra) # f6e <link>
     3c0:	b3c5                	j	1a0 <go+0xf2>
      int pid = fork();
     3c2:	00001097          	auipc	ra,0x1
     3c6:	b44080e7          	jalr	-1212(ra) # f06 <fork>
      if(pid == 0){
     3ca:	c909                	beqz	a0,3dc <go+0x32e>
      } else if(pid < 0){
     3cc:	00054c63          	bltz	a0,3e4 <go+0x336>
      wait(0);
     3d0:	4501                	li	a0,0
     3d2:	00001097          	auipc	ra,0x1
     3d6:	b44080e7          	jalr	-1212(ra) # f16 <wait>
     3da:	b3d9                	j	1a0 <go+0xf2>
        exit(0);
     3dc:	00001097          	auipc	ra,0x1
     3e0:	b32080e7          	jalr	-1230(ra) # f0e <exit>
        printf("grind: fork failed\n");
     3e4:	00001517          	auipc	a0,0x1
     3e8:	25c50513          	addi	a0,a0,604 # 1640 <malloc+0x214>
     3ec:	00001097          	auipc	ra,0x1
     3f0:	f84080e7          	jalr	-124(ra) # 1370 <printf>
        exit(1);
     3f4:	4505                	li	a0,1
     3f6:	00001097          	auipc	ra,0x1
     3fa:	b18080e7          	jalr	-1256(ra) # f0e <exit>
      int pid = fork();
     3fe:	00001097          	auipc	ra,0x1
     402:	b08080e7          	jalr	-1272(ra) # f06 <fork>
      if(pid == 0){
     406:	c909                	beqz	a0,418 <go+0x36a>
      } else if(pid < 0){
     408:	02054563          	bltz	a0,432 <go+0x384>
      wait(0);
     40c:	4501                	li	a0,0
     40e:	00001097          	auipc	ra,0x1
     412:	b08080e7          	jalr	-1272(ra) # f16 <wait>
     416:	b369                	j	1a0 <go+0xf2>
        fork();
     418:	00001097          	auipc	ra,0x1
     41c:	aee080e7          	jalr	-1298(ra) # f06 <fork>
        fork();
     420:	00001097          	auipc	ra,0x1
     424:	ae6080e7          	jalr	-1306(ra) # f06 <fork>
        exit(0);
     428:	4501                	li	a0,0
     42a:	00001097          	auipc	ra,0x1
     42e:	ae4080e7          	jalr	-1308(ra) # f0e <exit>
        printf("grind: fork failed\n");
     432:	00001517          	auipc	a0,0x1
     436:	20e50513          	addi	a0,a0,526 # 1640 <malloc+0x214>
     43a:	00001097          	auipc	ra,0x1
     43e:	f36080e7          	jalr	-202(ra) # 1370 <printf>
        exit(1);
     442:	4505                	li	a0,1
     444:	00001097          	auipc	ra,0x1
     448:	aca080e7          	jalr	-1334(ra) # f0e <exit>
      sbrk(6011);
     44c:	6505                	lui	a0,0x1
     44e:	77b50513          	addi	a0,a0,1915 # 177b <malloc+0x34f>
     452:	00001097          	auipc	ra,0x1
     456:	b44080e7          	jalr	-1212(ra) # f96 <sbrk>
     45a:	b399                	j	1a0 <go+0xf2>
      if(sbrk(0) > break0)
     45c:	4501                	li	a0,0
     45e:	00001097          	auipc	ra,0x1
     462:	b38080e7          	jalr	-1224(ra) # f96 <sbrk>
     466:	f5843783          	ld	a5,-168(s0)
     46a:	d2a7fbe3          	bgeu	a5,a0,1a0 <go+0xf2>
        sbrk(-(sbrk(0) - break0));
     46e:	4501                	li	a0,0
     470:	00001097          	auipc	ra,0x1
     474:	b26080e7          	jalr	-1242(ra) # f96 <sbrk>
     478:	f5843783          	ld	a5,-168(s0)
     47c:	40a7853b          	subw	a0,a5,a0
     480:	00001097          	auipc	ra,0x1
     484:	b16080e7          	jalr	-1258(ra) # f96 <sbrk>
     488:	bb21                	j	1a0 <go+0xf2>
      int pid = fork();
     48a:	00001097          	auipc	ra,0x1
     48e:	a7c080e7          	jalr	-1412(ra) # f06 <fork>
     492:	8d2a                	mv	s10,a0
      if(pid == 0){
     494:	c51d                	beqz	a0,4c2 <go+0x414>
      } else if(pid < 0){
     496:	04054963          	bltz	a0,4e8 <go+0x43a>
      if(chdir("../grindir/..") != 0){
     49a:	00001517          	auipc	a0,0x1
     49e:	1c650513          	addi	a0,a0,454 # 1660 <malloc+0x234>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	adc080e7          	jalr	-1316(ra) # f7e <chdir>
     4aa:	ed21                	bnez	a0,502 <go+0x454>
      kill(pid);
     4ac:	856a                	mv	a0,s10
     4ae:	00001097          	auipc	ra,0x1
     4b2:	a90080e7          	jalr	-1392(ra) # f3e <kill>
      wait(0);
     4b6:	4501                	li	a0,0
     4b8:	00001097          	auipc	ra,0x1
     4bc:	a5e080e7          	jalr	-1442(ra) # f16 <wait>
     4c0:	b1c5                	j	1a0 <go+0xf2>
        close(open("a", O_CREATE|O_RDWR));
     4c2:	20200593          	li	a1,514
     4c6:	00001517          	auipc	a0,0x1
     4ca:	19250513          	addi	a0,a0,402 # 1658 <malloc+0x22c>
     4ce:	00001097          	auipc	ra,0x1
     4d2:	a80080e7          	jalr	-1408(ra) # f4e <open>
     4d6:	00001097          	auipc	ra,0x1
     4da:	a60080e7          	jalr	-1440(ra) # f36 <close>
        exit(0);
     4de:	4501                	li	a0,0
     4e0:	00001097          	auipc	ra,0x1
     4e4:	a2e080e7          	jalr	-1490(ra) # f0e <exit>
        printf("grind: fork failed\n");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	15850513          	addi	a0,a0,344 # 1640 <malloc+0x214>
     4f0:	00001097          	auipc	ra,0x1
     4f4:	e80080e7          	jalr	-384(ra) # 1370 <printf>
        exit(1);
     4f8:	4505                	li	a0,1
     4fa:	00001097          	auipc	ra,0x1
     4fe:	a14080e7          	jalr	-1516(ra) # f0e <exit>
        printf("grind: chdir failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	16e50513          	addi	a0,a0,366 # 1670 <malloc+0x244>
     50a:	00001097          	auipc	ra,0x1
     50e:	e66080e7          	jalr	-410(ra) # 1370 <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	9fa080e7          	jalr	-1542(ra) # f0e <exit>
      int pid = fork();
     51c:	00001097          	auipc	ra,0x1
     520:	9ea080e7          	jalr	-1558(ra) # f06 <fork>
      if(pid == 0){
     524:	c909                	beqz	a0,536 <go+0x488>
      } else if(pid < 0){
     526:	02054563          	bltz	a0,550 <go+0x4a2>
      wait(0);
     52a:	4501                	li	a0,0
     52c:	00001097          	auipc	ra,0x1
     530:	9ea080e7          	jalr	-1558(ra) # f16 <wait>
     534:	b1b5                	j	1a0 <go+0xf2>
        kill(getpid());
     536:	00001097          	auipc	ra,0x1
     53a:	a58080e7          	jalr	-1448(ra) # f8e <getpid>
     53e:	00001097          	auipc	ra,0x1
     542:	a00080e7          	jalr	-1536(ra) # f3e <kill>
        exit(0);
     546:	4501                	li	a0,0
     548:	00001097          	auipc	ra,0x1
     54c:	9c6080e7          	jalr	-1594(ra) # f0e <exit>
        printf("grind: fork failed\n");
     550:	00001517          	auipc	a0,0x1
     554:	0f050513          	addi	a0,a0,240 # 1640 <malloc+0x214>
     558:	00001097          	auipc	ra,0x1
     55c:	e18080e7          	jalr	-488(ra) # 1370 <printf>
        exit(1);
     560:	4505                	li	a0,1
     562:	00001097          	auipc	ra,0x1
     566:	9ac080e7          	jalr	-1620(ra) # f0e <exit>
      if(pipe(fds) < 0){
     56a:	f7840513          	addi	a0,s0,-136
     56e:	00001097          	auipc	ra,0x1
     572:	9b0080e7          	jalr	-1616(ra) # f1e <pipe>
     576:	02054b63          	bltz	a0,5ac <go+0x4fe>
      int pid = fork();
     57a:	00001097          	auipc	ra,0x1
     57e:	98c080e7          	jalr	-1652(ra) # f06 <fork>
      if(pid == 0){
     582:	c131                	beqz	a0,5c6 <go+0x518>
      } else if(pid < 0){
     584:	0a054a63          	bltz	a0,638 <go+0x58a>
      close(fds[0]);
     588:	f7842503          	lw	a0,-136(s0)
     58c:	00001097          	auipc	ra,0x1
     590:	9aa080e7          	jalr	-1622(ra) # f36 <close>
      close(fds[1]);
     594:	f7c42503          	lw	a0,-132(s0)
     598:	00001097          	auipc	ra,0x1
     59c:	99e080e7          	jalr	-1634(ra) # f36 <close>
      wait(0);
     5a0:	4501                	li	a0,0
     5a2:	00001097          	auipc	ra,0x1
     5a6:	974080e7          	jalr	-1676(ra) # f16 <wait>
     5aa:	bedd                	j	1a0 <go+0xf2>
        printf("grind: pipe failed\n");
     5ac:	00001517          	auipc	a0,0x1
     5b0:	0dc50513          	addi	a0,a0,220 # 1688 <malloc+0x25c>
     5b4:	00001097          	auipc	ra,0x1
     5b8:	dbc080e7          	jalr	-580(ra) # 1370 <printf>
        exit(1);
     5bc:	4505                	li	a0,1
     5be:	00001097          	auipc	ra,0x1
     5c2:	950080e7          	jalr	-1712(ra) # f0e <exit>
        fork();
     5c6:	00001097          	auipc	ra,0x1
     5ca:	940080e7          	jalr	-1728(ra) # f06 <fork>
        fork();
     5ce:	00001097          	auipc	ra,0x1
     5d2:	938080e7          	jalr	-1736(ra) # f06 <fork>
        if(write(fds[1], "x", 1) != 1)
     5d6:	4605                	li	a2,1
     5d8:	00001597          	auipc	a1,0x1
     5dc:	0c858593          	addi	a1,a1,200 # 16a0 <malloc+0x274>
     5e0:	f7c42503          	lw	a0,-132(s0)
     5e4:	00001097          	auipc	ra,0x1
     5e8:	94a080e7          	jalr	-1718(ra) # f2e <write>
     5ec:	4785                	li	a5,1
     5ee:	02f51363          	bne	a0,a5,614 <go+0x566>
        if(read(fds[0], &c, 1) != 1)
     5f2:	4605                	li	a2,1
     5f4:	f7040593          	addi	a1,s0,-144
     5f8:	f7842503          	lw	a0,-136(s0)
     5fc:	00001097          	auipc	ra,0x1
     600:	92a080e7          	jalr	-1750(ra) # f26 <read>
     604:	4785                	li	a5,1
     606:	02f51063          	bne	a0,a5,626 <go+0x578>
        exit(0);
     60a:	4501                	li	a0,0
     60c:	00001097          	auipc	ra,0x1
     610:	902080e7          	jalr	-1790(ra) # f0e <exit>
          printf("grind: pipe write failed\n");
     614:	00001517          	auipc	a0,0x1
     618:	09450513          	addi	a0,a0,148 # 16a8 <malloc+0x27c>
     61c:	00001097          	auipc	ra,0x1
     620:	d54080e7          	jalr	-684(ra) # 1370 <printf>
     624:	b7f9                	j	5f2 <go+0x544>
          printf("grind: pipe read failed\n");
     626:	00001517          	auipc	a0,0x1
     62a:	0a250513          	addi	a0,a0,162 # 16c8 <malloc+0x29c>
     62e:	00001097          	auipc	ra,0x1
     632:	d42080e7          	jalr	-702(ra) # 1370 <printf>
     636:	bfd1                	j	60a <go+0x55c>
        printf("grind: fork failed\n");
     638:	00001517          	auipc	a0,0x1
     63c:	00850513          	addi	a0,a0,8 # 1640 <malloc+0x214>
     640:	00001097          	auipc	ra,0x1
     644:	d30080e7          	jalr	-720(ra) # 1370 <printf>
        exit(1);
     648:	4505                	li	a0,1
     64a:	00001097          	auipc	ra,0x1
     64e:	8c4080e7          	jalr	-1852(ra) # f0e <exit>
      int pid = fork();
     652:	00001097          	auipc	ra,0x1
     656:	8b4080e7          	jalr	-1868(ra) # f06 <fork>
      if(pid == 0){
     65a:	c909                	beqz	a0,66c <go+0x5be>
      } else if(pid < 0){
     65c:	06054f63          	bltz	a0,6da <go+0x62c>
      wait(0);
     660:	4501                	li	a0,0
     662:	00001097          	auipc	ra,0x1
     666:	8b4080e7          	jalr	-1868(ra) # f16 <wait>
     66a:	be1d                	j	1a0 <go+0xf2>
        unlink("a");
     66c:	00001517          	auipc	a0,0x1
     670:	fec50513          	addi	a0,a0,-20 # 1658 <malloc+0x22c>
     674:	00001097          	auipc	ra,0x1
     678:	8ea080e7          	jalr	-1814(ra) # f5e <unlink>
        mkdir("a");
     67c:	00001517          	auipc	a0,0x1
     680:	fdc50513          	addi	a0,a0,-36 # 1658 <malloc+0x22c>
     684:	00001097          	auipc	ra,0x1
     688:	8f2080e7          	jalr	-1806(ra) # f76 <mkdir>
        chdir("a");
     68c:	00001517          	auipc	a0,0x1
     690:	fcc50513          	addi	a0,a0,-52 # 1658 <malloc+0x22c>
     694:	00001097          	auipc	ra,0x1
     698:	8ea080e7          	jalr	-1814(ra) # f7e <chdir>
        unlink("../a");
     69c:	00001517          	auipc	a0,0x1
     6a0:	04c50513          	addi	a0,a0,76 # 16e8 <malloc+0x2bc>
     6a4:	00001097          	auipc	ra,0x1
     6a8:	8ba080e7          	jalr	-1862(ra) # f5e <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     6ac:	20200593          	li	a1,514
     6b0:	00001517          	auipc	a0,0x1
     6b4:	ff050513          	addi	a0,a0,-16 # 16a0 <malloc+0x274>
     6b8:	00001097          	auipc	ra,0x1
     6bc:	896080e7          	jalr	-1898(ra) # f4e <open>
        unlink("x");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	fe050513          	addi	a0,a0,-32 # 16a0 <malloc+0x274>
     6c8:	00001097          	auipc	ra,0x1
     6cc:	896080e7          	jalr	-1898(ra) # f5e <unlink>
        exit(0);
     6d0:	4501                	li	a0,0
     6d2:	00001097          	auipc	ra,0x1
     6d6:	83c080e7          	jalr	-1988(ra) # f0e <exit>
        printf("grind: fork failed\n");
     6da:	00001517          	auipc	a0,0x1
     6de:	f6650513          	addi	a0,a0,-154 # 1640 <malloc+0x214>
     6e2:	00001097          	auipc	ra,0x1
     6e6:	c8e080e7          	jalr	-882(ra) # 1370 <printf>
        exit(1);
     6ea:	4505                	li	a0,1
     6ec:	00001097          	auipc	ra,0x1
     6f0:	822080e7          	jalr	-2014(ra) # f0e <exit>
      unlink("c");
     6f4:	00001517          	auipc	a0,0x1
     6f8:	ffc50513          	addi	a0,a0,-4 # 16f0 <malloc+0x2c4>
     6fc:	00001097          	auipc	ra,0x1
     700:	862080e7          	jalr	-1950(ra) # f5e <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     704:	20200593          	li	a1,514
     708:	00001517          	auipc	a0,0x1
     70c:	fe850513          	addi	a0,a0,-24 # 16f0 <malloc+0x2c4>
     710:	00001097          	auipc	ra,0x1
     714:	83e080e7          	jalr	-1986(ra) # f4e <open>
     718:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     71a:	04054d63          	bltz	a0,774 <go+0x6c6>
      if(write(fd1, "x", 1) != 1){
     71e:	865e                	mv	a2,s7
     720:	00001597          	auipc	a1,0x1
     724:	f8058593          	addi	a1,a1,-128 # 16a0 <malloc+0x274>
     728:	00001097          	auipc	ra,0x1
     72c:	806080e7          	jalr	-2042(ra) # f2e <write>
     730:	05751f63          	bne	a0,s7,78e <go+0x6e0>
      if(fstat(fd1, &st) != 0){
     734:	f7840593          	addi	a1,s0,-136
     738:	856a                	mv	a0,s10
     73a:	00001097          	auipc	ra,0x1
     73e:	82c080e7          	jalr	-2004(ra) # f66 <fstat>
     742:	e13d                	bnez	a0,7a8 <go+0x6fa>
      if(st.size != 1){
     744:	f8843583          	ld	a1,-120(s0)
     748:	07759d63          	bne	a1,s7,7c2 <go+0x714>
      if(st.ino > 200){
     74c:	f7c42583          	lw	a1,-132(s0)
     750:	0c800793          	li	a5,200
     754:	08b7e563          	bltu	a5,a1,7de <go+0x730>
      close(fd1);
     758:	856a                	mv	a0,s10
     75a:	00000097          	auipc	ra,0x0
     75e:	7dc080e7          	jalr	2012(ra) # f36 <close>
      unlink("c");
     762:	00001517          	auipc	a0,0x1
     766:	f8e50513          	addi	a0,a0,-114 # 16f0 <malloc+0x2c4>
     76a:	00000097          	auipc	ra,0x0
     76e:	7f4080e7          	jalr	2036(ra) # f5e <unlink>
     772:	b43d                	j	1a0 <go+0xf2>
        printf("grind: create c failed\n");
     774:	00001517          	auipc	a0,0x1
     778:	f8450513          	addi	a0,a0,-124 # 16f8 <malloc+0x2cc>
     77c:	00001097          	auipc	ra,0x1
     780:	bf4080e7          	jalr	-1036(ra) # 1370 <printf>
        exit(1);
     784:	4505                	li	a0,1
     786:	00000097          	auipc	ra,0x0
     78a:	788080e7          	jalr	1928(ra) # f0e <exit>
        printf("grind: write c failed\n");
     78e:	00001517          	auipc	a0,0x1
     792:	f8250513          	addi	a0,a0,-126 # 1710 <malloc+0x2e4>
     796:	00001097          	auipc	ra,0x1
     79a:	bda080e7          	jalr	-1062(ra) # 1370 <printf>
        exit(1);
     79e:	4505                	li	a0,1
     7a0:	00000097          	auipc	ra,0x0
     7a4:	76e080e7          	jalr	1902(ra) # f0e <exit>
        printf("grind: fstat failed\n");
     7a8:	00001517          	auipc	a0,0x1
     7ac:	f8050513          	addi	a0,a0,-128 # 1728 <malloc+0x2fc>
     7b0:	00001097          	auipc	ra,0x1
     7b4:	bc0080e7          	jalr	-1088(ra) # 1370 <printf>
        exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00000097          	auipc	ra,0x0
     7be:	754080e7          	jalr	1876(ra) # f0e <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     7c2:	2581                	sext.w	a1,a1
     7c4:	00001517          	auipc	a0,0x1
     7c8:	f7c50513          	addi	a0,a0,-132 # 1740 <malloc+0x314>
     7cc:	00001097          	auipc	ra,0x1
     7d0:	ba4080e7          	jalr	-1116(ra) # 1370 <printf>
        exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00000097          	auipc	ra,0x0
     7da:	738080e7          	jalr	1848(ra) # f0e <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     7de:	00001517          	auipc	a0,0x1
     7e2:	f8a50513          	addi	a0,a0,-118 # 1768 <malloc+0x33c>
     7e6:	00001097          	auipc	ra,0x1
     7ea:	b8a080e7          	jalr	-1142(ra) # 1370 <printf>
        exit(1);
     7ee:	4505                	li	a0,1
     7f0:	00000097          	auipc	ra,0x0
     7f4:	71e080e7          	jalr	1822(ra) # f0e <exit>
      if(pipe(aa) < 0){
     7f8:	856e                	mv	a0,s11
     7fa:	00000097          	auipc	ra,0x0
     7fe:	724080e7          	jalr	1828(ra) # f1e <pipe>
     802:	10054063          	bltz	a0,902 <go+0x854>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     806:	f7040513          	addi	a0,s0,-144
     80a:	00000097          	auipc	ra,0x0
     80e:	714080e7          	jalr	1812(ra) # f1e <pipe>
     812:	10054663          	bltz	a0,91e <go+0x870>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     816:	00000097          	auipc	ra,0x0
     81a:	6f0080e7          	jalr	1776(ra) # f06 <fork>
      if(pid1 == 0){
     81e:	10050e63          	beqz	a0,93a <go+0x88c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     822:	1c054663          	bltz	a0,9ee <go+0x940>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     826:	00000097          	auipc	ra,0x0
     82a:	6e0080e7          	jalr	1760(ra) # f06 <fork>
      if(pid2 == 0){
     82e:	1c050e63          	beqz	a0,a0a <go+0x95c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     832:	2a054a63          	bltz	a0,ae6 <go+0xa38>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     836:	f6842503          	lw	a0,-152(s0)
     83a:	00000097          	auipc	ra,0x0
     83e:	6fc080e7          	jalr	1788(ra) # f36 <close>
      close(aa[1]);
     842:	f6c42503          	lw	a0,-148(s0)
     846:	00000097          	auipc	ra,0x0
     84a:	6f0080e7          	jalr	1776(ra) # f36 <close>
      close(bb[1]);
     84e:	f7442503          	lw	a0,-140(s0)
     852:	00000097          	auipc	ra,0x0
     856:	6e4080e7          	jalr	1764(ra) # f36 <close>
      char buf[4] = { 0, 0, 0, 0 };
     85a:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     85e:	865e                	mv	a2,s7
     860:	f6040593          	addi	a1,s0,-160
     864:	f7042503          	lw	a0,-144(s0)
     868:	00000097          	auipc	ra,0x0
     86c:	6be080e7          	jalr	1726(ra) # f26 <read>
      read(bb[0], buf+1, 1);
     870:	865e                	mv	a2,s7
     872:	f6140593          	addi	a1,s0,-159
     876:	f7042503          	lw	a0,-144(s0)
     87a:	00000097          	auipc	ra,0x0
     87e:	6ac080e7          	jalr	1708(ra) # f26 <read>
      read(bb[0], buf+2, 1);
     882:	865e                	mv	a2,s7
     884:	f6240593          	addi	a1,s0,-158
     888:	f7042503          	lw	a0,-144(s0)
     88c:	00000097          	auipc	ra,0x0
     890:	69a080e7          	jalr	1690(ra) # f26 <read>
      close(bb[0]);
     894:	f7042503          	lw	a0,-144(s0)
     898:	00000097          	auipc	ra,0x0
     89c:	69e080e7          	jalr	1694(ra) # f36 <close>
      int st1, st2;
      wait(&st1);
     8a0:	f6440513          	addi	a0,s0,-156
     8a4:	00000097          	auipc	ra,0x0
     8a8:	672080e7          	jalr	1650(ra) # f16 <wait>
      wait(&st2);
     8ac:	f7840513          	addi	a0,s0,-136
     8b0:	00000097          	auipc	ra,0x0
     8b4:	666080e7          	jalr	1638(ra) # f16 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     8b8:	f6442783          	lw	a5,-156(s0)
     8bc:	f7842703          	lw	a4,-136(s0)
     8c0:	8fd9                	or	a5,a5,a4
     8c2:	ef89                	bnez	a5,8dc <go+0x82e>
     8c4:	00001597          	auipc	a1,0x1
     8c8:	f4458593          	addi	a1,a1,-188 # 1808 <malloc+0x3dc>
     8cc:	f6040513          	addi	a0,s0,-160
     8d0:	00000097          	auipc	ra,0x0
     8d4:	3be080e7          	jalr	958(ra) # c8e <strcmp>
     8d8:	8c0504e3          	beqz	a0,1a0 <go+0xf2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     8dc:	f6040693          	addi	a3,s0,-160
     8e0:	f7842603          	lw	a2,-136(s0)
     8e4:	f6442583          	lw	a1,-156(s0)
     8e8:	00001517          	auipc	a0,0x1
     8ec:	f2850513          	addi	a0,a0,-216 # 1810 <malloc+0x3e4>
     8f0:	00001097          	auipc	ra,0x1
     8f4:	a80080e7          	jalr	-1408(ra) # 1370 <printf>
        exit(1);
     8f8:	4505                	li	a0,1
     8fa:	00000097          	auipc	ra,0x0
     8fe:	614080e7          	jalr	1556(ra) # f0e <exit>
        fprintf(2, "grind: pipe failed\n");
     902:	00001597          	auipc	a1,0x1
     906:	d8658593          	addi	a1,a1,-634 # 1688 <malloc+0x25c>
     90a:	4509                	li	a0,2
     90c:	00001097          	auipc	ra,0x1
     910:	a36080e7          	jalr	-1482(ra) # 1342 <fprintf>
        exit(1);
     914:	4505                	li	a0,1
     916:	00000097          	auipc	ra,0x0
     91a:	5f8080e7          	jalr	1528(ra) # f0e <exit>
        fprintf(2, "grind: pipe failed\n");
     91e:	00001597          	auipc	a1,0x1
     922:	d6a58593          	addi	a1,a1,-662 # 1688 <malloc+0x25c>
     926:	4509                	li	a0,2
     928:	00001097          	auipc	ra,0x1
     92c:	a1a080e7          	jalr	-1510(ra) # 1342 <fprintf>
        exit(1);
     930:	4505                	li	a0,1
     932:	00000097          	auipc	ra,0x0
     936:	5dc080e7          	jalr	1500(ra) # f0e <exit>
        close(bb[0]);
     93a:	f7042503          	lw	a0,-144(s0)
     93e:	00000097          	auipc	ra,0x0
     942:	5f8080e7          	jalr	1528(ra) # f36 <close>
        close(bb[1]);
     946:	f7442503          	lw	a0,-140(s0)
     94a:	00000097          	auipc	ra,0x0
     94e:	5ec080e7          	jalr	1516(ra) # f36 <close>
        close(aa[0]);
     952:	f6842503          	lw	a0,-152(s0)
     956:	00000097          	auipc	ra,0x0
     95a:	5e0080e7          	jalr	1504(ra) # f36 <close>
        close(1);
     95e:	4505                	li	a0,1
     960:	00000097          	auipc	ra,0x0
     964:	5d6080e7          	jalr	1494(ra) # f36 <close>
        if(dup(aa[1]) != 1){
     968:	f6c42503          	lw	a0,-148(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	61a080e7          	jalr	1562(ra) # f86 <dup>
     974:	4785                	li	a5,1
     976:	02f50063          	beq	a0,a5,996 <go+0x8e8>
          fprintf(2, "grind: dup failed\n");
     97a:	00001597          	auipc	a1,0x1
     97e:	e1658593          	addi	a1,a1,-490 # 1790 <malloc+0x364>
     982:	4509                	li	a0,2
     984:	00001097          	auipc	ra,0x1
     988:	9be080e7          	jalr	-1602(ra) # 1342 <fprintf>
          exit(1);
     98c:	4505                	li	a0,1
     98e:	00000097          	auipc	ra,0x0
     992:	580080e7          	jalr	1408(ra) # f0e <exit>
        close(aa[1]);
     996:	f6c42503          	lw	a0,-148(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	59c080e7          	jalr	1436(ra) # f36 <close>
        char *args[3] = { "echo", "hi", 0 };
     9a2:	00001797          	auipc	a5,0x1
     9a6:	e0678793          	addi	a5,a5,-506 # 17a8 <malloc+0x37c>
     9aa:	f6f43c23          	sd	a5,-136(s0)
     9ae:	00001797          	auipc	a5,0x1
     9b2:	e0278793          	addi	a5,a5,-510 # 17b0 <malloc+0x384>
     9b6:	f8f43023          	sd	a5,-128(s0)
     9ba:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     9be:	f7840593          	addi	a1,s0,-136
     9c2:	00001517          	auipc	a0,0x1
     9c6:	df650513          	addi	a0,a0,-522 # 17b8 <malloc+0x38c>
     9ca:	00000097          	auipc	ra,0x0
     9ce:	57c080e7          	jalr	1404(ra) # f46 <exec>
        fprintf(2, "grind: echo: not found\n");
     9d2:	00001597          	auipc	a1,0x1
     9d6:	df658593          	addi	a1,a1,-522 # 17c8 <malloc+0x39c>
     9da:	4509                	li	a0,2
     9dc:	00001097          	auipc	ra,0x1
     9e0:	966080e7          	jalr	-1690(ra) # 1342 <fprintf>
        exit(2);
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	528080e7          	jalr	1320(ra) # f0e <exit>
        fprintf(2, "grind: fork failed\n");
     9ee:	00001597          	auipc	a1,0x1
     9f2:	c5258593          	addi	a1,a1,-942 # 1640 <malloc+0x214>
     9f6:	4509                	li	a0,2
     9f8:	00001097          	auipc	ra,0x1
     9fc:	94a080e7          	jalr	-1718(ra) # 1342 <fprintf>
        exit(3);
     a00:	450d                	li	a0,3
     a02:	00000097          	auipc	ra,0x0
     a06:	50c080e7          	jalr	1292(ra) # f0e <exit>
        close(aa[1]);
     a0a:	f6c42503          	lw	a0,-148(s0)
     a0e:	00000097          	auipc	ra,0x0
     a12:	528080e7          	jalr	1320(ra) # f36 <close>
        close(bb[0]);
     a16:	f7042503          	lw	a0,-144(s0)
     a1a:	00000097          	auipc	ra,0x0
     a1e:	51c080e7          	jalr	1308(ra) # f36 <close>
        close(0);
     a22:	4501                	li	a0,0
     a24:	00000097          	auipc	ra,0x0
     a28:	512080e7          	jalr	1298(ra) # f36 <close>
        if(dup(aa[0]) != 0){
     a2c:	f6842503          	lw	a0,-152(s0)
     a30:	00000097          	auipc	ra,0x0
     a34:	556080e7          	jalr	1366(ra) # f86 <dup>
     a38:	cd19                	beqz	a0,a56 <go+0x9a8>
          fprintf(2, "grind: dup failed\n");
     a3a:	00001597          	auipc	a1,0x1
     a3e:	d5658593          	addi	a1,a1,-682 # 1790 <malloc+0x364>
     a42:	4509                	li	a0,2
     a44:	00001097          	auipc	ra,0x1
     a48:	8fe080e7          	jalr	-1794(ra) # 1342 <fprintf>
          exit(4);
     a4c:	4511                	li	a0,4
     a4e:	00000097          	auipc	ra,0x0
     a52:	4c0080e7          	jalr	1216(ra) # f0e <exit>
        close(aa[0]);
     a56:	f6842503          	lw	a0,-152(s0)
     a5a:	00000097          	auipc	ra,0x0
     a5e:	4dc080e7          	jalr	1244(ra) # f36 <close>
        close(1);
     a62:	4505                	li	a0,1
     a64:	00000097          	auipc	ra,0x0
     a68:	4d2080e7          	jalr	1234(ra) # f36 <close>
        if(dup(bb[1]) != 1){
     a6c:	f7442503          	lw	a0,-140(s0)
     a70:	00000097          	auipc	ra,0x0
     a74:	516080e7          	jalr	1302(ra) # f86 <dup>
     a78:	4785                	li	a5,1
     a7a:	02f50063          	beq	a0,a5,a9a <go+0x9ec>
          fprintf(2, "grind: dup failed\n");
     a7e:	00001597          	auipc	a1,0x1
     a82:	d1258593          	addi	a1,a1,-750 # 1790 <malloc+0x364>
     a86:	4509                	li	a0,2
     a88:	00001097          	auipc	ra,0x1
     a8c:	8ba080e7          	jalr	-1862(ra) # 1342 <fprintf>
          exit(5);
     a90:	4515                	li	a0,5
     a92:	00000097          	auipc	ra,0x0
     a96:	47c080e7          	jalr	1148(ra) # f0e <exit>
        close(bb[1]);
     a9a:	f7442503          	lw	a0,-140(s0)
     a9e:	00000097          	auipc	ra,0x0
     aa2:	498080e7          	jalr	1176(ra) # f36 <close>
        char *args[2] = { "cat", 0 };
     aa6:	00001797          	auipc	a5,0x1
     aaa:	d3a78793          	addi	a5,a5,-710 # 17e0 <malloc+0x3b4>
     aae:	f6f43c23          	sd	a5,-136(s0)
     ab2:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     ab6:	f7840593          	addi	a1,s0,-136
     aba:	00001517          	auipc	a0,0x1
     abe:	d2e50513          	addi	a0,a0,-722 # 17e8 <malloc+0x3bc>
     ac2:	00000097          	auipc	ra,0x0
     ac6:	484080e7          	jalr	1156(ra) # f46 <exec>
        fprintf(2, "grind: cat: not found\n");
     aca:	00001597          	auipc	a1,0x1
     ace:	d2658593          	addi	a1,a1,-730 # 17f0 <malloc+0x3c4>
     ad2:	4509                	li	a0,2
     ad4:	00001097          	auipc	ra,0x1
     ad8:	86e080e7          	jalr	-1938(ra) # 1342 <fprintf>
        exit(6);
     adc:	4519                	li	a0,6
     ade:	00000097          	auipc	ra,0x0
     ae2:	430080e7          	jalr	1072(ra) # f0e <exit>
        fprintf(2, "grind: fork failed\n");
     ae6:	00001597          	auipc	a1,0x1
     aea:	b5a58593          	addi	a1,a1,-1190 # 1640 <malloc+0x214>
     aee:	4509                	li	a0,2
     af0:	00001097          	auipc	ra,0x1
     af4:	852080e7          	jalr	-1966(ra) # 1342 <fprintf>
        exit(7);
     af8:	451d                	li	a0,7
     afa:	00000097          	auipc	ra,0x0
     afe:	414080e7          	jalr	1044(ra) # f0e <exit>

0000000000000b02 <iter>:
  }
}

void
iter()
{
     b02:	7179                	addi	sp,sp,-48
     b04:	f406                	sd	ra,40(sp)
     b06:	f022                	sd	s0,32(sp)
     b08:	1800                	addi	s0,sp,48
  unlink("a");
     b0a:	00001517          	auipc	a0,0x1
     b0e:	b4e50513          	addi	a0,a0,-1202 # 1658 <malloc+0x22c>
     b12:	00000097          	auipc	ra,0x0
     b16:	44c080e7          	jalr	1100(ra) # f5e <unlink>
  unlink("b");
     b1a:	00001517          	auipc	a0,0x1
     b1e:	aee50513          	addi	a0,a0,-1298 # 1608 <malloc+0x1dc>
     b22:	00000097          	auipc	ra,0x0
     b26:	43c080e7          	jalr	1084(ra) # f5e <unlink>
  
  int pid1 = fork();
     b2a:	00000097          	auipc	ra,0x0
     b2e:	3dc080e7          	jalr	988(ra) # f06 <fork>
  if(pid1 < 0){
     b32:	02054363          	bltz	a0,b58 <iter+0x56>
     b36:	ec26                	sd	s1,24(sp)
     b38:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b3a:	ed15                	bnez	a0,b76 <iter+0x74>
     b3c:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     b3e:	00001717          	auipc	a4,0x1
     b42:	4c270713          	addi	a4,a4,1218 # 2000 <rand_next>
     b46:	631c                	ld	a5,0(a4)
     b48:	01f7c793          	xori	a5,a5,31
     b4c:	e31c                	sd	a5,0(a4)
    go(0);
     b4e:	4501                	li	a0,0
     b50:	fffff097          	auipc	ra,0xfffff
     b54:	55e080e7          	jalr	1374(ra) # ae <go>
     b58:	ec26                	sd	s1,24(sp)
     b5a:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     b5c:	00001517          	auipc	a0,0x1
     b60:	ae450513          	addi	a0,a0,-1308 # 1640 <malloc+0x214>
     b64:	00001097          	auipc	ra,0x1
     b68:	80c080e7          	jalr	-2036(ra) # 1370 <printf>
    exit(1);
     b6c:	4505                	li	a0,1
     b6e:	00000097          	auipc	ra,0x0
     b72:	3a0080e7          	jalr	928(ra) # f0e <exit>
     b76:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     b78:	00000097          	auipc	ra,0x0
     b7c:	38e080e7          	jalr	910(ra) # f06 <fork>
     b80:	892a                	mv	s2,a0
  if(pid2 < 0){
     b82:	02054263          	bltz	a0,ba6 <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b86:	ed0d                	bnez	a0,bc0 <iter+0xbe>
    rand_next ^= 7177;
     b88:	00001697          	auipc	a3,0x1
     b8c:	47868693          	addi	a3,a3,1144 # 2000 <rand_next>
     b90:	629c                	ld	a5,0(a3)
     b92:	6709                	lui	a4,0x2
     b94:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x369>
     b98:	8fb9                	xor	a5,a5,a4
     b9a:	e29c                	sd	a5,0(a3)
    go(1);
     b9c:	4505                	li	a0,1
     b9e:	fffff097          	auipc	ra,0xfffff
     ba2:	510080e7          	jalr	1296(ra) # ae <go>
    printf("grind: fork failed\n");
     ba6:	00001517          	auipc	a0,0x1
     baa:	a9a50513          	addi	a0,a0,-1382 # 1640 <malloc+0x214>
     bae:	00000097          	auipc	ra,0x0
     bb2:	7c2080e7          	jalr	1986(ra) # 1370 <printf>
    exit(1);
     bb6:	4505                	li	a0,1
     bb8:	00000097          	auipc	ra,0x0
     bbc:	356080e7          	jalr	854(ra) # f0e <exit>
    exit(0);
  }

  int st1 = -1;
     bc0:	57fd                	li	a5,-1
     bc2:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     bc6:	fdc40513          	addi	a0,s0,-36
     bca:	00000097          	auipc	ra,0x0
     bce:	34c080e7          	jalr	844(ra) # f16 <wait>
  if(st1 != 0){
     bd2:	fdc42783          	lw	a5,-36(s0)
     bd6:	ef99                	bnez	a5,bf4 <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     bd8:	57fd                	li	a5,-1
     bda:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     bde:	fd840513          	addi	a0,s0,-40
     be2:	00000097          	auipc	ra,0x0
     be6:	334080e7          	jalr	820(ra) # f16 <wait>

  exit(0);
     bea:	4501                	li	a0,0
     bec:	00000097          	auipc	ra,0x0
     bf0:	322080e7          	jalr	802(ra) # f0e <exit>
    kill(pid1);
     bf4:	8526                	mv	a0,s1
     bf6:	00000097          	auipc	ra,0x0
     bfa:	348080e7          	jalr	840(ra) # f3e <kill>
    kill(pid2);
     bfe:	854a                	mv	a0,s2
     c00:	00000097          	auipc	ra,0x0
     c04:	33e080e7          	jalr	830(ra) # f3e <kill>
     c08:	bfc1                	j	bd8 <iter+0xd6>

0000000000000c0a <main>:
}

int
main()
{
     c0a:	1101                	addi	sp,sp,-32
     c0c:	ec06                	sd	ra,24(sp)
     c0e:	e822                	sd	s0,16(sp)
     c10:	e426                	sd	s1,8(sp)
     c12:	e04a                	sd	s2,0(sp)
     c14:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     c16:	4951                	li	s2,20
    rand_next += 1;
     c18:	00001497          	auipc	s1,0x1
     c1c:	3e848493          	addi	s1,s1,1000 # 2000 <rand_next>
     c20:	a829                	j	c3a <main+0x30>
      iter();
     c22:	00000097          	auipc	ra,0x0
     c26:	ee0080e7          	jalr	-288(ra) # b02 <iter>
    sleep(20);
     c2a:	854a                	mv	a0,s2
     c2c:	00000097          	auipc	ra,0x0
     c30:	372080e7          	jalr	882(ra) # f9e <sleep>
    rand_next += 1;
     c34:	609c                	ld	a5,0(s1)
     c36:	0785                	addi	a5,a5,1
     c38:	e09c                	sd	a5,0(s1)
    int pid = fork();
     c3a:	00000097          	auipc	ra,0x0
     c3e:	2cc080e7          	jalr	716(ra) # f06 <fork>
    if(pid == 0){
     c42:	d165                	beqz	a0,c22 <main+0x18>
    if(pid > 0){
     c44:	fea053e3          	blez	a0,c2a <main+0x20>
      wait(0);
     c48:	4501                	li	a0,0
     c4a:	00000097          	auipc	ra,0x0
     c4e:	2cc080e7          	jalr	716(ra) # f16 <wait>
     c52:	bfe1                	j	c2a <main+0x20>

0000000000000c54 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     c54:	1141                	addi	sp,sp,-16
     c56:	e406                	sd	ra,8(sp)
     c58:	e022                	sd	s0,0(sp)
     c5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c5c:	00000097          	auipc	ra,0x0
     c60:	fae080e7          	jalr	-82(ra) # c0a <main>
  exit(0);
     c64:	4501                	li	a0,0
     c66:	00000097          	auipc	ra,0x0
     c6a:	2a8080e7          	jalr	680(ra) # f0e <exit>

0000000000000c6e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c6e:	1141                	addi	sp,sp,-16
     c70:	e406                	sd	ra,8(sp)
     c72:	e022                	sd	s0,0(sp)
     c74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c76:	87aa                	mv	a5,a0
     c78:	0585                	addi	a1,a1,1
     c7a:	0785                	addi	a5,a5,1
     c7c:	fff5c703          	lbu	a4,-1(a1)
     c80:	fee78fa3          	sb	a4,-1(a5)
     c84:	fb75                	bnez	a4,c78 <strcpy+0xa>
    ;
  return os;
}
     c86:	60a2                	ld	ra,8(sp)
     c88:	6402                	ld	s0,0(sp)
     c8a:	0141                	addi	sp,sp,16
     c8c:	8082                	ret

0000000000000c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c8e:	1141                	addi	sp,sp,-16
     c90:	e406                	sd	ra,8(sp)
     c92:	e022                	sd	s0,0(sp)
     c94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c96:	00054783          	lbu	a5,0(a0)
     c9a:	cb91                	beqz	a5,cae <strcmp+0x20>
     c9c:	0005c703          	lbu	a4,0(a1)
     ca0:	00f71763          	bne	a4,a5,cae <strcmp+0x20>
    p++, q++;
     ca4:	0505                	addi	a0,a0,1
     ca6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     ca8:	00054783          	lbu	a5,0(a0)
     cac:	fbe5                	bnez	a5,c9c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     cae:	0005c503          	lbu	a0,0(a1)
}
     cb2:	40a7853b          	subw	a0,a5,a0
     cb6:	60a2                	ld	ra,8(sp)
     cb8:	6402                	ld	s0,0(sp)
     cba:	0141                	addi	sp,sp,16
     cbc:	8082                	ret

0000000000000cbe <strlen>:

uint
strlen(const char *s)
{
     cbe:	1141                	addi	sp,sp,-16
     cc0:	e406                	sd	ra,8(sp)
     cc2:	e022                	sd	s0,0(sp)
     cc4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     cc6:	00054783          	lbu	a5,0(a0)
     cca:	cf99                	beqz	a5,ce8 <strlen+0x2a>
     ccc:	0505                	addi	a0,a0,1
     cce:	87aa                	mv	a5,a0
     cd0:	86be                	mv	a3,a5
     cd2:	0785                	addi	a5,a5,1
     cd4:	fff7c703          	lbu	a4,-1(a5)
     cd8:	ff65                	bnez	a4,cd0 <strlen+0x12>
     cda:	40a6853b          	subw	a0,a3,a0
     cde:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     ce0:	60a2                	ld	ra,8(sp)
     ce2:	6402                	ld	s0,0(sp)
     ce4:	0141                	addi	sp,sp,16
     ce6:	8082                	ret
  for(n = 0; s[n]; n++)
     ce8:	4501                	li	a0,0
     cea:	bfdd                	j	ce0 <strlen+0x22>

0000000000000cec <memset>:

void*
memset(void *dst, int c, uint n)
{
     cec:	1141                	addi	sp,sp,-16
     cee:	e406                	sd	ra,8(sp)
     cf0:	e022                	sd	s0,0(sp)
     cf2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     cf4:	ca19                	beqz	a2,d0a <memset+0x1e>
     cf6:	87aa                	mv	a5,a0
     cf8:	1602                	slli	a2,a2,0x20
     cfa:	9201                	srli	a2,a2,0x20
     cfc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d00:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d04:	0785                	addi	a5,a5,1
     d06:	fee79de3          	bne	a5,a4,d00 <memset+0x14>
  }
  return dst;
}
     d0a:	60a2                	ld	ra,8(sp)
     d0c:	6402                	ld	s0,0(sp)
     d0e:	0141                	addi	sp,sp,16
     d10:	8082                	ret

0000000000000d12 <strchr>:

char*
strchr(const char *s, char c)
{
     d12:	1141                	addi	sp,sp,-16
     d14:	e406                	sd	ra,8(sp)
     d16:	e022                	sd	s0,0(sp)
     d18:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d1a:	00054783          	lbu	a5,0(a0)
     d1e:	cf81                	beqz	a5,d36 <strchr+0x24>
    if(*s == c)
     d20:	00f58763          	beq	a1,a5,d2e <strchr+0x1c>
  for(; *s; s++)
     d24:	0505                	addi	a0,a0,1
     d26:	00054783          	lbu	a5,0(a0)
     d2a:	fbfd                	bnez	a5,d20 <strchr+0xe>
      return (char*)s;
  return 0;
     d2c:	4501                	li	a0,0
}
     d2e:	60a2                	ld	ra,8(sp)
     d30:	6402                	ld	s0,0(sp)
     d32:	0141                	addi	sp,sp,16
     d34:	8082                	ret
  return 0;
     d36:	4501                	li	a0,0
     d38:	bfdd                	j	d2e <strchr+0x1c>

0000000000000d3a <gets>:

char*
gets(char *buf, int max)
{
     d3a:	7159                	addi	sp,sp,-112
     d3c:	f486                	sd	ra,104(sp)
     d3e:	f0a2                	sd	s0,96(sp)
     d40:	eca6                	sd	s1,88(sp)
     d42:	e8ca                	sd	s2,80(sp)
     d44:	e4ce                	sd	s3,72(sp)
     d46:	e0d2                	sd	s4,64(sp)
     d48:	fc56                	sd	s5,56(sp)
     d4a:	f85a                	sd	s6,48(sp)
     d4c:	f45e                	sd	s7,40(sp)
     d4e:	f062                	sd	s8,32(sp)
     d50:	ec66                	sd	s9,24(sp)
     d52:	e86a                	sd	s10,16(sp)
     d54:	1880                	addi	s0,sp,112
     d56:	8caa                	mv	s9,a0
     d58:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d5a:	892a                	mv	s2,a0
     d5c:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d5e:	f9f40b13          	addi	s6,s0,-97
     d62:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d64:	4ba9                	li	s7,10
     d66:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     d68:	8d26                	mv	s10,s1
     d6a:	0014899b          	addiw	s3,s1,1
     d6e:	84ce                	mv	s1,s3
     d70:	0349d763          	bge	s3,s4,d9e <gets+0x64>
    cc = read(0, &c, 1);
     d74:	8656                	mv	a2,s5
     d76:	85da                	mv	a1,s6
     d78:	4501                	li	a0,0
     d7a:	00000097          	auipc	ra,0x0
     d7e:	1ac080e7          	jalr	428(ra) # f26 <read>
    if(cc < 1)
     d82:	00a05e63          	blez	a0,d9e <gets+0x64>
    buf[i++] = c;
     d86:	f9f44783          	lbu	a5,-97(s0)
     d8a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d8e:	01778763          	beq	a5,s7,d9c <gets+0x62>
     d92:	0905                	addi	s2,s2,1
     d94:	fd879ae3          	bne	a5,s8,d68 <gets+0x2e>
    buf[i++] = c;
     d98:	8d4e                	mv	s10,s3
     d9a:	a011                	j	d9e <gets+0x64>
     d9c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     d9e:	9d66                	add	s10,s10,s9
     da0:	000d0023          	sb	zero,0(s10)
  return buf;
}
     da4:	8566                	mv	a0,s9
     da6:	70a6                	ld	ra,104(sp)
     da8:	7406                	ld	s0,96(sp)
     daa:	64e6                	ld	s1,88(sp)
     dac:	6946                	ld	s2,80(sp)
     dae:	69a6                	ld	s3,72(sp)
     db0:	6a06                	ld	s4,64(sp)
     db2:	7ae2                	ld	s5,56(sp)
     db4:	7b42                	ld	s6,48(sp)
     db6:	7ba2                	ld	s7,40(sp)
     db8:	7c02                	ld	s8,32(sp)
     dba:	6ce2                	ld	s9,24(sp)
     dbc:	6d42                	ld	s10,16(sp)
     dbe:	6165                	addi	sp,sp,112
     dc0:	8082                	ret

0000000000000dc2 <stat>:

int
stat(const char *n, struct stat *st)
{
     dc2:	1101                	addi	sp,sp,-32
     dc4:	ec06                	sd	ra,24(sp)
     dc6:	e822                	sd	s0,16(sp)
     dc8:	e04a                	sd	s2,0(sp)
     dca:	1000                	addi	s0,sp,32
     dcc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dce:	4581                	li	a1,0
     dd0:	00000097          	auipc	ra,0x0
     dd4:	17e080e7          	jalr	382(ra) # f4e <open>
  if(fd < 0)
     dd8:	02054663          	bltz	a0,e04 <stat+0x42>
     ddc:	e426                	sd	s1,8(sp)
     dde:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     de0:	85ca                	mv	a1,s2
     de2:	00000097          	auipc	ra,0x0
     de6:	184080e7          	jalr	388(ra) # f66 <fstat>
     dea:	892a                	mv	s2,a0
  close(fd);
     dec:	8526                	mv	a0,s1
     dee:	00000097          	auipc	ra,0x0
     df2:	148080e7          	jalr	328(ra) # f36 <close>
  return r;
     df6:	64a2                	ld	s1,8(sp)
}
     df8:	854a                	mv	a0,s2
     dfa:	60e2                	ld	ra,24(sp)
     dfc:	6442                	ld	s0,16(sp)
     dfe:	6902                	ld	s2,0(sp)
     e00:	6105                	addi	sp,sp,32
     e02:	8082                	ret
    return -1;
     e04:	597d                	li	s2,-1
     e06:	bfcd                	j	df8 <stat+0x36>

0000000000000e08 <atoi>:

int
atoi(const char *s)
{
     e08:	1141                	addi	sp,sp,-16
     e0a:	e406                	sd	ra,8(sp)
     e0c:	e022                	sd	s0,0(sp)
     e0e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e10:	00054683          	lbu	a3,0(a0)
     e14:	fd06879b          	addiw	a5,a3,-48
     e18:	0ff7f793          	zext.b	a5,a5
     e1c:	4625                	li	a2,9
     e1e:	02f66963          	bltu	a2,a5,e50 <atoi+0x48>
     e22:	872a                	mv	a4,a0
  n = 0;
     e24:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e26:	0705                	addi	a4,a4,1
     e28:	0025179b          	slliw	a5,a0,0x2
     e2c:	9fa9                	addw	a5,a5,a0
     e2e:	0017979b          	slliw	a5,a5,0x1
     e32:	9fb5                	addw	a5,a5,a3
     e34:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e38:	00074683          	lbu	a3,0(a4)
     e3c:	fd06879b          	addiw	a5,a3,-48
     e40:	0ff7f793          	zext.b	a5,a5
     e44:	fef671e3          	bgeu	a2,a5,e26 <atoi+0x1e>
  return n;
}
     e48:	60a2                	ld	ra,8(sp)
     e4a:	6402                	ld	s0,0(sp)
     e4c:	0141                	addi	sp,sp,16
     e4e:	8082                	ret
  n = 0;
     e50:	4501                	li	a0,0
     e52:	bfdd                	j	e48 <atoi+0x40>

0000000000000e54 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e54:	1141                	addi	sp,sp,-16
     e56:	e406                	sd	ra,8(sp)
     e58:	e022                	sd	s0,0(sp)
     e5a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e5c:	02b57563          	bgeu	a0,a1,e86 <memmove+0x32>
    while(n-- > 0)
     e60:	00c05f63          	blez	a2,e7e <memmove+0x2a>
     e64:	1602                	slli	a2,a2,0x20
     e66:	9201                	srli	a2,a2,0x20
     e68:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e6c:	872a                	mv	a4,a0
      *dst++ = *src++;
     e6e:	0585                	addi	a1,a1,1
     e70:	0705                	addi	a4,a4,1
     e72:	fff5c683          	lbu	a3,-1(a1)
     e76:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e7a:	fee79ae3          	bne	a5,a4,e6e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e7e:	60a2                	ld	ra,8(sp)
     e80:	6402                	ld	s0,0(sp)
     e82:	0141                	addi	sp,sp,16
     e84:	8082                	ret
    dst += n;
     e86:	00c50733          	add	a4,a0,a2
    src += n;
     e8a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e8c:	fec059e3          	blez	a2,e7e <memmove+0x2a>
     e90:	fff6079b          	addiw	a5,a2,-1
     e94:	1782                	slli	a5,a5,0x20
     e96:	9381                	srli	a5,a5,0x20
     e98:	fff7c793          	not	a5,a5
     e9c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e9e:	15fd                	addi	a1,a1,-1
     ea0:	177d                	addi	a4,a4,-1
     ea2:	0005c683          	lbu	a3,0(a1)
     ea6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     eaa:	fef71ae3          	bne	a4,a5,e9e <memmove+0x4a>
     eae:	bfc1                	j	e7e <memmove+0x2a>

0000000000000eb0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     eb0:	1141                	addi	sp,sp,-16
     eb2:	e406                	sd	ra,8(sp)
     eb4:	e022                	sd	s0,0(sp)
     eb6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     eb8:	ca0d                	beqz	a2,eea <memcmp+0x3a>
     eba:	fff6069b          	addiw	a3,a2,-1
     ebe:	1682                	slli	a3,a3,0x20
     ec0:	9281                	srli	a3,a3,0x20
     ec2:	0685                	addi	a3,a3,1
     ec4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ec6:	00054783          	lbu	a5,0(a0)
     eca:	0005c703          	lbu	a4,0(a1)
     ece:	00e79863          	bne	a5,a4,ede <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     ed2:	0505                	addi	a0,a0,1
    p2++;
     ed4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ed6:	fed518e3          	bne	a0,a3,ec6 <memcmp+0x16>
  }
  return 0;
     eda:	4501                	li	a0,0
     edc:	a019                	j	ee2 <memcmp+0x32>
      return *p1 - *p2;
     ede:	40e7853b          	subw	a0,a5,a4
}
     ee2:	60a2                	ld	ra,8(sp)
     ee4:	6402                	ld	s0,0(sp)
     ee6:	0141                	addi	sp,sp,16
     ee8:	8082                	ret
  return 0;
     eea:	4501                	li	a0,0
     eec:	bfdd                	j	ee2 <memcmp+0x32>

0000000000000eee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     eee:	1141                	addi	sp,sp,-16
     ef0:	e406                	sd	ra,8(sp)
     ef2:	e022                	sd	s0,0(sp)
     ef4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ef6:	00000097          	auipc	ra,0x0
     efa:	f5e080e7          	jalr	-162(ra) # e54 <memmove>
}
     efe:	60a2                	ld	ra,8(sp)
     f00:	6402                	ld	s0,0(sp)
     f02:	0141                	addi	sp,sp,16
     f04:	8082                	ret

0000000000000f06 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f06:	4885                	li	a7,1
 ecall
     f08:	00000073          	ecall
 ret
     f0c:	8082                	ret

0000000000000f0e <exit>:
.global exit
exit:
 li a7, SYS_exit
     f0e:	4889                	li	a7,2
 ecall
     f10:	00000073          	ecall
 ret
     f14:	8082                	ret

0000000000000f16 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f16:	488d                	li	a7,3
 ecall
     f18:	00000073          	ecall
 ret
     f1c:	8082                	ret

0000000000000f1e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f1e:	4891                	li	a7,4
 ecall
     f20:	00000073          	ecall
 ret
     f24:	8082                	ret

0000000000000f26 <read>:
.global read
read:
 li a7, SYS_read
     f26:	4895                	li	a7,5
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	8082                	ret

0000000000000f2e <write>:
.global write
write:
 li a7, SYS_write
     f2e:	48c1                	li	a7,16
 ecall
     f30:	00000073          	ecall
 ret
     f34:	8082                	ret

0000000000000f36 <close>:
.global close
close:
 li a7, SYS_close
     f36:	48d5                	li	a7,21
 ecall
     f38:	00000073          	ecall
 ret
     f3c:	8082                	ret

0000000000000f3e <kill>:
.global kill
kill:
 li a7, SYS_kill
     f3e:	4899                	li	a7,6
 ecall
     f40:	00000073          	ecall
 ret
     f44:	8082                	ret

0000000000000f46 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f46:	489d                	li	a7,7
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <open>:
.global open
open:
 li a7, SYS_open
     f4e:	48bd                	li	a7,15
 ecall
     f50:	00000073          	ecall
 ret
     f54:	8082                	ret

0000000000000f56 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f56:	48c5                	li	a7,17
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f5e:	48c9                	li	a7,18
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f66:	48a1                	li	a7,8
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <link>:
.global link
link:
 li a7, SYS_link
     f6e:	48cd                	li	a7,19
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f76:	48d1                	li	a7,20
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f7e:	48a5                	li	a7,9
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f86:	48a9                	li	a7,10
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f8e:	48ad                	li	a7,11
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f96:	48b1                	li	a7,12
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f9e:	48b5                	li	a7,13
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     fa6:	48b9                	li	a7,14
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <trace>:
.global trace
trace:
 li a7, SYS_trace
     fae:	48d9                	li	a7,22
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
     fb6:	48dd                	li	a7,23
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fbe:	1101                	addi	sp,sp,-32
     fc0:	ec06                	sd	ra,24(sp)
     fc2:	e822                	sd	s0,16(sp)
     fc4:	1000                	addi	s0,sp,32
     fc6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fca:	4605                	li	a2,1
     fcc:	fef40593          	addi	a1,s0,-17
     fd0:	00000097          	auipc	ra,0x0
     fd4:	f5e080e7          	jalr	-162(ra) # f2e <write>
}
     fd8:	60e2                	ld	ra,24(sp)
     fda:	6442                	ld	s0,16(sp)
     fdc:	6105                	addi	sp,sp,32
     fde:	8082                	ret

0000000000000fe0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     fe0:	7139                	addi	sp,sp,-64
     fe2:	fc06                	sd	ra,56(sp)
     fe4:	f822                	sd	s0,48(sp)
     fe6:	f426                	sd	s1,40(sp)
     fe8:	f04a                	sd	s2,32(sp)
     fea:	ec4e                	sd	s3,24(sp)
     fec:	0080                	addi	s0,sp,64
     fee:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ff0:	c299                	beqz	a3,ff6 <printint+0x16>
     ff2:	0805c063          	bltz	a1,1072 <printint+0x92>
  neg = 0;
     ff6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     ff8:	fc040313          	addi	t1,s0,-64
  neg = 0;
     ffc:	869a                	mv	a3,t1
  i = 0;
     ffe:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    1000:	00001817          	auipc	a6,0x1
    1004:	8a080813          	addi	a6,a6,-1888 # 18a0 <digits>
    1008:	88be                	mv	a7,a5
    100a:	0017851b          	addiw	a0,a5,1
    100e:	87aa                	mv	a5,a0
    1010:	02c5f73b          	remuw	a4,a1,a2
    1014:	1702                	slli	a4,a4,0x20
    1016:	9301                	srli	a4,a4,0x20
    1018:	9742                	add	a4,a4,a6
    101a:	00074703          	lbu	a4,0(a4)
    101e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    1022:	872e                	mv	a4,a1
    1024:	02c5d5bb          	divuw	a1,a1,a2
    1028:	0685                	addi	a3,a3,1
    102a:	fcc77fe3          	bgeu	a4,a2,1008 <printint+0x28>
  if(neg)
    102e:	000e0c63          	beqz	t3,1046 <printint+0x66>
    buf[i++] = '-';
    1032:	fd050793          	addi	a5,a0,-48
    1036:	00878533          	add	a0,a5,s0
    103a:	02d00793          	li	a5,45
    103e:	fef50823          	sb	a5,-16(a0)
    1042:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    1046:	fff7899b          	addiw	s3,a5,-1
    104a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    104e:	fff4c583          	lbu	a1,-1(s1)
    1052:	854a                	mv	a0,s2
    1054:	00000097          	auipc	ra,0x0
    1058:	f6a080e7          	jalr	-150(ra) # fbe <putc>
  while(--i >= 0)
    105c:	39fd                	addiw	s3,s3,-1
    105e:	14fd                	addi	s1,s1,-1
    1060:	fe09d7e3          	bgez	s3,104e <printint+0x6e>
}
    1064:	70e2                	ld	ra,56(sp)
    1066:	7442                	ld	s0,48(sp)
    1068:	74a2                	ld	s1,40(sp)
    106a:	7902                	ld	s2,32(sp)
    106c:	69e2                	ld	s3,24(sp)
    106e:	6121                	addi	sp,sp,64
    1070:	8082                	ret
    x = -xx;
    1072:	40b005bb          	negw	a1,a1
    neg = 1;
    1076:	4e05                	li	t3,1
    x = -xx;
    1078:	b741                	j	ff8 <printint+0x18>

000000000000107a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    107a:	711d                	addi	sp,sp,-96
    107c:	ec86                	sd	ra,88(sp)
    107e:	e8a2                	sd	s0,80(sp)
    1080:	e4a6                	sd	s1,72(sp)
    1082:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1084:	0005c483          	lbu	s1,0(a1)
    1088:	2a048863          	beqz	s1,1338 <vprintf+0x2be>
    108c:	e0ca                	sd	s2,64(sp)
    108e:	fc4e                	sd	s3,56(sp)
    1090:	f852                	sd	s4,48(sp)
    1092:	f456                	sd	s5,40(sp)
    1094:	f05a                	sd	s6,32(sp)
    1096:	ec5e                	sd	s7,24(sp)
    1098:	e862                	sd	s8,16(sp)
    109a:	e466                	sd	s9,8(sp)
    109c:	8b2a                	mv	s6,a0
    109e:	8a2e                	mv	s4,a1
    10a0:	8bb2                	mv	s7,a2
  state = 0;
    10a2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    10a4:	4901                	li	s2,0
    10a6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    10a8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    10ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    10b0:	06c00c93          	li	s9,108
    10b4:	a01d                	j	10da <vprintf+0x60>
        putc(fd, c0);
    10b6:	85a6                	mv	a1,s1
    10b8:	855a                	mv	a0,s6
    10ba:	00000097          	auipc	ra,0x0
    10be:	f04080e7          	jalr	-252(ra) # fbe <putc>
    10c2:	a019                	j	10c8 <vprintf+0x4e>
    } else if(state == '%'){
    10c4:	03598363          	beq	s3,s5,10ea <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
    10c8:	0019079b          	addiw	a5,s2,1
    10cc:	893e                	mv	s2,a5
    10ce:	873e                	mv	a4,a5
    10d0:	97d2                	add	a5,a5,s4
    10d2:	0007c483          	lbu	s1,0(a5)
    10d6:	24048963          	beqz	s1,1328 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
    10da:	0004879b          	sext.w	a5,s1
    if(state == 0){
    10de:	fe0993e3          	bnez	s3,10c4 <vprintf+0x4a>
      if(c0 == '%'){
    10e2:	fd579ae3          	bne	a5,s5,10b6 <vprintf+0x3c>
        state = '%';
    10e6:	89be                	mv	s3,a5
    10e8:	b7c5                	j	10c8 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
    10ea:	00ea06b3          	add	a3,s4,a4
    10ee:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    10f2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    10f4:	c681                	beqz	a3,10fc <vprintf+0x82>
    10f6:	9752                	add	a4,a4,s4
    10f8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    10fc:	05878063          	beq	a5,s8,113c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    1100:	05978c63          	beq	a5,s9,1158 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1104:	07500713          	li	a4,117
    1108:	10e78063          	beq	a5,a4,1208 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    110c:	07800713          	li	a4,120
    1110:	14e78863          	beq	a5,a4,1260 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1114:	07000713          	li	a4,112
    1118:	18e78163          	beq	a5,a4,129a <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    111c:	07300713          	li	a4,115
    1120:	1ce78663          	beq	a5,a4,12ec <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1124:	02500713          	li	a4,37
    1128:	04e79863          	bne	a5,a4,1178 <vprintf+0xfe>
        putc(fd, '%');
    112c:	85ba                	mv	a1,a4
    112e:	855a                	mv	a0,s6
    1130:	00000097          	auipc	ra,0x0
    1134:	e8e080e7          	jalr	-370(ra) # fbe <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1138:	4981                	li	s3,0
    113a:	b779                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
    113c:	008b8493          	addi	s1,s7,8
    1140:	4685                	li	a3,1
    1142:	4629                	li	a2,10
    1144:	000ba583          	lw	a1,0(s7)
    1148:	855a                	mv	a0,s6
    114a:	00000097          	auipc	ra,0x0
    114e:	e96080e7          	jalr	-362(ra) # fe0 <printint>
    1152:	8ba6                	mv	s7,s1
      state = 0;
    1154:	4981                	li	s3,0
    1156:	bf8d                	j	10c8 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
    1158:	06400793          	li	a5,100
    115c:	02f68d63          	beq	a3,a5,1196 <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1160:	06c00793          	li	a5,108
    1164:	04f68863          	beq	a3,a5,11b4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
    1168:	07500793          	li	a5,117
    116c:	0af68c63          	beq	a3,a5,1224 <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
    1170:	07800793          	li	a5,120
    1174:	10f68463          	beq	a3,a5,127c <vprintf+0x202>
        putc(fd, '%');
    1178:	02500593          	li	a1,37
    117c:	855a                	mv	a0,s6
    117e:	00000097          	auipc	ra,0x0
    1182:	e40080e7          	jalr	-448(ra) # fbe <putc>
        putc(fd, c0);
    1186:	85a6                	mv	a1,s1
    1188:	855a                	mv	a0,s6
    118a:	00000097          	auipc	ra,0x0
    118e:	e34080e7          	jalr	-460(ra) # fbe <putc>
      state = 0;
    1192:	4981                	li	s3,0
    1194:	bf15                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1196:	008b8493          	addi	s1,s7,8
    119a:	4685                	li	a3,1
    119c:	4629                	li	a2,10
    119e:	000ba583          	lw	a1,0(s7)
    11a2:	855a                	mv	a0,s6
    11a4:	00000097          	auipc	ra,0x0
    11a8:	e3c080e7          	jalr	-452(ra) # fe0 <printint>
        i += 1;
    11ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    11ae:	8ba6                	mv	s7,s1
      state = 0;
    11b0:	4981                	li	s3,0
        i += 1;
    11b2:	bf19                	j	10c8 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    11b4:	06400793          	li	a5,100
    11b8:	02f60963          	beq	a2,a5,11ea <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    11bc:	07500793          	li	a5,117
    11c0:	08f60163          	beq	a2,a5,1242 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    11c4:	07800793          	li	a5,120
    11c8:	faf618e3          	bne	a2,a5,1178 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
    11cc:	008b8493          	addi	s1,s7,8
    11d0:	4681                	li	a3,0
    11d2:	4641                	li	a2,16
    11d4:	000ba583          	lw	a1,0(s7)
    11d8:	855a                	mv	a0,s6
    11da:	00000097          	auipc	ra,0x0
    11de:	e06080e7          	jalr	-506(ra) # fe0 <printint>
        i += 2;
    11e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    11e4:	8ba6                	mv	s7,s1
      state = 0;
    11e6:	4981                	li	s3,0
        i += 2;
    11e8:	b5c5                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
    11ea:	008b8493          	addi	s1,s7,8
    11ee:	4685                	li	a3,1
    11f0:	4629                	li	a2,10
    11f2:	000ba583          	lw	a1,0(s7)
    11f6:	855a                	mv	a0,s6
    11f8:	00000097          	auipc	ra,0x0
    11fc:	de8080e7          	jalr	-536(ra) # fe0 <printint>
        i += 2;
    1200:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1202:	8ba6                	mv	s7,s1
      state = 0;
    1204:	4981                	li	s3,0
        i += 2;
    1206:	b5c9                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
    1208:	008b8493          	addi	s1,s7,8
    120c:	4681                	li	a3,0
    120e:	4629                	li	a2,10
    1210:	000ba583          	lw	a1,0(s7)
    1214:	855a                	mv	a0,s6
    1216:	00000097          	auipc	ra,0x0
    121a:	dca080e7          	jalr	-566(ra) # fe0 <printint>
    121e:	8ba6                	mv	s7,s1
      state = 0;
    1220:	4981                	li	s3,0
    1222:	b55d                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1224:	008b8493          	addi	s1,s7,8
    1228:	4681                	li	a3,0
    122a:	4629                	li	a2,10
    122c:	000ba583          	lw	a1,0(s7)
    1230:	855a                	mv	a0,s6
    1232:	00000097          	auipc	ra,0x0
    1236:	dae080e7          	jalr	-594(ra) # fe0 <printint>
        i += 1;
    123a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    123c:	8ba6                	mv	s7,s1
      state = 0;
    123e:	4981                	li	s3,0
        i += 1;
    1240:	b561                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1242:	008b8493          	addi	s1,s7,8
    1246:	4681                	li	a3,0
    1248:	4629                	li	a2,10
    124a:	000ba583          	lw	a1,0(s7)
    124e:	855a                	mv	a0,s6
    1250:	00000097          	auipc	ra,0x0
    1254:	d90080e7          	jalr	-624(ra) # fe0 <printint>
        i += 2;
    1258:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    125a:	8ba6                	mv	s7,s1
      state = 0;
    125c:	4981                	li	s3,0
        i += 2;
    125e:	b5ad                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
    1260:	008b8493          	addi	s1,s7,8
    1264:	4681                	li	a3,0
    1266:	4641                	li	a2,16
    1268:	000ba583          	lw	a1,0(s7)
    126c:	855a                	mv	a0,s6
    126e:	00000097          	auipc	ra,0x0
    1272:	d72080e7          	jalr	-654(ra) # fe0 <printint>
    1276:	8ba6                	mv	s7,s1
      state = 0;
    1278:	4981                	li	s3,0
    127a:	b5b9                	j	10c8 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
    127c:	008b8493          	addi	s1,s7,8
    1280:	4681                	li	a3,0
    1282:	4641                	li	a2,16
    1284:	000ba583          	lw	a1,0(s7)
    1288:	855a                	mv	a0,s6
    128a:	00000097          	auipc	ra,0x0
    128e:	d56080e7          	jalr	-682(ra) # fe0 <printint>
        i += 1;
    1292:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1294:	8ba6                	mv	s7,s1
      state = 0;
    1296:	4981                	li	s3,0
        i += 1;
    1298:	bd05                	j	10c8 <vprintf+0x4e>
    129a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    129c:	008b8d13          	addi	s10,s7,8
    12a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    12a4:	03000593          	li	a1,48
    12a8:	855a                	mv	a0,s6
    12aa:	00000097          	auipc	ra,0x0
    12ae:	d14080e7          	jalr	-748(ra) # fbe <putc>
  putc(fd, 'x');
    12b2:	07800593          	li	a1,120
    12b6:	855a                	mv	a0,s6
    12b8:	00000097          	auipc	ra,0x0
    12bc:	d06080e7          	jalr	-762(ra) # fbe <putc>
    12c0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    12c2:	00000b97          	auipc	s7,0x0
    12c6:	5deb8b93          	addi	s7,s7,1502 # 18a0 <digits>
    12ca:	03c9d793          	srli	a5,s3,0x3c
    12ce:	97de                	add	a5,a5,s7
    12d0:	0007c583          	lbu	a1,0(a5)
    12d4:	855a                	mv	a0,s6
    12d6:	00000097          	auipc	ra,0x0
    12da:	ce8080e7          	jalr	-792(ra) # fbe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    12de:	0992                	slli	s3,s3,0x4
    12e0:	34fd                	addiw	s1,s1,-1
    12e2:	f4e5                	bnez	s1,12ca <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
    12e4:	8bea                	mv	s7,s10
      state = 0;
    12e6:	4981                	li	s3,0
    12e8:	6d02                	ld	s10,0(sp)
    12ea:	bbf9                	j	10c8 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
    12ec:	008b8993          	addi	s3,s7,8
    12f0:	000bb483          	ld	s1,0(s7)
    12f4:	c085                	beqz	s1,1314 <vprintf+0x29a>
        for(; *s; s++)
    12f6:	0004c583          	lbu	a1,0(s1)
    12fa:	c585                	beqz	a1,1322 <vprintf+0x2a8>
          putc(fd, *s);
    12fc:	855a                	mv	a0,s6
    12fe:	00000097          	auipc	ra,0x0
    1302:	cc0080e7          	jalr	-832(ra) # fbe <putc>
        for(; *s; s++)
    1306:	0485                	addi	s1,s1,1
    1308:	0004c583          	lbu	a1,0(s1)
    130c:	f9e5                	bnez	a1,12fc <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
    130e:	8bce                	mv	s7,s3
      state = 0;
    1310:	4981                	li	s3,0
    1312:	bb5d                	j	10c8 <vprintf+0x4e>
          s = "(null)";
    1314:	00000497          	auipc	s1,0x0
    1318:	52448493          	addi	s1,s1,1316 # 1838 <malloc+0x40c>
        for(; *s; s++)
    131c:	02800593          	li	a1,40
    1320:	bff1                	j	12fc <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
    1322:	8bce                	mv	s7,s3
      state = 0;
    1324:	4981                	li	s3,0
    1326:	b34d                	j	10c8 <vprintf+0x4e>
    1328:	6906                	ld	s2,64(sp)
    132a:	79e2                	ld	s3,56(sp)
    132c:	7a42                	ld	s4,48(sp)
    132e:	7aa2                	ld	s5,40(sp)
    1330:	7b02                	ld	s6,32(sp)
    1332:	6be2                	ld	s7,24(sp)
    1334:	6c42                	ld	s8,16(sp)
    1336:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1338:	60e6                	ld	ra,88(sp)
    133a:	6446                	ld	s0,80(sp)
    133c:	64a6                	ld	s1,72(sp)
    133e:	6125                	addi	sp,sp,96
    1340:	8082                	ret

0000000000001342 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1342:	715d                	addi	sp,sp,-80
    1344:	ec06                	sd	ra,24(sp)
    1346:	e822                	sd	s0,16(sp)
    1348:	1000                	addi	s0,sp,32
    134a:	e010                	sd	a2,0(s0)
    134c:	e414                	sd	a3,8(s0)
    134e:	e818                	sd	a4,16(s0)
    1350:	ec1c                	sd	a5,24(s0)
    1352:	03043023          	sd	a6,32(s0)
    1356:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    135a:	8622                	mv	a2,s0
    135c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1360:	00000097          	auipc	ra,0x0
    1364:	d1a080e7          	jalr	-742(ra) # 107a <vprintf>
}
    1368:	60e2                	ld	ra,24(sp)
    136a:	6442                	ld	s0,16(sp)
    136c:	6161                	addi	sp,sp,80
    136e:	8082                	ret

0000000000001370 <printf>:

void
printf(const char *fmt, ...)
{
    1370:	711d                	addi	sp,sp,-96
    1372:	ec06                	sd	ra,24(sp)
    1374:	e822                	sd	s0,16(sp)
    1376:	1000                	addi	s0,sp,32
    1378:	e40c                	sd	a1,8(s0)
    137a:	e810                	sd	a2,16(s0)
    137c:	ec14                	sd	a3,24(s0)
    137e:	f018                	sd	a4,32(s0)
    1380:	f41c                	sd	a5,40(s0)
    1382:	03043823          	sd	a6,48(s0)
    1386:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    138a:	00840613          	addi	a2,s0,8
    138e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1392:	85aa                	mv	a1,a0
    1394:	4505                	li	a0,1
    1396:	00000097          	auipc	ra,0x0
    139a:	ce4080e7          	jalr	-796(ra) # 107a <vprintf>
}
    139e:	60e2                	ld	ra,24(sp)
    13a0:	6442                	ld	s0,16(sp)
    13a2:	6125                	addi	sp,sp,96
    13a4:	8082                	ret

00000000000013a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    13a6:	1141                	addi	sp,sp,-16
    13a8:	e406                	sd	ra,8(sp)
    13aa:	e022                	sd	s0,0(sp)
    13ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    13ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13b2:	00001797          	auipc	a5,0x1
    13b6:	c5e7b783          	ld	a5,-930(a5) # 2010 <freep>
    13ba:	a02d                	j	13e4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    13bc:	4618                	lw	a4,8(a2)
    13be:	9f2d                	addw	a4,a4,a1
    13c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    13c4:	6398                	ld	a4,0(a5)
    13c6:	6310                	ld	a2,0(a4)
    13c8:	a83d                	j	1406 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    13ca:	ff852703          	lw	a4,-8(a0)
    13ce:	9f31                	addw	a4,a4,a2
    13d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    13d2:	ff053683          	ld	a3,-16(a0)
    13d6:	a091                	j	141a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13d8:	6398                	ld	a4,0(a5)
    13da:	00e7e463          	bltu	a5,a4,13e2 <free+0x3c>
    13de:	00e6ea63          	bltu	a3,a4,13f2 <free+0x4c>
{
    13e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13e4:	fed7fae3          	bgeu	a5,a3,13d8 <free+0x32>
    13e8:	6398                	ld	a4,0(a5)
    13ea:	00e6e463          	bltu	a3,a4,13f2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13ee:	fee7eae3          	bltu	a5,a4,13e2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    13f2:	ff852583          	lw	a1,-8(a0)
    13f6:	6390                	ld	a2,0(a5)
    13f8:	02059813          	slli	a6,a1,0x20
    13fc:	01c85713          	srli	a4,a6,0x1c
    1400:	9736                	add	a4,a4,a3
    1402:	fae60de3          	beq	a2,a4,13bc <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1406:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    140a:	4790                	lw	a2,8(a5)
    140c:	02061593          	slli	a1,a2,0x20
    1410:	01c5d713          	srli	a4,a1,0x1c
    1414:	973e                	add	a4,a4,a5
    1416:	fae68ae3          	beq	a3,a4,13ca <free+0x24>
    p->s.ptr = bp->s.ptr;
    141a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    141c:	00001717          	auipc	a4,0x1
    1420:	bef73a23          	sd	a5,-1036(a4) # 2010 <freep>
}
    1424:	60a2                	ld	ra,8(sp)
    1426:	6402                	ld	s0,0(sp)
    1428:	0141                	addi	sp,sp,16
    142a:	8082                	ret

000000000000142c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    142c:	7139                	addi	sp,sp,-64
    142e:	fc06                	sd	ra,56(sp)
    1430:	f822                	sd	s0,48(sp)
    1432:	f04a                	sd	s2,32(sp)
    1434:	ec4e                	sd	s3,24(sp)
    1436:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1438:	02051993          	slli	s3,a0,0x20
    143c:	0209d993          	srli	s3,s3,0x20
    1440:	09bd                	addi	s3,s3,15
    1442:	0049d993          	srli	s3,s3,0x4
    1446:	2985                	addiw	s3,s3,1
    1448:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    144a:	00001517          	auipc	a0,0x1
    144e:	bc653503          	ld	a0,-1082(a0) # 2010 <freep>
    1452:	c905                	beqz	a0,1482 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1454:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1456:	4798                	lw	a4,8(a5)
    1458:	09377a63          	bgeu	a4,s3,14ec <malloc+0xc0>
    145c:	f426                	sd	s1,40(sp)
    145e:	e852                	sd	s4,16(sp)
    1460:	e456                	sd	s5,8(sp)
    1462:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1464:	8a4e                	mv	s4,s3
    1466:	6705                	lui	a4,0x1
    1468:	00e9f363          	bgeu	s3,a4,146e <malloc+0x42>
    146c:	6a05                	lui	s4,0x1
    146e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1472:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1476:	00001497          	auipc	s1,0x1
    147a:	b9a48493          	addi	s1,s1,-1126 # 2010 <freep>
  if(p == (char*)-1)
    147e:	5afd                	li	s5,-1
    1480:	a089                	j	14c2 <malloc+0x96>
    1482:	f426                	sd	s1,40(sp)
    1484:	e852                	sd	s4,16(sp)
    1486:	e456                	sd	s5,8(sp)
    1488:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    148a:	00001797          	auipc	a5,0x1
    148e:	f7e78793          	addi	a5,a5,-130 # 2408 <base>
    1492:	00001717          	auipc	a4,0x1
    1496:	b6f73f23          	sd	a5,-1154(a4) # 2010 <freep>
    149a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    149c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    14a0:	b7d1                	j	1464 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    14a2:	6398                	ld	a4,0(a5)
    14a4:	e118                	sd	a4,0(a0)
    14a6:	a8b9                	j	1504 <malloc+0xd8>
  hp->s.size = nu;
    14a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    14ac:	0541                	addi	a0,a0,16
    14ae:	00000097          	auipc	ra,0x0
    14b2:	ef8080e7          	jalr	-264(ra) # 13a6 <free>
  return freep;
    14b6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    14b8:	c135                	beqz	a0,151c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    14bc:	4798                	lw	a4,8(a5)
    14be:	03277363          	bgeu	a4,s2,14e4 <malloc+0xb8>
    if(p == freep)
    14c2:	6098                	ld	a4,0(s1)
    14c4:	853e                	mv	a0,a5
    14c6:	fef71ae3          	bne	a4,a5,14ba <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    14ca:	8552                	mv	a0,s4
    14cc:	00000097          	auipc	ra,0x0
    14d0:	aca080e7          	jalr	-1334(ra) # f96 <sbrk>
  if(p == (char*)-1)
    14d4:	fd551ae3          	bne	a0,s5,14a8 <malloc+0x7c>
        return 0;
    14d8:	4501                	li	a0,0
    14da:	74a2                	ld	s1,40(sp)
    14dc:	6a42                	ld	s4,16(sp)
    14de:	6aa2                	ld	s5,8(sp)
    14e0:	6b02                	ld	s6,0(sp)
    14e2:	a03d                	j	1510 <malloc+0xe4>
    14e4:	74a2                	ld	s1,40(sp)
    14e6:	6a42                	ld	s4,16(sp)
    14e8:	6aa2                	ld	s5,8(sp)
    14ea:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    14ec:	fae90be3          	beq	s2,a4,14a2 <malloc+0x76>
        p->s.size -= nunits;
    14f0:	4137073b          	subw	a4,a4,s3
    14f4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    14f6:	02071693          	slli	a3,a4,0x20
    14fa:	01c6d713          	srli	a4,a3,0x1c
    14fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1500:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1504:	00001717          	auipc	a4,0x1
    1508:	b0a73623          	sd	a0,-1268(a4) # 2010 <freep>
      return (void*)(p + 1);
    150c:	01078513          	addi	a0,a5,16
  }
}
    1510:	70e2                	ld	ra,56(sp)
    1512:	7442                	ld	s0,48(sp)
    1514:	7902                	ld	s2,32(sp)
    1516:	69e2                	ld	s3,24(sp)
    1518:	6121                	addi	sp,sp,64
    151a:	8082                	ret
    151c:	74a2                	ld	s1,40(sp)
    151e:	6a42                	ld	s4,16(sp)
    1520:	6aa2                	ld	s5,8(sp)
    1522:	6b02                	ld	s6,0(sp)
    1524:	b7f5                	j	1510 <malloc+0xe4>
