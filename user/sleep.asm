
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
  12:	8a260613          	addi	a2,a2,-1886 # 8b0 <malloc+0x100>
  16:	618c                	ld	a1,0(a1)
  18:	00001517          	auipc	a0,0x1
  1c:	8b850513          	addi	a0,a0,-1864 # 8d0 <malloc+0x120>
  20:	6d8000ef          	jal	6f8 <printf>
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
  42:	8ba50513          	addi	a0,a0,-1862 # 8f8 <malloc+0x148>
  46:	6b2000ef          	jal	6f8 <printf>
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

0000000000000396 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 396:	1101                	addi	sp,sp,-32
 398:	ec06                	sd	ra,24(sp)
 39a:	e822                	sd	s0,16(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a2:	4605                	li	a2,1
 3a4:	fef40593          	addi	a1,s0,-17
 3a8:	f67ff0ef          	jal	30e <write>
}
 3ac:	60e2                	ld	ra,24(sp)
 3ae:	6442                	ld	s0,16(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret

00000000000003b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b4:	7139                	addi	sp,sp,-64
 3b6:	fc06                	sd	ra,56(sp)
 3b8:	f822                	sd	s0,48(sp)
 3ba:	f426                	sd	s1,40(sp)
 3bc:	f04a                	sd	s2,32(sp)
 3be:	ec4e                	sd	s3,24(sp)
 3c0:	0080                	addi	s0,sp,64
 3c2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c4:	c299                	beqz	a3,3ca <printint+0x16>
 3c6:	0605ce63          	bltz	a1,442 <printint+0x8e>
  neg = 0;
 3ca:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3cc:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3d0:	869a                	mv	a3,t1
  i = 0;
 3d2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3d4:	00000817          	auipc	a6,0x0
 3d8:	56480813          	addi	a6,a6,1380 # 938 <digits>
 3dc:	88be                	mv	a7,a5
 3de:	0017851b          	addiw	a0,a5,1
 3e2:	87aa                	mv	a5,a0
 3e4:	02c5f73b          	remuw	a4,a1,a2
 3e8:	1702                	slli	a4,a4,0x20
 3ea:	9301                	srli	a4,a4,0x20
 3ec:	9742                	add	a4,a4,a6
 3ee:	00074703          	lbu	a4,0(a4)
 3f2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3f6:	872e                	mv	a4,a1
 3f8:	02c5d5bb          	divuw	a1,a1,a2
 3fc:	0685                	addi	a3,a3,1
 3fe:	fcc77fe3          	bgeu	a4,a2,3dc <printint+0x28>
  if(neg)
 402:	000e0c63          	beqz	t3,41a <printint+0x66>
    buf[i++] = '-';
 406:	fd050793          	addi	a5,a0,-48
 40a:	00878533          	add	a0,a5,s0
 40e:	02d00793          	li	a5,45
 412:	fef50823          	sb	a5,-16(a0)
 416:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 41a:	fff7899b          	addiw	s3,a5,-1
 41e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 422:	fff4c583          	lbu	a1,-1(s1)
 426:	854a                	mv	a0,s2
 428:	f6fff0ef          	jal	396 <putc>
  while(--i >= 0)
 42c:	39fd                	addiw	s3,s3,-1
 42e:	14fd                	addi	s1,s1,-1
 430:	fe09d9e3          	bgez	s3,422 <printint+0x6e>
}
 434:	70e2                	ld	ra,56(sp)
 436:	7442                	ld	s0,48(sp)
 438:	74a2                	ld	s1,40(sp)
 43a:	7902                	ld	s2,32(sp)
 43c:	69e2                	ld	s3,24(sp)
 43e:	6121                	addi	sp,sp,64
 440:	8082                	ret
    x = -xx;
 442:	40b005bb          	negw	a1,a1
    neg = 1;
 446:	4e05                	li	t3,1
    x = -xx;
 448:	b751                	j	3cc <printint+0x18>

000000000000044a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44a:	711d                	addi	sp,sp,-96
 44c:	ec86                	sd	ra,88(sp)
 44e:	e8a2                	sd	s0,80(sp)
 450:	e4a6                	sd	s1,72(sp)
 452:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 454:	0005c483          	lbu	s1,0(a1)
 458:	26048663          	beqz	s1,6c4 <vprintf+0x27a>
 45c:	e0ca                	sd	s2,64(sp)
 45e:	fc4e                	sd	s3,56(sp)
 460:	f852                	sd	s4,48(sp)
 462:	f456                	sd	s5,40(sp)
 464:	f05a                	sd	s6,32(sp)
 466:	ec5e                	sd	s7,24(sp)
 468:	e862                	sd	s8,16(sp)
 46a:	e466                	sd	s9,8(sp)
 46c:	8b2a                	mv	s6,a0
 46e:	8a2e                	mv	s4,a1
 470:	8bb2                	mv	s7,a2
  state = 0;
 472:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 474:	4901                	li	s2,0
 476:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 478:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 47c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 480:	06c00c93          	li	s9,108
 484:	a00d                	j	4a6 <vprintf+0x5c>
        putc(fd, c0);
 486:	85a6                	mv	a1,s1
 488:	855a                	mv	a0,s6
 48a:	f0dff0ef          	jal	396 <putc>
 48e:	a019                	j	494 <vprintf+0x4a>
    } else if(state == '%'){
 490:	03598363          	beq	s3,s5,4b6 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 494:	0019079b          	addiw	a5,s2,1
 498:	893e                	mv	s2,a5
 49a:	873e                	mv	a4,a5
 49c:	97d2                	add	a5,a5,s4
 49e:	0007c483          	lbu	s1,0(a5)
 4a2:	20048963          	beqz	s1,6b4 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4a6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4aa:	fe0993e3          	bnez	s3,490 <vprintf+0x46>
      if(c0 == '%'){
 4ae:	fd579ce3          	bne	a5,s5,486 <vprintf+0x3c>
        state = '%';
 4b2:	89be                	mv	s3,a5
 4b4:	b7c5                	j	494 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4b6:	00ea06b3          	add	a3,s4,a4
 4ba:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4be:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4c0:	c681                	beqz	a3,4c8 <vprintf+0x7e>
 4c2:	9752                	add	a4,a4,s4
 4c4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4c8:	03878e63          	beq	a5,s8,504 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4cc:	05978863          	beq	a5,s9,51c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4d0:	07500713          	li	a4,117
 4d4:	0ee78263          	beq	a5,a4,5b8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4d8:	07800713          	li	a4,120
 4dc:	12e78463          	beq	a5,a4,604 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4e0:	07000713          	li	a4,112
 4e4:	14e78963          	beq	a5,a4,636 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4e8:	07300713          	li	a4,115
 4ec:	18e78863          	beq	a5,a4,67c <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4f0:	02500713          	li	a4,37
 4f4:	04e79463          	bne	a5,a4,53c <vprintf+0xf2>
        putc(fd, '%');
 4f8:	85ba                	mv	a1,a4
 4fa:	855a                	mv	a0,s6
 4fc:	e9bff0ef          	jal	396 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 500:	4981                	li	s3,0
 502:	bf49                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 504:	008b8493          	addi	s1,s7,8
 508:	4685                	li	a3,1
 50a:	4629                	li	a2,10
 50c:	000ba583          	lw	a1,0(s7)
 510:	855a                	mv	a0,s6
 512:	ea3ff0ef          	jal	3b4 <printint>
 516:	8ba6                	mv	s7,s1
      state = 0;
 518:	4981                	li	s3,0
 51a:	bfad                	j	494 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 51c:	06400793          	li	a5,100
 520:	02f68963          	beq	a3,a5,552 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 524:	06c00793          	li	a5,108
 528:	04f68263          	beq	a3,a5,56c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 52c:	07500793          	li	a5,117
 530:	0af68063          	beq	a3,a5,5d0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 534:	07800793          	li	a5,120
 538:	0ef68263          	beq	a3,a5,61c <vprintf+0x1d2>
        putc(fd, '%');
 53c:	02500593          	li	a1,37
 540:	855a                	mv	a0,s6
 542:	e55ff0ef          	jal	396 <putc>
        putc(fd, c0);
 546:	85a6                	mv	a1,s1
 548:	855a                	mv	a0,s6
 54a:	e4dff0ef          	jal	396 <putc>
      state = 0;
 54e:	4981                	li	s3,0
 550:	b791                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 552:	008b8493          	addi	s1,s7,8
 556:	4685                	li	a3,1
 558:	4629                	li	a2,10
 55a:	000ba583          	lw	a1,0(s7)
 55e:	855a                	mv	a0,s6
 560:	e55ff0ef          	jal	3b4 <printint>
        i += 1;
 564:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 566:	8ba6                	mv	s7,s1
      state = 0;
 568:	4981                	li	s3,0
        i += 1;
 56a:	b72d                	j	494 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56c:	06400793          	li	a5,100
 570:	02f60763          	beq	a2,a5,59e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 574:	07500793          	li	a5,117
 578:	06f60963          	beq	a2,a5,5ea <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 57c:	07800793          	li	a5,120
 580:	faf61ee3          	bne	a2,a5,53c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 584:	008b8493          	addi	s1,s7,8
 588:	4681                	li	a3,0
 58a:	4641                	li	a2,16
 58c:	000ba583          	lw	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	e23ff0ef          	jal	3b4 <printint>
        i += 2;
 596:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 598:	8ba6                	mv	s7,s1
      state = 0;
 59a:	4981                	li	s3,0
        i += 2;
 59c:	bde5                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	008b8493          	addi	s1,s7,8
 5a2:	4685                	li	a3,1
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	e09ff0ef          	jal	3b4 <printint>
        i += 2;
 5b0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	8ba6                	mv	s7,s1
      state = 0;
 5b4:	4981                	li	s3,0
        i += 2;
 5b6:	bdf9                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	defff0ef          	jal	3b4 <printint>
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b5d9                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	dd7ff0ef          	jal	3b4 <printint>
        i += 1;
 5e2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	8ba6                	mv	s7,s1
      state = 0;
 5e6:	4981                	li	s3,0
        i += 1;
 5e8:	b575                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	008b8493          	addi	s1,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4629                	li	a2,10
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	dbdff0ef          	jal	3b4 <printint>
        i += 2;
 5fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fe:	8ba6                	mv	s7,s1
      state = 0;
 600:	4981                	li	s3,0
        i += 2;
 602:	bd49                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 604:	008b8493          	addi	s1,s7,8
 608:	4681                	li	a3,0
 60a:	4641                	li	a2,16
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	da3ff0ef          	jal	3b4 <printint>
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
 61a:	bdad                	j	494 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	d8bff0ef          	jal	3b4 <printint>
        i += 1;
 62e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
        i += 1;
 634:	b585                	j	494 <vprintf+0x4a>
 636:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 638:	008b8d13          	addi	s10,s7,8
 63c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 640:	03000593          	li	a1,48
 644:	855a                	mv	a0,s6
 646:	d51ff0ef          	jal	396 <putc>
  putc(fd, 'x');
 64a:	07800593          	li	a1,120
 64e:	855a                	mv	a0,s6
 650:	d47ff0ef          	jal	396 <putc>
 654:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 656:	00000b97          	auipc	s7,0x0
 65a:	2e2b8b93          	addi	s7,s7,738 # 938 <digits>
 65e:	03c9d793          	srli	a5,s3,0x3c
 662:	97de                	add	a5,a5,s7
 664:	0007c583          	lbu	a1,0(a5)
 668:	855a                	mv	a0,s6
 66a:	d2dff0ef          	jal	396 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 66e:	0992                	slli	s3,s3,0x4
 670:	34fd                	addiw	s1,s1,-1
 672:	f4f5                	bnez	s1,65e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 674:	8bea                	mv	s7,s10
      state = 0;
 676:	4981                	li	s3,0
 678:	6d02                	ld	s10,0(sp)
 67a:	bd29                	j	494 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 67c:	008b8993          	addi	s3,s7,8
 680:	000bb483          	ld	s1,0(s7)
 684:	cc91                	beqz	s1,6a0 <vprintf+0x256>
        for(; *s; s++)
 686:	0004c583          	lbu	a1,0(s1)
 68a:	c195                	beqz	a1,6ae <vprintf+0x264>
          putc(fd, *s);
 68c:	855a                	mv	a0,s6
 68e:	d09ff0ef          	jal	396 <putc>
        for(; *s; s++)
 692:	0485                	addi	s1,s1,1
 694:	0004c583          	lbu	a1,0(s1)
 698:	f9f5                	bnez	a1,68c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 69a:	8bce                	mv	s7,s3
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bbdd                	j	494 <vprintf+0x4a>
          s = "(null)";
 6a0:	00000497          	auipc	s1,0x0
 6a4:	29048493          	addi	s1,s1,656 # 930 <malloc+0x180>
        for(; *s; s++)
 6a8:	02800593          	li	a1,40
 6ac:	b7c5                	j	68c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6ae:	8bce                	mv	s7,s3
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b3cd                	j	494 <vprintf+0x4a>
 6b4:	6906                	ld	s2,64(sp)
 6b6:	79e2                	ld	s3,56(sp)
 6b8:	7a42                	ld	s4,48(sp)
 6ba:	7aa2                	ld	s5,40(sp)
 6bc:	7b02                	ld	s6,32(sp)
 6be:	6be2                	ld	s7,24(sp)
 6c0:	6c42                	ld	s8,16(sp)
 6c2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6c4:	60e6                	ld	ra,88(sp)
 6c6:	6446                	ld	s0,80(sp)
 6c8:	64a6                	ld	s1,72(sp)
 6ca:	6125                	addi	sp,sp,96
 6cc:	8082                	ret

00000000000006ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ce:	715d                	addi	sp,sp,-80
 6d0:	ec06                	sd	ra,24(sp)
 6d2:	e822                	sd	s0,16(sp)
 6d4:	1000                	addi	s0,sp,32
 6d6:	e010                	sd	a2,0(s0)
 6d8:	e414                	sd	a3,8(s0)
 6da:	e818                	sd	a4,16(s0)
 6dc:	ec1c                	sd	a5,24(s0)
 6de:	03043023          	sd	a6,32(s0)
 6e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e6:	8622                	mv	a2,s0
 6e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ec:	d5fff0ef          	jal	44a <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6161                	addi	sp,sp,80
 6f6:	8082                	ret

00000000000006f8 <printf>:

void
printf(const char *fmt, ...)
{
 6f8:	711d                	addi	sp,sp,-96
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e40c                	sd	a1,8(s0)
 702:	e810                	sd	a2,16(s0)
 704:	ec14                	sd	a3,24(s0)
 706:	f018                	sd	a4,32(s0)
 708:	f41c                	sd	a5,40(s0)
 70a:	03043823          	sd	a6,48(s0)
 70e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 712:	00840613          	addi	a2,s0,8
 716:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71a:	85aa                	mv	a1,a0
 71c:	4505                	li	a0,1
 71e:	d2dff0ef          	jal	44a <vprintf>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6125                	addi	sp,sp,96
 728:	8082                	ret

000000000000072a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72a:	1141                	addi	sp,sp,-16
 72c:	e406                	sd	ra,8(sp)
 72e:	e022                	sd	s0,0(sp)
 730:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 732:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	00001797          	auipc	a5,0x1
 73a:	8ca7b783          	ld	a5,-1846(a5) # 1000 <freep>
 73e:	a02d                	j	768 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 740:	4618                	lw	a4,8(a2)
 742:	9f2d                	addw	a4,a4,a1
 744:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 748:	6398                	ld	a4,0(a5)
 74a:	6310                	ld	a2,0(a4)
 74c:	a83d                	j	78a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74e:	ff852703          	lw	a4,-8(a0)
 752:	9f31                	addw	a4,a4,a2
 754:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 756:	ff053683          	ld	a3,-16(a0)
 75a:	a091                	j	79e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75c:	6398                	ld	a4,0(a5)
 75e:	00e7e463          	bltu	a5,a4,766 <free+0x3c>
 762:	00e6ea63          	bltu	a3,a4,776 <free+0x4c>
{
 766:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	fed7fae3          	bgeu	a5,a3,75c <free+0x32>
 76c:	6398                	ld	a4,0(a5)
 76e:	00e6e463          	bltu	a3,a4,776 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	fee7eae3          	bltu	a5,a4,766 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 776:	ff852583          	lw	a1,-8(a0)
 77a:	6390                	ld	a2,0(a5)
 77c:	02059813          	slli	a6,a1,0x20
 780:	01c85713          	srli	a4,a6,0x1c
 784:	9736                	add	a4,a4,a3
 786:	fae60de3          	beq	a2,a4,740 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 78e:	4790                	lw	a2,8(a5)
 790:	02061593          	slli	a1,a2,0x20
 794:	01c5d713          	srli	a4,a1,0x1c
 798:	973e                	add	a4,a4,a5
 79a:	fae68ae3          	beq	a3,a4,74e <free+0x24>
    p->s.ptr = bp->s.ptr;
 79e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a0:	00001717          	auipc	a4,0x1
 7a4:	86f73023          	sd	a5,-1952(a4) # 1000 <freep>
}
 7a8:	60a2                	ld	ra,8(sp)
 7aa:	6402                	ld	s0,0(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret

00000000000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	7139                	addi	sp,sp,-64
 7b2:	fc06                	sd	ra,56(sp)
 7b4:	f822                	sd	s0,48(sp)
 7b6:	f04a                	sd	s2,32(sp)
 7b8:	ec4e                	sd	s3,24(sp)
 7ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bc:	02051993          	slli	s3,a0,0x20
 7c0:	0209d993          	srli	s3,s3,0x20
 7c4:	09bd                	addi	s3,s3,15
 7c6:	0049d993          	srli	s3,s3,0x4
 7ca:	2985                	addiw	s3,s3,1
 7cc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ce:	00001517          	auipc	a0,0x1
 7d2:	83253503          	ld	a0,-1998(a0) # 1000 <freep>
 7d6:	c905                	beqz	a0,806 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7da:	4798                	lw	a4,8(a5)
 7dc:	09377663          	bgeu	a4,s3,868 <malloc+0xb8>
 7e0:	f426                	sd	s1,40(sp)
 7e2:	e852                	sd	s4,16(sp)
 7e4:	e456                	sd	s5,8(sp)
 7e6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e8:	8a4e                	mv	s4,s3
 7ea:	6705                	lui	a4,0x1
 7ec:	00e9f363          	bgeu	s3,a4,7f2 <malloc+0x42>
 7f0:	6a05                	lui	s4,0x1
 7f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fa:	00001497          	auipc	s1,0x1
 7fe:	80648493          	addi	s1,s1,-2042 # 1000 <freep>
  if(p == (char*)-1)
 802:	5afd                	li	s5,-1
 804:	a83d                	j	842 <malloc+0x92>
 806:	f426                	sd	s1,40(sp)
 808:	e852                	sd	s4,16(sp)
 80a:	e456                	sd	s5,8(sp)
 80c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 80e:	00001797          	auipc	a5,0x1
 812:	80278793          	addi	a5,a5,-2046 # 1010 <base>
 816:	00000717          	auipc	a4,0x0
 81a:	7ef73523          	sd	a5,2026(a4) # 1000 <freep>
 81e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 820:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 824:	b7d1                	j	7e8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 826:	6398                	ld	a4,0(a5)
 828:	e118                	sd	a4,0(a0)
 82a:	a899                	j	880 <malloc+0xd0>
  hp->s.size = nu;
 82c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 830:	0541                	addi	a0,a0,16
 832:	ef9ff0ef          	jal	72a <free>
  return freep;
 836:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 838:	c125                	beqz	a0,898 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	03277163          	bgeu	a4,s2,860 <malloc+0xb0>
    if(p == freep)
 842:	6098                	ld	a4,0(s1)
 844:	853e                	mv	a0,a5
 846:	fef71ae3          	bne	a4,a5,83a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 84a:	8552                	mv	a0,s4
 84c:	b2bff0ef          	jal	376 <sbrk>
  if(p == (char*)-1)
 850:	fd551ee3          	bne	a0,s5,82c <malloc+0x7c>
        return 0;
 854:	4501                	li	a0,0
 856:	74a2                	ld	s1,40(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
 85e:	a03d                	j	88c <malloc+0xdc>
 860:	74a2                	ld	s1,40(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 868:	fae90fe3          	beq	s2,a4,826 <malloc+0x76>
        p->s.size -= nunits;
 86c:	4137073b          	subw	a4,a4,s3
 870:	c798                	sw	a4,8(a5)
        p += p->s.size;
 872:	02071693          	slli	a3,a4,0x20
 876:	01c6d713          	srli	a4,a3,0x1c
 87a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 880:	00000717          	auipc	a4,0x0
 884:	78a73023          	sd	a0,1920(a4) # 1000 <freep>
      return (void*)(p + 1);
 888:	01078513          	addi	a0,a5,16
  }
}
 88c:	70e2                	ld	ra,56(sp)
 88e:	7442                	ld	s0,48(sp)
 890:	7902                	ld	s2,32(sp)
 892:	69e2                	ld	s3,24(sp)
 894:	6121                	addi	sp,sp,64
 896:	8082                	ret
 898:	74a2                	ld	s1,40(sp)
 89a:	6a42                	ld	s4,16(sp)
 89c:	6aa2                	ld	s5,8(sp)
 89e:	6b02                	ld	s6,0(sp)
 8a0:	b7f5                	j	88c <malloc+0xdc>
