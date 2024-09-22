
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	35a080e7          	jalr	858(ra) # 366 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	32e080e7          	jalr	814(ra) # 366 <strlen>
  40:	47b5                	li	a5,13
  42:	00a7f863          	bgeu	a5,a0,52 <fmtname+0x52>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  46:	8526                	mv	a0,s1
  48:	70a2                	ld	ra,40(sp)
  4a:	7402                	ld	s0,32(sp)
  4c:	64e2                	ld	s1,24(sp)
  4e:	6145                	addi	sp,sp,48
  50:	8082                	ret
  52:	e84a                	sd	s2,16(sp)
  54:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  56:	8526                	mv	a0,s1
  58:	00000097          	auipc	ra,0x0
  5c:	30e080e7          	jalr	782(ra) # 366 <strlen>
  60:	862a                	mv	a2,a0
  62:	00002997          	auipc	s3,0x2
  66:	fae98993          	addi	s3,s3,-82 # 2010 <buf.0>
  6a:	85a6                	mv	a1,s1
  6c:	854e                	mv	a0,s3
  6e:	00000097          	auipc	ra,0x0
  72:	48e080e7          	jalr	1166(ra) # 4fc <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  76:	8526                	mv	a0,s1
  78:	00000097          	auipc	ra,0x0
  7c:	2ee080e7          	jalr	750(ra) # 366 <strlen>
  80:	892a                	mv	s2,a0
  82:	8526                	mv	a0,s1
  84:	00000097          	auipc	ra,0x0
  88:	2e2080e7          	jalr	738(ra) # 366 <strlen>
  8c:	1902                	slli	s2,s2,0x20
  8e:	02095913          	srli	s2,s2,0x20
  92:	4639                	li	a2,14
  94:	9e09                	subw	a2,a2,a0
  96:	02000593          	li	a1,32
  9a:	01298533          	add	a0,s3,s2
  9e:	00000097          	auipc	ra,0x0
  a2:	2f6080e7          	jalr	758(ra) # 394 <memset>
  return buf;
  a6:	84ce                	mv	s1,s3
  a8:	6942                	ld	s2,16(sp)
  aa:	69a2                	ld	s3,8(sp)
  ac:	bf69                	j	46 <fmtname+0x46>

00000000000000ae <ls>:

void
ls(char *path)
{
  ae:	d7010113          	addi	sp,sp,-656
  b2:	28113423          	sd	ra,648(sp)
  b6:	28813023          	sd	s0,640(sp)
  ba:	27213823          	sd	s2,624(sp)
  be:	0d00                	addi	s0,sp,656
  c0:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  c2:	4581                	li	a1,0
  c4:	00000097          	auipc	ra,0x0
  c8:	532080e7          	jalr	1330(ra) # 5f6 <open>
  cc:	06054b63          	bltz	a0,142 <ls+0x94>
  d0:	26913c23          	sd	s1,632(sp)
  d4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  d6:	d7840593          	addi	a1,s0,-648
  da:	00000097          	auipc	ra,0x0
  de:	534080e7          	jalr	1332(ra) # 60e <fstat>
  e2:	06054b63          	bltz	a0,158 <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  e6:	d8041783          	lh	a5,-640(s0)
  ea:	4705                	li	a4,1
  ec:	08e78863          	beq	a5,a4,17c <ls+0xce>
  f0:	37f9                	addiw	a5,a5,-2
  f2:	17c2                	slli	a5,a5,0x30
  f4:	93c1                	srli	a5,a5,0x30
  f6:	02f76663          	bltu	a4,a5,122 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  fa:	854a                	mv	a0,s2
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <fmtname>
 104:	85aa                	mv	a1,a0
 106:	d8842703          	lw	a4,-632(s0)
 10a:	d7c42683          	lw	a3,-644(s0)
 10e:	d8041603          	lh	a2,-640(s0)
 112:	00001517          	auipc	a0,0x1
 116:	aee50513          	addi	a0,a0,-1298 # c00 <malloc+0x12c>
 11a:	00001097          	auipc	ra,0x1
 11e:	8fe080e7          	jalr	-1794(ra) # a18 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 122:	8526                	mv	a0,s1
 124:	00000097          	auipc	ra,0x0
 128:	4ba080e7          	jalr	1210(ra) # 5de <close>
 12c:	27813483          	ld	s1,632(sp)
}
 130:	28813083          	ld	ra,648(sp)
 134:	28013403          	ld	s0,640(sp)
 138:	27013903          	ld	s2,624(sp)
 13c:	29010113          	addi	sp,sp,656
 140:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 142:	864a                	mv	a2,s2
 144:	00001597          	auipc	a1,0x1
 148:	a8c58593          	addi	a1,a1,-1396 # bd0 <malloc+0xfc>
 14c:	4509                	li	a0,2
 14e:	00001097          	auipc	ra,0x1
 152:	89c080e7          	jalr	-1892(ra) # 9ea <fprintf>
    return;
 156:	bfe9                	j	130 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 158:	864a                	mv	a2,s2
 15a:	00001597          	auipc	a1,0x1
 15e:	a8e58593          	addi	a1,a1,-1394 # be8 <malloc+0x114>
 162:	4509                	li	a0,2
 164:	00001097          	auipc	ra,0x1
 168:	886080e7          	jalr	-1914(ra) # 9ea <fprintf>
    close(fd);
 16c:	8526                	mv	a0,s1
 16e:	00000097          	auipc	ra,0x0
 172:	470080e7          	jalr	1136(ra) # 5de <close>
    return;
 176:	27813483          	ld	s1,632(sp)
 17a:	bf5d                	j	130 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 17c:	854a                	mv	a0,s2
 17e:	00000097          	auipc	ra,0x0
 182:	1e8080e7          	jalr	488(ra) # 366 <strlen>
 186:	2541                	addiw	a0,a0,16
 188:	20000793          	li	a5,512
 18c:	00a7fb63          	bgeu	a5,a0,1a2 <ls+0xf4>
      printf("ls: path too long\n");
 190:	00001517          	auipc	a0,0x1
 194:	a8050513          	addi	a0,a0,-1408 # c10 <malloc+0x13c>
 198:	00001097          	auipc	ra,0x1
 19c:	880080e7          	jalr	-1920(ra) # a18 <printf>
      break;
 1a0:	b749                	j	122 <ls+0x74>
 1a2:	27313423          	sd	s3,616(sp)
 1a6:	27413023          	sd	s4,608(sp)
 1aa:	25513c23          	sd	s5,600(sp)
 1ae:	25613823          	sd	s6,592(sp)
 1b2:	25713423          	sd	s7,584(sp)
 1b6:	25813023          	sd	s8,576(sp)
 1ba:	23913c23          	sd	s9,568(sp)
 1be:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 1c2:	da040993          	addi	s3,s0,-608
 1c6:	85ca                	mv	a1,s2
 1c8:	854e                	mv	a0,s3
 1ca:	00000097          	auipc	ra,0x0
 1ce:	14c080e7          	jalr	332(ra) # 316 <strcpy>
    p = buf+strlen(buf);
 1d2:	854e                	mv	a0,s3
 1d4:	00000097          	auipc	ra,0x0
 1d8:	192080e7          	jalr	402(ra) # 366 <strlen>
 1dc:	1502                	slli	a0,a0,0x20
 1de:	9101                	srli	a0,a0,0x20
 1e0:	99aa                	add	s3,s3,a0
    *p++ = '/';
 1e2:	00198c93          	addi	s9,s3,1
 1e6:	02f00793          	li	a5,47
 1ea:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ee:	d9040a13          	addi	s4,s0,-624
 1f2:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1f4:	d9240c13          	addi	s8,s0,-622
 1f8:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1fa:	d7840b13          	addi	s6,s0,-648
 1fe:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 202:	00001d17          	auipc	s10,0x1
 206:	9fed0d13          	addi	s10,s10,-1538 # c00 <malloc+0x12c>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 20a:	a811                	j	21e <ls+0x170>
        printf("ls: cannot stat %s\n", buf);
 20c:	85d6                	mv	a1,s5
 20e:	00001517          	auipc	a0,0x1
 212:	9da50513          	addi	a0,a0,-1574 # be8 <malloc+0x114>
 216:	00001097          	auipc	ra,0x1
 21a:	802080e7          	jalr	-2046(ra) # a18 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 21e:	864a                	mv	a2,s2
 220:	85d2                	mv	a1,s4
 222:	8526                	mv	a0,s1
 224:	00000097          	auipc	ra,0x0
 228:	3aa080e7          	jalr	938(ra) # 5ce <read>
 22c:	05251863          	bne	a0,s2,27c <ls+0x1ce>
      if(de.inum == 0)
 230:	d9045783          	lhu	a5,-624(s0)
 234:	d7ed                	beqz	a5,21e <ls+0x170>
      memmove(p, de.name, DIRSIZ);
 236:	865e                	mv	a2,s7
 238:	85e2                	mv	a1,s8
 23a:	8566                	mv	a0,s9
 23c:	00000097          	auipc	ra,0x0
 240:	2c0080e7          	jalr	704(ra) # 4fc <memmove>
      p[DIRSIZ] = 0;
 244:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 248:	85da                	mv	a1,s6
 24a:	8556                	mv	a0,s5
 24c:	00000097          	auipc	ra,0x0
 250:	21e080e7          	jalr	542(ra) # 46a <stat>
 254:	fa054ce3          	bltz	a0,20c <ls+0x15e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 258:	8556                	mv	a0,s5
 25a:	00000097          	auipc	ra,0x0
 25e:	da6080e7          	jalr	-602(ra) # 0 <fmtname>
 262:	85aa                	mv	a1,a0
 264:	d8842703          	lw	a4,-632(s0)
 268:	d7c42683          	lw	a3,-644(s0)
 26c:	d8041603          	lh	a2,-640(s0)
 270:	856a                	mv	a0,s10
 272:	00000097          	auipc	ra,0x0
 276:	7a6080e7          	jalr	1958(ra) # a18 <printf>
 27a:	b755                	j	21e <ls+0x170>
 27c:	26813983          	ld	s3,616(sp)
 280:	26013a03          	ld	s4,608(sp)
 284:	25813a83          	ld	s5,600(sp)
 288:	25013b03          	ld	s6,592(sp)
 28c:	24813b83          	ld	s7,584(sp)
 290:	24013c03          	ld	s8,576(sp)
 294:	23813c83          	ld	s9,568(sp)
 298:	23013d03          	ld	s10,560(sp)
 29c:	b559                	j	122 <ls+0x74>

000000000000029e <main>:

int
main(int argc, char *argv[])
{
 29e:	1101                	addi	sp,sp,-32
 2a0:	ec06                	sd	ra,24(sp)
 2a2:	e822                	sd	s0,16(sp)
 2a4:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 2a6:	4785                	li	a5,1
 2a8:	02a7db63          	bge	a5,a0,2de <main+0x40>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	e04a                	sd	s2,0(sp)
 2b0:	00858493          	addi	s1,a1,8
 2b4:	ffe5091b          	addiw	s2,a0,-2
 2b8:	02091793          	slli	a5,s2,0x20
 2bc:	01d7d913          	srli	s2,a5,0x1d
 2c0:	05c1                	addi	a1,a1,16
 2c2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2c4:	6088                	ld	a0,0(s1)
 2c6:	00000097          	auipc	ra,0x0
 2ca:	de8080e7          	jalr	-536(ra) # ae <ls>
  for(i=1; i<argc; i++)
 2ce:	04a1                	addi	s1,s1,8
 2d0:	ff249ae3          	bne	s1,s2,2c4 <main+0x26>
  exit(0);
 2d4:	4501                	li	a0,0
 2d6:	00000097          	auipc	ra,0x0
 2da:	2e0080e7          	jalr	736(ra) # 5b6 <exit>
 2de:	e426                	sd	s1,8(sp)
 2e0:	e04a                	sd	s2,0(sp)
    ls(".");
 2e2:	00001517          	auipc	a0,0x1
 2e6:	94650513          	addi	a0,a0,-1722 # c28 <malloc+0x154>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	dc4080e7          	jalr	-572(ra) # ae <ls>
    exit(0);
 2f2:	4501                	li	a0,0
 2f4:	00000097          	auipc	ra,0x0
 2f8:	2c2080e7          	jalr	706(ra) # 5b6 <exit>

00000000000002fc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  extern int main();
  main();
 304:	00000097          	auipc	ra,0x0
 308:	f9a080e7          	jalr	-102(ra) # 29e <main>
  exit(0);
 30c:	4501                	li	a0,0
 30e:	00000097          	auipc	ra,0x0
 312:	2a8080e7          	jalr	680(ra) # 5b6 <exit>

0000000000000316 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 31e:	87aa                	mv	a5,a0
 320:	0585                	addi	a1,a1,1
 322:	0785                	addi	a5,a5,1
 324:	fff5c703          	lbu	a4,-1(a1)
 328:	fee78fa3          	sb	a4,-1(a5)
 32c:	fb75                	bnez	a4,320 <strcpy+0xa>
    ;
  return os;
}
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cb91                	beqz	a5,356 <strcmp+0x20>
 344:	0005c703          	lbu	a4,0(a1)
 348:	00f71763          	bne	a4,a5,356 <strcmp+0x20>
    p++, q++;
 34c:	0505                	addi	a0,a0,1
 34e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 350:	00054783          	lbu	a5,0(a0)
 354:	fbe5                	bnez	a5,344 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 356:	0005c503          	lbu	a0,0(a1)
}
 35a:	40a7853b          	subw	a0,a5,a0
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <strlen>:

uint
strlen(const char *s)
{
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cf99                	beqz	a5,390 <strlen+0x2a>
 374:	0505                	addi	a0,a0,1
 376:	87aa                	mv	a5,a0
 378:	86be                	mv	a3,a5
 37a:	0785                	addi	a5,a5,1
 37c:	fff7c703          	lbu	a4,-1(a5)
 380:	ff65                	bnez	a4,378 <strlen+0x12>
 382:	40a6853b          	subw	a0,a3,a0
 386:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  for(n = 0; s[n]; n++)
 390:	4501                	li	a0,0
 392:	bfdd                	j	388 <strlen+0x22>

0000000000000394 <memset>:

void*
memset(void *dst, int c, uint n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 39c:	ca19                	beqz	a2,3b2 <memset+0x1e>
 39e:	87aa                	mv	a5,a0
 3a0:	1602                	slli	a2,a2,0x20
 3a2:	9201                	srli	a2,a2,0x20
 3a4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3ac:	0785                	addi	a5,a5,1
 3ae:	fee79de3          	bne	a5,a4,3a8 <memset+0x14>
  }
  return dst;
}
 3b2:	60a2                	ld	ra,8(sp)
 3b4:	6402                	ld	s0,0(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret

00000000000003ba <strchr>:

char*
strchr(const char *s, char c)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3c2:	00054783          	lbu	a5,0(a0)
 3c6:	cf81                	beqz	a5,3de <strchr+0x24>
    if(*s == c)
 3c8:	00f58763          	beq	a1,a5,3d6 <strchr+0x1c>
  for(; *s; s++)
 3cc:	0505                	addi	a0,a0,1
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	fbfd                	bnez	a5,3c8 <strchr+0xe>
      return (char*)s;
  return 0;
 3d4:	4501                	li	a0,0
}
 3d6:	60a2                	ld	ra,8(sp)
 3d8:	6402                	ld	s0,0(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfdd                	j	3d6 <strchr+0x1c>

00000000000003e2 <gets>:

char*
gets(char *buf, int max)
{
 3e2:	7159                	addi	sp,sp,-112
 3e4:	f486                	sd	ra,104(sp)
 3e6:	f0a2                	sd	s0,96(sp)
 3e8:	eca6                	sd	s1,88(sp)
 3ea:	e8ca                	sd	s2,80(sp)
 3ec:	e4ce                	sd	s3,72(sp)
 3ee:	e0d2                	sd	s4,64(sp)
 3f0:	fc56                	sd	s5,56(sp)
 3f2:	f85a                	sd	s6,48(sp)
 3f4:	f45e                	sd	s7,40(sp)
 3f6:	f062                	sd	s8,32(sp)
 3f8:	ec66                	sd	s9,24(sp)
 3fa:	e86a                	sd	s10,16(sp)
 3fc:	1880                	addi	s0,sp,112
 3fe:	8caa                	mv	s9,a0
 400:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 402:	892a                	mv	s2,a0
 404:	4481                	li	s1,0
    cc = read(0, &c, 1);
 406:	f9f40b13          	addi	s6,s0,-97
 40a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 40c:	4ba9                	li	s7,10
 40e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 410:	8d26                	mv	s10,s1
 412:	0014899b          	addiw	s3,s1,1
 416:	84ce                	mv	s1,s3
 418:	0349d763          	bge	s3,s4,446 <gets+0x64>
    cc = read(0, &c, 1);
 41c:	8656                	mv	a2,s5
 41e:	85da                	mv	a1,s6
 420:	4501                	li	a0,0
 422:	00000097          	auipc	ra,0x0
 426:	1ac080e7          	jalr	428(ra) # 5ce <read>
    if(cc < 1)
 42a:	00a05e63          	blez	a0,446 <gets+0x64>
    buf[i++] = c;
 42e:	f9f44783          	lbu	a5,-97(s0)
 432:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 436:	01778763          	beq	a5,s7,444 <gets+0x62>
 43a:	0905                	addi	s2,s2,1
 43c:	fd879ae3          	bne	a5,s8,410 <gets+0x2e>
    buf[i++] = c;
 440:	8d4e                	mv	s10,s3
 442:	a011                	j	446 <gets+0x64>
 444:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 446:	9d66                	add	s10,s10,s9
 448:	000d0023          	sb	zero,0(s10)
  return buf;
}
 44c:	8566                	mv	a0,s9
 44e:	70a6                	ld	ra,104(sp)
 450:	7406                	ld	s0,96(sp)
 452:	64e6                	ld	s1,88(sp)
 454:	6946                	ld	s2,80(sp)
 456:	69a6                	ld	s3,72(sp)
 458:	6a06                	ld	s4,64(sp)
 45a:	7ae2                	ld	s5,56(sp)
 45c:	7b42                	ld	s6,48(sp)
 45e:	7ba2                	ld	s7,40(sp)
 460:	7c02                	ld	s8,32(sp)
 462:	6ce2                	ld	s9,24(sp)
 464:	6d42                	ld	s10,16(sp)
 466:	6165                	addi	sp,sp,112
 468:	8082                	ret

000000000000046a <stat>:

int
stat(const char *n, struct stat *st)
{
 46a:	1101                	addi	sp,sp,-32
 46c:	ec06                	sd	ra,24(sp)
 46e:	e822                	sd	s0,16(sp)
 470:	e04a                	sd	s2,0(sp)
 472:	1000                	addi	s0,sp,32
 474:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 476:	4581                	li	a1,0
 478:	00000097          	auipc	ra,0x0
 47c:	17e080e7          	jalr	382(ra) # 5f6 <open>
  if(fd < 0)
 480:	02054663          	bltz	a0,4ac <stat+0x42>
 484:	e426                	sd	s1,8(sp)
 486:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 488:	85ca                	mv	a1,s2
 48a:	00000097          	auipc	ra,0x0
 48e:	184080e7          	jalr	388(ra) # 60e <fstat>
 492:	892a                	mv	s2,a0
  close(fd);
 494:	8526                	mv	a0,s1
 496:	00000097          	auipc	ra,0x0
 49a:	148080e7          	jalr	328(ra) # 5de <close>
  return r;
 49e:	64a2                	ld	s1,8(sp)
}
 4a0:	854a                	mv	a0,s2
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	6902                	ld	s2,0(sp)
 4a8:	6105                	addi	sp,sp,32
 4aa:	8082                	ret
    return -1;
 4ac:	597d                	li	s2,-1
 4ae:	bfcd                	j	4a0 <stat+0x36>

00000000000004b0 <atoi>:

int
atoi(const char *s)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e406                	sd	ra,8(sp)
 4b4:	e022                	sd	s0,0(sp)
 4b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b8:	00054683          	lbu	a3,0(a0)
 4bc:	fd06879b          	addiw	a5,a3,-48
 4c0:	0ff7f793          	zext.b	a5,a5
 4c4:	4625                	li	a2,9
 4c6:	02f66963          	bltu	a2,a5,4f8 <atoi+0x48>
 4ca:	872a                	mv	a4,a0
  n = 0;
 4cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ce:	0705                	addi	a4,a4,1
 4d0:	0025179b          	slliw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	slliw	a5,a5,0x1
 4da:	9fb5                	addw	a5,a5,a3
 4dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e0:	00074683          	lbu	a3,0(a4)
 4e4:	fd06879b          	addiw	a5,a3,-48
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	fef671e3          	bgeu	a2,a5,4ce <atoi+0x1e>
  return n;
}
 4f0:	60a2                	ld	ra,8(sp)
 4f2:	6402                	ld	s0,0(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret
  n = 0;
 4f8:	4501                	li	a0,0
 4fa:	bfdd                	j	4f0 <atoi+0x40>

00000000000004fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e406                	sd	ra,8(sp)
 500:	e022                	sd	s0,0(sp)
 502:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 504:	02b57563          	bgeu	a0,a1,52e <memmove+0x32>
    while(n-- > 0)
 508:	00c05f63          	blez	a2,526 <memmove+0x2a>
 50c:	1602                	slli	a2,a2,0x20
 50e:	9201                	srli	a2,a2,0x20
 510:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 514:	872a                	mv	a4,a0
      *dst++ = *src++;
 516:	0585                	addi	a1,a1,1
 518:	0705                	addi	a4,a4,1
 51a:	fff5c683          	lbu	a3,-1(a1)
 51e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 522:	fee79ae3          	bne	a5,a4,516 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 526:	60a2                	ld	ra,8(sp)
 528:	6402                	ld	s0,0(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret
    dst += n;
 52e:	00c50733          	add	a4,a0,a2
    src += n;
 532:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 534:	fec059e3          	blez	a2,526 <memmove+0x2a>
 538:	fff6079b          	addiw	a5,a2,-1
 53c:	1782                	slli	a5,a5,0x20
 53e:	9381                	srli	a5,a5,0x20
 540:	fff7c793          	not	a5,a5
 544:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 546:	15fd                	addi	a1,a1,-1
 548:	177d                	addi	a4,a4,-1
 54a:	0005c683          	lbu	a3,0(a1)
 54e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 552:	fef71ae3          	bne	a4,a5,546 <memmove+0x4a>
 556:	bfc1                	j	526 <memmove+0x2a>

0000000000000558 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 558:	1141                	addi	sp,sp,-16
 55a:	e406                	sd	ra,8(sp)
 55c:	e022                	sd	s0,0(sp)
 55e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 560:	ca0d                	beqz	a2,592 <memcmp+0x3a>
 562:	fff6069b          	addiw	a3,a2,-1
 566:	1682                	slli	a3,a3,0x20
 568:	9281                	srli	a3,a3,0x20
 56a:	0685                	addi	a3,a3,1
 56c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 56e:	00054783          	lbu	a5,0(a0)
 572:	0005c703          	lbu	a4,0(a1)
 576:	00e79863          	bne	a5,a4,586 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 57a:	0505                	addi	a0,a0,1
    p2++;
 57c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 57e:	fed518e3          	bne	a0,a3,56e <memcmp+0x16>
  }
  return 0;
 582:	4501                	li	a0,0
 584:	a019                	j	58a <memcmp+0x32>
      return *p1 - *p2;
 586:	40e7853b          	subw	a0,a5,a4
}
 58a:	60a2                	ld	ra,8(sp)
 58c:	6402                	ld	s0,0(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret
  return 0;
 592:	4501                	li	a0,0
 594:	bfdd                	j	58a <memcmp+0x32>

0000000000000596 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 596:	1141                	addi	sp,sp,-16
 598:	e406                	sd	ra,8(sp)
 59a:	e022                	sd	s0,0(sp)
 59c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 59e:	00000097          	auipc	ra,0x0
 5a2:	f5e080e7          	jalr	-162(ra) # 4fc <memmove>
}
 5a6:	60a2                	ld	ra,8(sp)
 5a8:	6402                	ld	s0,0(sp)
 5aa:	0141                	addi	sp,sp,16
 5ac:	8082                	ret

00000000000005ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5ae:	4885                	li	a7,1
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5b6:	4889                	li	a7,2
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <wait>:
.global wait
wait:
 li a7, SYS_wait
 5be:	488d                	li	a7,3
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5c6:	4891                	li	a7,4
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <read>:
.global read
read:
 li a7, SYS_read
 5ce:	4895                	li	a7,5
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <write>:
.global write
write:
 li a7, SYS_write
 5d6:	48c1                	li	a7,16
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <close>:
.global close
close:
 li a7, SYS_close
 5de:	48d5                	li	a7,21
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5e6:	4899                	li	a7,6
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ee:	489d                	li	a7,7
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <open>:
.global open
open:
 li a7, SYS_open
 5f6:	48bd                	li	a7,15
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5fe:	48c5                	li	a7,17
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 606:	48c9                	li	a7,18
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 60e:	48a1                	li	a7,8
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <link>:
.global link
link:
 li a7, SYS_link
 616:	48cd                	li	a7,19
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 61e:	48d1                	li	a7,20
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 626:	48a5                	li	a7,9
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <dup>:
.global dup
dup:
 li a7, SYS_dup
 62e:	48a9                	li	a7,10
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 636:	48ad                	li	a7,11
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 63e:	48b1                	li	a7,12
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 646:	48b5                	li	a7,13
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 64e:	48b9                	li	a7,14
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <trace>:
.global trace
trace:
 li a7, SYS_trace
 656:	48d9                	li	a7,22
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 65e:	48dd                	li	a7,23
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 666:	1101                	addi	sp,sp,-32
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 672:	4605                	li	a2,1
 674:	fef40593          	addi	a1,s0,-17
 678:	00000097          	auipc	ra,0x0
 67c:	f5e080e7          	jalr	-162(ra) # 5d6 <write>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6105                	addi	sp,sp,32
 686:	8082                	ret

0000000000000688 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 688:	7139                	addi	sp,sp,-64
 68a:	fc06                	sd	ra,56(sp)
 68c:	f822                	sd	s0,48(sp)
 68e:	f426                	sd	s1,40(sp)
 690:	f04a                	sd	s2,32(sp)
 692:	ec4e                	sd	s3,24(sp)
 694:	0080                	addi	s0,sp,64
 696:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 698:	c299                	beqz	a3,69e <printint+0x16>
 69a:	0805c063          	bltz	a1,71a <printint+0x92>
  neg = 0;
 69e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6a0:	fc040313          	addi	t1,s0,-64
  neg = 0;
 6a4:	869a                	mv	a3,t1
  i = 0;
 6a6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6a8:	00000817          	auipc	a6,0x0
 6ac:	59080813          	addi	a6,a6,1424 # c38 <digits>
 6b0:	88be                	mv	a7,a5
 6b2:	0017851b          	addiw	a0,a5,1
 6b6:	87aa                	mv	a5,a0
 6b8:	02c5f73b          	remuw	a4,a1,a2
 6bc:	1702                	slli	a4,a4,0x20
 6be:	9301                	srli	a4,a4,0x20
 6c0:	9742                	add	a4,a4,a6
 6c2:	00074703          	lbu	a4,0(a4)
 6c6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6ca:	872e                	mv	a4,a1
 6cc:	02c5d5bb          	divuw	a1,a1,a2
 6d0:	0685                	addi	a3,a3,1
 6d2:	fcc77fe3          	bgeu	a4,a2,6b0 <printint+0x28>
  if(neg)
 6d6:	000e0c63          	beqz	t3,6ee <printint+0x66>
    buf[i++] = '-';
 6da:	fd050793          	addi	a5,a0,-48
 6de:	00878533          	add	a0,a5,s0
 6e2:	02d00793          	li	a5,45
 6e6:	fef50823          	sb	a5,-16(a0)
 6ea:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6ee:	fff7899b          	addiw	s3,a5,-1
 6f2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6f6:	fff4c583          	lbu	a1,-1(s1)
 6fa:	854a                	mv	a0,s2
 6fc:	00000097          	auipc	ra,0x0
 700:	f6a080e7          	jalr	-150(ra) # 666 <putc>
  while(--i >= 0)
 704:	39fd                	addiw	s3,s3,-1
 706:	14fd                	addi	s1,s1,-1
 708:	fe09d7e3          	bgez	s3,6f6 <printint+0x6e>
}
 70c:	70e2                	ld	ra,56(sp)
 70e:	7442                	ld	s0,48(sp)
 710:	74a2                	ld	s1,40(sp)
 712:	7902                	ld	s2,32(sp)
 714:	69e2                	ld	s3,24(sp)
 716:	6121                	addi	sp,sp,64
 718:	8082                	ret
    x = -xx;
 71a:	40b005bb          	negw	a1,a1
    neg = 1;
 71e:	4e05                	li	t3,1
    x = -xx;
 720:	b741                	j	6a0 <printint+0x18>

0000000000000722 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 722:	711d                	addi	sp,sp,-96
 724:	ec86                	sd	ra,88(sp)
 726:	e8a2                	sd	s0,80(sp)
 728:	e4a6                	sd	s1,72(sp)
 72a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 72c:	0005c483          	lbu	s1,0(a1)
 730:	2a048863          	beqz	s1,9e0 <vprintf+0x2be>
 734:	e0ca                	sd	s2,64(sp)
 736:	fc4e                	sd	s3,56(sp)
 738:	f852                	sd	s4,48(sp)
 73a:	f456                	sd	s5,40(sp)
 73c:	f05a                	sd	s6,32(sp)
 73e:	ec5e                	sd	s7,24(sp)
 740:	e862                	sd	s8,16(sp)
 742:	e466                	sd	s9,8(sp)
 744:	8b2a                	mv	s6,a0
 746:	8a2e                	mv	s4,a1
 748:	8bb2                	mv	s7,a2
  state = 0;
 74a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 74c:	4901                	li	s2,0
 74e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 750:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 754:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 758:	06c00c93          	li	s9,108
 75c:	a01d                	j	782 <vprintf+0x60>
        putc(fd, c0);
 75e:	85a6                	mv	a1,s1
 760:	855a                	mv	a0,s6
 762:	00000097          	auipc	ra,0x0
 766:	f04080e7          	jalr	-252(ra) # 666 <putc>
 76a:	a019                	j	770 <vprintf+0x4e>
    } else if(state == '%'){
 76c:	03598363          	beq	s3,s5,792 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 770:	0019079b          	addiw	a5,s2,1
 774:	893e                	mv	s2,a5
 776:	873e                	mv	a4,a5
 778:	97d2                	add	a5,a5,s4
 77a:	0007c483          	lbu	s1,0(a5)
 77e:	24048963          	beqz	s1,9d0 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 782:	0004879b          	sext.w	a5,s1
    if(state == 0){
 786:	fe0993e3          	bnez	s3,76c <vprintf+0x4a>
      if(c0 == '%'){
 78a:	fd579ae3          	bne	a5,s5,75e <vprintf+0x3c>
        state = '%';
 78e:	89be                	mv	s3,a5
 790:	b7c5                	j	770 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 792:	00ea06b3          	add	a3,s4,a4
 796:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 79a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 79c:	c681                	beqz	a3,7a4 <vprintf+0x82>
 79e:	9752                	add	a4,a4,s4
 7a0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7a4:	05878063          	beq	a5,s8,7e4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 7a8:	05978c63          	beq	a5,s9,800 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7ac:	07500713          	li	a4,117
 7b0:	10e78063          	beq	a5,a4,8b0 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7b4:	07800713          	li	a4,120
 7b8:	14e78863          	beq	a5,a4,908 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7bc:	07000713          	li	a4,112
 7c0:	18e78163          	beq	a5,a4,942 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7c4:	07300713          	li	a4,115
 7c8:	1ce78663          	beq	a5,a4,994 <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7cc:	02500713          	li	a4,37
 7d0:	04e79863          	bne	a5,a4,820 <vprintf+0xfe>
        putc(fd, '%');
 7d4:	85ba                	mv	a1,a4
 7d6:	855a                	mv	a0,s6
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e8e080e7          	jalr	-370(ra) # 666 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b779                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 7e4:	008b8493          	addi	s1,s7,8
 7e8:	4685                	li	a3,1
 7ea:	4629                	li	a2,10
 7ec:	000ba583          	lw	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e96080e7          	jalr	-362(ra) # 688 <printint>
 7fa:	8ba6                	mv	s7,s1
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bf8d                	j	770 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 800:	06400793          	li	a5,100
 804:	02f68d63          	beq	a3,a5,83e <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 808:	06c00793          	li	a5,108
 80c:	04f68863          	beq	a3,a5,85c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 810:	07500793          	li	a5,117
 814:	0af68c63          	beq	a3,a5,8cc <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 818:	07800793          	li	a5,120
 81c:	10f68463          	beq	a3,a5,924 <vprintf+0x202>
        putc(fd, '%');
 820:	02500593          	li	a1,37
 824:	855a                	mv	a0,s6
 826:	00000097          	auipc	ra,0x0
 82a:	e40080e7          	jalr	-448(ra) # 666 <putc>
        putc(fd, c0);
 82e:	85a6                	mv	a1,s1
 830:	855a                	mv	a0,s6
 832:	00000097          	auipc	ra,0x0
 836:	e34080e7          	jalr	-460(ra) # 666 <putc>
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bf15                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 83e:	008b8493          	addi	s1,s7,8
 842:	4685                	li	a3,1
 844:	4629                	li	a2,10
 846:	000ba583          	lw	a1,0(s7)
 84a:	855a                	mv	a0,s6
 84c:	00000097          	auipc	ra,0x0
 850:	e3c080e7          	jalr	-452(ra) # 688 <printint>
        i += 1;
 854:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 856:	8ba6                	mv	s7,s1
      state = 0;
 858:	4981                	li	s3,0
        i += 1;
 85a:	bf19                	j	770 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 85c:	06400793          	li	a5,100
 860:	02f60963          	beq	a2,a5,892 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 864:	07500793          	li	a5,117
 868:	08f60163          	beq	a2,a5,8ea <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 86c:	07800793          	li	a5,120
 870:	faf618e3          	bne	a2,a5,820 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 874:	008b8493          	addi	s1,s7,8
 878:	4681                	li	a3,0
 87a:	4641                	li	a2,16
 87c:	000ba583          	lw	a1,0(s7)
 880:	855a                	mv	a0,s6
 882:	00000097          	auipc	ra,0x0
 886:	e06080e7          	jalr	-506(ra) # 688 <printint>
        i += 2;
 88a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 88c:	8ba6                	mv	s7,s1
      state = 0;
 88e:	4981                	li	s3,0
        i += 2;
 890:	b5c5                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 892:	008b8493          	addi	s1,s7,8
 896:	4685                	li	a3,1
 898:	4629                	li	a2,10
 89a:	000ba583          	lw	a1,0(s7)
 89e:	855a                	mv	a0,s6
 8a0:	00000097          	auipc	ra,0x0
 8a4:	de8080e7          	jalr	-536(ra) # 688 <printint>
        i += 2;
 8a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8aa:	8ba6                	mv	s7,s1
      state = 0;
 8ac:	4981                	li	s3,0
        i += 2;
 8ae:	b5c9                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 8b0:	008b8493          	addi	s1,s7,8
 8b4:	4681                	li	a3,0
 8b6:	4629                	li	a2,10
 8b8:	000ba583          	lw	a1,0(s7)
 8bc:	855a                	mv	a0,s6
 8be:	00000097          	auipc	ra,0x0
 8c2:	dca080e7          	jalr	-566(ra) # 688 <printint>
 8c6:	8ba6                	mv	s7,s1
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	b55d                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8cc:	008b8493          	addi	s1,s7,8
 8d0:	4681                	li	a3,0
 8d2:	4629                	li	a2,10
 8d4:	000ba583          	lw	a1,0(s7)
 8d8:	855a                	mv	a0,s6
 8da:	00000097          	auipc	ra,0x0
 8de:	dae080e7          	jalr	-594(ra) # 688 <printint>
        i += 1;
 8e2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e4:	8ba6                	mv	s7,s1
      state = 0;
 8e6:	4981                	li	s3,0
        i += 1;
 8e8:	b561                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ea:	008b8493          	addi	s1,s7,8
 8ee:	4681                	li	a3,0
 8f0:	4629                	li	a2,10
 8f2:	000ba583          	lw	a1,0(s7)
 8f6:	855a                	mv	a0,s6
 8f8:	00000097          	auipc	ra,0x0
 8fc:	d90080e7          	jalr	-624(ra) # 688 <printint>
        i += 2;
 900:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 902:	8ba6                	mv	s7,s1
      state = 0;
 904:	4981                	li	s3,0
        i += 2;
 906:	b5ad                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 908:	008b8493          	addi	s1,s7,8
 90c:	4681                	li	a3,0
 90e:	4641                	li	a2,16
 910:	000ba583          	lw	a1,0(s7)
 914:	855a                	mv	a0,s6
 916:	00000097          	auipc	ra,0x0
 91a:	d72080e7          	jalr	-654(ra) # 688 <printint>
 91e:	8ba6                	mv	s7,s1
      state = 0;
 920:	4981                	li	s3,0
 922:	b5b9                	j	770 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 924:	008b8493          	addi	s1,s7,8
 928:	4681                	li	a3,0
 92a:	4641                	li	a2,16
 92c:	000ba583          	lw	a1,0(s7)
 930:	855a                	mv	a0,s6
 932:	00000097          	auipc	ra,0x0
 936:	d56080e7          	jalr	-682(ra) # 688 <printint>
        i += 1;
 93a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 93c:	8ba6                	mv	s7,s1
      state = 0;
 93e:	4981                	li	s3,0
        i += 1;
 940:	bd05                	j	770 <vprintf+0x4e>
 942:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 944:	008b8d13          	addi	s10,s7,8
 948:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 94c:	03000593          	li	a1,48
 950:	855a                	mv	a0,s6
 952:	00000097          	auipc	ra,0x0
 956:	d14080e7          	jalr	-748(ra) # 666 <putc>
  putc(fd, 'x');
 95a:	07800593          	li	a1,120
 95e:	855a                	mv	a0,s6
 960:	00000097          	auipc	ra,0x0
 964:	d06080e7          	jalr	-762(ra) # 666 <putc>
 968:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 96a:	00000b97          	auipc	s7,0x0
 96e:	2ceb8b93          	addi	s7,s7,718 # c38 <digits>
 972:	03c9d793          	srli	a5,s3,0x3c
 976:	97de                	add	a5,a5,s7
 978:	0007c583          	lbu	a1,0(a5)
 97c:	855a                	mv	a0,s6
 97e:	00000097          	auipc	ra,0x0
 982:	ce8080e7          	jalr	-792(ra) # 666 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 986:	0992                	slli	s3,s3,0x4
 988:	34fd                	addiw	s1,s1,-1
 98a:	f4e5                	bnez	s1,972 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 98c:	8bea                	mv	s7,s10
      state = 0;
 98e:	4981                	li	s3,0
 990:	6d02                	ld	s10,0(sp)
 992:	bbf9                	j	770 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 994:	008b8993          	addi	s3,s7,8
 998:	000bb483          	ld	s1,0(s7)
 99c:	c085                	beqz	s1,9bc <vprintf+0x29a>
        for(; *s; s++)
 99e:	0004c583          	lbu	a1,0(s1)
 9a2:	c585                	beqz	a1,9ca <vprintf+0x2a8>
          putc(fd, *s);
 9a4:	855a                	mv	a0,s6
 9a6:	00000097          	auipc	ra,0x0
 9aa:	cc0080e7          	jalr	-832(ra) # 666 <putc>
        for(; *s; s++)
 9ae:	0485                	addi	s1,s1,1
 9b0:	0004c583          	lbu	a1,0(s1)
 9b4:	f9e5                	bnez	a1,9a4 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 9b6:	8bce                	mv	s7,s3
      state = 0;
 9b8:	4981                	li	s3,0
 9ba:	bb5d                	j	770 <vprintf+0x4e>
          s = "(null)";
 9bc:	00000497          	auipc	s1,0x0
 9c0:	27448493          	addi	s1,s1,628 # c30 <malloc+0x15c>
        for(; *s; s++)
 9c4:	02800593          	li	a1,40
 9c8:	bff1                	j	9a4 <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 9ca:	8bce                	mv	s7,s3
      state = 0;
 9cc:	4981                	li	s3,0
 9ce:	b34d                	j	770 <vprintf+0x4e>
 9d0:	6906                	ld	s2,64(sp)
 9d2:	79e2                	ld	s3,56(sp)
 9d4:	7a42                	ld	s4,48(sp)
 9d6:	7aa2                	ld	s5,40(sp)
 9d8:	7b02                	ld	s6,32(sp)
 9da:	6be2                	ld	s7,24(sp)
 9dc:	6c42                	ld	s8,16(sp)
 9de:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9e0:	60e6                	ld	ra,88(sp)
 9e2:	6446                	ld	s0,80(sp)
 9e4:	64a6                	ld	s1,72(sp)
 9e6:	6125                	addi	sp,sp,96
 9e8:	8082                	ret

00000000000009ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ea:	715d                	addi	sp,sp,-80
 9ec:	ec06                	sd	ra,24(sp)
 9ee:	e822                	sd	s0,16(sp)
 9f0:	1000                	addi	s0,sp,32
 9f2:	e010                	sd	a2,0(s0)
 9f4:	e414                	sd	a3,8(s0)
 9f6:	e818                	sd	a4,16(s0)
 9f8:	ec1c                	sd	a5,24(s0)
 9fa:	03043023          	sd	a6,32(s0)
 9fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a02:	8622                	mv	a2,s0
 a04:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a08:	00000097          	auipc	ra,0x0
 a0c:	d1a080e7          	jalr	-742(ra) # 722 <vprintf>
}
 a10:	60e2                	ld	ra,24(sp)
 a12:	6442                	ld	s0,16(sp)
 a14:	6161                	addi	sp,sp,80
 a16:	8082                	ret

0000000000000a18 <printf>:

void
printf(const char *fmt, ...)
{
 a18:	711d                	addi	sp,sp,-96
 a1a:	ec06                	sd	ra,24(sp)
 a1c:	e822                	sd	s0,16(sp)
 a1e:	1000                	addi	s0,sp,32
 a20:	e40c                	sd	a1,8(s0)
 a22:	e810                	sd	a2,16(s0)
 a24:	ec14                	sd	a3,24(s0)
 a26:	f018                	sd	a4,32(s0)
 a28:	f41c                	sd	a5,40(s0)
 a2a:	03043823          	sd	a6,48(s0)
 a2e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a32:	00840613          	addi	a2,s0,8
 a36:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a3a:	85aa                	mv	a1,a0
 a3c:	4505                	li	a0,1
 a3e:	00000097          	auipc	ra,0x0
 a42:	ce4080e7          	jalr	-796(ra) # 722 <vprintf>
}
 a46:	60e2                	ld	ra,24(sp)
 a48:	6442                	ld	s0,16(sp)
 a4a:	6125                	addi	sp,sp,96
 a4c:	8082                	ret

0000000000000a4e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a4e:	1141                	addi	sp,sp,-16
 a50:	e406                	sd	ra,8(sp)
 a52:	e022                	sd	s0,0(sp)
 a54:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a56:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a5a:	00001797          	auipc	a5,0x1
 a5e:	5a67b783          	ld	a5,1446(a5) # 2000 <freep>
 a62:	a02d                	j	a8c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a64:	4618                	lw	a4,8(a2)
 a66:	9f2d                	addw	a4,a4,a1
 a68:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a6c:	6398                	ld	a4,0(a5)
 a6e:	6310                	ld	a2,0(a4)
 a70:	a83d                	j	aae <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a72:	ff852703          	lw	a4,-8(a0)
 a76:	9f31                	addw	a4,a4,a2
 a78:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a7a:	ff053683          	ld	a3,-16(a0)
 a7e:	a091                	j	ac2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a80:	6398                	ld	a4,0(a5)
 a82:	00e7e463          	bltu	a5,a4,a8a <free+0x3c>
 a86:	00e6ea63          	bltu	a3,a4,a9a <free+0x4c>
{
 a8a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8c:	fed7fae3          	bgeu	a5,a3,a80 <free+0x32>
 a90:	6398                	ld	a4,0(a5)
 a92:	00e6e463          	bltu	a3,a4,a9a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a96:	fee7eae3          	bltu	a5,a4,a8a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a9a:	ff852583          	lw	a1,-8(a0)
 a9e:	6390                	ld	a2,0(a5)
 aa0:	02059813          	slli	a6,a1,0x20
 aa4:	01c85713          	srli	a4,a6,0x1c
 aa8:	9736                	add	a4,a4,a3
 aaa:	fae60de3          	beq	a2,a4,a64 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 aae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ab2:	4790                	lw	a2,8(a5)
 ab4:	02061593          	slli	a1,a2,0x20
 ab8:	01c5d713          	srli	a4,a1,0x1c
 abc:	973e                	add	a4,a4,a5
 abe:	fae68ae3          	beq	a3,a4,a72 <free+0x24>
    p->s.ptr = bp->s.ptr;
 ac2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ac4:	00001717          	auipc	a4,0x1
 ac8:	52f73e23          	sd	a5,1340(a4) # 2000 <freep>
}
 acc:	60a2                	ld	ra,8(sp)
 ace:	6402                	ld	s0,0(sp)
 ad0:	0141                	addi	sp,sp,16
 ad2:	8082                	ret

0000000000000ad4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ad4:	7139                	addi	sp,sp,-64
 ad6:	fc06                	sd	ra,56(sp)
 ad8:	f822                	sd	s0,48(sp)
 ada:	f04a                	sd	s2,32(sp)
 adc:	ec4e                	sd	s3,24(sp)
 ade:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ae0:	02051993          	slli	s3,a0,0x20
 ae4:	0209d993          	srli	s3,s3,0x20
 ae8:	09bd                	addi	s3,s3,15
 aea:	0049d993          	srli	s3,s3,0x4
 aee:	2985                	addiw	s3,s3,1
 af0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 af2:	00001517          	auipc	a0,0x1
 af6:	50e53503          	ld	a0,1294(a0) # 2000 <freep>
 afa:	c905                	beqz	a0,b2a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 afc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 afe:	4798                	lw	a4,8(a5)
 b00:	09377a63          	bgeu	a4,s3,b94 <malloc+0xc0>
 b04:	f426                	sd	s1,40(sp)
 b06:	e852                	sd	s4,16(sp)
 b08:	e456                	sd	s5,8(sp)
 b0a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b0c:	8a4e                	mv	s4,s3
 b0e:	6705                	lui	a4,0x1
 b10:	00e9f363          	bgeu	s3,a4,b16 <malloc+0x42>
 b14:	6a05                	lui	s4,0x1
 b16:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b1a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b1e:	00001497          	auipc	s1,0x1
 b22:	4e248493          	addi	s1,s1,1250 # 2000 <freep>
  if(p == (char*)-1)
 b26:	5afd                	li	s5,-1
 b28:	a089                	j	b6a <malloc+0x96>
 b2a:	f426                	sd	s1,40(sp)
 b2c:	e852                	sd	s4,16(sp)
 b2e:	e456                	sd	s5,8(sp)
 b30:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b32:	00001797          	auipc	a5,0x1
 b36:	4ee78793          	addi	a5,a5,1262 # 2020 <base>
 b3a:	00001717          	auipc	a4,0x1
 b3e:	4cf73323          	sd	a5,1222(a4) # 2000 <freep>
 b42:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b44:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b48:	b7d1                	j	b0c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b4a:	6398                	ld	a4,0(a5)
 b4c:	e118                	sd	a4,0(a0)
 b4e:	a8b9                	j	bac <malloc+0xd8>
  hp->s.size = nu;
 b50:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b54:	0541                	addi	a0,a0,16
 b56:	00000097          	auipc	ra,0x0
 b5a:	ef8080e7          	jalr	-264(ra) # a4e <free>
  return freep;
 b5e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b60:	c135                	beqz	a0,bc4 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b62:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b64:	4798                	lw	a4,8(a5)
 b66:	03277363          	bgeu	a4,s2,b8c <malloc+0xb8>
    if(p == freep)
 b6a:	6098                	ld	a4,0(s1)
 b6c:	853e                	mv	a0,a5
 b6e:	fef71ae3          	bne	a4,a5,b62 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b72:	8552                	mv	a0,s4
 b74:	00000097          	auipc	ra,0x0
 b78:	aca080e7          	jalr	-1334(ra) # 63e <sbrk>
  if(p == (char*)-1)
 b7c:	fd551ae3          	bne	a0,s5,b50 <malloc+0x7c>
        return 0;
 b80:	4501                	li	a0,0
 b82:	74a2                	ld	s1,40(sp)
 b84:	6a42                	ld	s4,16(sp)
 b86:	6aa2                	ld	s5,8(sp)
 b88:	6b02                	ld	s6,0(sp)
 b8a:	a03d                	j	bb8 <malloc+0xe4>
 b8c:	74a2                	ld	s1,40(sp)
 b8e:	6a42                	ld	s4,16(sp)
 b90:	6aa2                	ld	s5,8(sp)
 b92:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b94:	fae90be3          	beq	s2,a4,b4a <malloc+0x76>
        p->s.size -= nunits;
 b98:	4137073b          	subw	a4,a4,s3
 b9c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b9e:	02071693          	slli	a3,a4,0x20
 ba2:	01c6d713          	srli	a4,a3,0x1c
 ba6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ba8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bac:	00001717          	auipc	a4,0x1
 bb0:	44a73a23          	sd	a0,1108(a4) # 2000 <freep>
      return (void*)(p + 1);
 bb4:	01078513          	addi	a0,a5,16
  }
}
 bb8:	70e2                	ld	ra,56(sp)
 bba:	7442                	ld	s0,48(sp)
 bbc:	7902                	ld	s2,32(sp)
 bbe:	69e2                	ld	s3,24(sp)
 bc0:	6121                	addi	sp,sp,64
 bc2:	8082                	ret
 bc4:	74a2                	ld	s1,40(sp)
 bc6:	6a42                	ld	s4,16(sp)
 bc8:	6aa2                	ld	s5,8(sp)
 bca:	6b02                	ld	s6,0(sp)
 bcc:	b7f5                	j	bb8 <malloc+0xe4>
