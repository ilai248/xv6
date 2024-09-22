
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	a0278793          	addi	a5,a5,-1534 # a20 <malloc+0x12c>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	9bc50513          	addi	a0,a0,-1604 # 9f0 <malloc+0xfc>
  3c:	00000097          	auipc	ra,0x0
  40:	7fc080e7          	jalr	2044(ra) # 838 <printf>
  memset(data, 'a', sizeof(data));
  44:	20000613          	li	a2,512
  48:	06100593          	li	a1,97
  4c:	dc040513          	addi	a0,s0,-576
  50:	00000097          	auipc	ra,0x0
  54:	164080e7          	jalr	356(ra) # 1b4 <memset>

  for(i = 0; i < 4; i++)
  58:	4481                	li	s1,0
  5a:	4911                	li	s2,4
    if(fork() > 0)
  5c:	00000097          	auipc	ra,0x0
  60:	372080e7          	jalr	882(ra) # 3ce <fork>
  64:	00a04563          	bgtz	a0,6e <main+0x6e>
  for(i = 0; i < 4; i++)
  68:	2485                	addiw	s1,s1,1
  6a:	ff2499e3          	bne	s1,s2,5c <main+0x5c>
      break;

  printf("write %d\n", i);
  6e:	85a6                	mv	a1,s1
  70:	00001517          	auipc	a0,0x1
  74:	99850513          	addi	a0,a0,-1640 # a08 <malloc+0x114>
  78:	00000097          	auipc	ra,0x0
  7c:	7c0080e7          	jalr	1984(ra) # 838 <printf>

  path[8] += i;
  80:	fc844783          	lbu	a5,-56(s0)
  84:	9fa5                	addw	a5,a5,s1
  86:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  8a:	20200593          	li	a1,514
  8e:	fc040513          	addi	a0,s0,-64
  92:	00000097          	auipc	ra,0x0
  96:	384080e7          	jalr	900(ra) # 416 <open>
  9a:	892a                	mv	s2,a0
  9c:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  9e:	dc040a13          	addi	s4,s0,-576
  a2:	20000993          	li	s3,512
  a6:	864e                	mv	a2,s3
  a8:	85d2                	mv	a1,s4
  aa:	854a                	mv	a0,s2
  ac:	00000097          	auipc	ra,0x0
  b0:	34a080e7          	jalr	842(ra) # 3f6 <write>
  for(i = 0; i < 20; i++)
  b4:	34fd                	addiw	s1,s1,-1
  b6:	f8e5                	bnez	s1,a6 <main+0xa6>
  close(fd);
  b8:	854a                	mv	a0,s2
  ba:	00000097          	auipc	ra,0x0
  be:	344080e7          	jalr	836(ra) # 3fe <close>

  printf("read\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	95650513          	addi	a0,a0,-1706 # a18 <malloc+0x124>
  ca:	00000097          	auipc	ra,0x0
  ce:	76e080e7          	jalr	1902(ra) # 838 <printf>

  fd = open(path, O_RDONLY);
  d2:	4581                	li	a1,0
  d4:	fc040513          	addi	a0,s0,-64
  d8:	00000097          	auipc	ra,0x0
  dc:	33e080e7          	jalr	830(ra) # 416 <open>
  e0:	892a                	mv	s2,a0
  e2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e4:	dc040a13          	addi	s4,s0,-576
  e8:	20000993          	li	s3,512
  ec:	864e                	mv	a2,s3
  ee:	85d2                	mv	a1,s4
  f0:	854a                	mv	a0,s2
  f2:	00000097          	auipc	ra,0x0
  f6:	2fc080e7          	jalr	764(ra) # 3ee <read>
  for (i = 0; i < 20; i++)
  fa:	34fd                	addiw	s1,s1,-1
  fc:	f8e5                	bnez	s1,ec <main+0xec>
  close(fd);
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	2fe080e7          	jalr	766(ra) # 3fe <close>

  wait(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2d4080e7          	jalr	724(ra) # 3de <wait>

  exit(0);
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	2c2080e7          	jalr	706(ra) # 3d6 <exit>

000000000000011c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  extern int main();
  main();
 124:	00000097          	auipc	ra,0x0
 128:	edc080e7          	jalr	-292(ra) # 0 <main>
  exit(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	2a8080e7          	jalr	680(ra) # 3d6 <exit>

0000000000000136 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13e:	87aa                	mv	a5,a0
 140:	0585                	addi	a1,a1,1
 142:	0785                	addi	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fb75                	bnez	a4,140 <strcpy+0xa>
    ;
  return os;
}
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x20>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x20>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	60a2                	ld	ra,8(sp)
 180:	6402                	ld	s0,0(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strlen>:

uint
strlen(const char *s)
{
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cf99                	beqz	a5,1b0 <strlen+0x2a>
 194:	0505                	addi	a0,a0,1
 196:	87aa                	mv	a5,a0
 198:	86be                	mv	a3,a5
 19a:	0785                	addi	a5,a5,1
 19c:	fff7c703          	lbu	a4,-1(a5)
 1a0:	ff65                	bnez	a4,198 <strlen+0x12>
 1a2:	40a6853b          	subw	a0,a3,a0
 1a6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a8:	60a2                	ld	ra,8(sp)
 1aa:	6402                	ld	s0,0(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  for(n = 0; s[n]; n++)
 1b0:	4501                	li	a0,0
 1b2:	bfdd                	j	1a8 <strlen+0x22>

00000000000001b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1bc:	ca19                	beqz	a2,1d2 <memset+0x1e>
 1be:	87aa                	mv	a5,a0
 1c0:	1602                	slli	a2,a2,0x20
 1c2:	9201                	srli	a2,a2,0x20
 1c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1cc:	0785                	addi	a5,a5,1
 1ce:	fee79de3          	bne	a5,a4,1c8 <memset+0x14>
  }
  return dst;
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strchr>:

char*
strchr(const char *s, char c)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	cf81                	beqz	a5,1fe <strchr+0x24>
    if(*s == c)
 1e8:	00f58763          	beq	a1,a5,1f6 <strchr+0x1c>
  for(; *s; s++)
 1ec:	0505                	addi	a0,a0,1
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbfd                	bnez	a5,1e8 <strchr+0xe>
      return (char*)s;
  return 0;
 1f4:	4501                	li	a0,0
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  return 0;
 1fe:	4501                	li	a0,0
 200:	bfdd                	j	1f6 <strchr+0x1c>

0000000000000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	7159                	addi	sp,sp,-112
 204:	f486                	sd	ra,104(sp)
 206:	f0a2                	sd	s0,96(sp)
 208:	eca6                	sd	s1,88(sp)
 20a:	e8ca                	sd	s2,80(sp)
 20c:	e4ce                	sd	s3,72(sp)
 20e:	e0d2                	sd	s4,64(sp)
 210:	fc56                	sd	s5,56(sp)
 212:	f85a                	sd	s6,48(sp)
 214:	f45e                	sd	s7,40(sp)
 216:	f062                	sd	s8,32(sp)
 218:	ec66                	sd	s9,24(sp)
 21a:	e86a                	sd	s10,16(sp)
 21c:	1880                	addi	s0,sp,112
 21e:	8caa                	mv	s9,a0
 220:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	892a                	mv	s2,a0
 224:	4481                	li	s1,0
    cc = read(0, &c, 1);
 226:	f9f40b13          	addi	s6,s0,-97
 22a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 22c:	4ba9                	li	s7,10
 22e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 230:	8d26                	mv	s10,s1
 232:	0014899b          	addiw	s3,s1,1
 236:	84ce                	mv	s1,s3
 238:	0349d763          	bge	s3,s4,266 <gets+0x64>
    cc = read(0, &c, 1);
 23c:	8656                	mv	a2,s5
 23e:	85da                	mv	a1,s6
 240:	4501                	li	a0,0
 242:	00000097          	auipc	ra,0x0
 246:	1ac080e7          	jalr	428(ra) # 3ee <read>
    if(cc < 1)
 24a:	00a05e63          	blez	a0,266 <gets+0x64>
    buf[i++] = c;
 24e:	f9f44783          	lbu	a5,-97(s0)
 252:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 256:	01778763          	beq	a5,s7,264 <gets+0x62>
 25a:	0905                	addi	s2,s2,1
 25c:	fd879ae3          	bne	a5,s8,230 <gets+0x2e>
    buf[i++] = c;
 260:	8d4e                	mv	s10,s3
 262:	a011                	j	266 <gets+0x64>
 264:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 266:	9d66                	add	s10,s10,s9
 268:	000d0023          	sb	zero,0(s10)
  return buf;
}
 26c:	8566                	mv	a0,s9
 26e:	70a6                	ld	ra,104(sp)
 270:	7406                	ld	s0,96(sp)
 272:	64e6                	ld	s1,88(sp)
 274:	6946                	ld	s2,80(sp)
 276:	69a6                	ld	s3,72(sp)
 278:	6a06                	ld	s4,64(sp)
 27a:	7ae2                	ld	s5,56(sp)
 27c:	7b42                	ld	s6,48(sp)
 27e:	7ba2                	ld	s7,40(sp)
 280:	7c02                	ld	s8,32(sp)
 282:	6ce2                	ld	s9,24(sp)
 284:	6d42                	ld	s10,16(sp)
 286:	6165                	addi	sp,sp,112
 288:	8082                	ret

000000000000028a <stat>:

int
stat(const char *n, struct stat *st)
{
 28a:	1101                	addi	sp,sp,-32
 28c:	ec06                	sd	ra,24(sp)
 28e:	e822                	sd	s0,16(sp)
 290:	e04a                	sd	s2,0(sp)
 292:	1000                	addi	s0,sp,32
 294:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	4581                	li	a1,0
 298:	00000097          	auipc	ra,0x0
 29c:	17e080e7          	jalr	382(ra) # 416 <open>
  if(fd < 0)
 2a0:	02054663          	bltz	a0,2cc <stat+0x42>
 2a4:	e426                	sd	s1,8(sp)
 2a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a8:	85ca                	mv	a1,s2
 2aa:	00000097          	auipc	ra,0x0
 2ae:	184080e7          	jalr	388(ra) # 42e <fstat>
 2b2:	892a                	mv	s2,a0
  close(fd);
 2b4:	8526                	mv	a0,s1
 2b6:	00000097          	auipc	ra,0x0
 2ba:	148080e7          	jalr	328(ra) # 3fe <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x36>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d8:	00054683          	lbu	a3,0(a0)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	4625                	li	a2,9
 2e6:	02f66963          	bltu	a2,a5,318 <atoi+0x48>
 2ea:	872a                	mv	a4,a0
  n = 0;
 2ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ee:	0705                	addi	a4,a4,1
 2f0:	0025179b          	slliw	a5,a0,0x2
 2f4:	9fa9                	addw	a5,a5,a0
 2f6:	0017979b          	slliw	a5,a5,0x1
 2fa:	9fb5                	addw	a5,a5,a3
 2fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 300:	00074683          	lbu	a3,0(a4)
 304:	fd06879b          	addiw	a5,a3,-48
 308:	0ff7f793          	zext.b	a5,a5
 30c:	fef671e3          	bgeu	a2,a5,2ee <atoi+0x1e>
  return n;
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  n = 0;
 318:	4501                	li	a0,0
 31a:	bfdd                	j	310 <atoi+0x40>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 324:	02b57563          	bgeu	a0,a1,34e <memmove+0x32>
    while(n-- > 0)
 328:	00c05f63          	blez	a2,346 <memmove+0x2a>
 32c:	1602                	slli	a2,a2,0x20
 32e:	9201                	srli	a2,a2,0x20
 330:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 334:	872a                	mv	a4,a0
      *dst++ = *src++;
 336:	0585                	addi	a1,a1,1
 338:	0705                	addi	a4,a4,1
 33a:	fff5c683          	lbu	a3,-1(a1)
 33e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
    dst += n;
 34e:	00c50733          	add	a4,a0,a2
    src += n;
 352:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 354:	fec059e3          	blez	a2,346 <memmove+0x2a>
 358:	fff6079b          	addiw	a5,a2,-1
 35c:	1782                	slli	a5,a5,0x20
 35e:	9381                	srli	a5,a5,0x20
 360:	fff7c793          	not	a5,a5
 364:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 366:	15fd                	addi	a1,a1,-1
 368:	177d                	addi	a4,a4,-1
 36a:	0005c683          	lbu	a3,0(a1)
 36e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 372:	fef71ae3          	bne	a4,a5,366 <memmove+0x4a>
 376:	bfc1                	j	346 <memmove+0x2a>

0000000000000378 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 380:	ca0d                	beqz	a2,3b2 <memcmp+0x3a>
 382:	fff6069b          	addiw	a3,a2,-1
 386:	1682                	slli	a3,a3,0x20
 388:	9281                	srli	a3,a3,0x20
 38a:	0685                	addi	a3,a3,1
 38c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 38e:	00054783          	lbu	a5,0(a0)
 392:	0005c703          	lbu	a4,0(a1)
 396:	00e79863          	bne	a5,a4,3a6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 39a:	0505                	addi	a0,a0,1
    p2++;
 39c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39e:	fed518e3          	bne	a0,a3,38e <memcmp+0x16>
  }
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	a019                	j	3aa <memcmp+0x32>
      return *p1 - *p2;
 3a6:	40e7853b          	subw	a0,a5,a4
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfdd                	j	3aa <memcmp+0x32>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	00000097          	auipc	ra,0x0
 3c2:	f5e080e7          	jalr	-162(ra) # 31c <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d6:	4889                	li	a7,2
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <wait>:
.global wait
wait:
 li a7, SYS_wait
 3de:	488d                	li	a7,3
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e6:	4891                	li	a7,4
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <read>:
.global read
read:
 li a7, SYS_read
 3ee:	4895                	li	a7,5
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <close>:
.global close
close:
 li a7, SYS_close
 3fe:	48d5                	li	a7,21
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <kill>:
.global kill
kill:
 li a7, SYS_kill
 406:	4899                	li	a7,6
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exec>:
.global exec
exec:
 li a7, SYS_exec
 40e:	489d                	li	a7,7
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <open>:
.global open
open:
 li a7, SYS_open
 416:	48bd                	li	a7,15
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41e:	48c5                	li	a7,17
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c9                	li	a7,18
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42e:	48a1                	li	a7,8
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <link>:
.global link
link:
 li a7, SYS_link
 436:	48cd                	li	a7,19
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43e:	48d1                	li	a7,20
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 446:	48a5                	li	a7,9
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <dup>:
.global dup
dup:
 li a7, SYS_dup
 44e:	48a9                	li	a7,10
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 456:	48ad                	li	a7,11
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45e:	48b1                	li	a7,12
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 466:	48b5                	li	a7,13
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46e:	48b9                	li	a7,14
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <trace>:
.global trace
trace:
 li a7, SYS_trace
 476:	48d9                	li	a7,22
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 47e:	48dd                	li	a7,23
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 486:	1101                	addi	sp,sp,-32
 488:	ec06                	sd	ra,24(sp)
 48a:	e822                	sd	s0,16(sp)
 48c:	1000                	addi	s0,sp,32
 48e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 492:	4605                	li	a2,1
 494:	fef40593          	addi	a1,s0,-17
 498:	00000097          	auipc	ra,0x0
 49c:	f5e080e7          	jalr	-162(ra) # 3f6 <write>
}
 4a0:	60e2                	ld	ra,24(sp)
 4a2:	6442                	ld	s0,16(sp)
 4a4:	6105                	addi	sp,sp,32
 4a6:	8082                	ret

00000000000004a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a8:	7139                	addi	sp,sp,-64
 4aa:	fc06                	sd	ra,56(sp)
 4ac:	f822                	sd	s0,48(sp)
 4ae:	f426                	sd	s1,40(sp)
 4b0:	f04a                	sd	s2,32(sp)
 4b2:	ec4e                	sd	s3,24(sp)
 4b4:	0080                	addi	s0,sp,64
 4b6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b8:	c299                	beqz	a3,4be <printint+0x16>
 4ba:	0805c063          	bltz	a1,53a <printint+0x92>
  neg = 0;
 4be:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4c0:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4c4:	869a                	mv	a3,t1
  i = 0;
 4c6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4c8:	00000817          	auipc	a6,0x0
 4cc:	57080813          	addi	a6,a6,1392 # a38 <digits>
 4d0:	88be                	mv	a7,a5
 4d2:	0017851b          	addiw	a0,a5,1
 4d6:	87aa                	mv	a5,a0
 4d8:	02c5f73b          	remuw	a4,a1,a2
 4dc:	1702                	slli	a4,a4,0x20
 4de:	9301                	srli	a4,a4,0x20
 4e0:	9742                	add	a4,a4,a6
 4e2:	00074703          	lbu	a4,0(a4)
 4e6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4ea:	872e                	mv	a4,a1
 4ec:	02c5d5bb          	divuw	a1,a1,a2
 4f0:	0685                	addi	a3,a3,1
 4f2:	fcc77fe3          	bgeu	a4,a2,4d0 <printint+0x28>
  if(neg)
 4f6:	000e0c63          	beqz	t3,50e <printint+0x66>
    buf[i++] = '-';
 4fa:	fd050793          	addi	a5,a0,-48
 4fe:	00878533          	add	a0,a5,s0
 502:	02d00793          	li	a5,45
 506:	fef50823          	sb	a5,-16(a0)
 50a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 50e:	fff7899b          	addiw	s3,a5,-1
 512:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 516:	fff4c583          	lbu	a1,-1(s1)
 51a:	854a                	mv	a0,s2
 51c:	00000097          	auipc	ra,0x0
 520:	f6a080e7          	jalr	-150(ra) # 486 <putc>
  while(--i >= 0)
 524:	39fd                	addiw	s3,s3,-1
 526:	14fd                	addi	s1,s1,-1
 528:	fe09d7e3          	bgez	s3,516 <printint+0x6e>
}
 52c:	70e2                	ld	ra,56(sp)
 52e:	7442                	ld	s0,48(sp)
 530:	74a2                	ld	s1,40(sp)
 532:	7902                	ld	s2,32(sp)
 534:	69e2                	ld	s3,24(sp)
 536:	6121                	addi	sp,sp,64
 538:	8082                	ret
    x = -xx;
 53a:	40b005bb          	negw	a1,a1
    neg = 1;
 53e:	4e05                	li	t3,1
    x = -xx;
 540:	b741                	j	4c0 <printint+0x18>

0000000000000542 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 542:	711d                	addi	sp,sp,-96
 544:	ec86                	sd	ra,88(sp)
 546:	e8a2                	sd	s0,80(sp)
 548:	e4a6                	sd	s1,72(sp)
 54a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54c:	0005c483          	lbu	s1,0(a1)
 550:	2a048863          	beqz	s1,800 <vprintf+0x2be>
 554:	e0ca                	sd	s2,64(sp)
 556:	fc4e                	sd	s3,56(sp)
 558:	f852                	sd	s4,48(sp)
 55a:	f456                	sd	s5,40(sp)
 55c:	f05a                	sd	s6,32(sp)
 55e:	ec5e                	sd	s7,24(sp)
 560:	e862                	sd	s8,16(sp)
 562:	e466                	sd	s9,8(sp)
 564:	8b2a                	mv	s6,a0
 566:	8a2e                	mv	s4,a1
 568:	8bb2                	mv	s7,a2
  state = 0;
 56a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 56c:	4901                	li	s2,0
 56e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 570:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 574:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 578:	06c00c93          	li	s9,108
 57c:	a01d                	j	5a2 <vprintf+0x60>
        putc(fd, c0);
 57e:	85a6                	mv	a1,s1
 580:	855a                	mv	a0,s6
 582:	00000097          	auipc	ra,0x0
 586:	f04080e7          	jalr	-252(ra) # 486 <putc>
 58a:	a019                	j	590 <vprintf+0x4e>
    } else if(state == '%'){
 58c:	03598363          	beq	s3,s5,5b2 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 590:	0019079b          	addiw	a5,s2,1
 594:	893e                	mv	s2,a5
 596:	873e                	mv	a4,a5
 598:	97d2                	add	a5,a5,s4
 59a:	0007c483          	lbu	s1,0(a5)
 59e:	24048963          	beqz	s1,7f0 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 5a2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5a6:	fe0993e3          	bnez	s3,58c <vprintf+0x4a>
      if(c0 == '%'){
 5aa:	fd579ae3          	bne	a5,s5,57e <vprintf+0x3c>
        state = '%';
 5ae:	89be                	mv	s3,a5
 5b0:	b7c5                	j	590 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 5b2:	00ea06b3          	add	a3,s4,a4
 5b6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ba:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5bc:	c681                	beqz	a3,5c4 <vprintf+0x82>
 5be:	9752                	add	a4,a4,s4
 5c0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5c4:	05878063          	beq	a5,s8,604 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5c8:	05978c63          	beq	a5,s9,620 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5cc:	07500713          	li	a4,117
 5d0:	10e78063          	beq	a5,a4,6d0 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5d4:	07800713          	li	a4,120
 5d8:	14e78863          	beq	a5,a4,728 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5dc:	07000713          	li	a4,112
 5e0:	18e78163          	beq	a5,a4,762 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5e4:	07300713          	li	a4,115
 5e8:	1ce78663          	beq	a5,a4,7b4 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ec:	02500713          	li	a4,37
 5f0:	04e79863          	bne	a5,a4,640 <vprintf+0xfe>
        putc(fd, '%');
 5f4:	85ba                	mv	a1,a4
 5f6:	855a                	mv	a0,s6
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e8e080e7          	jalr	-370(ra) # 486 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 600:	4981                	li	s3,0
 602:	b779                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 604:	008b8493          	addi	s1,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	00000097          	auipc	ra,0x0
 616:	e96080e7          	jalr	-362(ra) # 4a8 <printint>
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bf8d                	j	590 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 620:	06400793          	li	a5,100
 624:	02f68d63          	beq	a3,a5,65e <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 628:	06c00793          	li	a5,108
 62c:	04f68863          	beq	a3,a5,67c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 630:	07500793          	li	a5,117
 634:	0af68c63          	beq	a3,a5,6ec <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 638:	07800793          	li	a5,120
 63c:	10f68463          	beq	a3,a5,744 <vprintf+0x202>
        putc(fd, '%');
 640:	02500593          	li	a1,37
 644:	855a                	mv	a0,s6
 646:	00000097          	auipc	ra,0x0
 64a:	e40080e7          	jalr	-448(ra) # 486 <putc>
        putc(fd, c0);
 64e:	85a6                	mv	a1,s1
 650:	855a                	mv	a0,s6
 652:	00000097          	auipc	ra,0x0
 656:	e34080e7          	jalr	-460(ra) # 486 <putc>
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bf15                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	00000097          	auipc	ra,0x0
 670:	e3c080e7          	jalr	-452(ra) # 4a8 <printint>
        i += 1;
 674:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
        i += 1;
 67a:	bf19                	j	590 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 67c:	06400793          	li	a5,100
 680:	02f60963          	beq	a2,a5,6b2 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 684:	07500793          	li	a5,117
 688:	08f60163          	beq	a2,a5,70a <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 68c:	07800793          	li	a5,120
 690:	faf618e3          	bne	a2,a5,640 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	008b8493          	addi	s1,s7,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000ba583          	lw	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e06080e7          	jalr	-506(ra) # 4a8 <printint>
        i += 2;
 6aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ac:	8ba6                	mv	s7,s1
      state = 0;
 6ae:	4981                	li	s3,0
        i += 2;
 6b0:	b5c5                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b2:	008b8493          	addi	s1,s7,8
 6b6:	4685                	li	a3,1
 6b8:	4629                	li	a2,10
 6ba:	000ba583          	lw	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	00000097          	auipc	ra,0x0
 6c4:	de8080e7          	jalr	-536(ra) # 4a8 <printint>
        i += 2;
 6c8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ca:	8ba6                	mv	s7,s1
      state = 0;
 6cc:	4981                	li	s3,0
        i += 2;
 6ce:	b5c9                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 6d0:	008b8493          	addi	s1,s7,8
 6d4:	4681                	li	a3,0
 6d6:	4629                	li	a2,10
 6d8:	000ba583          	lw	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	00000097          	auipc	ra,0x0
 6e2:	dca080e7          	jalr	-566(ra) # 4a8 <printint>
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b55d                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4629                	li	a2,10
 6f4:	000ba583          	lw	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	00000097          	auipc	ra,0x0
 6fe:	dae080e7          	jalr	-594(ra) # 4a8 <printint>
        i += 1;
 702:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 704:	8ba6                	mv	s7,s1
      state = 0;
 706:	4981                	li	s3,0
        i += 1;
 708:	b561                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	008b8493          	addi	s1,s7,8
 70e:	4681                	li	a3,0
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	00000097          	auipc	ra,0x0
 71c:	d90080e7          	jalr	-624(ra) # 4a8 <printint>
        i += 2;
 720:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	8ba6                	mv	s7,s1
      state = 0;
 724:	4981                	li	s3,0
        i += 2;
 726:	b5ad                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 728:	008b8493          	addi	s1,s7,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000ba583          	lw	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	00000097          	auipc	ra,0x0
 73a:	d72080e7          	jalr	-654(ra) # 4a8 <printint>
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
 742:	b5b9                	j	590 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4641                	li	a2,16
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	00000097          	auipc	ra,0x0
 756:	d56080e7          	jalr	-682(ra) # 4a8 <printint>
        i += 1;
 75a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 75c:	8ba6                	mv	s7,s1
      state = 0;
 75e:	4981                	li	s3,0
        i += 1;
 760:	bd05                	j	590 <vprintf+0x4e>
 762:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 764:	008b8d13          	addi	s10,s7,8
 768:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 76c:	03000593          	li	a1,48
 770:	855a                	mv	a0,s6
 772:	00000097          	auipc	ra,0x0
 776:	d14080e7          	jalr	-748(ra) # 486 <putc>
  putc(fd, 'x');
 77a:	07800593          	li	a1,120
 77e:	855a                	mv	a0,s6
 780:	00000097          	auipc	ra,0x0
 784:	d06080e7          	jalr	-762(ra) # 486 <putc>
 788:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78a:	00000b97          	auipc	s7,0x0
 78e:	2aeb8b93          	addi	s7,s7,686 # a38 <digits>
 792:	03c9d793          	srli	a5,s3,0x3c
 796:	97de                	add	a5,a5,s7
 798:	0007c583          	lbu	a1,0(a5)
 79c:	855a                	mv	a0,s6
 79e:	00000097          	auipc	ra,0x0
 7a2:	ce8080e7          	jalr	-792(ra) # 486 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a6:	0992                	slli	s3,s3,0x4
 7a8:	34fd                	addiw	s1,s1,-1
 7aa:	f4e5                	bnez	s1,792 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 7ac:	8bea                	mv	s7,s10
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	6d02                	ld	s10,0(sp)
 7b2:	bbf9                	j	590 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 7b4:	008b8993          	addi	s3,s7,8
 7b8:	000bb483          	ld	s1,0(s7)
 7bc:	c085                	beqz	s1,7dc <vprintf+0x29a>
        for(; *s; s++)
 7be:	0004c583          	lbu	a1,0(s1)
 7c2:	c585                	beqz	a1,7ea <vprintf+0x2a8>
          putc(fd, *s);
 7c4:	855a                	mv	a0,s6
 7c6:	00000097          	auipc	ra,0x0
 7ca:	cc0080e7          	jalr	-832(ra) # 486 <putc>
        for(; *s; s++)
 7ce:	0485                	addi	s1,s1,1
 7d0:	0004c583          	lbu	a1,0(s1)
 7d4:	f9e5                	bnez	a1,7c4 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 7d6:	8bce                	mv	s7,s3
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	bb5d                	j	590 <vprintf+0x4e>
          s = "(null)";
 7dc:	00000497          	auipc	s1,0x0
 7e0:	25448493          	addi	s1,s1,596 # a30 <malloc+0x13c>
        for(; *s; s++)
 7e4:	02800593          	li	a1,40
 7e8:	bff1                	j	7c4 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 7ea:	8bce                	mv	s7,s3
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b34d                	j	590 <vprintf+0x4e>
 7f0:	6906                	ld	s2,64(sp)
 7f2:	79e2                	ld	s3,56(sp)
 7f4:	7a42                	ld	s4,48(sp)
 7f6:	7aa2                	ld	s5,40(sp)
 7f8:	7b02                	ld	s6,32(sp)
 7fa:	6be2                	ld	s7,24(sp)
 7fc:	6c42                	ld	s8,16(sp)
 7fe:	6ca2                	ld	s9,8(sp)
    }
  }
}
 800:	60e6                	ld	ra,88(sp)
 802:	6446                	ld	s0,80(sp)
 804:	64a6                	ld	s1,72(sp)
 806:	6125                	addi	sp,sp,96
 808:	8082                	ret

000000000000080a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 80a:	715d                	addi	sp,sp,-80
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e010                	sd	a2,0(s0)
 814:	e414                	sd	a3,8(s0)
 816:	e818                	sd	a4,16(s0)
 818:	ec1c                	sd	a5,24(s0)
 81a:	03043023          	sd	a6,32(s0)
 81e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 822:	8622                	mv	a2,s0
 824:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 828:	00000097          	auipc	ra,0x0
 82c:	d1a080e7          	jalr	-742(ra) # 542 <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6161                	addi	sp,sp,80
 836:	8082                	ret

0000000000000838 <printf>:

void
printf(const char *fmt, ...)
{
 838:	711d                	addi	sp,sp,-96
 83a:	ec06                	sd	ra,24(sp)
 83c:	e822                	sd	s0,16(sp)
 83e:	1000                	addi	s0,sp,32
 840:	e40c                	sd	a1,8(s0)
 842:	e810                	sd	a2,16(s0)
 844:	ec14                	sd	a3,24(s0)
 846:	f018                	sd	a4,32(s0)
 848:	f41c                	sd	a5,40(s0)
 84a:	03043823          	sd	a6,48(s0)
 84e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 852:	00840613          	addi	a2,s0,8
 856:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85a:	85aa                	mv	a1,a0
 85c:	4505                	li	a0,1
 85e:	00000097          	auipc	ra,0x0
 862:	ce4080e7          	jalr	-796(ra) # 542 <vprintf>
}
 866:	60e2                	ld	ra,24(sp)
 868:	6442                	ld	s0,16(sp)
 86a:	6125                	addi	sp,sp,96
 86c:	8082                	ret

000000000000086e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86e:	1141                	addi	sp,sp,-16
 870:	e406                	sd	ra,8(sp)
 872:	e022                	sd	s0,0(sp)
 874:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 876:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	00000797          	auipc	a5,0x0
 87e:	7867b783          	ld	a5,1926(a5) # 1000 <freep>
 882:	a02d                	j	8ac <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 884:	4618                	lw	a4,8(a2)
 886:	9f2d                	addw	a4,a4,a1
 888:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	6310                	ld	a2,0(a4)
 890:	a83d                	j	8ce <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 892:	ff852703          	lw	a4,-8(a0)
 896:	9f31                	addw	a4,a4,a2
 898:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 89a:	ff053683          	ld	a3,-16(a0)
 89e:	a091                	j	8e2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e7e463          	bltu	a5,a4,8aa <free+0x3c>
 8a6:	00e6ea63          	bltu	a3,a4,8ba <free+0x4c>
{
 8aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	fed7fae3          	bgeu	a5,a3,8a0 <free+0x32>
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e6e463          	bltu	a3,a4,8ba <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	fee7eae3          	bltu	a5,a4,8aa <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8ba:	ff852583          	lw	a1,-8(a0)
 8be:	6390                	ld	a2,0(a5)
 8c0:	02059813          	slli	a6,a1,0x20
 8c4:	01c85713          	srli	a4,a6,0x1c
 8c8:	9736                	add	a4,a4,a3
 8ca:	fae60de3          	beq	a2,a4,884 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ce:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d2:	4790                	lw	a2,8(a5)
 8d4:	02061593          	slli	a1,a2,0x20
 8d8:	01c5d713          	srli	a4,a1,0x1c
 8dc:	973e                	add	a4,a4,a5
 8de:	fae68ae3          	beq	a3,a4,892 <free+0x24>
    p->s.ptr = bp->s.ptr;
 8e2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	70f73e23          	sd	a5,1820(a4) # 1000 <freep>
}
 8ec:	60a2                	ld	ra,8(sp)
 8ee:	6402                	ld	s0,0(sp)
 8f0:	0141                	addi	sp,sp,16
 8f2:	8082                	ret

00000000000008f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f4:	7139                	addi	sp,sp,-64
 8f6:	fc06                	sd	ra,56(sp)
 8f8:	f822                	sd	s0,48(sp)
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	ec4e                	sd	s3,24(sp)
 8fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 900:	02051993          	slli	s3,a0,0x20
 904:	0209d993          	srli	s3,s3,0x20
 908:	09bd                	addi	s3,s3,15
 90a:	0049d993          	srli	s3,s3,0x4
 90e:	2985                	addiw	s3,s3,1
 910:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 912:	00000517          	auipc	a0,0x0
 916:	6ee53503          	ld	a0,1774(a0) # 1000 <freep>
 91a:	c905                	beqz	a0,94a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	09377a63          	bgeu	a4,s3,9b4 <malloc+0xc0>
 924:	f426                	sd	s1,40(sp)
 926:	e852                	sd	s4,16(sp)
 928:	e456                	sd	s5,8(sp)
 92a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 92c:	8a4e                	mv	s4,s3
 92e:	6705                	lui	a4,0x1
 930:	00e9f363          	bgeu	s3,a4,936 <malloc+0x42>
 934:	6a05                	lui	s4,0x1
 936:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93e:	00000497          	auipc	s1,0x0
 942:	6c248493          	addi	s1,s1,1730 # 1000 <freep>
  if(p == (char*)-1)
 946:	5afd                	li	s5,-1
 948:	a089                	j	98a <malloc+0x96>
 94a:	f426                	sd	s1,40(sp)
 94c:	e852                	sd	s4,16(sp)
 94e:	e456                	sd	s5,8(sp)
 950:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 952:	00000797          	auipc	a5,0x0
 956:	6be78793          	addi	a5,a5,1726 # 1010 <base>
 95a:	00000717          	auipc	a4,0x0
 95e:	6af73323          	sd	a5,1702(a4) # 1000 <freep>
 962:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 964:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 968:	b7d1                	j	92c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 96a:	6398                	ld	a4,0(a5)
 96c:	e118                	sd	a4,0(a0)
 96e:	a8b9                	j	9cc <malloc+0xd8>
  hp->s.size = nu;
 970:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 974:	0541                	addi	a0,a0,16
 976:	00000097          	auipc	ra,0x0
 97a:	ef8080e7          	jalr	-264(ra) # 86e <free>
  return freep;
 97e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 980:	c135                	beqz	a0,9e4 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 984:	4798                	lw	a4,8(a5)
 986:	03277363          	bgeu	a4,s2,9ac <malloc+0xb8>
    if(p == freep)
 98a:	6098                	ld	a4,0(s1)
 98c:	853e                	mv	a0,a5
 98e:	fef71ae3          	bne	a4,a5,982 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 992:	8552                	mv	a0,s4
 994:	00000097          	auipc	ra,0x0
 998:	aca080e7          	jalr	-1334(ra) # 45e <sbrk>
  if(p == (char*)-1)
 99c:	fd551ae3          	bne	a0,s5,970 <malloc+0x7c>
        return 0;
 9a0:	4501                	li	a0,0
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
 9aa:	a03d                	j	9d8 <malloc+0xe4>
 9ac:	74a2                	ld	s1,40(sp)
 9ae:	6a42                	ld	s4,16(sp)
 9b0:	6aa2                	ld	s5,8(sp)
 9b2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b4:	fae90be3          	beq	s2,a4,96a <malloc+0x76>
        p->s.size -= nunits;
 9b8:	4137073b          	subw	a4,a4,s3
 9bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9be:	02071693          	slli	a3,a4,0x20
 9c2:	01c6d713          	srli	a4,a3,0x1c
 9c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9cc:	00000717          	auipc	a4,0x0
 9d0:	62a73a23          	sd	a0,1588(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d4:	01078513          	addi	a0,a5,16
  }
}
 9d8:	70e2                	ld	ra,56(sp)
 9da:	7442                	ld	s0,48(sp)
 9dc:	7902                	ld	s2,32(sp)
 9de:	69e2                	ld	s3,24(sp)
 9e0:	6121                	addi	sp,sp,64
 9e2:	8082                	ret
 9e4:	74a2                	ld	s1,40(sp)
 9e6:	6a42                	ld	s4,16(sp)
 9e8:	6aa2                	ld	s5,8(sp)
 9ea:	6b02                	ld	s6,0(sp)
 9ec:	b7f5                	j	9d8 <malloc+0xe4>
