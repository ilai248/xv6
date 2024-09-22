
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	00001917          	auipc	s2,0x1
  18:	ffc90913          	addi	s2,s2,-4 # 1010 <buf>
  1c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	00000097          	auipc	ra,0x0
  2c:	3d8080e7          	jalr	984(ra) # 400 <read>
  30:	84aa                	mv	s1,a0
  32:	02a05963          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  36:	8626                	mv	a2,s1
  38:	85ca                	mv	a1,s2
  3a:	8556                	mv	a0,s5
  3c:	00000097          	auipc	ra,0x0
  40:	3cc080e7          	jalr	972(ra) # 408 <write>
  44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  48:	00001597          	auipc	a1,0x1
  4c:	9b858593          	addi	a1,a1,-1608 # a00 <malloc+0xfa>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	7ca080e7          	jalr	1994(ra) # 81c <fprintf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	38c080e7          	jalr	908(ra) # 3e8 <exit>
    }
  }
  if(n < 0){
  64:	00054b63          	bltz	a0,7a <cat+0x7a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  68:	70e2                	ld	ra,56(sp)
  6a:	7442                	ld	s0,48(sp)
  6c:	74a2                	ld	s1,40(sp)
  6e:	7902                	ld	s2,32(sp)
  70:	69e2                	ld	s3,24(sp)
  72:	6a42                	ld	s4,16(sp)
  74:	6aa2                	ld	s5,8(sp)
  76:	6121                	addi	sp,sp,64
  78:	8082                	ret
    fprintf(2, "cat: read error\n");
  7a:	00001597          	auipc	a1,0x1
  7e:	99e58593          	addi	a1,a1,-1634 # a18 <malloc+0x112>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	798080e7          	jalr	1944(ra) # 81c <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	35a080e7          	jalr	858(ra) # 3e8 <exit>

0000000000000096 <main>:

int
main(int argc, char *argv[])
{
  96:	7179                	addi	sp,sp,-48
  98:	f406                	sd	ra,40(sp)
  9a:	f022                	sd	s0,32(sp)
  9c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9e:	4785                	li	a5,1
  a0:	04a7da63          	bge	a5,a0,f4 <main+0x5e>
  a4:	ec26                	sd	s1,24(sp)
  a6:	e84a                	sd	s2,16(sp)
  a8:	e44e                	sd	s3,8(sp)
  aa:	00858913          	addi	s2,a1,8
  ae:	ffe5099b          	addiw	s3,a0,-2
  b2:	02099793          	slli	a5,s3,0x20
  b6:	01d7d993          	srli	s3,a5,0x1d
  ba:	05c1                	addi	a1,a1,16
  bc:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  be:	4581                	li	a1,0
  c0:	00093503          	ld	a0,0(s2)
  c4:	00000097          	auipc	ra,0x0
  c8:	364080e7          	jalr	868(ra) # 428 <open>
  cc:	84aa                	mv	s1,a0
  ce:	04054063          	bltz	a0,10e <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <cat>
    close(fd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	334080e7          	jalr	820(ra) # 410 <close>
  for(i = 1; i < argc; i++){
  e4:	0921                	addi	s2,s2,8
  e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
  }
  exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	2fc080e7          	jalr	764(ra) # 3e8 <exit>
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
    cat(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <cat>
    exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	2e2080e7          	jalr	738(ra) # 3e8 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 10e:	00093603          	ld	a2,0(s2)
 112:	00001597          	auipc	a1,0x1
 116:	91e58593          	addi	a1,a1,-1762 # a30 <malloc+0x12a>
 11a:	4509                	li	a0,2
 11c:	00000097          	auipc	ra,0x0
 120:	700080e7          	jalr	1792(ra) # 81c <fprintf>
      exit(1);
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	2c2080e7          	jalr	706(ra) # 3e8 <exit>

000000000000012e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  extern int main();
  main();
 136:	00000097          	auipc	ra,0x0
 13a:	f60080e7          	jalr	-160(ra) # 96 <main>
  exit(0);
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	2a8080e7          	jalr	680(ra) # 3e8 <exit>

0000000000000148 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	87aa                	mv	a5,a0
 152:	0585                	addi	a1,a1,1
 154:	0785                	addi	a5,a5,1
 156:	fff5c703          	lbu	a4,-1(a1)
 15a:	fee78fa3          	sb	a4,-1(a5)
 15e:	fb75                	bnez	a4,152 <strcpy+0xa>
    ;
  return os;
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb91                	beqz	a5,188 <strcmp+0x20>
 176:	0005c703          	lbu	a4,0(a1)
 17a:	00f71763          	bne	a4,a5,188 <strcmp+0x20>
    p++, q++;
 17e:	0505                	addi	a0,a0,1
 180:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	fbe5                	bnez	a5,176 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 188:	0005c503          	lbu	a0,0(a1)
}
 18c:	40a7853b          	subw	a0,a5,a0
 190:	60a2                	ld	ra,8(sp)
 192:	6402                	ld	s0,0(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <strlen>:

uint
strlen(const char *s)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e406                	sd	ra,8(sp)
 19c:	e022                	sd	s0,0(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cf99                	beqz	a5,1c2 <strlen+0x2a>
 1a6:	0505                	addi	a0,a0,1
 1a8:	87aa                	mv	a5,a0
 1aa:	86be                	mv	a3,a5
 1ac:	0785                	addi	a5,a5,1
 1ae:	fff7c703          	lbu	a4,-1(a5)
 1b2:	ff65                	bnez	a4,1aa <strlen+0x12>
 1b4:	40a6853b          	subw	a0,a3,a0
 1b8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1ba:	60a2                	ld	ra,8(sp)
 1bc:	6402                	ld	s0,0(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret
  for(n = 0; s[n]; n++)
 1c2:	4501                	li	a0,0
 1c4:	bfdd                	j	1ba <strlen+0x22>

00000000000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ce:	ca19                	beqz	a2,1e4 <memset+0x1e>
 1d0:	87aa                	mv	a5,a0
 1d2:	1602                	slli	a2,a2,0x20
 1d4:	9201                	srli	a2,a2,0x20
 1d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1de:	0785                	addi	a5,a5,1
 1e0:	fee79de3          	bne	a5,a4,1da <memset+0x14>
  }
  return dst;
}
 1e4:	60a2                	ld	ra,8(sp)
 1e6:	6402                	ld	s0,0(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strchr>:

char*
strchr(const char *s, char c)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cf81                	beqz	a5,210 <strchr+0x24>
    if(*s == c)
 1fa:	00f58763          	beq	a1,a5,208 <strchr+0x1c>
  for(; *s; s++)
 1fe:	0505                	addi	a0,a0,1
 200:	00054783          	lbu	a5,0(a0)
 204:	fbfd                	bnez	a5,1fa <strchr+0xe>
      return (char*)s;
  return 0;
 206:	4501                	li	a0,0
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
  return 0;
 210:	4501                	li	a0,0
 212:	bfdd                	j	208 <strchr+0x1c>

0000000000000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	7159                	addi	sp,sp,-112
 216:	f486                	sd	ra,104(sp)
 218:	f0a2                	sd	s0,96(sp)
 21a:	eca6                	sd	s1,88(sp)
 21c:	e8ca                	sd	s2,80(sp)
 21e:	e4ce                	sd	s3,72(sp)
 220:	e0d2                	sd	s4,64(sp)
 222:	fc56                	sd	s5,56(sp)
 224:	f85a                	sd	s6,48(sp)
 226:	f45e                	sd	s7,40(sp)
 228:	f062                	sd	s8,32(sp)
 22a:	ec66                	sd	s9,24(sp)
 22c:	e86a                	sd	s10,16(sp)
 22e:	1880                	addi	s0,sp,112
 230:	8caa                	mv	s9,a0
 232:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	892a                	mv	s2,a0
 236:	4481                	li	s1,0
    cc = read(0, &c, 1);
 238:	f9f40b13          	addi	s6,s0,-97
 23c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23e:	4ba9                	li	s7,10
 240:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 242:	8d26                	mv	s10,s1
 244:	0014899b          	addiw	s3,s1,1
 248:	84ce                	mv	s1,s3
 24a:	0349d763          	bge	s3,s4,278 <gets+0x64>
    cc = read(0, &c, 1);
 24e:	8656                	mv	a2,s5
 250:	85da                	mv	a1,s6
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	1ac080e7          	jalr	428(ra) # 400 <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x64>
    buf[i++] = c;
 260:	f9f44783          	lbu	a5,-97(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01778763          	beq	a5,s7,276 <gets+0x62>
 26c:	0905                	addi	s2,s2,1
 26e:	fd879ae3          	bne	a5,s8,242 <gets+0x2e>
    buf[i++] = c;
 272:	8d4e                	mv	s10,s3
 274:	a011                	j	278 <gets+0x64>
 276:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 278:	9d66                	add	s10,s10,s9
 27a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 27e:	8566                	mv	a0,s9
 280:	70a6                	ld	ra,104(sp)
 282:	7406                	ld	s0,96(sp)
 284:	64e6                	ld	s1,88(sp)
 286:	6946                	ld	s2,80(sp)
 288:	69a6                	ld	s3,72(sp)
 28a:	6a06                	ld	s4,64(sp)
 28c:	7ae2                	ld	s5,56(sp)
 28e:	7b42                	ld	s6,48(sp)
 290:	7ba2                	ld	s7,40(sp)
 292:	7c02                	ld	s8,32(sp)
 294:	6ce2                	ld	s9,24(sp)
 296:	6d42                	ld	s10,16(sp)
 298:	6165                	addi	sp,sp,112
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	addi	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e04a                	sd	s2,0(sp)
 2a4:	1000                	addi	s0,sp,32
 2a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a8:	4581                	li	a1,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	17e080e7          	jalr	382(ra) # 428 <open>
  if(fd < 0)
 2b2:	02054663          	bltz	a0,2de <stat+0x42>
 2b6:	e426                	sd	s1,8(sp)
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	00000097          	auipc	ra,0x0
 2c0:	184080e7          	jalr	388(ra) # 440 <fstat>
 2c4:	892a                	mv	s2,a0
  close(fd);
 2c6:	8526                	mv	a0,s1
 2c8:	00000097          	auipc	ra,0x0
 2cc:	148080e7          	jalr	328(ra) # 410 <close>
  return r;
 2d0:	64a2                	ld	s1,8(sp)
}
 2d2:	854a                	mv	a0,s2
 2d4:	60e2                	ld	ra,24(sp)
 2d6:	6442                	ld	s0,16(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfcd                	j	2d2 <stat+0x36>

00000000000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ea:	00054683          	lbu	a3,0(a0)
 2ee:	fd06879b          	addiw	a5,a3,-48
 2f2:	0ff7f793          	zext.b	a5,a5
 2f6:	4625                	li	a2,9
 2f8:	02f66963          	bltu	a2,a5,32a <atoi+0x48>
 2fc:	872a                	mv	a4,a0
  n = 0;
 2fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 300:	0705                	addi	a4,a4,1
 302:	0025179b          	slliw	a5,a0,0x2
 306:	9fa9                	addw	a5,a5,a0
 308:	0017979b          	slliw	a5,a5,0x1
 30c:	9fb5                	addw	a5,a5,a3
 30e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 312:	00074683          	lbu	a3,0(a4)
 316:	fd06879b          	addiw	a5,a3,-48
 31a:	0ff7f793          	zext.b	a5,a5
 31e:	fef671e3          	bgeu	a2,a5,300 <atoi+0x1e>
  return n;
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  n = 0;
 32a:	4501                	li	a0,0
 32c:	bfdd                	j	322 <atoi+0x40>

000000000000032e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 336:	02b57563          	bgeu	a0,a1,360 <memmove+0x32>
    while(n-- > 0)
 33a:	00c05f63          	blez	a2,358 <memmove+0x2a>
 33e:	1602                	slli	a2,a2,0x20
 340:	9201                	srli	a2,a2,0x20
 342:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 346:	872a                	mv	a4,a0
      *dst++ = *src++;
 348:	0585                	addi	a1,a1,1
 34a:	0705                	addi	a4,a4,1
 34c:	fff5c683          	lbu	a3,-1(a1)
 350:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 354:	fee79ae3          	bne	a5,a4,348 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
    dst += n;
 360:	00c50733          	add	a4,a0,a2
    src += n;
 364:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 366:	fec059e3          	blez	a2,358 <memmove+0x2a>
 36a:	fff6079b          	addiw	a5,a2,-1
 36e:	1782                	slli	a5,a5,0x20
 370:	9381                	srli	a5,a5,0x20
 372:	fff7c793          	not	a5,a5
 376:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 378:	15fd                	addi	a1,a1,-1
 37a:	177d                	addi	a4,a4,-1
 37c:	0005c683          	lbu	a3,0(a1)
 380:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 384:	fef71ae3          	bne	a4,a5,378 <memmove+0x4a>
 388:	bfc1                	j	358 <memmove+0x2a>

000000000000038a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 392:	ca0d                	beqz	a2,3c4 <memcmp+0x3a>
 394:	fff6069b          	addiw	a3,a2,-1
 398:	1682                	slli	a3,a3,0x20
 39a:	9281                	srli	a3,a3,0x20
 39c:	0685                	addi	a3,a3,1
 39e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a0:	00054783          	lbu	a5,0(a0)
 3a4:	0005c703          	lbu	a4,0(a1)
 3a8:	00e79863          	bne	a5,a4,3b8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3ac:	0505                	addi	a0,a0,1
    p2++;
 3ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b0:	fed518e3          	bne	a0,a3,3a0 <memcmp+0x16>
  }
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	a019                	j	3bc <memcmp+0x32>
      return *p1 - *p2;
 3b8:	40e7853b          	subw	a0,a5,a4
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	bfdd                	j	3bc <memcmp+0x32>

00000000000003c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e406                	sd	ra,8(sp)
 3cc:	e022                	sd	s0,0(sp)
 3ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f5e080e7          	jalr	-162(ra) # 32e <memmove>
}
 3d8:	60a2                	ld	ra,8(sp)
 3da:	6402                	ld	s0,0(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret

00000000000003e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e0:	4885                	li	a7,1
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e8:	4889                	li	a7,2
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f0:	488d                	li	a7,3
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f8:	4891                	li	a7,4
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <read>:
.global read
read:
 li a7, SYS_read
 400:	4895                	li	a7,5
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <write>:
.global write
write:
 li a7, SYS_write
 408:	48c1                	li	a7,16
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <close>:
.global close
close:
 li a7, SYS_close
 410:	48d5                	li	a7,21
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <kill>:
.global kill
kill:
 li a7, SYS_kill
 418:	4899                	li	a7,6
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exec>:
.global exec
exec:
 li a7, SYS_exec
 420:	489d                	li	a7,7
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <open>:
.global open
open:
 li a7, SYS_open
 428:	48bd                	li	a7,15
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 430:	48c5                	li	a7,17
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 438:	48c9                	li	a7,18
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 440:	48a1                	li	a7,8
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <link>:
.global link
link:
 li a7, SYS_link
 448:	48cd                	li	a7,19
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 450:	48d1                	li	a7,20
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 458:	48a5                	li	a7,9
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <dup>:
.global dup
dup:
 li a7, SYS_dup
 460:	48a9                	li	a7,10
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 468:	48ad                	li	a7,11
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 470:	48b1                	li	a7,12
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 478:	48b5                	li	a7,13
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 480:	48b9                	li	a7,14
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <trace>:
.global trace
trace:
 li a7, SYS_trace
 488:	48d9                	li	a7,22
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 490:	48dd                	li	a7,23
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 498:	1101                	addi	sp,sp,-32
 49a:	ec06                	sd	ra,24(sp)
 49c:	e822                	sd	s0,16(sp)
 49e:	1000                	addi	s0,sp,32
 4a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a4:	4605                	li	a2,1
 4a6:	fef40593          	addi	a1,s0,-17
 4aa:	00000097          	auipc	ra,0x0
 4ae:	f5e080e7          	jalr	-162(ra) # 408 <write>
}
 4b2:	60e2                	ld	ra,24(sp)
 4b4:	6442                	ld	s0,16(sp)
 4b6:	6105                	addi	sp,sp,32
 4b8:	8082                	ret

00000000000004ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ba:	7139                	addi	sp,sp,-64
 4bc:	fc06                	sd	ra,56(sp)
 4be:	f822                	sd	s0,48(sp)
 4c0:	f426                	sd	s1,40(sp)
 4c2:	f04a                	sd	s2,32(sp)
 4c4:	ec4e                	sd	s3,24(sp)
 4c6:	0080                	addi	s0,sp,64
 4c8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ca:	c299                	beqz	a3,4d0 <printint+0x16>
 4cc:	0805c063          	bltz	a1,54c <printint+0x92>
  neg = 0;
 4d0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4d2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4d6:	869a                	mv	a3,t1
  i = 0;
 4d8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4da:	00000817          	auipc	a6,0x0
 4de:	57680813          	addi	a6,a6,1398 # a50 <digits>
 4e2:	88be                	mv	a7,a5
 4e4:	0017851b          	addiw	a0,a5,1
 4e8:	87aa                	mv	a5,a0
 4ea:	02c5f73b          	remuw	a4,a1,a2
 4ee:	1702                	slli	a4,a4,0x20
 4f0:	9301                	srli	a4,a4,0x20
 4f2:	9742                	add	a4,a4,a6
 4f4:	00074703          	lbu	a4,0(a4)
 4f8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4fc:	872e                	mv	a4,a1
 4fe:	02c5d5bb          	divuw	a1,a1,a2
 502:	0685                	addi	a3,a3,1
 504:	fcc77fe3          	bgeu	a4,a2,4e2 <printint+0x28>
  if(neg)
 508:	000e0c63          	beqz	t3,520 <printint+0x66>
    buf[i++] = '-';
 50c:	fd050793          	addi	a5,a0,-48
 510:	00878533          	add	a0,a5,s0
 514:	02d00793          	li	a5,45
 518:	fef50823          	sb	a5,-16(a0)
 51c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 520:	fff7899b          	addiw	s3,a5,-1
 524:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 528:	fff4c583          	lbu	a1,-1(s1)
 52c:	854a                	mv	a0,s2
 52e:	00000097          	auipc	ra,0x0
 532:	f6a080e7          	jalr	-150(ra) # 498 <putc>
  while(--i >= 0)
 536:	39fd                	addiw	s3,s3,-1
 538:	14fd                	addi	s1,s1,-1
 53a:	fe09d7e3          	bgez	s3,528 <printint+0x6e>
}
 53e:	70e2                	ld	ra,56(sp)
 540:	7442                	ld	s0,48(sp)
 542:	74a2                	ld	s1,40(sp)
 544:	7902                	ld	s2,32(sp)
 546:	69e2                	ld	s3,24(sp)
 548:	6121                	addi	sp,sp,64
 54a:	8082                	ret
    x = -xx;
 54c:	40b005bb          	negw	a1,a1
    neg = 1;
 550:	4e05                	li	t3,1
    x = -xx;
 552:	b741                	j	4d2 <printint+0x18>

0000000000000554 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 554:	711d                	addi	sp,sp,-96
 556:	ec86                	sd	ra,88(sp)
 558:	e8a2                	sd	s0,80(sp)
 55a:	e4a6                	sd	s1,72(sp)
 55c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 55e:	0005c483          	lbu	s1,0(a1)
 562:	2a048863          	beqz	s1,812 <vprintf+0x2be>
 566:	e0ca                	sd	s2,64(sp)
 568:	fc4e                	sd	s3,56(sp)
 56a:	f852                	sd	s4,48(sp)
 56c:	f456                	sd	s5,40(sp)
 56e:	f05a                	sd	s6,32(sp)
 570:	ec5e                	sd	s7,24(sp)
 572:	e862                	sd	s8,16(sp)
 574:	e466                	sd	s9,8(sp)
 576:	8b2a                	mv	s6,a0
 578:	8a2e                	mv	s4,a1
 57a:	8bb2                	mv	s7,a2
  state = 0;
 57c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 57e:	4901                	li	s2,0
 580:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 582:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 586:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 58a:	06c00c93          	li	s9,108
 58e:	a01d                	j	5b4 <vprintf+0x60>
        putc(fd, c0);
 590:	85a6                	mv	a1,s1
 592:	855a                	mv	a0,s6
 594:	00000097          	auipc	ra,0x0
 598:	f04080e7          	jalr	-252(ra) # 498 <putc>
 59c:	a019                	j	5a2 <vprintf+0x4e>
    } else if(state == '%'){
 59e:	03598363          	beq	s3,s5,5c4 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 5a2:	0019079b          	addiw	a5,s2,1
 5a6:	893e                	mv	s2,a5
 5a8:	873e                	mv	a4,a5
 5aa:	97d2                	add	a5,a5,s4
 5ac:	0007c483          	lbu	s1,0(a5)
 5b0:	24048963          	beqz	s1,802 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 5b4:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5b8:	fe0993e3          	bnez	s3,59e <vprintf+0x4a>
      if(c0 == '%'){
 5bc:	fd579ae3          	bne	a5,s5,590 <vprintf+0x3c>
        state = '%';
 5c0:	89be                	mv	s3,a5
 5c2:	b7c5                	j	5a2 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c4:	00ea06b3          	add	a3,s4,a4
 5c8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5cc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ce:	c681                	beqz	a3,5d6 <vprintf+0x82>
 5d0:	9752                	add	a4,a4,s4
 5d2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5d6:	05878063          	beq	a5,s8,616 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5da:	05978c63          	beq	a5,s9,632 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5de:	07500713          	li	a4,117
 5e2:	10e78063          	beq	a5,a4,6e2 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5e6:	07800713          	li	a4,120
 5ea:	14e78863          	beq	a5,a4,73a <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ee:	07000713          	li	a4,112
 5f2:	18e78163          	beq	a5,a4,774 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5f6:	07300713          	li	a4,115
 5fa:	1ce78663          	beq	a5,a4,7c6 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5fe:	02500713          	li	a4,37
 602:	04e79863          	bne	a5,a4,652 <vprintf+0xfe>
        putc(fd, '%');
 606:	85ba                	mv	a1,a4
 608:	855a                	mv	a0,s6
 60a:	00000097          	auipc	ra,0x0
 60e:	e8e080e7          	jalr	-370(ra) # 498 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 612:	4981                	li	s3,0
 614:	b779                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 616:	008b8493          	addi	s1,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	00000097          	auipc	ra,0x0
 628:	e96080e7          	jalr	-362(ra) # 4ba <printint>
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
 630:	bf8d                	j	5a2 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 632:	06400793          	li	a5,100
 636:	02f68d63          	beq	a3,a5,670 <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63a:	06c00793          	li	a5,108
 63e:	04f68863          	beq	a3,a5,68e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 642:	07500793          	li	a5,117
 646:	0af68c63          	beq	a3,a5,6fe <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 64a:	07800793          	li	a5,120
 64e:	10f68463          	beq	a3,a5,756 <vprintf+0x202>
        putc(fd, '%');
 652:	02500593          	li	a1,37
 656:	855a                	mv	a0,s6
 658:	00000097          	auipc	ra,0x0
 65c:	e40080e7          	jalr	-448(ra) # 498 <putc>
        putc(fd, c0);
 660:	85a6                	mv	a1,s1
 662:	855a                	mv	a0,s6
 664:	00000097          	auipc	ra,0x0
 668:	e34080e7          	jalr	-460(ra) # 498 <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bf15                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 670:	008b8493          	addi	s1,s7,8
 674:	4685                	li	a3,1
 676:	4629                	li	a2,10
 678:	000ba583          	lw	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	00000097          	auipc	ra,0x0
 682:	e3c080e7          	jalr	-452(ra) # 4ba <printint>
        i += 1;
 686:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
        i += 1;
 68c:	bf19                	j	5a2 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68e:	06400793          	li	a5,100
 692:	02f60963          	beq	a2,a5,6c4 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 696:	07500793          	li	a5,117
 69a:	08f60163          	beq	a2,a5,71c <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 69e:	07800793          	li	a5,120
 6a2:	faf618e3          	bne	a2,a5,652 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4641                	li	a2,16
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e06080e7          	jalr	-506(ra) # 4ba <printint>
        i += 2;
 6bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
        i += 2;
 6c2:	b5c5                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4685                	li	a3,1
 6ca:	4629                	li	a2,10
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	00000097          	auipc	ra,0x0
 6d6:	de8080e7          	jalr	-536(ra) # 4ba <printint>
        i += 2;
 6da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6dc:	8ba6                	mv	s7,s1
      state = 0;
 6de:	4981                	li	s3,0
        i += 2;
 6e0:	b5c9                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 6e2:	008b8493          	addi	s1,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4629                	li	a2,10
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	00000097          	auipc	ra,0x0
 6f4:	dca080e7          	jalr	-566(ra) # 4ba <printint>
 6f8:	8ba6                	mv	s7,s1
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b55d                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	008b8493          	addi	s1,s7,8
 702:	4681                	li	a3,0
 704:	4629                	li	a2,10
 706:	000ba583          	lw	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	00000097          	auipc	ra,0x0
 710:	dae080e7          	jalr	-594(ra) # 4ba <printint>
        i += 1;
 714:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 716:	8ba6                	mv	s7,s1
      state = 0;
 718:	4981                	li	s3,0
        i += 1;
 71a:	b561                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71c:	008b8493          	addi	s1,s7,8
 720:	4681                	li	a3,0
 722:	4629                	li	a2,10
 724:	000ba583          	lw	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	00000097          	auipc	ra,0x0
 72e:	d90080e7          	jalr	-624(ra) # 4ba <printint>
        i += 2;
 732:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	8ba6                	mv	s7,s1
      state = 0;
 736:	4981                	li	s3,0
        i += 2;
 738:	b5ad                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 73a:	008b8493          	addi	s1,s7,8
 73e:	4681                	li	a3,0
 740:	4641                	li	a2,16
 742:	000ba583          	lw	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	00000097          	auipc	ra,0x0
 74c:	d72080e7          	jalr	-654(ra) # 4ba <printint>
 750:	8ba6                	mv	s7,s1
      state = 0;
 752:	4981                	li	s3,0
 754:	b5b9                	j	5a2 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 756:	008b8493          	addi	s1,s7,8
 75a:	4681                	li	a3,0
 75c:	4641                	li	a2,16
 75e:	000ba583          	lw	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	00000097          	auipc	ra,0x0
 768:	d56080e7          	jalr	-682(ra) # 4ba <printint>
        i += 1;
 76c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 76e:	8ba6                	mv	s7,s1
      state = 0;
 770:	4981                	li	s3,0
        i += 1;
 772:	bd05                	j	5a2 <vprintf+0x4e>
 774:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 776:	008b8d13          	addi	s10,s7,8
 77a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 77e:	03000593          	li	a1,48
 782:	855a                	mv	a0,s6
 784:	00000097          	auipc	ra,0x0
 788:	d14080e7          	jalr	-748(ra) # 498 <putc>
  putc(fd, 'x');
 78c:	07800593          	li	a1,120
 790:	855a                	mv	a0,s6
 792:	00000097          	auipc	ra,0x0
 796:	d06080e7          	jalr	-762(ra) # 498 <putc>
 79a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79c:	00000b97          	auipc	s7,0x0
 7a0:	2b4b8b93          	addi	s7,s7,692 # a50 <digits>
 7a4:	03c9d793          	srli	a5,s3,0x3c
 7a8:	97de                	add	a5,a5,s7
 7aa:	0007c583          	lbu	a1,0(a5)
 7ae:	855a                	mv	a0,s6
 7b0:	00000097          	auipc	ra,0x0
 7b4:	ce8080e7          	jalr	-792(ra) # 498 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b8:	0992                	slli	s3,s3,0x4
 7ba:	34fd                	addiw	s1,s1,-1
 7bc:	f4e5                	bnez	s1,7a4 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 7be:	8bea                	mv	s7,s10
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	6d02                	ld	s10,0(sp)
 7c4:	bbf9                	j	5a2 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	008b8993          	addi	s3,s7,8
 7ca:	000bb483          	ld	s1,0(s7)
 7ce:	c085                	beqz	s1,7ee <vprintf+0x29a>
        for(; *s; s++)
 7d0:	0004c583          	lbu	a1,0(s1)
 7d4:	c585                	beqz	a1,7fc <vprintf+0x2a8>
          putc(fd, *s);
 7d6:	855a                	mv	a0,s6
 7d8:	00000097          	auipc	ra,0x0
 7dc:	cc0080e7          	jalr	-832(ra) # 498 <putc>
        for(; *s; s++)
 7e0:	0485                	addi	s1,s1,1
 7e2:	0004c583          	lbu	a1,0(s1)
 7e6:	f9e5                	bnez	a1,7d6 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 7e8:	8bce                	mv	s7,s3
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	bb5d                	j	5a2 <vprintf+0x4e>
          s = "(null)";
 7ee:	00000497          	auipc	s1,0x0
 7f2:	25a48493          	addi	s1,s1,602 # a48 <malloc+0x142>
        for(; *s; s++)
 7f6:	02800593          	li	a1,40
 7fa:	bff1                	j	7d6 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 7fc:	8bce                	mv	s7,s3
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b34d                	j	5a2 <vprintf+0x4e>
 802:	6906                	ld	s2,64(sp)
 804:	79e2                	ld	s3,56(sp)
 806:	7a42                	ld	s4,48(sp)
 808:	7aa2                	ld	s5,40(sp)
 80a:	7b02                	ld	s6,32(sp)
 80c:	6be2                	ld	s7,24(sp)
 80e:	6c42                	ld	s8,16(sp)
 810:	6ca2                	ld	s9,8(sp)
    }
  }
}
 812:	60e6                	ld	ra,88(sp)
 814:	6446                	ld	s0,80(sp)
 816:	64a6                	ld	s1,72(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81c:	715d                	addi	sp,sp,-80
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e010                	sd	a2,0(s0)
 826:	e414                	sd	a3,8(s0)
 828:	e818                	sd	a4,16(s0)
 82a:	ec1c                	sd	a5,24(s0)
 82c:	03043023          	sd	a6,32(s0)
 830:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	8622                	mv	a2,s0
 836:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83a:	00000097          	auipc	ra,0x0
 83e:	d1a080e7          	jalr	-742(ra) # 554 <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6161                	addi	sp,sp,80
 848:	8082                	ret

000000000000084a <printf>:

void
printf(const char *fmt, ...)
{
 84a:	711d                	addi	sp,sp,-96
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	e40c                	sd	a1,8(s0)
 854:	e810                	sd	a2,16(s0)
 856:	ec14                	sd	a3,24(s0)
 858:	f018                	sd	a4,32(s0)
 85a:	f41c                	sd	a5,40(s0)
 85c:	03043823          	sd	a6,48(s0)
 860:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 864:	00840613          	addi	a2,s0,8
 868:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 86c:	85aa                	mv	a1,a0
 86e:	4505                	li	a0,1
 870:	00000097          	auipc	ra,0x0
 874:	ce4080e7          	jalr	-796(ra) # 554 <vprintf>
}
 878:	60e2                	ld	ra,24(sp)
 87a:	6442                	ld	s0,16(sp)
 87c:	6125                	addi	sp,sp,96
 87e:	8082                	ret

0000000000000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	1141                	addi	sp,sp,-16
 882:	e406                	sd	ra,8(sp)
 884:	e022                	sd	s0,0(sp)
 886:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 888:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88c:	00000797          	auipc	a5,0x0
 890:	7747b783          	ld	a5,1908(a5) # 1000 <freep>
 894:	a02d                	j	8be <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 896:	4618                	lw	a4,8(a2)
 898:	9f2d                	addw	a4,a4,a1
 89a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	6310                	ld	a2,0(a4)
 8a2:	a83d                	j	8e0 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a4:	ff852703          	lw	a4,-8(a0)
 8a8:	9f31                	addw	a4,a4,a2
 8aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ac:	ff053683          	ld	a3,-16(a0)
 8b0:	a091                	j	8f4 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	6398                	ld	a4,0(a5)
 8b4:	00e7e463          	bltu	a5,a4,8bc <free+0x3c>
 8b8:	00e6ea63          	bltu	a3,a4,8cc <free+0x4c>
{
 8bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	fed7fae3          	bgeu	a5,a3,8b2 <free+0x32>
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e6e463          	bltu	a3,a4,8cc <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c8:	fee7eae3          	bltu	a5,a4,8bc <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8cc:	ff852583          	lw	a1,-8(a0)
 8d0:	6390                	ld	a2,0(a5)
 8d2:	02059813          	slli	a6,a1,0x20
 8d6:	01c85713          	srli	a4,a6,0x1c
 8da:	9736                	add	a4,a4,a3
 8dc:	fae60de3          	beq	a2,a4,896 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e4:	4790                	lw	a2,8(a5)
 8e6:	02061593          	slli	a1,a2,0x20
 8ea:	01c5d713          	srli	a4,a1,0x1c
 8ee:	973e                	add	a4,a4,a5
 8f0:	fae68ae3          	beq	a3,a4,8a4 <free+0x24>
    p->s.ptr = bp->s.ptr;
 8f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f6:	00000717          	auipc	a4,0x0
 8fa:	70f73523          	sd	a5,1802(a4) # 1000 <freep>
}
 8fe:	60a2                	ld	ra,8(sp)
 900:	6402                	ld	s0,0(sp)
 902:	0141                	addi	sp,sp,16
 904:	8082                	ret

0000000000000906 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 906:	7139                	addi	sp,sp,-64
 908:	fc06                	sd	ra,56(sp)
 90a:	f822                	sd	s0,48(sp)
 90c:	f04a                	sd	s2,32(sp)
 90e:	ec4e                	sd	s3,24(sp)
 910:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 912:	02051993          	slli	s3,a0,0x20
 916:	0209d993          	srli	s3,s3,0x20
 91a:	09bd                	addi	s3,s3,15
 91c:	0049d993          	srli	s3,s3,0x4
 920:	2985                	addiw	s3,s3,1
 922:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 924:	00000517          	auipc	a0,0x0
 928:	6dc53503          	ld	a0,1756(a0) # 1000 <freep>
 92c:	c905                	beqz	a0,95c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 930:	4798                	lw	a4,8(a5)
 932:	09377a63          	bgeu	a4,s3,9c6 <malloc+0xc0>
 936:	f426                	sd	s1,40(sp)
 938:	e852                	sd	s4,16(sp)
 93a:	e456                	sd	s5,8(sp)
 93c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 93e:	8a4e                	mv	s4,s3
 940:	6705                	lui	a4,0x1
 942:	00e9f363          	bgeu	s3,a4,948 <malloc+0x42>
 946:	6a05                	lui	s4,0x1
 948:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 94c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 950:	00000497          	auipc	s1,0x0
 954:	6b048493          	addi	s1,s1,1712 # 1000 <freep>
  if(p == (char*)-1)
 958:	5afd                	li	s5,-1
 95a:	a089                	j	99c <malloc+0x96>
 95c:	f426                	sd	s1,40(sp)
 95e:	e852                	sd	s4,16(sp)
 960:	e456                	sd	s5,8(sp)
 962:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 964:	00001797          	auipc	a5,0x1
 968:	8ac78793          	addi	a5,a5,-1876 # 1210 <base>
 96c:	00000717          	auipc	a4,0x0
 970:	68f73a23          	sd	a5,1684(a4) # 1000 <freep>
 974:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 976:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 97a:	b7d1                	j	93e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 97c:	6398                	ld	a4,0(a5)
 97e:	e118                	sd	a4,0(a0)
 980:	a8b9                	j	9de <malloc+0xd8>
  hp->s.size = nu;
 982:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 986:	0541                	addi	a0,a0,16
 988:	00000097          	auipc	ra,0x0
 98c:	ef8080e7          	jalr	-264(ra) # 880 <free>
  return freep;
 990:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 992:	c135                	beqz	a0,9f6 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 994:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 996:	4798                	lw	a4,8(a5)
 998:	03277363          	bgeu	a4,s2,9be <malloc+0xb8>
    if(p == freep)
 99c:	6098                	ld	a4,0(s1)
 99e:	853e                	mv	a0,a5
 9a0:	fef71ae3          	bne	a4,a5,994 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9a4:	8552                	mv	a0,s4
 9a6:	00000097          	auipc	ra,0x0
 9aa:	aca080e7          	jalr	-1334(ra) # 470 <sbrk>
  if(p == (char*)-1)
 9ae:	fd551ae3          	bne	a0,s5,982 <malloc+0x7c>
        return 0;
 9b2:	4501                	li	a0,0
 9b4:	74a2                	ld	s1,40(sp)
 9b6:	6a42                	ld	s4,16(sp)
 9b8:	6aa2                	ld	s5,8(sp)
 9ba:	6b02                	ld	s6,0(sp)
 9bc:	a03d                	j	9ea <malloc+0xe4>
 9be:	74a2                	ld	s1,40(sp)
 9c0:	6a42                	ld	s4,16(sp)
 9c2:	6aa2                	ld	s5,8(sp)
 9c4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9c6:	fae90be3          	beq	s2,a4,97c <malloc+0x76>
        p->s.size -= nunits;
 9ca:	4137073b          	subw	a4,a4,s3
 9ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d0:	02071693          	slli	a3,a4,0x20
 9d4:	01c6d713          	srli	a4,a3,0x1c
 9d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62a73123          	sd	a0,1570(a4) # 1000 <freep>
      return (void*)(p + 1);
 9e6:	01078513          	addi	a0,a5,16
  }
}
 9ea:	70e2                	ld	ra,56(sp)
 9ec:	7442                	ld	s0,48(sp)
 9ee:	7902                	ld	s2,32(sp)
 9f0:	69e2                	ld	s3,24(sp)
 9f2:	6121                	addi	sp,sp,64
 9f4:	8082                	ret
 9f6:	74a2                	ld	s1,40(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	b7f5                	j	9ea <malloc+0xe4>
