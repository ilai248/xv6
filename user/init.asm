
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	9c250513          	addi	a0,a0,-1598 # 9d0 <malloc+0x100>
  16:	00000097          	auipc	ra,0x0
  1a:	3dc080e7          	jalr	988(ra) # 3f2 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	406080e7          	jalr	1030(ra) # 42a <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3fc080e7          	jalr	1020(ra) # 42a <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	9a290913          	addi	s2,s2,-1630 # 9d8 <malloc+0x108>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	7d4080e7          	jalr	2004(ra) # 814 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	362080e7          	jalr	866(ra) # 3aa <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	360080e7          	jalr	864(ra) # 3ba <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	9be50513          	addi	a0,a0,-1602 # a28 <malloc+0x158>
  72:	00000097          	auipc	ra,0x0
  76:	7a2080e7          	jalr	1954(ra) # 814 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	336080e7          	jalr	822(ra) # 3b2 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	94850513          	addi	a0,a0,-1720 # 9d0 <malloc+0x100>
  90:	00000097          	auipc	ra,0x0
  94:	36a080e7          	jalr	874(ra) # 3fa <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	93650513          	addi	a0,a0,-1738 # 9d0 <malloc+0x100>
  a2:	00000097          	auipc	ra,0x0
  a6:	350080e7          	jalr	848(ra) # 3f2 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	94450513          	addi	a0,a0,-1724 # 9f0 <malloc+0x120>
  b4:	00000097          	auipc	ra,0x0
  b8:	760080e7          	jalr	1888(ra) # 814 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2f4080e7          	jalr	756(ra) # 3b2 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	addi	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	93a50513          	addi	a0,a0,-1734 # a08 <malloc+0x138>
  d6:	00000097          	auipc	ra,0x0
  da:	314080e7          	jalr	788(ra) # 3ea <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	93250513          	addi	a0,a0,-1742 # a10 <malloc+0x140>
  e6:	00000097          	auipc	ra,0x0
  ea:	72e080e7          	jalr	1838(ra) # 814 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	2c2080e7          	jalr	706(ra) # 3b2 <exit>

00000000000000f8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2a8080e7          	jalr	680(ra) # 3b2 <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf99                	beqz	a5,18c <strlen+0x2a>
 170:	0505                	addi	a0,a0,1
 172:	87aa                	mv	a5,a0
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
 182:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfdd                	j	184 <strlen+0x22>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 198:	ca19                	beqz	a2,1ae <memset+0x1e>
 19a:	87aa                	mv	a5,a0
 19c:	1602                	slli	a2,a2,0x20
 19e:	9201                	srli	a2,a2,0x20
 1a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a8:	0785                	addi	a5,a5,1
 1aa:	fee79de3          	bne	a5,a4,1a4 <memset+0x14>
  }
  return dst;
}
 1ae:	60a2                	ld	ra,8(sp)
 1b0:	6402                	ld	s0,0(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf81                	beqz	a5,1da <strchr+0x24>
    if(*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1c>
  for(; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xe>
      return (char*)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfdd                	j	1d2 <strchr+0x1c>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	7159                	addi	sp,sp,-112
 1e0:	f486                	sd	ra,104(sp)
 1e2:	f0a2                	sd	s0,96(sp)
 1e4:	eca6                	sd	s1,88(sp)
 1e6:	e8ca                	sd	s2,80(sp)
 1e8:	e4ce                	sd	s3,72(sp)
 1ea:	e0d2                	sd	s4,64(sp)
 1ec:	fc56                	sd	s5,56(sp)
 1ee:	f85a                	sd	s6,48(sp)
 1f0:	f45e                	sd	s7,40(sp)
 1f2:	f062                	sd	s8,32(sp)
 1f4:	ec66                	sd	s9,24(sp)
 1f6:	e86a                	sd	s10,16(sp)
 1f8:	1880                	addi	s0,sp,112
 1fa:	8caa                	mv	s9,a0
 1fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fe:	892a                	mv	s2,a0
 200:	4481                	li	s1,0
    cc = read(0, &c, 1);
 202:	f9f40b13          	addi	s6,s0,-97
 206:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 208:	4ba9                	li	s7,10
 20a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 20c:	8d26                	mv	s10,s1
 20e:	0014899b          	addiw	s3,s1,1
 212:	84ce                	mv	s1,s3
 214:	0349d763          	bge	s3,s4,242 <gets+0x64>
    cc = read(0, &c, 1);
 218:	8656                	mv	a2,s5
 21a:	85da                	mv	a1,s6
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	1ac080e7          	jalr	428(ra) # 3ca <read>
    if(cc < 1)
 226:	00a05e63          	blez	a0,242 <gets+0x64>
    buf[i++] = c;
 22a:	f9f44783          	lbu	a5,-97(s0)
 22e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 232:	01778763          	beq	a5,s7,240 <gets+0x62>
 236:	0905                	addi	s2,s2,1
 238:	fd879ae3          	bne	a5,s8,20c <gets+0x2e>
    buf[i++] = c;
 23c:	8d4e                	mv	s10,s3
 23e:	a011                	j	242 <gets+0x64>
 240:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 242:	9d66                	add	s10,s10,s9
 244:	000d0023          	sb	zero,0(s10)
  return buf;
}
 248:	8566                	mv	a0,s9
 24a:	70a6                	ld	ra,104(sp)
 24c:	7406                	ld	s0,96(sp)
 24e:	64e6                	ld	s1,88(sp)
 250:	6946                	ld	s2,80(sp)
 252:	69a6                	ld	s3,72(sp)
 254:	6a06                	ld	s4,64(sp)
 256:	7ae2                	ld	s5,56(sp)
 258:	7b42                	ld	s6,48(sp)
 25a:	7ba2                	ld	s7,40(sp)
 25c:	7c02                	ld	s8,32(sp)
 25e:	6ce2                	ld	s9,24(sp)
 260:	6d42                	ld	s10,16(sp)
 262:	6165                	addi	sp,sp,112
 264:	8082                	ret

0000000000000266 <stat>:

int
stat(const char *n, struct stat *st)
{
 266:	1101                	addi	sp,sp,-32
 268:	ec06                	sd	ra,24(sp)
 26a:	e822                	sd	s0,16(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	17e080e7          	jalr	382(ra) # 3f2 <open>
  if(fd < 0)
 27c:	02054663          	bltz	a0,2a8 <stat+0x42>
 280:	e426                	sd	s1,8(sp)
 282:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 284:	85ca                	mv	a1,s2
 286:	00000097          	auipc	ra,0x0
 28a:	184080e7          	jalr	388(ra) # 40a <fstat>
 28e:	892a                	mv	s2,a0
  close(fd);
 290:	8526                	mv	a0,s1
 292:	00000097          	auipc	ra,0x0
 296:	148080e7          	jalr	328(ra) # 3da <close>
  return r;
 29a:	64a2                	ld	s1,8(sp)
}
 29c:	854a                	mv	a0,s2
 29e:	60e2                	ld	ra,24(sp)
 2a0:	6442                	ld	s0,16(sp)
 2a2:	6902                	ld	s2,0(sp)
 2a4:	6105                	addi	sp,sp,32
 2a6:	8082                	ret
    return -1;
 2a8:	597d                	li	s2,-1
 2aa:	bfcd                	j	29c <stat+0x36>

00000000000002ac <atoi>:

int
atoi(const char *s)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b4:	00054683          	lbu	a3,0(a0)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	4625                	li	a2,9
 2c2:	02f66963          	bltu	a2,a5,2f4 <atoi+0x48>
 2c6:	872a                	mv	a4,a0
  n = 0;
 2c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ca:	0705                	addi	a4,a4,1
 2cc:	0025179b          	slliw	a5,a0,0x2
 2d0:	9fa9                	addw	a5,a5,a0
 2d2:	0017979b          	slliw	a5,a5,0x1
 2d6:	9fb5                	addw	a5,a5,a3
 2d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2dc:	00074683          	lbu	a3,0(a4)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	fef671e3          	bgeu	a2,a5,2ca <atoi+0x1e>
  return n;
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
  n = 0;
 2f4:	4501                	li	a0,0
 2f6:	bfdd                	j	2ec <atoi+0x40>

00000000000002f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 300:	02b57563          	bgeu	a0,a1,32a <memmove+0x32>
    while(n-- > 0)
 304:	00c05f63          	blez	a2,322 <memmove+0x2a>
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 310:	872a                	mv	a4,a0
      *dst++ = *src++;
 312:	0585                	addi	a1,a1,1
 314:	0705                	addi	a4,a4,1
 316:	fff5c683          	lbu	a3,-1(a1)
 31a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
    dst += n;
 32a:	00c50733          	add	a4,a0,a2
    src += n;
 32e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 330:	fec059e3          	blez	a2,322 <memmove+0x2a>
 334:	fff6079b          	addiw	a5,a2,-1
 338:	1782                	slli	a5,a5,0x20
 33a:	9381                	srli	a5,a5,0x20
 33c:	fff7c793          	not	a5,a5
 340:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 342:	15fd                	addi	a1,a1,-1
 344:	177d                	addi	a4,a4,-1
 346:	0005c683          	lbu	a3,0(a1)
 34a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34e:	fef71ae3          	bne	a4,a5,342 <memmove+0x4a>
 352:	bfc1                	j	322 <memmove+0x2a>

0000000000000354 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35c:	ca0d                	beqz	a2,38e <memcmp+0x3a>
 35e:	fff6069b          	addiw	a3,a2,-1
 362:	1682                	slli	a3,a3,0x20
 364:	9281                	srli	a3,a3,0x20
 366:	0685                	addi	a3,a3,1
 368:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36a:	00054783          	lbu	a5,0(a0)
 36e:	0005c703          	lbu	a4,0(a1)
 372:	00e79863          	bne	a5,a4,382 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 376:	0505                	addi	a0,a0,1
    p2++;
 378:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37a:	fed518e3          	bne	a0,a3,36a <memcmp+0x16>
  }
  return 0;
 37e:	4501                	li	a0,0
 380:	a019                	j	386 <memcmp+0x32>
      return *p1 - *p2;
 382:	40e7853b          	subw	a0,a5,a4
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  return 0;
 38e:	4501                	li	a0,0
 390:	bfdd                	j	386 <memcmp+0x32>

0000000000000392 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39a:	00000097          	auipc	ra,0x0
 39e:	f5e080e7          	jalr	-162(ra) # 2f8 <memmove>
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3aa:	4885                	li	a7,1
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b2:	4889                	li	a7,2
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ba:	488d                	li	a7,3
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c2:	4891                	li	a7,4
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <read>:
.global read
read:
 li a7, SYS_read
 3ca:	4895                	li	a7,5
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <write>:
.global write
write:
 li a7, SYS_write
 3d2:	48c1                	li	a7,16
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <close>:
.global close
close:
 li a7, SYS_close
 3da:	48d5                	li	a7,21
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e2:	4899                	li	a7,6
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ea:	489d                	li	a7,7
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <open>:
.global open
open:
 li a7, SYS_open
 3f2:	48bd                	li	a7,15
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fa:	48c5                	li	a7,17
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 402:	48c9                	li	a7,18
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40a:	48a1                	li	a7,8
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <link>:
.global link
link:
 li a7, SYS_link
 412:	48cd                	li	a7,19
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41a:	48d1                	li	a7,20
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 422:	48a5                	li	a7,9
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <dup>:
.global dup
dup:
 li a7, SYS_dup
 42a:	48a9                	li	a7,10
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 432:	48ad                	li	a7,11
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43a:	48b1                	li	a7,12
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 442:	48b5                	li	a7,13
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44a:	48b9                	li	a7,14
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <trace>:
.global trace
trace:
 li a7, SYS_trace
 452:	48d9                	li	a7,22
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 45a:	48dd                	li	a7,23
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 462:	1101                	addi	sp,sp,-32
 464:	ec06                	sd	ra,24(sp)
 466:	e822                	sd	s0,16(sp)
 468:	1000                	addi	s0,sp,32
 46a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46e:	4605                	li	a2,1
 470:	fef40593          	addi	a1,s0,-17
 474:	00000097          	auipc	ra,0x0
 478:	f5e080e7          	jalr	-162(ra) # 3d2 <write>
}
 47c:	60e2                	ld	ra,24(sp)
 47e:	6442                	ld	s0,16(sp)
 480:	6105                	addi	sp,sp,32
 482:	8082                	ret

0000000000000484 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 484:	7139                	addi	sp,sp,-64
 486:	fc06                	sd	ra,56(sp)
 488:	f822                	sd	s0,48(sp)
 48a:	f426                	sd	s1,40(sp)
 48c:	f04a                	sd	s2,32(sp)
 48e:	ec4e                	sd	s3,24(sp)
 490:	0080                	addi	s0,sp,64
 492:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 494:	c299                	beqz	a3,49a <printint+0x16>
 496:	0805c063          	bltz	a1,516 <printint+0x92>
  neg = 0;
 49a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 49c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4a0:	869a                	mv	a3,t1
  i = 0;
 4a2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4a4:	00000817          	auipc	a6,0x0
 4a8:	5ac80813          	addi	a6,a6,1452 # a50 <digits>
 4ac:	88be                	mv	a7,a5
 4ae:	0017851b          	addiw	a0,a5,1
 4b2:	87aa                	mv	a5,a0
 4b4:	02c5f73b          	remuw	a4,a1,a2
 4b8:	1702                	slli	a4,a4,0x20
 4ba:	9301                	srli	a4,a4,0x20
 4bc:	9742                	add	a4,a4,a6
 4be:	00074703          	lbu	a4,0(a4)
 4c2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4c6:	872e                	mv	a4,a1
 4c8:	02c5d5bb          	divuw	a1,a1,a2
 4cc:	0685                	addi	a3,a3,1
 4ce:	fcc77fe3          	bgeu	a4,a2,4ac <printint+0x28>
  if(neg)
 4d2:	000e0c63          	beqz	t3,4ea <printint+0x66>
    buf[i++] = '-';
 4d6:	fd050793          	addi	a5,a0,-48
 4da:	00878533          	add	a0,a5,s0
 4de:	02d00793          	li	a5,45
 4e2:	fef50823          	sb	a5,-16(a0)
 4e6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4ea:	fff7899b          	addiw	s3,a5,-1
 4ee:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4f2:	fff4c583          	lbu	a1,-1(s1)
 4f6:	854a                	mv	a0,s2
 4f8:	00000097          	auipc	ra,0x0
 4fc:	f6a080e7          	jalr	-150(ra) # 462 <putc>
  while(--i >= 0)
 500:	39fd                	addiw	s3,s3,-1
 502:	14fd                	addi	s1,s1,-1
 504:	fe09d7e3          	bgez	s3,4f2 <printint+0x6e>
}
 508:	70e2                	ld	ra,56(sp)
 50a:	7442                	ld	s0,48(sp)
 50c:	74a2                	ld	s1,40(sp)
 50e:	7902                	ld	s2,32(sp)
 510:	69e2                	ld	s3,24(sp)
 512:	6121                	addi	sp,sp,64
 514:	8082                	ret
    x = -xx;
 516:	40b005bb          	negw	a1,a1
    neg = 1;
 51a:	4e05                	li	t3,1
    x = -xx;
 51c:	b741                	j	49c <printint+0x18>

000000000000051e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51e:	711d                	addi	sp,sp,-96
 520:	ec86                	sd	ra,88(sp)
 522:	e8a2                	sd	s0,80(sp)
 524:	e4a6                	sd	s1,72(sp)
 526:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 528:	0005c483          	lbu	s1,0(a1)
 52c:	2a048863          	beqz	s1,7dc <vprintf+0x2be>
 530:	e0ca                	sd	s2,64(sp)
 532:	fc4e                	sd	s3,56(sp)
 534:	f852                	sd	s4,48(sp)
 536:	f456                	sd	s5,40(sp)
 538:	f05a                	sd	s6,32(sp)
 53a:	ec5e                	sd	s7,24(sp)
 53c:	e862                	sd	s8,16(sp)
 53e:	e466                	sd	s9,8(sp)
 540:	8b2a                	mv	s6,a0
 542:	8a2e                	mv	s4,a1
 544:	8bb2                	mv	s7,a2
  state = 0;
 546:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 548:	4901                	li	s2,0
 54a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 54c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 550:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 554:	06c00c93          	li	s9,108
 558:	a01d                	j	57e <vprintf+0x60>
        putc(fd, c0);
 55a:	85a6                	mv	a1,s1
 55c:	855a                	mv	a0,s6
 55e:	00000097          	auipc	ra,0x0
 562:	f04080e7          	jalr	-252(ra) # 462 <putc>
 566:	a019                	j	56c <vprintf+0x4e>
    } else if(state == '%'){
 568:	03598363          	beq	s3,s5,58e <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 56c:	0019079b          	addiw	a5,s2,1
 570:	893e                	mv	s2,a5
 572:	873e                	mv	a4,a5
 574:	97d2                	add	a5,a5,s4
 576:	0007c483          	lbu	s1,0(a5)
 57a:	24048963          	beqz	s1,7cc <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 57e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 582:	fe0993e3          	bnez	s3,568 <vprintf+0x4a>
      if(c0 == '%'){
 586:	fd579ae3          	bne	a5,s5,55a <vprintf+0x3c>
        state = '%';
 58a:	89be                	mv	s3,a5
 58c:	b7c5                	j	56c <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 58e:	00ea06b3          	add	a3,s4,a4
 592:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 596:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 598:	c681                	beqz	a3,5a0 <vprintf+0x82>
 59a:	9752                	add	a4,a4,s4
 59c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5a0:	05878063          	beq	a5,s8,5e0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5a4:	05978c63          	beq	a5,s9,5fc <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a8:	07500713          	li	a4,117
 5ac:	10e78063          	beq	a5,a4,6ac <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5b0:	07800713          	li	a4,120
 5b4:	14e78863          	beq	a5,a4,704 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5b8:	07000713          	li	a4,112
 5bc:	18e78163          	beq	a5,a4,73e <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5c0:	07300713          	li	a4,115
 5c4:	1ce78663          	beq	a5,a4,790 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c8:	02500713          	li	a4,37
 5cc:	04e79863          	bne	a5,a4,61c <vprintf+0xfe>
        putc(fd, '%');
 5d0:	85ba                	mv	a1,a4
 5d2:	855a                	mv	a0,s6
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e8e080e7          	jalr	-370(ra) # 462 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b779                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e96080e7          	jalr	-362(ra) # 484 <printint>
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bf8d                	j	56c <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 5fc:	06400793          	li	a5,100
 600:	02f68d63          	beq	a3,a5,63a <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 604:	06c00793          	li	a5,108
 608:	04f68863          	beq	a3,a5,658 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 60c:	07500793          	li	a5,117
 610:	0af68c63          	beq	a3,a5,6c8 <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 614:	07800793          	li	a5,120
 618:	10f68463          	beq	a3,a5,720 <vprintf+0x202>
        putc(fd, '%');
 61c:	02500593          	li	a1,37
 620:	855a                	mv	a0,s6
 622:	00000097          	auipc	ra,0x0
 626:	e40080e7          	jalr	-448(ra) # 462 <putc>
        putc(fd, c0);
 62a:	85a6                	mv	a1,s1
 62c:	855a                	mv	a0,s6
 62e:	00000097          	auipc	ra,0x0
 632:	e34080e7          	jalr	-460(ra) # 462 <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	bf15                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	00000097          	auipc	ra,0x0
 64c:	e3c080e7          	jalr	-452(ra) # 484 <printint>
        i += 1;
 650:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
        i += 1;
 656:	bf19                	j	56c <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 658:	06400793          	li	a5,100
 65c:	02f60963          	beq	a2,a5,68e <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 660:	07500793          	li	a5,117
 664:	08f60163          	beq	a2,a5,6e6 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 668:	07800793          	li	a5,120
 66c:	faf618e3          	bne	a2,a5,61c <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000ba583          	lw	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	00000097          	auipc	ra,0x0
 682:	e06080e7          	jalr	-506(ra) # 484 <printint>
        i += 2;
 686:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	b5c5                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68e:	008b8493          	addi	s1,s7,8
 692:	4685                	li	a3,1
 694:	4629                	li	a2,10
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	00000097          	auipc	ra,0x0
 6a0:	de8080e7          	jalr	-536(ra) # 484 <printint>
        i += 2;
 6a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a6:	8ba6                	mv	s7,s1
      state = 0;
 6a8:	4981                	li	s3,0
        i += 2;
 6aa:	b5c9                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4629                	li	a2,10
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	00000097          	auipc	ra,0x0
 6be:	dca080e7          	jalr	-566(ra) # 484 <printint>
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b55d                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	008b8493          	addi	s1,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4629                	li	a2,10
 6d0:	000ba583          	lw	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	00000097          	auipc	ra,0x0
 6da:	dae080e7          	jalr	-594(ra) # 484 <printint>
        i += 1;
 6de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e0:	8ba6                	mv	s7,s1
      state = 0;
 6e2:	4981                	li	s3,0
        i += 1;
 6e4:	b561                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e6:	008b8493          	addi	s1,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4629                	li	a2,10
 6ee:	000ba583          	lw	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	00000097          	auipc	ra,0x0
 6f8:	d90080e7          	jalr	-624(ra) # 484 <printint>
        i += 2;
 6fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	b5ad                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 704:	008b8493          	addi	s1,s7,8
 708:	4681                	li	a3,0
 70a:	4641                	li	a2,16
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	00000097          	auipc	ra,0x0
 716:	d72080e7          	jalr	-654(ra) # 484 <printint>
 71a:	8ba6                	mv	s7,s1
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b5b9                	j	56c <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 720:	008b8493          	addi	s1,s7,8
 724:	4681                	li	a3,0
 726:	4641                	li	a2,16
 728:	000ba583          	lw	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	00000097          	auipc	ra,0x0
 732:	d56080e7          	jalr	-682(ra) # 484 <printint>
        i += 1;
 736:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 738:	8ba6                	mv	s7,s1
      state = 0;
 73a:	4981                	li	s3,0
        i += 1;
 73c:	bd05                	j	56c <vprintf+0x4e>
 73e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 740:	008b8d13          	addi	s10,s7,8
 744:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 748:	03000593          	li	a1,48
 74c:	855a                	mv	a0,s6
 74e:	00000097          	auipc	ra,0x0
 752:	d14080e7          	jalr	-748(ra) # 462 <putc>
  putc(fd, 'x');
 756:	07800593          	li	a1,120
 75a:	855a                	mv	a0,s6
 75c:	00000097          	auipc	ra,0x0
 760:	d06080e7          	jalr	-762(ra) # 462 <putc>
 764:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 766:	00000b97          	auipc	s7,0x0
 76a:	2eab8b93          	addi	s7,s7,746 # a50 <digits>
 76e:	03c9d793          	srli	a5,s3,0x3c
 772:	97de                	add	a5,a5,s7
 774:	0007c583          	lbu	a1,0(a5)
 778:	855a                	mv	a0,s6
 77a:	00000097          	auipc	ra,0x0
 77e:	ce8080e7          	jalr	-792(ra) # 462 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 782:	0992                	slli	s3,s3,0x4
 784:	34fd                	addiw	s1,s1,-1
 786:	f4e5                	bnez	s1,76e <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 788:	8bea                	mv	s7,s10
      state = 0;
 78a:	4981                	li	s3,0
 78c:	6d02                	ld	s10,0(sp)
 78e:	bbf9                	j	56c <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 790:	008b8993          	addi	s3,s7,8
 794:	000bb483          	ld	s1,0(s7)
 798:	c085                	beqz	s1,7b8 <vprintf+0x29a>
        for(; *s; s++)
 79a:	0004c583          	lbu	a1,0(s1)
 79e:	c585                	beqz	a1,7c6 <vprintf+0x2a8>
          putc(fd, *s);
 7a0:	855a                	mv	a0,s6
 7a2:	00000097          	auipc	ra,0x0
 7a6:	cc0080e7          	jalr	-832(ra) # 462 <putc>
        for(; *s; s++)
 7aa:	0485                	addi	s1,s1,1
 7ac:	0004c583          	lbu	a1,0(s1)
 7b0:	f9e5                	bnez	a1,7a0 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 7b2:	8bce                	mv	s7,s3
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	bb5d                	j	56c <vprintf+0x4e>
          s = "(null)";
 7b8:	00000497          	auipc	s1,0x0
 7bc:	29048493          	addi	s1,s1,656 # a48 <malloc+0x178>
        for(; *s; s++)
 7c0:	02800593          	li	a1,40
 7c4:	bff1                	j	7a0 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	8bce                	mv	s7,s3
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b34d                	j	56c <vprintf+0x4e>
 7cc:	6906                	ld	s2,64(sp)
 7ce:	79e2                	ld	s3,56(sp)
 7d0:	7a42                	ld	s4,48(sp)
 7d2:	7aa2                	ld	s5,40(sp)
 7d4:	7b02                	ld	s6,32(sp)
 7d6:	6be2                	ld	s7,24(sp)
 7d8:	6c42                	ld	s8,16(sp)
 7da:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7dc:	60e6                	ld	ra,88(sp)
 7de:	6446                	ld	s0,80(sp)
 7e0:	64a6                	ld	s1,72(sp)
 7e2:	6125                	addi	sp,sp,96
 7e4:	8082                	ret

00000000000007e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e6:	715d                	addi	sp,sp,-80
 7e8:	ec06                	sd	ra,24(sp)
 7ea:	e822                	sd	s0,16(sp)
 7ec:	1000                	addi	s0,sp,32
 7ee:	e010                	sd	a2,0(s0)
 7f0:	e414                	sd	a3,8(s0)
 7f2:	e818                	sd	a4,16(s0)
 7f4:	ec1c                	sd	a5,24(s0)
 7f6:	03043023          	sd	a6,32(s0)
 7fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fe:	8622                	mv	a2,s0
 800:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 804:	00000097          	auipc	ra,0x0
 808:	d1a080e7          	jalr	-742(ra) # 51e <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6161                	addi	sp,sp,80
 812:	8082                	ret

0000000000000814 <printf>:

void
printf(const char *fmt, ...)
{
 814:	711d                	addi	sp,sp,-96
 816:	ec06                	sd	ra,24(sp)
 818:	e822                	sd	s0,16(sp)
 81a:	1000                	addi	s0,sp,32
 81c:	e40c                	sd	a1,8(s0)
 81e:	e810                	sd	a2,16(s0)
 820:	ec14                	sd	a3,24(s0)
 822:	f018                	sd	a4,32(s0)
 824:	f41c                	sd	a5,40(s0)
 826:	03043823          	sd	a6,48(s0)
 82a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82e:	00840613          	addi	a2,s0,8
 832:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 836:	85aa                	mv	a1,a0
 838:	4505                	li	a0,1
 83a:	00000097          	auipc	ra,0x0
 83e:	ce4080e7          	jalr	-796(ra) # 51e <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6125                	addi	sp,sp,96
 848:	8082                	ret

000000000000084a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84a:	1141                	addi	sp,sp,-16
 84c:	e406                	sd	ra,8(sp)
 84e:	e022                	sd	s0,0(sp)
 850:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 852:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	00000797          	auipc	a5,0x0
 85a:	7ba7b783          	ld	a5,1978(a5) # 1010 <freep>
 85e:	a02d                	j	888 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 860:	4618                	lw	a4,8(a2)
 862:	9f2d                	addw	a4,a4,a1
 864:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 868:	6398                	ld	a4,0(a5)
 86a:	6310                	ld	a2,0(a4)
 86c:	a83d                	j	8aa <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 86e:	ff852703          	lw	a4,-8(a0)
 872:	9f31                	addw	a4,a4,a2
 874:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 876:	ff053683          	ld	a3,-16(a0)
 87a:	a091                	j	8be <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87c:	6398                	ld	a4,0(a5)
 87e:	00e7e463          	bltu	a5,a4,886 <free+0x3c>
 882:	00e6ea63          	bltu	a3,a4,896 <free+0x4c>
{
 886:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 888:	fed7fae3          	bgeu	a5,a3,87c <free+0x32>
 88c:	6398                	ld	a4,0(a5)
 88e:	00e6e463          	bltu	a3,a4,896 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 892:	fee7eae3          	bltu	a5,a4,886 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 896:	ff852583          	lw	a1,-8(a0)
 89a:	6390                	ld	a2,0(a5)
 89c:	02059813          	slli	a6,a1,0x20
 8a0:	01c85713          	srli	a4,a6,0x1c
 8a4:	9736                	add	a4,a4,a3
 8a6:	fae60de3          	beq	a2,a4,860 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ae:	4790                	lw	a2,8(a5)
 8b0:	02061593          	slli	a1,a2,0x20
 8b4:	01c5d713          	srli	a4,a1,0x1c
 8b8:	973e                	add	a4,a4,a5
 8ba:	fae68ae3          	beq	a3,a4,86e <free+0x24>
    p->s.ptr = bp->s.ptr;
 8be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74f73823          	sd	a5,1872(a4) # 1010 <freep>
}
 8c8:	60a2                	ld	ra,8(sp)
 8ca:	6402                	ld	s0,0(sp)
 8cc:	0141                	addi	sp,sp,16
 8ce:	8082                	ret

00000000000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	7139                	addi	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	ec4e                	sd	s3,24(sp)
 8da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8dc:	02051993          	slli	s3,a0,0x20
 8e0:	0209d993          	srli	s3,s3,0x20
 8e4:	09bd                	addi	s3,s3,15
 8e6:	0049d993          	srli	s3,s3,0x4
 8ea:	2985                	addiw	s3,s3,1
 8ec:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8ee:	00000517          	auipc	a0,0x0
 8f2:	72253503          	ld	a0,1826(a0) # 1010 <freep>
 8f6:	c905                	beqz	a0,926 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fa:	4798                	lw	a4,8(a5)
 8fc:	09377a63          	bgeu	a4,s3,990 <malloc+0xc0>
 900:	f426                	sd	s1,40(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 908:	8a4e                	mv	s4,s3
 90a:	6705                	lui	a4,0x1
 90c:	00e9f363          	bgeu	s3,a4,912 <malloc+0x42>
 910:	6a05                	lui	s4,0x1
 912:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 916:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91a:	00000497          	auipc	s1,0x0
 91e:	6f648493          	addi	s1,s1,1782 # 1010 <freep>
  if(p == (char*)-1)
 922:	5afd                	li	s5,-1
 924:	a089                	j	966 <malloc+0x96>
 926:	f426                	sd	s1,40(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 92e:	00000797          	auipc	a5,0x0
 932:	6f278793          	addi	a5,a5,1778 # 1020 <base>
 936:	00000717          	auipc	a4,0x0
 93a:	6cf73d23          	sd	a5,1754(a4) # 1010 <freep>
 93e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 940:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 944:	b7d1                	j	908 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	e118                	sd	a4,0(a0)
 94a:	a8b9                	j	9a8 <malloc+0xd8>
  hp->s.size = nu;
 94c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 950:	0541                	addi	a0,a0,16
 952:	00000097          	auipc	ra,0x0
 956:	ef8080e7          	jalr	-264(ra) # 84a <free>
  return freep;
 95a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 95c:	c135                	beqz	a0,9c0 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 960:	4798                	lw	a4,8(a5)
 962:	03277363          	bgeu	a4,s2,988 <malloc+0xb8>
    if(p == freep)
 966:	6098                	ld	a4,0(s1)
 968:	853e                	mv	a0,a5
 96a:	fef71ae3          	bne	a4,a5,95e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 96e:	8552                	mv	a0,s4
 970:	00000097          	auipc	ra,0x0
 974:	aca080e7          	jalr	-1334(ra) # 43a <sbrk>
  if(p == (char*)-1)
 978:	fd551ae3          	bne	a0,s5,94c <malloc+0x7c>
        return 0;
 97c:	4501                	li	a0,0
 97e:	74a2                	ld	s1,40(sp)
 980:	6a42                	ld	s4,16(sp)
 982:	6aa2                	ld	s5,8(sp)
 984:	6b02                	ld	s6,0(sp)
 986:	a03d                	j	9b4 <malloc+0xe4>
 988:	74a2                	ld	s1,40(sp)
 98a:	6a42                	ld	s4,16(sp)
 98c:	6aa2                	ld	s5,8(sp)
 98e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 990:	fae90be3          	beq	s2,a4,946 <malloc+0x76>
        p->s.size -= nunits;
 994:	4137073b          	subw	a4,a4,s3
 998:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99a:	02071693          	slli	a3,a4,0x20
 99e:	01c6d713          	srli	a4,a3,0x1c
 9a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a8:	00000717          	auipc	a4,0x0
 9ac:	66a73423          	sd	a0,1640(a4) # 1010 <freep>
      return (void*)(p + 1);
 9b0:	01078513          	addi	a0,a5,16
  }
}
 9b4:	70e2                	ld	ra,56(sp)
 9b6:	7442                	ld	s0,48(sp)
 9b8:	7902                	ld	s2,32(sp)
 9ba:	69e2                	ld	s3,24(sp)
 9bc:	6121                	addi	sp,sp,64
 9be:	8082                	ret
 9c0:	74a2                	ld	s1,40(sp)
 9c2:	6a42                	ld	s4,16(sp)
 9c4:	6aa2                	ld	s5,8(sp)
 9c6:	6b02                	ld	s6,0(sp)
 9c8:	b7f5                	j	9b4 <malloc+0xe4>
