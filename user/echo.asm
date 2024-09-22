
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d863          	bge	a5,a0,86 <main+0x86>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	93cb0b13          	addi	s6,s6,-1732 # 970 <malloc+0x108>
  3c:	a819                	j	52 <main+0x52>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	00000097          	auipc	ra,0x0
  48:	326080e7          	jalr	806(ra) # 36a <write>
  for(i = 1; i < argc; i++){
  4c:	04a1                	addi	s1,s1,8
  4e:	03448c63          	beq	s1,s4,86 <main+0x86>
    write(1, argv[i], strlen(argv[i]));
  52:	0004b903          	ld	s2,0(s1)
  56:	854a                	mv	a0,s2
  58:	00000097          	auipc	ra,0x0
  5c:	0a2080e7          	jalr	162(ra) # fa <strlen>
  60:	862a                	mv	a2,a0
  62:	85ca                	mv	a1,s2
  64:	854e                	mv	a0,s3
  66:	00000097          	auipc	ra,0x0
  6a:	304080e7          	jalr	772(ra) # 36a <write>
    if(i + 1 < argc){
  6e:	fd5498e3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  72:	4605                	li	a2,1
  74:	00001597          	auipc	a1,0x1
  78:	90458593          	addi	a1,a1,-1788 # 978 <malloc+0x110>
  7c:	8532                	mv	a0,a2
  7e:	00000097          	auipc	ra,0x0
  82:	2ec080e7          	jalr	748(ra) # 36a <write>
    }
  }
  exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	2c2080e7          	jalr	706(ra) # 34a <exit>

0000000000000090 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  90:	1141                	addi	sp,sp,-16
  92:	e406                	sd	ra,8(sp)
  94:	e022                	sd	s0,0(sp)
  96:	0800                	addi	s0,sp,16
  extern int main();
  main();
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <main>
  exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	2a8080e7          	jalr	680(ra) # 34a <exit>

00000000000000aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0xa>
    ;
  return os;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x20>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x20>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cf99                	beqz	a5,124 <strlen+0x2a>
 108:	0505                	addi	a0,a0,1
 10a:	87aa                	mv	a5,a0
 10c:	86be                	mv	a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	ff65                	bnez	a4,10c <strlen+0x12>
 116:	40a6853b          	subw	a0,a3,a0
 11a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strlen+0x22>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 130:	ca19                	beqz	a2,146 <memset+0x1e>
 132:	87aa                	mv	a5,a0
 134:	1602                	slli	a2,a2,0x20
 136:	9201                	srli	a2,a2,0x20
 138:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 140:	0785                	addi	a5,a5,1
 142:	fee79de3          	bne	a5,a4,13c <memset+0x14>
  }
  return dst;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strchr>:

char*
strchr(const char *s, char c)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  for(; *s; s++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf81                	beqz	a5,172 <strchr+0x24>
    if(*s == c)
 15c:	00f58763          	beq	a1,a5,16a <strchr+0x1c>
  for(; *s; s++)
 160:	0505                	addi	a0,a0,1
 162:	00054783          	lbu	a5,0(a0)
 166:	fbfd                	bnez	a5,15c <strchr+0xe>
      return (char*)s;
  return 0;
 168:	4501                	li	a0,0
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  return 0;
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strchr+0x1c>

0000000000000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	7159                	addi	sp,sp,-112
 178:	f486                	sd	ra,104(sp)
 17a:	f0a2                	sd	s0,96(sp)
 17c:	eca6                	sd	s1,88(sp)
 17e:	e8ca                	sd	s2,80(sp)
 180:	e4ce                	sd	s3,72(sp)
 182:	e0d2                	sd	s4,64(sp)
 184:	fc56                	sd	s5,56(sp)
 186:	f85a                	sd	s6,48(sp)
 188:	f45e                	sd	s7,40(sp)
 18a:	f062                	sd	s8,32(sp)
 18c:	ec66                	sd	s9,24(sp)
 18e:	e86a                	sd	s10,16(sp)
 190:	1880                	addi	s0,sp,112
 192:	8caa                	mv	s9,a0
 194:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	892a                	mv	s2,a0
 198:	4481                	li	s1,0
    cc = read(0, &c, 1);
 19a:	f9f40b13          	addi	s6,s0,-97
 19e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a0:	4ba9                	li	s7,10
 1a2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1a4:	8d26                	mv	s10,s1
 1a6:	0014899b          	addiw	s3,s1,1
 1aa:	84ce                	mv	s1,s3
 1ac:	0349d763          	bge	s3,s4,1da <gets+0x64>
    cc = read(0, &c, 1);
 1b0:	8656                	mv	a2,s5
 1b2:	85da                	mv	a1,s6
 1b4:	4501                	li	a0,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	1ac080e7          	jalr	428(ra) # 362 <read>
    if(cc < 1)
 1be:	00a05e63          	blez	a0,1da <gets+0x64>
    buf[i++] = c;
 1c2:	f9f44783          	lbu	a5,-97(s0)
 1c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ca:	01778763          	beq	a5,s7,1d8 <gets+0x62>
 1ce:	0905                	addi	s2,s2,1
 1d0:	fd879ae3          	bne	a5,s8,1a4 <gets+0x2e>
    buf[i++] = c;
 1d4:	8d4e                	mv	s10,s3
 1d6:	a011                	j	1da <gets+0x64>
 1d8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1da:	9d66                	add	s10,s10,s9
 1dc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1e0:	8566                	mv	a0,s9
 1e2:	70a6                	ld	ra,104(sp)
 1e4:	7406                	ld	s0,96(sp)
 1e6:	64e6                	ld	s1,88(sp)
 1e8:	6946                	ld	s2,80(sp)
 1ea:	69a6                	ld	s3,72(sp)
 1ec:	6a06                	ld	s4,64(sp)
 1ee:	7ae2                	ld	s5,56(sp)
 1f0:	7b42                	ld	s6,48(sp)
 1f2:	7ba2                	ld	s7,40(sp)
 1f4:	7c02                	ld	s8,32(sp)
 1f6:	6ce2                	ld	s9,24(sp)
 1f8:	6d42                	ld	s10,16(sp)
 1fa:	6165                	addi	sp,sp,112
 1fc:	8082                	ret

00000000000001fe <stat>:

int
stat(const char *n, struct stat *st)
{
 1fe:	1101                	addi	sp,sp,-32
 200:	ec06                	sd	ra,24(sp)
 202:	e822                	sd	s0,16(sp)
 204:	e04a                	sd	s2,0(sp)
 206:	1000                	addi	s0,sp,32
 208:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	4581                	li	a1,0
 20c:	00000097          	auipc	ra,0x0
 210:	17e080e7          	jalr	382(ra) # 38a <open>
  if(fd < 0)
 214:	02054663          	bltz	a0,240 <stat+0x42>
 218:	e426                	sd	s1,8(sp)
 21a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21c:	85ca                	mv	a1,s2
 21e:	00000097          	auipc	ra,0x0
 222:	184080e7          	jalr	388(ra) # 3a2 <fstat>
 226:	892a                	mv	s2,a0
  close(fd);
 228:	8526                	mv	a0,s1
 22a:	00000097          	auipc	ra,0x0
 22e:	148080e7          	jalr	328(ra) # 372 <close>
  return r;
 232:	64a2                	ld	s1,8(sp)
}
 234:	854a                	mv	a0,s2
 236:	60e2                	ld	ra,24(sp)
 238:	6442                	ld	s0,16(sp)
 23a:	6902                	ld	s2,0(sp)
 23c:	6105                	addi	sp,sp,32
 23e:	8082                	ret
    return -1;
 240:	597d                	li	s2,-1
 242:	bfcd                	j	234 <stat+0x36>

0000000000000244 <atoi>:

int
atoi(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24c:	00054683          	lbu	a3,0(a0)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	4625                	li	a2,9
 25a:	02f66963          	bltu	a2,a5,28c <atoi+0x48>
 25e:	872a                	mv	a4,a0
  n = 0;
 260:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 262:	0705                	addi	a4,a4,1
 264:	0025179b          	slliw	a5,a0,0x2
 268:	9fa9                	addw	a5,a5,a0
 26a:	0017979b          	slliw	a5,a5,0x1
 26e:	9fb5                	addw	a5,a5,a3
 270:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 274:	00074683          	lbu	a3,0(a4)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	fef671e3          	bgeu	a2,a5,262 <atoi+0x1e>
  return n;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  n = 0;
 28c:	4501                	li	a0,0
 28e:	bfdd                	j	284 <atoi+0x40>

0000000000000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 298:	02b57563          	bgeu	a0,a1,2c2 <memmove+0x32>
    while(n-- > 0)
 29c:	00c05f63          	blez	a2,2ba <memmove+0x2a>
 2a0:	1602                	slli	a2,a2,0x20
 2a2:	9201                	srli	a2,a2,0x20
 2a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2aa:	0585                	addi	a1,a1,1
 2ac:	0705                	addi	a4,a4,1
 2ae:	fff5c683          	lbu	a3,-1(a1)
 2b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b6:	fee79ae3          	bne	a5,a4,2aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec059e3          	blez	a2,2ba <memmove+0x2a>
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fef71ae3          	bne	a4,a5,2da <memmove+0x4a>
 2ea:	bfc1                	j	2ba <memmove+0x2a>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f4:	ca0d                	beqz	a2,326 <memcmp+0x3a>
 2f6:	fff6069b          	addiw	a3,a2,-1
 2fa:	1682                	slli	a3,a3,0x20
 2fc:	9281                	srli	a3,a3,0x20
 2fe:	0685                	addi	a3,a3,1
 300:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 302:	00054783          	lbu	a5,0(a0)
 306:	0005c703          	lbu	a4,0(a1)
 30a:	00e79863          	bne	a5,a4,31a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 30e:	0505                	addi	a0,a0,1
    p2++;
 310:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 312:	fed518e3          	bne	a0,a3,302 <memcmp+0x16>
  }
  return 0;
 316:	4501                	li	a0,0
 318:	a019                	j	31e <memcmp+0x32>
      return *p1 - *p2;
 31a:	40e7853b          	subw	a0,a5,a4
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfdd                	j	31e <memcmp+0x32>

000000000000032a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 332:	00000097          	auipc	ra,0x0
 336:	f5e080e7          	jalr	-162(ra) # 290 <memmove>
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret

0000000000000342 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 342:	4885                	li	a7,1
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <exit>:
.global exit
exit:
 li a7, SYS_exit
 34a:	4889                	li	a7,2
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <wait>:
.global wait
wait:
 li a7, SYS_wait
 352:	488d                	li	a7,3
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35a:	4891                	li	a7,4
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <read>:
.global read
read:
 li a7, SYS_read
 362:	4895                	li	a7,5
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <write>:
.global write
write:
 li a7, SYS_write
 36a:	48c1                	li	a7,16
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <close>:
.global close
close:
 li a7, SYS_close
 372:	48d5                	li	a7,21
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <kill>:
.global kill
kill:
 li a7, SYS_kill
 37a:	4899                	li	a7,6
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exec>:
.global exec
exec:
 li a7, SYS_exec
 382:	489d                	li	a7,7
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <open>:
.global open
open:
 li a7, SYS_open
 38a:	48bd                	li	a7,15
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 392:	48c5                	li	a7,17
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39a:	48c9                	li	a7,18
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a2:	48a1                	li	a7,8
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <link>:
.global link
link:
 li a7, SYS_link
 3aa:	48cd                	li	a7,19
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b2:	48d1                	li	a7,20
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ba:	48a5                	li	a7,9
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c2:	48a9                	li	a7,10
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ca:	48ad                	li	a7,11
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d2:	48b1                	li	a7,12
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3da:	48b5                	li	a7,13
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e2:	48b9                	li	a7,14
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ea:	48d9                	li	a7,22
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3f2:	48dd                	li	a7,23
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fa:	1101                	addi	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	1000                	addi	s0,sp,32
 402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 406:	4605                	li	a2,1
 408:	fef40593          	addi	a1,s0,-17
 40c:	00000097          	auipc	ra,0x0
 410:	f5e080e7          	jalr	-162(ra) # 36a <write>
}
 414:	60e2                	ld	ra,24(sp)
 416:	6442                	ld	s0,16(sp)
 418:	6105                	addi	sp,sp,32
 41a:	8082                	ret

000000000000041c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41c:	7139                	addi	sp,sp,-64
 41e:	fc06                	sd	ra,56(sp)
 420:	f822                	sd	s0,48(sp)
 422:	f426                	sd	s1,40(sp)
 424:	f04a                	sd	s2,32(sp)
 426:	ec4e                	sd	s3,24(sp)
 428:	0080                	addi	s0,sp,64
 42a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42c:	c299                	beqz	a3,432 <printint+0x16>
 42e:	0805c063          	bltz	a1,4ae <printint+0x92>
  neg = 0;
 432:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 434:	fc040313          	addi	t1,s0,-64
  neg = 0;
 438:	869a                	mv	a3,t1
  i = 0;
 43a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 43c:	00000817          	auipc	a6,0x0
 440:	54c80813          	addi	a6,a6,1356 # 988 <digits>
 444:	88be                	mv	a7,a5
 446:	0017851b          	addiw	a0,a5,1
 44a:	87aa                	mv	a5,a0
 44c:	02c5f73b          	remuw	a4,a1,a2
 450:	1702                	slli	a4,a4,0x20
 452:	9301                	srli	a4,a4,0x20
 454:	9742                	add	a4,a4,a6
 456:	00074703          	lbu	a4,0(a4)
 45a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 45e:	872e                	mv	a4,a1
 460:	02c5d5bb          	divuw	a1,a1,a2
 464:	0685                	addi	a3,a3,1
 466:	fcc77fe3          	bgeu	a4,a2,444 <printint+0x28>
  if(neg)
 46a:	000e0c63          	beqz	t3,482 <printint+0x66>
    buf[i++] = '-';
 46e:	fd050793          	addi	a5,a0,-48
 472:	00878533          	add	a0,a5,s0
 476:	02d00793          	li	a5,45
 47a:	fef50823          	sb	a5,-16(a0)
 47e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 482:	fff7899b          	addiw	s3,a5,-1
 486:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 48a:	fff4c583          	lbu	a1,-1(s1)
 48e:	854a                	mv	a0,s2
 490:	00000097          	auipc	ra,0x0
 494:	f6a080e7          	jalr	-150(ra) # 3fa <putc>
  while(--i >= 0)
 498:	39fd                	addiw	s3,s3,-1
 49a:	14fd                	addi	s1,s1,-1
 49c:	fe09d7e3          	bgez	s3,48a <printint+0x6e>
}
 4a0:	70e2                	ld	ra,56(sp)
 4a2:	7442                	ld	s0,48(sp)
 4a4:	74a2                	ld	s1,40(sp)
 4a6:	7902                	ld	s2,32(sp)
 4a8:	69e2                	ld	s3,24(sp)
 4aa:	6121                	addi	sp,sp,64
 4ac:	8082                	ret
    x = -xx;
 4ae:	40b005bb          	negw	a1,a1
    neg = 1;
 4b2:	4e05                	li	t3,1
    x = -xx;
 4b4:	b741                	j	434 <printint+0x18>

00000000000004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b6:	711d                	addi	sp,sp,-96
 4b8:	ec86                	sd	ra,88(sp)
 4ba:	e8a2                	sd	s0,80(sp)
 4bc:	e4a6                	sd	s1,72(sp)
 4be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c0:	0005c483          	lbu	s1,0(a1)
 4c4:	2a048863          	beqz	s1,774 <vprintf+0x2be>
 4c8:	e0ca                	sd	s2,64(sp)
 4ca:	fc4e                	sd	s3,56(sp)
 4cc:	f852                	sd	s4,48(sp)
 4ce:	f456                	sd	s5,40(sp)
 4d0:	f05a                	sd	s6,32(sp)
 4d2:	ec5e                	sd	s7,24(sp)
 4d4:	e862                	sd	s8,16(sp)
 4d6:	e466                	sd	s9,8(sp)
 4d8:	8b2a                	mv	s6,a0
 4da:	8a2e                	mv	s4,a1
 4dc:	8bb2                	mv	s7,a2
  state = 0;
 4de:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e0:	4901                	li	s2,0
 4e2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ec:	06c00c93          	li	s9,108
 4f0:	a01d                	j	516 <vprintf+0x60>
        putc(fd, c0);
 4f2:	85a6                	mv	a1,s1
 4f4:	855a                	mv	a0,s6
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f04080e7          	jalr	-252(ra) # 3fa <putc>
 4fe:	a019                	j	504 <vprintf+0x4e>
    } else if(state == '%'){
 500:	03598363          	beq	s3,s5,526 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 504:	0019079b          	addiw	a5,s2,1
 508:	893e                	mv	s2,a5
 50a:	873e                	mv	a4,a5
 50c:	97d2                	add	a5,a5,s4
 50e:	0007c483          	lbu	s1,0(a5)
 512:	24048963          	beqz	s1,764 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 516:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51a:	fe0993e3          	bnez	s3,500 <vprintf+0x4a>
      if(c0 == '%'){
 51e:	fd579ae3          	bne	a5,s5,4f2 <vprintf+0x3c>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7c5                	j	504 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 526:	00ea06b3          	add	a3,s4,a4
 52a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 52e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 530:	c681                	beqz	a3,538 <vprintf+0x82>
 532:	9752                	add	a4,a4,s4
 534:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 538:	05878063          	beq	a5,s8,578 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 53c:	05978c63          	beq	a5,s9,594 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 540:	07500713          	li	a4,117
 544:	10e78063          	beq	a5,a4,644 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 548:	07800713          	li	a4,120
 54c:	14e78863          	beq	a5,a4,69c <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 550:	07000713          	li	a4,112
 554:	18e78163          	beq	a5,a4,6d6 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 558:	07300713          	li	a4,115
 55c:	1ce78663          	beq	a5,a4,728 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 560:	02500713          	li	a4,37
 564:	04e79863          	bne	a5,a4,5b4 <vprintf+0xfe>
        putc(fd, '%');
 568:	85ba                	mv	a1,a4
 56a:	855a                	mv	a0,s6
 56c:	00000097          	auipc	ra,0x0
 570:	e8e080e7          	jalr	-370(ra) # 3fa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 574:	4981                	li	s3,0
 576:	b779                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 578:	008b8493          	addi	s1,s7,8
 57c:	4685                	li	a3,1
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	00000097          	auipc	ra,0x0
 58a:	e96080e7          	jalr	-362(ra) # 41c <printint>
 58e:	8ba6                	mv	s7,s1
      state = 0;
 590:	4981                	li	s3,0
 592:	bf8d                	j	504 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 594:	06400793          	li	a5,100
 598:	02f68d63          	beq	a3,a5,5d2 <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 59c:	06c00793          	li	a5,108
 5a0:	04f68863          	beq	a3,a5,5f0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 5a4:	07500793          	li	a5,117
 5a8:	0af68c63          	beq	a3,a5,660 <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 5ac:	07800793          	li	a5,120
 5b0:	10f68463          	beq	a3,a5,6b8 <vprintf+0x202>
        putc(fd, '%');
 5b4:	02500593          	li	a1,37
 5b8:	855a                	mv	a0,s6
 5ba:	00000097          	auipc	ra,0x0
 5be:	e40080e7          	jalr	-448(ra) # 3fa <putc>
        putc(fd, c0);
 5c2:	85a6                	mv	a1,s1
 5c4:	855a                	mv	a0,s6
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e34080e7          	jalr	-460(ra) # 3fa <putc>
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bf15                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e3c080e7          	jalr	-452(ra) # 41c <printint>
        i += 1;
 5e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
        i += 1;
 5ee:	bf19                	j	504 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f0:	06400793          	li	a5,100
 5f4:	02f60963          	beq	a2,a5,626 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f8:	07500793          	li	a5,117
 5fc:	08f60163          	beq	a2,a5,67e <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 600:	07800793          	li	a5,120
 604:	faf618e3          	bne	a2,a5,5b4 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	00000097          	auipc	ra,0x0
 61a:	e06080e7          	jalr	-506(ra) # 41c <printint>
        i += 2;
 61e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
        i += 2;
 624:	b5c5                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	008b8493          	addi	s1,s7,8
 62a:	4685                	li	a3,1
 62c:	4629                	li	a2,10
 62e:	000ba583          	lw	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	00000097          	auipc	ra,0x0
 638:	de8080e7          	jalr	-536(ra) # 41c <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	b5c9                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	00000097          	auipc	ra,0x0
 656:	dca080e7          	jalr	-566(ra) # 41c <printint>
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b55d                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 660:	008b8493          	addi	s1,s7,8
 664:	4681                	li	a3,0
 666:	4629                	li	a2,10
 668:	000ba583          	lw	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	00000097          	auipc	ra,0x0
 672:	dae080e7          	jalr	-594(ra) # 41c <printint>
        i += 1;
 676:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	8ba6                	mv	s7,s1
      state = 0;
 67a:	4981                	li	s3,0
        i += 1;
 67c:	b561                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	008b8493          	addi	s1,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000ba583          	lw	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	00000097          	auipc	ra,0x0
 690:	d90080e7          	jalr	-624(ra) # 41c <printint>
        i += 2;
 694:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	b5ad                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 69c:	008b8493          	addi	s1,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4641                	li	a2,16
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	00000097          	auipc	ra,0x0
 6ae:	d72080e7          	jalr	-654(ra) # 41c <printint>
 6b2:	8ba6                	mv	s7,s1
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b5b9                	j	504 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b8:	008b8493          	addi	s1,s7,8
 6bc:	4681                	li	a3,0
 6be:	4641                	li	a2,16
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	00000097          	auipc	ra,0x0
 6ca:	d56080e7          	jalr	-682(ra) # 41c <printint>
        i += 1;
 6ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d0:	8ba6                	mv	s7,s1
      state = 0;
 6d2:	4981                	li	s3,0
        i += 1;
 6d4:	bd05                	j	504 <vprintf+0x4e>
 6d6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6d8:	008b8d13          	addi	s10,s7,8
 6dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e0:	03000593          	li	a1,48
 6e4:	855a                	mv	a0,s6
 6e6:	00000097          	auipc	ra,0x0
 6ea:	d14080e7          	jalr	-748(ra) # 3fa <putc>
  putc(fd, 'x');
 6ee:	07800593          	li	a1,120
 6f2:	855a                	mv	a0,s6
 6f4:	00000097          	auipc	ra,0x0
 6f8:	d06080e7          	jalr	-762(ra) # 3fa <putc>
 6fc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fe:	00000b97          	auipc	s7,0x0
 702:	28ab8b93          	addi	s7,s7,650 # 988 <digits>
 706:	03c9d793          	srli	a5,s3,0x3c
 70a:	97de                	add	a5,a5,s7
 70c:	0007c583          	lbu	a1,0(a5)
 710:	855a                	mv	a0,s6
 712:	00000097          	auipc	ra,0x0
 716:	ce8080e7          	jalr	-792(ra) # 3fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71a:	0992                	slli	s3,s3,0x4
 71c:	34fd                	addiw	s1,s1,-1
 71e:	f4e5                	bnez	s1,706 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 720:	8bea                	mv	s7,s10
      state = 0;
 722:	4981                	li	s3,0
 724:	6d02                	ld	s10,0(sp)
 726:	bbf9                	j	504 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 728:	008b8993          	addi	s3,s7,8
 72c:	000bb483          	ld	s1,0(s7)
 730:	c085                	beqz	s1,750 <vprintf+0x29a>
        for(; *s; s++)
 732:	0004c583          	lbu	a1,0(s1)
 736:	c585                	beqz	a1,75e <vprintf+0x2a8>
          putc(fd, *s);
 738:	855a                	mv	a0,s6
 73a:	00000097          	auipc	ra,0x0
 73e:	cc0080e7          	jalr	-832(ra) # 3fa <putc>
        for(; *s; s++)
 742:	0485                	addi	s1,s1,1
 744:	0004c583          	lbu	a1,0(s1)
 748:	f9e5                	bnez	a1,738 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 74a:	8bce                	mv	s7,s3
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bb5d                	j	504 <vprintf+0x4e>
          s = "(null)";
 750:	00000497          	auipc	s1,0x0
 754:	23048493          	addi	s1,s1,560 # 980 <malloc+0x118>
        for(; *s; s++)
 758:	02800593          	li	a1,40
 75c:	bff1                	j	738 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 75e:	8bce                	mv	s7,s3
      state = 0;
 760:	4981                	li	s3,0
 762:	b34d                	j	504 <vprintf+0x4e>
 764:	6906                	ld	s2,64(sp)
 766:	79e2                	ld	s3,56(sp)
 768:	7a42                	ld	s4,48(sp)
 76a:	7aa2                	ld	s5,40(sp)
 76c:	7b02                	ld	s6,32(sp)
 76e:	6be2                	ld	s7,24(sp)
 770:	6c42                	ld	s8,16(sp)
 772:	6ca2                	ld	s9,8(sp)
    }
  }
}
 774:	60e6                	ld	ra,88(sp)
 776:	6446                	ld	s0,80(sp)
 778:	64a6                	ld	s1,72(sp)
 77a:	6125                	addi	sp,sp,96
 77c:	8082                	ret

000000000000077e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77e:	715d                	addi	sp,sp,-80
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e010                	sd	a2,0(s0)
 788:	e414                	sd	a3,8(s0)
 78a:	e818                	sd	a4,16(s0)
 78c:	ec1c                	sd	a5,24(s0)
 78e:	03043023          	sd	a6,32(s0)
 792:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	8622                	mv	a2,s0
 798:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79c:	00000097          	auipc	ra,0x0
 7a0:	d1a080e7          	jalr	-742(ra) # 4b6 <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6161                	addi	sp,sp,80
 7aa:	8082                	ret

00000000000007ac <printf>:

void
printf(const char *fmt, ...)
{
 7ac:	711d                	addi	sp,sp,-96
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e40c                	sd	a1,8(s0)
 7b6:	e810                	sd	a2,16(s0)
 7b8:	ec14                	sd	a3,24(s0)
 7ba:	f018                	sd	a4,32(s0)
 7bc:	f41c                	sd	a5,40(s0)
 7be:	03043823          	sd	a6,48(s0)
 7c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	00840613          	addi	a2,s0,8
 7ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ce:	85aa                	mv	a1,a0
 7d0:	4505                	li	a0,1
 7d2:	00000097          	auipc	ra,0x0
 7d6:	ce4080e7          	jalr	-796(ra) # 4b6 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e406                	sd	ra,8(sp)
 7e6:	e022                	sd	s0,0(sp)
 7e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	00001797          	auipc	a5,0x1
 7f2:	8127b783          	ld	a5,-2030(a5) # 1000 <freep>
 7f6:	a02d                	j	820 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f8:	4618                	lw	a4,8(a2)
 7fa:	9f2d                	addw	a4,a4,a1
 7fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	6310                	ld	a2,0(a4)
 804:	a83d                	j	842 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 806:	ff852703          	lw	a4,-8(a0)
 80a:	9f31                	addw	a4,a4,a2
 80c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80e:	ff053683          	ld	a3,-16(a0)
 812:	a091                	j	856 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 814:	6398                	ld	a4,0(a5)
 816:	00e7e463          	bltu	a5,a4,81e <free+0x3c>
 81a:	00e6ea63          	bltu	a3,a4,82e <free+0x4c>
{
 81e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	fed7fae3          	bgeu	a5,a3,814 <free+0x32>
 824:	6398                	ld	a4,0(a5)
 826:	00e6e463          	bltu	a3,a4,82e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82a:	fee7eae3          	bltu	a5,a4,81e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 82e:	ff852583          	lw	a1,-8(a0)
 832:	6390                	ld	a2,0(a5)
 834:	02059813          	slli	a6,a1,0x20
 838:	01c85713          	srli	a4,a6,0x1c
 83c:	9736                	add	a4,a4,a3
 83e:	fae60de3          	beq	a2,a4,7f8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 846:	4790                	lw	a2,8(a5)
 848:	02061593          	slli	a1,a2,0x20
 84c:	01c5d713          	srli	a4,a1,0x1c
 850:	973e                	add	a4,a4,a5
 852:	fae68ae3          	beq	a3,a4,806 <free+0x24>
    p->s.ptr = bp->s.ptr;
 856:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 858:	00000717          	auipc	a4,0x0
 85c:	7af73423          	sd	a5,1960(a4) # 1000 <freep>
}
 860:	60a2                	ld	ra,8(sp)
 862:	6402                	ld	s0,0(sp)
 864:	0141                	addi	sp,sp,16
 866:	8082                	ret

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f04a                	sd	s2,32(sp)
 870:	ec4e                	sd	s3,24(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051993          	slli	s3,a0,0x20
 878:	0209d993          	srli	s3,s3,0x20
 87c:	09bd                	addi	s3,s3,15
 87e:	0049d993          	srli	s3,s3,0x4
 882:	2985                	addiw	s3,s3,1
 884:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 886:	00000517          	auipc	a0,0x0
 88a:	77a53503          	ld	a0,1914(a0) # 1000 <freep>
 88e:	c905                	beqz	a0,8be <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	09377a63          	bgeu	a4,s3,928 <malloc+0xc0>
 898:	f426                	sd	s1,40(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a0:	8a4e                	mv	s4,s3
 8a2:	6705                	lui	a4,0x1
 8a4:	00e9f363          	bgeu	s3,a4,8aa <malloc+0x42>
 8a8:	6a05                	lui	s4,0x1
 8aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b2:	00000497          	auipc	s1,0x0
 8b6:	74e48493          	addi	s1,s1,1870 # 1000 <freep>
  if(p == (char*)-1)
 8ba:	5afd                	li	s5,-1
 8bc:	a089                	j	8fe <malloc+0x96>
 8be:	f426                	sd	s1,40(sp)
 8c0:	e852                	sd	s4,16(sp)
 8c2:	e456                	sd	s5,8(sp)
 8c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c6:	00000797          	auipc	a5,0x0
 8ca:	74a78793          	addi	a5,a5,1866 # 1010 <base>
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72f73923          	sd	a5,1842(a4) # 1000 <freep>
 8d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8dc:	b7d1                	j	8a0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	e118                	sd	a4,0(a0)
 8e2:	a8b9                	j	940 <malloc+0xd8>
  hp->s.size = nu;
 8e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e8:	0541                	addi	a0,a0,16
 8ea:	00000097          	auipc	ra,0x0
 8ee:	ef8080e7          	jalr	-264(ra) # 7e2 <free>
  return freep;
 8f2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8f4:	c135                	beqz	a0,958 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	03277363          	bgeu	a4,s2,920 <malloc+0xb8>
    if(p == freep)
 8fe:	6098                	ld	a4,0(s1)
 900:	853e                	mv	a0,a5
 902:	fef71ae3          	bne	a4,a5,8f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 906:	8552                	mv	a0,s4
 908:	00000097          	auipc	ra,0x0
 90c:	aca080e7          	jalr	-1334(ra) # 3d2 <sbrk>
  if(p == (char*)-1)
 910:	fd551ae3          	bne	a0,s5,8e4 <malloc+0x7c>
        return 0;
 914:	4501                	li	a0,0
 916:	74a2                	ld	s1,40(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	a03d                	j	94c <malloc+0xe4>
 920:	74a2                	ld	s1,40(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 928:	fae90be3          	beq	s2,a4,8de <malloc+0x76>
        p->s.size -= nunits;
 92c:	4137073b          	subw	a4,a4,s3
 930:	c798                	sw	a4,8(a5)
        p += p->s.size;
 932:	02071693          	slli	a3,a4,0x20
 936:	01c6d713          	srli	a4,a3,0x1c
 93a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 940:	00000717          	auipc	a4,0x0
 944:	6ca73023          	sd	a0,1728(a4) # 1000 <freep>
      return (void*)(p + 1);
 948:	01078513          	addi	a0,a5,16
  }
}
 94c:	70e2                	ld	ra,56(sp)
 94e:	7442                	ld	s0,48(sp)
 950:	7902                	ld	s2,32(sp)
 952:	69e2                	ld	s3,24(sp)
 954:	6121                	addi	sp,sp,64
 956:	8082                	ret
 958:	74a2                	ld	s1,40(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	b7f5                	j	94c <malloc+0xe4>
