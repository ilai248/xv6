
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

enum ArgvIndexes {PROGRAM_NAME_INDEX, SLEEP_DURATION_INDEX};
enum ReturnCodes {SUCCESS, ERROR};

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // Ensure correct argc (args count).
  if(argc != SLEEP_DURATION_INDEX + 1 ){
   8:	4789                	li	a5,2
   a:	02f50463          	beq	a0,a5,32 <main+0x32>
    printf("Wrong Format. Correct Format is:\n\t%s %s", argv[PROGRAM_NAME_INDEX], "<Number Of Ticks To Wait>\n");
   e:	00001617          	auipc	a2,0x1
  12:	93260613          	addi	a2,a2,-1742 # 940 <malloc+0xfc>
  16:	618c                	ld	a1,0(a1)
  18:	00001517          	auipc	a0,0x1
  1c:	94850513          	addi	a0,a0,-1720 # 960 <malloc+0x11c>
  20:	00000097          	auipc	ra,0x0
  24:	768080e7          	jalr	1896(ra) # 788 <printf>
    exit(ERROR);
  28:	4505                	li	a0,1
  2a:	00000097          	auipc	ra,0x0
  2e:	2fc080e7          	jalr	764(ra) # 326 <exit>
  }

  // Make sure the given amount of ticks is a positive integer (if it's not an integer then 0 will be returned).
  int ticksToWait = atoi(argv[SLEEP_DURATION_INDEX]);
  32:	6588                	ld	a0,8(a1)
  34:	00000097          	auipc	ra,0x0
  38:	1ec080e7          	jalr	492(ra) # 220 <atoi>
  if (ticksToWait <= 0) {
  3c:	00a05b63          	blez	a0,52 <main+0x52>
    printf("Error: Number of ticks must be a positive integer.\n");
    exit(ERROR);
  }

  sleep(ticksToWait);
  40:	00000097          	auipc	ra,0x0
  44:	376080e7          	jalr	886(ra) # 3b6 <sleep>
  exit(SUCCESS);
  48:	4501                	li	a0,0
  4a:	00000097          	auipc	ra,0x0
  4e:	2dc080e7          	jalr	732(ra) # 326 <exit>
    printf("Error: Number of ticks must be a positive integer.\n");
  52:	00001517          	auipc	a0,0x1
  56:	93650513          	addi	a0,a0,-1738 # 988 <malloc+0x144>
  5a:	00000097          	auipc	ra,0x0
  5e:	72e080e7          	jalr	1838(ra) # 788 <printf>
    exit(ERROR);
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	2c2080e7          	jalr	706(ra) # 326 <exit>

000000000000006c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e406                	sd	ra,8(sp)
  70:	e022                	sd	s0,0(sp)
  72:	0800                	addi	s0,sp,16
  extern int main();
  main();
  74:	00000097          	auipc	ra,0x0
  78:	f8c080e7          	jalr	-116(ra) # 0 <main>
  exit(0);
  7c:	4501                	li	a0,0
  7e:	00000097          	auipc	ra,0x0
  82:	2a8080e7          	jalr	680(ra) # 326 <exit>

0000000000000086 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  86:	1141                	addi	sp,sp,-16
  88:	e406                	sd	ra,8(sp)
  8a:	e022                	sd	s0,0(sp)
  8c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8e:	87aa                	mv	a5,a0
  90:	0585                	addi	a1,a1,1
  92:	0785                	addi	a5,a5,1
  94:	fff5c703          	lbu	a4,-1(a1)
  98:	fee78fa3          	sb	a4,-1(a5)
  9c:	fb75                	bnez	a4,90 <strcpy+0xa>
    ;
  return os;
}
  9e:	60a2                	ld	ra,8(sp)
  a0:	6402                	ld	s0,0(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e406                	sd	ra,8(sp)
  aa:	e022                	sd	s0,0(sp)
  ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cb91                	beqz	a5,c6 <strcmp+0x20>
  b4:	0005c703          	lbu	a4,0(a1)
  b8:	00f71763          	bne	a4,a5,c6 <strcmp+0x20>
    p++, q++;
  bc:	0505                	addi	a0,a0,1
  be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fbe5                	bnez	a5,b4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strlen>:

uint
strlen(const char *s)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cf99                	beqz	a5,100 <strlen+0x2a>
  e4:	0505                	addi	a0,a0,1
  e6:	87aa                	mv	a5,a0
  e8:	86be                	mv	a3,a5
  ea:	0785                	addi	a5,a5,1
  ec:	fff7c703          	lbu	a4,-1(a5)
  f0:	ff65                	bnez	a4,e8 <strlen+0x12>
  f2:	40a6853b          	subw	a0,a3,a0
  f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
  for(n = 0; s[n]; n++)
 100:	4501                	li	a0,0
 102:	bfdd                	j	f8 <strlen+0x22>

0000000000000104 <memset>:

void*
memset(void *dst, int c, uint n)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	ca19                	beqz	a2,122 <memset+0x1e>
 10e:	87aa                	mv	a5,a0
 110:	1602                	slli	a2,a2,0x20
 112:	9201                	srli	a2,a2,0x20
 114:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 118:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11c:	0785                	addi	a5,a5,1
 11e:	fee79de3          	bne	a5,a4,118 <memset+0x14>
  }
  return dst;
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strchr>:

char*
strchr(const char *s, char c)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  for(; *s; s++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cf81                	beqz	a5,14e <strchr+0x24>
    if(*s == c)
 138:	00f58763          	beq	a1,a5,146 <strchr+0x1c>
  for(; *s; s++)
 13c:	0505                	addi	a0,a0,1
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbfd                	bnez	a5,138 <strchr+0xe>
      return (char*)s;
  return 0;
 144:	4501                	li	a0,0
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  return 0;
 14e:	4501                	li	a0,0
 150:	bfdd                	j	146 <strchr+0x1c>

0000000000000152 <gets>:

char*
gets(char *buf, int max)
{
 152:	7159                	addi	sp,sp,-112
 154:	f486                	sd	ra,104(sp)
 156:	f0a2                	sd	s0,96(sp)
 158:	eca6                	sd	s1,88(sp)
 15a:	e8ca                	sd	s2,80(sp)
 15c:	e4ce                	sd	s3,72(sp)
 15e:	e0d2                	sd	s4,64(sp)
 160:	fc56                	sd	s5,56(sp)
 162:	f85a                	sd	s6,48(sp)
 164:	f45e                	sd	s7,40(sp)
 166:	f062                	sd	s8,32(sp)
 168:	ec66                	sd	s9,24(sp)
 16a:	e86a                	sd	s10,16(sp)
 16c:	1880                	addi	s0,sp,112
 16e:	8caa                	mv	s9,a0
 170:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	892a                	mv	s2,a0
 174:	4481                	li	s1,0
    cc = read(0, &c, 1);
 176:	f9f40b13          	addi	s6,s0,-97
 17a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17c:	4ba9                	li	s7,10
 17e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 180:	8d26                	mv	s10,s1
 182:	0014899b          	addiw	s3,s1,1
 186:	84ce                	mv	s1,s3
 188:	0349d763          	bge	s3,s4,1b6 <gets+0x64>
    cc = read(0, &c, 1);
 18c:	8656                	mv	a2,s5
 18e:	85da                	mv	a1,s6
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	1ac080e7          	jalr	428(ra) # 33e <read>
    if(cc < 1)
 19a:	00a05e63          	blez	a0,1b6 <gets+0x64>
    buf[i++] = c;
 19e:	f9f44783          	lbu	a5,-97(s0)
 1a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a6:	01778763          	beq	a5,s7,1b4 <gets+0x62>
 1aa:	0905                	addi	s2,s2,1
 1ac:	fd879ae3          	bne	a5,s8,180 <gets+0x2e>
    buf[i++] = c;
 1b0:	8d4e                	mv	s10,s3
 1b2:	a011                	j	1b6 <gets+0x64>
 1b4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1b6:	9d66                	add	s10,s10,s9
 1b8:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1bc:	8566                	mv	a0,s9
 1be:	70a6                	ld	ra,104(sp)
 1c0:	7406                	ld	s0,96(sp)
 1c2:	64e6                	ld	s1,88(sp)
 1c4:	6946                	ld	s2,80(sp)
 1c6:	69a6                	ld	s3,72(sp)
 1c8:	6a06                	ld	s4,64(sp)
 1ca:	7ae2                	ld	s5,56(sp)
 1cc:	7b42                	ld	s6,48(sp)
 1ce:	7ba2                	ld	s7,40(sp)
 1d0:	7c02                	ld	s8,32(sp)
 1d2:	6ce2                	ld	s9,24(sp)
 1d4:	6d42                	ld	s10,16(sp)
 1d6:	6165                	addi	sp,sp,112
 1d8:	8082                	ret

00000000000001da <stat>:

int
stat(const char *n, struct stat *st)
{
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e04a                	sd	s2,0(sp)
 1e2:	1000                	addi	s0,sp,32
 1e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	4581                	li	a1,0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	17e080e7          	jalr	382(ra) # 366 <open>
  if(fd < 0)
 1f0:	02054663          	bltz	a0,21c <stat+0x42>
 1f4:	e426                	sd	s1,8(sp)
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	184080e7          	jalr	388(ra) # 37e <fstat>
 202:	892a                	mv	s2,a0
  close(fd);
 204:	8526                	mv	a0,s1
 206:	00000097          	auipc	ra,0x0
 20a:	148080e7          	jalr	328(ra) # 34e <close>
  return r;
 20e:	64a2                	ld	s1,8(sp)
}
 210:	854a                	mv	a0,s2
 212:	60e2                	ld	ra,24(sp)
 214:	6442                	ld	s0,16(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfcd                	j	210 <stat+0x36>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e406                	sd	ra,8(sp)
 224:	e022                	sd	s0,0(sp)
 226:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 228:	00054683          	lbu	a3,0(a0)
 22c:	fd06879b          	addiw	a5,a3,-48
 230:	0ff7f793          	zext.b	a5,a5
 234:	4625                	li	a2,9
 236:	02f66963          	bltu	a2,a5,268 <atoi+0x48>
 23a:	872a                	mv	a4,a0
  n = 0;
 23c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23e:	0705                	addi	a4,a4,1
 240:	0025179b          	slliw	a5,a0,0x2
 244:	9fa9                	addw	a5,a5,a0
 246:	0017979b          	slliw	a5,a5,0x1
 24a:	9fb5                	addw	a5,a5,a3
 24c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 250:	00074683          	lbu	a3,0(a4)
 254:	fd06879b          	addiw	a5,a3,-48
 258:	0ff7f793          	zext.b	a5,a5
 25c:	fef671e3          	bgeu	a2,a5,23e <atoi+0x1e>
  return n;
}
 260:	60a2                	ld	ra,8(sp)
 262:	6402                	ld	s0,0(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  n = 0;
 268:	4501                	li	a0,0
 26a:	bfdd                	j	260 <atoi+0x40>

000000000000026c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 274:	02b57563          	bgeu	a0,a1,29e <memmove+0x32>
    while(n-- > 0)
 278:	00c05f63          	blez	a2,296 <memmove+0x2a>
 27c:	1602                	slli	a2,a2,0x20
 27e:	9201                	srli	a2,a2,0x20
 280:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 284:	872a                	mv	a4,a0
      *dst++ = *src++;
 286:	0585                	addi	a1,a1,1
 288:	0705                	addi	a4,a4,1
 28a:	fff5c683          	lbu	a3,-1(a1)
 28e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
    dst += n;
 29e:	00c50733          	add	a4,a0,a2
    src += n;
 2a2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a4:	fec059e3          	blez	a2,296 <memmove+0x2a>
 2a8:	fff6079b          	addiw	a5,a2,-1
 2ac:	1782                	slli	a5,a5,0x20
 2ae:	9381                	srli	a5,a5,0x20
 2b0:	fff7c793          	not	a5,a5
 2b4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b6:	15fd                	addi	a1,a1,-1
 2b8:	177d                	addi	a4,a4,-1
 2ba:	0005c683          	lbu	a3,0(a1)
 2be:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c2:	fef71ae3          	bne	a4,a5,2b6 <memmove+0x4a>
 2c6:	bfc1                	j	296 <memmove+0x2a>

00000000000002c8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d0:	ca0d                	beqz	a2,302 <memcmp+0x3a>
 2d2:	fff6069b          	addiw	a3,a2,-1
 2d6:	1682                	slli	a3,a3,0x20
 2d8:	9281                	srli	a3,a3,0x20
 2da:	0685                	addi	a3,a3,1
 2dc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	0005c703          	lbu	a4,0(a1)
 2e6:	00e79863          	bne	a5,a4,2f6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2ea:	0505                	addi	a0,a0,1
    p2++;
 2ec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ee:	fed518e3          	bne	a0,a3,2de <memcmp+0x16>
  }
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	a019                	j	2fa <memcmp+0x32>
      return *p1 - *p2;
 2f6:	40e7853b          	subw	a0,a5,a4
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfdd                	j	2fa <memcmp+0x32>

0000000000000306 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30e:	00000097          	auipc	ra,0x0
 312:	f5e080e7          	jalr	-162(ra) # 26c <memmove>
}
 316:	60a2                	ld	ra,8(sp)
 318:	6402                	ld	s0,0(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret

000000000000031e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31e:	4885                	li	a7,1
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <exit>:
.global exit
exit:
 li a7, SYS_exit
 326:	4889                	li	a7,2
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <wait>:
.global wait
wait:
 li a7, SYS_wait
 32e:	488d                	li	a7,3
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 336:	4891                	li	a7,4
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <read>:
.global read
read:
 li a7, SYS_read
 33e:	4895                	li	a7,5
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <write>:
.global write
write:
 li a7, SYS_write
 346:	48c1                	li	a7,16
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <close>:
.global close
close:
 li a7, SYS_close
 34e:	48d5                	li	a7,21
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <kill>:
.global kill
kill:
 li a7, SYS_kill
 356:	4899                	li	a7,6
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <exec>:
.global exec
exec:
 li a7, SYS_exec
 35e:	489d                	li	a7,7
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <open>:
.global open
open:
 li a7, SYS_open
 366:	48bd                	li	a7,15
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36e:	48c5                	li	a7,17
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 376:	48c9                	li	a7,18
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37e:	48a1                	li	a7,8
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <link>:
.global link
link:
 li a7, SYS_link
 386:	48cd                	li	a7,19
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38e:	48d1                	li	a7,20
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 396:	48a5                	li	a7,9
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <dup>:
.global dup
dup:
 li a7, SYS_dup
 39e:	48a9                	li	a7,10
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a6:	48ad                	li	a7,11
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ae:	48b1                	li	a7,12
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b6:	48b5                	li	a7,13
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3be:	48b9                	li	a7,14
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c6:	48d9                	li	a7,22
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3ce:	48dd                	li	a7,23
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d6:	1101                	addi	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	1000                	addi	s0,sp,32
 3de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e2:	4605                	li	a2,1
 3e4:	fef40593          	addi	a1,s0,-17
 3e8:	00000097          	auipc	ra,0x0
 3ec:	f5e080e7          	jalr	-162(ra) # 346 <write>
}
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	6105                	addi	sp,sp,32
 3f6:	8082                	ret

00000000000003f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f8:	7139                	addi	sp,sp,-64
 3fa:	fc06                	sd	ra,56(sp)
 3fc:	f822                	sd	s0,48(sp)
 3fe:	f426                	sd	s1,40(sp)
 400:	f04a                	sd	s2,32(sp)
 402:	ec4e                	sd	s3,24(sp)
 404:	0080                	addi	s0,sp,64
 406:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 408:	c299                	beqz	a3,40e <printint+0x16>
 40a:	0805c063          	bltz	a1,48a <printint+0x92>
  neg = 0;
 40e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 410:	fc040313          	addi	t1,s0,-64
  neg = 0;
 414:	869a                	mv	a3,t1
  i = 0;
 416:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 418:	00000817          	auipc	a6,0x0
 41c:	5b080813          	addi	a6,a6,1456 # 9c8 <digits>
 420:	88be                	mv	a7,a5
 422:	0017851b          	addiw	a0,a5,1
 426:	87aa                	mv	a5,a0
 428:	02c5f73b          	remuw	a4,a1,a2
 42c:	1702                	slli	a4,a4,0x20
 42e:	9301                	srli	a4,a4,0x20
 430:	9742                	add	a4,a4,a6
 432:	00074703          	lbu	a4,0(a4)
 436:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 43a:	872e                	mv	a4,a1
 43c:	02c5d5bb          	divuw	a1,a1,a2
 440:	0685                	addi	a3,a3,1
 442:	fcc77fe3          	bgeu	a4,a2,420 <printint+0x28>
  if(neg)
 446:	000e0c63          	beqz	t3,45e <printint+0x66>
    buf[i++] = '-';
 44a:	fd050793          	addi	a5,a0,-48
 44e:	00878533          	add	a0,a5,s0
 452:	02d00793          	li	a5,45
 456:	fef50823          	sb	a5,-16(a0)
 45a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 45e:	fff7899b          	addiw	s3,a5,-1
 462:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 466:	fff4c583          	lbu	a1,-1(s1)
 46a:	854a                	mv	a0,s2
 46c:	00000097          	auipc	ra,0x0
 470:	f6a080e7          	jalr	-150(ra) # 3d6 <putc>
  while(--i >= 0)
 474:	39fd                	addiw	s3,s3,-1
 476:	14fd                	addi	s1,s1,-1
 478:	fe09d7e3          	bgez	s3,466 <printint+0x6e>
}
 47c:	70e2                	ld	ra,56(sp)
 47e:	7442                	ld	s0,48(sp)
 480:	74a2                	ld	s1,40(sp)
 482:	7902                	ld	s2,32(sp)
 484:	69e2                	ld	s3,24(sp)
 486:	6121                	addi	sp,sp,64
 488:	8082                	ret
    x = -xx;
 48a:	40b005bb          	negw	a1,a1
    neg = 1;
 48e:	4e05                	li	t3,1
    x = -xx;
 490:	b741                	j	410 <printint+0x18>

0000000000000492 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 492:	711d                	addi	sp,sp,-96
 494:	ec86                	sd	ra,88(sp)
 496:	e8a2                	sd	s0,80(sp)
 498:	e4a6                	sd	s1,72(sp)
 49a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49c:	0005c483          	lbu	s1,0(a1)
 4a0:	2a048863          	beqz	s1,750 <vprintf+0x2be>
 4a4:	e0ca                	sd	s2,64(sp)
 4a6:	fc4e                	sd	s3,56(sp)
 4a8:	f852                	sd	s4,48(sp)
 4aa:	f456                	sd	s5,40(sp)
 4ac:	f05a                	sd	s6,32(sp)
 4ae:	ec5e                	sd	s7,24(sp)
 4b0:	e862                	sd	s8,16(sp)
 4b2:	e466                	sd	s9,8(sp)
 4b4:	8b2a                	mv	s6,a0
 4b6:	8a2e                	mv	s4,a1
 4b8:	8bb2                	mv	s7,a2
  state = 0;
 4ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4bc:	4901                	li	s2,0
 4be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c8:	06c00c93          	li	s9,108
 4cc:	a01d                	j	4f2 <vprintf+0x60>
        putc(fd, c0);
 4ce:	85a6                	mv	a1,s1
 4d0:	855a                	mv	a0,s6
 4d2:	00000097          	auipc	ra,0x0
 4d6:	f04080e7          	jalr	-252(ra) # 3d6 <putc>
 4da:	a019                	j	4e0 <vprintf+0x4e>
    } else if(state == '%'){
 4dc:	03598363          	beq	s3,s5,502 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 4e0:	0019079b          	addiw	a5,s2,1
 4e4:	893e                	mv	s2,a5
 4e6:	873e                	mv	a4,a5
 4e8:	97d2                	add	a5,a5,s4
 4ea:	0007c483          	lbu	s1,0(a5)
 4ee:	24048963          	beqz	s1,740 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 4f2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4f6:	fe0993e3          	bnez	s3,4dc <vprintf+0x4a>
      if(c0 == '%'){
 4fa:	fd579ae3          	bne	a5,s5,4ce <vprintf+0x3c>
        state = '%';
 4fe:	89be                	mv	s3,a5
 500:	b7c5                	j	4e0 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 502:	00ea06b3          	add	a3,s4,a4
 506:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 50a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 50c:	c681                	beqz	a3,514 <vprintf+0x82>
 50e:	9752                	add	a4,a4,s4
 510:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 514:	05878063          	beq	a5,s8,554 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 518:	05978c63          	beq	a5,s9,570 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 51c:	07500713          	li	a4,117
 520:	10e78063          	beq	a5,a4,620 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 524:	07800713          	li	a4,120
 528:	14e78863          	beq	a5,a4,678 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 52c:	07000713          	li	a4,112
 530:	18e78163          	beq	a5,a4,6b2 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 534:	07300713          	li	a4,115
 538:	1ce78663          	beq	a5,a4,704 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 53c:	02500713          	li	a4,37
 540:	04e79863          	bne	a5,a4,590 <vprintf+0xfe>
        putc(fd, '%');
 544:	85ba                	mv	a1,a4
 546:	855a                	mv	a0,s6
 548:	00000097          	auipc	ra,0x0
 54c:	e8e080e7          	jalr	-370(ra) # 3d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 550:	4981                	li	s3,0
 552:	b779                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 554:	008b8493          	addi	s1,s7,8
 558:	4685                	li	a3,1
 55a:	4629                	li	a2,10
 55c:	000ba583          	lw	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	00000097          	auipc	ra,0x0
 566:	e96080e7          	jalr	-362(ra) # 3f8 <printint>
 56a:	8ba6                	mv	s7,s1
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bf8d                	j	4e0 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 570:	06400793          	li	a5,100
 574:	02f68d63          	beq	a3,a5,5ae <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 578:	06c00793          	li	a5,108
 57c:	04f68863          	beq	a3,a5,5cc <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 580:	07500793          	li	a5,117
 584:	0af68c63          	beq	a3,a5,63c <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 588:	07800793          	li	a5,120
 58c:	10f68463          	beq	a3,a5,694 <vprintf+0x202>
        putc(fd, '%');
 590:	02500593          	li	a1,37
 594:	855a                	mv	a0,s6
 596:	00000097          	auipc	ra,0x0
 59a:	e40080e7          	jalr	-448(ra) # 3d6 <putc>
        putc(fd, c0);
 59e:	85a6                	mv	a1,s1
 5a0:	855a                	mv	a0,s6
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e34080e7          	jalr	-460(ra) # 3d6 <putc>
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bf15                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e3c080e7          	jalr	-452(ra) # 3f8 <printint>
        i += 1;
 5c4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	8ba6                	mv	s7,s1
      state = 0;
 5c8:	4981                	li	s3,0
        i += 1;
 5ca:	bf19                	j	4e0 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5cc:	06400793          	li	a5,100
 5d0:	02f60963          	beq	a2,a5,602 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d4:	07500793          	li	a5,117
 5d8:	08f60163          	beq	a2,a5,65a <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5dc:	07800793          	li	a5,120
 5e0:	faf618e3          	bne	a2,a5,590 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e06080e7          	jalr	-506(ra) # 3f8 <printint>
        i += 2;
 5fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
        i += 2;
 600:	b5c5                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	008b8493          	addi	s1,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	00000097          	auipc	ra,0x0
 614:	de8080e7          	jalr	-536(ra) # 3f8 <printint>
        i += 2;
 618:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	b5c9                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	00000097          	auipc	ra,0x0
 632:	dca080e7          	jalr	-566(ra) # 3f8 <printint>
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	b55d                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	00000097          	auipc	ra,0x0
 64e:	dae080e7          	jalr	-594(ra) # 3f8 <printint>
        i += 1;
 652:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	b561                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000ba583          	lw	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	00000097          	auipc	ra,0x0
 66c:	d90080e7          	jalr	-624(ra) # 3f8 <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	b5ad                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	00000097          	auipc	ra,0x0
 68a:	d72080e7          	jalr	-654(ra) # 3f8 <printint>
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
 692:	b5b9                	j	4e0 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	008b8493          	addi	s1,s7,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000ba583          	lw	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	00000097          	auipc	ra,0x0
 6a6:	d56080e7          	jalr	-682(ra) # 3f8 <printint>
        i += 1;
 6aa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ac:	8ba6                	mv	s7,s1
      state = 0;
 6ae:	4981                	li	s3,0
        i += 1;
 6b0:	bd05                	j	4e0 <vprintf+0x4e>
 6b2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6b4:	008b8d13          	addi	s10,s7,8
 6b8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6bc:	03000593          	li	a1,48
 6c0:	855a                	mv	a0,s6
 6c2:	00000097          	auipc	ra,0x0
 6c6:	d14080e7          	jalr	-748(ra) # 3d6 <putc>
  putc(fd, 'x');
 6ca:	07800593          	li	a1,120
 6ce:	855a                	mv	a0,s6
 6d0:	00000097          	auipc	ra,0x0
 6d4:	d06080e7          	jalr	-762(ra) # 3d6 <putc>
 6d8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6da:	00000b97          	auipc	s7,0x0
 6de:	2eeb8b93          	addi	s7,s7,750 # 9c8 <digits>
 6e2:	03c9d793          	srli	a5,s3,0x3c
 6e6:	97de                	add	a5,a5,s7
 6e8:	0007c583          	lbu	a1,0(a5)
 6ec:	855a                	mv	a0,s6
 6ee:	00000097          	auipc	ra,0x0
 6f2:	ce8080e7          	jalr	-792(ra) # 3d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f6:	0992                	slli	s3,s3,0x4
 6f8:	34fd                	addiw	s1,s1,-1
 6fa:	f4e5                	bnez	s1,6e2 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 6fc:	8bea                	mv	s7,s10
      state = 0;
 6fe:	4981                	li	s3,0
 700:	6d02                	ld	s10,0(sp)
 702:	bbf9                	j	4e0 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 704:	008b8993          	addi	s3,s7,8
 708:	000bb483          	ld	s1,0(s7)
 70c:	c085                	beqz	s1,72c <vprintf+0x29a>
        for(; *s; s++)
 70e:	0004c583          	lbu	a1,0(s1)
 712:	c585                	beqz	a1,73a <vprintf+0x2a8>
          putc(fd, *s);
 714:	855a                	mv	a0,s6
 716:	00000097          	auipc	ra,0x0
 71a:	cc0080e7          	jalr	-832(ra) # 3d6 <putc>
        for(; *s; s++)
 71e:	0485                	addi	s1,s1,1
 720:	0004c583          	lbu	a1,0(s1)
 724:	f9e5                	bnez	a1,714 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 726:	8bce                	mv	s7,s3
      state = 0;
 728:	4981                	li	s3,0
 72a:	bb5d                	j	4e0 <vprintf+0x4e>
          s = "(null)";
 72c:	00000497          	auipc	s1,0x0
 730:	29448493          	addi	s1,s1,660 # 9c0 <malloc+0x17c>
        for(; *s; s++)
 734:	02800593          	li	a1,40
 738:	bff1                	j	714 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b34d                	j	4e0 <vprintf+0x4e>
 740:	6906                	ld	s2,64(sp)
 742:	79e2                	ld	s3,56(sp)
 744:	7a42                	ld	s4,48(sp)
 746:	7aa2                	ld	s5,40(sp)
 748:	7b02                	ld	s6,32(sp)
 74a:	6be2                	ld	s7,24(sp)
 74c:	6c42                	ld	s8,16(sp)
 74e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 750:	60e6                	ld	ra,88(sp)
 752:	6446                	ld	s0,80(sp)
 754:	64a6                	ld	s1,72(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret

000000000000075a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75a:	715d                	addi	sp,sp,-80
 75c:	ec06                	sd	ra,24(sp)
 75e:	e822                	sd	s0,16(sp)
 760:	1000                	addi	s0,sp,32
 762:	e010                	sd	a2,0(s0)
 764:	e414                	sd	a3,8(s0)
 766:	e818                	sd	a4,16(s0)
 768:	ec1c                	sd	a5,24(s0)
 76a:	03043023          	sd	a6,32(s0)
 76e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 772:	8622                	mv	a2,s0
 774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 778:	00000097          	auipc	ra,0x0
 77c:	d1a080e7          	jalr	-742(ra) # 492 <vprintf>
}
 780:	60e2                	ld	ra,24(sp)
 782:	6442                	ld	s0,16(sp)
 784:	6161                	addi	sp,sp,80
 786:	8082                	ret

0000000000000788 <printf>:

void
printf(const char *fmt, ...)
{
 788:	711d                	addi	sp,sp,-96
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	addi	s0,sp,32
 790:	e40c                	sd	a1,8(s0)
 792:	e810                	sd	a2,16(s0)
 794:	ec14                	sd	a3,24(s0)
 796:	f018                	sd	a4,32(s0)
 798:	f41c                	sd	a5,40(s0)
 79a:	03043823          	sd	a6,48(s0)
 79e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a2:	00840613          	addi	a2,s0,8
 7a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7aa:	85aa                	mv	a1,a0
 7ac:	4505                	li	a0,1
 7ae:	00000097          	auipc	ra,0x0
 7b2:	ce4080e7          	jalr	-796(ra) # 492 <vprintf>
}
 7b6:	60e2                	ld	ra,24(sp)
 7b8:	6442                	ld	s0,16(sp)
 7ba:	6125                	addi	sp,sp,96
 7bc:	8082                	ret

00000000000007be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7be:	1141                	addi	sp,sp,-16
 7c0:	e406                	sd	ra,8(sp)
 7c2:	e022                	sd	s0,0(sp)
 7c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00001797          	auipc	a5,0x1
 7ce:	8367b783          	ld	a5,-1994(a5) # 1000 <freep>
 7d2:	a02d                	j	7fc <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d4:	4618                	lw	a4,8(a2)
 7d6:	9f2d                	addw	a4,a4,a1
 7d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	6310                	ld	a2,0(a4)
 7e0:	a83d                	j	81e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e2:	ff852703          	lw	a4,-8(a0)
 7e6:	9f31                	addw	a4,a4,a2
 7e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ea:	ff053683          	ld	a3,-16(a0)
 7ee:	a091                	j	832 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e7e463          	bltu	a5,a4,7fa <free+0x3c>
 7f6:	00e6ea63          	bltu	a3,a4,80a <free+0x4c>
{
 7fa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	fed7fae3          	bgeu	a5,a3,7f0 <free+0x32>
 800:	6398                	ld	a4,0(a5)
 802:	00e6e463          	bltu	a3,a4,80a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	fee7eae3          	bltu	a5,a4,7fa <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 80a:	ff852583          	lw	a1,-8(a0)
 80e:	6390                	ld	a2,0(a5)
 810:	02059813          	slli	a6,a1,0x20
 814:	01c85713          	srli	a4,a6,0x1c
 818:	9736                	add	a4,a4,a3
 81a:	fae60de3          	beq	a2,a4,7d4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 81e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 822:	4790                	lw	a2,8(a5)
 824:	02061593          	slli	a1,a2,0x20
 828:	01c5d713          	srli	a4,a1,0x1c
 82c:	973e                	add	a4,a4,a5
 82e:	fae68ae3          	beq	a3,a4,7e2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 832:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
}
 83c:	60a2                	ld	ra,8(sp)
 83e:	6402                	ld	s0,0(sp)
 840:	0141                	addi	sp,sp,16
 842:	8082                	ret

0000000000000844 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 844:	7139                	addi	sp,sp,-64
 846:	fc06                	sd	ra,56(sp)
 848:	f822                	sd	s0,48(sp)
 84a:	f04a                	sd	s2,32(sp)
 84c:	ec4e                	sd	s3,24(sp)
 84e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 850:	02051993          	slli	s3,a0,0x20
 854:	0209d993          	srli	s3,s3,0x20
 858:	09bd                	addi	s3,s3,15
 85a:	0049d993          	srli	s3,s3,0x4
 85e:	2985                	addiw	s3,s3,1
 860:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 862:	00000517          	auipc	a0,0x0
 866:	79e53503          	ld	a0,1950(a0) # 1000 <freep>
 86a:	c905                	beqz	a0,89a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86e:	4798                	lw	a4,8(a5)
 870:	09377a63          	bgeu	a4,s3,904 <malloc+0xc0>
 874:	f426                	sd	s1,40(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 87c:	8a4e                	mv	s4,s3
 87e:	6705                	lui	a4,0x1
 880:	00e9f363          	bgeu	s3,a4,886 <malloc+0x42>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88e:	00000497          	auipc	s1,0x0
 892:	77248493          	addi	s1,s1,1906 # 1000 <freep>
  if(p == (char*)-1)
 896:	5afd                	li	s5,-1
 898:	a089                	j	8da <malloc+0x96>
 89a:	f426                	sd	s1,40(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a2:	00000797          	auipc	a5,0x0
 8a6:	76e78793          	addi	a5,a5,1902 # 1010 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
 8b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b8:	b7d1                	j	87c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a8b9                	j	91c <malloc+0xd8>
  hp->s.size = nu;
 8c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c4:	0541                	addi	a0,a0,16
 8c6:	00000097          	auipc	ra,0x0
 8ca:	ef8080e7          	jalr	-264(ra) # 7be <free>
  return freep;
 8ce:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8d0:	c135                	beqz	a0,934 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	03277363          	bgeu	a4,s2,8fc <malloc+0xb8>
    if(p == freep)
 8da:	6098                	ld	a4,0(s1)
 8dc:	853e                	mv	a0,a5
 8de:	fef71ae3          	bne	a4,a5,8d2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8e2:	8552                	mv	a0,s4
 8e4:	00000097          	auipc	ra,0x0
 8e8:	aca080e7          	jalr	-1334(ra) # 3ae <sbrk>
  if(p == (char*)-1)
 8ec:	fd551ae3          	bne	a0,s5,8c0 <malloc+0x7c>
        return 0;
 8f0:	4501                	li	a0,0
 8f2:	74a2                	ld	s1,40(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
 8fa:	a03d                	j	928 <malloc+0xe4>
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 904:	fae90be3          	beq	s2,a4,8ba <malloc+0x76>
        p->s.size -= nunits;
 908:	4137073b          	subw	a4,a4,s3
 90c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90e:	02071693          	slli	a3,a4,0x20
 912:	01c6d713          	srli	a4,a3,0x1c
 916:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 918:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91c:	00000717          	auipc	a4,0x0
 920:	6ea73223          	sd	a0,1764(a4) # 1000 <freep>
      return (void*)(p + 1);
 924:	01078513          	addi	a0,a5,16
  }
}
 928:	70e2                	ld	ra,56(sp)
 92a:	7442                	ld	s0,48(sp)
 92c:	7902                	ld	s2,32(sp)
 92e:	69e2                	ld	s3,24(sp)
 930:	6121                	addi	sp,sp,64
 932:	8082                	ret
 934:	74a2                	ld	s1,40(sp)
 936:	6a42                	ld	s4,16(sp)
 938:	6aa2                	ld	s5,8(sp)
 93a:	6b02                	ld	s6,0(sp)
 93c:	b7f5                	j	928 <malloc+0xe4>
