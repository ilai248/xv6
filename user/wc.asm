
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
  36:	20000d13          	li	s10,512
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	a34a0a13          	addi	s4,s4,-1484 # a70 <malloc+0x108>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a805                	j	74 <wc+0x74>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	00000097          	auipc	ra,0x0
  4c:	206080e7          	jalr	518(ra) # 24e <strchr>
  50:	c919                	beqz	a0,66 <wc+0x66>
        inword = 0;
  52:	4901                	li	s2,0
    for(i=0; i<n; i++){
  54:	0485                	addi	s1,s1,1
  56:	01348d63          	beq	s1,s3,70 <wc+0x70>
      if(buf[i] == '\n')
  5a:	0004c583          	lbu	a1,0(s1)
  5e:	ff5594e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  62:	2b85                	addiw	s7,s7,1
  64:	b7cd                	j	46 <wc+0x46>
      else if(!inword){
  66:	fe0917e3          	bnez	s2,54 <wc+0x54>
        w++;
  6a:	2c05                	addiw	s8,s8,1
        inword = 1;
  6c:	4905                	li	s2,1
  6e:	b7dd                	j	54 <wc+0x54>
  70:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  74:	866a                	mv	a2,s10
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3e6080e7          	jalr	998(ra) # 462 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
  8a:	00001497          	auipc	s1,0x1
  8e:	f8648493          	addi	s1,s1,-122 # 1010 <buf>
  92:	009b09b3          	add	s3,s6,s1
  96:	b7d1                	j	5a <wc+0x5a>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86e6                	mv	a3,s9
  a2:	8662                	mv	a2,s8
  a4:	85de                	mv	a1,s7
  a6:	00001517          	auipc	a0,0x1
  aa:	9ea50513          	addi	a0,a0,-1558 # a90 <malloc+0x128>
  ae:	00000097          	auipc	ra,0x0
  b2:	7fe080e7          	jalr	2046(ra) # 8ac <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	9ac50513          	addi	a0,a0,-1620 # a80 <malloc+0x118>
  dc:	00000097          	auipc	ra,0x0
  e0:	7d0080e7          	jalr	2000(ra) # 8ac <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	364080e7          	jalr	868(ra) # 44a <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	36e080e7          	jalr	878(ra) # 48a <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	33a080e7          	jalr	826(ra) # 472 <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	302080e7          	jalr	770(ra) # 44a <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	92258593          	addi	a1,a1,-1758 # a78 <malloc+0x110>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2e0080e7          	jalr	736(ra) # 44a <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	92a50513          	addi	a0,a0,-1750 # aa0 <malloc+0x138>
 17e:	00000097          	auipc	ra,0x0
 182:	72e080e7          	jalr	1838(ra) # 8ac <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	2c2080e7          	jalr	706(ra) # 44a <exit>

0000000000000190 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	2a8080e7          	jalr	680(ra) # 44a <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b2:	87aa                	mv	a5,a0
 1b4:	0585                	addi	a1,a1,1
 1b6:	0785                	addi	a5,a5,1
 1b8:	fff5c703          	lbu	a4,-1(a1)
 1bc:	fee78fa3          	sb	a4,-1(a5)
 1c0:	fb75                	bnez	a4,1b4 <strcpy+0xa>
    ;
  return os;
}
 1c2:	60a2                	ld	ra,8(sp)
 1c4:	6402                	ld	s0,0(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb91                	beqz	a5,1ea <strcmp+0x20>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71763          	bne	a4,a5,1ea <strcmp+0x20>
    p++, q++;
 1e0:	0505                	addi	a0,a0,1
 1e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbe5                	bnez	a5,1d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ea:	0005c503          	lbu	a0,0(a1)
}
 1ee:	40a7853b          	subw	a0,a5,a0
 1f2:	60a2                	ld	ra,8(sp)
 1f4:	6402                	ld	s0,0(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <strlen>:

uint
strlen(const char *s)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e406                	sd	ra,8(sp)
 1fe:	e022                	sd	s0,0(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 202:	00054783          	lbu	a5,0(a0)
 206:	cf99                	beqz	a5,224 <strlen+0x2a>
 208:	0505                	addi	a0,a0,1
 20a:	87aa                	mv	a5,a0
 20c:	86be                	mv	a3,a5
 20e:	0785                	addi	a5,a5,1
 210:	fff7c703          	lbu	a4,-1(a5)
 214:	ff65                	bnez	a4,20c <strlen+0x12>
 216:	40a6853b          	subw	a0,a3,a0
 21a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 21c:	60a2                	ld	ra,8(sp)
 21e:	6402                	ld	s0,0(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  for(n = 0; s[n]; n++)
 224:	4501                	li	a0,0
 226:	bfdd                	j	21c <strlen+0x22>

0000000000000228 <memset>:

void*
memset(void *dst, int c, uint n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 230:	ca19                	beqz	a2,246 <memset+0x1e>
 232:	87aa                	mv	a5,a0
 234:	1602                	slli	a2,a2,0x20
 236:	9201                	srli	a2,a2,0x20
 238:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 240:	0785                	addi	a5,a5,1
 242:	fee79de3          	bne	a5,a4,23c <memset+0x14>
  }
  return dst;
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret

000000000000024e <strchr>:

char*
strchr(const char *s, char c)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  for(; *s; s++)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cf81                	beqz	a5,272 <strchr+0x24>
    if(*s == c)
 25c:	00f58763          	beq	a1,a5,26a <strchr+0x1c>
  for(; *s; s++)
 260:	0505                	addi	a0,a0,1
 262:	00054783          	lbu	a5,0(a0)
 266:	fbfd                	bnez	a5,25c <strchr+0xe>
      return (char*)s;
  return 0;
 268:	4501                	li	a0,0
}
 26a:	60a2                	ld	ra,8(sp)
 26c:	6402                	ld	s0,0(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfdd                	j	26a <strchr+0x1c>

0000000000000276 <gets>:

char*
gets(char *buf, int max)
{
 276:	7159                	addi	sp,sp,-112
 278:	f486                	sd	ra,104(sp)
 27a:	f0a2                	sd	s0,96(sp)
 27c:	eca6                	sd	s1,88(sp)
 27e:	e8ca                	sd	s2,80(sp)
 280:	e4ce                	sd	s3,72(sp)
 282:	e0d2                	sd	s4,64(sp)
 284:	fc56                	sd	s5,56(sp)
 286:	f85a                	sd	s6,48(sp)
 288:	f45e                	sd	s7,40(sp)
 28a:	f062                	sd	s8,32(sp)
 28c:	ec66                	sd	s9,24(sp)
 28e:	e86a                	sd	s10,16(sp)
 290:	1880                	addi	s0,sp,112
 292:	8caa                	mv	s9,a0
 294:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 296:	892a                	mv	s2,a0
 298:	4481                	li	s1,0
    cc = read(0, &c, 1);
 29a:	f9f40b13          	addi	s6,s0,-97
 29e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a0:	4ba9                	li	s7,10
 2a2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2a4:	8d26                	mv	s10,s1
 2a6:	0014899b          	addiw	s3,s1,1
 2aa:	84ce                	mv	s1,s3
 2ac:	0349d763          	bge	s3,s4,2da <gets+0x64>
    cc = read(0, &c, 1);
 2b0:	8656                	mv	a2,s5
 2b2:	85da                	mv	a1,s6
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	1ac080e7          	jalr	428(ra) # 462 <read>
    if(cc < 1)
 2be:	00a05e63          	blez	a0,2da <gets+0x64>
    buf[i++] = c;
 2c2:	f9f44783          	lbu	a5,-97(s0)
 2c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ca:	01778763          	beq	a5,s7,2d8 <gets+0x62>
 2ce:	0905                	addi	s2,s2,1
 2d0:	fd879ae3          	bne	a5,s8,2a4 <gets+0x2e>
    buf[i++] = c;
 2d4:	8d4e                	mv	s10,s3
 2d6:	a011                	j	2da <gets+0x64>
 2d8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 2da:	9d66                	add	s10,s10,s9
 2dc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2e0:	8566                	mv	a0,s9
 2e2:	70a6                	ld	ra,104(sp)
 2e4:	7406                	ld	s0,96(sp)
 2e6:	64e6                	ld	s1,88(sp)
 2e8:	6946                	ld	s2,80(sp)
 2ea:	69a6                	ld	s3,72(sp)
 2ec:	6a06                	ld	s4,64(sp)
 2ee:	7ae2                	ld	s5,56(sp)
 2f0:	7b42                	ld	s6,48(sp)
 2f2:	7ba2                	ld	s7,40(sp)
 2f4:	7c02                	ld	s8,32(sp)
 2f6:	6ce2                	ld	s9,24(sp)
 2f8:	6d42                	ld	s10,16(sp)
 2fa:	6165                	addi	sp,sp,112
 2fc:	8082                	ret

00000000000002fe <stat>:

int
stat(const char *n, struct stat *st)
{
 2fe:	1101                	addi	sp,sp,-32
 300:	ec06                	sd	ra,24(sp)
 302:	e822                	sd	s0,16(sp)
 304:	e04a                	sd	s2,0(sp)
 306:	1000                	addi	s0,sp,32
 308:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 30a:	4581                	li	a1,0
 30c:	00000097          	auipc	ra,0x0
 310:	17e080e7          	jalr	382(ra) # 48a <open>
  if(fd < 0)
 314:	02054663          	bltz	a0,340 <stat+0x42>
 318:	e426                	sd	s1,8(sp)
 31a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 31c:	85ca                	mv	a1,s2
 31e:	00000097          	auipc	ra,0x0
 322:	184080e7          	jalr	388(ra) # 4a2 <fstat>
 326:	892a                	mv	s2,a0
  close(fd);
 328:	8526                	mv	a0,s1
 32a:	00000097          	auipc	ra,0x0
 32e:	148080e7          	jalr	328(ra) # 472 <close>
  return r;
 332:	64a2                	ld	s1,8(sp)
}
 334:	854a                	mv	a0,s2
 336:	60e2                	ld	ra,24(sp)
 338:	6442                	ld	s0,16(sp)
 33a:	6902                	ld	s2,0(sp)
 33c:	6105                	addi	sp,sp,32
 33e:	8082                	ret
    return -1;
 340:	597d                	li	s2,-1
 342:	bfcd                	j	334 <stat+0x36>

0000000000000344 <atoi>:

int
atoi(const char *s)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34c:	00054683          	lbu	a3,0(a0)
 350:	fd06879b          	addiw	a5,a3,-48
 354:	0ff7f793          	zext.b	a5,a5
 358:	4625                	li	a2,9
 35a:	02f66963          	bltu	a2,a5,38c <atoi+0x48>
 35e:	872a                	mv	a4,a0
  n = 0;
 360:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 362:	0705                	addi	a4,a4,1
 364:	0025179b          	slliw	a5,a0,0x2
 368:	9fa9                	addw	a5,a5,a0
 36a:	0017979b          	slliw	a5,a5,0x1
 36e:	9fb5                	addw	a5,a5,a3
 370:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 374:	00074683          	lbu	a3,0(a4)
 378:	fd06879b          	addiw	a5,a3,-48
 37c:	0ff7f793          	zext.b	a5,a5
 380:	fef671e3          	bgeu	a2,a5,362 <atoi+0x1e>
  return n;
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  n = 0;
 38c:	4501                	li	a0,0
 38e:	bfdd                	j	384 <atoi+0x40>

0000000000000390 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 398:	02b57563          	bgeu	a0,a1,3c2 <memmove+0x32>
    while(n-- > 0)
 39c:	00c05f63          	blez	a2,3ba <memmove+0x2a>
 3a0:	1602                	slli	a2,a2,0x20
 3a2:	9201                	srli	a2,a2,0x20
 3a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 3aa:	0585                	addi	a1,a1,1
 3ac:	0705                	addi	a4,a4,1
 3ae:	fff5c683          	lbu	a3,-1(a1)
 3b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b6:	fee79ae3          	bne	a5,a4,3aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
    dst += n;
 3c2:	00c50733          	add	a4,a0,a2
    src += n;
 3c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3c8:	fec059e3          	blez	a2,3ba <memmove+0x2a>
 3cc:	fff6079b          	addiw	a5,a2,-1
 3d0:	1782                	slli	a5,a5,0x20
 3d2:	9381                	srli	a5,a5,0x20
 3d4:	fff7c793          	not	a5,a5
 3d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3da:	15fd                	addi	a1,a1,-1
 3dc:	177d                	addi	a4,a4,-1
 3de:	0005c683          	lbu	a3,0(a1)
 3e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e6:	fef71ae3          	bne	a4,a5,3da <memmove+0x4a>
 3ea:	bfc1                	j	3ba <memmove+0x2a>

00000000000003ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f4:	ca0d                	beqz	a2,426 <memcmp+0x3a>
 3f6:	fff6069b          	addiw	a3,a2,-1
 3fa:	1682                	slli	a3,a3,0x20
 3fc:	9281                	srli	a3,a3,0x20
 3fe:	0685                	addi	a3,a3,1
 400:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 402:	00054783          	lbu	a5,0(a0)
 406:	0005c703          	lbu	a4,0(a1)
 40a:	00e79863          	bne	a5,a4,41a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 40e:	0505                	addi	a0,a0,1
    p2++;
 410:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 412:	fed518e3          	bne	a0,a3,402 <memcmp+0x16>
  }
  return 0;
 416:	4501                	li	a0,0
 418:	a019                	j	41e <memcmp+0x32>
      return *p1 - *p2;
 41a:	40e7853b          	subw	a0,a5,a4
}
 41e:	60a2                	ld	ra,8(sp)
 420:	6402                	ld	s0,0(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
  return 0;
 426:	4501                	li	a0,0
 428:	bfdd                	j	41e <memcmp+0x32>

000000000000042a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e406                	sd	ra,8(sp)
 42e:	e022                	sd	s0,0(sp)
 430:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 432:	00000097          	auipc	ra,0x0
 436:	f5e080e7          	jalr	-162(ra) # 390 <memmove>
}
 43a:	60a2                	ld	ra,8(sp)
 43c:	6402                	ld	s0,0(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret

0000000000000442 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 442:	4885                	li	a7,1
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exit>:
.global exit
exit:
 li a7, SYS_exit
 44a:	4889                	li	a7,2
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <wait>:
.global wait
wait:
 li a7, SYS_wait
 452:	488d                	li	a7,3
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45a:	4891                	li	a7,4
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <read>:
.global read
read:
 li a7, SYS_read
 462:	4895                	li	a7,5
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <write>:
.global write
write:
 li a7, SYS_write
 46a:	48c1                	li	a7,16
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <close>:
.global close
close:
 li a7, SYS_close
 472:	48d5                	li	a7,21
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <kill>:
.global kill
kill:
 li a7, SYS_kill
 47a:	4899                	li	a7,6
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <exec>:
.global exec
exec:
 li a7, SYS_exec
 482:	489d                	li	a7,7
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <open>:
.global open
open:
 li a7, SYS_open
 48a:	48bd                	li	a7,15
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 492:	48c5                	li	a7,17
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49a:	48c9                	li	a7,18
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a2:	48a1                	li	a7,8
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <link>:
.global link
link:
 li a7, SYS_link
 4aa:	48cd                	li	a7,19
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b2:	48d1                	li	a7,20
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ba:	48a5                	li	a7,9
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c2:	48a9                	li	a7,10
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ca:	48ad                	li	a7,11
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d2:	48b1                	li	a7,12
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4da:	48b5                	li	a7,13
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e2:	48b9                	li	a7,14
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <trace>:
.global trace
trace:
 li a7, SYS_trace
 4ea:	48d9                	li	a7,22
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4f2:	48dd                	li	a7,23
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fa:	1101                	addi	sp,sp,-32
 4fc:	ec06                	sd	ra,24(sp)
 4fe:	e822                	sd	s0,16(sp)
 500:	1000                	addi	s0,sp,32
 502:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 506:	4605                	li	a2,1
 508:	fef40593          	addi	a1,s0,-17
 50c:	00000097          	auipc	ra,0x0
 510:	f5e080e7          	jalr	-162(ra) # 46a <write>
}
 514:	60e2                	ld	ra,24(sp)
 516:	6442                	ld	s0,16(sp)
 518:	6105                	addi	sp,sp,32
 51a:	8082                	ret

000000000000051c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51c:	7139                	addi	sp,sp,-64
 51e:	fc06                	sd	ra,56(sp)
 520:	f822                	sd	s0,48(sp)
 522:	f426                	sd	s1,40(sp)
 524:	f04a                	sd	s2,32(sp)
 526:	ec4e                	sd	s3,24(sp)
 528:	0080                	addi	s0,sp,64
 52a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52c:	c299                	beqz	a3,532 <printint+0x16>
 52e:	0805c063          	bltz	a1,5ae <printint+0x92>
  neg = 0;
 532:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 534:	fc040313          	addi	t1,s0,-64
  neg = 0;
 538:	869a                	mv	a3,t1
  i = 0;
 53a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 53c:	00000817          	auipc	a6,0x0
 540:	58480813          	addi	a6,a6,1412 # ac0 <digits>
 544:	88be                	mv	a7,a5
 546:	0017851b          	addiw	a0,a5,1
 54a:	87aa                	mv	a5,a0
 54c:	02c5f73b          	remuw	a4,a1,a2
 550:	1702                	slli	a4,a4,0x20
 552:	9301                	srli	a4,a4,0x20
 554:	9742                	add	a4,a4,a6
 556:	00074703          	lbu	a4,0(a4)
 55a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 55e:	872e                	mv	a4,a1
 560:	02c5d5bb          	divuw	a1,a1,a2
 564:	0685                	addi	a3,a3,1
 566:	fcc77fe3          	bgeu	a4,a2,544 <printint+0x28>
  if(neg)
 56a:	000e0c63          	beqz	t3,582 <printint+0x66>
    buf[i++] = '-';
 56e:	fd050793          	addi	a5,a0,-48
 572:	00878533          	add	a0,a5,s0
 576:	02d00793          	li	a5,45
 57a:	fef50823          	sb	a5,-16(a0)
 57e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 582:	fff7899b          	addiw	s3,a5,-1
 586:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 58a:	fff4c583          	lbu	a1,-1(s1)
 58e:	854a                	mv	a0,s2
 590:	00000097          	auipc	ra,0x0
 594:	f6a080e7          	jalr	-150(ra) # 4fa <putc>
  while(--i >= 0)
 598:	39fd                	addiw	s3,s3,-1
 59a:	14fd                	addi	s1,s1,-1
 59c:	fe09d7e3          	bgez	s3,58a <printint+0x6e>
}
 5a0:	70e2                	ld	ra,56(sp)
 5a2:	7442                	ld	s0,48(sp)
 5a4:	74a2                	ld	s1,40(sp)
 5a6:	7902                	ld	s2,32(sp)
 5a8:	69e2                	ld	s3,24(sp)
 5aa:	6121                	addi	sp,sp,64
 5ac:	8082                	ret
    x = -xx;
 5ae:	40b005bb          	negw	a1,a1
    neg = 1;
 5b2:	4e05                	li	t3,1
    x = -xx;
 5b4:	b741                	j	534 <printint+0x18>

00000000000005b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b6:	711d                	addi	sp,sp,-96
 5b8:	ec86                	sd	ra,88(sp)
 5ba:	e8a2                	sd	s0,80(sp)
 5bc:	e4a6                	sd	s1,72(sp)
 5be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c0:	0005c483          	lbu	s1,0(a1)
 5c4:	2a048863          	beqz	s1,874 <vprintf+0x2be>
 5c8:	e0ca                	sd	s2,64(sp)
 5ca:	fc4e                	sd	s3,56(sp)
 5cc:	f852                	sd	s4,48(sp)
 5ce:	f456                	sd	s5,40(sp)
 5d0:	f05a                	sd	s6,32(sp)
 5d2:	ec5e                	sd	s7,24(sp)
 5d4:	e862                	sd	s8,16(sp)
 5d6:	e466                	sd	s9,8(sp)
 5d8:	8b2a                	mv	s6,a0
 5da:	8a2e                	mv	s4,a1
 5dc:	8bb2                	mv	s7,a2
  state = 0;
 5de:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5e0:	4901                	li	s2,0
 5e2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ec:	06c00c93          	li	s9,108
 5f0:	a01d                	j	616 <vprintf+0x60>
        putc(fd, c0);
 5f2:	85a6                	mv	a1,s1
 5f4:	855a                	mv	a0,s6
 5f6:	00000097          	auipc	ra,0x0
 5fa:	f04080e7          	jalr	-252(ra) # 4fa <putc>
 5fe:	a019                	j	604 <vprintf+0x4e>
    } else if(state == '%'){
 600:	03598363          	beq	s3,s5,626 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 604:	0019079b          	addiw	a5,s2,1
 608:	893e                	mv	s2,a5
 60a:	873e                	mv	a4,a5
 60c:	97d2                	add	a5,a5,s4
 60e:	0007c483          	lbu	s1,0(a5)
 612:	24048963          	beqz	s1,864 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 616:	0004879b          	sext.w	a5,s1
    if(state == 0){
 61a:	fe0993e3          	bnez	s3,600 <vprintf+0x4a>
      if(c0 == '%'){
 61e:	fd579ae3          	bne	a5,s5,5f2 <vprintf+0x3c>
        state = '%';
 622:	89be                	mv	s3,a5
 624:	b7c5                	j	604 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 626:	00ea06b3          	add	a3,s4,a4
 62a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 62e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 630:	c681                	beqz	a3,638 <vprintf+0x82>
 632:	9752                	add	a4,a4,s4
 634:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 638:	05878063          	beq	a5,s8,678 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 63c:	05978c63          	beq	a5,s9,694 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 640:	07500713          	li	a4,117
 644:	10e78063          	beq	a5,a4,744 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 648:	07800713          	li	a4,120
 64c:	14e78863          	beq	a5,a4,79c <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 650:	07000713          	li	a4,112
 654:	18e78163          	beq	a5,a4,7d6 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 658:	07300713          	li	a4,115
 65c:	1ce78663          	beq	a5,a4,828 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 660:	02500713          	li	a4,37
 664:	04e79863          	bne	a5,a4,6b4 <vprintf+0xfe>
        putc(fd, '%');
 668:	85ba                	mv	a1,a4
 66a:	855a                	mv	a0,s6
 66c:	00000097          	auipc	ra,0x0
 670:	e8e080e7          	jalr	-370(ra) # 4fa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 674:	4981                	li	s3,0
 676:	b779                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 678:	008b8493          	addi	s1,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	00000097          	auipc	ra,0x0
 68a:	e96080e7          	jalr	-362(ra) # 51c <printint>
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
 692:	bf8d                	j	604 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 694:	06400793          	li	a5,100
 698:	02f68d63          	beq	a3,a5,6d2 <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69c:	06c00793          	li	a5,108
 6a0:	04f68863          	beq	a3,a5,6f0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 6a4:	07500793          	li	a5,117
 6a8:	0af68c63          	beq	a3,a5,760 <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 6ac:	07800793          	li	a5,120
 6b0:	10f68463          	beq	a3,a5,7b8 <vprintf+0x202>
        putc(fd, '%');
 6b4:	02500593          	li	a1,37
 6b8:	855a                	mv	a0,s6
 6ba:	00000097          	auipc	ra,0x0
 6be:	e40080e7          	jalr	-448(ra) # 4fa <putc>
        putc(fd, c0);
 6c2:	85a6                	mv	a1,s1
 6c4:	855a                	mv	a0,s6
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e34080e7          	jalr	-460(ra) # 4fa <putc>
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bf15                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d2:	008b8493          	addi	s1,s7,8
 6d6:	4685                	li	a3,1
 6d8:	4629                	li	a2,10
 6da:	000ba583          	lw	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e3c080e7          	jalr	-452(ra) # 51c <printint>
        i += 1;
 6e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ea:	8ba6                	mv	s7,s1
      state = 0;
 6ec:	4981                	li	s3,0
        i += 1;
 6ee:	bf19                	j	604 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f0:	06400793          	li	a5,100
 6f4:	02f60963          	beq	a2,a5,726 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6f8:	07500793          	li	a5,117
 6fc:	08f60163          	beq	a2,a5,77e <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 700:	07800793          	li	a5,120
 704:	faf618e3          	bne	a2,a5,6b4 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 708:	008b8493          	addi	s1,s7,8
 70c:	4681                	li	a3,0
 70e:	4641                	li	a2,16
 710:	000ba583          	lw	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	00000097          	auipc	ra,0x0
 71a:	e06080e7          	jalr	-506(ra) # 51c <printint>
        i += 2;
 71e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 720:	8ba6                	mv	s7,s1
      state = 0;
 722:	4981                	li	s3,0
        i += 2;
 724:	b5c5                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 726:	008b8493          	addi	s1,s7,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000ba583          	lw	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	00000097          	auipc	ra,0x0
 738:	de8080e7          	jalr	-536(ra) # 51c <printint>
        i += 2;
 73c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
        i += 2;
 742:	b5c9                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	00000097          	auipc	ra,0x0
 756:	dca080e7          	jalr	-566(ra) # 51c <printint>
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b55d                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 760:	008b8493          	addi	s1,s7,8
 764:	4681                	li	a3,0
 766:	4629                	li	a2,10
 768:	000ba583          	lw	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	00000097          	auipc	ra,0x0
 772:	dae080e7          	jalr	-594(ra) # 51c <printint>
        i += 1;
 776:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	8ba6                	mv	s7,s1
      state = 0;
 77a:	4981                	li	s3,0
        i += 1;
 77c:	b561                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 77e:	008b8493          	addi	s1,s7,8
 782:	4681                	li	a3,0
 784:	4629                	li	a2,10
 786:	000ba583          	lw	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	00000097          	auipc	ra,0x0
 790:	d90080e7          	jalr	-624(ra) # 51c <printint>
        i += 2;
 794:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 796:	8ba6                	mv	s7,s1
      state = 0;
 798:	4981                	li	s3,0
        i += 2;
 79a:	b5ad                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 79c:	008b8493          	addi	s1,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4641                	li	a2,16
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	00000097          	auipc	ra,0x0
 7ae:	d72080e7          	jalr	-654(ra) # 51c <printint>
 7b2:	8ba6                	mv	s7,s1
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b5b9                	j	604 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	008b8493          	addi	s1,s7,8
 7bc:	4681                	li	a3,0
 7be:	4641                	li	a2,16
 7c0:	000ba583          	lw	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	00000097          	auipc	ra,0x0
 7ca:	d56080e7          	jalr	-682(ra) # 51c <printint>
        i += 1;
 7ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d0:	8ba6                	mv	s7,s1
      state = 0;
 7d2:	4981                	li	s3,0
        i += 1;
 7d4:	bd05                	j	604 <vprintf+0x4e>
 7d6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7d8:	008b8d13          	addi	s10,s7,8
 7dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e0:	03000593          	li	a1,48
 7e4:	855a                	mv	a0,s6
 7e6:	00000097          	auipc	ra,0x0
 7ea:	d14080e7          	jalr	-748(ra) # 4fa <putc>
  putc(fd, 'x');
 7ee:	07800593          	li	a1,120
 7f2:	855a                	mv	a0,s6
 7f4:	00000097          	auipc	ra,0x0
 7f8:	d06080e7          	jalr	-762(ra) # 4fa <putc>
 7fc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fe:	00000b97          	auipc	s7,0x0
 802:	2c2b8b93          	addi	s7,s7,706 # ac0 <digits>
 806:	03c9d793          	srli	a5,s3,0x3c
 80a:	97de                	add	a5,a5,s7
 80c:	0007c583          	lbu	a1,0(a5)
 810:	855a                	mv	a0,s6
 812:	00000097          	auipc	ra,0x0
 816:	ce8080e7          	jalr	-792(ra) # 4fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 81a:	0992                	slli	s3,s3,0x4
 81c:	34fd                	addiw	s1,s1,-1
 81e:	f4e5                	bnez	s1,806 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 820:	8bea                	mv	s7,s10
      state = 0;
 822:	4981                	li	s3,0
 824:	6d02                	ld	s10,0(sp)
 826:	bbf9                	j	604 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 828:	008b8993          	addi	s3,s7,8
 82c:	000bb483          	ld	s1,0(s7)
 830:	c085                	beqz	s1,850 <vprintf+0x29a>
        for(; *s; s++)
 832:	0004c583          	lbu	a1,0(s1)
 836:	c585                	beqz	a1,85e <vprintf+0x2a8>
          putc(fd, *s);
 838:	855a                	mv	a0,s6
 83a:	00000097          	auipc	ra,0x0
 83e:	cc0080e7          	jalr	-832(ra) # 4fa <putc>
        for(; *s; s++)
 842:	0485                	addi	s1,s1,1
 844:	0004c583          	lbu	a1,0(s1)
 848:	f9e5                	bnez	a1,838 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 84a:	8bce                	mv	s7,s3
      state = 0;
 84c:	4981                	li	s3,0
 84e:	bb5d                	j	604 <vprintf+0x4e>
          s = "(null)";
 850:	00000497          	auipc	s1,0x0
 854:	26848493          	addi	s1,s1,616 # ab8 <malloc+0x150>
        for(; *s; s++)
 858:	02800593          	li	a1,40
 85c:	bff1                	j	838 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 85e:	8bce                	mv	s7,s3
      state = 0;
 860:	4981                	li	s3,0
 862:	b34d                	j	604 <vprintf+0x4e>
 864:	6906                	ld	s2,64(sp)
 866:	79e2                	ld	s3,56(sp)
 868:	7a42                	ld	s4,48(sp)
 86a:	7aa2                	ld	s5,40(sp)
 86c:	7b02                	ld	s6,32(sp)
 86e:	6be2                	ld	s7,24(sp)
 870:	6c42                	ld	s8,16(sp)
 872:	6ca2                	ld	s9,8(sp)
    }
  }
}
 874:	60e6                	ld	ra,88(sp)
 876:	6446                	ld	s0,80(sp)
 878:	64a6                	ld	s1,72(sp)
 87a:	6125                	addi	sp,sp,96
 87c:	8082                	ret

000000000000087e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 87e:	715d                	addi	sp,sp,-80
 880:	ec06                	sd	ra,24(sp)
 882:	e822                	sd	s0,16(sp)
 884:	1000                	addi	s0,sp,32
 886:	e010                	sd	a2,0(s0)
 888:	e414                	sd	a3,8(s0)
 88a:	e818                	sd	a4,16(s0)
 88c:	ec1c                	sd	a5,24(s0)
 88e:	03043023          	sd	a6,32(s0)
 892:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 896:	8622                	mv	a2,s0
 898:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 89c:	00000097          	auipc	ra,0x0
 8a0:	d1a080e7          	jalr	-742(ra) # 5b6 <vprintf>
}
 8a4:	60e2                	ld	ra,24(sp)
 8a6:	6442                	ld	s0,16(sp)
 8a8:	6161                	addi	sp,sp,80
 8aa:	8082                	ret

00000000000008ac <printf>:

void
printf(const char *fmt, ...)
{
 8ac:	711d                	addi	sp,sp,-96
 8ae:	ec06                	sd	ra,24(sp)
 8b0:	e822                	sd	s0,16(sp)
 8b2:	1000                	addi	s0,sp,32
 8b4:	e40c                	sd	a1,8(s0)
 8b6:	e810                	sd	a2,16(s0)
 8b8:	ec14                	sd	a3,24(s0)
 8ba:	f018                	sd	a4,32(s0)
 8bc:	f41c                	sd	a5,40(s0)
 8be:	03043823          	sd	a6,48(s0)
 8c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c6:	00840613          	addi	a2,s0,8
 8ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ce:	85aa                	mv	a1,a0
 8d0:	4505                	li	a0,1
 8d2:	00000097          	auipc	ra,0x0
 8d6:	ce4080e7          	jalr	-796(ra) # 5b6 <vprintf>
}
 8da:	60e2                	ld	ra,24(sp)
 8dc:	6442                	ld	s0,16(sp)
 8de:	6125                	addi	sp,sp,96
 8e0:	8082                	ret

00000000000008e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e2:	1141                	addi	sp,sp,-16
 8e4:	e406                	sd	ra,8(sp)
 8e6:	e022                	sd	s0,0(sp)
 8e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	00000797          	auipc	a5,0x0
 8f2:	7127b783          	ld	a5,1810(a5) # 1000 <freep>
 8f6:	a02d                	j	920 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f8:	4618                	lw	a4,8(a2)
 8fa:	9f2d                	addw	a4,a4,a1
 8fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	6310                	ld	a2,0(a4)
 904:	a83d                	j	942 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 906:	ff852703          	lw	a4,-8(a0)
 90a:	9f31                	addw	a4,a4,a2
 90c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 90e:	ff053683          	ld	a3,-16(a0)
 912:	a091                	j	956 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	6398                	ld	a4,0(a5)
 916:	00e7e463          	bltu	a5,a4,91e <free+0x3c>
 91a:	00e6ea63          	bltu	a3,a4,92e <free+0x4c>
{
 91e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	fed7fae3          	bgeu	a5,a3,914 <free+0x32>
 924:	6398                	ld	a4,0(a5)
 926:	00e6e463          	bltu	a3,a4,92e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	fee7eae3          	bltu	a5,a4,91e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 92e:	ff852583          	lw	a1,-8(a0)
 932:	6390                	ld	a2,0(a5)
 934:	02059813          	slli	a6,a1,0x20
 938:	01c85713          	srli	a4,a6,0x1c
 93c:	9736                	add	a4,a4,a3
 93e:	fae60de3          	beq	a2,a4,8f8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 942:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 946:	4790                	lw	a2,8(a5)
 948:	02061593          	slli	a1,a2,0x20
 94c:	01c5d713          	srli	a4,a1,0x1c
 950:	973e                	add	a4,a4,a5
 952:	fae68ae3          	beq	a3,a4,906 <free+0x24>
    p->s.ptr = bp->s.ptr;
 956:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
}
 960:	60a2                	ld	ra,8(sp)
 962:	6402                	ld	s0,0(sp)
 964:	0141                	addi	sp,sp,16
 966:	8082                	ret

0000000000000968 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 968:	7139                	addi	sp,sp,-64
 96a:	fc06                	sd	ra,56(sp)
 96c:	f822                	sd	s0,48(sp)
 96e:	f04a                	sd	s2,32(sp)
 970:	ec4e                	sd	s3,24(sp)
 972:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 974:	02051993          	slli	s3,a0,0x20
 978:	0209d993          	srli	s3,s3,0x20
 97c:	09bd                	addi	s3,s3,15
 97e:	0049d993          	srli	s3,s3,0x4
 982:	2985                	addiw	s3,s3,1
 984:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 986:	00000517          	auipc	a0,0x0
 98a:	67a53503          	ld	a0,1658(a0) # 1000 <freep>
 98e:	c905                	beqz	a0,9be <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 992:	4798                	lw	a4,8(a5)
 994:	09377a63          	bgeu	a4,s3,a28 <malloc+0xc0>
 998:	f426                	sd	s1,40(sp)
 99a:	e852                	sd	s4,16(sp)
 99c:	e456                	sd	s5,8(sp)
 99e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9a0:	8a4e                	mv	s4,s3
 9a2:	6705                	lui	a4,0x1
 9a4:	00e9f363          	bgeu	s3,a4,9aa <malloc+0x42>
 9a8:	6a05                	lui	s4,0x1
 9aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b2:	00000497          	auipc	s1,0x0
 9b6:	64e48493          	addi	s1,s1,1614 # 1000 <freep>
  if(p == (char*)-1)
 9ba:	5afd                	li	s5,-1
 9bc:	a089                	j	9fe <malloc+0x96>
 9be:	f426                	sd	s1,40(sp)
 9c0:	e852                	sd	s4,16(sp)
 9c2:	e456                	sd	s5,8(sp)
 9c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9c6:	00001797          	auipc	a5,0x1
 9ca:	84a78793          	addi	a5,a5,-1974 # 1210 <base>
 9ce:	00000717          	auipc	a4,0x0
 9d2:	62f73923          	sd	a5,1586(a4) # 1000 <freep>
 9d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9dc:	b7d1                	j	9a0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9de:	6398                	ld	a4,0(a5)
 9e0:	e118                	sd	a4,0(a0)
 9e2:	a8b9                	j	a40 <malloc+0xd8>
  hp->s.size = nu;
 9e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e8:	0541                	addi	a0,a0,16
 9ea:	00000097          	auipc	ra,0x0
 9ee:	ef8080e7          	jalr	-264(ra) # 8e2 <free>
  return freep;
 9f2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9f4:	c135                	beqz	a0,a58 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f8:	4798                	lw	a4,8(a5)
 9fa:	03277363          	bgeu	a4,s2,a20 <malloc+0xb8>
    if(p == freep)
 9fe:	6098                	ld	a4,0(s1)
 a00:	853e                	mv	a0,a5
 a02:	fef71ae3          	bne	a4,a5,9f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a06:	8552                	mv	a0,s4
 a08:	00000097          	auipc	ra,0x0
 a0c:	aca080e7          	jalr	-1334(ra) # 4d2 <sbrk>
  if(p == (char*)-1)
 a10:	fd551ae3          	bne	a0,s5,9e4 <malloc+0x7c>
        return 0;
 a14:	4501                	li	a0,0
 a16:	74a2                	ld	s1,40(sp)
 a18:	6a42                	ld	s4,16(sp)
 a1a:	6aa2                	ld	s5,8(sp)
 a1c:	6b02                	ld	s6,0(sp)
 a1e:	a03d                	j	a4c <malloc+0xe4>
 a20:	74a2                	ld	s1,40(sp)
 a22:	6a42                	ld	s4,16(sp)
 a24:	6aa2                	ld	s5,8(sp)
 a26:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a28:	fae90be3          	beq	s2,a4,9de <malloc+0x76>
        p->s.size -= nunits;
 a2c:	4137073b          	subw	a4,a4,s3
 a30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a32:	02071693          	slli	a3,a4,0x20
 a36:	01c6d713          	srli	a4,a3,0x1c
 a3a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a3c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a40:	00000717          	auipc	a4,0x0
 a44:	5ca73023          	sd	a0,1472(a4) # 1000 <freep>
      return (void*)(p + 1);
 a48:	01078513          	addi	a0,a5,16
  }
}
 a4c:	70e2                	ld	ra,56(sp)
 a4e:	7442                	ld	s0,48(sp)
 a50:	7902                	ld	s2,32(sp)
 a52:	69e2                	ld	s3,24(sp)
 a54:	6121                	addi	sp,sp,64
 a56:	8082                	ret
 a58:	74a2                	ld	s1,40(sp)
 a5a:	6a42                	ld	s4,16(sp)
 a5c:	6aa2                	ld	s5,8(sp)
 a5e:	6b02                	ld	s6,0(sp)
 a60:	b7f5                	j	a4c <malloc+0xe4>
