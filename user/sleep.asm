
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
   a:	02f50063          	beq	a0,a5,2a <main+0x2a>
    printf("Wrong Format. Correct Format is:\n\t%s %s", argv[PROGRAM_NAME_INDEX], "<Number Of Ticks To Wait>\n");
   e:	00001617          	auipc	a2,0x1
  12:	8a260613          	addi	a2,a2,-1886 # 8b0 <malloc+0xf8>
  16:	618c                	ld	a1,0(a1)
  18:	00001517          	auipc	a0,0x1
  1c:	8b850513          	addi	a0,a0,-1864 # 8d0 <malloc+0x118>
  20:	6e0000ef          	jal	700 <printf>
    exit(ERROR);
  24:	4505                	li	a0,1
  26:	2c8000ef          	jal	2ee <exit>
  }

  // Make sure the given amount of ticks is a positive integer (if it's not an integer then 0 will be returned).
  int ticksToWait = atoi(argv[SLEEP_DURATION_INDEX]);
  2a:	6588                	ld	a0,8(a1)
  2c:	1c0000ef          	jal	1ec <atoi>
  if (ticksToWait <= 0) {
  30:	00a05763          	blez	a0,3e <main+0x3e>
    printf("Error: Number of ticks must be a positive integer.\n");
    exit(ERROR);
  }

  sleep(ticksToWait);
  34:	34a000ef          	jal	37e <sleep>
  exit(SUCCESS);
  38:	4501                	li	a0,0
  3a:	2b4000ef          	jal	2ee <exit>
    printf("Error: Number of ticks must be a positive integer.\n");
  3e:	00001517          	auipc	a0,0x1
  42:	8ba50513          	addi	a0,a0,-1862 # 8f8 <malloc+0x140>
  46:	6ba000ef          	jal	700 <printf>
    exit(ERROR);
  4a:	4505                	li	a0,1
  4c:	2a2000ef          	jal	2ee <exit>

0000000000000050 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  extern int main();
  main();
  58:	fa9ff0ef          	jal	0 <main>
  exit(0);
  5c:	4501                	li	a0,0
  5e:	290000ef          	jal	2ee <exit>

0000000000000062 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	addi	a1,a1,1
  6e:	0785                	addi	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0xa>
    ;
  return os;
}
  7a:	60a2                	ld	ra,8(sp)
  7c:	6402                	ld	s0,0(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1141                	addi	sp,sp,-16
  84:	e406                	sd	ra,8(sp)
  86:	e022                	sd	s0,0(sp)
  88:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8a:	00054783          	lbu	a5,0(a0)
  8e:	cb91                	beqz	a5,a2 <strcmp+0x20>
  90:	0005c703          	lbu	a4,0(a1)
  94:	00f71763          	bne	a4,a5,a2 <strcmp+0x20>
    p++, q++;
  98:	0505                	addi	a0,a0,1
  9a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	fbe5                	bnez	a5,90 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a2:	0005c503          	lbu	a0,0(a1)
}
  a6:	40a7853b          	subw	a0,a5,a0
  aa:	60a2                	ld	ra,8(sp)
  ac:	6402                	ld	s0,0(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret

00000000000000b2 <strlen>:

uint
strlen(const char *s)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e406                	sd	ra,8(sp)
  b6:	e022                	sd	s0,0(sp)
  b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cf99                	beqz	a5,dc <strlen+0x2a>
  c0:	0505                	addi	a0,a0,1
  c2:	87aa                	mv	a5,a0
  c4:	86be                	mv	a3,a5
  c6:	0785                	addi	a5,a5,1
  c8:	fff7c703          	lbu	a4,-1(a5)
  cc:	ff65                	bnez	a4,c4 <strlen+0x12>
  ce:	40a6853b          	subw	a0,a3,a0
  d2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  for(n = 0; s[n]; n++)
  dc:	4501                	li	a0,0
  de:	bfdd                	j	d4 <strlen+0x22>

00000000000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e8:	ca19                	beqz	a2,fe <memset+0x1e>
  ea:	87aa                	mv	a5,a0
  ec:	1602                	slli	a2,a2,0x20
  ee:	9201                	srli	a2,a2,0x20
  f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f8:	0785                	addi	a5,a5,1
  fa:	fee79de3          	bne	a5,a4,f4 <memset+0x14>
  }
  return dst;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strchr>:

char*
strchr(const char *s, char c)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cf81                	beqz	a5,12a <strchr+0x24>
    if(*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1c>
  for(; *s; s++)
 118:	0505                	addi	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xe>
      return (char*)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret
  return 0;
 12a:	4501                	li	a0,0
 12c:	bfdd                	j	122 <strchr+0x1c>

000000000000012e <gets>:

char*
gets(char *buf, int max)
{
 12e:	7159                	addi	sp,sp,-112
 130:	f486                	sd	ra,104(sp)
 132:	f0a2                	sd	s0,96(sp)
 134:	eca6                	sd	s1,88(sp)
 136:	e8ca                	sd	s2,80(sp)
 138:	e4ce                	sd	s3,72(sp)
 13a:	e0d2                	sd	s4,64(sp)
 13c:	fc56                	sd	s5,56(sp)
 13e:	f85a                	sd	s6,48(sp)
 140:	f45e                	sd	s7,40(sp)
 142:	f062                	sd	s8,32(sp)
 144:	ec66                	sd	s9,24(sp)
 146:	e86a                	sd	s10,16(sp)
 148:	1880                	addi	s0,sp,112
 14a:	8caa                	mv	s9,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
 152:	f9f40b13          	addi	s6,s0,-97
 156:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 158:	4ba9                	li	s7,10
 15a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 15c:	8d26                	mv	s10,s1
 15e:	0014899b          	addiw	s3,s1,1
 162:	84ce                	mv	s1,s3
 164:	0349d563          	bge	s3,s4,18e <gets+0x60>
    cc = read(0, &c, 1);
 168:	8656                	mv	a2,s5
 16a:	85da                	mv	a1,s6
 16c:	4501                	li	a0,0
 16e:	198000ef          	jal	306 <read>
    if(cc < 1)
 172:	00a05e63          	blez	a0,18e <gets+0x60>
    buf[i++] = c;
 176:	f9f44783          	lbu	a5,-97(s0)
 17a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17e:	01778763          	beq	a5,s7,18c <gets+0x5e>
 182:	0905                	addi	s2,s2,1
 184:	fd879ce3          	bne	a5,s8,15c <gets+0x2e>
    buf[i++] = c;
 188:	8d4e                	mv	s10,s3
 18a:	a011                	j	18e <gets+0x60>
 18c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 18e:	9d66                	add	s10,s10,s9
 190:	000d0023          	sb	zero,0(s10)
  return buf;
}
 194:	8566                	mv	a0,s9
 196:	70a6                	ld	ra,104(sp)
 198:	7406                	ld	s0,96(sp)
 19a:	64e6                	ld	s1,88(sp)
 19c:	6946                	ld	s2,80(sp)
 19e:	69a6                	ld	s3,72(sp)
 1a0:	6a06                	ld	s4,64(sp)
 1a2:	7ae2                	ld	s5,56(sp)
 1a4:	7b42                	ld	s6,48(sp)
 1a6:	7ba2                	ld	s7,40(sp)
 1a8:	7c02                	ld	s8,32(sp)
 1aa:	6ce2                	ld	s9,24(sp)
 1ac:	6d42                	ld	s10,16(sp)
 1ae:	6165                	addi	sp,sp,112
 1b0:	8082                	ret

00000000000001b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b2:	1101                	addi	sp,sp,-32
 1b4:	ec06                	sd	ra,24(sp)
 1b6:	e822                	sd	s0,16(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	16e000ef          	jal	32e <open>
  if(fd < 0)
 1c4:	02054263          	bltz	a0,1e8 <stat+0x36>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	178000ef          	jal	346 <fstat>
 1d2:	892a                	mv	s2,a0
  close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	140000ef          	jal	316 <close>
  return r;
 1da:	64a2                	ld	s1,8(sp)
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	6902                	ld	s2,0(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret
    return -1;
 1e8:	597d                	li	s2,-1
 1ea:	bfcd                	j	1dc <stat+0x2a>

00000000000001ec <atoi>:

int
atoi(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054683          	lbu	a3,0(a0)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	4625                	li	a2,9
 202:	02f66963          	bltu	a2,a5,234 <atoi+0x48>
 206:	872a                	mv	a4,a0
  n = 0;
 208:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20a:	0705                	addi	a4,a4,1
 20c:	0025179b          	slliw	a5,a0,0x2
 210:	9fa9                	addw	a5,a5,a0
 212:	0017979b          	slliw	a5,a5,0x1
 216:	9fb5                	addw	a5,a5,a3
 218:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21c:	00074683          	lbu	a3,0(a4)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	fef671e3          	bgeu	a2,a5,20a <atoi+0x1e>
  return n;
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  n = 0;
 234:	4501                	li	a0,0
 236:	bfdd                	j	22c <atoi+0x40>

0000000000000238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e406                	sd	ra,8(sp)
 23c:	e022                	sd	s0,0(sp)
 23e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 240:	02b57563          	bgeu	a0,a1,26a <memmove+0x32>
    while(n-- > 0)
 244:	00c05f63          	blez	a2,262 <memmove+0x2a>
 248:	1602                	slli	a2,a2,0x20
 24a:	9201                	srli	a2,a2,0x20
 24c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 250:	872a                	mv	a4,a0
      *dst++ = *src++;
 252:	0585                	addi	a1,a1,1
 254:	0705                	addi	a4,a4,1
 256:	fff5c683          	lbu	a3,-1(a1)
 25a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25e:	fee79ae3          	bne	a5,a4,252 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 262:	60a2                	ld	ra,8(sp)
 264:	6402                	ld	s0,0(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
    dst += n;
 26a:	00c50733          	add	a4,a0,a2
    src += n;
 26e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 270:	fec059e3          	blez	a2,262 <memmove+0x2a>
 274:	fff6079b          	addiw	a5,a2,-1
 278:	1782                	slli	a5,a5,0x20
 27a:	9381                	srli	a5,a5,0x20
 27c:	fff7c793          	not	a5,a5
 280:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 282:	15fd                	addi	a1,a1,-1
 284:	177d                	addi	a4,a4,-1
 286:	0005c683          	lbu	a3,0(a1)
 28a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28e:	fef71ae3          	bne	a4,a5,282 <memmove+0x4a>
 292:	bfc1                	j	262 <memmove+0x2a>

0000000000000294 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29c:	ca0d                	beqz	a2,2ce <memcmp+0x3a>
 29e:	fff6069b          	addiw	a3,a2,-1
 2a2:	1682                	slli	a3,a3,0x20
 2a4:	9281                	srli	a3,a3,0x20
 2a6:	0685                	addi	a3,a3,1
 2a8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	0005c703          	lbu	a4,0(a1)
 2b2:	00e79863          	bne	a5,a4,2c2 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2b6:	0505                	addi	a0,a0,1
    p2++;
 2b8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ba:	fed518e3          	bne	a0,a3,2aa <memcmp+0x16>
  }
  return 0;
 2be:	4501                	li	a0,0
 2c0:	a019                	j	2c6 <memcmp+0x32>
      return *p1 - *p2;
 2c2:	40e7853b          	subw	a0,a5,a4
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	bfdd                	j	2c6 <memcmp+0x32>

00000000000002d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2da:	f5fff0ef          	jal	238 <memmove>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e6:	4885                	li	a7,1
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ee:	4889                	li	a7,2
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f6:	488d                	li	a7,3
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fe:	4891                	li	a7,4
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <read>:
.global read
read:
 li a7, SYS_read
 306:	4895                	li	a7,5
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <write>:
.global write
write:
 li a7, SYS_write
 30e:	48c1                	li	a7,16
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <close>:
.global close
close:
 li a7, SYS_close
 316:	48d5                	li	a7,21
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <kill>:
.global kill
kill:
 li a7, SYS_kill
 31e:	4899                	li	a7,6
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <exec>:
.global exec
exec:
 li a7, SYS_exec
 326:	489d                	li	a7,7
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <open>:
.global open
open:
 li a7, SYS_open
 32e:	48bd                	li	a7,15
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 336:	48c5                	li	a7,17
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33e:	48c9                	li	a7,18
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 346:	48a1                	li	a7,8
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <link>:
.global link
link:
 li a7, SYS_link
 34e:	48cd                	li	a7,19
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 356:	48d1                	li	a7,20
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35e:	48a5                	li	a7,9
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <dup>:
.global dup
dup:
 li a7, SYS_dup
 366:	48a9                	li	a7,10
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36e:	48ad                	li	a7,11
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 376:	48b1                	li	a7,12
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37e:	48b5                	li	a7,13
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 386:	48b9                	li	a7,14
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <trace>:
.global trace
trace:
 li a7, SYS_trace
 38e:	48d9                	li	a7,22
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 396:	48dd                	li	a7,23
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39e:	1101                	addi	sp,sp,-32
 3a0:	ec06                	sd	ra,24(sp)
 3a2:	e822                	sd	s0,16(sp)
 3a4:	1000                	addi	s0,sp,32
 3a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3aa:	4605                	li	a2,1
 3ac:	fef40593          	addi	a1,s0,-17
 3b0:	f5fff0ef          	jal	30e <write>
}
 3b4:	60e2                	ld	ra,24(sp)
 3b6:	6442                	ld	s0,16(sp)
 3b8:	6105                	addi	sp,sp,32
 3ba:	8082                	ret

00000000000003bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bc:	7139                	addi	sp,sp,-64
 3be:	fc06                	sd	ra,56(sp)
 3c0:	f822                	sd	s0,48(sp)
 3c2:	f426                	sd	s1,40(sp)
 3c4:	f04a                	sd	s2,32(sp)
 3c6:	ec4e                	sd	s3,24(sp)
 3c8:	0080                	addi	s0,sp,64
 3ca:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3cc:	c299                	beqz	a3,3d2 <printint+0x16>
 3ce:	0605ce63          	bltz	a1,44a <printint+0x8e>
  neg = 0;
 3d2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3d4:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3d8:	869a                	mv	a3,t1
  i = 0;
 3da:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3dc:	00000817          	auipc	a6,0x0
 3e0:	55c80813          	addi	a6,a6,1372 # 938 <digits>
 3e4:	88be                	mv	a7,a5
 3e6:	0017851b          	addiw	a0,a5,1
 3ea:	87aa                	mv	a5,a0
 3ec:	02c5f73b          	remuw	a4,a1,a2
 3f0:	1702                	slli	a4,a4,0x20
 3f2:	9301                	srli	a4,a4,0x20
 3f4:	9742                	add	a4,a4,a6
 3f6:	00074703          	lbu	a4,0(a4)
 3fa:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3fe:	872e                	mv	a4,a1
 400:	02c5d5bb          	divuw	a1,a1,a2
 404:	0685                	addi	a3,a3,1
 406:	fcc77fe3          	bgeu	a4,a2,3e4 <printint+0x28>
  if(neg)
 40a:	000e0c63          	beqz	t3,422 <printint+0x66>
    buf[i++] = '-';
 40e:	fd050793          	addi	a5,a0,-48
 412:	00878533          	add	a0,a5,s0
 416:	02d00793          	li	a5,45
 41a:	fef50823          	sb	a5,-16(a0)
 41e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 422:	fff7899b          	addiw	s3,a5,-1
 426:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 42a:	fff4c583          	lbu	a1,-1(s1)
 42e:	854a                	mv	a0,s2
 430:	f6fff0ef          	jal	39e <putc>
  while(--i >= 0)
 434:	39fd                	addiw	s3,s3,-1
 436:	14fd                	addi	s1,s1,-1
 438:	fe09d9e3          	bgez	s3,42a <printint+0x6e>
}
 43c:	70e2                	ld	ra,56(sp)
 43e:	7442                	ld	s0,48(sp)
 440:	74a2                	ld	s1,40(sp)
 442:	7902                	ld	s2,32(sp)
 444:	69e2                	ld	s3,24(sp)
 446:	6121                	addi	sp,sp,64
 448:	8082                	ret
    x = -xx;
 44a:	40b005bb          	negw	a1,a1
    neg = 1;
 44e:	4e05                	li	t3,1
    x = -xx;
 450:	b751                	j	3d4 <printint+0x18>

0000000000000452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 452:	711d                	addi	sp,sp,-96
 454:	ec86                	sd	ra,88(sp)
 456:	e8a2                	sd	s0,80(sp)
 458:	e4a6                	sd	s1,72(sp)
 45a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45c:	0005c483          	lbu	s1,0(a1)
 460:	26048663          	beqz	s1,6cc <vprintf+0x27a>
 464:	e0ca                	sd	s2,64(sp)
 466:	fc4e                	sd	s3,56(sp)
 468:	f852                	sd	s4,48(sp)
 46a:	f456                	sd	s5,40(sp)
 46c:	f05a                	sd	s6,32(sp)
 46e:	ec5e                	sd	s7,24(sp)
 470:	e862                	sd	s8,16(sp)
 472:	e466                	sd	s9,8(sp)
 474:	8b2a                	mv	s6,a0
 476:	8a2e                	mv	s4,a1
 478:	8bb2                	mv	s7,a2
  state = 0;
 47a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47c:	4901                	li	s2,0
 47e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 480:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 484:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 488:	06c00c93          	li	s9,108
 48c:	a00d                	j	4ae <vprintf+0x5c>
        putc(fd, c0);
 48e:	85a6                	mv	a1,s1
 490:	855a                	mv	a0,s6
 492:	f0dff0ef          	jal	39e <putc>
 496:	a019                	j	49c <vprintf+0x4a>
    } else if(state == '%'){
 498:	03598363          	beq	s3,s5,4be <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 49c:	0019079b          	addiw	a5,s2,1
 4a0:	893e                	mv	s2,a5
 4a2:	873e                	mv	a4,a5
 4a4:	97d2                	add	a5,a5,s4
 4a6:	0007c483          	lbu	s1,0(a5)
 4aa:	20048963          	beqz	s1,6bc <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4ae:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4b2:	fe0993e3          	bnez	s3,498 <vprintf+0x46>
      if(c0 == '%'){
 4b6:	fd579ce3          	bne	a5,s5,48e <vprintf+0x3c>
        state = '%';
 4ba:	89be                	mv	s3,a5
 4bc:	b7c5                	j	49c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4be:	00ea06b3          	add	a3,s4,a4
 4c2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4c8:	c681                	beqz	a3,4d0 <vprintf+0x7e>
 4ca:	9752                	add	a4,a4,s4
 4cc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4d0:	03878e63          	beq	a5,s8,50c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4d4:	05978863          	beq	a5,s9,524 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4d8:	07500713          	li	a4,117
 4dc:	0ee78263          	beq	a5,a4,5c0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4e0:	07800713          	li	a4,120
 4e4:	12e78463          	beq	a5,a4,60c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4e8:	07000713          	li	a4,112
 4ec:	14e78963          	beq	a5,a4,63e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4f0:	07300713          	li	a4,115
 4f4:	18e78863          	beq	a5,a4,684 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4f8:	02500713          	li	a4,37
 4fc:	04e79463          	bne	a5,a4,544 <vprintf+0xf2>
        putc(fd, '%');
 500:	85ba                	mv	a1,a4
 502:	855a                	mv	a0,s6
 504:	e9bff0ef          	jal	39e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 508:	4981                	li	s3,0
 50a:	bf49                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 50c:	008b8493          	addi	s1,s7,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000ba583          	lw	a1,0(s7)
 518:	855a                	mv	a0,s6
 51a:	ea3ff0ef          	jal	3bc <printint>
 51e:	8ba6                	mv	s7,s1
      state = 0;
 520:	4981                	li	s3,0
 522:	bfad                	j	49c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 524:	06400793          	li	a5,100
 528:	02f68963          	beq	a3,a5,55a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52c:	06c00793          	li	a5,108
 530:	04f68263          	beq	a3,a5,574 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 534:	07500793          	li	a5,117
 538:	0af68063          	beq	a3,a5,5d8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 53c:	07800793          	li	a5,120
 540:	0ef68263          	beq	a3,a5,624 <vprintf+0x1d2>
        putc(fd, '%');
 544:	02500593          	li	a1,37
 548:	855a                	mv	a0,s6
 54a:	e55ff0ef          	jal	39e <putc>
        putc(fd, c0);
 54e:	85a6                	mv	a1,s1
 550:	855a                	mv	a0,s6
 552:	e4dff0ef          	jal	39e <putc>
      state = 0;
 556:	4981                	li	s3,0
 558:	b791                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000ba583          	lw	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e55ff0ef          	jal	3bc <printint>
        i += 1;
 56c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
        i += 1;
 572:	b72d                	j	49c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 574:	06400793          	li	a5,100
 578:	02f60763          	beq	a2,a5,5a6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 57c:	07500793          	li	a5,117
 580:	06f60963          	beq	a2,a5,5f2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 584:	07800793          	li	a5,120
 588:	faf61ee3          	bne	a2,a5,544 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4641                	li	a2,16
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e23ff0ef          	jal	3bc <printint>
        i += 2;
 59e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
        i += 2;
 5a4:	bde5                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4685                	li	a3,1
 5ac:	4629                	li	a2,10
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	e09ff0ef          	jal	3bc <printint>
        i += 2;
 5b8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	8ba6                	mv	s7,s1
      state = 0;
 5bc:	4981                	li	s3,0
        i += 2;
 5be:	bdf9                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	defff0ef          	jal	3bc <printint>
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b5d9                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4681                	li	a3,0
 5de:	4629                	li	a2,10
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	dd7ff0ef          	jal	3bc <printint>
        i += 1;
 5ea:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
        i += 1;
 5f0:	b575                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4629                	li	a2,10
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	dbdff0ef          	jal	3bc <printint>
        i += 2;
 604:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	bd49                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 60c:	008b8493          	addi	s1,s7,8
 610:	4681                	li	a3,0
 612:	4641                	li	a2,16
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	da3ff0ef          	jal	3bc <printint>
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
 622:	bdad                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	008b8493          	addi	s1,s7,8
 628:	4681                	li	a3,0
 62a:	4641                	li	a2,16
 62c:	000ba583          	lw	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	d8bff0ef          	jal	3bc <printint>
        i += 1;
 636:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
        i += 1;
 63c:	b585                	j	49c <vprintf+0x4a>
 63e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 640:	008b8d13          	addi	s10,s7,8
 644:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 648:	03000593          	li	a1,48
 64c:	855a                	mv	a0,s6
 64e:	d51ff0ef          	jal	39e <putc>
  putc(fd, 'x');
 652:	07800593          	li	a1,120
 656:	855a                	mv	a0,s6
 658:	d47ff0ef          	jal	39e <putc>
 65c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65e:	00000b97          	auipc	s7,0x0
 662:	2dab8b93          	addi	s7,s7,730 # 938 <digits>
 666:	03c9d793          	srli	a5,s3,0x3c
 66a:	97de                	add	a5,a5,s7
 66c:	0007c583          	lbu	a1,0(a5)
 670:	855a                	mv	a0,s6
 672:	d2dff0ef          	jal	39e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	slli	s3,s3,0x4
 678:	34fd                	addiw	s1,s1,-1
 67a:	f4f5                	bnez	s1,666 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 67c:	8bea                	mv	s7,s10
      state = 0;
 67e:	4981                	li	s3,0
 680:	6d02                	ld	s10,0(sp)
 682:	bd29                	j	49c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 684:	008b8993          	addi	s3,s7,8
 688:	000bb483          	ld	s1,0(s7)
 68c:	cc91                	beqz	s1,6a8 <vprintf+0x256>
        for(; *s; s++)
 68e:	0004c583          	lbu	a1,0(s1)
 692:	c195                	beqz	a1,6b6 <vprintf+0x264>
          putc(fd, *s);
 694:	855a                	mv	a0,s6
 696:	d09ff0ef          	jal	39e <putc>
        for(; *s; s++)
 69a:	0485                	addi	s1,s1,1
 69c:	0004c583          	lbu	a1,0(s1)
 6a0:	f9f5                	bnez	a1,694 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6a2:	8bce                	mv	s7,s3
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bbdd                	j	49c <vprintf+0x4a>
          s = "(null)";
 6a8:	00000497          	auipc	s1,0x0
 6ac:	28848493          	addi	s1,s1,648 # 930 <malloc+0x178>
        for(; *s; s++)
 6b0:	02800593          	li	a1,40
 6b4:	b7c5                	j	694 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b3cd                	j	49c <vprintf+0x4a>
 6bc:	6906                	ld	s2,64(sp)
 6be:	79e2                	ld	s3,56(sp)
 6c0:	7a42                	ld	s4,48(sp)
 6c2:	7aa2                	ld	s5,40(sp)
 6c4:	7b02                	ld	s6,32(sp)
 6c6:	6be2                	ld	s7,24(sp)
 6c8:	6c42                	ld	s8,16(sp)
 6ca:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6cc:	60e6                	ld	ra,88(sp)
 6ce:	6446                	ld	s0,80(sp)
 6d0:	64a6                	ld	s1,72(sp)
 6d2:	6125                	addi	sp,sp,96
 6d4:	8082                	ret

00000000000006d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d6:	715d                	addi	sp,sp,-80
 6d8:	ec06                	sd	ra,24(sp)
 6da:	e822                	sd	s0,16(sp)
 6dc:	1000                	addi	s0,sp,32
 6de:	e010                	sd	a2,0(s0)
 6e0:	e414                	sd	a3,8(s0)
 6e2:	e818                	sd	a4,16(s0)
 6e4:	ec1c                	sd	a5,24(s0)
 6e6:	03043023          	sd	a6,32(s0)
 6ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ee:	8622                	mv	a2,s0
 6f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f4:	d5fff0ef          	jal	452 <vprintf>
}
 6f8:	60e2                	ld	ra,24(sp)
 6fa:	6442                	ld	s0,16(sp)
 6fc:	6161                	addi	sp,sp,80
 6fe:	8082                	ret

0000000000000700 <printf>:

void
printf(const char *fmt, ...)
{
 700:	711d                	addi	sp,sp,-96
 702:	ec06                	sd	ra,24(sp)
 704:	e822                	sd	s0,16(sp)
 706:	1000                	addi	s0,sp,32
 708:	e40c                	sd	a1,8(s0)
 70a:	e810                	sd	a2,16(s0)
 70c:	ec14                	sd	a3,24(s0)
 70e:	f018                	sd	a4,32(s0)
 710:	f41c                	sd	a5,40(s0)
 712:	03043823          	sd	a6,48(s0)
 716:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 71a:	00840613          	addi	a2,s0,8
 71e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 722:	85aa                	mv	a1,a0
 724:	4505                	li	a0,1
 726:	d2dff0ef          	jal	452 <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6125                	addi	sp,sp,96
 730:	8082                	ret

0000000000000732 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 732:	1141                	addi	sp,sp,-16
 734:	e406                	sd	ra,8(sp)
 736:	e022                	sd	s0,0(sp)
 738:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	00001797          	auipc	a5,0x1
 742:	8c27b783          	ld	a5,-1854(a5) # 1000 <freep>
 746:	a02d                	j	770 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 748:	4618                	lw	a4,8(a2)
 74a:	9f2d                	addw	a4,a4,a1
 74c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	6398                	ld	a4,0(a5)
 752:	6310                	ld	a2,0(a4)
 754:	a83d                	j	792 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 756:	ff852703          	lw	a4,-8(a0)
 75a:	9f31                	addw	a4,a4,a2
 75c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75e:	ff053683          	ld	a3,-16(a0)
 762:	a091                	j	7a6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 764:	6398                	ld	a4,0(a5)
 766:	00e7e463          	bltu	a5,a4,76e <free+0x3c>
 76a:	00e6ea63          	bltu	a3,a4,77e <free+0x4c>
{
 76e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 770:	fed7fae3          	bgeu	a5,a3,764 <free+0x32>
 774:	6398                	ld	a4,0(a5)
 776:	00e6e463          	bltu	a3,a4,77e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77a:	fee7eae3          	bltu	a5,a4,76e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 77e:	ff852583          	lw	a1,-8(a0)
 782:	6390                	ld	a2,0(a5)
 784:	02059813          	slli	a6,a1,0x20
 788:	01c85713          	srli	a4,a6,0x1c
 78c:	9736                	add	a4,a4,a3
 78e:	fae60de3          	beq	a2,a4,748 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 796:	4790                	lw	a2,8(a5)
 798:	02061593          	slli	a1,a2,0x20
 79c:	01c5d713          	srli	a4,a1,0x1c
 7a0:	973e                	add	a4,a4,a5
 7a2:	fae68ae3          	beq	a3,a4,756 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7a6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a8:	00001717          	auipc	a4,0x1
 7ac:	84f73c23          	sd	a5,-1960(a4) # 1000 <freep>
}
 7b0:	60a2                	ld	ra,8(sp)
 7b2:	6402                	ld	s0,0(sp)
 7b4:	0141                	addi	sp,sp,16
 7b6:	8082                	ret

00000000000007b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b8:	7139                	addi	sp,sp,-64
 7ba:	fc06                	sd	ra,56(sp)
 7bc:	f822                	sd	s0,48(sp)
 7be:	f04a                	sd	s2,32(sp)
 7c0:	ec4e                	sd	s3,24(sp)
 7c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c4:	02051993          	slli	s3,a0,0x20
 7c8:	0209d993          	srli	s3,s3,0x20
 7cc:	09bd                	addi	s3,s3,15
 7ce:	0049d993          	srli	s3,s3,0x4
 7d2:	2985                	addiw	s3,s3,1
 7d4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7d6:	00001517          	auipc	a0,0x1
 7da:	82a53503          	ld	a0,-2006(a0) # 1000 <freep>
 7de:	c905                	beqz	a0,80e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e2:	4798                	lw	a4,8(a5)
 7e4:	09377663          	bgeu	a4,s3,870 <malloc+0xb8>
 7e8:	f426                	sd	s1,40(sp)
 7ea:	e852                	sd	s4,16(sp)
 7ec:	e456                	sd	s5,8(sp)
 7ee:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7f0:	8a4e                	mv	s4,s3
 7f2:	6705                	lui	a4,0x1
 7f4:	00e9f363          	bgeu	s3,a4,7fa <malloc+0x42>
 7f8:	6a05                	lui	s4,0x1
 7fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 802:	00000497          	auipc	s1,0x0
 806:	7fe48493          	addi	s1,s1,2046 # 1000 <freep>
  if(p == (char*)-1)
 80a:	5afd                	li	s5,-1
 80c:	a83d                	j	84a <malloc+0x92>
 80e:	f426                	sd	s1,40(sp)
 810:	e852                	sd	s4,16(sp)
 812:	e456                	sd	s5,8(sp)
 814:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 816:	00000797          	auipc	a5,0x0
 81a:	7fa78793          	addi	a5,a5,2042 # 1010 <base>
 81e:	00000717          	auipc	a4,0x0
 822:	7ef73123          	sd	a5,2018(a4) # 1000 <freep>
 826:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 828:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 82c:	b7d1                	j	7f0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 82e:	6398                	ld	a4,0(a5)
 830:	e118                	sd	a4,0(a0)
 832:	a899                	j	888 <malloc+0xd0>
  hp->s.size = nu;
 834:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 838:	0541                	addi	a0,a0,16
 83a:	ef9ff0ef          	jal	732 <free>
  return freep;
 83e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 840:	c125                	beqz	a0,8a0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 844:	4798                	lw	a4,8(a5)
 846:	03277163          	bgeu	a4,s2,868 <malloc+0xb0>
    if(p == freep)
 84a:	6098                	ld	a4,0(s1)
 84c:	853e                	mv	a0,a5
 84e:	fef71ae3          	bne	a4,a5,842 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 852:	8552                	mv	a0,s4
 854:	b23ff0ef          	jal	376 <sbrk>
  if(p == (char*)-1)
 858:	fd551ee3          	bne	a0,s5,834 <malloc+0x7c>
        return 0;
 85c:	4501                	li	a0,0
 85e:	74a2                	ld	s1,40(sp)
 860:	6a42                	ld	s4,16(sp)
 862:	6aa2                	ld	s5,8(sp)
 864:	6b02                	ld	s6,0(sp)
 866:	a03d                	j	894 <malloc+0xdc>
 868:	74a2                	ld	s1,40(sp)
 86a:	6a42                	ld	s4,16(sp)
 86c:	6aa2                	ld	s5,8(sp)
 86e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 870:	fae90fe3          	beq	s2,a4,82e <malloc+0x76>
        p->s.size -= nunits;
 874:	4137073b          	subw	a4,a4,s3
 878:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87a:	02071693          	slli	a3,a4,0x20
 87e:	01c6d713          	srli	a4,a3,0x1c
 882:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 884:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 888:	00000717          	auipc	a4,0x0
 88c:	76a73c23          	sd	a0,1912(a4) # 1000 <freep>
      return (void*)(p + 1);
 890:	01078513          	addi	a0,a5,16
  }
}
 894:	70e2                	ld	ra,56(sp)
 896:	7442                	ld	s0,48(sp)
 898:	7902                	ld	s2,32(sp)
 89a:	69e2                	ld	s3,24(sp)
 89c:	6121                	addi	sp,sp,64
 89e:	8082                	ret
 8a0:	74a2                	ld	s1,40(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
 8a8:	b7f5                	j	894 <malloc+0xdc>
