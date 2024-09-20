
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	40013103          	ld	sp,1024(sp) # 8000a400 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	507040ef          	jal	80004d1c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	95078793          	addi	a5,a5,-1712 # 80023980 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	40490913          	addi	s2,s2,1028 # 8000a450 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	72e050ef          	jal	80005784 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	7b2050ef          	jal	80005818 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	3d8050ef          	jal	80005456 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	89be                	mv	s3,a5
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	37650513          	addi	a0,a0,886 # 8000a450 <kmem>
    800000e2:	61e050ef          	jal	80005700 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00024517          	auipc	a0,0x24
    800000ee:	89650513          	addi	a0,a0,-1898 # 80023980 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	34848493          	addi	s1,s1,840 # 8000a450 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	672050ef          	jal	80005784 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	33450513          	addi	a0,a0,820 # 8000a450 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	6f2050ef          	jal	80005818 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	31050513          	addi	a0,a0,784 # 8000a450 <kmem>
    80000148:	6d0050ef          	jal	80005818 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000156:	ca19                	beqz	a2,8000016c <memset+0x1e>
    80000158:	87aa                	mv	a5,a0
    8000015a:	1602                	slli	a2,a2,0x20
    8000015c:	9201                	srli	a2,a2,0x20
    8000015e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x14>
  }
  return dst;
}
    8000016c:	60a2                	ld	ra,8(sp)
    8000016e:	6402                	ld	s0,0(sp)
    80000170:	0141                	addi	sp,sp,16
    80000172:	8082                	ret

0000000080000174 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000174:	1141                	addi	sp,sp,-16
    80000176:	e406                	sd	ra,8(sp)
    80000178:	e022                	sd	s0,0(sp)
    8000017a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000017c:	ca0d                	beqz	a2,800001ae <memcmp+0x3a>
    8000017e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000182:	1682                	slli	a3,a3,0x20
    80000184:	9281                	srli	a3,a3,0x20
    80000186:	0685                	addi	a3,a3,1
    80000188:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000018a:	00054783          	lbu	a5,0(a0)
    8000018e:	0005c703          	lbu	a4,0(a1)
    80000192:	00e79863          	bne	a5,a4,800001a2 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000196:	0505                	addi	a0,a0,1
    80000198:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000019a:	fed518e3          	bne	a0,a3,8000018a <memcmp+0x16>
  }

  return 0;
    8000019e:	4501                	li	a0,0
    800001a0:	a019                	j	800001a6 <memcmp+0x32>
      return *s1 - *s2;
    800001a2:	40e7853b          	subw	a0,a5,a4
}
    800001a6:	60a2                	ld	ra,8(sp)
    800001a8:	6402                	ld	s0,0(sp)
    800001aa:	0141                	addi	sp,sp,16
    800001ac:	8082                	ret
  return 0;
    800001ae:	4501                	li	a0,0
    800001b0:	bfdd                	j	800001a6 <memcmp+0x32>

00000000800001b2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e406                	sd	ra,8(sp)
    800001b6:	e022                	sd	s0,0(sp)
    800001b8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001ba:	c205                	beqz	a2,800001da <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001bc:	02a5e363          	bltu	a1,a0,800001e2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c0:	1602                	slli	a2,a2,0x20
    800001c2:	9201                	srli	a2,a2,0x20
    800001c4:	00c587b3          	add	a5,a1,a2
{
    800001c8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ca:	0585                	addi	a1,a1,1
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb681>
    800001ce:	fff5c683          	lbu	a3,-1(a1)
    800001d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001d6:	feb79ae3          	bne	a5,a1,800001ca <memmove+0x18>

  return dst;
}
    800001da:	60a2                	ld	ra,8(sp)
    800001dc:	6402                	ld	s0,0(sp)
    800001de:	0141                	addi	sp,sp,16
    800001e0:	8082                	ret
  if(s < d && s + n > d){
    800001e2:	02061693          	slli	a3,a2,0x20
    800001e6:	9281                	srli	a3,a3,0x20
    800001e8:	00d58733          	add	a4,a1,a3
    800001ec:	fce57ae3          	bgeu	a0,a4,800001c0 <memmove+0xe>
    d += n;
    800001f0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	fff7c793          	not	a5,a5
    800001fe:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000200:	177d                	addi	a4,a4,-1
    80000202:	16fd                	addi	a3,a3,-1
    80000204:	00074603          	lbu	a2,0(a4)
    80000208:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000020c:	fee79ae3          	bne	a5,a4,80000200 <memmove+0x4e>
    80000210:	b7e9                	j	800001da <memmove+0x28>

0000000080000212 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000021a:	f99ff0ef          	jal	800001b2 <memmove>
}
    8000021e:	60a2                	ld	ra,8(sp)
    80000220:	6402                	ld	s0,0(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret

0000000080000226 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000022e:	ce11                	beqz	a2,8000024a <strncmp+0x24>
    80000230:	00054783          	lbu	a5,0(a0)
    80000234:	cf89                	beqz	a5,8000024e <strncmp+0x28>
    80000236:	0005c703          	lbu	a4,0(a1)
    8000023a:	00f71a63          	bne	a4,a5,8000024e <strncmp+0x28>
    n--, p++, q++;
    8000023e:	367d                	addiw	a2,a2,-1
    80000240:	0505                	addi	a0,a0,1
    80000242:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000244:	f675                	bnez	a2,80000230 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000246:	4501                	li	a0,0
    80000248:	a801                	j	80000258 <strncmp+0x32>
    8000024a:	4501                	li	a0,0
    8000024c:	a031                	j	80000258 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000024e:	00054503          	lbu	a0,0(a0)
    80000252:	0005c783          	lbu	a5,0(a1)
    80000256:	9d1d                	subw	a0,a0,a5
}
    80000258:	60a2                	ld	ra,8(sp)
    8000025a:	6402                	ld	s0,0(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret

0000000080000260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000260:	1141                	addi	sp,sp,-16
    80000262:	e406                	sd	ra,8(sp)
    80000264:	e022                	sd	s0,0(sp)
    80000266:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000268:	87aa                	mv	a5,a0
    8000026a:	86b2                	mv	a3,a2
    8000026c:	367d                	addiw	a2,a2,-1
    8000026e:	02d05563          	blez	a3,80000298 <strncpy+0x38>
    80000272:	0785                	addi	a5,a5,1
    80000274:	0005c703          	lbu	a4,0(a1)
    80000278:	fee78fa3          	sb	a4,-1(a5)
    8000027c:	0585                	addi	a1,a1,1
    8000027e:	f775                	bnez	a4,8000026a <strncpy+0xa>
    ;
  while(n-- > 0)
    80000280:	873e                	mv	a4,a5
    80000282:	00c05b63          	blez	a2,80000298 <strncpy+0x38>
    80000286:	9fb5                	addw	a5,a5,a3
    80000288:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000028a:	0705                	addi	a4,a4,1
    8000028c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000290:	40e786bb          	subw	a3,a5,a4
    80000294:	fed04be3          	bgtz	a3,8000028a <strncpy+0x2a>
  return os;
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a8:	02c05363          	blez	a2,800002ce <safestrcpy+0x2e>
    800002ac:	fff6069b          	addiw	a3,a2,-1
    800002b0:	1682                	slli	a3,a3,0x20
    800002b2:	9281                	srli	a3,a3,0x20
    800002b4:	96ae                	add	a3,a3,a1
    800002b6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b8:	00d58963          	beq	a1,a3,800002ca <safestrcpy+0x2a>
    800002bc:	0585                	addi	a1,a1,1
    800002be:	0785                	addi	a5,a5,1
    800002c0:	fff5c703          	lbu	a4,-1(a1)
    800002c4:	fee78fa3          	sb	a4,-1(a5)
    800002c8:	fb65                	bnez	a4,800002b8 <safestrcpy+0x18>
    ;
  *s = 0;
    800002ca:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ce:	60a2                	ld	ra,8(sp)
    800002d0:	6402                	ld	s0,0(sp)
    800002d2:	0141                	addi	sp,sp,16
    800002d4:	8082                	ret

00000000800002d6 <strlen>:

int
strlen(const char *s)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e406                	sd	ra,8(sp)
    800002da:	e022                	sd	s0,0(sp)
    800002dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002de:	00054783          	lbu	a5,0(a0)
    800002e2:	cf99                	beqz	a5,80000300 <strlen+0x2a>
    800002e4:	0505                	addi	a0,a0,1
    800002e6:	87aa                	mv	a5,a0
    800002e8:	86be                	mv	a3,a5
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff7c703          	lbu	a4,-1(a5)
    800002f0:	ff65                	bnez	a4,800002e8 <strlen+0x12>
    800002f2:	40a6853b          	subw	a0,a3,a0
    800002f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000300:	4501                	li	a0,0
    80000302:	bfdd                	j	800002f8 <strlen+0x22>

0000000080000304 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000030c:	21d000ef          	jal	80000d28 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000310:	0000a717          	auipc	a4,0xa
    80000314:	11070713          	addi	a4,a4,272 # 8000a420 <started>
  if(cpuid() == 0){
    80000318:	c51d                	beqz	a0,80000346 <main+0x42>
    while(started == 0)
    8000031a:	431c                	lw	a5,0(a4)
    8000031c:	2781                	sext.w	a5,a5
    8000031e:	dff5                	beqz	a5,8000031a <main+0x16>
      ;
    __sync_synchronize();
    80000320:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000324:	205000ef          	jal	80000d28 <cpuid>
    80000328:	85aa                	mv	a1,a0
    8000032a:	00007517          	auipc	a0,0x7
    8000032e:	d0e50513          	addi	a0,a0,-754 # 80007038 <etext+0x38>
    80000332:	655040ef          	jal	80005186 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	518010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	42a040ef          	jal	80004768 <plicinithart>
  }

  scheduler();        
    80000342:	65b000ef          	jal	8000119c <scheduler>
    consoleinit();
    80000346:	573040ef          	jal	800050b8 <consoleinit>
    printfinit();
    8000034a:	146050ef          	jal	80005490 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	631040ef          	jal	80005186 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	625040ef          	jal	80005186 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	619040ef          	jal	80005186 <printf>
    kinit();         // physical page allocator
    80000372:	d59ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    80000376:	2ce000ef          	jal	80000644 <kvminit>
    kvminithart();   // turn on paging
    8000037a:	03c000ef          	jal	800003b6 <kvminithart>
    procinit();      // process table
    8000037e:	0fb000ef          	jal	80000c78 <procinit>
    trapinit();      // trap vectors
    80000382:	4ac010ef          	jal	8000182e <trapinit>
    trapinithart();  // install kernel trap vector
    80000386:	4cc010ef          	jal	80001852 <trapinithart>
    plicinit();      // set up interrupt controller
    8000038a:	3c4040ef          	jal	8000474e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	3da040ef          	jal	80004768 <plicinithart>
    binit();         // buffer cache
    80000392:	349010ef          	jal	80001eda <binit>
    iinit();         // inode table
    80000396:	114020ef          	jal	800024aa <iinit>
    fileinit();      // file table
    8000039a:	6e3020ef          	jal	8000327c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	4ba040ef          	jal	80004858 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	427000ef          	jal	80000fc8 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	0000a717          	auipc	a4,0xa
    800003b0:	06f72a23          	sw	a5,116(a4) # 8000a420 <started>
    800003b4:	b779                	j	80000342 <main+0x3e>

00000000800003b6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003be:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003c2:	0000a797          	auipc	a5,0xa
    800003c6:	0667b783          	ld	a5,102(a5) # 8000a428 <kernel_pagetable>
    800003ca:	83b1                	srli	a5,a5,0xc
    800003cc:	577d                	li	a4,-1
    800003ce:	177e                	slli	a4,a4,0x3f
    800003d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003d2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003d6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003e2:	7139                	addi	sp,sp,-64
    800003e4:	fc06                	sd	ra,56(sp)
    800003e6:	f822                	sd	s0,48(sp)
    800003e8:	f426                	sd	s1,40(sp)
    800003ea:	f04a                	sd	s2,32(sp)
    800003ec:	ec4e                	sd	s3,24(sp)
    800003ee:	e852                	sd	s4,16(sp)
    800003f0:	e456                	sd	s5,8(sp)
    800003f2:	e05a                	sd	s6,0(sp)
    800003f4:	0080                	addi	s0,sp,64
    800003f6:	84aa                	mv	s1,a0
    800003f8:	89ae                	mv	s3,a1
    800003fa:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003fc:	57fd                	li	a5,-1
    800003fe:	83e9                	srli	a5,a5,0x1a
    80000400:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000402:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000404:	04b7e263          	bltu	a5,a1,80000448 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000408:	0149d933          	srl	s2,s3,s4
    8000040c:	1ff97913          	andi	s2,s2,511
    80000410:	090e                	slli	s2,s2,0x3
    80000412:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000414:	00093483          	ld	s1,0(s2)
    80000418:	0014f793          	andi	a5,s1,1
    8000041c:	cf85                	beqz	a5,80000454 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000041e:	80a9                	srli	s1,s1,0xa
    80000420:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000422:	3a5d                	addiw	s4,s4,-9
    80000424:	ff6a12e3          	bne	s4,s6,80000408 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000428:	00c9d513          	srli	a0,s3,0xc
    8000042c:	1ff57513          	andi	a0,a0,511
    80000430:	050e                	slli	a0,a0,0x3
    80000432:	9526                	add	a0,a0,s1
}
    80000434:	70e2                	ld	ra,56(sp)
    80000436:	7442                	ld	s0,48(sp)
    80000438:	74a2                	ld	s1,40(sp)
    8000043a:	7902                	ld	s2,32(sp)
    8000043c:	69e2                	ld	s3,24(sp)
    8000043e:	6a42                	ld	s4,16(sp)
    80000440:	6aa2                	ld	s5,8(sp)
    80000442:	6b02                	ld	s6,0(sp)
    80000444:	6121                	addi	sp,sp,64
    80000446:	8082                	ret
    panic("walk");
    80000448:	00007517          	auipc	a0,0x7
    8000044c:	c0850513          	addi	a0,a0,-1016 # 80007050 <etext+0x50>
    80000450:	006050ef          	jal	80005456 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000454:	020a8263          	beqz	s5,80000478 <walk+0x96>
    80000458:	ca7ff0ef          	jal	800000fe <kalloc>
    8000045c:	84aa                	mv	s1,a0
    8000045e:	d979                	beqz	a0,80000434 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000460:	6605                	lui	a2,0x1
    80000462:	4581                	li	a1,0
    80000464:	cebff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000468:	00c4d793          	srli	a5,s1,0xc
    8000046c:	07aa                	slli	a5,a5,0xa
    8000046e:	0017e793          	ori	a5,a5,1
    80000472:	00f93023          	sd	a5,0(s2)
    80000476:	b775                	j	80000422 <walk+0x40>
        return 0;
    80000478:	4501                	li	a0,0
    8000047a:	bf6d                	j	80000434 <walk+0x52>

000000008000047c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000047c:	57fd                	li	a5,-1
    8000047e:	83e9                	srli	a5,a5,0x1a
    80000480:	00b7f463          	bgeu	a5,a1,80000488 <walkaddr+0xc>
    return 0;
    80000484:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000486:	8082                	ret
{
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e406                	sd	ra,8(sp)
    8000048c:	e022                	sd	s0,0(sp)
    8000048e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000490:	4601                	li	a2,0
    80000492:	f51ff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    80000496:	c105                	beqz	a0,800004b6 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000498:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000049a:	0117f693          	andi	a3,a5,17
    8000049e:	4745                	li	a4,17
    return 0;
    800004a0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004a2:	00e68663          	beq	a3,a4,800004ae <walkaddr+0x32>
}
    800004a6:	60a2                	ld	ra,8(sp)
    800004a8:	6402                	ld	s0,0(sp)
    800004aa:	0141                	addi	sp,sp,16
    800004ac:	8082                	ret
  pa = PTE2PA(*pte);
    800004ae:	83a9                	srli	a5,a5,0xa
    800004b0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004b4:	bfcd                	j	800004a6 <walkaddr+0x2a>
    return 0;
    800004b6:	4501                	li	a0,0
    800004b8:	b7fd                	j	800004a6 <walkaddr+0x2a>

00000000800004ba <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004ba:	715d                	addi	sp,sp,-80
    800004bc:	e486                	sd	ra,72(sp)
    800004be:	e0a2                	sd	s0,64(sp)
    800004c0:	fc26                	sd	s1,56(sp)
    800004c2:	f84a                	sd	s2,48(sp)
    800004c4:	f44e                	sd	s3,40(sp)
    800004c6:	f052                	sd	s4,32(sp)
    800004c8:	ec56                	sd	s5,24(sp)
    800004ca:	e85a                	sd	s6,16(sp)
    800004cc:	e45e                	sd	s7,8(sp)
    800004ce:	e062                	sd	s8,0(sp)
    800004d0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004d2:	03459793          	slli	a5,a1,0x34
    800004d6:	e7b1                	bnez	a5,80000522 <mappages+0x68>
    800004d8:	8aaa                	mv	s5,a0
    800004da:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004dc:	03461793          	slli	a5,a2,0x34
    800004e0:	e7b9                	bnez	a5,8000052e <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    800004e2:	ce21                	beqz	a2,8000053a <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004e4:	77fd                	lui	a5,0xfffff
    800004e6:	963e                	add	a2,a2,a5
    800004e8:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ec:	892e                	mv	s2,a1
    800004ee:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004f2:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004f4:	6c05                	lui	s8,0x1
    800004f6:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fa:	865e                	mv	a2,s7
    800004fc:	85ca                	mv	a1,s2
    800004fe:	8556                	mv	a0,s5
    80000500:	ee3ff0ef          	jal	800003e2 <walk>
    80000504:	c539                	beqz	a0,80000552 <mappages+0x98>
    if(*pte & PTE_V)
    80000506:	611c                	ld	a5,0(a0)
    80000508:	8b85                	andi	a5,a5,1
    8000050a:	ef95                	bnez	a5,80000546 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000050c:	80b1                	srli	s1,s1,0xc
    8000050e:	04aa                	slli	s1,s1,0xa
    80000510:	0164e4b3          	or	s1,s1,s6
    80000514:	0014e493          	ori	s1,s1,1
    80000518:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051a:	05390963          	beq	s2,s3,8000056c <mappages+0xb2>
    a += PGSIZE;
    8000051e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000520:	bfd9                	j	800004f6 <mappages+0x3c>
    panic("mappages: va not aligned");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b3650513          	addi	a0,a0,-1226 # 80007058 <etext+0x58>
    8000052a:	72d040ef          	jal	80005456 <panic>
    panic("mappages: size not aligned");
    8000052e:	00007517          	auipc	a0,0x7
    80000532:	b4a50513          	addi	a0,a0,-1206 # 80007078 <etext+0x78>
    80000536:	721040ef          	jal	80005456 <panic>
    panic("mappages: size");
    8000053a:	00007517          	auipc	a0,0x7
    8000053e:	b5e50513          	addi	a0,a0,-1186 # 80007098 <etext+0x98>
    80000542:	715040ef          	jal	80005456 <panic>
      panic("mappages: remap");
    80000546:	00007517          	auipc	a0,0x7
    8000054a:	b6250513          	addi	a0,a0,-1182 # 800070a8 <etext+0xa8>
    8000054e:	709040ef          	jal	80005456 <panic>
      return -1;
    80000552:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000554:	60a6                	ld	ra,72(sp)
    80000556:	6406                	ld	s0,64(sp)
    80000558:	74e2                	ld	s1,56(sp)
    8000055a:	7942                	ld	s2,48(sp)
    8000055c:	79a2                	ld	s3,40(sp)
    8000055e:	7a02                	ld	s4,32(sp)
    80000560:	6ae2                	ld	s5,24(sp)
    80000562:	6b42                	ld	s6,16(sp)
    80000564:	6ba2                	ld	s7,8(sp)
    80000566:	6c02                	ld	s8,0(sp)
    80000568:	6161                	addi	sp,sp,80
    8000056a:	8082                	ret
  return 0;
    8000056c:	4501                	li	a0,0
    8000056e:	b7dd                	j	80000554 <mappages+0x9a>

0000000080000570 <kvmmap>:
{
    80000570:	1141                	addi	sp,sp,-16
    80000572:	e406                	sd	ra,8(sp)
    80000574:	e022                	sd	s0,0(sp)
    80000576:	0800                	addi	s0,sp,16
    80000578:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000057a:	86b2                	mv	a3,a2
    8000057c:	863e                	mv	a2,a5
    8000057e:	f3dff0ef          	jal	800004ba <mappages>
    80000582:	e509                	bnez	a0,8000058c <kvmmap+0x1c>
}
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
    panic("kvmmap");
    8000058c:	00007517          	auipc	a0,0x7
    80000590:	b2c50513          	addi	a0,a0,-1236 # 800070b8 <etext+0xb8>
    80000594:	6c3040ef          	jal	80005456 <panic>

0000000080000598 <kvmmake>:
{
    80000598:	1101                	addi	sp,sp,-32
    8000059a:	ec06                	sd	ra,24(sp)
    8000059c:	e822                	sd	s0,16(sp)
    8000059e:	e426                	sd	s1,8(sp)
    800005a0:	e04a                	sd	s2,0(sp)
    800005a2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005a4:	b5bff0ef          	jal	800000fe <kalloc>
    800005a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005aa:	6605                	lui	a2,0x1
    800005ac:	4581                	li	a1,0
    800005ae:	ba1ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005b2:	4719                	li	a4,6
    800005b4:	6685                	lui	a3,0x1
    800005b6:	10000637          	lui	a2,0x10000
    800005ba:	85b2                	mv	a1,a2
    800005bc:	8526                	mv	a0,s1
    800005be:	fb3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005c2:	4719                	li	a4,6
    800005c4:	6685                	lui	a3,0x1
    800005c6:	10001637          	lui	a2,0x10001
    800005ca:	85b2                	mv	a1,a2
    800005cc:	8526                	mv	a0,s1
    800005ce:	fa3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005d2:	4719                	li	a4,6
    800005d4:	040006b7          	lui	a3,0x4000
    800005d8:	0c000637          	lui	a2,0xc000
    800005dc:	85b2                	mv	a1,a2
    800005de:	8526                	mv	a0,s1
    800005e0:	f91ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005e4:	00007917          	auipc	s2,0x7
    800005e8:	a1c90913          	addi	s2,s2,-1508 # 80007000 <etext>
    800005ec:	4729                	li	a4,10
    800005ee:	80007697          	auipc	a3,0x80007
    800005f2:	a1268693          	addi	a3,a3,-1518 # 7000 <_entry-0x7fff9000>
    800005f6:	4605                	li	a2,1
    800005f8:	067e                	slli	a2,a2,0x1f
    800005fa:	85b2                	mv	a1,a2
    800005fc:	8526                	mv	a0,s1
    800005fe:	f73ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000602:	4719                	li	a4,6
    80000604:	46c5                	li	a3,17
    80000606:	06ee                	slli	a3,a3,0x1b
    80000608:	412686b3          	sub	a3,a3,s2
    8000060c:	864a                	mv	a2,s2
    8000060e:	85ca                	mv	a1,s2
    80000610:	8526                	mv	a0,s1
    80000612:	f5fff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000616:	4729                	li	a4,10
    80000618:	6685                	lui	a3,0x1
    8000061a:	00006617          	auipc	a2,0x6
    8000061e:	9e660613          	addi	a2,a2,-1562 # 80006000 <_trampoline>
    80000622:	040005b7          	lui	a1,0x4000
    80000626:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000628:	05b2                	slli	a1,a1,0xc
    8000062a:	8526                	mv	a0,s1
    8000062c:	f45ff0ef          	jal	80000570 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000630:	8526                	mv	a0,s1
    80000632:	5a8000ef          	jal	80000bda <proc_mapstacks>
}
    80000636:	8526                	mv	a0,s1
    80000638:	60e2                	ld	ra,24(sp)
    8000063a:	6442                	ld	s0,16(sp)
    8000063c:	64a2                	ld	s1,8(sp)
    8000063e:	6902                	ld	s2,0(sp)
    80000640:	6105                	addi	sp,sp,32
    80000642:	8082                	ret

0000000080000644 <kvminit>:
{
    80000644:	1141                	addi	sp,sp,-16
    80000646:	e406                	sd	ra,8(sp)
    80000648:	e022                	sd	s0,0(sp)
    8000064a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000064c:	f4dff0ef          	jal	80000598 <kvmmake>
    80000650:	0000a797          	auipc	a5,0xa
    80000654:	dca7bc23          	sd	a0,-552(a5) # 8000a428 <kernel_pagetable>
}
    80000658:	60a2                	ld	ra,8(sp)
    8000065a:	6402                	ld	s0,0(sp)
    8000065c:	0141                	addi	sp,sp,16
    8000065e:	8082                	ret

0000000080000660 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000660:	715d                	addi	sp,sp,-80
    80000662:	e486                	sd	ra,72(sp)
    80000664:	e0a2                	sd	s0,64(sp)
    80000666:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000668:	03459793          	slli	a5,a1,0x34
    8000066c:	e39d                	bnez	a5,80000692 <uvmunmap+0x32>
    8000066e:	f84a                	sd	s2,48(sp)
    80000670:	f44e                	sd	s3,40(sp)
    80000672:	f052                	sd	s4,32(sp)
    80000674:	ec56                	sd	s5,24(sp)
    80000676:	e85a                	sd	s6,16(sp)
    80000678:	e45e                	sd	s7,8(sp)
    8000067a:	8a2a                	mv	s4,a0
    8000067c:	892e                	mv	s2,a1
    8000067e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000680:	0632                	slli	a2,a2,0xc
    80000682:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000686:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000688:	6b05                	lui	s6,0x1
    8000068a:	0735ff63          	bgeu	a1,s3,80000708 <uvmunmap+0xa8>
    8000068e:	fc26                	sd	s1,56(sp)
    80000690:	a0a9                	j	800006da <uvmunmap+0x7a>
    80000692:	fc26                	sd	s1,56(sp)
    80000694:	f84a                	sd	s2,48(sp)
    80000696:	f44e                	sd	s3,40(sp)
    80000698:	f052                	sd	s4,32(sp)
    8000069a:	ec56                	sd	s5,24(sp)
    8000069c:	e85a                	sd	s6,16(sp)
    8000069e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	5af040ef          	jal	80005456 <panic>
      panic("uvmunmap: walk");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	5a3040ef          	jal	80005456 <panic>
      panic("uvmunmap: not mapped");
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a3050513          	addi	a0,a0,-1488 # 800070e8 <etext+0xe8>
    800006c0:	597040ef          	jal	80005456 <panic>
      panic("uvmunmap: not a leaf");
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a3c50513          	addi	a0,a0,-1476 # 80007100 <etext+0x100>
    800006cc:	58b040ef          	jal	80005456 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006d0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006d4:	995a                	add	s2,s2,s6
    800006d6:	03397863          	bgeu	s2,s3,80000706 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006da:	4601                	li	a2,0
    800006dc:	85ca                	mv	a1,s2
    800006de:	8552                	mv	a0,s4
    800006e0:	d03ff0ef          	jal	800003e2 <walk>
    800006e4:	84aa                	mv	s1,a0
    800006e6:	d179                	beqz	a0,800006ac <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006e8:	6108                	ld	a0,0(a0)
    800006ea:	00157793          	andi	a5,a0,1
    800006ee:	d7e9                	beqz	a5,800006b8 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006f0:	3ff57793          	andi	a5,a0,1023
    800006f4:	fd7788e3          	beq	a5,s7,800006c4 <uvmunmap+0x64>
    if(do_free){
    800006f8:	fc0a8ce3          	beqz	s5,800006d0 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800006fc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006fe:	0532                	slli	a0,a0,0xc
    80000700:	91dff0ef          	jal	8000001c <kfree>
    80000704:	b7f1                	j	800006d0 <uvmunmap+0x70>
    80000706:	74e2                	ld	s1,56(sp)
    80000708:	7942                	ld	s2,48(sp)
    8000070a:	79a2                	ld	s3,40(sp)
    8000070c:	7a02                	ld	s4,32(sp)
    8000070e:	6ae2                	ld	s5,24(sp)
    80000710:	6b42                	ld	s6,16(sp)
    80000712:	6ba2                	ld	s7,8(sp)
  }
}
    80000714:	60a6                	ld	ra,72(sp)
    80000716:	6406                	ld	s0,64(sp)
    80000718:	6161                	addi	sp,sp,80
    8000071a:	8082                	ret

000000008000071c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000071c:	1101                	addi	sp,sp,-32
    8000071e:	ec06                	sd	ra,24(sp)
    80000720:	e822                	sd	s0,16(sp)
    80000722:	e426                	sd	s1,8(sp)
    80000724:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000726:	9d9ff0ef          	jal	800000fe <kalloc>
    8000072a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000072c:	c509                	beqz	a0,80000736 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	a1dff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000736:	8526                	mv	a0,s1
    80000738:	60e2                	ld	ra,24(sp)
    8000073a:	6442                	ld	s0,16(sp)
    8000073c:	64a2                	ld	s1,8(sp)
    8000073e:	6105                	addi	sp,sp,32
    80000740:	8082                	ret

0000000080000742 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000742:	7179                	addi	sp,sp,-48
    80000744:	f406                	sd	ra,40(sp)
    80000746:	f022                	sd	s0,32(sp)
    80000748:	ec26                	sd	s1,24(sp)
    8000074a:	e84a                	sd	s2,16(sp)
    8000074c:	e44e                	sd	s3,8(sp)
    8000074e:	e052                	sd	s4,0(sp)
    80000750:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000752:	6785                	lui	a5,0x1
    80000754:	04f67063          	bgeu	a2,a5,80000794 <uvmfirst+0x52>
    80000758:	8a2a                	mv	s4,a0
    8000075a:	89ae                	mv	s3,a1
    8000075c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000075e:	9a1ff0ef          	jal	800000fe <kalloc>
    80000762:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000764:	6605                	lui	a2,0x1
    80000766:	4581                	li	a1,0
    80000768:	9e7ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000076c:	4779                	li	a4,30
    8000076e:	86ca                	mv	a3,s2
    80000770:	6605                	lui	a2,0x1
    80000772:	4581                	li	a1,0
    80000774:	8552                	mv	a0,s4
    80000776:	d45ff0ef          	jal	800004ba <mappages>
  memmove(mem, src, sz);
    8000077a:	8626                	mv	a2,s1
    8000077c:	85ce                	mv	a1,s3
    8000077e:	854a                	mv	a0,s2
    80000780:	a33ff0ef          	jal	800001b2 <memmove>
}
    80000784:	70a2                	ld	ra,40(sp)
    80000786:	7402                	ld	s0,32(sp)
    80000788:	64e2                	ld	s1,24(sp)
    8000078a:	6942                	ld	s2,16(sp)
    8000078c:	69a2                	ld	s3,8(sp)
    8000078e:	6a02                	ld	s4,0(sp)
    80000790:	6145                	addi	sp,sp,48
    80000792:	8082                	ret
    panic("uvmfirst: more than a page");
    80000794:	00007517          	auipc	a0,0x7
    80000798:	98450513          	addi	a0,a0,-1660 # 80007118 <etext+0x118>
    8000079c:	4bb040ef          	jal	80005456 <panic>

00000000800007a0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007a0:	1101                	addi	sp,sp,-32
    800007a2:	ec06                	sd	ra,24(sp)
    800007a4:	e822                	sd	s0,16(sp)
    800007a6:	e426                	sd	s1,8(sp)
    800007a8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007aa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ac:	00b67d63          	bgeu	a2,a1,800007c6 <uvmdealloc+0x26>
    800007b0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007b2:	6785                	lui	a5,0x1
    800007b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b6:	00f60733          	add	a4,a2,a5
    800007ba:	76fd                	lui	a3,0xfffff
    800007bc:	8f75                	and	a4,a4,a3
    800007be:	97ae                	add	a5,a5,a1
    800007c0:	8ff5                	and	a5,a5,a3
    800007c2:	00f76863          	bltu	a4,a5,800007d2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007c6:	8526                	mv	a0,s1
    800007c8:	60e2                	ld	ra,24(sp)
    800007ca:	6442                	ld	s0,16(sp)
    800007cc:	64a2                	ld	s1,8(sp)
    800007ce:	6105                	addi	sp,sp,32
    800007d0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007d2:	8f99                	sub	a5,a5,a4
    800007d4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007d6:	4685                	li	a3,1
    800007d8:	0007861b          	sext.w	a2,a5
    800007dc:	85ba                	mv	a1,a4
    800007de:	e83ff0ef          	jal	80000660 <uvmunmap>
    800007e2:	b7d5                	j	800007c6 <uvmdealloc+0x26>

00000000800007e4 <uvmalloc>:
  if(newsz < oldsz)
    800007e4:	0ab66363          	bltu	a2,a1,8000088a <uvmalloc+0xa6>
{
    800007e8:	715d                	addi	sp,sp,-80
    800007ea:	e486                	sd	ra,72(sp)
    800007ec:	e0a2                	sd	s0,64(sp)
    800007ee:	f052                	sd	s4,32(sp)
    800007f0:	ec56                	sd	s5,24(sp)
    800007f2:	e85a                	sd	s6,16(sp)
    800007f4:	0880                	addi	s0,sp,80
    800007f6:	8b2a                	mv	s6,a0
    800007f8:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800007fa:	6785                	lui	a5,0x1
    800007fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007fe:	95be                	add	a1,a1,a5
    80000800:	77fd                	lui	a5,0xfffff
    80000802:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000806:	08ca7463          	bgeu	s4,a2,8000088e <uvmalloc+0xaa>
    8000080a:	fc26                	sd	s1,56(sp)
    8000080c:	f84a                	sd	s2,48(sp)
    8000080e:	f44e                	sd	s3,40(sp)
    80000810:	e45e                	sd	s7,8(sp)
    80000812:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80000814:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000816:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000081a:	8e5ff0ef          	jal	800000fe <kalloc>
    8000081e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000820:	c515                	beqz	a0,8000084c <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000822:	864e                	mv	a2,s3
    80000824:	4581                	li	a1,0
    80000826:	929ff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000082a:	875e                	mv	a4,s7
    8000082c:	86a6                	mv	a3,s1
    8000082e:	864e                	mv	a2,s3
    80000830:	85ca                	mv	a1,s2
    80000832:	855a                	mv	a0,s6
    80000834:	c87ff0ef          	jal	800004ba <mappages>
    80000838:	e91d                	bnez	a0,8000086e <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000083a:	994e                	add	s2,s2,s3
    8000083c:	fd596fe3          	bltu	s2,s5,8000081a <uvmalloc+0x36>
  return newsz;
    80000840:	8556                	mv	a0,s5
    80000842:	74e2                	ld	s1,56(sp)
    80000844:	7942                	ld	s2,48(sp)
    80000846:	79a2                	ld	s3,40(sp)
    80000848:	6ba2                	ld	s7,8(sp)
    8000084a:	a819                	j	80000860 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000084c:	8652                	mv	a2,s4
    8000084e:	85ca                	mv	a1,s2
    80000850:	855a                	mv	a0,s6
    80000852:	f4fff0ef          	jal	800007a0 <uvmdealloc>
      return 0;
    80000856:	4501                	li	a0,0
    80000858:	74e2                	ld	s1,56(sp)
    8000085a:	7942                	ld	s2,48(sp)
    8000085c:	79a2                	ld	s3,40(sp)
    8000085e:	6ba2                	ld	s7,8(sp)
}
    80000860:	60a6                	ld	ra,72(sp)
    80000862:	6406                	ld	s0,64(sp)
    80000864:	7a02                	ld	s4,32(sp)
    80000866:	6ae2                	ld	s5,24(sp)
    80000868:	6b42                	ld	s6,16(sp)
    8000086a:	6161                	addi	sp,sp,80
    8000086c:	8082                	ret
      kfree(mem);
    8000086e:	8526                	mv	a0,s1
    80000870:	facff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000874:	8652                	mv	a2,s4
    80000876:	85ca                	mv	a1,s2
    80000878:	855a                	mv	a0,s6
    8000087a:	f27ff0ef          	jal	800007a0 <uvmdealloc>
      return 0;
    8000087e:	4501                	li	a0,0
    80000880:	74e2                	ld	s1,56(sp)
    80000882:	7942                	ld	s2,48(sp)
    80000884:	79a2                	ld	s3,40(sp)
    80000886:	6ba2                	ld	s7,8(sp)
    80000888:	bfe1                	j	80000860 <uvmalloc+0x7c>
    return oldsz;
    8000088a:	852e                	mv	a0,a1
}
    8000088c:	8082                	ret
  return newsz;
    8000088e:	8532                	mv	a0,a2
    80000890:	bfc1                	j	80000860 <uvmalloc+0x7c>

0000000080000892 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000892:	7179                	addi	sp,sp,-48
    80000894:	f406                	sd	ra,40(sp)
    80000896:	f022                	sd	s0,32(sp)
    80000898:	ec26                	sd	s1,24(sp)
    8000089a:	e84a                	sd	s2,16(sp)
    8000089c:	e44e                	sd	s3,8(sp)
    8000089e:	e052                	sd	s4,0(sp)
    800008a0:	1800                	addi	s0,sp,48
    800008a2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008a4:	84aa                	mv	s1,a0
    800008a6:	6905                	lui	s2,0x1
    800008a8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008aa:	4985                	li	s3,1
    800008ac:	a819                	j	800008c2 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008ae:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008b0:	00c79513          	slli	a0,a5,0xc
    800008b4:	fdfff0ef          	jal	80000892 <freewalk>
      pagetable[i] = 0;
    800008b8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008bc:	04a1                	addi	s1,s1,8
    800008be:	01248f63          	beq	s1,s2,800008dc <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008c2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	00f7f713          	andi	a4,a5,15
    800008c8:	ff3703e3          	beq	a4,s3,800008ae <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008cc:	8b85                	andi	a5,a5,1
    800008ce:	d7fd                	beqz	a5,800008bc <freewalk+0x2a>
      panic("freewalk: leaf");
    800008d0:	00007517          	auipc	a0,0x7
    800008d4:	86850513          	addi	a0,a0,-1944 # 80007138 <etext+0x138>
    800008d8:	37f040ef          	jal	80005456 <panic>
    }
  }
  kfree((void*)pagetable);
    800008dc:	8552                	mv	a0,s4
    800008de:	f3eff0ef          	jal	8000001c <kfree>
}
    800008e2:	70a2                	ld	ra,40(sp)
    800008e4:	7402                	ld	s0,32(sp)
    800008e6:	64e2                	ld	s1,24(sp)
    800008e8:	6942                	ld	s2,16(sp)
    800008ea:	69a2                	ld	s3,8(sp)
    800008ec:	6a02                	ld	s4,0(sp)
    800008ee:	6145                	addi	sp,sp,48
    800008f0:	8082                	ret

00000000800008f2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008f2:	1101                	addi	sp,sp,-32
    800008f4:	ec06                	sd	ra,24(sp)
    800008f6:	e822                	sd	s0,16(sp)
    800008f8:	e426                	sd	s1,8(sp)
    800008fa:	1000                	addi	s0,sp,32
    800008fc:	84aa                	mv	s1,a0
  if(sz > 0)
    800008fe:	e989                	bnez	a1,80000910 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000900:	8526                	mv	a0,s1
    80000902:	f91ff0ef          	jal	80000892 <freewalk>
}
    80000906:	60e2                	ld	ra,24(sp)
    80000908:	6442                	ld	s0,16(sp)
    8000090a:	64a2                	ld	s1,8(sp)
    8000090c:	6105                	addi	sp,sp,32
    8000090e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000910:	6785                	lui	a5,0x1
    80000912:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000914:	95be                	add	a1,a1,a5
    80000916:	4685                	li	a3,1
    80000918:	00c5d613          	srli	a2,a1,0xc
    8000091c:	4581                	li	a1,0
    8000091e:	d43ff0ef          	jal	80000660 <uvmunmap>
    80000922:	bff9                	j	80000900 <uvmfree+0xe>

0000000080000924 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000924:	ca4d                	beqz	a2,800009d6 <uvmcopy+0xb2>
{
    80000926:	715d                	addi	sp,sp,-80
    80000928:	e486                	sd	ra,72(sp)
    8000092a:	e0a2                	sd	s0,64(sp)
    8000092c:	fc26                	sd	s1,56(sp)
    8000092e:	f84a                	sd	s2,48(sp)
    80000930:	f44e                	sd	s3,40(sp)
    80000932:	f052                	sd	s4,32(sp)
    80000934:	ec56                	sd	s5,24(sp)
    80000936:	e85a                	sd	s6,16(sp)
    80000938:	e45e                	sd	s7,8(sp)
    8000093a:	e062                	sd	s8,0(sp)
    8000093c:	0880                	addi	s0,sp,80
    8000093e:	8baa                	mv	s7,a0
    80000940:	8b2e                	mv	s6,a1
    80000942:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000944:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000946:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000948:	4601                	li	a2,0
    8000094a:	85ce                	mv	a1,s3
    8000094c:	855e                	mv	a0,s7
    8000094e:	a95ff0ef          	jal	800003e2 <walk>
    80000952:	cd1d                	beqz	a0,80000990 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    80000954:	6118                	ld	a4,0(a0)
    80000956:	00177793          	andi	a5,a4,1
    8000095a:	c3a9                	beqz	a5,8000099c <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    8000095c:	00a75593          	srli	a1,a4,0xa
    80000960:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000964:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000968:	f96ff0ef          	jal	800000fe <kalloc>
    8000096c:	892a                	mv	s2,a0
    8000096e:	c121                	beqz	a0,800009ae <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    80000970:	8652                	mv	a2,s4
    80000972:	85e2                	mv	a1,s8
    80000974:	83fff0ef          	jal	800001b2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000978:	8726                	mv	a4,s1
    8000097a:	86ca                	mv	a3,s2
    8000097c:	8652                	mv	a2,s4
    8000097e:	85ce                	mv	a1,s3
    80000980:	855a                	mv	a0,s6
    80000982:	b39ff0ef          	jal	800004ba <mappages>
    80000986:	e10d                	bnez	a0,800009a8 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80000988:	99d2                	add	s3,s3,s4
    8000098a:	fb59efe3          	bltu	s3,s5,80000948 <uvmcopy+0x24>
    8000098e:	a805                	j	800009be <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80000990:	00006517          	auipc	a0,0x6
    80000994:	7b850513          	addi	a0,a0,1976 # 80007148 <etext+0x148>
    80000998:	2bf040ef          	jal	80005456 <panic>
      panic("uvmcopy: page not present");
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	2b3040ef          	jal	80005456 <panic>
      kfree(mem);
    800009a8:	854a                	mv	a0,s2
    800009aa:	e72ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009ae:	4685                	li	a3,1
    800009b0:	00c9d613          	srli	a2,s3,0xc
    800009b4:	4581                	li	a1,0
    800009b6:	855a                	mv	a0,s6
    800009b8:	ca9ff0ef          	jal	80000660 <uvmunmap>
  return -1;
    800009bc:	557d                	li	a0,-1
}
    800009be:	60a6                	ld	ra,72(sp)
    800009c0:	6406                	ld	s0,64(sp)
    800009c2:	74e2                	ld	s1,56(sp)
    800009c4:	7942                	ld	s2,48(sp)
    800009c6:	79a2                	ld	s3,40(sp)
    800009c8:	7a02                	ld	s4,32(sp)
    800009ca:	6ae2                	ld	s5,24(sp)
    800009cc:	6b42                	ld	s6,16(sp)
    800009ce:	6ba2                	ld	s7,8(sp)
    800009d0:	6c02                	ld	s8,0(sp)
    800009d2:	6161                	addi	sp,sp,80
    800009d4:	8082                	ret
  return 0;
    800009d6:	4501                	li	a0,0
}
    800009d8:	8082                	ret

00000000800009da <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009da:	1141                	addi	sp,sp,-16
    800009dc:	e406                	sd	ra,8(sp)
    800009de:	e022                	sd	s0,0(sp)
    800009e0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e2:	4601                	li	a2,0
    800009e4:	9ffff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    800009e8:	c901                	beqz	a0,800009f8 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ea:	611c                	ld	a5,0(a0)
    800009ec:	9bbd                	andi	a5,a5,-17
    800009ee:	e11c                	sd	a5,0(a0)
}
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    panic("uvmclear");
    800009f8:	00006517          	auipc	a0,0x6
    800009fc:	79050513          	addi	a0,a0,1936 # 80007188 <etext+0x188>
    80000a00:	257040ef          	jal	80005456 <panic>

0000000080000a04 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a04:	c2d9                	beqz	a3,80000a8a <copyout+0x86>
{
    80000a06:	711d                	addi	sp,sp,-96
    80000a08:	ec86                	sd	ra,88(sp)
    80000a0a:	e8a2                	sd	s0,80(sp)
    80000a0c:	e4a6                	sd	s1,72(sp)
    80000a0e:	e0ca                	sd	s2,64(sp)
    80000a10:	fc4e                	sd	s3,56(sp)
    80000a12:	f852                	sd	s4,48(sp)
    80000a14:	f456                	sd	s5,40(sp)
    80000a16:	f05a                	sd	s6,32(sp)
    80000a18:	ec5e                	sd	s7,24(sp)
    80000a1a:	e862                	sd	s8,16(sp)
    80000a1c:	e466                	sd	s9,8(sp)
    80000a1e:	e06a                	sd	s10,0(sp)
    80000a20:	1080                	addi	s0,sp,96
    80000a22:	8c2a                	mv	s8,a0
    80000a24:	892e                	mv	s2,a1
    80000a26:	8ab2                	mv	s5,a2
    80000a28:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a2a:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    80000a2c:	5bfd                	li	s7,-1
    80000a2e:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a32:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000a34:	6b05                	lui	s6,0x1
    80000a36:	a015                	j	80000a5a <copyout+0x56>
    pa0 = PTE2PA(*pte);
    80000a38:	83a9                	srli	a5,a5,0xa
    80000a3a:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a3c:	41390533          	sub	a0,s2,s3
    80000a40:	0004861b          	sext.w	a2,s1
    80000a44:	85d6                	mv	a1,s5
    80000a46:	953e                	add	a0,a0,a5
    80000a48:	f6aff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000a4c:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a50:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a52:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000a56:	020a0863          	beqz	s4,80000a86 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    80000a5a:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    80000a5e:	033be863          	bltu	s7,s3,80000a8e <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    80000a62:	4601                	li	a2,0
    80000a64:	85ce                	mv	a1,s3
    80000a66:	8562                	mv	a0,s8
    80000a68:	97bff0ef          	jal	800003e2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a6c:	c121                	beqz	a0,80000aac <copyout+0xa8>
    80000a6e:	611c                	ld	a5,0(a0)
    80000a70:	0157f713          	andi	a4,a5,21
    80000a74:	03a71e63          	bne	a4,s10,80000ab0 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000a78:	412984b3          	sub	s1,s3,s2
    80000a7c:	94da                	add	s1,s1,s6
    if(n > len)
    80000a7e:	fa9a7de3          	bgeu	s4,s1,80000a38 <copyout+0x34>
    80000a82:	84d2                	mv	s1,s4
    80000a84:	bf55                	j	80000a38 <copyout+0x34>
  }
  return 0;
    80000a86:	4501                	li	a0,0
    80000a88:	a021                	j	80000a90 <copyout+0x8c>
    80000a8a:	4501                	li	a0,0
}
    80000a8c:	8082                	ret
      return -1;
    80000a8e:	557d                	li	a0,-1
}
    80000a90:	60e6                	ld	ra,88(sp)
    80000a92:	6446                	ld	s0,80(sp)
    80000a94:	64a6                	ld	s1,72(sp)
    80000a96:	6906                	ld	s2,64(sp)
    80000a98:	79e2                	ld	s3,56(sp)
    80000a9a:	7a42                	ld	s4,48(sp)
    80000a9c:	7aa2                	ld	s5,40(sp)
    80000a9e:	7b02                	ld	s6,32(sp)
    80000aa0:	6be2                	ld	s7,24(sp)
    80000aa2:	6c42                	ld	s8,16(sp)
    80000aa4:	6ca2                	ld	s9,8(sp)
    80000aa6:	6d02                	ld	s10,0(sp)
    80000aa8:	6125                	addi	sp,sp,96
    80000aaa:	8082                	ret
      return -1;
    80000aac:	557d                	li	a0,-1
    80000aae:	b7cd                	j	80000a90 <copyout+0x8c>
    80000ab0:	557d                	li	a0,-1
    80000ab2:	bff9                	j	80000a90 <copyout+0x8c>

0000000080000ab4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ab4:	c6a5                	beqz	a3,80000b1c <copyin+0x68>
{
    80000ab6:	715d                	addi	sp,sp,-80
    80000ab8:	e486                	sd	ra,72(sp)
    80000aba:	e0a2                	sd	s0,64(sp)
    80000abc:	fc26                	sd	s1,56(sp)
    80000abe:	f84a                	sd	s2,48(sp)
    80000ac0:	f44e                	sd	s3,40(sp)
    80000ac2:	f052                	sd	s4,32(sp)
    80000ac4:	ec56                	sd	s5,24(sp)
    80000ac6:	e85a                	sd	s6,16(sp)
    80000ac8:	e45e                	sd	s7,8(sp)
    80000aca:	e062                	sd	s8,0(sp)
    80000acc:	0880                	addi	s0,sp,80
    80000ace:	8b2a                	mv	s6,a0
    80000ad0:	8a2e                	mv	s4,a1
    80000ad2:	8c32                	mv	s8,a2
    80000ad4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ad6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ad8:	6a85                	lui	s5,0x1
    80000ada:	a00d                	j	80000afc <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000adc:	018505b3          	add	a1,a0,s8
    80000ae0:	0004861b          	sext.w	a2,s1
    80000ae4:	412585b3          	sub	a1,a1,s2
    80000ae8:	8552                	mv	a0,s4
    80000aea:	ec8ff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000aee:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000af2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000af4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000af8:	02098063          	beqz	s3,80000b18 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000afc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b00:	85ca                	mv	a1,s2
    80000b02:	855a                	mv	a0,s6
    80000b04:	979ff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000b08:	cd01                	beqz	a0,80000b20 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b0a:	418904b3          	sub	s1,s2,s8
    80000b0e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b10:	fc99f6e3          	bgeu	s3,s1,80000adc <copyin+0x28>
    80000b14:	84ce                	mv	s1,s3
    80000b16:	b7d9                	j	80000adc <copyin+0x28>
  }
  return 0;
    80000b18:	4501                	li	a0,0
    80000b1a:	a021                	j	80000b22 <copyin+0x6e>
    80000b1c:	4501                	li	a0,0
}
    80000b1e:	8082                	ret
      return -1;
    80000b20:	557d                	li	a0,-1
}
    80000b22:	60a6                	ld	ra,72(sp)
    80000b24:	6406                	ld	s0,64(sp)
    80000b26:	74e2                	ld	s1,56(sp)
    80000b28:	7942                	ld	s2,48(sp)
    80000b2a:	79a2                	ld	s3,40(sp)
    80000b2c:	7a02                	ld	s4,32(sp)
    80000b2e:	6ae2                	ld	s5,24(sp)
    80000b30:	6b42                	ld	s6,16(sp)
    80000b32:	6ba2                	ld	s7,8(sp)
    80000b34:	6c02                	ld	s8,0(sp)
    80000b36:	6161                	addi	sp,sp,80
    80000b38:	8082                	ret

0000000080000b3a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b3a:	715d                	addi	sp,sp,-80
    80000b3c:	e486                	sd	ra,72(sp)
    80000b3e:	e0a2                	sd	s0,64(sp)
    80000b40:	fc26                	sd	s1,56(sp)
    80000b42:	f84a                	sd	s2,48(sp)
    80000b44:	f44e                	sd	s3,40(sp)
    80000b46:	f052                	sd	s4,32(sp)
    80000b48:	ec56                	sd	s5,24(sp)
    80000b4a:	e85a                	sd	s6,16(sp)
    80000b4c:	e45e                	sd	s7,8(sp)
    80000b4e:	0880                	addi	s0,sp,80
    80000b50:	8aaa                	mv	s5,a0
    80000b52:	89ae                	mv	s3,a1
    80000b54:	8bb2                	mv	s7,a2
    80000b56:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b58:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b5a:	6a05                	lui	s4,0x1
    80000b5c:	a02d                	j	80000b86 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b5e:	00078023          	sb	zero,0(a5)
    80000b62:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b64:	0017c793          	xori	a5,a5,1
    80000b68:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b6c:	60a6                	ld	ra,72(sp)
    80000b6e:	6406                	ld	s0,64(sp)
    80000b70:	74e2                	ld	s1,56(sp)
    80000b72:	7942                	ld	s2,48(sp)
    80000b74:	79a2                	ld	s3,40(sp)
    80000b76:	7a02                	ld	s4,32(sp)
    80000b78:	6ae2                	ld	s5,24(sp)
    80000b7a:	6b42                	ld	s6,16(sp)
    80000b7c:	6ba2                	ld	s7,8(sp)
    80000b7e:	6161                	addi	sp,sp,80
    80000b80:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b82:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000b86:	c4b1                	beqz	s1,80000bd2 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000b88:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000b8c:	85ca                	mv	a1,s2
    80000b8e:	8556                	mv	a0,s5
    80000b90:	8edff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000b94:	c129                	beqz	a0,80000bd6 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000b96:	41790633          	sub	a2,s2,s7
    80000b9a:	9652                	add	a2,a2,s4
    if(n > max)
    80000b9c:	00c4f363          	bgeu	s1,a2,80000ba2 <copyinstr+0x68>
    80000ba0:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ba2:	412b8bb3          	sub	s7,s7,s2
    80000ba6:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000ba8:	de69                	beqz	a2,80000b82 <copyinstr+0x48>
    80000baa:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000bac:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000bb0:	964e                	add	a2,a2,s3
    80000bb2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bb4:	00f68733          	add	a4,a3,a5
    80000bb8:	00074703          	lbu	a4,0(a4)
    80000bbc:	d34d                	beqz	a4,80000b5e <copyinstr+0x24>
        *dst = *p;
    80000bbe:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bc2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bc4:	fec797e3          	bne	a5,a2,80000bb2 <copyinstr+0x78>
    80000bc8:	14fd                	addi	s1,s1,-1
    80000bca:	94ce                	add	s1,s1,s3
      --max;
    80000bcc:	8c8d                	sub	s1,s1,a1
    80000bce:	89be                	mv	s3,a5
    80000bd0:	bf4d                	j	80000b82 <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	bf41                	j	80000b64 <copyinstr+0x2a>
      return -1;
    80000bd6:	557d                	li	a0,-1
    80000bd8:	bf51                	j	80000b6c <copyinstr+0x32>

0000000080000bda <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bda:	715d                	addi	sp,sp,-80
    80000bdc:	e486                	sd	ra,72(sp)
    80000bde:	e0a2                	sd	s0,64(sp)
    80000be0:	fc26                	sd	s1,56(sp)
    80000be2:	f84a                	sd	s2,48(sp)
    80000be4:	f44e                	sd	s3,40(sp)
    80000be6:	f052                	sd	s4,32(sp)
    80000be8:	ec56                	sd	s5,24(sp)
    80000bea:	e85a                	sd	s6,16(sp)
    80000bec:	e45e                	sd	s7,8(sp)
    80000bee:	e062                	sd	s8,0(sp)
    80000bf0:	0880                	addi	s0,sp,80
    80000bf2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf4:	0000a497          	auipc	s1,0xa
    80000bf8:	cac48493          	addi	s1,s1,-852 # 8000a8a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfc:	8c26                	mv	s8,s1
    80000bfe:	e9bd37b7          	lui	a5,0xe9bd3
    80000c02:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bafe27>
    80000c06:	d37a7937          	lui	s2,0xd37a7
    80000c0a:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff537835ce>
    80000c0e:	1902                	slli	s2,s2,0x20
    80000c10:	993e                	add	s2,s2,a5
    80000c12:	040009b7          	lui	s3,0x4000
    80000c16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c18:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c1a:	4b99                	li	s7,6
    80000c1c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	00010a97          	auipc	s5,0x10
    80000c22:	882a8a93          	addi	s5,s5,-1918 # 800104a0 <tickslock>
    char *pa = kalloc();
    80000c26:	cd8ff0ef          	jal	800000fe <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	c121                	beqz	a0,80000c6c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	418485b3          	sub	a1,s1,s8
    80000c32:	8591                	srai	a1,a1,0x4
    80000c34:	032585b3          	mul	a1,a1,s2
    80000c38:	2585                	addiw	a1,a1,1
    80000c3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	875e                	mv	a4,s7
    80000c40:	86da                	mv	a3,s6
    80000c42:	40b985b3          	sub	a1,s3,a1
    80000c46:	8552                	mv	a0,s4
    80000c48:	929ff0ef          	jal	80000570 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	17048493          	addi	s1,s1,368
    80000c50:	fd549be3          	bne	s1,s5,80000c26 <proc_mapstacks+0x4c>
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
      panic("kalloc");
    80000c6c:	00006517          	auipc	a0,0x6
    80000c70:	52c50513          	addi	a0,a0,1324 # 80007198 <etext+0x198>
    80000c74:	7e2040ef          	jal	80005456 <panic>

0000000080000c78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c78:	7139                	addi	sp,sp,-64
    80000c7a:	fc06                	sd	ra,56(sp)
    80000c7c:	f822                	sd	s0,48(sp)
    80000c7e:	f426                	sd	s1,40(sp)
    80000c80:	f04a                	sd	s2,32(sp)
    80000c82:	ec4e                	sd	s3,24(sp)
    80000c84:	e852                	sd	s4,16(sp)
    80000c86:	e456                	sd	s5,8(sp)
    80000c88:	e05a                	sd	s6,0(sp)
    80000c8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c8c:	00006597          	auipc	a1,0x6
    80000c90:	51458593          	addi	a1,a1,1300 # 800071a0 <etext+0x1a0>
    80000c94:	00009517          	auipc	a0,0x9
    80000c98:	7dc50513          	addi	a0,a0,2012 # 8000a470 <pid_lock>
    80000c9c:	265040ef          	jal	80005700 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ca0:	00006597          	auipc	a1,0x6
    80000ca4:	50858593          	addi	a1,a1,1288 # 800071a8 <etext+0x1a8>
    80000ca8:	00009517          	auipc	a0,0x9
    80000cac:	7e050513          	addi	a0,a0,2016 # 8000a488 <wait_lock>
    80000cb0:	251040ef          	jal	80005700 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb4:	0000a497          	auipc	s1,0xa
    80000cb8:	bec48493          	addi	s1,s1,-1044 # 8000a8a0 <proc>
      initlock(&p->lock, "proc");
    80000cbc:	00006b17          	auipc	s6,0x6
    80000cc0:	4fcb0b13          	addi	s6,s6,1276 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc4:	8aa6                	mv	s5,s1
    80000cc6:	e9bd37b7          	lui	a5,0xe9bd3
    80000cca:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bafe27>
    80000cce:	d37a7937          	lui	s2,0xd37a7
    80000cd2:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff537835ce>
    80000cd6:	1902                	slli	s2,s2,0x20
    80000cd8:	993e                	add	s2,s2,a5
    80000cda:	040009b7          	lui	s3,0x4000
    80000cde:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce2:	0000fa17          	auipc	s4,0xf
    80000ce6:	7bea0a13          	addi	s4,s4,1982 # 800104a0 <tickslock>
      initlock(&p->lock, "proc");
    80000cea:	85da                	mv	a1,s6
    80000cec:	8526                	mv	a0,s1
    80000cee:	213040ef          	jal	80005700 <initlock>
      p->state = UNUSED;
    80000cf2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf6:	415487b3          	sub	a5,s1,s5
    80000cfa:	8791                	srai	a5,a5,0x4
    80000cfc:	032787b3          	mul	a5,a5,s2
    80000d00:	2785                	addiw	a5,a5,1
    80000d02:	00d7979b          	slliw	a5,a5,0xd
    80000d06:	40f987b3          	sub	a5,s3,a5
    80000d0a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	17048493          	addi	s1,s1,368
    80000d10:	fd449de3          	bne	s1,s4,80000cea <procinit+0x72>
  }
}
    80000d14:	70e2                	ld	ra,56(sp)
    80000d16:	7442                	ld	s0,48(sp)
    80000d18:	74a2                	ld	s1,40(sp)
    80000d1a:	7902                	ld	s2,32(sp)
    80000d1c:	69e2                	ld	s3,24(sp)
    80000d1e:	6a42                	ld	s4,16(sp)
    80000d20:	6aa2                	ld	s5,8(sp)
    80000d22:	6b02                	ld	s6,0(sp)
    80000d24:	6121                	addi	sp,sp,64
    80000d26:	8082                	ret

0000000080000d28 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e406                	sd	ra,8(sp)
    80000d2c:	e022                	sd	s0,0(sp)
    80000d2e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d30:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d32:	2501                	sext.w	a0,a0
    80000d34:	60a2                	ld	ra,8(sp)
    80000d36:	6402                	ld	s0,0(sp)
    80000d38:	0141                	addi	sp,sp,16
    80000d3a:	8082                	ret

0000000080000d3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d3c:	1141                	addi	sp,sp,-16
    80000d3e:	e406                	sd	ra,8(sp)
    80000d40:	e022                	sd	s0,0(sp)
    80000d42:	0800                	addi	s0,sp,16
    80000d44:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d46:	2781                	sext.w	a5,a5
    80000d48:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d4a:	00009517          	auipc	a0,0x9
    80000d4e:	75650513          	addi	a0,a0,1878 # 8000a4a0 <cpus>
    80000d52:	953e                	add	a0,a0,a5
    80000d54:	60a2                	ld	ra,8(sp)
    80000d56:	6402                	ld	s0,0(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret

0000000080000d5c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d5c:	1101                	addi	sp,sp,-32
    80000d5e:	ec06                	sd	ra,24(sp)
    80000d60:	e822                	sd	s0,16(sp)
    80000d62:	e426                	sd	s1,8(sp)
    80000d64:	1000                	addi	s0,sp,32
  push_off();
    80000d66:	1df040ef          	jal	80005744 <push_off>
    80000d6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d6c:	2781                	sext.w	a5,a5
    80000d6e:	079e                	slli	a5,a5,0x7
    80000d70:	00009717          	auipc	a4,0x9
    80000d74:	70070713          	addi	a4,a4,1792 # 8000a470 <pid_lock>
    80000d78:	97ba                	add	a5,a5,a4
    80000d7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d7c:	24d040ef          	jal	800057c8 <pop_off>
  return p;
}
    80000d80:	8526                	mv	a0,s1
    80000d82:	60e2                	ld	ra,24(sp)
    80000d84:	6442                	ld	s0,16(sp)
    80000d86:	64a2                	ld	s1,8(sp)
    80000d88:	6105                	addi	sp,sp,32
    80000d8a:	8082                	ret

0000000080000d8c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e406                	sd	ra,8(sp)
    80000d90:	e022                	sd	s0,0(sp)
    80000d92:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d94:	fc9ff0ef          	jal	80000d5c <myproc>
    80000d98:	281040ef          	jal	80005818 <release>

  if (first) {
    80000d9c:	00009797          	auipc	a5,0x9
    80000da0:	6147a783          	lw	a5,1556(a5) # 8000a3b0 <first.1>
    80000da4:	e799                	bnez	a5,80000db2 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da6:	2c9000ef          	jal	8000186e <usertrapret>
}
    80000daa:	60a2                	ld	ra,8(sp)
    80000dac:	6402                	ld	s0,0(sp)
    80000dae:	0141                	addi	sp,sp,16
    80000db0:	8082                	ret
    fsinit(ROOTDEV);
    80000db2:	4505                	li	a0,1
    80000db4:	68a010ef          	jal	8000243e <fsinit>
    first = 0;
    80000db8:	00009797          	auipc	a5,0x9
    80000dbc:	5e07ac23          	sw	zero,1528(a5) # 8000a3b0 <first.1>
    __sync_synchronize();
    80000dc0:	0330000f          	fence	rw,rw
    80000dc4:	b7cd                	j	80000da6 <forkret+0x1a>

0000000080000dc6 <allocpid>:
{
    80000dc6:	1101                	addi	sp,sp,-32
    80000dc8:	ec06                	sd	ra,24(sp)
    80000dca:	e822                	sd	s0,16(sp)
    80000dcc:	e426                	sd	s1,8(sp)
    80000dce:	e04a                	sd	s2,0(sp)
    80000dd0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dd2:	00009917          	auipc	s2,0x9
    80000dd6:	69e90913          	addi	s2,s2,1694 # 8000a470 <pid_lock>
    80000dda:	854a                	mv	a0,s2
    80000ddc:	1a9040ef          	jal	80005784 <acquire>
  pid = nextpid;
    80000de0:	00009797          	auipc	a5,0x9
    80000de4:	5d478793          	addi	a5,a5,1492 # 8000a3b4 <nextpid>
    80000de8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000dea:	0014871b          	addiw	a4,s1,1
    80000dee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000df0:	854a                	mv	a0,s2
    80000df2:	227040ef          	jal	80005818 <release>
}
    80000df6:	8526                	mv	a0,s1
    80000df8:	60e2                	ld	ra,24(sp)
    80000dfa:	6442                	ld	s0,16(sp)
    80000dfc:	64a2                	ld	s1,8(sp)
    80000dfe:	6902                	ld	s2,0(sp)
    80000e00:	6105                	addi	sp,sp,32
    80000e02:	8082                	ret

0000000080000e04 <proc_pagetable>:
{
    80000e04:	1101                	addi	sp,sp,-32
    80000e06:	ec06                	sd	ra,24(sp)
    80000e08:	e822                	sd	s0,16(sp)
    80000e0a:	e426                	sd	s1,8(sp)
    80000e0c:	e04a                	sd	s2,0(sp)
    80000e0e:	1000                	addi	s0,sp,32
    80000e10:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e12:	90bff0ef          	jal	8000071c <uvmcreate>
    80000e16:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e18:	cd05                	beqz	a0,80000e50 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e1a:	4729                	li	a4,10
    80000e1c:	00005697          	auipc	a3,0x5
    80000e20:	1e468693          	addi	a3,a3,484 # 80006000 <_trampoline>
    80000e24:	6605                	lui	a2,0x1
    80000e26:	040005b7          	lui	a1,0x4000
    80000e2a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e2c:	05b2                	slli	a1,a1,0xc
    80000e2e:	e8cff0ef          	jal	800004ba <mappages>
    80000e32:	02054663          	bltz	a0,80000e5e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e36:	4719                	li	a4,6
    80000e38:	05893683          	ld	a3,88(s2)
    80000e3c:	6605                	lui	a2,0x1
    80000e3e:	020005b7          	lui	a1,0x2000
    80000e42:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e44:	05b6                	slli	a1,a1,0xd
    80000e46:	8526                	mv	a0,s1
    80000e48:	e72ff0ef          	jal	800004ba <mappages>
    80000e4c:	00054f63          	bltz	a0,80000e6a <proc_pagetable+0x66>
}
    80000e50:	8526                	mv	a0,s1
    80000e52:	60e2                	ld	ra,24(sp)
    80000e54:	6442                	ld	s0,16(sp)
    80000e56:	64a2                	ld	s1,8(sp)
    80000e58:	6902                	ld	s2,0(sp)
    80000e5a:	6105                	addi	sp,sp,32
    80000e5c:	8082                	ret
    uvmfree(pagetable, 0);
    80000e5e:	4581                	li	a1,0
    80000e60:	8526                	mv	a0,s1
    80000e62:	a91ff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e66:	4481                	li	s1,0
    80000e68:	b7e5                	j	80000e50 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e6a:	4681                	li	a3,0
    80000e6c:	4605                	li	a2,1
    80000e6e:	040005b7          	lui	a1,0x4000
    80000e72:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e74:	05b2                	slli	a1,a1,0xc
    80000e76:	8526                	mv	a0,s1
    80000e78:	fe8ff0ef          	jal	80000660 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e7c:	4581                	li	a1,0
    80000e7e:	8526                	mv	a0,s1
    80000e80:	a73ff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e84:	4481                	li	s1,0
    80000e86:	b7e9                	j	80000e50 <proc_pagetable+0x4c>

0000000080000e88 <proc_freepagetable>:
{
    80000e88:	1101                	addi	sp,sp,-32
    80000e8a:	ec06                	sd	ra,24(sp)
    80000e8c:	e822                	sd	s0,16(sp)
    80000e8e:	e426                	sd	s1,8(sp)
    80000e90:	e04a                	sd	s2,0(sp)
    80000e92:	1000                	addi	s0,sp,32
    80000e94:	84aa                	mv	s1,a0
    80000e96:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e98:	4681                	li	a3,0
    80000e9a:	4605                	li	a2,1
    80000e9c:	040005b7          	lui	a1,0x4000
    80000ea0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea2:	05b2                	slli	a1,a1,0xc
    80000ea4:	fbcff0ef          	jal	80000660 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ea8:	4681                	li	a3,0
    80000eaa:	4605                	li	a2,1
    80000eac:	020005b7          	lui	a1,0x2000
    80000eb0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eb2:	05b6                	slli	a1,a1,0xd
    80000eb4:	8526                	mv	a0,s1
    80000eb6:	faaff0ef          	jal	80000660 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eba:	85ca                	mv	a1,s2
    80000ebc:	8526                	mv	a0,s1
    80000ebe:	a35ff0ef          	jal	800008f2 <uvmfree>
}
    80000ec2:	60e2                	ld	ra,24(sp)
    80000ec4:	6442                	ld	s0,16(sp)
    80000ec6:	64a2                	ld	s1,8(sp)
    80000ec8:	6902                	ld	s2,0(sp)
    80000eca:	6105                	addi	sp,sp,32
    80000ecc:	8082                	ret

0000000080000ece <freeproc>:
{
    80000ece:	1101                	addi	sp,sp,-32
    80000ed0:	ec06                	sd	ra,24(sp)
    80000ed2:	e822                	sd	s0,16(sp)
    80000ed4:	e426                	sd	s1,8(sp)
    80000ed6:	1000                	addi	s0,sp,32
    80000ed8:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000eda:	6d28                	ld	a0,88(a0)
    80000edc:	c119                	beqz	a0,80000ee2 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ede:	93eff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ee2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ee6:	68a8                	ld	a0,80(s1)
    80000ee8:	c501                	beqz	a0,80000ef0 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000eea:	64ac                	ld	a1,72(s1)
    80000eec:	f9dff0ef          	jal	80000e88 <proc_freepagetable>
  p->pagetable = 0;
    80000ef0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ef4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ef8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000efc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f00:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f04:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f08:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f0c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f10:	0004ac23          	sw	zero,24(s1)
}
    80000f14:	60e2                	ld	ra,24(sp)
    80000f16:	6442                	ld	s0,16(sp)
    80000f18:	64a2                	ld	s1,8(sp)
    80000f1a:	6105                	addi	sp,sp,32
    80000f1c:	8082                	ret

0000000080000f1e <allocproc>:
{
    80000f1e:	1101                	addi	sp,sp,-32
    80000f20:	ec06                	sd	ra,24(sp)
    80000f22:	e822                	sd	s0,16(sp)
    80000f24:	e426                	sd	s1,8(sp)
    80000f26:	e04a                	sd	s2,0(sp)
    80000f28:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2a:	0000a497          	auipc	s1,0xa
    80000f2e:	97648493          	addi	s1,s1,-1674 # 8000a8a0 <proc>
    80000f32:	0000f917          	auipc	s2,0xf
    80000f36:	56e90913          	addi	s2,s2,1390 # 800104a0 <tickslock>
    acquire(&p->lock);
    80000f3a:	8526                	mv	a0,s1
    80000f3c:	049040ef          	jal	80005784 <acquire>
    if(p->state == UNUSED) {
    80000f40:	4c9c                	lw	a5,24(s1)
    80000f42:	cb91                	beqz	a5,80000f56 <allocproc+0x38>
      release(&p->lock);
    80000f44:	8526                	mv	a0,s1
    80000f46:	0d3040ef          	jal	80005818 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4a:	17048493          	addi	s1,s1,368
    80000f4e:	ff2496e3          	bne	s1,s2,80000f3a <allocproc+0x1c>
  return 0;
    80000f52:	4481                	li	s1,0
    80000f54:	a099                	j	80000f9a <allocproc+0x7c>
  p->pid = allocpid();
    80000f56:	e71ff0ef          	jal	80000dc6 <allocpid>
    80000f5a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f5c:	4785                	li	a5,1
    80000f5e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f60:	99eff0ef          	jal	800000fe <kalloc>
    80000f64:	892a                	mv	s2,a0
    80000f66:	eca8                	sd	a0,88(s1)
    80000f68:	c121                	beqz	a0,80000fa8 <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	e99ff0ef          	jal	80000e04 <proc_pagetable>
    80000f70:	892a                	mv	s2,a0
    80000f72:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f74:	c131                	beqz	a0,80000fb8 <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80000f76:	07000613          	li	a2,112
    80000f7a:	4581                	li	a1,0
    80000f7c:	06048513          	addi	a0,s1,96
    80000f80:	9ceff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f84:	00000797          	auipc	a5,0x0
    80000f88:	e0878793          	addi	a5,a5,-504 # 80000d8c <forkret>
    80000f8c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f8e:	60bc                	ld	a5,64(s1)
    80000f90:	6705                	lui	a4,0x1
    80000f92:	97ba                	add	a5,a5,a4
    80000f94:	f4bc                	sd	a5,104(s1)
  p->syscallMask = 0;
    80000f96:	1604a423          	sw	zero,360(s1)
}
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	60e2                	ld	ra,24(sp)
    80000f9e:	6442                	ld	s0,16(sp)
    80000fa0:	64a2                	ld	s1,8(sp)
    80000fa2:	6902                	ld	s2,0(sp)
    80000fa4:	6105                	addi	sp,sp,32
    80000fa6:	8082                	ret
    freeproc(p);
    80000fa8:	8526                	mv	a0,s1
    80000faa:	f25ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000fae:	8526                	mv	a0,s1
    80000fb0:	069040ef          	jal	80005818 <release>
    return 0;
    80000fb4:	84ca                	mv	s1,s2
    80000fb6:	b7d5                	j	80000f9a <allocproc+0x7c>
    freeproc(p);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	f15ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	059040ef          	jal	80005818 <release>
    return 0;
    80000fc4:	84ca                	mv	s1,s2
    80000fc6:	bfd1                	j	80000f9a <allocproc+0x7c>

0000000080000fc8 <userinit>:
{
    80000fc8:	1101                	addi	sp,sp,-32
    80000fca:	ec06                	sd	ra,24(sp)
    80000fcc:	e822                	sd	s0,16(sp)
    80000fce:	e426                	sd	s1,8(sp)
    80000fd0:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fd2:	f4dff0ef          	jal	80000f1e <allocproc>
    80000fd6:	84aa                	mv	s1,a0
  initproc = p;
    80000fd8:	00009797          	auipc	a5,0x9
    80000fdc:	44a7bc23          	sd	a0,1112(a5) # 8000a430 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fe0:	03400613          	li	a2,52
    80000fe4:	00009597          	auipc	a1,0x9
    80000fe8:	3dc58593          	addi	a1,a1,988 # 8000a3c0 <initcode>
    80000fec:	6928                	ld	a0,80(a0)
    80000fee:	f54ff0ef          	jal	80000742 <uvmfirst>
  p->sz = PGSIZE;
    80000ff2:	6785                	lui	a5,0x1
    80000ff4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ff6:	6cb8                	ld	a4,88(s1)
    80000ff8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ffc:	6cb8                	ld	a4,88(s1)
    80000ffe:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001000:	4641                	li	a2,16
    80001002:	00006597          	auipc	a1,0x6
    80001006:	1be58593          	addi	a1,a1,446 # 800071c0 <etext+0x1c0>
    8000100a:	15848513          	addi	a0,s1,344
    8000100e:	a92ff0ef          	jal	800002a0 <safestrcpy>
  p->cwd = namei("/");
    80001012:	00006517          	auipc	a0,0x6
    80001016:	1be50513          	addi	a0,a0,446 # 800071d0 <etext+0x1d0>
    8000101a:	549010ef          	jal	80002d62 <namei>
    8000101e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001022:	478d                	li	a5,3
    80001024:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001026:	8526                	mv	a0,s1
    80001028:	7f0040ef          	jal	80005818 <release>
}
    8000102c:	60e2                	ld	ra,24(sp)
    8000102e:	6442                	ld	s0,16(sp)
    80001030:	64a2                	ld	s1,8(sp)
    80001032:	6105                	addi	sp,sp,32
    80001034:	8082                	ret

0000000080001036 <growproc>:
{
    80001036:	1101                	addi	sp,sp,-32
    80001038:	ec06                	sd	ra,24(sp)
    8000103a:	e822                	sd	s0,16(sp)
    8000103c:	e426                	sd	s1,8(sp)
    8000103e:	e04a                	sd	s2,0(sp)
    80001040:	1000                	addi	s0,sp,32
    80001042:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001044:	d19ff0ef          	jal	80000d5c <myproc>
    80001048:	84aa                	mv	s1,a0
  sz = p->sz;
    8000104a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000104c:	01204c63          	bgtz	s2,80001064 <growproc+0x2e>
  } else if(n < 0){
    80001050:	02094463          	bltz	s2,80001078 <growproc+0x42>
  p->sz = sz;
    80001054:	e4ac                	sd	a1,72(s1)
  return 0;
    80001056:	4501                	li	a0,0
}
    80001058:	60e2                	ld	ra,24(sp)
    8000105a:	6442                	ld	s0,16(sp)
    8000105c:	64a2                	ld	s1,8(sp)
    8000105e:	6902                	ld	s2,0(sp)
    80001060:	6105                	addi	sp,sp,32
    80001062:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001064:	4691                	li	a3,4
    80001066:	00b90633          	add	a2,s2,a1
    8000106a:	6928                	ld	a0,80(a0)
    8000106c:	f78ff0ef          	jal	800007e4 <uvmalloc>
    80001070:	85aa                	mv	a1,a0
    80001072:	f16d                	bnez	a0,80001054 <growproc+0x1e>
      return -1;
    80001074:	557d                	li	a0,-1
    80001076:	b7cd                	j	80001058 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001078:	00b90633          	add	a2,s2,a1
    8000107c:	6928                	ld	a0,80(a0)
    8000107e:	f22ff0ef          	jal	800007a0 <uvmdealloc>
    80001082:	85aa                	mv	a1,a0
    80001084:	bfc1                	j	80001054 <growproc+0x1e>

0000000080001086 <fork>:
{
    80001086:	7139                	addi	sp,sp,-64
    80001088:	fc06                	sd	ra,56(sp)
    8000108a:	f822                	sd	s0,48(sp)
    8000108c:	f04a                	sd	s2,32(sp)
    8000108e:	e456                	sd	s5,8(sp)
    80001090:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001092:	ccbff0ef          	jal	80000d5c <myproc>
    80001096:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001098:	e87ff0ef          	jal	80000f1e <allocproc>
    8000109c:	0e050e63          	beqz	a0,80001198 <fork+0x112>
    800010a0:	ec4e                	sd	s3,24(sp)
    800010a2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010a4:	048ab603          	ld	a2,72(s5)
    800010a8:	692c                	ld	a1,80(a0)
    800010aa:	050ab503          	ld	a0,80(s5)
    800010ae:	877ff0ef          	jal	80000924 <uvmcopy>
    800010b2:	04054a63          	bltz	a0,80001106 <fork+0x80>
    800010b6:	f426                	sd	s1,40(sp)
    800010b8:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800010ba:	048ab783          	ld	a5,72(s5)
    800010be:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010c2:	058ab683          	ld	a3,88(s5)
    800010c6:	87b6                	mv	a5,a3
    800010c8:	0589b703          	ld	a4,88(s3)
    800010cc:	12068693          	addi	a3,a3,288
    800010d0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010d4:	6788                	ld	a0,8(a5)
    800010d6:	6b8c                	ld	a1,16(a5)
    800010d8:	6f90                	ld	a2,24(a5)
    800010da:	01073023          	sd	a6,0(a4)
    800010de:	e708                	sd	a0,8(a4)
    800010e0:	eb0c                	sd	a1,16(a4)
    800010e2:	ef10                	sd	a2,24(a4)
    800010e4:	02078793          	addi	a5,a5,32
    800010e8:	02070713          	addi	a4,a4,32
    800010ec:	fed792e3          	bne	a5,a3,800010d0 <fork+0x4a>
  np->trapframe->a0 = 0;
    800010f0:	0589b783          	ld	a5,88(s3)
    800010f4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010f8:	0d0a8493          	addi	s1,s5,208
    800010fc:	0d098913          	addi	s2,s3,208
    80001100:	150a8a13          	addi	s4,s5,336
    80001104:	a831                	j	80001120 <fork+0x9a>
    freeproc(np);
    80001106:	854e                	mv	a0,s3
    80001108:	dc7ff0ef          	jal	80000ece <freeproc>
    release(&np->lock);
    8000110c:	854e                	mv	a0,s3
    8000110e:	70a040ef          	jal	80005818 <release>
    return -1;
    80001112:	597d                	li	s2,-1
    80001114:	69e2                	ld	s3,24(sp)
    80001116:	a895                	j	8000118a <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001118:	04a1                	addi	s1,s1,8
    8000111a:	0921                	addi	s2,s2,8
    8000111c:	01448963          	beq	s1,s4,8000112e <fork+0xa8>
    if(p->ofile[i])
    80001120:	6088                	ld	a0,0(s1)
    80001122:	d97d                	beqz	a0,80001118 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001124:	1da020ef          	jal	800032fe <filedup>
    80001128:	00a93023          	sd	a0,0(s2)
    8000112c:	b7f5                	j	80001118 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000112e:	150ab503          	ld	a0,336(s5)
    80001132:	50a010ef          	jal	8000263c <idup>
    80001136:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000113a:	4641                	li	a2,16
    8000113c:	158a8593          	addi	a1,s5,344
    80001140:	15898513          	addi	a0,s3,344
    80001144:	95cff0ef          	jal	800002a0 <safestrcpy>
  pid = np->pid;
    80001148:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000114c:	854e                	mv	a0,s3
    8000114e:	6ca040ef          	jal	80005818 <release>
  acquire(&wait_lock);
    80001152:	00009497          	auipc	s1,0x9
    80001156:	33648493          	addi	s1,s1,822 # 8000a488 <wait_lock>
    8000115a:	8526                	mv	a0,s1
    8000115c:	628040ef          	jal	80005784 <acquire>
  np->parent = p;
    80001160:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001164:	8526                	mv	a0,s1
    80001166:	6b2040ef          	jal	80005818 <release>
  acquire(&np->lock);
    8000116a:	854e                	mv	a0,s3
    8000116c:	618040ef          	jal	80005784 <acquire>
  np->state = RUNNABLE;
    80001170:	478d                	li	a5,3
    80001172:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001176:	854e                	mv	a0,s3
    80001178:	6a0040ef          	jal	80005818 <release>
  np->syscallMask = p->syscallMask;
    8000117c:	168aa783          	lw	a5,360(s5)
    80001180:	16f9a423          	sw	a5,360(s3)
  return pid;
    80001184:	74a2                	ld	s1,40(sp)
    80001186:	69e2                	ld	s3,24(sp)
    80001188:	6a42                	ld	s4,16(sp)
}
    8000118a:	854a                	mv	a0,s2
    8000118c:	70e2                	ld	ra,56(sp)
    8000118e:	7442                	ld	s0,48(sp)
    80001190:	7902                	ld	s2,32(sp)
    80001192:	6aa2                	ld	s5,8(sp)
    80001194:	6121                	addi	sp,sp,64
    80001196:	8082                	ret
    return -1;
    80001198:	597d                	li	s2,-1
    8000119a:	bfc5                	j	8000118a <fork+0x104>

000000008000119c <scheduler>:
{
    8000119c:	715d                	addi	sp,sp,-80
    8000119e:	e486                	sd	ra,72(sp)
    800011a0:	e0a2                	sd	s0,64(sp)
    800011a2:	fc26                	sd	s1,56(sp)
    800011a4:	f84a                	sd	s2,48(sp)
    800011a6:	f44e                	sd	s3,40(sp)
    800011a8:	f052                	sd	s4,32(sp)
    800011aa:	ec56                	sd	s5,24(sp)
    800011ac:	e85a                	sd	s6,16(sp)
    800011ae:	e45e                	sd	s7,8(sp)
    800011b0:	e062                	sd	s8,0(sp)
    800011b2:	0880                	addi	s0,sp,80
    800011b4:	8792                	mv	a5,tp
  int id = r_tp();
    800011b6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011b8:	00779b13          	slli	s6,a5,0x7
    800011bc:	00009717          	auipc	a4,0x9
    800011c0:	2b470713          	addi	a4,a4,692 # 8000a470 <pid_lock>
    800011c4:	975a                	add	a4,a4,s6
    800011c6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011ca:	00009717          	auipc	a4,0x9
    800011ce:	2de70713          	addi	a4,a4,734 # 8000a4a8 <cpus+0x8>
    800011d2:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011d4:	4c11                	li	s8,4
        c->proc = p;
    800011d6:	079e                	slli	a5,a5,0x7
    800011d8:	00009a17          	auipc	s4,0x9
    800011dc:	298a0a13          	addi	s4,s4,664 # 8000a470 <pid_lock>
    800011e0:	9a3e                	add	s4,s4,a5
        found = 1;
    800011e2:	4b85                	li	s7,1
    800011e4:	a0a9                	j	8000122e <scheduler+0x92>
      release(&p->lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	630040ef          	jal	80005818 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ec:	17048493          	addi	s1,s1,368
    800011f0:	03248563          	beq	s1,s2,8000121a <scheduler+0x7e>
      acquire(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	58e040ef          	jal	80005784 <acquire>
      if(p->state == RUNNABLE) {
    800011fa:	4c9c                	lw	a5,24(s1)
    800011fc:	ff3795e3          	bne	a5,s3,800011e6 <scheduler+0x4a>
        p->state = RUNNING;
    80001200:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001204:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001208:	06048593          	addi	a1,s1,96
    8000120c:	855a                	mv	a0,s6
    8000120e:	5b6000ef          	jal	800017c4 <swtch>
        c->proc = 0;
    80001212:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001216:	8ade                	mv	s5,s7
    80001218:	b7f9                	j	800011e6 <scheduler+0x4a>
    if(found == 0) {
    8000121a:	000a9a63          	bnez	s5,8000122e <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000121e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001222:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001226:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000122a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000122e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001232:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001236:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000123a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123c:	00009497          	auipc	s1,0x9
    80001240:	66448493          	addi	s1,s1,1636 # 8000a8a0 <proc>
      if(p->state == RUNNABLE) {
    80001244:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001246:	0000f917          	auipc	s2,0xf
    8000124a:	25a90913          	addi	s2,s2,602 # 800104a0 <tickslock>
    8000124e:	b75d                	j	800011f4 <scheduler+0x58>

0000000080001250 <sched>:
{
    80001250:	7179                	addi	sp,sp,-48
    80001252:	f406                	sd	ra,40(sp)
    80001254:	f022                	sd	s0,32(sp)
    80001256:	ec26                	sd	s1,24(sp)
    80001258:	e84a                	sd	s2,16(sp)
    8000125a:	e44e                	sd	s3,8(sp)
    8000125c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000125e:	affff0ef          	jal	80000d5c <myproc>
    80001262:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001264:	4b6040ef          	jal	8000571a <holding>
    80001268:	c92d                	beqz	a0,800012da <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000126a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000126c:	2781                	sext.w	a5,a5
    8000126e:	079e                	slli	a5,a5,0x7
    80001270:	00009717          	auipc	a4,0x9
    80001274:	20070713          	addi	a4,a4,512 # 8000a470 <pid_lock>
    80001278:	97ba                	add	a5,a5,a4
    8000127a:	0a87a703          	lw	a4,168(a5)
    8000127e:	4785                	li	a5,1
    80001280:	06f71363          	bne	a4,a5,800012e6 <sched+0x96>
  if(p->state == RUNNING)
    80001284:	4c98                	lw	a4,24(s1)
    80001286:	4791                	li	a5,4
    80001288:	06f70563          	beq	a4,a5,800012f2 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000128c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001290:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001292:	e7b5                	bnez	a5,800012fe <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001294:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001296:	00009917          	auipc	s2,0x9
    8000129a:	1da90913          	addi	s2,s2,474 # 8000a470 <pid_lock>
    8000129e:	2781                	sext.w	a5,a5
    800012a0:	079e                	slli	a5,a5,0x7
    800012a2:	97ca                	add	a5,a5,s2
    800012a4:	0ac7a983          	lw	s3,172(a5)
    800012a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012aa:	2781                	sext.w	a5,a5
    800012ac:	079e                	slli	a5,a5,0x7
    800012ae:	00009597          	auipc	a1,0x9
    800012b2:	1fa58593          	addi	a1,a1,506 # 8000a4a8 <cpus+0x8>
    800012b6:	95be                	add	a1,a1,a5
    800012b8:	06048513          	addi	a0,s1,96
    800012bc:	508000ef          	jal	800017c4 <swtch>
    800012c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012c2:	2781                	sext.w	a5,a5
    800012c4:	079e                	slli	a5,a5,0x7
    800012c6:	993e                	add	s2,s2,a5
    800012c8:	0b392623          	sw	s3,172(s2)
}
    800012cc:	70a2                	ld	ra,40(sp)
    800012ce:	7402                	ld	s0,32(sp)
    800012d0:	64e2                	ld	s1,24(sp)
    800012d2:	6942                	ld	s2,16(sp)
    800012d4:	69a2                	ld	s3,8(sp)
    800012d6:	6145                	addi	sp,sp,48
    800012d8:	8082                	ret
    panic("sched p->lock");
    800012da:	00006517          	auipc	a0,0x6
    800012de:	efe50513          	addi	a0,a0,-258 # 800071d8 <etext+0x1d8>
    800012e2:	174040ef          	jal	80005456 <panic>
    panic("sched locks");
    800012e6:	00006517          	auipc	a0,0x6
    800012ea:	f0250513          	addi	a0,a0,-254 # 800071e8 <etext+0x1e8>
    800012ee:	168040ef          	jal	80005456 <panic>
    panic("sched running");
    800012f2:	00006517          	auipc	a0,0x6
    800012f6:	f0650513          	addi	a0,a0,-250 # 800071f8 <etext+0x1f8>
    800012fa:	15c040ef          	jal	80005456 <panic>
    panic("sched interruptible");
    800012fe:	00006517          	auipc	a0,0x6
    80001302:	f0a50513          	addi	a0,a0,-246 # 80007208 <etext+0x208>
    80001306:	150040ef          	jal	80005456 <panic>

000000008000130a <yield>:
{
    8000130a:	1101                	addi	sp,sp,-32
    8000130c:	ec06                	sd	ra,24(sp)
    8000130e:	e822                	sd	s0,16(sp)
    80001310:	e426                	sd	s1,8(sp)
    80001312:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001314:	a49ff0ef          	jal	80000d5c <myproc>
    80001318:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000131a:	46a040ef          	jal	80005784 <acquire>
  p->state = RUNNABLE;
    8000131e:	478d                	li	a5,3
    80001320:	cc9c                	sw	a5,24(s1)
  sched();
    80001322:	f2fff0ef          	jal	80001250 <sched>
  release(&p->lock);
    80001326:	8526                	mv	a0,s1
    80001328:	4f0040ef          	jal	80005818 <release>
}
    8000132c:	60e2                	ld	ra,24(sp)
    8000132e:	6442                	ld	s0,16(sp)
    80001330:	64a2                	ld	s1,8(sp)
    80001332:	6105                	addi	sp,sp,32
    80001334:	8082                	ret

0000000080001336 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001336:	7179                	addi	sp,sp,-48
    80001338:	f406                	sd	ra,40(sp)
    8000133a:	f022                	sd	s0,32(sp)
    8000133c:	ec26                	sd	s1,24(sp)
    8000133e:	e84a                	sd	s2,16(sp)
    80001340:	e44e                	sd	s3,8(sp)
    80001342:	1800                	addi	s0,sp,48
    80001344:	89aa                	mv	s3,a0
    80001346:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001348:	a15ff0ef          	jal	80000d5c <myproc>
    8000134c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000134e:	436040ef          	jal	80005784 <acquire>
  release(lk);
    80001352:	854a                	mv	a0,s2
    80001354:	4c4040ef          	jal	80005818 <release>

  // Go to sleep.
  p->chan = chan;
    80001358:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000135c:	4789                	li	a5,2
    8000135e:	cc9c                	sw	a5,24(s1)

  sched();
    80001360:	ef1ff0ef          	jal	80001250 <sched>

  // Tidy up.
  p->chan = 0;
    80001364:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001368:	8526                	mv	a0,s1
    8000136a:	4ae040ef          	jal	80005818 <release>
  acquire(lk);
    8000136e:	854a                	mv	a0,s2
    80001370:	414040ef          	jal	80005784 <acquire>
}
    80001374:	70a2                	ld	ra,40(sp)
    80001376:	7402                	ld	s0,32(sp)
    80001378:	64e2                	ld	s1,24(sp)
    8000137a:	6942                	ld	s2,16(sp)
    8000137c:	69a2                	ld	s3,8(sp)
    8000137e:	6145                	addi	sp,sp,48
    80001380:	8082                	ret

0000000080001382 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001382:	7139                	addi	sp,sp,-64
    80001384:	fc06                	sd	ra,56(sp)
    80001386:	f822                	sd	s0,48(sp)
    80001388:	f426                	sd	s1,40(sp)
    8000138a:	f04a                	sd	s2,32(sp)
    8000138c:	ec4e                	sd	s3,24(sp)
    8000138e:	e852                	sd	s4,16(sp)
    80001390:	e456                	sd	s5,8(sp)
    80001392:	0080                	addi	s0,sp,64
    80001394:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	00009497          	auipc	s1,0x9
    8000139a:	50a48493          	addi	s1,s1,1290 # 8000a8a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000139e:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013a0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a2:	0000f917          	auipc	s2,0xf
    800013a6:	0fe90913          	addi	s2,s2,254 # 800104a0 <tickslock>
    800013aa:	a801                	j	800013ba <wakeup+0x38>
      }
      release(&p->lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	46a040ef          	jal	80005818 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013b2:	17048493          	addi	s1,s1,368
    800013b6:	03248263          	beq	s1,s2,800013da <wakeup+0x58>
    if(p != myproc()){
    800013ba:	9a3ff0ef          	jal	80000d5c <myproc>
    800013be:	fea48ae3          	beq	s1,a0,800013b2 <wakeup+0x30>
      acquire(&p->lock);
    800013c2:	8526                	mv	a0,s1
    800013c4:	3c0040ef          	jal	80005784 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013c8:	4c9c                	lw	a5,24(s1)
    800013ca:	ff3791e3          	bne	a5,s3,800013ac <wakeup+0x2a>
    800013ce:	709c                	ld	a5,32(s1)
    800013d0:	fd479ee3          	bne	a5,s4,800013ac <wakeup+0x2a>
        p->state = RUNNABLE;
    800013d4:	0154ac23          	sw	s5,24(s1)
    800013d8:	bfd1                	j	800013ac <wakeup+0x2a>
    }
  }
}
    800013da:	70e2                	ld	ra,56(sp)
    800013dc:	7442                	ld	s0,48(sp)
    800013de:	74a2                	ld	s1,40(sp)
    800013e0:	7902                	ld	s2,32(sp)
    800013e2:	69e2                	ld	s3,24(sp)
    800013e4:	6a42                	ld	s4,16(sp)
    800013e6:	6aa2                	ld	s5,8(sp)
    800013e8:	6121                	addi	sp,sp,64
    800013ea:	8082                	ret

00000000800013ec <reparent>:
{
    800013ec:	7179                	addi	sp,sp,-48
    800013ee:	f406                	sd	ra,40(sp)
    800013f0:	f022                	sd	s0,32(sp)
    800013f2:	ec26                	sd	s1,24(sp)
    800013f4:	e84a                	sd	s2,16(sp)
    800013f6:	e44e                	sd	s3,8(sp)
    800013f8:	e052                	sd	s4,0(sp)
    800013fa:	1800                	addi	s0,sp,48
    800013fc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013fe:	00009497          	auipc	s1,0x9
    80001402:	4a248493          	addi	s1,s1,1186 # 8000a8a0 <proc>
      pp->parent = initproc;
    80001406:	00009a17          	auipc	s4,0x9
    8000140a:	02aa0a13          	addi	s4,s4,42 # 8000a430 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000140e:	0000f997          	auipc	s3,0xf
    80001412:	09298993          	addi	s3,s3,146 # 800104a0 <tickslock>
    80001416:	a029                	j	80001420 <reparent+0x34>
    80001418:	17048493          	addi	s1,s1,368
    8000141c:	01348b63          	beq	s1,s3,80001432 <reparent+0x46>
    if(pp->parent == p){
    80001420:	7c9c                	ld	a5,56(s1)
    80001422:	ff279be3          	bne	a5,s2,80001418 <reparent+0x2c>
      pp->parent = initproc;
    80001426:	000a3503          	ld	a0,0(s4)
    8000142a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000142c:	f57ff0ef          	jal	80001382 <wakeup>
    80001430:	b7e5                	j	80001418 <reparent+0x2c>
}
    80001432:	70a2                	ld	ra,40(sp)
    80001434:	7402                	ld	s0,32(sp)
    80001436:	64e2                	ld	s1,24(sp)
    80001438:	6942                	ld	s2,16(sp)
    8000143a:	69a2                	ld	s3,8(sp)
    8000143c:	6a02                	ld	s4,0(sp)
    8000143e:	6145                	addi	sp,sp,48
    80001440:	8082                	ret

0000000080001442 <exit>:
{
    80001442:	7179                	addi	sp,sp,-48
    80001444:	f406                	sd	ra,40(sp)
    80001446:	f022                	sd	s0,32(sp)
    80001448:	ec26                	sd	s1,24(sp)
    8000144a:	e84a                	sd	s2,16(sp)
    8000144c:	e44e                	sd	s3,8(sp)
    8000144e:	e052                	sd	s4,0(sp)
    80001450:	1800                	addi	s0,sp,48
    80001452:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001454:	909ff0ef          	jal	80000d5c <myproc>
    80001458:	89aa                	mv	s3,a0
  if(p == initproc)
    8000145a:	00009797          	auipc	a5,0x9
    8000145e:	fd67b783          	ld	a5,-42(a5) # 8000a430 <initproc>
    80001462:	0d050493          	addi	s1,a0,208
    80001466:	15050913          	addi	s2,a0,336
    8000146a:	00a79b63          	bne	a5,a0,80001480 <exit+0x3e>
    panic("init exiting");
    8000146e:	00006517          	auipc	a0,0x6
    80001472:	db250513          	addi	a0,a0,-590 # 80007220 <etext+0x220>
    80001476:	7e1030ef          	jal	80005456 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000147a:	04a1                	addi	s1,s1,8
    8000147c:	01248963          	beq	s1,s2,8000148e <exit+0x4c>
    if(p->ofile[fd]){
    80001480:	6088                	ld	a0,0(s1)
    80001482:	dd65                	beqz	a0,8000147a <exit+0x38>
      fileclose(f);
    80001484:	6c1010ef          	jal	80003344 <fileclose>
      p->ofile[fd] = 0;
    80001488:	0004b023          	sd	zero,0(s1)
    8000148c:	b7fd                	j	8000147a <exit+0x38>
  begin_op();
    8000148e:	297010ef          	jal	80002f24 <begin_op>
  iput(p->cwd);
    80001492:	1509b503          	ld	a0,336(s3)
    80001496:	35e010ef          	jal	800027f4 <iput>
  end_op();
    8000149a:	2f5010ef          	jal	80002f8e <end_op>
  p->cwd = 0;
    8000149e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014a2:	00009497          	auipc	s1,0x9
    800014a6:	fe648493          	addi	s1,s1,-26 # 8000a488 <wait_lock>
    800014aa:	8526                	mv	a0,s1
    800014ac:	2d8040ef          	jal	80005784 <acquire>
  reparent(p);
    800014b0:	854e                	mv	a0,s3
    800014b2:	f3bff0ef          	jal	800013ec <reparent>
  wakeup(p->parent);
    800014b6:	0389b503          	ld	a0,56(s3)
    800014ba:	ec9ff0ef          	jal	80001382 <wakeup>
  acquire(&p->lock);
    800014be:	854e                	mv	a0,s3
    800014c0:	2c4040ef          	jal	80005784 <acquire>
  p->xstate = status;
    800014c4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c8:	4795                	li	a5,5
    800014ca:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014ce:	8526                	mv	a0,s1
    800014d0:	348040ef          	jal	80005818 <release>
  sched();
    800014d4:	d7dff0ef          	jal	80001250 <sched>
  panic("zombie exit");
    800014d8:	00006517          	auipc	a0,0x6
    800014dc:	d5850513          	addi	a0,a0,-680 # 80007230 <etext+0x230>
    800014e0:	777030ef          	jal	80005456 <panic>

00000000800014e4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014e4:	7179                	addi	sp,sp,-48
    800014e6:	f406                	sd	ra,40(sp)
    800014e8:	f022                	sd	s0,32(sp)
    800014ea:	ec26                	sd	s1,24(sp)
    800014ec:	e84a                	sd	s2,16(sp)
    800014ee:	e44e                	sd	s3,8(sp)
    800014f0:	1800                	addi	s0,sp,48
    800014f2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014f4:	00009497          	auipc	s1,0x9
    800014f8:	3ac48493          	addi	s1,s1,940 # 8000a8a0 <proc>
    800014fc:	0000f997          	auipc	s3,0xf
    80001500:	fa498993          	addi	s3,s3,-92 # 800104a0 <tickslock>
    acquire(&p->lock);
    80001504:	8526                	mv	a0,s1
    80001506:	27e040ef          	jal	80005784 <acquire>
    if(p->pid == pid){
    8000150a:	589c                	lw	a5,48(s1)
    8000150c:	01278b63          	beq	a5,s2,80001522 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001510:	8526                	mv	a0,s1
    80001512:	306040ef          	jal	80005818 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001516:	17048493          	addi	s1,s1,368
    8000151a:	ff3495e3          	bne	s1,s3,80001504 <kill+0x20>
  }
  return -1;
    8000151e:	557d                	li	a0,-1
    80001520:	a819                	j	80001536 <kill+0x52>
      p->killed = 1;
    80001522:	4785                	li	a5,1
    80001524:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001526:	4c98                	lw	a4,24(s1)
    80001528:	4789                	li	a5,2
    8000152a:	00f70d63          	beq	a4,a5,80001544 <kill+0x60>
      release(&p->lock);
    8000152e:	8526                	mv	a0,s1
    80001530:	2e8040ef          	jal	80005818 <release>
      return 0;
    80001534:	4501                	li	a0,0
}
    80001536:	70a2                	ld	ra,40(sp)
    80001538:	7402                	ld	s0,32(sp)
    8000153a:	64e2                	ld	s1,24(sp)
    8000153c:	6942                	ld	s2,16(sp)
    8000153e:	69a2                	ld	s3,8(sp)
    80001540:	6145                	addi	sp,sp,48
    80001542:	8082                	ret
        p->state = RUNNABLE;
    80001544:	478d                	li	a5,3
    80001546:	cc9c                	sw	a5,24(s1)
    80001548:	b7dd                	j	8000152e <kill+0x4a>

000000008000154a <setkilled>:

void
setkilled(struct proc *p)
{
    8000154a:	1101                	addi	sp,sp,-32
    8000154c:	ec06                	sd	ra,24(sp)
    8000154e:	e822                	sd	s0,16(sp)
    80001550:	e426                	sd	s1,8(sp)
    80001552:	1000                	addi	s0,sp,32
    80001554:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001556:	22e040ef          	jal	80005784 <acquire>
  p->killed = 1;
    8000155a:	4785                	li	a5,1
    8000155c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	2b8040ef          	jal	80005818 <release>
}
    80001564:	60e2                	ld	ra,24(sp)
    80001566:	6442                	ld	s0,16(sp)
    80001568:	64a2                	ld	s1,8(sp)
    8000156a:	6105                	addi	sp,sp,32
    8000156c:	8082                	ret

000000008000156e <killed>:

int
killed(struct proc *p)
{
    8000156e:	1101                	addi	sp,sp,-32
    80001570:	ec06                	sd	ra,24(sp)
    80001572:	e822                	sd	s0,16(sp)
    80001574:	e426                	sd	s1,8(sp)
    80001576:	e04a                	sd	s2,0(sp)
    80001578:	1000                	addi	s0,sp,32
    8000157a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000157c:	208040ef          	jal	80005784 <acquire>
  k = p->killed;
    80001580:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	292040ef          	jal	80005818 <release>
  return k;
}
    8000158a:	854a                	mv	a0,s2
    8000158c:	60e2                	ld	ra,24(sp)
    8000158e:	6442                	ld	s0,16(sp)
    80001590:	64a2                	ld	s1,8(sp)
    80001592:	6902                	ld	s2,0(sp)
    80001594:	6105                	addi	sp,sp,32
    80001596:	8082                	ret

0000000080001598 <wait>:
{
    80001598:	715d                	addi	sp,sp,-80
    8000159a:	e486                	sd	ra,72(sp)
    8000159c:	e0a2                	sd	s0,64(sp)
    8000159e:	fc26                	sd	s1,56(sp)
    800015a0:	f84a                	sd	s2,48(sp)
    800015a2:	f44e                	sd	s3,40(sp)
    800015a4:	f052                	sd	s4,32(sp)
    800015a6:	ec56                	sd	s5,24(sp)
    800015a8:	e85a                	sd	s6,16(sp)
    800015aa:	e45e                	sd	s7,8(sp)
    800015ac:	0880                	addi	s0,sp,80
    800015ae:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b0:	facff0ef          	jal	80000d5c <myproc>
    800015b4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b6:	00009517          	auipc	a0,0x9
    800015ba:	ed250513          	addi	a0,a0,-302 # 8000a488 <wait_lock>
    800015be:	1c6040ef          	jal	80005784 <acquire>
        if(pp->state == ZOMBIE){
    800015c2:	4a15                	li	s4,5
        havekids = 1;
    800015c4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c6:	0000f997          	auipc	s3,0xf
    800015ca:	eda98993          	addi	s3,s3,-294 # 800104a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015ce:	00009b97          	auipc	s7,0x9
    800015d2:	ebab8b93          	addi	s7,s7,-326 # 8000a488 <wait_lock>
    800015d6:	a869                	j	80001670 <wait+0xd8>
          pid = pp->pid;
    800015d8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015dc:	000b0c63          	beqz	s6,800015f4 <wait+0x5c>
    800015e0:	4691                	li	a3,4
    800015e2:	02c48613          	addi	a2,s1,44
    800015e6:	85da                	mv	a1,s6
    800015e8:	05093503          	ld	a0,80(s2)
    800015ec:	c18ff0ef          	jal	80000a04 <copyout>
    800015f0:	02054a63          	bltz	a0,80001624 <wait+0x8c>
          freeproc(pp);
    800015f4:	8526                	mv	a0,s1
    800015f6:	8d9ff0ef          	jal	80000ece <freeproc>
          release(&pp->lock);
    800015fa:	8526                	mv	a0,s1
    800015fc:	21c040ef          	jal	80005818 <release>
          release(&wait_lock);
    80001600:	00009517          	auipc	a0,0x9
    80001604:	e8850513          	addi	a0,a0,-376 # 8000a488 <wait_lock>
    80001608:	210040ef          	jal	80005818 <release>
}
    8000160c:	854e                	mv	a0,s3
    8000160e:	60a6                	ld	ra,72(sp)
    80001610:	6406                	ld	s0,64(sp)
    80001612:	74e2                	ld	s1,56(sp)
    80001614:	7942                	ld	s2,48(sp)
    80001616:	79a2                	ld	s3,40(sp)
    80001618:	7a02                	ld	s4,32(sp)
    8000161a:	6ae2                	ld	s5,24(sp)
    8000161c:	6b42                	ld	s6,16(sp)
    8000161e:	6ba2                	ld	s7,8(sp)
    80001620:	6161                	addi	sp,sp,80
    80001622:	8082                	ret
            release(&pp->lock);
    80001624:	8526                	mv	a0,s1
    80001626:	1f2040ef          	jal	80005818 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	e5e50513          	addi	a0,a0,-418 # 8000a488 <wait_lock>
    80001632:	1e6040ef          	jal	80005818 <release>
            return -1;
    80001636:	59fd                	li	s3,-1
    80001638:	bfd1                	j	8000160c <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163a:	17048493          	addi	s1,s1,368
    8000163e:	03348063          	beq	s1,s3,8000165e <wait+0xc6>
      if(pp->parent == p){
    80001642:	7c9c                	ld	a5,56(s1)
    80001644:	ff279be3          	bne	a5,s2,8000163a <wait+0xa2>
        acquire(&pp->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	13a040ef          	jal	80005784 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94784e3          	beq	a5,s4,800015d8 <wait+0x40>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	1c2040ef          	jal	80005818 <release>
        havekids = 1;
    8000165a:	8756                	mv	a4,s5
    8000165c:	bff9                	j	8000163a <wait+0xa2>
    if(!havekids || killed(p)){
    8000165e:	cf19                	beqz	a4,8000167c <wait+0xe4>
    80001660:	854a                	mv	a0,s2
    80001662:	f0dff0ef          	jal	8000156e <killed>
    80001666:	e919                	bnez	a0,8000167c <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001668:	85de                	mv	a1,s7
    8000166a:	854a                	mv	a0,s2
    8000166c:	ccbff0ef          	jal	80001336 <sleep>
    havekids = 0;
    80001670:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001672:	00009497          	auipc	s1,0x9
    80001676:	22e48493          	addi	s1,s1,558 # 8000a8a0 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xaa>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	e0c50513          	addi	a0,a0,-500 # 8000a488 <wait_lock>
    80001684:	194040ef          	jal	80005818 <release>
      return -1;
    80001688:	59fd                	li	s3,-1
    8000168a:	b749                	j	8000160c <wait+0x74>

000000008000168c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000168c:	7179                	addi	sp,sp,-48
    8000168e:	f406                	sd	ra,40(sp)
    80001690:	f022                	sd	s0,32(sp)
    80001692:	ec26                	sd	s1,24(sp)
    80001694:	e84a                	sd	s2,16(sp)
    80001696:	e44e                	sd	s3,8(sp)
    80001698:	e052                	sd	s4,0(sp)
    8000169a:	1800                	addi	s0,sp,48
    8000169c:	84aa                	mv	s1,a0
    8000169e:	892e                	mv	s2,a1
    800016a0:	89b2                	mv	s3,a2
    800016a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016a4:	eb8ff0ef          	jal	80000d5c <myproc>
  if(user_dst){
    800016a8:	cc99                	beqz	s1,800016c6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016aa:	86d2                	mv	a3,s4
    800016ac:	864e                	mv	a2,s3
    800016ae:	85ca                	mv	a1,s2
    800016b0:	6928                	ld	a0,80(a0)
    800016b2:	b52ff0ef          	jal	80000a04 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016b6:	70a2                	ld	ra,40(sp)
    800016b8:	7402                	ld	s0,32(sp)
    800016ba:	64e2                	ld	s1,24(sp)
    800016bc:	6942                	ld	s2,16(sp)
    800016be:	69a2                	ld	s3,8(sp)
    800016c0:	6a02                	ld	s4,0(sp)
    800016c2:	6145                	addi	sp,sp,48
    800016c4:	8082                	ret
    memmove((char *)dst, src, len);
    800016c6:	000a061b          	sext.w	a2,s4
    800016ca:	85ce                	mv	a1,s3
    800016cc:	854a                	mv	a0,s2
    800016ce:	ae5fe0ef          	jal	800001b2 <memmove>
    return 0;
    800016d2:	8526                	mv	a0,s1
    800016d4:	b7cd                	j	800016b6 <either_copyout+0x2a>

00000000800016d6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016d6:	7179                	addi	sp,sp,-48
    800016d8:	f406                	sd	ra,40(sp)
    800016da:	f022                	sd	s0,32(sp)
    800016dc:	ec26                	sd	s1,24(sp)
    800016de:	e84a                	sd	s2,16(sp)
    800016e0:	e44e                	sd	s3,8(sp)
    800016e2:	e052                	sd	s4,0(sp)
    800016e4:	1800                	addi	s0,sp,48
    800016e6:	892a                	mv	s2,a0
    800016e8:	84ae                	mv	s1,a1
    800016ea:	89b2                	mv	s3,a2
    800016ec:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016ee:	e6eff0ef          	jal	80000d5c <myproc>
  if(user_src){
    800016f2:	cc99                	beqz	s1,80001710 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016f4:	86d2                	mv	a3,s4
    800016f6:	864e                	mv	a2,s3
    800016f8:	85ca                	mv	a1,s2
    800016fa:	6928                	ld	a0,80(a0)
    800016fc:	bb8ff0ef          	jal	80000ab4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001700:	70a2                	ld	ra,40(sp)
    80001702:	7402                	ld	s0,32(sp)
    80001704:	64e2                	ld	s1,24(sp)
    80001706:	6942                	ld	s2,16(sp)
    80001708:	69a2                	ld	s3,8(sp)
    8000170a:	6a02                	ld	s4,0(sp)
    8000170c:	6145                	addi	sp,sp,48
    8000170e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001710:	000a061b          	sext.w	a2,s4
    80001714:	85ce                	mv	a1,s3
    80001716:	854a                	mv	a0,s2
    80001718:	a9bfe0ef          	jal	800001b2 <memmove>
    return 0;
    8000171c:	8526                	mv	a0,s1
    8000171e:	b7cd                	j	80001700 <either_copyin+0x2a>

0000000080001720 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001720:	715d                	addi	sp,sp,-80
    80001722:	e486                	sd	ra,72(sp)
    80001724:	e0a2                	sd	s0,64(sp)
    80001726:	fc26                	sd	s1,56(sp)
    80001728:	f84a                	sd	s2,48(sp)
    8000172a:	f44e                	sd	s3,40(sp)
    8000172c:	f052                	sd	s4,32(sp)
    8000172e:	ec56                	sd	s5,24(sp)
    80001730:	e85a                	sd	s6,16(sp)
    80001732:	e45e                	sd	s7,8(sp)
    80001734:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001736:	00006517          	auipc	a0,0x6
    8000173a:	8e250513          	addi	a0,a0,-1822 # 80007018 <etext+0x18>
    8000173e:	249030ef          	jal	80005186 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00009497          	auipc	s1,0x9
    80001746:	2b648493          	addi	s1,s1,694 # 8000a9f8 <proc+0x158>
    8000174a:	0000f917          	auipc	s2,0xf
    8000174e:	eae90913          	addi	s2,s2,-338 # 800105f8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001752:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001754:	00006997          	auipc	s3,0x6
    80001758:	aec98993          	addi	s3,s3,-1300 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    8000175c:	00006a97          	auipc	s5,0x6
    80001760:	aeca8a93          	addi	s5,s5,-1300 # 80007248 <etext+0x248>
    printf("\n");
    80001764:	00006a17          	auipc	s4,0x6
    80001768:	8b4a0a13          	addi	s4,s4,-1868 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000176c:	00006b97          	auipc	s7,0x6
    80001770:	0bcb8b93          	addi	s7,s7,188 # 80007828 <states.0>
    80001774:	a829                	j	8000178e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001776:	ed86a583          	lw	a1,-296(a3)
    8000177a:	8556                	mv	a0,s5
    8000177c:	20b030ef          	jal	80005186 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	205030ef          	jal	80005186 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001786:	17048493          	addi	s1,s1,368
    8000178a:	03248263          	beq	s1,s2,800017ae <procdump+0x8e>
    if(p->state == UNUSED)
    8000178e:	86a6                	mv	a3,s1
    80001790:	ec04a783          	lw	a5,-320(s1)
    80001794:	dbed                	beqz	a5,80001786 <procdump+0x66>
      state = "???";
    80001796:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001798:	fcfb6fe3          	bltu	s6,a5,80001776 <procdump+0x56>
    8000179c:	02079713          	slli	a4,a5,0x20
    800017a0:	01d75793          	srli	a5,a4,0x1d
    800017a4:	97de                	add	a5,a5,s7
    800017a6:	6390                	ld	a2,0(a5)
    800017a8:	f679                	bnez	a2,80001776 <procdump+0x56>
      state = "???";
    800017aa:	864e                	mv	a2,s3
    800017ac:	b7e9                	j	80001776 <procdump+0x56>
  }
}
    800017ae:	60a6                	ld	ra,72(sp)
    800017b0:	6406                	ld	s0,64(sp)
    800017b2:	74e2                	ld	s1,56(sp)
    800017b4:	7942                	ld	s2,48(sp)
    800017b6:	79a2                	ld	s3,40(sp)
    800017b8:	7a02                	ld	s4,32(sp)
    800017ba:	6ae2                	ld	s5,24(sp)
    800017bc:	6b42                	ld	s6,16(sp)
    800017be:	6ba2                	ld	s7,8(sp)
    800017c0:	6161                	addi	sp,sp,80
    800017c2:	8082                	ret

00000000800017c4 <swtch>:
    800017c4:	00153023          	sd	ra,0(a0)
    800017c8:	00253423          	sd	sp,8(a0)
    800017cc:	e900                	sd	s0,16(a0)
    800017ce:	ed04                	sd	s1,24(a0)
    800017d0:	03253023          	sd	s2,32(a0)
    800017d4:	03353423          	sd	s3,40(a0)
    800017d8:	03453823          	sd	s4,48(a0)
    800017dc:	03553c23          	sd	s5,56(a0)
    800017e0:	05653023          	sd	s6,64(a0)
    800017e4:	05753423          	sd	s7,72(a0)
    800017e8:	05853823          	sd	s8,80(a0)
    800017ec:	05953c23          	sd	s9,88(a0)
    800017f0:	07a53023          	sd	s10,96(a0)
    800017f4:	07b53423          	sd	s11,104(a0)
    800017f8:	0005b083          	ld	ra,0(a1)
    800017fc:	0085b103          	ld	sp,8(a1)
    80001800:	6980                	ld	s0,16(a1)
    80001802:	6d84                	ld	s1,24(a1)
    80001804:	0205b903          	ld	s2,32(a1)
    80001808:	0285b983          	ld	s3,40(a1)
    8000180c:	0305ba03          	ld	s4,48(a1)
    80001810:	0385ba83          	ld	s5,56(a1)
    80001814:	0405bb03          	ld	s6,64(a1)
    80001818:	0485bb83          	ld	s7,72(a1)
    8000181c:	0505bc03          	ld	s8,80(a1)
    80001820:	0585bc83          	ld	s9,88(a1)
    80001824:	0605bd03          	ld	s10,96(a1)
    80001828:	0685bd83          	ld	s11,104(a1)
    8000182c:	8082                	ret

000000008000182e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000182e:	1141                	addi	sp,sp,-16
    80001830:	e406                	sd	ra,8(sp)
    80001832:	e022                	sd	s0,0(sp)
    80001834:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001836:	00006597          	auipc	a1,0x6
    8000183a:	a5258593          	addi	a1,a1,-1454 # 80007288 <etext+0x288>
    8000183e:	0000f517          	auipc	a0,0xf
    80001842:	c6250513          	addi	a0,a0,-926 # 800104a0 <tickslock>
    80001846:	6bb030ef          	jal	80005700 <initlock>
}
    8000184a:	60a2                	ld	ra,8(sp)
    8000184c:	6402                	ld	s0,0(sp)
    8000184e:	0141                	addi	sp,sp,16
    80001850:	8082                	ret

0000000080001852 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001852:	1141                	addi	sp,sp,-16
    80001854:	e406                	sd	ra,8(sp)
    80001856:	e022                	sd	s0,0(sp)
    80001858:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000185a:	00003797          	auipc	a5,0x3
    8000185e:	e9678793          	addi	a5,a5,-362 # 800046f0 <kernelvec>
    80001862:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001866:	60a2                	ld	ra,8(sp)
    80001868:	6402                	ld	s0,0(sp)
    8000186a:	0141                	addi	sp,sp,16
    8000186c:	8082                	ret

000000008000186e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000186e:	1141                	addi	sp,sp,-16
    80001870:	e406                	sd	ra,8(sp)
    80001872:	e022                	sd	s0,0(sp)
    80001874:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001876:	ce6ff0ef          	jal	80000d5c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000187a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000187e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001880:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001884:	00004697          	auipc	a3,0x4
    80001888:	77c68693          	addi	a3,a3,1916 # 80006000 <_trampoline>
    8000188c:	00004717          	auipc	a4,0x4
    80001890:	77470713          	addi	a4,a4,1908 # 80006000 <_trampoline>
    80001894:	8f15                	sub	a4,a4,a3
    80001896:	040007b7          	lui	a5,0x4000
    8000189a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000189c:	07b2                	slli	a5,a5,0xc
    8000189e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018a0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018a4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018a6:	18002673          	csrr	a2,satp
    800018aa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018ac:	6d30                	ld	a2,88(a0)
    800018ae:	6138                	ld	a4,64(a0)
    800018b0:	6585                	lui	a1,0x1
    800018b2:	972e                	add	a4,a4,a1
    800018b4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018b6:	6d38                	ld	a4,88(a0)
    800018b8:	00000617          	auipc	a2,0x0
    800018bc:	11060613          	addi	a2,a2,272 # 800019c8 <usertrap>
    800018c0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018c2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018c4:	8612                	mv	a2,tp
    800018c6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018c8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018cc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018d0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018d4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018d8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018da:	6f18                	ld	a4,24(a4)
    800018dc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018e0:	6928                	ld	a0,80(a0)
    800018e2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018e4:	00004717          	auipc	a4,0x4
    800018e8:	7b870713          	addi	a4,a4,1976 # 8000609c <userret>
    800018ec:	8f15                	sub	a4,a4,a3
    800018ee:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018f0:	577d                	li	a4,-1
    800018f2:	177e                	slli	a4,a4,0x3f
    800018f4:	8d59                	or	a0,a0,a4
    800018f6:	9782                	jalr	a5
}
    800018f8:	60a2                	ld	ra,8(sp)
    800018fa:	6402                	ld	s0,0(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001908:	c20ff0ef          	jal	80000d28 <cpuid>
    8000190c:	cd11                	beqz	a0,80001928 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000190e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001912:	000f4737          	lui	a4,0xf4
    80001916:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000191a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000191c:	14d79073          	csrw	stimecmp,a5
}
    80001920:	60e2                	ld	ra,24(sp)
    80001922:	6442                	ld	s0,16(sp)
    80001924:	6105                	addi	sp,sp,32
    80001926:	8082                	ret
    80001928:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000192a:	0000f497          	auipc	s1,0xf
    8000192e:	b7648493          	addi	s1,s1,-1162 # 800104a0 <tickslock>
    80001932:	8526                	mv	a0,s1
    80001934:	651030ef          	jal	80005784 <acquire>
    ticks++;
    80001938:	00009517          	auipc	a0,0x9
    8000193c:	b0050513          	addi	a0,a0,-1280 # 8000a438 <ticks>
    80001940:	411c                	lw	a5,0(a0)
    80001942:	2785                	addiw	a5,a5,1
    80001944:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001946:	a3dff0ef          	jal	80001382 <wakeup>
    release(&tickslock);
    8000194a:	8526                	mv	a0,s1
    8000194c:	6cd030ef          	jal	80005818 <release>
    80001950:	64a2                	ld	s1,8(sp)
    80001952:	bf75                	j	8000190e <clockintr+0xe>

0000000080001954 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001954:	1101                	addi	sp,sp,-32
    80001956:	ec06                	sd	ra,24(sp)
    80001958:	e822                	sd	s0,16(sp)
    8000195a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000195c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001960:	57fd                	li	a5,-1
    80001962:	17fe                	slli	a5,a5,0x3f
    80001964:	07a5                	addi	a5,a5,9
    80001966:	00f70c63          	beq	a4,a5,8000197e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000196a:	57fd                	li	a5,-1
    8000196c:	17fe                	slli	a5,a5,0x3f
    8000196e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001970:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001972:	04f70763          	beq	a4,a5,800019c0 <devintr+0x6c>
  }
}
    80001976:	60e2                	ld	ra,24(sp)
    80001978:	6442                	ld	s0,16(sp)
    8000197a:	6105                	addi	sp,sp,32
    8000197c:	8082                	ret
    8000197e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001980:	61d020ef          	jal	8000479c <plic_claim>
    80001984:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001986:	47a9                	li	a5,10
    80001988:	00f50963          	beq	a0,a5,8000199a <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000198c:	4785                	li	a5,1
    8000198e:	00f50963          	beq	a0,a5,800019a0 <devintr+0x4c>
    return 1;
    80001992:	4505                	li	a0,1
    } else if(irq){
    80001994:	e889                	bnez	s1,800019a6 <devintr+0x52>
    80001996:	64a2                	ld	s1,8(sp)
    80001998:	bff9                	j	80001976 <devintr+0x22>
      uartintr();
    8000199a:	52b030ef          	jal	800056c4 <uartintr>
    if(irq)
    8000199e:	a819                	j	800019b4 <devintr+0x60>
      virtio_disk_intr();
    800019a0:	28c030ef          	jal	80004c2c <virtio_disk_intr>
    if(irq)
    800019a4:	a801                	j	800019b4 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a6:	85a6                	mv	a1,s1
    800019a8:	00006517          	auipc	a0,0x6
    800019ac:	8e850513          	addi	a0,a0,-1816 # 80007290 <etext+0x290>
    800019b0:	7d6030ef          	jal	80005186 <printf>
      plic_complete(irq);
    800019b4:	8526                	mv	a0,s1
    800019b6:	607020ef          	jal	800047bc <plic_complete>
    return 1;
    800019ba:	4505                	li	a0,1
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	bf65                	j	80001976 <devintr+0x22>
    clockintr();
    800019c0:	f41ff0ef          	jal	80001900 <clockintr>
    return 2;
    800019c4:	4509                	li	a0,2
    800019c6:	bf45                	j	80001976 <devintr+0x22>

00000000800019c8 <usertrap>:
{
    800019c8:	1101                	addi	sp,sp,-32
    800019ca:	ec06                	sd	ra,24(sp)
    800019cc:	e822                	sd	s0,16(sp)
    800019ce:	e426                	sd	s1,8(sp)
    800019d0:	e04a                	sd	s2,0(sp)
    800019d2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019d4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019d8:	1007f793          	andi	a5,a5,256
    800019dc:	ef85                	bnez	a5,80001a14 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019de:	00003797          	auipc	a5,0x3
    800019e2:	d1278793          	addi	a5,a5,-750 # 800046f0 <kernelvec>
    800019e6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019ea:	b72ff0ef          	jal	80000d5c <myproc>
    800019ee:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019f0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019f2:	14102773          	csrr	a4,sepc
    800019f6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019fc:	47a1                	li	a5,8
    800019fe:	02f70163          	beq	a4,a5,80001a20 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a02:	f53ff0ef          	jal	80001954 <devintr>
    80001a06:	892a                	mv	s2,a0
    80001a08:	c135                	beqz	a0,80001a6c <usertrap+0xa4>
  if(killed(p))
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	b63ff0ef          	jal	8000156e <killed>
    80001a10:	cd1d                	beqz	a0,80001a4e <usertrap+0x86>
    80001a12:	a81d                	j	80001a48 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a14:	00006517          	auipc	a0,0x6
    80001a18:	89c50513          	addi	a0,a0,-1892 # 800072b0 <etext+0x2b0>
    80001a1c:	23b030ef          	jal	80005456 <panic>
    if(killed(p))
    80001a20:	b4fff0ef          	jal	8000156e <killed>
    80001a24:	e121                	bnez	a0,80001a64 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a26:	6cb8                	ld	a4,88(s1)
    80001a28:	6f1c                	ld	a5,24(a4)
    80001a2a:	0791                	addi	a5,a5,4
    80001a2c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a32:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a36:	10079073          	csrw	sstatus,a5
    syscall();
    80001a3a:	240000ef          	jal	80001c7a <syscall>
  if(killed(p))
    80001a3e:	8526                	mv	a0,s1
    80001a40:	b2fff0ef          	jal	8000156e <killed>
    80001a44:	c901                	beqz	a0,80001a54 <usertrap+0x8c>
    80001a46:	4901                	li	s2,0
    exit(-1);
    80001a48:	557d                	li	a0,-1
    80001a4a:	9f9ff0ef          	jal	80001442 <exit>
  if(which_dev == 2)
    80001a4e:	4789                	li	a5,2
    80001a50:	04f90563          	beq	s2,a5,80001a9a <usertrap+0xd2>
  usertrapret();
    80001a54:	e1bff0ef          	jal	8000186e <usertrapret>
}
    80001a58:	60e2                	ld	ra,24(sp)
    80001a5a:	6442                	ld	s0,16(sp)
    80001a5c:	64a2                	ld	s1,8(sp)
    80001a5e:	6902                	ld	s2,0(sp)
    80001a60:	6105                	addi	sp,sp,32
    80001a62:	8082                	ret
      exit(-1);
    80001a64:	557d                	li	a0,-1
    80001a66:	9ddff0ef          	jal	80001442 <exit>
    80001a6a:	bf75                	j	80001a26 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a6c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a70:	5890                	lw	a2,48(s1)
    80001a72:	00006517          	auipc	a0,0x6
    80001a76:	85e50513          	addi	a0,a0,-1954 # 800072d0 <etext+0x2d0>
    80001a7a:	70c030ef          	jal	80005186 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a82:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a86:	00006517          	auipc	a0,0x6
    80001a8a:	87a50513          	addi	a0,a0,-1926 # 80007300 <etext+0x300>
    80001a8e:	6f8030ef          	jal	80005186 <printf>
    setkilled(p);
    80001a92:	8526                	mv	a0,s1
    80001a94:	ab7ff0ef          	jal	8000154a <setkilled>
    80001a98:	b75d                	j	80001a3e <usertrap+0x76>
    yield();
    80001a9a:	871ff0ef          	jal	8000130a <yield>
    80001a9e:	bf5d                	j	80001a54 <usertrap+0x8c>

0000000080001aa0 <kerneltrap>:
{
    80001aa0:	7179                	addi	sp,sp,-48
    80001aa2:	f406                	sd	ra,40(sp)
    80001aa4:	f022                	sd	s0,32(sp)
    80001aa6:	ec26                	sd	s1,24(sp)
    80001aa8:	e84a                	sd	s2,16(sp)
    80001aaa:	e44e                	sd	s3,8(sp)
    80001aac:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aae:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ab6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001aba:	1004f793          	andi	a5,s1,256
    80001abe:	c795                	beqz	a5,80001aea <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ac4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ac6:	eb85                	bnez	a5,80001af6 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ac8:	e8dff0ef          	jal	80001954 <devintr>
    80001acc:	c91d                	beqz	a0,80001b02 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ace:	4789                	li	a5,2
    80001ad0:	04f50a63          	beq	a0,a5,80001b24 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ad4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad8:	10049073          	csrw	sstatus,s1
}
    80001adc:	70a2                	ld	ra,40(sp)
    80001ade:	7402                	ld	s0,32(sp)
    80001ae0:	64e2                	ld	s1,24(sp)
    80001ae2:	6942                	ld	s2,16(sp)
    80001ae4:	69a2                	ld	s3,8(sp)
    80001ae6:	6145                	addi	sp,sp,48
    80001ae8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001aea:	00006517          	auipc	a0,0x6
    80001aee:	83e50513          	addi	a0,a0,-1986 # 80007328 <etext+0x328>
    80001af2:	165030ef          	jal	80005456 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af6:	00006517          	auipc	a0,0x6
    80001afa:	85a50513          	addi	a0,a0,-1958 # 80007350 <etext+0x350>
    80001afe:	159030ef          	jal	80005456 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b02:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b06:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b0a:	85ce                	mv	a1,s3
    80001b0c:	00006517          	auipc	a0,0x6
    80001b10:	86450513          	addi	a0,a0,-1948 # 80007370 <etext+0x370>
    80001b14:	672030ef          	jal	80005186 <printf>
    panic("kerneltrap");
    80001b18:	00006517          	auipc	a0,0x6
    80001b1c:	88050513          	addi	a0,a0,-1920 # 80007398 <etext+0x398>
    80001b20:	137030ef          	jal	80005456 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b24:	a38ff0ef          	jal	80000d5c <myproc>
    80001b28:	d555                	beqz	a0,80001ad4 <kerneltrap+0x34>
    yield();
    80001b2a:	fe0ff0ef          	jal	8000130a <yield>
    80001b2e:	b75d                	j	80001ad4 <kerneltrap+0x34>

0000000080001b30 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b3c:	a20ff0ef          	jal	80000d5c <myproc>
  switch (n) {
    80001b40:	4795                	li	a5,5
    80001b42:	0497e163          	bltu	a5,s1,80001b84 <argraw+0x54>
    80001b46:	048a                	slli	s1,s1,0x2
    80001b48:	00006717          	auipc	a4,0x6
    80001b4c:	d1070713          	addi	a4,a4,-752 # 80007858 <states.0+0x30>
    80001b50:	94ba                	add	s1,s1,a4
    80001b52:	409c                	lw	a5,0(s1)
    80001b54:	97ba                	add	a5,a5,a4
    80001b56:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b58:	6d3c                	ld	a5,88(a0)
    80001b5a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b5c:	60e2                	ld	ra,24(sp)
    80001b5e:	6442                	ld	s0,16(sp)
    80001b60:	64a2                	ld	s1,8(sp)
    80001b62:	6105                	addi	sp,sp,32
    80001b64:	8082                	ret
    return p->trapframe->a1;
    80001b66:	6d3c                	ld	a5,88(a0)
    80001b68:	7fa8                	ld	a0,120(a5)
    80001b6a:	bfcd                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a2;
    80001b6c:	6d3c                	ld	a5,88(a0)
    80001b6e:	63c8                	ld	a0,128(a5)
    80001b70:	b7f5                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a3;
    80001b72:	6d3c                	ld	a5,88(a0)
    80001b74:	67c8                	ld	a0,136(a5)
    80001b76:	b7dd                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a4;
    80001b78:	6d3c                	ld	a5,88(a0)
    80001b7a:	6bc8                	ld	a0,144(a5)
    80001b7c:	b7c5                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a5;
    80001b7e:	6d3c                	ld	a5,88(a0)
    80001b80:	6fc8                	ld	a0,152(a5)
    80001b82:	bfe9                	j	80001b5c <argraw+0x2c>
  panic("argraw");
    80001b84:	00006517          	auipc	a0,0x6
    80001b88:	82450513          	addi	a0,a0,-2012 # 800073a8 <etext+0x3a8>
    80001b8c:	0cb030ef          	jal	80005456 <panic>

0000000080001b90 <fetchaddr>:
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	e04a                	sd	s2,0(sp)
    80001b9a:	1000                	addi	s0,sp,32
    80001b9c:	84aa                	mv	s1,a0
    80001b9e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ba0:	9bcff0ef          	jal	80000d5c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ba4:	653c                	ld	a5,72(a0)
    80001ba6:	02f4f663          	bgeu	s1,a5,80001bd2 <fetchaddr+0x42>
    80001baa:	00848713          	addi	a4,s1,8
    80001bae:	02e7e463          	bltu	a5,a4,80001bd6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bb2:	46a1                	li	a3,8
    80001bb4:	8626                	mv	a2,s1
    80001bb6:	85ca                	mv	a1,s2
    80001bb8:	6928                	ld	a0,80(a0)
    80001bba:	efbfe0ef          	jal	80000ab4 <copyin>
    80001bbe:	00a03533          	snez	a0,a0
    80001bc2:	40a0053b          	negw	a0,a0
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6902                	ld	s2,0(sp)
    80001bce:	6105                	addi	sp,sp,32
    80001bd0:	8082                	ret
    return -1;
    80001bd2:	557d                	li	a0,-1
    80001bd4:	bfcd                	j	80001bc6 <fetchaddr+0x36>
    80001bd6:	557d                	li	a0,-1
    80001bd8:	b7fd                	j	80001bc6 <fetchaddr+0x36>

0000000080001bda <fetchstr>:
{
    80001bda:	7179                	addi	sp,sp,-48
    80001bdc:	f406                	sd	ra,40(sp)
    80001bde:	f022                	sd	s0,32(sp)
    80001be0:	ec26                	sd	s1,24(sp)
    80001be2:	e84a                	sd	s2,16(sp)
    80001be4:	e44e                	sd	s3,8(sp)
    80001be6:	1800                	addi	s0,sp,48
    80001be8:	892a                	mv	s2,a0
    80001bea:	84ae                	mv	s1,a1
    80001bec:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bee:	96eff0ef          	jal	80000d5c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bf2:	86ce                	mv	a3,s3
    80001bf4:	864a                	mv	a2,s2
    80001bf6:	85a6                	mv	a1,s1
    80001bf8:	6928                	ld	a0,80(a0)
    80001bfa:	f41fe0ef          	jal	80000b3a <copyinstr>
    80001bfe:	00054c63          	bltz	a0,80001c16 <fetchstr+0x3c>
  return strlen(buf);
    80001c02:	8526                	mv	a0,s1
    80001c04:	ed2fe0ef          	jal	800002d6 <strlen>
}
    80001c08:	70a2                	ld	ra,40(sp)
    80001c0a:	7402                	ld	s0,32(sp)
    80001c0c:	64e2                	ld	s1,24(sp)
    80001c0e:	6942                	ld	s2,16(sp)
    80001c10:	69a2                	ld	s3,8(sp)
    80001c12:	6145                	addi	sp,sp,48
    80001c14:	8082                	ret
    return -1;
    80001c16:	557d                	li	a0,-1
    80001c18:	bfc5                	j	80001c08 <fetchstr+0x2e>

0000000080001c1a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	1000                	addi	s0,sp,32
    80001c24:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c26:	f0bff0ef          	jal	80001b30 <argraw>
    80001c2a:	c088                	sw	a0,0(s1)
}
    80001c2c:	60e2                	ld	ra,24(sp)
    80001c2e:	6442                	ld	s0,16(sp)
    80001c30:	64a2                	ld	s1,8(sp)
    80001c32:	6105                	addi	sp,sp,32
    80001c34:	8082                	ret

0000000080001c36 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c36:	1101                	addi	sp,sp,-32
    80001c38:	ec06                	sd	ra,24(sp)
    80001c3a:	e822                	sd	s0,16(sp)
    80001c3c:	e426                	sd	s1,8(sp)
    80001c3e:	1000                	addi	s0,sp,32
    80001c40:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c42:	eefff0ef          	jal	80001b30 <argraw>
    80001c46:	e088                	sd	a0,0(s1)
}
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6105                	addi	sp,sp,32
    80001c50:	8082                	ret

0000000080001c52 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c52:	1101                	addi	sp,sp,-32
    80001c54:	ec06                	sd	ra,24(sp)
    80001c56:	e822                	sd	s0,16(sp)
    80001c58:	e426                	sd	s1,8(sp)
    80001c5a:	e04a                	sd	s2,0(sp)
    80001c5c:	1000                	addi	s0,sp,32
    80001c5e:	84ae                	mv	s1,a1
    80001c60:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001c62:	ecfff0ef          	jal	80001b30 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001c66:	864a                	mv	a2,s2
    80001c68:	85a6                	mv	a1,s1
    80001c6a:	f71ff0ef          	jal	80001bda <fetchstr>
}
    80001c6e:	60e2                	ld	ra,24(sp)
    80001c70:	6442                	ld	s0,16(sp)
    80001c72:	64a2                	ld	s1,8(sp)
    80001c74:	6902                	ld	s2,0(sp)
    80001c76:	6105                	addi	sp,sp,32
    80001c78:	8082                	ret

0000000080001c7a <syscall>:
};


void
syscall(void)
{
    80001c7a:	7179                	addi	sp,sp,-48
    80001c7c:	f406                	sd	ra,40(sp)
    80001c7e:	f022                	sd	s0,32(sp)
    80001c80:	ec26                	sd	s1,24(sp)
    80001c82:	e84a                	sd	s2,16(sp)
    80001c84:	e44e                	sd	s3,8(sp)
    80001c86:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001c88:	8d4ff0ef          	jal	80000d5c <myproc>
    80001c8c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c8e:	05853903          	ld	s2,88(a0)
    80001c92:	0a893783          	ld	a5,168(s2)
    80001c96:	0007899b          	sext.w	s3,a5
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c9a:	37fd                	addiw	a5,a5,-1
    80001c9c:	4755                	li	a4,21
    80001c9e:	04f76563          	bltu	a4,a5,80001ce8 <syscall+0x6e>
    80001ca2:	00399713          	slli	a4,s3,0x3
    80001ca6:	00006797          	auipc	a5,0x6
    80001caa:	bca78793          	addi	a5,a5,-1078 # 80007870 <syscalls>
    80001cae:	97ba                	add	a5,a5,a4
    80001cb0:	639c                	ld	a5,0(a5)
    80001cb2:	cb9d                	beqz	a5,80001ce8 <syscall+0x6e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001cb4:	9782                	jalr	a5
    80001cb6:	06a93823          	sd	a0,112(s2)

    // Log the syscall if its number is in the process's syscall mask.
    if ((1 << num) & p->syscallMask)
    80001cba:	1684a783          	lw	a5,360(s1)
    80001cbe:	4137d7bb          	sraw	a5,a5,s3
    80001cc2:	8b85                	andi	a5,a5,1
    80001cc4:	cf9d                	beqz	a5,80001d02 <syscall+0x88>
      printf("%d: syscall %s -> %ld\n", p->pid, syscallNames[num], p->trapframe->a0);
    80001cc6:	6cb8                	ld	a4,88(s1)
    80001cc8:	098e                	slli	s3,s3,0x3
    80001cca:	00006797          	auipc	a5,0x6
    80001cce:	ba678793          	addi	a5,a5,-1114 # 80007870 <syscalls>
    80001cd2:	97ce                	add	a5,a5,s3
    80001cd4:	7b34                	ld	a3,112(a4)
    80001cd6:	7fd0                	ld	a2,184(a5)
    80001cd8:	588c                	lw	a1,48(s1)
    80001cda:	00005517          	auipc	a0,0x5
    80001cde:	6d650513          	addi	a0,a0,1750 # 800073b0 <etext+0x3b0>
    80001ce2:	4a4030ef          	jal	80005186 <printf>
    80001ce6:	a831                	j	80001d02 <syscall+0x88>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001ce8:	86ce                	mv	a3,s3
    80001cea:	15848613          	addi	a2,s1,344
    80001cee:	588c                	lw	a1,48(s1)
    80001cf0:	00005517          	auipc	a0,0x5
    80001cf4:	6d850513          	addi	a0,a0,1752 # 800073c8 <etext+0x3c8>
    80001cf8:	48e030ef          	jal	80005186 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cfc:	6cbc                	ld	a5,88(s1)
    80001cfe:	577d                	li	a4,-1
    80001d00:	fbb8                	sd	a4,112(a5)
  }
}
    80001d02:	70a2                	ld	ra,40(sp)
    80001d04:	7402                	ld	s0,32(sp)
    80001d06:	64e2                	ld	s1,24(sp)
    80001d08:	6942                	ld	s2,16(sp)
    80001d0a:	69a2                	ld	s3,8(sp)
    80001d0c:	6145                	addi	sp,sp,48
    80001d0e:	8082                	ret

0000000080001d10 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001d10:	1101                	addi	sp,sp,-32
    80001d12:	ec06                	sd	ra,24(sp)
    80001d14:	e822                	sd	s0,16(sp)
    80001d16:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d18:	fec40593          	addi	a1,s0,-20
    80001d1c:	4501                	li	a0,0
    80001d1e:	efdff0ef          	jal	80001c1a <argint>
  exit(n);
    80001d22:	fec42503          	lw	a0,-20(s0)
    80001d26:	f1cff0ef          	jal	80001442 <exit>
  return 0;  // not reached
}
    80001d2a:	4501                	li	a0,0
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	6105                	addi	sp,sp,32
    80001d32:	8082                	ret

0000000080001d34 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d34:	1141                	addi	sp,sp,-16
    80001d36:	e406                	sd	ra,8(sp)
    80001d38:	e022                	sd	s0,0(sp)
    80001d3a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d3c:	820ff0ef          	jal	80000d5c <myproc>
}
    80001d40:	5908                	lw	a0,48(a0)
    80001d42:	60a2                	ld	ra,8(sp)
    80001d44:	6402                	ld	s0,0(sp)
    80001d46:	0141                	addi	sp,sp,16
    80001d48:	8082                	ret

0000000080001d4a <sys_fork>:

uint64
sys_fork(void)
{
    80001d4a:	1141                	addi	sp,sp,-16
    80001d4c:	e406                	sd	ra,8(sp)
    80001d4e:	e022                	sd	s0,0(sp)
    80001d50:	0800                	addi	s0,sp,16
  return fork();
    80001d52:	b34ff0ef          	jal	80001086 <fork>
}
    80001d56:	60a2                	ld	ra,8(sp)
    80001d58:	6402                	ld	s0,0(sp)
    80001d5a:	0141                	addi	sp,sp,16
    80001d5c:	8082                	ret

0000000080001d5e <sys_wait>:

uint64
sys_wait(void)
{
    80001d5e:	1101                	addi	sp,sp,-32
    80001d60:	ec06                	sd	ra,24(sp)
    80001d62:	e822                	sd	s0,16(sp)
    80001d64:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d66:	fe840593          	addi	a1,s0,-24
    80001d6a:	4501                	li	a0,0
    80001d6c:	ecbff0ef          	jal	80001c36 <argaddr>
  return wait(p);
    80001d70:	fe843503          	ld	a0,-24(s0)
    80001d74:	825ff0ef          	jal	80001598 <wait>
}
    80001d78:	60e2                	ld	ra,24(sp)
    80001d7a:	6442                	ld	s0,16(sp)
    80001d7c:	6105                	addi	sp,sp,32
    80001d7e:	8082                	ret

0000000080001d80 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d80:	7179                	addi	sp,sp,-48
    80001d82:	f406                	sd	ra,40(sp)
    80001d84:	f022                	sd	s0,32(sp)
    80001d86:	ec26                	sd	s1,24(sp)
    80001d88:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d8a:	fdc40593          	addi	a1,s0,-36
    80001d8e:	4501                	li	a0,0
    80001d90:	e8bff0ef          	jal	80001c1a <argint>
  addr = myproc()->sz;
    80001d94:	fc9fe0ef          	jal	80000d5c <myproc>
    80001d98:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d9a:	fdc42503          	lw	a0,-36(s0)
    80001d9e:	a98ff0ef          	jal	80001036 <growproc>
    80001da2:	00054863          	bltz	a0,80001db2 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001da6:	8526                	mv	a0,s1
    80001da8:	70a2                	ld	ra,40(sp)
    80001daa:	7402                	ld	s0,32(sp)
    80001dac:	64e2                	ld	s1,24(sp)
    80001dae:	6145                	addi	sp,sp,48
    80001db0:	8082                	ret
    return -1;
    80001db2:	54fd                	li	s1,-1
    80001db4:	bfcd                	j	80001da6 <sys_sbrk+0x26>

0000000080001db6 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001db6:	7139                	addi	sp,sp,-64
    80001db8:	fc06                	sd	ra,56(sp)
    80001dba:	f822                	sd	s0,48(sp)
    80001dbc:	f04a                	sd	s2,32(sp)
    80001dbe:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001dc0:	fcc40593          	addi	a1,s0,-52
    80001dc4:	4501                	li	a0,0
    80001dc6:	e55ff0ef          	jal	80001c1a <argint>
  if(n < 0)
    80001dca:	fcc42783          	lw	a5,-52(s0)
    80001dce:	0607c763          	bltz	a5,80001e3c <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001dd2:	0000e517          	auipc	a0,0xe
    80001dd6:	6ce50513          	addi	a0,a0,1742 # 800104a0 <tickslock>
    80001dda:	1ab030ef          	jal	80005784 <acquire>
  ticks0 = ticks;
    80001dde:	00008917          	auipc	s2,0x8
    80001de2:	65a92903          	lw	s2,1626(s2) # 8000a438 <ticks>
  while(ticks - ticks0 < n){
    80001de6:	fcc42783          	lw	a5,-52(s0)
    80001dea:	cf8d                	beqz	a5,80001e24 <sys_sleep+0x6e>
    80001dec:	f426                	sd	s1,40(sp)
    80001dee:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001df0:	0000e997          	auipc	s3,0xe
    80001df4:	6b098993          	addi	s3,s3,1712 # 800104a0 <tickslock>
    80001df8:	00008497          	auipc	s1,0x8
    80001dfc:	64048493          	addi	s1,s1,1600 # 8000a438 <ticks>
    if(killed(myproc())){
    80001e00:	f5dfe0ef          	jal	80000d5c <myproc>
    80001e04:	f6aff0ef          	jal	8000156e <killed>
    80001e08:	ed0d                	bnez	a0,80001e42 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e0a:	85ce                	mv	a1,s3
    80001e0c:	8526                	mv	a0,s1
    80001e0e:	d28ff0ef          	jal	80001336 <sleep>
  while(ticks - ticks0 < n){
    80001e12:	409c                	lw	a5,0(s1)
    80001e14:	412787bb          	subw	a5,a5,s2
    80001e18:	fcc42703          	lw	a4,-52(s0)
    80001e1c:	fee7e2e3          	bltu	a5,a4,80001e00 <sys_sleep+0x4a>
    80001e20:	74a2                	ld	s1,40(sp)
    80001e22:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e24:	0000e517          	auipc	a0,0xe
    80001e28:	67c50513          	addi	a0,a0,1660 # 800104a0 <tickslock>
    80001e2c:	1ed030ef          	jal	80005818 <release>
  return 0;
    80001e30:	4501                	li	a0,0
}
    80001e32:	70e2                	ld	ra,56(sp)
    80001e34:	7442                	ld	s0,48(sp)
    80001e36:	7902                	ld	s2,32(sp)
    80001e38:	6121                	addi	sp,sp,64
    80001e3a:	8082                	ret
    n = 0;
    80001e3c:	fc042623          	sw	zero,-52(s0)
    80001e40:	bf49                	j	80001dd2 <sys_sleep+0x1c>
      release(&tickslock);
    80001e42:	0000e517          	auipc	a0,0xe
    80001e46:	65e50513          	addi	a0,a0,1630 # 800104a0 <tickslock>
    80001e4a:	1cf030ef          	jal	80005818 <release>
      return -1;
    80001e4e:	557d                	li	a0,-1
    80001e50:	74a2                	ld	s1,40(sp)
    80001e52:	69e2                	ld	s3,24(sp)
    80001e54:	bff9                	j	80001e32 <sys_sleep+0x7c>

0000000080001e56 <sys_kill>:

uint64
sys_kill(void)
{
    80001e56:	1101                	addi	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e5e:	fec40593          	addi	a1,s0,-20
    80001e62:	4501                	li	a0,0
    80001e64:	db7ff0ef          	jal	80001c1a <argint>
  return kill(pid);
    80001e68:	fec42503          	lw	a0,-20(s0)
    80001e6c:	e78ff0ef          	jal	800014e4 <kill>
}
    80001e70:	60e2                	ld	ra,24(sp)
    80001e72:	6442                	ld	s0,16(sp)
    80001e74:	6105                	addi	sp,sp,32
    80001e76:	8082                	ret

0000000080001e78 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e82:	0000e517          	auipc	a0,0xe
    80001e86:	61e50513          	addi	a0,a0,1566 # 800104a0 <tickslock>
    80001e8a:	0fb030ef          	jal	80005784 <acquire>
  xticks = ticks;
    80001e8e:	00008497          	auipc	s1,0x8
    80001e92:	5aa4a483          	lw	s1,1450(s1) # 8000a438 <ticks>
  release(&tickslock);
    80001e96:	0000e517          	auipc	a0,0xe
    80001e9a:	60a50513          	addi	a0,a0,1546 # 800104a0 <tickslock>
    80001e9e:	17b030ef          	jal	80005818 <release>
  return xticks;
}
    80001ea2:	02049513          	slli	a0,s1,0x20
    80001ea6:	9101                	srli	a0,a0,0x20
    80001ea8:	60e2                	ld	ra,24(sp)
    80001eaa:	6442                	ld	s0,16(sp)
    80001eac:	64a2                	ld	s1,8(sp)
    80001eae:	6105                	addi	sp,sp,32
    80001eb0:	8082                	ret

0000000080001eb2 <sys_trace>:

uint64
sys_trace(void)
{
    80001eb2:	1101                	addi	sp,sp,-32
    80001eb4:	ec06                	sd	ra,24(sp)
    80001eb6:	e822                	sd	s0,16(sp)
    80001eb8:	1000                	addi	s0,sp,32
  int syscallMask;
  argint(0, &syscallMask);
    80001eba:	fec40593          	addi	a1,s0,-20
    80001ebe:	4501                	li	a0,0
    80001ec0:	d5bff0ef          	jal	80001c1a <argint>
  myproc()->syscallMask = syscallMask;
    80001ec4:	e99fe0ef          	jal	80000d5c <myproc>
    80001ec8:	fec42783          	lw	a5,-20(s0)
    80001ecc:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80001ed0:	4501                	li	a0,0
    80001ed2:	60e2                	ld	ra,24(sp)
    80001ed4:	6442                	ld	s0,16(sp)
    80001ed6:	6105                	addi	sp,sp,32
    80001ed8:	8082                	ret

0000000080001eda <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001eda:	7179                	addi	sp,sp,-48
    80001edc:	f406                	sd	ra,40(sp)
    80001ede:	f022                	sd	s0,32(sp)
    80001ee0:	ec26                	sd	s1,24(sp)
    80001ee2:	e84a                	sd	s2,16(sp)
    80001ee4:	e44e                	sd	s3,8(sp)
    80001ee6:	e052                	sd	s4,0(sp)
    80001ee8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001eea:	00005597          	auipc	a1,0x5
    80001eee:	5a658593          	addi	a1,a1,1446 # 80007490 <etext+0x490>
    80001ef2:	0000e517          	auipc	a0,0xe
    80001ef6:	5c650513          	addi	a0,a0,1478 # 800104b8 <bcache>
    80001efa:	007030ef          	jal	80005700 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001efe:	00016797          	auipc	a5,0x16
    80001f02:	5ba78793          	addi	a5,a5,1466 # 800184b8 <bcache+0x8000>
    80001f06:	00017717          	auipc	a4,0x17
    80001f0a:	81a70713          	addi	a4,a4,-2022 # 80018720 <bcache+0x8268>
    80001f0e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f12:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f16:	0000e497          	auipc	s1,0xe
    80001f1a:	5ba48493          	addi	s1,s1,1466 # 800104d0 <bcache+0x18>
    b->next = bcache.head.next;
    80001f1e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f20:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f22:	00005a17          	auipc	s4,0x5
    80001f26:	576a0a13          	addi	s4,s4,1398 # 80007498 <etext+0x498>
    b->next = bcache.head.next;
    80001f2a:	2b893783          	ld	a5,696(s2)
    80001f2e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f30:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f34:	85d2                	mv	a1,s4
    80001f36:	01048513          	addi	a0,s1,16
    80001f3a:	244010ef          	jal	8000317e <initsleeplock>
    bcache.head.next->prev = b;
    80001f3e:	2b893783          	ld	a5,696(s2)
    80001f42:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001f44:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f48:	45848493          	addi	s1,s1,1112
    80001f4c:	fd349fe3          	bne	s1,s3,80001f2a <binit+0x50>
  }
}
    80001f50:	70a2                	ld	ra,40(sp)
    80001f52:	7402                	ld	s0,32(sp)
    80001f54:	64e2                	ld	s1,24(sp)
    80001f56:	6942                	ld	s2,16(sp)
    80001f58:	69a2                	ld	s3,8(sp)
    80001f5a:	6a02                	ld	s4,0(sp)
    80001f5c:	6145                	addi	sp,sp,48
    80001f5e:	8082                	ret

0000000080001f60 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001f60:	7179                	addi	sp,sp,-48
    80001f62:	f406                	sd	ra,40(sp)
    80001f64:	f022                	sd	s0,32(sp)
    80001f66:	ec26                	sd	s1,24(sp)
    80001f68:	e84a                	sd	s2,16(sp)
    80001f6a:	e44e                	sd	s3,8(sp)
    80001f6c:	1800                	addi	s0,sp,48
    80001f6e:	892a                	mv	s2,a0
    80001f70:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f72:	0000e517          	auipc	a0,0xe
    80001f76:	54650513          	addi	a0,a0,1350 # 800104b8 <bcache>
    80001f7a:	00b030ef          	jal	80005784 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f7e:	00016497          	auipc	s1,0x16
    80001f82:	7f24b483          	ld	s1,2034(s1) # 80018770 <bcache+0x82b8>
    80001f86:	00016797          	auipc	a5,0x16
    80001f8a:	79a78793          	addi	a5,a5,1946 # 80018720 <bcache+0x8268>
    80001f8e:	02f48b63          	beq	s1,a5,80001fc4 <bread+0x64>
    80001f92:	873e                	mv	a4,a5
    80001f94:	a021                	j	80001f9c <bread+0x3c>
    80001f96:	68a4                	ld	s1,80(s1)
    80001f98:	02e48663          	beq	s1,a4,80001fc4 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f9c:	449c                	lw	a5,8(s1)
    80001f9e:	ff279ce3          	bne	a5,s2,80001f96 <bread+0x36>
    80001fa2:	44dc                	lw	a5,12(s1)
    80001fa4:	ff3799e3          	bne	a5,s3,80001f96 <bread+0x36>
      b->refcnt++;
    80001fa8:	40bc                	lw	a5,64(s1)
    80001faa:	2785                	addiw	a5,a5,1
    80001fac:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001fae:	0000e517          	auipc	a0,0xe
    80001fb2:	50a50513          	addi	a0,a0,1290 # 800104b8 <bcache>
    80001fb6:	063030ef          	jal	80005818 <release>
      acquiresleep(&b->lock);
    80001fba:	01048513          	addi	a0,s1,16
    80001fbe:	1f6010ef          	jal	800031b4 <acquiresleep>
      return b;
    80001fc2:	a889                	j	80002014 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001fc4:	00016497          	auipc	s1,0x16
    80001fc8:	7a44b483          	ld	s1,1956(s1) # 80018768 <bcache+0x82b0>
    80001fcc:	00016797          	auipc	a5,0x16
    80001fd0:	75478793          	addi	a5,a5,1876 # 80018720 <bcache+0x8268>
    80001fd4:	00f48863          	beq	s1,a5,80001fe4 <bread+0x84>
    80001fd8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001fda:	40bc                	lw	a5,64(s1)
    80001fdc:	cb91                	beqz	a5,80001ff0 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001fde:	64a4                	ld	s1,72(s1)
    80001fe0:	fee49de3          	bne	s1,a4,80001fda <bread+0x7a>
  panic("bget: no buffers");
    80001fe4:	00005517          	auipc	a0,0x5
    80001fe8:	4bc50513          	addi	a0,a0,1212 # 800074a0 <etext+0x4a0>
    80001fec:	46a030ef          	jal	80005456 <panic>
      b->dev = dev;
    80001ff0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001ff4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001ff8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001ffc:	4785                	li	a5,1
    80001ffe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002000:	0000e517          	auipc	a0,0xe
    80002004:	4b850513          	addi	a0,a0,1208 # 800104b8 <bcache>
    80002008:	011030ef          	jal	80005818 <release>
      acquiresleep(&b->lock);
    8000200c:	01048513          	addi	a0,s1,16
    80002010:	1a4010ef          	jal	800031b4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002014:	409c                	lw	a5,0(s1)
    80002016:	cb89                	beqz	a5,80002028 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002018:	8526                	mv	a0,s1
    8000201a:	70a2                	ld	ra,40(sp)
    8000201c:	7402                	ld	s0,32(sp)
    8000201e:	64e2                	ld	s1,24(sp)
    80002020:	6942                	ld	s2,16(sp)
    80002022:	69a2                	ld	s3,8(sp)
    80002024:	6145                	addi	sp,sp,48
    80002026:	8082                	ret
    virtio_disk_rw(b, 0);
    80002028:	4581                	li	a1,0
    8000202a:	8526                	mv	a0,s1
    8000202c:	1f5020ef          	jal	80004a20 <virtio_disk_rw>
    b->valid = 1;
    80002030:	4785                	li	a5,1
    80002032:	c09c                	sw	a5,0(s1)
  return b;
    80002034:	b7d5                	j	80002018 <bread+0xb8>

0000000080002036 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002036:	1101                	addi	sp,sp,-32
    80002038:	ec06                	sd	ra,24(sp)
    8000203a:	e822                	sd	s0,16(sp)
    8000203c:	e426                	sd	s1,8(sp)
    8000203e:	1000                	addi	s0,sp,32
    80002040:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002042:	0541                	addi	a0,a0,16
    80002044:	1ee010ef          	jal	80003232 <holdingsleep>
    80002048:	c911                	beqz	a0,8000205c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000204a:	4585                	li	a1,1
    8000204c:	8526                	mv	a0,s1
    8000204e:	1d3020ef          	jal	80004a20 <virtio_disk_rw>
}
    80002052:	60e2                	ld	ra,24(sp)
    80002054:	6442                	ld	s0,16(sp)
    80002056:	64a2                	ld	s1,8(sp)
    80002058:	6105                	addi	sp,sp,32
    8000205a:	8082                	ret
    panic("bwrite");
    8000205c:	00005517          	auipc	a0,0x5
    80002060:	45c50513          	addi	a0,a0,1116 # 800074b8 <etext+0x4b8>
    80002064:	3f2030ef          	jal	80005456 <panic>

0000000080002068 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	e04a                	sd	s2,0(sp)
    80002072:	1000                	addi	s0,sp,32
    80002074:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002076:	01050913          	addi	s2,a0,16
    8000207a:	854a                	mv	a0,s2
    8000207c:	1b6010ef          	jal	80003232 <holdingsleep>
    80002080:	c125                	beqz	a0,800020e0 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002082:	854a                	mv	a0,s2
    80002084:	176010ef          	jal	800031fa <releasesleep>

  acquire(&bcache.lock);
    80002088:	0000e517          	auipc	a0,0xe
    8000208c:	43050513          	addi	a0,a0,1072 # 800104b8 <bcache>
    80002090:	6f4030ef          	jal	80005784 <acquire>
  b->refcnt--;
    80002094:	40bc                	lw	a5,64(s1)
    80002096:	37fd                	addiw	a5,a5,-1
    80002098:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000209a:	e79d                	bnez	a5,800020c8 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000209c:	68b8                	ld	a4,80(s1)
    8000209e:	64bc                	ld	a5,72(s1)
    800020a0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800020a2:	68b8                	ld	a4,80(s1)
    800020a4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800020a6:	00016797          	auipc	a5,0x16
    800020aa:	41278793          	addi	a5,a5,1042 # 800184b8 <bcache+0x8000>
    800020ae:	2b87b703          	ld	a4,696(a5)
    800020b2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800020b4:	00016717          	auipc	a4,0x16
    800020b8:	66c70713          	addi	a4,a4,1644 # 80018720 <bcache+0x8268>
    800020bc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800020be:	2b87b703          	ld	a4,696(a5)
    800020c2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800020c4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800020c8:	0000e517          	auipc	a0,0xe
    800020cc:	3f050513          	addi	a0,a0,1008 # 800104b8 <bcache>
    800020d0:	748030ef          	jal	80005818 <release>
}
    800020d4:	60e2                	ld	ra,24(sp)
    800020d6:	6442                	ld	s0,16(sp)
    800020d8:	64a2                	ld	s1,8(sp)
    800020da:	6902                	ld	s2,0(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret
    panic("brelse");
    800020e0:	00005517          	auipc	a0,0x5
    800020e4:	3e050513          	addi	a0,a0,992 # 800074c0 <etext+0x4c0>
    800020e8:	36e030ef          	jal	80005456 <panic>

00000000800020ec <bpin>:

void
bpin(struct buf *b) {
    800020ec:	1101                	addi	sp,sp,-32
    800020ee:	ec06                	sd	ra,24(sp)
    800020f0:	e822                	sd	s0,16(sp)
    800020f2:	e426                	sd	s1,8(sp)
    800020f4:	1000                	addi	s0,sp,32
    800020f6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020f8:	0000e517          	auipc	a0,0xe
    800020fc:	3c050513          	addi	a0,a0,960 # 800104b8 <bcache>
    80002100:	684030ef          	jal	80005784 <acquire>
  b->refcnt++;
    80002104:	40bc                	lw	a5,64(s1)
    80002106:	2785                	addiw	a5,a5,1
    80002108:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000210a:	0000e517          	auipc	a0,0xe
    8000210e:	3ae50513          	addi	a0,a0,942 # 800104b8 <bcache>
    80002112:	706030ef          	jal	80005818 <release>
}
    80002116:	60e2                	ld	ra,24(sp)
    80002118:	6442                	ld	s0,16(sp)
    8000211a:	64a2                	ld	s1,8(sp)
    8000211c:	6105                	addi	sp,sp,32
    8000211e:	8082                	ret

0000000080002120 <bunpin>:

void
bunpin(struct buf *b) {
    80002120:	1101                	addi	sp,sp,-32
    80002122:	ec06                	sd	ra,24(sp)
    80002124:	e822                	sd	s0,16(sp)
    80002126:	e426                	sd	s1,8(sp)
    80002128:	1000                	addi	s0,sp,32
    8000212a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000212c:	0000e517          	auipc	a0,0xe
    80002130:	38c50513          	addi	a0,a0,908 # 800104b8 <bcache>
    80002134:	650030ef          	jal	80005784 <acquire>
  b->refcnt--;
    80002138:	40bc                	lw	a5,64(s1)
    8000213a:	37fd                	addiw	a5,a5,-1
    8000213c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000213e:	0000e517          	auipc	a0,0xe
    80002142:	37a50513          	addi	a0,a0,890 # 800104b8 <bcache>
    80002146:	6d2030ef          	jal	80005818 <release>
}
    8000214a:	60e2                	ld	ra,24(sp)
    8000214c:	6442                	ld	s0,16(sp)
    8000214e:	64a2                	ld	s1,8(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002154:	1101                	addi	sp,sp,-32
    80002156:	ec06                	sd	ra,24(sp)
    80002158:	e822                	sd	s0,16(sp)
    8000215a:	e426                	sd	s1,8(sp)
    8000215c:	e04a                	sd	s2,0(sp)
    8000215e:	1000                	addi	s0,sp,32
    80002160:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002162:	00d5d79b          	srliw	a5,a1,0xd
    80002166:	00017597          	auipc	a1,0x17
    8000216a:	a2e5a583          	lw	a1,-1490(a1) # 80018b94 <sb+0x1c>
    8000216e:	9dbd                	addw	a1,a1,a5
    80002170:	df1ff0ef          	jal	80001f60 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002174:	0074f713          	andi	a4,s1,7
    80002178:	4785                	li	a5,1
    8000217a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000217e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002180:	90d9                	srli	s1,s1,0x36
    80002182:	00950733          	add	a4,a0,s1
    80002186:	05874703          	lbu	a4,88(a4)
    8000218a:	00e7f6b3          	and	a3,a5,a4
    8000218e:	c29d                	beqz	a3,800021b4 <bfree+0x60>
    80002190:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002192:	94aa                	add	s1,s1,a0
    80002194:	fff7c793          	not	a5,a5
    80002198:	8f7d                	and	a4,a4,a5
    8000219a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000219e:	711000ef          	jal	800030ae <log_write>
  brelse(bp);
    800021a2:	854a                	mv	a0,s2
    800021a4:	ec5ff0ef          	jal	80002068 <brelse>
}
    800021a8:	60e2                	ld	ra,24(sp)
    800021aa:	6442                	ld	s0,16(sp)
    800021ac:	64a2                	ld	s1,8(sp)
    800021ae:	6902                	ld	s2,0(sp)
    800021b0:	6105                	addi	sp,sp,32
    800021b2:	8082                	ret
    panic("freeing free block");
    800021b4:	00005517          	auipc	a0,0x5
    800021b8:	31450513          	addi	a0,a0,788 # 800074c8 <etext+0x4c8>
    800021bc:	29a030ef          	jal	80005456 <panic>

00000000800021c0 <balloc>:
{
    800021c0:	715d                	addi	sp,sp,-80
    800021c2:	e486                	sd	ra,72(sp)
    800021c4:	e0a2                	sd	s0,64(sp)
    800021c6:	fc26                	sd	s1,56(sp)
    800021c8:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800021ca:	00017797          	auipc	a5,0x17
    800021ce:	9b27a783          	lw	a5,-1614(a5) # 80018b7c <sb+0x4>
    800021d2:	0e078863          	beqz	a5,800022c2 <balloc+0x102>
    800021d6:	f84a                	sd	s2,48(sp)
    800021d8:	f44e                	sd	s3,40(sp)
    800021da:	f052                	sd	s4,32(sp)
    800021dc:	ec56                	sd	s5,24(sp)
    800021de:	e85a                	sd	s6,16(sp)
    800021e0:	e45e                	sd	s7,8(sp)
    800021e2:	e062                	sd	s8,0(sp)
    800021e4:	8baa                	mv	s7,a0
    800021e6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800021e8:	00017b17          	auipc	s6,0x17
    800021ec:	990b0b13          	addi	s6,s6,-1648 # 80018b78 <sb>
      m = 1 << (bi % 8);
    800021f0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021f2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800021f4:	6c09                	lui	s8,0x2
    800021f6:	a09d                	j	8000225c <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800021f8:	97ca                	add	a5,a5,s2
    800021fa:	8e55                	or	a2,a2,a3
    800021fc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002200:	854a                	mv	a0,s2
    80002202:	6ad000ef          	jal	800030ae <log_write>
        brelse(bp);
    80002206:	854a                	mv	a0,s2
    80002208:	e61ff0ef          	jal	80002068 <brelse>
  bp = bread(dev, bno);
    8000220c:	85a6                	mv	a1,s1
    8000220e:	855e                	mv	a0,s7
    80002210:	d51ff0ef          	jal	80001f60 <bread>
    80002214:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002216:	40000613          	li	a2,1024
    8000221a:	4581                	li	a1,0
    8000221c:	05850513          	addi	a0,a0,88
    80002220:	f2ffd0ef          	jal	8000014e <memset>
  log_write(bp);
    80002224:	854a                	mv	a0,s2
    80002226:	689000ef          	jal	800030ae <log_write>
  brelse(bp);
    8000222a:	854a                	mv	a0,s2
    8000222c:	e3dff0ef          	jal	80002068 <brelse>
}
    80002230:	7942                	ld	s2,48(sp)
    80002232:	79a2                	ld	s3,40(sp)
    80002234:	7a02                	ld	s4,32(sp)
    80002236:	6ae2                	ld	s5,24(sp)
    80002238:	6b42                	ld	s6,16(sp)
    8000223a:	6ba2                	ld	s7,8(sp)
    8000223c:	6c02                	ld	s8,0(sp)
}
    8000223e:	8526                	mv	a0,s1
    80002240:	60a6                	ld	ra,72(sp)
    80002242:	6406                	ld	s0,64(sp)
    80002244:	74e2                	ld	s1,56(sp)
    80002246:	6161                	addi	sp,sp,80
    80002248:	8082                	ret
    brelse(bp);
    8000224a:	854a                	mv	a0,s2
    8000224c:	e1dff0ef          	jal	80002068 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002250:	015c0abb          	addw	s5,s8,s5
    80002254:	004b2783          	lw	a5,4(s6)
    80002258:	04fafe63          	bgeu	s5,a5,800022b4 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    8000225c:	41fad79b          	sraiw	a5,s5,0x1f
    80002260:	0137d79b          	srliw	a5,a5,0x13
    80002264:	015787bb          	addw	a5,a5,s5
    80002268:	40d7d79b          	sraiw	a5,a5,0xd
    8000226c:	01cb2583          	lw	a1,28(s6)
    80002270:	9dbd                	addw	a1,a1,a5
    80002272:	855e                	mv	a0,s7
    80002274:	cedff0ef          	jal	80001f60 <bread>
    80002278:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000227a:	004b2503          	lw	a0,4(s6)
    8000227e:	84d6                	mv	s1,s5
    80002280:	4701                	li	a4,0
    80002282:	fca4f4e3          	bgeu	s1,a0,8000224a <balloc+0x8a>
      m = 1 << (bi % 8);
    80002286:	00777693          	andi	a3,a4,7
    8000228a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000228e:	41f7579b          	sraiw	a5,a4,0x1f
    80002292:	01d7d79b          	srliw	a5,a5,0x1d
    80002296:	9fb9                	addw	a5,a5,a4
    80002298:	4037d79b          	sraiw	a5,a5,0x3
    8000229c:	00f90633          	add	a2,s2,a5
    800022a0:	05864603          	lbu	a2,88(a2)
    800022a4:	00c6f5b3          	and	a1,a3,a2
    800022a8:	d9a1                	beqz	a1,800021f8 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022aa:	2705                	addiw	a4,a4,1
    800022ac:	2485                	addiw	s1,s1,1
    800022ae:	fd471ae3          	bne	a4,s4,80002282 <balloc+0xc2>
    800022b2:	bf61                	j	8000224a <balloc+0x8a>
    800022b4:	7942                	ld	s2,48(sp)
    800022b6:	79a2                	ld	s3,40(sp)
    800022b8:	7a02                	ld	s4,32(sp)
    800022ba:	6ae2                	ld	s5,24(sp)
    800022bc:	6b42                	ld	s6,16(sp)
    800022be:	6ba2                	ld	s7,8(sp)
    800022c0:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800022c2:	00005517          	auipc	a0,0x5
    800022c6:	21e50513          	addi	a0,a0,542 # 800074e0 <etext+0x4e0>
    800022ca:	6bd020ef          	jal	80005186 <printf>
  return 0;
    800022ce:	4481                	li	s1,0
    800022d0:	b7bd                	j	8000223e <balloc+0x7e>

00000000800022d2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800022d2:	7179                	addi	sp,sp,-48
    800022d4:	f406                	sd	ra,40(sp)
    800022d6:	f022                	sd	s0,32(sp)
    800022d8:	ec26                	sd	s1,24(sp)
    800022da:	e84a                	sd	s2,16(sp)
    800022dc:	e44e                	sd	s3,8(sp)
    800022de:	1800                	addi	s0,sp,48
    800022e0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800022e2:	47ad                	li	a5,11
    800022e4:	02b7e363          	bltu	a5,a1,8000230a <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800022e8:	02059793          	slli	a5,a1,0x20
    800022ec:	01e7d593          	srli	a1,a5,0x1e
    800022f0:	00b504b3          	add	s1,a0,a1
    800022f4:	0504a903          	lw	s2,80(s1)
    800022f8:	06091363          	bnez	s2,8000235e <bmap+0x8c>
      addr = balloc(ip->dev);
    800022fc:	4108                	lw	a0,0(a0)
    800022fe:	ec3ff0ef          	jal	800021c0 <balloc>
    80002302:	892a                	mv	s2,a0
      if(addr == 0)
    80002304:	cd29                	beqz	a0,8000235e <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    80002306:	c8a8                	sw	a0,80(s1)
    80002308:	a899                	j	8000235e <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000230a:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000230e:	0ff00793          	li	a5,255
    80002312:	0697e963          	bltu	a5,s1,80002384 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002316:	08052903          	lw	s2,128(a0)
    8000231a:	00091b63          	bnez	s2,80002330 <bmap+0x5e>
      addr = balloc(ip->dev);
    8000231e:	4108                	lw	a0,0(a0)
    80002320:	ea1ff0ef          	jal	800021c0 <balloc>
    80002324:	892a                	mv	s2,a0
      if(addr == 0)
    80002326:	cd05                	beqz	a0,8000235e <bmap+0x8c>
    80002328:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000232a:	08a9a023          	sw	a0,128(s3)
    8000232e:	a011                	j	80002332 <bmap+0x60>
    80002330:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002332:	85ca                	mv	a1,s2
    80002334:	0009a503          	lw	a0,0(s3)
    80002338:	c29ff0ef          	jal	80001f60 <bread>
    8000233c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000233e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002342:	02049713          	slli	a4,s1,0x20
    80002346:	01e75593          	srli	a1,a4,0x1e
    8000234a:	00b784b3          	add	s1,a5,a1
    8000234e:	0004a903          	lw	s2,0(s1)
    80002352:	00090e63          	beqz	s2,8000236e <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002356:	8552                	mv	a0,s4
    80002358:	d11ff0ef          	jal	80002068 <brelse>
    return addr;
    8000235c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000235e:	854a                	mv	a0,s2
    80002360:	70a2                	ld	ra,40(sp)
    80002362:	7402                	ld	s0,32(sp)
    80002364:	64e2                	ld	s1,24(sp)
    80002366:	6942                	ld	s2,16(sp)
    80002368:	69a2                	ld	s3,8(sp)
    8000236a:	6145                	addi	sp,sp,48
    8000236c:	8082                	ret
      addr = balloc(ip->dev);
    8000236e:	0009a503          	lw	a0,0(s3)
    80002372:	e4fff0ef          	jal	800021c0 <balloc>
    80002376:	892a                	mv	s2,a0
      if(addr){
    80002378:	dd79                	beqz	a0,80002356 <bmap+0x84>
        a[bn] = addr;
    8000237a:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000237c:	8552                	mv	a0,s4
    8000237e:	531000ef          	jal	800030ae <log_write>
    80002382:	bfd1                	j	80002356 <bmap+0x84>
    80002384:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002386:	00005517          	auipc	a0,0x5
    8000238a:	17250513          	addi	a0,a0,370 # 800074f8 <etext+0x4f8>
    8000238e:	0c8030ef          	jal	80005456 <panic>

0000000080002392 <iget>:
{
    80002392:	7179                	addi	sp,sp,-48
    80002394:	f406                	sd	ra,40(sp)
    80002396:	f022                	sd	s0,32(sp)
    80002398:	ec26                	sd	s1,24(sp)
    8000239a:	e84a                	sd	s2,16(sp)
    8000239c:	e44e                	sd	s3,8(sp)
    8000239e:	e052                	sd	s4,0(sp)
    800023a0:	1800                	addi	s0,sp,48
    800023a2:	89aa                	mv	s3,a0
    800023a4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800023a6:	00016517          	auipc	a0,0x16
    800023aa:	7f250513          	addi	a0,a0,2034 # 80018b98 <itable>
    800023ae:	3d6030ef          	jal	80005784 <acquire>
  empty = 0;
    800023b2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800023b4:	00016497          	auipc	s1,0x16
    800023b8:	7fc48493          	addi	s1,s1,2044 # 80018bb0 <itable+0x18>
    800023bc:	00018697          	auipc	a3,0x18
    800023c0:	28468693          	addi	a3,a3,644 # 8001a640 <log>
    800023c4:	a039                	j	800023d2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023c6:	02090963          	beqz	s2,800023f8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800023ca:	08848493          	addi	s1,s1,136
    800023ce:	02d48863          	beq	s1,a3,800023fe <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800023d2:	449c                	lw	a5,8(s1)
    800023d4:	fef059e3          	blez	a5,800023c6 <iget+0x34>
    800023d8:	4098                	lw	a4,0(s1)
    800023da:	ff3716e3          	bne	a4,s3,800023c6 <iget+0x34>
    800023de:	40d8                	lw	a4,4(s1)
    800023e0:	ff4713e3          	bne	a4,s4,800023c6 <iget+0x34>
      ip->ref++;
    800023e4:	2785                	addiw	a5,a5,1
    800023e6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800023e8:	00016517          	auipc	a0,0x16
    800023ec:	7b050513          	addi	a0,a0,1968 # 80018b98 <itable>
    800023f0:	428030ef          	jal	80005818 <release>
      return ip;
    800023f4:	8926                	mv	s2,s1
    800023f6:	a02d                	j	80002420 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023f8:	fbe9                	bnez	a5,800023ca <iget+0x38>
      empty = ip;
    800023fa:	8926                	mv	s2,s1
    800023fc:	b7f9                	j	800023ca <iget+0x38>
  if(empty == 0)
    800023fe:	02090a63          	beqz	s2,80002432 <iget+0xa0>
  ip->dev = dev;
    80002402:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002406:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000240a:	4785                	li	a5,1
    8000240c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002410:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002414:	00016517          	auipc	a0,0x16
    80002418:	78450513          	addi	a0,a0,1924 # 80018b98 <itable>
    8000241c:	3fc030ef          	jal	80005818 <release>
}
    80002420:	854a                	mv	a0,s2
    80002422:	70a2                	ld	ra,40(sp)
    80002424:	7402                	ld	s0,32(sp)
    80002426:	64e2                	ld	s1,24(sp)
    80002428:	6942                	ld	s2,16(sp)
    8000242a:	69a2                	ld	s3,8(sp)
    8000242c:	6a02                	ld	s4,0(sp)
    8000242e:	6145                	addi	sp,sp,48
    80002430:	8082                	ret
    panic("iget: no inodes");
    80002432:	00005517          	auipc	a0,0x5
    80002436:	0de50513          	addi	a0,a0,222 # 80007510 <etext+0x510>
    8000243a:	01c030ef          	jal	80005456 <panic>

000000008000243e <fsinit>:
fsinit(int dev) {
    8000243e:	7179                	addi	sp,sp,-48
    80002440:	f406                	sd	ra,40(sp)
    80002442:	f022                	sd	s0,32(sp)
    80002444:	ec26                	sd	s1,24(sp)
    80002446:	e84a                	sd	s2,16(sp)
    80002448:	e44e                	sd	s3,8(sp)
    8000244a:	1800                	addi	s0,sp,48
    8000244c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000244e:	4585                	li	a1,1
    80002450:	b11ff0ef          	jal	80001f60 <bread>
    80002454:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002456:	00016997          	auipc	s3,0x16
    8000245a:	72298993          	addi	s3,s3,1826 # 80018b78 <sb>
    8000245e:	02000613          	li	a2,32
    80002462:	05850593          	addi	a1,a0,88
    80002466:	854e                	mv	a0,s3
    80002468:	d4bfd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    8000246c:	8526                	mv	a0,s1
    8000246e:	bfbff0ef          	jal	80002068 <brelse>
  if(sb.magic != FSMAGIC)
    80002472:	0009a703          	lw	a4,0(s3)
    80002476:	102037b7          	lui	a5,0x10203
    8000247a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000247e:	02f71063          	bne	a4,a5,8000249e <fsinit+0x60>
  initlog(dev, &sb);
    80002482:	00016597          	auipc	a1,0x16
    80002486:	6f658593          	addi	a1,a1,1782 # 80018b78 <sb>
    8000248a:	854a                	mv	a0,s2
    8000248c:	215000ef          	jal	80002ea0 <initlog>
}
    80002490:	70a2                	ld	ra,40(sp)
    80002492:	7402                	ld	s0,32(sp)
    80002494:	64e2                	ld	s1,24(sp)
    80002496:	6942                	ld	s2,16(sp)
    80002498:	69a2                	ld	s3,8(sp)
    8000249a:	6145                	addi	sp,sp,48
    8000249c:	8082                	ret
    panic("invalid file system");
    8000249e:	00005517          	auipc	a0,0x5
    800024a2:	08250513          	addi	a0,a0,130 # 80007520 <etext+0x520>
    800024a6:	7b1020ef          	jal	80005456 <panic>

00000000800024aa <iinit>:
{
    800024aa:	7179                	addi	sp,sp,-48
    800024ac:	f406                	sd	ra,40(sp)
    800024ae:	f022                	sd	s0,32(sp)
    800024b0:	ec26                	sd	s1,24(sp)
    800024b2:	e84a                	sd	s2,16(sp)
    800024b4:	e44e                	sd	s3,8(sp)
    800024b6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800024b8:	00005597          	auipc	a1,0x5
    800024bc:	08058593          	addi	a1,a1,128 # 80007538 <etext+0x538>
    800024c0:	00016517          	auipc	a0,0x16
    800024c4:	6d850513          	addi	a0,a0,1752 # 80018b98 <itable>
    800024c8:	238030ef          	jal	80005700 <initlock>
  for(i = 0; i < NINODE; i++) {
    800024cc:	00016497          	auipc	s1,0x16
    800024d0:	6f448493          	addi	s1,s1,1780 # 80018bc0 <itable+0x28>
    800024d4:	00018997          	auipc	s3,0x18
    800024d8:	17c98993          	addi	s3,s3,380 # 8001a650 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800024dc:	00005917          	auipc	s2,0x5
    800024e0:	06490913          	addi	s2,s2,100 # 80007540 <etext+0x540>
    800024e4:	85ca                	mv	a1,s2
    800024e6:	8526                	mv	a0,s1
    800024e8:	497000ef          	jal	8000317e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800024ec:	08848493          	addi	s1,s1,136
    800024f0:	ff349ae3          	bne	s1,s3,800024e4 <iinit+0x3a>
}
    800024f4:	70a2                	ld	ra,40(sp)
    800024f6:	7402                	ld	s0,32(sp)
    800024f8:	64e2                	ld	s1,24(sp)
    800024fa:	6942                	ld	s2,16(sp)
    800024fc:	69a2                	ld	s3,8(sp)
    800024fe:	6145                	addi	sp,sp,48
    80002500:	8082                	ret

0000000080002502 <ialloc>:
{
    80002502:	7139                	addi	sp,sp,-64
    80002504:	fc06                	sd	ra,56(sp)
    80002506:	f822                	sd	s0,48(sp)
    80002508:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000250a:	00016717          	auipc	a4,0x16
    8000250e:	67a72703          	lw	a4,1658(a4) # 80018b84 <sb+0xc>
    80002512:	4785                	li	a5,1
    80002514:	06e7f063          	bgeu	a5,a4,80002574 <ialloc+0x72>
    80002518:	f426                	sd	s1,40(sp)
    8000251a:	f04a                	sd	s2,32(sp)
    8000251c:	ec4e                	sd	s3,24(sp)
    8000251e:	e852                	sd	s4,16(sp)
    80002520:	e456                	sd	s5,8(sp)
    80002522:	e05a                	sd	s6,0(sp)
    80002524:	8aaa                	mv	s5,a0
    80002526:	8b2e                	mv	s6,a1
    80002528:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000252a:	00016a17          	auipc	s4,0x16
    8000252e:	64ea0a13          	addi	s4,s4,1614 # 80018b78 <sb>
    80002532:	00495593          	srli	a1,s2,0x4
    80002536:	018a2783          	lw	a5,24(s4)
    8000253a:	9dbd                	addw	a1,a1,a5
    8000253c:	8556                	mv	a0,s5
    8000253e:	a23ff0ef          	jal	80001f60 <bread>
    80002542:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002544:	05850993          	addi	s3,a0,88
    80002548:	00f97793          	andi	a5,s2,15
    8000254c:	079a                	slli	a5,a5,0x6
    8000254e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002550:	00099783          	lh	a5,0(s3)
    80002554:	cb9d                	beqz	a5,8000258a <ialloc+0x88>
    brelse(bp);
    80002556:	b13ff0ef          	jal	80002068 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000255a:	0905                	addi	s2,s2,1
    8000255c:	00ca2703          	lw	a4,12(s4)
    80002560:	0009079b          	sext.w	a5,s2
    80002564:	fce7e7e3          	bltu	a5,a4,80002532 <ialloc+0x30>
    80002568:	74a2                	ld	s1,40(sp)
    8000256a:	7902                	ld	s2,32(sp)
    8000256c:	69e2                	ld	s3,24(sp)
    8000256e:	6a42                	ld	s4,16(sp)
    80002570:	6aa2                	ld	s5,8(sp)
    80002572:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002574:	00005517          	auipc	a0,0x5
    80002578:	fd450513          	addi	a0,a0,-44 # 80007548 <etext+0x548>
    8000257c:	40b020ef          	jal	80005186 <printf>
  return 0;
    80002580:	4501                	li	a0,0
}
    80002582:	70e2                	ld	ra,56(sp)
    80002584:	7442                	ld	s0,48(sp)
    80002586:	6121                	addi	sp,sp,64
    80002588:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000258a:	04000613          	li	a2,64
    8000258e:	4581                	li	a1,0
    80002590:	854e                	mv	a0,s3
    80002592:	bbdfd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002596:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000259a:	8526                	mv	a0,s1
    8000259c:	313000ef          	jal	800030ae <log_write>
      brelse(bp);
    800025a0:	8526                	mv	a0,s1
    800025a2:	ac7ff0ef          	jal	80002068 <brelse>
      return iget(dev, inum);
    800025a6:	0009059b          	sext.w	a1,s2
    800025aa:	8556                	mv	a0,s5
    800025ac:	de7ff0ef          	jal	80002392 <iget>
    800025b0:	74a2                	ld	s1,40(sp)
    800025b2:	7902                	ld	s2,32(sp)
    800025b4:	69e2                	ld	s3,24(sp)
    800025b6:	6a42                	ld	s4,16(sp)
    800025b8:	6aa2                	ld	s5,8(sp)
    800025ba:	6b02                	ld	s6,0(sp)
    800025bc:	b7d9                	j	80002582 <ialloc+0x80>

00000000800025be <iupdate>:
{
    800025be:	1101                	addi	sp,sp,-32
    800025c0:	ec06                	sd	ra,24(sp)
    800025c2:	e822                	sd	s0,16(sp)
    800025c4:	e426                	sd	s1,8(sp)
    800025c6:	e04a                	sd	s2,0(sp)
    800025c8:	1000                	addi	s0,sp,32
    800025ca:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025cc:	415c                	lw	a5,4(a0)
    800025ce:	0047d79b          	srliw	a5,a5,0x4
    800025d2:	00016597          	auipc	a1,0x16
    800025d6:	5be5a583          	lw	a1,1470(a1) # 80018b90 <sb+0x18>
    800025da:	9dbd                	addw	a1,a1,a5
    800025dc:	4108                	lw	a0,0(a0)
    800025de:	983ff0ef          	jal	80001f60 <bread>
    800025e2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800025e4:	05850793          	addi	a5,a0,88
    800025e8:	40d8                	lw	a4,4(s1)
    800025ea:	8b3d                	andi	a4,a4,15
    800025ec:	071a                	slli	a4,a4,0x6
    800025ee:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800025f0:	04449703          	lh	a4,68(s1)
    800025f4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800025f8:	04649703          	lh	a4,70(s1)
    800025fc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002600:	04849703          	lh	a4,72(s1)
    80002604:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002608:	04a49703          	lh	a4,74(s1)
    8000260c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002610:	44f8                	lw	a4,76(s1)
    80002612:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002614:	03400613          	li	a2,52
    80002618:	05048593          	addi	a1,s1,80
    8000261c:	00c78513          	addi	a0,a5,12
    80002620:	b93fd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    80002624:	854a                	mv	a0,s2
    80002626:	289000ef          	jal	800030ae <log_write>
  brelse(bp);
    8000262a:	854a                	mv	a0,s2
    8000262c:	a3dff0ef          	jal	80002068 <brelse>
}
    80002630:	60e2                	ld	ra,24(sp)
    80002632:	6442                	ld	s0,16(sp)
    80002634:	64a2                	ld	s1,8(sp)
    80002636:	6902                	ld	s2,0(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret

000000008000263c <idup>:
{
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002648:	00016517          	auipc	a0,0x16
    8000264c:	55050513          	addi	a0,a0,1360 # 80018b98 <itable>
    80002650:	134030ef          	jal	80005784 <acquire>
  ip->ref++;
    80002654:	449c                	lw	a5,8(s1)
    80002656:	2785                	addiw	a5,a5,1
    80002658:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000265a:	00016517          	auipc	a0,0x16
    8000265e:	53e50513          	addi	a0,a0,1342 # 80018b98 <itable>
    80002662:	1b6030ef          	jal	80005818 <release>
}
    80002666:	8526                	mv	a0,s1
    80002668:	60e2                	ld	ra,24(sp)
    8000266a:	6442                	ld	s0,16(sp)
    8000266c:	64a2                	ld	s1,8(sp)
    8000266e:	6105                	addi	sp,sp,32
    80002670:	8082                	ret

0000000080002672 <ilock>:
{
    80002672:	1101                	addi	sp,sp,-32
    80002674:	ec06                	sd	ra,24(sp)
    80002676:	e822                	sd	s0,16(sp)
    80002678:	e426                	sd	s1,8(sp)
    8000267a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000267c:	cd19                	beqz	a0,8000269a <ilock+0x28>
    8000267e:	84aa                	mv	s1,a0
    80002680:	451c                	lw	a5,8(a0)
    80002682:	00f05c63          	blez	a5,8000269a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002686:	0541                	addi	a0,a0,16
    80002688:	32d000ef          	jal	800031b4 <acquiresleep>
  if(ip->valid == 0){
    8000268c:	40bc                	lw	a5,64(s1)
    8000268e:	cf89                	beqz	a5,800026a8 <ilock+0x36>
}
    80002690:	60e2                	ld	ra,24(sp)
    80002692:	6442                	ld	s0,16(sp)
    80002694:	64a2                	ld	s1,8(sp)
    80002696:	6105                	addi	sp,sp,32
    80002698:	8082                	ret
    8000269a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000269c:	00005517          	auipc	a0,0x5
    800026a0:	ec450513          	addi	a0,a0,-316 # 80007560 <etext+0x560>
    800026a4:	5b3020ef          	jal	80005456 <panic>
    800026a8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026aa:	40dc                	lw	a5,4(s1)
    800026ac:	0047d79b          	srliw	a5,a5,0x4
    800026b0:	00016597          	auipc	a1,0x16
    800026b4:	4e05a583          	lw	a1,1248(a1) # 80018b90 <sb+0x18>
    800026b8:	9dbd                	addw	a1,a1,a5
    800026ba:	4088                	lw	a0,0(s1)
    800026bc:	8a5ff0ef          	jal	80001f60 <bread>
    800026c0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026c2:	05850593          	addi	a1,a0,88
    800026c6:	40dc                	lw	a5,4(s1)
    800026c8:	8bbd                	andi	a5,a5,15
    800026ca:	079a                	slli	a5,a5,0x6
    800026cc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026ce:	00059783          	lh	a5,0(a1)
    800026d2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026d6:	00259783          	lh	a5,2(a1)
    800026da:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800026de:	00459783          	lh	a5,4(a1)
    800026e2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800026e6:	00659783          	lh	a5,6(a1)
    800026ea:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800026ee:	459c                	lw	a5,8(a1)
    800026f0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800026f2:	03400613          	li	a2,52
    800026f6:	05b1                	addi	a1,a1,12
    800026f8:	05048513          	addi	a0,s1,80
    800026fc:	ab7fd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    80002700:	854a                	mv	a0,s2
    80002702:	967ff0ef          	jal	80002068 <brelse>
    ip->valid = 1;
    80002706:	4785                	li	a5,1
    80002708:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000270a:	04449783          	lh	a5,68(s1)
    8000270e:	c399                	beqz	a5,80002714 <ilock+0xa2>
    80002710:	6902                	ld	s2,0(sp)
    80002712:	bfbd                	j	80002690 <ilock+0x1e>
      panic("ilock: no type");
    80002714:	00005517          	auipc	a0,0x5
    80002718:	e5450513          	addi	a0,a0,-428 # 80007568 <etext+0x568>
    8000271c:	53b020ef          	jal	80005456 <panic>

0000000080002720 <iunlock>:
{
    80002720:	1101                	addi	sp,sp,-32
    80002722:	ec06                	sd	ra,24(sp)
    80002724:	e822                	sd	s0,16(sp)
    80002726:	e426                	sd	s1,8(sp)
    80002728:	e04a                	sd	s2,0(sp)
    8000272a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000272c:	c505                	beqz	a0,80002754 <iunlock+0x34>
    8000272e:	84aa                	mv	s1,a0
    80002730:	01050913          	addi	s2,a0,16
    80002734:	854a                	mv	a0,s2
    80002736:	2fd000ef          	jal	80003232 <holdingsleep>
    8000273a:	cd09                	beqz	a0,80002754 <iunlock+0x34>
    8000273c:	449c                	lw	a5,8(s1)
    8000273e:	00f05b63          	blez	a5,80002754 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002742:	854a                	mv	a0,s2
    80002744:	2b7000ef          	jal	800031fa <releasesleep>
}
    80002748:	60e2                	ld	ra,24(sp)
    8000274a:	6442                	ld	s0,16(sp)
    8000274c:	64a2                	ld	s1,8(sp)
    8000274e:	6902                	ld	s2,0(sp)
    80002750:	6105                	addi	sp,sp,32
    80002752:	8082                	ret
    panic("iunlock");
    80002754:	00005517          	auipc	a0,0x5
    80002758:	e2450513          	addi	a0,a0,-476 # 80007578 <etext+0x578>
    8000275c:	4fb020ef          	jal	80005456 <panic>

0000000080002760 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002760:	7179                	addi	sp,sp,-48
    80002762:	f406                	sd	ra,40(sp)
    80002764:	f022                	sd	s0,32(sp)
    80002766:	ec26                	sd	s1,24(sp)
    80002768:	e84a                	sd	s2,16(sp)
    8000276a:	e44e                	sd	s3,8(sp)
    8000276c:	1800                	addi	s0,sp,48
    8000276e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002770:	05050493          	addi	s1,a0,80
    80002774:	08050913          	addi	s2,a0,128
    80002778:	a021                	j	80002780 <itrunc+0x20>
    8000277a:	0491                	addi	s1,s1,4
    8000277c:	01248b63          	beq	s1,s2,80002792 <itrunc+0x32>
    if(ip->addrs[i]){
    80002780:	408c                	lw	a1,0(s1)
    80002782:	dde5                	beqz	a1,8000277a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002784:	0009a503          	lw	a0,0(s3)
    80002788:	9cdff0ef          	jal	80002154 <bfree>
      ip->addrs[i] = 0;
    8000278c:	0004a023          	sw	zero,0(s1)
    80002790:	b7ed                	j	8000277a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002792:	0809a583          	lw	a1,128(s3)
    80002796:	ed89                	bnez	a1,800027b0 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002798:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000279c:	854e                	mv	a0,s3
    8000279e:	e21ff0ef          	jal	800025be <iupdate>
}
    800027a2:	70a2                	ld	ra,40(sp)
    800027a4:	7402                	ld	s0,32(sp)
    800027a6:	64e2                	ld	s1,24(sp)
    800027a8:	6942                	ld	s2,16(sp)
    800027aa:	69a2                	ld	s3,8(sp)
    800027ac:	6145                	addi	sp,sp,48
    800027ae:	8082                	ret
    800027b0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800027b2:	0009a503          	lw	a0,0(s3)
    800027b6:	faaff0ef          	jal	80001f60 <bread>
    800027ba:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800027bc:	05850493          	addi	s1,a0,88
    800027c0:	45850913          	addi	s2,a0,1112
    800027c4:	a021                	j	800027cc <itrunc+0x6c>
    800027c6:	0491                	addi	s1,s1,4
    800027c8:	01248963          	beq	s1,s2,800027da <itrunc+0x7a>
      if(a[j])
    800027cc:	408c                	lw	a1,0(s1)
    800027ce:	dde5                	beqz	a1,800027c6 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800027d0:	0009a503          	lw	a0,0(s3)
    800027d4:	981ff0ef          	jal	80002154 <bfree>
    800027d8:	b7fd                	j	800027c6 <itrunc+0x66>
    brelse(bp);
    800027da:	8552                	mv	a0,s4
    800027dc:	88dff0ef          	jal	80002068 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800027e0:	0809a583          	lw	a1,128(s3)
    800027e4:	0009a503          	lw	a0,0(s3)
    800027e8:	96dff0ef          	jal	80002154 <bfree>
    ip->addrs[NDIRECT] = 0;
    800027ec:	0809a023          	sw	zero,128(s3)
    800027f0:	6a02                	ld	s4,0(sp)
    800027f2:	b75d                	j	80002798 <itrunc+0x38>

00000000800027f4 <iput>:
{
    800027f4:	1101                	addi	sp,sp,-32
    800027f6:	ec06                	sd	ra,24(sp)
    800027f8:	e822                	sd	s0,16(sp)
    800027fa:	e426                	sd	s1,8(sp)
    800027fc:	1000                	addi	s0,sp,32
    800027fe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002800:	00016517          	auipc	a0,0x16
    80002804:	39850513          	addi	a0,a0,920 # 80018b98 <itable>
    80002808:	77d020ef          	jal	80005784 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000280c:	4498                	lw	a4,8(s1)
    8000280e:	4785                	li	a5,1
    80002810:	02f70063          	beq	a4,a5,80002830 <iput+0x3c>
  ip->ref--;
    80002814:	449c                	lw	a5,8(s1)
    80002816:	37fd                	addiw	a5,a5,-1
    80002818:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000281a:	00016517          	auipc	a0,0x16
    8000281e:	37e50513          	addi	a0,a0,894 # 80018b98 <itable>
    80002822:	7f7020ef          	jal	80005818 <release>
}
    80002826:	60e2                	ld	ra,24(sp)
    80002828:	6442                	ld	s0,16(sp)
    8000282a:	64a2                	ld	s1,8(sp)
    8000282c:	6105                	addi	sp,sp,32
    8000282e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002830:	40bc                	lw	a5,64(s1)
    80002832:	d3ed                	beqz	a5,80002814 <iput+0x20>
    80002834:	04a49783          	lh	a5,74(s1)
    80002838:	fff1                	bnez	a5,80002814 <iput+0x20>
    8000283a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000283c:	01048913          	addi	s2,s1,16
    80002840:	854a                	mv	a0,s2
    80002842:	173000ef          	jal	800031b4 <acquiresleep>
    release(&itable.lock);
    80002846:	00016517          	auipc	a0,0x16
    8000284a:	35250513          	addi	a0,a0,850 # 80018b98 <itable>
    8000284e:	7cb020ef          	jal	80005818 <release>
    itrunc(ip);
    80002852:	8526                	mv	a0,s1
    80002854:	f0dff0ef          	jal	80002760 <itrunc>
    ip->type = 0;
    80002858:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000285c:	8526                	mv	a0,s1
    8000285e:	d61ff0ef          	jal	800025be <iupdate>
    ip->valid = 0;
    80002862:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002866:	854a                	mv	a0,s2
    80002868:	193000ef          	jal	800031fa <releasesleep>
    acquire(&itable.lock);
    8000286c:	00016517          	auipc	a0,0x16
    80002870:	32c50513          	addi	a0,a0,812 # 80018b98 <itable>
    80002874:	711020ef          	jal	80005784 <acquire>
    80002878:	6902                	ld	s2,0(sp)
    8000287a:	bf69                	j	80002814 <iput+0x20>

000000008000287c <iunlockput>:
{
    8000287c:	1101                	addi	sp,sp,-32
    8000287e:	ec06                	sd	ra,24(sp)
    80002880:	e822                	sd	s0,16(sp)
    80002882:	e426                	sd	s1,8(sp)
    80002884:	1000                	addi	s0,sp,32
    80002886:	84aa                	mv	s1,a0
  iunlock(ip);
    80002888:	e99ff0ef          	jal	80002720 <iunlock>
  iput(ip);
    8000288c:	8526                	mv	a0,s1
    8000288e:	f67ff0ef          	jal	800027f4 <iput>
}
    80002892:	60e2                	ld	ra,24(sp)
    80002894:	6442                	ld	s0,16(sp)
    80002896:	64a2                	ld	s1,8(sp)
    80002898:	6105                	addi	sp,sp,32
    8000289a:	8082                	ret

000000008000289c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000289c:	1141                	addi	sp,sp,-16
    8000289e:	e406                	sd	ra,8(sp)
    800028a0:	e022                	sd	s0,0(sp)
    800028a2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800028a4:	411c                	lw	a5,0(a0)
    800028a6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800028a8:	415c                	lw	a5,4(a0)
    800028aa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800028ac:	04451783          	lh	a5,68(a0)
    800028b0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800028b4:	04a51783          	lh	a5,74(a0)
    800028b8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800028bc:	04c56783          	lwu	a5,76(a0)
    800028c0:	e99c                	sd	a5,16(a1)
}
    800028c2:	60a2                	ld	ra,8(sp)
    800028c4:	6402                	ld	s0,0(sp)
    800028c6:	0141                	addi	sp,sp,16
    800028c8:	8082                	ret

00000000800028ca <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800028ca:	457c                	lw	a5,76(a0)
    800028cc:	0ed7e663          	bltu	a5,a3,800029b8 <readi+0xee>
{
    800028d0:	7159                	addi	sp,sp,-112
    800028d2:	f486                	sd	ra,104(sp)
    800028d4:	f0a2                	sd	s0,96(sp)
    800028d6:	eca6                	sd	s1,88(sp)
    800028d8:	e0d2                	sd	s4,64(sp)
    800028da:	fc56                	sd	s5,56(sp)
    800028dc:	f85a                	sd	s6,48(sp)
    800028de:	f45e                	sd	s7,40(sp)
    800028e0:	1880                	addi	s0,sp,112
    800028e2:	8b2a                	mv	s6,a0
    800028e4:	8bae                	mv	s7,a1
    800028e6:	8a32                	mv	s4,a2
    800028e8:	84b6                	mv	s1,a3
    800028ea:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800028ec:	9f35                	addw	a4,a4,a3
    return 0;
    800028ee:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800028f0:	0ad76b63          	bltu	a4,a3,800029a6 <readi+0xdc>
    800028f4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800028f6:	00e7f463          	bgeu	a5,a4,800028fe <readi+0x34>
    n = ip->size - off;
    800028fa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028fe:	080a8b63          	beqz	s5,80002994 <readi+0xca>
    80002902:	e8ca                	sd	s2,80(sp)
    80002904:	f062                	sd	s8,32(sp)
    80002906:	ec66                	sd	s9,24(sp)
    80002908:	e86a                	sd	s10,16(sp)
    8000290a:	e46e                	sd	s11,8(sp)
    8000290c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000290e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002912:	5c7d                	li	s8,-1
    80002914:	a80d                	j	80002946 <readi+0x7c>
    80002916:	020d1d93          	slli	s11,s10,0x20
    8000291a:	020ddd93          	srli	s11,s11,0x20
    8000291e:	05890613          	addi	a2,s2,88
    80002922:	86ee                	mv	a3,s11
    80002924:	963e                	add	a2,a2,a5
    80002926:	85d2                	mv	a1,s4
    80002928:	855e                	mv	a0,s7
    8000292a:	d63fe0ef          	jal	8000168c <either_copyout>
    8000292e:	05850363          	beq	a0,s8,80002974 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002932:	854a                	mv	a0,s2
    80002934:	f34ff0ef          	jal	80002068 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002938:	013d09bb          	addw	s3,s10,s3
    8000293c:	009d04bb          	addw	s1,s10,s1
    80002940:	9a6e                	add	s4,s4,s11
    80002942:	0559f363          	bgeu	s3,s5,80002988 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002946:	00a4d59b          	srliw	a1,s1,0xa
    8000294a:	855a                	mv	a0,s6
    8000294c:	987ff0ef          	jal	800022d2 <bmap>
    80002950:	85aa                	mv	a1,a0
    if(addr == 0)
    80002952:	c139                	beqz	a0,80002998 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002954:	000b2503          	lw	a0,0(s6)
    80002958:	e08ff0ef          	jal	80001f60 <bread>
    8000295c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000295e:	3ff4f793          	andi	a5,s1,1023
    80002962:	40fc873b          	subw	a4,s9,a5
    80002966:	413a86bb          	subw	a3,s5,s3
    8000296a:	8d3a                	mv	s10,a4
    8000296c:	fae6f5e3          	bgeu	a3,a4,80002916 <readi+0x4c>
    80002970:	8d36                	mv	s10,a3
    80002972:	b755                	j	80002916 <readi+0x4c>
      brelse(bp);
    80002974:	854a                	mv	a0,s2
    80002976:	ef2ff0ef          	jal	80002068 <brelse>
      tot = -1;
    8000297a:	59fd                	li	s3,-1
      break;
    8000297c:	6946                	ld	s2,80(sp)
    8000297e:	7c02                	ld	s8,32(sp)
    80002980:	6ce2                	ld	s9,24(sp)
    80002982:	6d42                	ld	s10,16(sp)
    80002984:	6da2                	ld	s11,8(sp)
    80002986:	a831                	j	800029a2 <readi+0xd8>
    80002988:	6946                	ld	s2,80(sp)
    8000298a:	7c02                	ld	s8,32(sp)
    8000298c:	6ce2                	ld	s9,24(sp)
    8000298e:	6d42                	ld	s10,16(sp)
    80002990:	6da2                	ld	s11,8(sp)
    80002992:	a801                	j	800029a2 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002994:	89d6                	mv	s3,s5
    80002996:	a031                	j	800029a2 <readi+0xd8>
    80002998:	6946                	ld	s2,80(sp)
    8000299a:	7c02                	ld	s8,32(sp)
    8000299c:	6ce2                	ld	s9,24(sp)
    8000299e:	6d42                	ld	s10,16(sp)
    800029a0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800029a2:	854e                	mv	a0,s3
    800029a4:	69a6                	ld	s3,72(sp)
}
    800029a6:	70a6                	ld	ra,104(sp)
    800029a8:	7406                	ld	s0,96(sp)
    800029aa:	64e6                	ld	s1,88(sp)
    800029ac:	6a06                	ld	s4,64(sp)
    800029ae:	7ae2                	ld	s5,56(sp)
    800029b0:	7b42                	ld	s6,48(sp)
    800029b2:	7ba2                	ld	s7,40(sp)
    800029b4:	6165                	addi	sp,sp,112
    800029b6:	8082                	ret
    return 0;
    800029b8:	4501                	li	a0,0
}
    800029ba:	8082                	ret

00000000800029bc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029bc:	457c                	lw	a5,76(a0)
    800029be:	0ed7eb63          	bltu	a5,a3,80002ab4 <writei+0xf8>
{
    800029c2:	7159                	addi	sp,sp,-112
    800029c4:	f486                	sd	ra,104(sp)
    800029c6:	f0a2                	sd	s0,96(sp)
    800029c8:	e8ca                	sd	s2,80(sp)
    800029ca:	e0d2                	sd	s4,64(sp)
    800029cc:	fc56                	sd	s5,56(sp)
    800029ce:	f85a                	sd	s6,48(sp)
    800029d0:	f45e                	sd	s7,40(sp)
    800029d2:	1880                	addi	s0,sp,112
    800029d4:	8aaa                	mv	s5,a0
    800029d6:	8bae                	mv	s7,a1
    800029d8:	8a32                	mv	s4,a2
    800029da:	8936                	mv	s2,a3
    800029dc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800029de:	00e687bb          	addw	a5,a3,a4
    800029e2:	0cd7eb63          	bltu	a5,a3,80002ab8 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800029e6:	00043737          	lui	a4,0x43
    800029ea:	0cf76963          	bltu	a4,a5,80002abc <writei+0x100>
    800029ee:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029f0:	0a0b0a63          	beqz	s6,80002aa4 <writei+0xe8>
    800029f4:	eca6                	sd	s1,88(sp)
    800029f6:	f062                	sd	s8,32(sp)
    800029f8:	ec66                	sd	s9,24(sp)
    800029fa:	e86a                	sd	s10,16(sp)
    800029fc:	e46e                	sd	s11,8(sp)
    800029fe:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a00:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002a04:	5c7d                	li	s8,-1
    80002a06:	a825                	j	80002a3e <writei+0x82>
    80002a08:	020d1d93          	slli	s11,s10,0x20
    80002a0c:	020ddd93          	srli	s11,s11,0x20
    80002a10:	05848513          	addi	a0,s1,88
    80002a14:	86ee                	mv	a3,s11
    80002a16:	8652                	mv	a2,s4
    80002a18:	85de                	mv	a1,s7
    80002a1a:	953e                	add	a0,a0,a5
    80002a1c:	cbbfe0ef          	jal	800016d6 <either_copyin>
    80002a20:	05850663          	beq	a0,s8,80002a6c <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002a24:	8526                	mv	a0,s1
    80002a26:	688000ef          	jal	800030ae <log_write>
    brelse(bp);
    80002a2a:	8526                	mv	a0,s1
    80002a2c:	e3cff0ef          	jal	80002068 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a30:	013d09bb          	addw	s3,s10,s3
    80002a34:	012d093b          	addw	s2,s10,s2
    80002a38:	9a6e                	add	s4,s4,s11
    80002a3a:	0369fc63          	bgeu	s3,s6,80002a72 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002a3e:	00a9559b          	srliw	a1,s2,0xa
    80002a42:	8556                	mv	a0,s5
    80002a44:	88fff0ef          	jal	800022d2 <bmap>
    80002a48:	85aa                	mv	a1,a0
    if(addr == 0)
    80002a4a:	c505                	beqz	a0,80002a72 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002a4c:	000aa503          	lw	a0,0(s5)
    80002a50:	d10ff0ef          	jal	80001f60 <bread>
    80002a54:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a56:	3ff97793          	andi	a5,s2,1023
    80002a5a:	40fc873b          	subw	a4,s9,a5
    80002a5e:	413b06bb          	subw	a3,s6,s3
    80002a62:	8d3a                	mv	s10,a4
    80002a64:	fae6f2e3          	bgeu	a3,a4,80002a08 <writei+0x4c>
    80002a68:	8d36                	mv	s10,a3
    80002a6a:	bf79                	j	80002a08 <writei+0x4c>
      brelse(bp);
    80002a6c:	8526                	mv	a0,s1
    80002a6e:	dfaff0ef          	jal	80002068 <brelse>
  }

  if(off > ip->size)
    80002a72:	04caa783          	lw	a5,76(s5)
    80002a76:	0327f963          	bgeu	a5,s2,80002aa8 <writei+0xec>
    ip->size = off;
    80002a7a:	052aa623          	sw	s2,76(s5)
    80002a7e:	64e6                	ld	s1,88(sp)
    80002a80:	7c02                	ld	s8,32(sp)
    80002a82:	6ce2                	ld	s9,24(sp)
    80002a84:	6d42                	ld	s10,16(sp)
    80002a86:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a88:	8556                	mv	a0,s5
    80002a8a:	b35ff0ef          	jal	800025be <iupdate>

  return tot;
    80002a8e:	854e                	mv	a0,s3
    80002a90:	69a6                	ld	s3,72(sp)
}
    80002a92:	70a6                	ld	ra,104(sp)
    80002a94:	7406                	ld	s0,96(sp)
    80002a96:	6946                	ld	s2,80(sp)
    80002a98:	6a06                	ld	s4,64(sp)
    80002a9a:	7ae2                	ld	s5,56(sp)
    80002a9c:	7b42                	ld	s6,48(sp)
    80002a9e:	7ba2                	ld	s7,40(sp)
    80002aa0:	6165                	addi	sp,sp,112
    80002aa2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002aa4:	89da                	mv	s3,s6
    80002aa6:	b7cd                	j	80002a88 <writei+0xcc>
    80002aa8:	64e6                	ld	s1,88(sp)
    80002aaa:	7c02                	ld	s8,32(sp)
    80002aac:	6ce2                	ld	s9,24(sp)
    80002aae:	6d42                	ld	s10,16(sp)
    80002ab0:	6da2                	ld	s11,8(sp)
    80002ab2:	bfd9                	j	80002a88 <writei+0xcc>
    return -1;
    80002ab4:	557d                	li	a0,-1
}
    80002ab6:	8082                	ret
    return -1;
    80002ab8:	557d                	li	a0,-1
    80002aba:	bfe1                	j	80002a92 <writei+0xd6>
    return -1;
    80002abc:	557d                	li	a0,-1
    80002abe:	bfd1                	j	80002a92 <writei+0xd6>

0000000080002ac0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002ac0:	1141                	addi	sp,sp,-16
    80002ac2:	e406                	sd	ra,8(sp)
    80002ac4:	e022                	sd	s0,0(sp)
    80002ac6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002ac8:	4639                	li	a2,14
    80002aca:	f5cfd0ef          	jal	80000226 <strncmp>
}
    80002ace:	60a2                	ld	ra,8(sp)
    80002ad0:	6402                	ld	s0,0(sp)
    80002ad2:	0141                	addi	sp,sp,16
    80002ad4:	8082                	ret

0000000080002ad6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ad6:	711d                	addi	sp,sp,-96
    80002ad8:	ec86                	sd	ra,88(sp)
    80002ada:	e8a2                	sd	s0,80(sp)
    80002adc:	e4a6                	sd	s1,72(sp)
    80002ade:	e0ca                	sd	s2,64(sp)
    80002ae0:	fc4e                	sd	s3,56(sp)
    80002ae2:	f852                	sd	s4,48(sp)
    80002ae4:	f456                	sd	s5,40(sp)
    80002ae6:	f05a                	sd	s6,32(sp)
    80002ae8:	ec5e                	sd	s7,24(sp)
    80002aea:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002aec:	04451703          	lh	a4,68(a0)
    80002af0:	4785                	li	a5,1
    80002af2:	00f71f63          	bne	a4,a5,80002b10 <dirlookup+0x3a>
    80002af6:	892a                	mv	s2,a0
    80002af8:	8aae                	mv	s5,a1
    80002afa:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002afc:	457c                	lw	a5,76(a0)
    80002afe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002b00:	fa040a13          	addi	s4,s0,-96
    80002b04:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002b06:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002b0a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b0c:	e39d                	bnez	a5,80002b32 <dirlookup+0x5c>
    80002b0e:	a8b9                	j	80002b6c <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002b10:	00005517          	auipc	a0,0x5
    80002b14:	a7050513          	addi	a0,a0,-1424 # 80007580 <etext+0x580>
    80002b18:	13f020ef          	jal	80005456 <panic>
      panic("dirlookup read");
    80002b1c:	00005517          	auipc	a0,0x5
    80002b20:	a7c50513          	addi	a0,a0,-1412 # 80007598 <etext+0x598>
    80002b24:	133020ef          	jal	80005456 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b28:	24c1                	addiw	s1,s1,16
    80002b2a:	04c92783          	lw	a5,76(s2)
    80002b2e:	02f4fe63          	bgeu	s1,a5,80002b6a <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002b32:	874e                	mv	a4,s3
    80002b34:	86a6                	mv	a3,s1
    80002b36:	8652                	mv	a2,s4
    80002b38:	4581                	li	a1,0
    80002b3a:	854a                	mv	a0,s2
    80002b3c:	d8fff0ef          	jal	800028ca <readi>
    80002b40:	fd351ee3          	bne	a0,s3,80002b1c <dirlookup+0x46>
    if(de.inum == 0)
    80002b44:	fa045783          	lhu	a5,-96(s0)
    80002b48:	d3e5                	beqz	a5,80002b28 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002b4a:	85da                	mv	a1,s6
    80002b4c:	8556                	mv	a0,s5
    80002b4e:	f73ff0ef          	jal	80002ac0 <namecmp>
    80002b52:	f979                	bnez	a0,80002b28 <dirlookup+0x52>
      if(poff)
    80002b54:	000b8463          	beqz	s7,80002b5c <dirlookup+0x86>
        *poff = off;
    80002b58:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002b5c:	fa045583          	lhu	a1,-96(s0)
    80002b60:	00092503          	lw	a0,0(s2)
    80002b64:	82fff0ef          	jal	80002392 <iget>
    80002b68:	a011                	j	80002b6c <dirlookup+0x96>
  return 0;
    80002b6a:	4501                	li	a0,0
}
    80002b6c:	60e6                	ld	ra,88(sp)
    80002b6e:	6446                	ld	s0,80(sp)
    80002b70:	64a6                	ld	s1,72(sp)
    80002b72:	6906                	ld	s2,64(sp)
    80002b74:	79e2                	ld	s3,56(sp)
    80002b76:	7a42                	ld	s4,48(sp)
    80002b78:	7aa2                	ld	s5,40(sp)
    80002b7a:	7b02                	ld	s6,32(sp)
    80002b7c:	6be2                	ld	s7,24(sp)
    80002b7e:	6125                	addi	sp,sp,96
    80002b80:	8082                	ret

0000000080002b82 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b82:	711d                	addi	sp,sp,-96
    80002b84:	ec86                	sd	ra,88(sp)
    80002b86:	e8a2                	sd	s0,80(sp)
    80002b88:	e4a6                	sd	s1,72(sp)
    80002b8a:	e0ca                	sd	s2,64(sp)
    80002b8c:	fc4e                	sd	s3,56(sp)
    80002b8e:	f852                	sd	s4,48(sp)
    80002b90:	f456                	sd	s5,40(sp)
    80002b92:	f05a                	sd	s6,32(sp)
    80002b94:	ec5e                	sd	s7,24(sp)
    80002b96:	e862                	sd	s8,16(sp)
    80002b98:	e466                	sd	s9,8(sp)
    80002b9a:	e06a                	sd	s10,0(sp)
    80002b9c:	1080                	addi	s0,sp,96
    80002b9e:	84aa                	mv	s1,a0
    80002ba0:	8b2e                	mv	s6,a1
    80002ba2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002ba4:	00054703          	lbu	a4,0(a0)
    80002ba8:	02f00793          	li	a5,47
    80002bac:	00f70f63          	beq	a4,a5,80002bca <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002bb0:	9acfe0ef          	jal	80000d5c <myproc>
    80002bb4:	15053503          	ld	a0,336(a0)
    80002bb8:	a85ff0ef          	jal	8000263c <idup>
    80002bbc:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002bbe:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002bc2:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002bc4:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002bc6:	4b85                	li	s7,1
    80002bc8:	a879                	j	80002c66 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002bca:	4585                	li	a1,1
    80002bcc:	852e                	mv	a0,a1
    80002bce:	fc4ff0ef          	jal	80002392 <iget>
    80002bd2:	8a2a                	mv	s4,a0
    80002bd4:	b7ed                	j	80002bbe <namex+0x3c>
      iunlockput(ip);
    80002bd6:	8552                	mv	a0,s4
    80002bd8:	ca5ff0ef          	jal	8000287c <iunlockput>
      return 0;
    80002bdc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002bde:	8552                	mv	a0,s4
    80002be0:	60e6                	ld	ra,88(sp)
    80002be2:	6446                	ld	s0,80(sp)
    80002be4:	64a6                	ld	s1,72(sp)
    80002be6:	6906                	ld	s2,64(sp)
    80002be8:	79e2                	ld	s3,56(sp)
    80002bea:	7a42                	ld	s4,48(sp)
    80002bec:	7aa2                	ld	s5,40(sp)
    80002bee:	7b02                	ld	s6,32(sp)
    80002bf0:	6be2                	ld	s7,24(sp)
    80002bf2:	6c42                	ld	s8,16(sp)
    80002bf4:	6ca2                	ld	s9,8(sp)
    80002bf6:	6d02                	ld	s10,0(sp)
    80002bf8:	6125                	addi	sp,sp,96
    80002bfa:	8082                	ret
      iunlock(ip);
    80002bfc:	8552                	mv	a0,s4
    80002bfe:	b23ff0ef          	jal	80002720 <iunlock>
      return ip;
    80002c02:	bff1                	j	80002bde <namex+0x5c>
      iunlockput(ip);
    80002c04:	8552                	mv	a0,s4
    80002c06:	c77ff0ef          	jal	8000287c <iunlockput>
      return 0;
    80002c0a:	8a4e                	mv	s4,s3
    80002c0c:	bfc9                	j	80002bde <namex+0x5c>
  len = path - s;
    80002c0e:	40998633          	sub	a2,s3,s1
    80002c12:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002c16:	09ac5063          	bge	s8,s10,80002c96 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002c1a:	8666                	mv	a2,s9
    80002c1c:	85a6                	mv	a1,s1
    80002c1e:	8556                	mv	a0,s5
    80002c20:	d92fd0ef          	jal	800001b2 <memmove>
    80002c24:	84ce                	mv	s1,s3
  while(*path == '/')
    80002c26:	0004c783          	lbu	a5,0(s1)
    80002c2a:	01279763          	bne	a5,s2,80002c38 <namex+0xb6>
    path++;
    80002c2e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c30:	0004c783          	lbu	a5,0(s1)
    80002c34:	ff278de3          	beq	a5,s2,80002c2e <namex+0xac>
    ilock(ip);
    80002c38:	8552                	mv	a0,s4
    80002c3a:	a39ff0ef          	jal	80002672 <ilock>
    if(ip->type != T_DIR){
    80002c3e:	044a1783          	lh	a5,68(s4)
    80002c42:	f9779ae3          	bne	a5,s7,80002bd6 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002c46:	000b0563          	beqz	s6,80002c50 <namex+0xce>
    80002c4a:	0004c783          	lbu	a5,0(s1)
    80002c4e:	d7dd                	beqz	a5,80002bfc <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002c50:	4601                	li	a2,0
    80002c52:	85d6                	mv	a1,s5
    80002c54:	8552                	mv	a0,s4
    80002c56:	e81ff0ef          	jal	80002ad6 <dirlookup>
    80002c5a:	89aa                	mv	s3,a0
    80002c5c:	d545                	beqz	a0,80002c04 <namex+0x82>
    iunlockput(ip);
    80002c5e:	8552                	mv	a0,s4
    80002c60:	c1dff0ef          	jal	8000287c <iunlockput>
    ip = next;
    80002c64:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002c66:	0004c783          	lbu	a5,0(s1)
    80002c6a:	01279763          	bne	a5,s2,80002c78 <namex+0xf6>
    path++;
    80002c6e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c70:	0004c783          	lbu	a5,0(s1)
    80002c74:	ff278de3          	beq	a5,s2,80002c6e <namex+0xec>
  if(*path == 0)
    80002c78:	cb8d                	beqz	a5,80002caa <namex+0x128>
  while(*path != '/' && *path != 0)
    80002c7a:	0004c783          	lbu	a5,0(s1)
    80002c7e:	89a6                	mv	s3,s1
  len = path - s;
    80002c80:	4d01                	li	s10,0
    80002c82:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002c84:	01278963          	beq	a5,s2,80002c96 <namex+0x114>
    80002c88:	d3d9                	beqz	a5,80002c0e <namex+0x8c>
    path++;
    80002c8a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c8c:	0009c783          	lbu	a5,0(s3)
    80002c90:	ff279ce3          	bne	a5,s2,80002c88 <namex+0x106>
    80002c94:	bfad                	j	80002c0e <namex+0x8c>
    memmove(name, s, len);
    80002c96:	2601                	sext.w	a2,a2
    80002c98:	85a6                	mv	a1,s1
    80002c9a:	8556                	mv	a0,s5
    80002c9c:	d16fd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002ca0:	9d56                	add	s10,s10,s5
    80002ca2:	000d0023          	sb	zero,0(s10)
    80002ca6:	84ce                	mv	s1,s3
    80002ca8:	bfbd                	j	80002c26 <namex+0xa4>
  if(nameiparent){
    80002caa:	f20b0ae3          	beqz	s6,80002bde <namex+0x5c>
    iput(ip);
    80002cae:	8552                	mv	a0,s4
    80002cb0:	b45ff0ef          	jal	800027f4 <iput>
    return 0;
    80002cb4:	4a01                	li	s4,0
    80002cb6:	b725                	j	80002bde <namex+0x5c>

0000000080002cb8 <dirlink>:
{
    80002cb8:	715d                	addi	sp,sp,-80
    80002cba:	e486                	sd	ra,72(sp)
    80002cbc:	e0a2                	sd	s0,64(sp)
    80002cbe:	f84a                	sd	s2,48(sp)
    80002cc0:	ec56                	sd	s5,24(sp)
    80002cc2:	e85a                	sd	s6,16(sp)
    80002cc4:	0880                	addi	s0,sp,80
    80002cc6:	892a                	mv	s2,a0
    80002cc8:	8aae                	mv	s5,a1
    80002cca:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002ccc:	4601                	li	a2,0
    80002cce:	e09ff0ef          	jal	80002ad6 <dirlookup>
    80002cd2:	ed1d                	bnez	a0,80002d10 <dirlink+0x58>
    80002cd4:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cd6:	04c92483          	lw	s1,76(s2)
    80002cda:	c4b9                	beqz	s1,80002d28 <dirlink+0x70>
    80002cdc:	f44e                	sd	s3,40(sp)
    80002cde:	f052                	sd	s4,32(sp)
    80002ce0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ce2:	fb040a13          	addi	s4,s0,-80
    80002ce6:	49c1                	li	s3,16
    80002ce8:	874e                	mv	a4,s3
    80002cea:	86a6                	mv	a3,s1
    80002cec:	8652                	mv	a2,s4
    80002cee:	4581                	li	a1,0
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	bd9ff0ef          	jal	800028ca <readi>
    80002cf6:	03351163          	bne	a0,s3,80002d18 <dirlink+0x60>
    if(de.inum == 0)
    80002cfa:	fb045783          	lhu	a5,-80(s0)
    80002cfe:	c39d                	beqz	a5,80002d24 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d00:	24c1                	addiw	s1,s1,16
    80002d02:	04c92783          	lw	a5,76(s2)
    80002d06:	fef4e1e3          	bltu	s1,a5,80002ce8 <dirlink+0x30>
    80002d0a:	79a2                	ld	s3,40(sp)
    80002d0c:	7a02                	ld	s4,32(sp)
    80002d0e:	a829                	j	80002d28 <dirlink+0x70>
    iput(ip);
    80002d10:	ae5ff0ef          	jal	800027f4 <iput>
    return -1;
    80002d14:	557d                	li	a0,-1
    80002d16:	a83d                	j	80002d54 <dirlink+0x9c>
      panic("dirlink read");
    80002d18:	00005517          	auipc	a0,0x5
    80002d1c:	89050513          	addi	a0,a0,-1904 # 800075a8 <etext+0x5a8>
    80002d20:	736020ef          	jal	80005456 <panic>
    80002d24:	79a2                	ld	s3,40(sp)
    80002d26:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002d28:	4639                	li	a2,14
    80002d2a:	85d6                	mv	a1,s5
    80002d2c:	fb240513          	addi	a0,s0,-78
    80002d30:	d30fd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002d34:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d38:	4741                	li	a4,16
    80002d3a:	86a6                	mv	a3,s1
    80002d3c:	fb040613          	addi	a2,s0,-80
    80002d40:	4581                	li	a1,0
    80002d42:	854a                	mv	a0,s2
    80002d44:	c79ff0ef          	jal	800029bc <writei>
    80002d48:	1541                	addi	a0,a0,-16
    80002d4a:	00a03533          	snez	a0,a0
    80002d4e:	40a0053b          	negw	a0,a0
    80002d52:	74e2                	ld	s1,56(sp)
}
    80002d54:	60a6                	ld	ra,72(sp)
    80002d56:	6406                	ld	s0,64(sp)
    80002d58:	7942                	ld	s2,48(sp)
    80002d5a:	6ae2                	ld	s5,24(sp)
    80002d5c:	6b42                	ld	s6,16(sp)
    80002d5e:	6161                	addi	sp,sp,80
    80002d60:	8082                	ret

0000000080002d62 <namei>:

struct inode*
namei(char *path)
{
    80002d62:	1101                	addi	sp,sp,-32
    80002d64:	ec06                	sd	ra,24(sp)
    80002d66:	e822                	sd	s0,16(sp)
    80002d68:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002d6a:	fe040613          	addi	a2,s0,-32
    80002d6e:	4581                	li	a1,0
    80002d70:	e13ff0ef          	jal	80002b82 <namex>
}
    80002d74:	60e2                	ld	ra,24(sp)
    80002d76:	6442                	ld	s0,16(sp)
    80002d78:	6105                	addi	sp,sp,32
    80002d7a:	8082                	ret

0000000080002d7c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d7c:	1141                	addi	sp,sp,-16
    80002d7e:	e406                	sd	ra,8(sp)
    80002d80:	e022                	sd	s0,0(sp)
    80002d82:	0800                	addi	s0,sp,16
    80002d84:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d86:	4585                	li	a1,1
    80002d88:	dfbff0ef          	jal	80002b82 <namex>
}
    80002d8c:	60a2                	ld	ra,8(sp)
    80002d8e:	6402                	ld	s0,0(sp)
    80002d90:	0141                	addi	sp,sp,16
    80002d92:	8082                	ret

0000000080002d94 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d94:	1101                	addi	sp,sp,-32
    80002d96:	ec06                	sd	ra,24(sp)
    80002d98:	e822                	sd	s0,16(sp)
    80002d9a:	e426                	sd	s1,8(sp)
    80002d9c:	e04a                	sd	s2,0(sp)
    80002d9e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002da0:	00018917          	auipc	s2,0x18
    80002da4:	8a090913          	addi	s2,s2,-1888 # 8001a640 <log>
    80002da8:	01892583          	lw	a1,24(s2)
    80002dac:	02892503          	lw	a0,40(s2)
    80002db0:	9b0ff0ef          	jal	80001f60 <bread>
    80002db4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002db6:	02c92603          	lw	a2,44(s2)
    80002dba:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002dbc:	00c05f63          	blez	a2,80002dda <write_head+0x46>
    80002dc0:	00018717          	auipc	a4,0x18
    80002dc4:	8b070713          	addi	a4,a4,-1872 # 8001a670 <log+0x30>
    80002dc8:	87aa                	mv	a5,a0
    80002dca:	060a                	slli	a2,a2,0x2
    80002dcc:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002dce:	4314                	lw	a3,0(a4)
    80002dd0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002dd2:	0711                	addi	a4,a4,4
    80002dd4:	0791                	addi	a5,a5,4
    80002dd6:	fec79ce3          	bne	a5,a2,80002dce <write_head+0x3a>
  }
  bwrite(buf);
    80002dda:	8526                	mv	a0,s1
    80002ddc:	a5aff0ef          	jal	80002036 <bwrite>
  brelse(buf);
    80002de0:	8526                	mv	a0,s1
    80002de2:	a86ff0ef          	jal	80002068 <brelse>
}
    80002de6:	60e2                	ld	ra,24(sp)
    80002de8:	6442                	ld	s0,16(sp)
    80002dea:	64a2                	ld	s1,8(sp)
    80002dec:	6902                	ld	s2,0(sp)
    80002dee:	6105                	addi	sp,sp,32
    80002df0:	8082                	ret

0000000080002df2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002df2:	00018797          	auipc	a5,0x18
    80002df6:	87a7a783          	lw	a5,-1926(a5) # 8001a66c <log+0x2c>
    80002dfa:	0af05263          	blez	a5,80002e9e <install_trans+0xac>
{
    80002dfe:	715d                	addi	sp,sp,-80
    80002e00:	e486                	sd	ra,72(sp)
    80002e02:	e0a2                	sd	s0,64(sp)
    80002e04:	fc26                	sd	s1,56(sp)
    80002e06:	f84a                	sd	s2,48(sp)
    80002e08:	f44e                	sd	s3,40(sp)
    80002e0a:	f052                	sd	s4,32(sp)
    80002e0c:	ec56                	sd	s5,24(sp)
    80002e0e:	e85a                	sd	s6,16(sp)
    80002e10:	e45e                	sd	s7,8(sp)
    80002e12:	0880                	addi	s0,sp,80
    80002e14:	8b2a                	mv	s6,a0
    80002e16:	00018a97          	auipc	s5,0x18
    80002e1a:	85aa8a93          	addi	s5,s5,-1958 # 8001a670 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e1e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002e20:	00018997          	auipc	s3,0x18
    80002e24:	82098993          	addi	s3,s3,-2016 # 8001a640 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002e28:	40000b93          	li	s7,1024
    80002e2c:	a829                	j	80002e46 <install_trans+0x54>
    brelse(lbuf);
    80002e2e:	854a                	mv	a0,s2
    80002e30:	a38ff0ef          	jal	80002068 <brelse>
    brelse(dbuf);
    80002e34:	8526                	mv	a0,s1
    80002e36:	a32ff0ef          	jal	80002068 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e3a:	2a05                	addiw	s4,s4,1
    80002e3c:	0a91                	addi	s5,s5,4
    80002e3e:	02c9a783          	lw	a5,44(s3)
    80002e42:	04fa5363          	bge	s4,a5,80002e88 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002e46:	0189a583          	lw	a1,24(s3)
    80002e4a:	014585bb          	addw	a1,a1,s4
    80002e4e:	2585                	addiw	a1,a1,1
    80002e50:	0289a503          	lw	a0,40(s3)
    80002e54:	90cff0ef          	jal	80001f60 <bread>
    80002e58:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002e5a:	000aa583          	lw	a1,0(s5)
    80002e5e:	0289a503          	lw	a0,40(s3)
    80002e62:	8feff0ef          	jal	80001f60 <bread>
    80002e66:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002e68:	865e                	mv	a2,s7
    80002e6a:	05890593          	addi	a1,s2,88
    80002e6e:	05850513          	addi	a0,a0,88
    80002e72:	b40fd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002e76:	8526                	mv	a0,s1
    80002e78:	9beff0ef          	jal	80002036 <bwrite>
    if(recovering == 0)
    80002e7c:	fa0b19e3          	bnez	s6,80002e2e <install_trans+0x3c>
      bunpin(dbuf);
    80002e80:	8526                	mv	a0,s1
    80002e82:	a9eff0ef          	jal	80002120 <bunpin>
    80002e86:	b765                	j	80002e2e <install_trans+0x3c>
}
    80002e88:	60a6                	ld	ra,72(sp)
    80002e8a:	6406                	ld	s0,64(sp)
    80002e8c:	74e2                	ld	s1,56(sp)
    80002e8e:	7942                	ld	s2,48(sp)
    80002e90:	79a2                	ld	s3,40(sp)
    80002e92:	7a02                	ld	s4,32(sp)
    80002e94:	6ae2                	ld	s5,24(sp)
    80002e96:	6b42                	ld	s6,16(sp)
    80002e98:	6ba2                	ld	s7,8(sp)
    80002e9a:	6161                	addi	sp,sp,80
    80002e9c:	8082                	ret
    80002e9e:	8082                	ret

0000000080002ea0 <initlog>:
{
    80002ea0:	7179                	addi	sp,sp,-48
    80002ea2:	f406                	sd	ra,40(sp)
    80002ea4:	f022                	sd	s0,32(sp)
    80002ea6:	ec26                	sd	s1,24(sp)
    80002ea8:	e84a                	sd	s2,16(sp)
    80002eaa:	e44e                	sd	s3,8(sp)
    80002eac:	1800                	addi	s0,sp,48
    80002eae:	892a                	mv	s2,a0
    80002eb0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002eb2:	00017497          	auipc	s1,0x17
    80002eb6:	78e48493          	addi	s1,s1,1934 # 8001a640 <log>
    80002eba:	00004597          	auipc	a1,0x4
    80002ebe:	6fe58593          	addi	a1,a1,1790 # 800075b8 <etext+0x5b8>
    80002ec2:	8526                	mv	a0,s1
    80002ec4:	03d020ef          	jal	80005700 <initlock>
  log.start = sb->logstart;
    80002ec8:	0149a583          	lw	a1,20(s3)
    80002ecc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002ece:	0109a783          	lw	a5,16(s3)
    80002ed2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002ed4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002ed8:	854a                	mv	a0,s2
    80002eda:	886ff0ef          	jal	80001f60 <bread>
  log.lh.n = lh->n;
    80002ede:	4d30                	lw	a2,88(a0)
    80002ee0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002ee2:	00c05f63          	blez	a2,80002f00 <initlog+0x60>
    80002ee6:	87aa                	mv	a5,a0
    80002ee8:	00017717          	auipc	a4,0x17
    80002eec:	78870713          	addi	a4,a4,1928 # 8001a670 <log+0x30>
    80002ef0:	060a                	slli	a2,a2,0x2
    80002ef2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002ef4:	4ff4                	lw	a3,92(a5)
    80002ef6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002ef8:	0791                	addi	a5,a5,4
    80002efa:	0711                	addi	a4,a4,4
    80002efc:	fec79ce3          	bne	a5,a2,80002ef4 <initlog+0x54>
  brelse(buf);
    80002f00:	968ff0ef          	jal	80002068 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002f04:	4505                	li	a0,1
    80002f06:	eedff0ef          	jal	80002df2 <install_trans>
  log.lh.n = 0;
    80002f0a:	00017797          	auipc	a5,0x17
    80002f0e:	7607a123          	sw	zero,1890(a5) # 8001a66c <log+0x2c>
  write_head(); // clear the log
    80002f12:	e83ff0ef          	jal	80002d94 <write_head>
}
    80002f16:	70a2                	ld	ra,40(sp)
    80002f18:	7402                	ld	s0,32(sp)
    80002f1a:	64e2                	ld	s1,24(sp)
    80002f1c:	6942                	ld	s2,16(sp)
    80002f1e:	69a2                	ld	s3,8(sp)
    80002f20:	6145                	addi	sp,sp,48
    80002f22:	8082                	ret

0000000080002f24 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002f24:	1101                	addi	sp,sp,-32
    80002f26:	ec06                	sd	ra,24(sp)
    80002f28:	e822                	sd	s0,16(sp)
    80002f2a:	e426                	sd	s1,8(sp)
    80002f2c:	e04a                	sd	s2,0(sp)
    80002f2e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002f30:	00017517          	auipc	a0,0x17
    80002f34:	71050513          	addi	a0,a0,1808 # 8001a640 <log>
    80002f38:	04d020ef          	jal	80005784 <acquire>
  while(1){
    if(log.committing){
    80002f3c:	00017497          	auipc	s1,0x17
    80002f40:	70448493          	addi	s1,s1,1796 # 8001a640 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002f44:	4979                	li	s2,30
    80002f46:	a029                	j	80002f50 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002f48:	85a6                	mv	a1,s1
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	beafe0ef          	jal	80001336 <sleep>
    if(log.committing){
    80002f50:	50dc                	lw	a5,36(s1)
    80002f52:	fbfd                	bnez	a5,80002f48 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002f54:	5098                	lw	a4,32(s1)
    80002f56:	2705                	addiw	a4,a4,1
    80002f58:	0027179b          	slliw	a5,a4,0x2
    80002f5c:	9fb9                	addw	a5,a5,a4
    80002f5e:	0017979b          	slliw	a5,a5,0x1
    80002f62:	54d4                	lw	a3,44(s1)
    80002f64:	9fb5                	addw	a5,a5,a3
    80002f66:	00f95763          	bge	s2,a5,80002f74 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002f6a:	85a6                	mv	a1,s1
    80002f6c:	8526                	mv	a0,s1
    80002f6e:	bc8fe0ef          	jal	80001336 <sleep>
    80002f72:	bff9                	j	80002f50 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002f74:	00017517          	auipc	a0,0x17
    80002f78:	6cc50513          	addi	a0,a0,1740 # 8001a640 <log>
    80002f7c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002f7e:	09b020ef          	jal	80005818 <release>
      break;
    }
  }
}
    80002f82:	60e2                	ld	ra,24(sp)
    80002f84:	6442                	ld	s0,16(sp)
    80002f86:	64a2                	ld	s1,8(sp)
    80002f88:	6902                	ld	s2,0(sp)
    80002f8a:	6105                	addi	sp,sp,32
    80002f8c:	8082                	ret

0000000080002f8e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f8e:	7139                	addi	sp,sp,-64
    80002f90:	fc06                	sd	ra,56(sp)
    80002f92:	f822                	sd	s0,48(sp)
    80002f94:	f426                	sd	s1,40(sp)
    80002f96:	f04a                	sd	s2,32(sp)
    80002f98:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f9a:	00017497          	auipc	s1,0x17
    80002f9e:	6a648493          	addi	s1,s1,1702 # 8001a640 <log>
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	7e0020ef          	jal	80005784 <acquire>
  log.outstanding -= 1;
    80002fa8:	509c                	lw	a5,32(s1)
    80002faa:	37fd                	addiw	a5,a5,-1
    80002fac:	893e                	mv	s2,a5
    80002fae:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002fb0:	50dc                	lw	a5,36(s1)
    80002fb2:	ef9d                	bnez	a5,80002ff0 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80002fb4:	04091863          	bnez	s2,80003004 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002fb8:	00017497          	auipc	s1,0x17
    80002fbc:	68848493          	addi	s1,s1,1672 # 8001a640 <log>
    80002fc0:	4785                	li	a5,1
    80002fc2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002fc4:	8526                	mv	a0,s1
    80002fc6:	053020ef          	jal	80005818 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002fca:	54dc                	lw	a5,44(s1)
    80002fcc:	04f04c63          	bgtz	a5,80003024 <end_op+0x96>
    acquire(&log.lock);
    80002fd0:	00017497          	auipc	s1,0x17
    80002fd4:	67048493          	addi	s1,s1,1648 # 8001a640 <log>
    80002fd8:	8526                	mv	a0,s1
    80002fda:	7aa020ef          	jal	80005784 <acquire>
    log.committing = 0;
    80002fde:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	b9efe0ef          	jal	80001382 <wakeup>
    release(&log.lock);
    80002fe8:	8526                	mv	a0,s1
    80002fea:	02f020ef          	jal	80005818 <release>
}
    80002fee:	a02d                	j	80003018 <end_op+0x8a>
    80002ff0:	ec4e                	sd	s3,24(sp)
    80002ff2:	e852                	sd	s4,16(sp)
    80002ff4:	e456                	sd	s5,8(sp)
    80002ff6:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80002ff8:	00004517          	auipc	a0,0x4
    80002ffc:	5c850513          	addi	a0,a0,1480 # 800075c0 <etext+0x5c0>
    80003000:	456020ef          	jal	80005456 <panic>
    wakeup(&log);
    80003004:	00017497          	auipc	s1,0x17
    80003008:	63c48493          	addi	s1,s1,1596 # 8001a640 <log>
    8000300c:	8526                	mv	a0,s1
    8000300e:	b74fe0ef          	jal	80001382 <wakeup>
  release(&log.lock);
    80003012:	8526                	mv	a0,s1
    80003014:	005020ef          	jal	80005818 <release>
}
    80003018:	70e2                	ld	ra,56(sp)
    8000301a:	7442                	ld	s0,48(sp)
    8000301c:	74a2                	ld	s1,40(sp)
    8000301e:	7902                	ld	s2,32(sp)
    80003020:	6121                	addi	sp,sp,64
    80003022:	8082                	ret
    80003024:	ec4e                	sd	s3,24(sp)
    80003026:	e852                	sd	s4,16(sp)
    80003028:	e456                	sd	s5,8(sp)
    8000302a:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000302c:	00017a97          	auipc	s5,0x17
    80003030:	644a8a93          	addi	s5,s5,1604 # 8001a670 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003034:	00017a17          	auipc	s4,0x17
    80003038:	60ca0a13          	addi	s4,s4,1548 # 8001a640 <log>
    memmove(to->data, from->data, BSIZE);
    8000303c:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003040:	018a2583          	lw	a1,24(s4)
    80003044:	012585bb          	addw	a1,a1,s2
    80003048:	2585                	addiw	a1,a1,1
    8000304a:	028a2503          	lw	a0,40(s4)
    8000304e:	f13fe0ef          	jal	80001f60 <bread>
    80003052:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003054:	000aa583          	lw	a1,0(s5)
    80003058:	028a2503          	lw	a0,40(s4)
    8000305c:	f05fe0ef          	jal	80001f60 <bread>
    80003060:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003062:	865a                	mv	a2,s6
    80003064:	05850593          	addi	a1,a0,88
    80003068:	05848513          	addi	a0,s1,88
    8000306c:	946fd0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    80003070:	8526                	mv	a0,s1
    80003072:	fc5fe0ef          	jal	80002036 <bwrite>
    brelse(from);
    80003076:	854e                	mv	a0,s3
    80003078:	ff1fe0ef          	jal	80002068 <brelse>
    brelse(to);
    8000307c:	8526                	mv	a0,s1
    8000307e:	febfe0ef          	jal	80002068 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003082:	2905                	addiw	s2,s2,1
    80003084:	0a91                	addi	s5,s5,4
    80003086:	02ca2783          	lw	a5,44(s4)
    8000308a:	faf94be3          	blt	s2,a5,80003040 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000308e:	d07ff0ef          	jal	80002d94 <write_head>
    install_trans(0); // Now install writes to home locations
    80003092:	4501                	li	a0,0
    80003094:	d5fff0ef          	jal	80002df2 <install_trans>
    log.lh.n = 0;
    80003098:	00017797          	auipc	a5,0x17
    8000309c:	5c07aa23          	sw	zero,1492(a5) # 8001a66c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800030a0:	cf5ff0ef          	jal	80002d94 <write_head>
    800030a4:	69e2                	ld	s3,24(sp)
    800030a6:	6a42                	ld	s4,16(sp)
    800030a8:	6aa2                	ld	s5,8(sp)
    800030aa:	6b02                	ld	s6,0(sp)
    800030ac:	b715                	j	80002fd0 <end_op+0x42>

00000000800030ae <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800030ae:	1101                	addi	sp,sp,-32
    800030b0:	ec06                	sd	ra,24(sp)
    800030b2:	e822                	sd	s0,16(sp)
    800030b4:	e426                	sd	s1,8(sp)
    800030b6:	e04a                	sd	s2,0(sp)
    800030b8:	1000                	addi	s0,sp,32
    800030ba:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800030bc:	00017917          	auipc	s2,0x17
    800030c0:	58490913          	addi	s2,s2,1412 # 8001a640 <log>
    800030c4:	854a                	mv	a0,s2
    800030c6:	6be020ef          	jal	80005784 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800030ca:	02c92603          	lw	a2,44(s2)
    800030ce:	47f5                	li	a5,29
    800030d0:	06c7c363          	blt	a5,a2,80003136 <log_write+0x88>
    800030d4:	00017797          	auipc	a5,0x17
    800030d8:	5887a783          	lw	a5,1416(a5) # 8001a65c <log+0x1c>
    800030dc:	37fd                	addiw	a5,a5,-1
    800030de:	04f65c63          	bge	a2,a5,80003136 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800030e2:	00017797          	auipc	a5,0x17
    800030e6:	57e7a783          	lw	a5,1406(a5) # 8001a660 <log+0x20>
    800030ea:	04f05c63          	blez	a5,80003142 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800030ee:	4781                	li	a5,0
    800030f0:	04c05f63          	blez	a2,8000314e <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030f4:	44cc                	lw	a1,12(s1)
    800030f6:	00017717          	auipc	a4,0x17
    800030fa:	57a70713          	addi	a4,a4,1402 # 8001a670 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800030fe:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003100:	4314                	lw	a3,0(a4)
    80003102:	04b68663          	beq	a3,a1,8000314e <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003106:	2785                	addiw	a5,a5,1
    80003108:	0711                	addi	a4,a4,4
    8000310a:	fef61be3          	bne	a2,a5,80003100 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000310e:	0621                	addi	a2,a2,8
    80003110:	060a                	slli	a2,a2,0x2
    80003112:	00017797          	auipc	a5,0x17
    80003116:	52e78793          	addi	a5,a5,1326 # 8001a640 <log>
    8000311a:	97b2                	add	a5,a5,a2
    8000311c:	44d8                	lw	a4,12(s1)
    8000311e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003120:	8526                	mv	a0,s1
    80003122:	fcbfe0ef          	jal	800020ec <bpin>
    log.lh.n++;
    80003126:	00017717          	auipc	a4,0x17
    8000312a:	51a70713          	addi	a4,a4,1306 # 8001a640 <log>
    8000312e:	575c                	lw	a5,44(a4)
    80003130:	2785                	addiw	a5,a5,1
    80003132:	d75c                	sw	a5,44(a4)
    80003134:	a80d                	j	80003166 <log_write+0xb8>
    panic("too big a transaction");
    80003136:	00004517          	auipc	a0,0x4
    8000313a:	49a50513          	addi	a0,a0,1178 # 800075d0 <etext+0x5d0>
    8000313e:	318020ef          	jal	80005456 <panic>
    panic("log_write outside of trans");
    80003142:	00004517          	auipc	a0,0x4
    80003146:	4a650513          	addi	a0,a0,1190 # 800075e8 <etext+0x5e8>
    8000314a:	30c020ef          	jal	80005456 <panic>
  log.lh.block[i] = b->blockno;
    8000314e:	00878693          	addi	a3,a5,8
    80003152:	068a                	slli	a3,a3,0x2
    80003154:	00017717          	auipc	a4,0x17
    80003158:	4ec70713          	addi	a4,a4,1260 # 8001a640 <log>
    8000315c:	9736                	add	a4,a4,a3
    8000315e:	44d4                	lw	a3,12(s1)
    80003160:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003162:	faf60fe3          	beq	a2,a5,80003120 <log_write+0x72>
  }
  release(&log.lock);
    80003166:	00017517          	auipc	a0,0x17
    8000316a:	4da50513          	addi	a0,a0,1242 # 8001a640 <log>
    8000316e:	6aa020ef          	jal	80005818 <release>
}
    80003172:	60e2                	ld	ra,24(sp)
    80003174:	6442                	ld	s0,16(sp)
    80003176:	64a2                	ld	s1,8(sp)
    80003178:	6902                	ld	s2,0(sp)
    8000317a:	6105                	addi	sp,sp,32
    8000317c:	8082                	ret

000000008000317e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000317e:	1101                	addi	sp,sp,-32
    80003180:	ec06                	sd	ra,24(sp)
    80003182:	e822                	sd	s0,16(sp)
    80003184:	e426                	sd	s1,8(sp)
    80003186:	e04a                	sd	s2,0(sp)
    80003188:	1000                	addi	s0,sp,32
    8000318a:	84aa                	mv	s1,a0
    8000318c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000318e:	00004597          	auipc	a1,0x4
    80003192:	47a58593          	addi	a1,a1,1146 # 80007608 <etext+0x608>
    80003196:	0521                	addi	a0,a0,8
    80003198:	568020ef          	jal	80005700 <initlock>
  lk->name = name;
    8000319c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800031a0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031a4:	0204a423          	sw	zero,40(s1)
}
    800031a8:	60e2                	ld	ra,24(sp)
    800031aa:	6442                	ld	s0,16(sp)
    800031ac:	64a2                	ld	s1,8(sp)
    800031ae:	6902                	ld	s2,0(sp)
    800031b0:	6105                	addi	sp,sp,32
    800031b2:	8082                	ret

00000000800031b4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800031b4:	1101                	addi	sp,sp,-32
    800031b6:	ec06                	sd	ra,24(sp)
    800031b8:	e822                	sd	s0,16(sp)
    800031ba:	e426                	sd	s1,8(sp)
    800031bc:	e04a                	sd	s2,0(sp)
    800031be:	1000                	addi	s0,sp,32
    800031c0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800031c2:	00850913          	addi	s2,a0,8
    800031c6:	854a                	mv	a0,s2
    800031c8:	5bc020ef          	jal	80005784 <acquire>
  while (lk->locked) {
    800031cc:	409c                	lw	a5,0(s1)
    800031ce:	c799                	beqz	a5,800031dc <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800031d0:	85ca                	mv	a1,s2
    800031d2:	8526                	mv	a0,s1
    800031d4:	962fe0ef          	jal	80001336 <sleep>
  while (lk->locked) {
    800031d8:	409c                	lw	a5,0(s1)
    800031da:	fbfd                	bnez	a5,800031d0 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800031dc:	4785                	li	a5,1
    800031de:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800031e0:	b7dfd0ef          	jal	80000d5c <myproc>
    800031e4:	591c                	lw	a5,48(a0)
    800031e6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800031e8:	854a                	mv	a0,s2
    800031ea:	62e020ef          	jal	80005818 <release>
}
    800031ee:	60e2                	ld	ra,24(sp)
    800031f0:	6442                	ld	s0,16(sp)
    800031f2:	64a2                	ld	s1,8(sp)
    800031f4:	6902                	ld	s2,0(sp)
    800031f6:	6105                	addi	sp,sp,32
    800031f8:	8082                	ret

00000000800031fa <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800031fa:	1101                	addi	sp,sp,-32
    800031fc:	ec06                	sd	ra,24(sp)
    800031fe:	e822                	sd	s0,16(sp)
    80003200:	e426                	sd	s1,8(sp)
    80003202:	e04a                	sd	s2,0(sp)
    80003204:	1000                	addi	s0,sp,32
    80003206:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003208:	00850913          	addi	s2,a0,8
    8000320c:	854a                	mv	a0,s2
    8000320e:	576020ef          	jal	80005784 <acquire>
  lk->locked = 0;
    80003212:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003216:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000321a:	8526                	mv	a0,s1
    8000321c:	966fe0ef          	jal	80001382 <wakeup>
  release(&lk->lk);
    80003220:	854a                	mv	a0,s2
    80003222:	5f6020ef          	jal	80005818 <release>
}
    80003226:	60e2                	ld	ra,24(sp)
    80003228:	6442                	ld	s0,16(sp)
    8000322a:	64a2                	ld	s1,8(sp)
    8000322c:	6902                	ld	s2,0(sp)
    8000322e:	6105                	addi	sp,sp,32
    80003230:	8082                	ret

0000000080003232 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003232:	7179                	addi	sp,sp,-48
    80003234:	f406                	sd	ra,40(sp)
    80003236:	f022                	sd	s0,32(sp)
    80003238:	ec26                	sd	s1,24(sp)
    8000323a:	e84a                	sd	s2,16(sp)
    8000323c:	1800                	addi	s0,sp,48
    8000323e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003240:	00850913          	addi	s2,a0,8
    80003244:	854a                	mv	a0,s2
    80003246:	53e020ef          	jal	80005784 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000324a:	409c                	lw	a5,0(s1)
    8000324c:	ef81                	bnez	a5,80003264 <holdingsleep+0x32>
    8000324e:	4481                	li	s1,0
  release(&lk->lk);
    80003250:	854a                	mv	a0,s2
    80003252:	5c6020ef          	jal	80005818 <release>
  return r;
}
    80003256:	8526                	mv	a0,s1
    80003258:	70a2                	ld	ra,40(sp)
    8000325a:	7402                	ld	s0,32(sp)
    8000325c:	64e2                	ld	s1,24(sp)
    8000325e:	6942                	ld	s2,16(sp)
    80003260:	6145                	addi	sp,sp,48
    80003262:	8082                	ret
    80003264:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003266:	0284a983          	lw	s3,40(s1)
    8000326a:	af3fd0ef          	jal	80000d5c <myproc>
    8000326e:	5904                	lw	s1,48(a0)
    80003270:	413484b3          	sub	s1,s1,s3
    80003274:	0014b493          	seqz	s1,s1
    80003278:	69a2                	ld	s3,8(sp)
    8000327a:	bfd9                	j	80003250 <holdingsleep+0x1e>

000000008000327c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000327c:	1141                	addi	sp,sp,-16
    8000327e:	e406                	sd	ra,8(sp)
    80003280:	e022                	sd	s0,0(sp)
    80003282:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003284:	00004597          	auipc	a1,0x4
    80003288:	39458593          	addi	a1,a1,916 # 80007618 <etext+0x618>
    8000328c:	00017517          	auipc	a0,0x17
    80003290:	4fc50513          	addi	a0,a0,1276 # 8001a788 <ftable>
    80003294:	46c020ef          	jal	80005700 <initlock>
}
    80003298:	60a2                	ld	ra,8(sp)
    8000329a:	6402                	ld	s0,0(sp)
    8000329c:	0141                	addi	sp,sp,16
    8000329e:	8082                	ret

00000000800032a0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800032a0:	1101                	addi	sp,sp,-32
    800032a2:	ec06                	sd	ra,24(sp)
    800032a4:	e822                	sd	s0,16(sp)
    800032a6:	e426                	sd	s1,8(sp)
    800032a8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800032aa:	00017517          	auipc	a0,0x17
    800032ae:	4de50513          	addi	a0,a0,1246 # 8001a788 <ftable>
    800032b2:	4d2020ef          	jal	80005784 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800032b6:	00017497          	auipc	s1,0x17
    800032ba:	4ea48493          	addi	s1,s1,1258 # 8001a7a0 <ftable+0x18>
    800032be:	00018717          	auipc	a4,0x18
    800032c2:	48270713          	addi	a4,a4,1154 # 8001b740 <disk>
    if(f->ref == 0){
    800032c6:	40dc                	lw	a5,4(s1)
    800032c8:	cf89                	beqz	a5,800032e2 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800032ca:	02848493          	addi	s1,s1,40
    800032ce:	fee49ce3          	bne	s1,a4,800032c6 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800032d2:	00017517          	auipc	a0,0x17
    800032d6:	4b650513          	addi	a0,a0,1206 # 8001a788 <ftable>
    800032da:	53e020ef          	jal	80005818 <release>
  return 0;
    800032de:	4481                	li	s1,0
    800032e0:	a809                	j	800032f2 <filealloc+0x52>
      f->ref = 1;
    800032e2:	4785                	li	a5,1
    800032e4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800032e6:	00017517          	auipc	a0,0x17
    800032ea:	4a250513          	addi	a0,a0,1186 # 8001a788 <ftable>
    800032ee:	52a020ef          	jal	80005818 <release>
}
    800032f2:	8526                	mv	a0,s1
    800032f4:	60e2                	ld	ra,24(sp)
    800032f6:	6442                	ld	s0,16(sp)
    800032f8:	64a2                	ld	s1,8(sp)
    800032fa:	6105                	addi	sp,sp,32
    800032fc:	8082                	ret

00000000800032fe <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800032fe:	1101                	addi	sp,sp,-32
    80003300:	ec06                	sd	ra,24(sp)
    80003302:	e822                	sd	s0,16(sp)
    80003304:	e426                	sd	s1,8(sp)
    80003306:	1000                	addi	s0,sp,32
    80003308:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000330a:	00017517          	auipc	a0,0x17
    8000330e:	47e50513          	addi	a0,a0,1150 # 8001a788 <ftable>
    80003312:	472020ef          	jal	80005784 <acquire>
  if(f->ref < 1)
    80003316:	40dc                	lw	a5,4(s1)
    80003318:	02f05063          	blez	a5,80003338 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000331c:	2785                	addiw	a5,a5,1
    8000331e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003320:	00017517          	auipc	a0,0x17
    80003324:	46850513          	addi	a0,a0,1128 # 8001a788 <ftable>
    80003328:	4f0020ef          	jal	80005818 <release>
  return f;
}
    8000332c:	8526                	mv	a0,s1
    8000332e:	60e2                	ld	ra,24(sp)
    80003330:	6442                	ld	s0,16(sp)
    80003332:	64a2                	ld	s1,8(sp)
    80003334:	6105                	addi	sp,sp,32
    80003336:	8082                	ret
    panic("filedup");
    80003338:	00004517          	auipc	a0,0x4
    8000333c:	2e850513          	addi	a0,a0,744 # 80007620 <etext+0x620>
    80003340:	116020ef          	jal	80005456 <panic>

0000000080003344 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003344:	7139                	addi	sp,sp,-64
    80003346:	fc06                	sd	ra,56(sp)
    80003348:	f822                	sd	s0,48(sp)
    8000334a:	f426                	sd	s1,40(sp)
    8000334c:	0080                	addi	s0,sp,64
    8000334e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003350:	00017517          	auipc	a0,0x17
    80003354:	43850513          	addi	a0,a0,1080 # 8001a788 <ftable>
    80003358:	42c020ef          	jal	80005784 <acquire>
  if(f->ref < 1)
    8000335c:	40dc                	lw	a5,4(s1)
    8000335e:	04f05863          	blez	a5,800033ae <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80003362:	37fd                	addiw	a5,a5,-1
    80003364:	c0dc                	sw	a5,4(s1)
    80003366:	04f04e63          	bgtz	a5,800033c2 <fileclose+0x7e>
    8000336a:	f04a                	sd	s2,32(sp)
    8000336c:	ec4e                	sd	s3,24(sp)
    8000336e:	e852                	sd	s4,16(sp)
    80003370:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003372:	0004a903          	lw	s2,0(s1)
    80003376:	0094ca83          	lbu	s5,9(s1)
    8000337a:	0104ba03          	ld	s4,16(s1)
    8000337e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003382:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003386:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000338a:	00017517          	auipc	a0,0x17
    8000338e:	3fe50513          	addi	a0,a0,1022 # 8001a788 <ftable>
    80003392:	486020ef          	jal	80005818 <release>

  if(ff.type == FD_PIPE){
    80003396:	4785                	li	a5,1
    80003398:	04f90063          	beq	s2,a5,800033d8 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000339c:	3979                	addiw	s2,s2,-2
    8000339e:	4785                	li	a5,1
    800033a0:	0527f563          	bgeu	a5,s2,800033ea <fileclose+0xa6>
    800033a4:	7902                	ld	s2,32(sp)
    800033a6:	69e2                	ld	s3,24(sp)
    800033a8:	6a42                	ld	s4,16(sp)
    800033aa:	6aa2                	ld	s5,8(sp)
    800033ac:	a00d                	j	800033ce <fileclose+0x8a>
    800033ae:	f04a                	sd	s2,32(sp)
    800033b0:	ec4e                	sd	s3,24(sp)
    800033b2:	e852                	sd	s4,16(sp)
    800033b4:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800033b6:	00004517          	auipc	a0,0x4
    800033ba:	27250513          	addi	a0,a0,626 # 80007628 <etext+0x628>
    800033be:	098020ef          	jal	80005456 <panic>
    release(&ftable.lock);
    800033c2:	00017517          	auipc	a0,0x17
    800033c6:	3c650513          	addi	a0,a0,966 # 8001a788 <ftable>
    800033ca:	44e020ef          	jal	80005818 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800033ce:	70e2                	ld	ra,56(sp)
    800033d0:	7442                	ld	s0,48(sp)
    800033d2:	74a2                	ld	s1,40(sp)
    800033d4:	6121                	addi	sp,sp,64
    800033d6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800033d8:	85d6                	mv	a1,s5
    800033da:	8552                	mv	a0,s4
    800033dc:	340000ef          	jal	8000371c <pipeclose>
    800033e0:	7902                	ld	s2,32(sp)
    800033e2:	69e2                	ld	s3,24(sp)
    800033e4:	6a42                	ld	s4,16(sp)
    800033e6:	6aa2                	ld	s5,8(sp)
    800033e8:	b7dd                	j	800033ce <fileclose+0x8a>
    begin_op();
    800033ea:	b3bff0ef          	jal	80002f24 <begin_op>
    iput(ff.ip);
    800033ee:	854e                	mv	a0,s3
    800033f0:	c04ff0ef          	jal	800027f4 <iput>
    end_op();
    800033f4:	b9bff0ef          	jal	80002f8e <end_op>
    800033f8:	7902                	ld	s2,32(sp)
    800033fa:	69e2                	ld	s3,24(sp)
    800033fc:	6a42                	ld	s4,16(sp)
    800033fe:	6aa2                	ld	s5,8(sp)
    80003400:	b7f9                	j	800033ce <fileclose+0x8a>

0000000080003402 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003402:	715d                	addi	sp,sp,-80
    80003404:	e486                	sd	ra,72(sp)
    80003406:	e0a2                	sd	s0,64(sp)
    80003408:	fc26                	sd	s1,56(sp)
    8000340a:	f44e                	sd	s3,40(sp)
    8000340c:	0880                	addi	s0,sp,80
    8000340e:	84aa                	mv	s1,a0
    80003410:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003412:	94bfd0ef          	jal	80000d5c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003416:	409c                	lw	a5,0(s1)
    80003418:	37f9                	addiw	a5,a5,-2
    8000341a:	4705                	li	a4,1
    8000341c:	04f76263          	bltu	a4,a5,80003460 <filestat+0x5e>
    80003420:	f84a                	sd	s2,48(sp)
    80003422:	f052                	sd	s4,32(sp)
    80003424:	892a                	mv	s2,a0
    ilock(f->ip);
    80003426:	6c88                	ld	a0,24(s1)
    80003428:	a4aff0ef          	jal	80002672 <ilock>
    stati(f->ip, &st);
    8000342c:	fb840a13          	addi	s4,s0,-72
    80003430:	85d2                	mv	a1,s4
    80003432:	6c88                	ld	a0,24(s1)
    80003434:	c68ff0ef          	jal	8000289c <stati>
    iunlock(f->ip);
    80003438:	6c88                	ld	a0,24(s1)
    8000343a:	ae6ff0ef          	jal	80002720 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000343e:	46e1                	li	a3,24
    80003440:	8652                	mv	a2,s4
    80003442:	85ce                	mv	a1,s3
    80003444:	05093503          	ld	a0,80(s2)
    80003448:	dbcfd0ef          	jal	80000a04 <copyout>
    8000344c:	41f5551b          	sraiw	a0,a0,0x1f
    80003450:	7942                	ld	s2,48(sp)
    80003452:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003454:	60a6                	ld	ra,72(sp)
    80003456:	6406                	ld	s0,64(sp)
    80003458:	74e2                	ld	s1,56(sp)
    8000345a:	79a2                	ld	s3,40(sp)
    8000345c:	6161                	addi	sp,sp,80
    8000345e:	8082                	ret
  return -1;
    80003460:	557d                	li	a0,-1
    80003462:	bfcd                	j	80003454 <filestat+0x52>

0000000080003464 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003464:	7179                	addi	sp,sp,-48
    80003466:	f406                	sd	ra,40(sp)
    80003468:	f022                	sd	s0,32(sp)
    8000346a:	e84a                	sd	s2,16(sp)
    8000346c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000346e:	00854783          	lbu	a5,8(a0)
    80003472:	cfd1                	beqz	a5,8000350e <fileread+0xaa>
    80003474:	ec26                	sd	s1,24(sp)
    80003476:	e44e                	sd	s3,8(sp)
    80003478:	84aa                	mv	s1,a0
    8000347a:	89ae                	mv	s3,a1
    8000347c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000347e:	411c                	lw	a5,0(a0)
    80003480:	4705                	li	a4,1
    80003482:	04e78363          	beq	a5,a4,800034c8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003486:	470d                	li	a4,3
    80003488:	04e78763          	beq	a5,a4,800034d6 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000348c:	4709                	li	a4,2
    8000348e:	06e79a63          	bne	a5,a4,80003502 <fileread+0x9e>
    ilock(f->ip);
    80003492:	6d08                	ld	a0,24(a0)
    80003494:	9deff0ef          	jal	80002672 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003498:	874a                	mv	a4,s2
    8000349a:	5094                	lw	a3,32(s1)
    8000349c:	864e                	mv	a2,s3
    8000349e:	4585                	li	a1,1
    800034a0:	6c88                	ld	a0,24(s1)
    800034a2:	c28ff0ef          	jal	800028ca <readi>
    800034a6:	892a                	mv	s2,a0
    800034a8:	00a05563          	blez	a0,800034b2 <fileread+0x4e>
      f->off += r;
    800034ac:	509c                	lw	a5,32(s1)
    800034ae:	9fa9                	addw	a5,a5,a0
    800034b0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800034b2:	6c88                	ld	a0,24(s1)
    800034b4:	a6cff0ef          	jal	80002720 <iunlock>
    800034b8:	64e2                	ld	s1,24(sp)
    800034ba:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800034bc:	854a                	mv	a0,s2
    800034be:	70a2                	ld	ra,40(sp)
    800034c0:	7402                	ld	s0,32(sp)
    800034c2:	6942                	ld	s2,16(sp)
    800034c4:	6145                	addi	sp,sp,48
    800034c6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800034c8:	6908                	ld	a0,16(a0)
    800034ca:	3a2000ef          	jal	8000386c <piperead>
    800034ce:	892a                	mv	s2,a0
    800034d0:	64e2                	ld	s1,24(sp)
    800034d2:	69a2                	ld	s3,8(sp)
    800034d4:	b7e5                	j	800034bc <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800034d6:	02451783          	lh	a5,36(a0)
    800034da:	03079693          	slli	a3,a5,0x30
    800034de:	92c1                	srli	a3,a3,0x30
    800034e0:	4725                	li	a4,9
    800034e2:	02d76863          	bltu	a4,a3,80003512 <fileread+0xae>
    800034e6:	0792                	slli	a5,a5,0x4
    800034e8:	00017717          	auipc	a4,0x17
    800034ec:	20070713          	addi	a4,a4,512 # 8001a6e8 <devsw>
    800034f0:	97ba                	add	a5,a5,a4
    800034f2:	639c                	ld	a5,0(a5)
    800034f4:	c39d                	beqz	a5,8000351a <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800034f6:	4505                	li	a0,1
    800034f8:	9782                	jalr	a5
    800034fa:	892a                	mv	s2,a0
    800034fc:	64e2                	ld	s1,24(sp)
    800034fe:	69a2                	ld	s3,8(sp)
    80003500:	bf75                	j	800034bc <fileread+0x58>
    panic("fileread");
    80003502:	00004517          	auipc	a0,0x4
    80003506:	13650513          	addi	a0,a0,310 # 80007638 <etext+0x638>
    8000350a:	74d010ef          	jal	80005456 <panic>
    return -1;
    8000350e:	597d                	li	s2,-1
    80003510:	b775                	j	800034bc <fileread+0x58>
      return -1;
    80003512:	597d                	li	s2,-1
    80003514:	64e2                	ld	s1,24(sp)
    80003516:	69a2                	ld	s3,8(sp)
    80003518:	b755                	j	800034bc <fileread+0x58>
    8000351a:	597d                	li	s2,-1
    8000351c:	64e2                	ld	s1,24(sp)
    8000351e:	69a2                	ld	s3,8(sp)
    80003520:	bf71                	j	800034bc <fileread+0x58>

0000000080003522 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003522:	00954783          	lbu	a5,9(a0)
    80003526:	10078e63          	beqz	a5,80003642 <filewrite+0x120>
{
    8000352a:	711d                	addi	sp,sp,-96
    8000352c:	ec86                	sd	ra,88(sp)
    8000352e:	e8a2                	sd	s0,80(sp)
    80003530:	e0ca                	sd	s2,64(sp)
    80003532:	f456                	sd	s5,40(sp)
    80003534:	f05a                	sd	s6,32(sp)
    80003536:	1080                	addi	s0,sp,96
    80003538:	892a                	mv	s2,a0
    8000353a:	8b2e                	mv	s6,a1
    8000353c:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000353e:	411c                	lw	a5,0(a0)
    80003540:	4705                	li	a4,1
    80003542:	02e78963          	beq	a5,a4,80003574 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003546:	470d                	li	a4,3
    80003548:	02e78a63          	beq	a5,a4,8000357c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000354c:	4709                	li	a4,2
    8000354e:	0ce79e63          	bne	a5,a4,8000362a <filewrite+0x108>
    80003552:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003554:	0ac05963          	blez	a2,80003606 <filewrite+0xe4>
    80003558:	e4a6                	sd	s1,72(sp)
    8000355a:	fc4e                	sd	s3,56(sp)
    8000355c:	ec5e                	sd	s7,24(sp)
    8000355e:	e862                	sd	s8,16(sp)
    80003560:	e466                	sd	s9,8(sp)
    int i = 0;
    80003562:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003564:	6b85                	lui	s7,0x1
    80003566:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000356a:	6c85                	lui	s9,0x1
    8000356c:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003570:	4c05                	li	s8,1
    80003572:	a8ad                	j	800035ec <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003574:	6908                	ld	a0,16(a0)
    80003576:	1fe000ef          	jal	80003774 <pipewrite>
    8000357a:	a04d                	j	8000361c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000357c:	02451783          	lh	a5,36(a0)
    80003580:	03079693          	slli	a3,a5,0x30
    80003584:	92c1                	srli	a3,a3,0x30
    80003586:	4725                	li	a4,9
    80003588:	0ad76f63          	bltu	a4,a3,80003646 <filewrite+0x124>
    8000358c:	0792                	slli	a5,a5,0x4
    8000358e:	00017717          	auipc	a4,0x17
    80003592:	15a70713          	addi	a4,a4,346 # 8001a6e8 <devsw>
    80003596:	97ba                	add	a5,a5,a4
    80003598:	679c                	ld	a5,8(a5)
    8000359a:	cbc5                	beqz	a5,8000364a <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    8000359c:	4505                	li	a0,1
    8000359e:	9782                	jalr	a5
    800035a0:	a8b5                	j	8000361c <filewrite+0xfa>
      if(n1 > max)
    800035a2:	2981                	sext.w	s3,s3
      begin_op();
    800035a4:	981ff0ef          	jal	80002f24 <begin_op>
      ilock(f->ip);
    800035a8:	01893503          	ld	a0,24(s2)
    800035ac:	8c6ff0ef          	jal	80002672 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800035b0:	874e                	mv	a4,s3
    800035b2:	02092683          	lw	a3,32(s2)
    800035b6:	016a0633          	add	a2,s4,s6
    800035ba:	85e2                	mv	a1,s8
    800035bc:	01893503          	ld	a0,24(s2)
    800035c0:	bfcff0ef          	jal	800029bc <writei>
    800035c4:	84aa                	mv	s1,a0
    800035c6:	00a05763          	blez	a0,800035d4 <filewrite+0xb2>
        f->off += r;
    800035ca:	02092783          	lw	a5,32(s2)
    800035ce:	9fa9                	addw	a5,a5,a0
    800035d0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800035d4:	01893503          	ld	a0,24(s2)
    800035d8:	948ff0ef          	jal	80002720 <iunlock>
      end_op();
    800035dc:	9b3ff0ef          	jal	80002f8e <end_op>

      if(r != n1){
    800035e0:	02999563          	bne	s3,s1,8000360a <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    800035e4:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800035e8:	015a5963          	bge	s4,s5,800035fa <filewrite+0xd8>
      int n1 = n - i;
    800035ec:	414a87bb          	subw	a5,s5,s4
    800035f0:	89be                	mv	s3,a5
      if(n1 > max)
    800035f2:	fafbd8e3          	bge	s7,a5,800035a2 <filewrite+0x80>
    800035f6:	89e6                	mv	s3,s9
    800035f8:	b76d                	j	800035a2 <filewrite+0x80>
    800035fa:	64a6                	ld	s1,72(sp)
    800035fc:	79e2                	ld	s3,56(sp)
    800035fe:	6be2                	ld	s7,24(sp)
    80003600:	6c42                	ld	s8,16(sp)
    80003602:	6ca2                	ld	s9,8(sp)
    80003604:	a801                	j	80003614 <filewrite+0xf2>
    int i = 0;
    80003606:	4a01                	li	s4,0
    80003608:	a031                	j	80003614 <filewrite+0xf2>
    8000360a:	64a6                	ld	s1,72(sp)
    8000360c:	79e2                	ld	s3,56(sp)
    8000360e:	6be2                	ld	s7,24(sp)
    80003610:	6c42                	ld	s8,16(sp)
    80003612:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003614:	034a9d63          	bne	s5,s4,8000364e <filewrite+0x12c>
    80003618:	8556                	mv	a0,s5
    8000361a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000361c:	60e6                	ld	ra,88(sp)
    8000361e:	6446                	ld	s0,80(sp)
    80003620:	6906                	ld	s2,64(sp)
    80003622:	7aa2                	ld	s5,40(sp)
    80003624:	7b02                	ld	s6,32(sp)
    80003626:	6125                	addi	sp,sp,96
    80003628:	8082                	ret
    8000362a:	e4a6                	sd	s1,72(sp)
    8000362c:	fc4e                	sd	s3,56(sp)
    8000362e:	f852                	sd	s4,48(sp)
    80003630:	ec5e                	sd	s7,24(sp)
    80003632:	e862                	sd	s8,16(sp)
    80003634:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003636:	00004517          	auipc	a0,0x4
    8000363a:	01250513          	addi	a0,a0,18 # 80007648 <etext+0x648>
    8000363e:	619010ef          	jal	80005456 <panic>
    return -1;
    80003642:	557d                	li	a0,-1
}
    80003644:	8082                	ret
      return -1;
    80003646:	557d                	li	a0,-1
    80003648:	bfd1                	j	8000361c <filewrite+0xfa>
    8000364a:	557d                	li	a0,-1
    8000364c:	bfc1                	j	8000361c <filewrite+0xfa>
    ret = (i == n ? n : -1);
    8000364e:	557d                	li	a0,-1
    80003650:	7a42                	ld	s4,48(sp)
    80003652:	b7e9                	j	8000361c <filewrite+0xfa>

0000000080003654 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003654:	7179                	addi	sp,sp,-48
    80003656:	f406                	sd	ra,40(sp)
    80003658:	f022                	sd	s0,32(sp)
    8000365a:	ec26                	sd	s1,24(sp)
    8000365c:	e052                	sd	s4,0(sp)
    8000365e:	1800                	addi	s0,sp,48
    80003660:	84aa                	mv	s1,a0
    80003662:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003664:	0005b023          	sd	zero,0(a1)
    80003668:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000366c:	c35ff0ef          	jal	800032a0 <filealloc>
    80003670:	e088                	sd	a0,0(s1)
    80003672:	c549                	beqz	a0,800036fc <pipealloc+0xa8>
    80003674:	c2dff0ef          	jal	800032a0 <filealloc>
    80003678:	00aa3023          	sd	a0,0(s4)
    8000367c:	cd25                	beqz	a0,800036f4 <pipealloc+0xa0>
    8000367e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003680:	a7ffc0ef          	jal	800000fe <kalloc>
    80003684:	892a                	mv	s2,a0
    80003686:	c12d                	beqz	a0,800036e8 <pipealloc+0x94>
    80003688:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000368a:	4985                	li	s3,1
    8000368c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003690:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003694:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003698:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000369c:	00004597          	auipc	a1,0x4
    800036a0:	d6458593          	addi	a1,a1,-668 # 80007400 <etext+0x400>
    800036a4:	05c020ef          	jal	80005700 <initlock>
  (*f0)->type = FD_PIPE;
    800036a8:	609c                	ld	a5,0(s1)
    800036aa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800036ae:	609c                	ld	a5,0(s1)
    800036b0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800036b4:	609c                	ld	a5,0(s1)
    800036b6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800036ba:	609c                	ld	a5,0(s1)
    800036bc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800036c0:	000a3783          	ld	a5,0(s4)
    800036c4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800036c8:	000a3783          	ld	a5,0(s4)
    800036cc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800036d0:	000a3783          	ld	a5,0(s4)
    800036d4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800036d8:	000a3783          	ld	a5,0(s4)
    800036dc:	0127b823          	sd	s2,16(a5)
  return 0;
    800036e0:	4501                	li	a0,0
    800036e2:	6942                	ld	s2,16(sp)
    800036e4:	69a2                	ld	s3,8(sp)
    800036e6:	a01d                	j	8000370c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800036e8:	6088                	ld	a0,0(s1)
    800036ea:	c119                	beqz	a0,800036f0 <pipealloc+0x9c>
    800036ec:	6942                	ld	s2,16(sp)
    800036ee:	a029                	j	800036f8 <pipealloc+0xa4>
    800036f0:	6942                	ld	s2,16(sp)
    800036f2:	a029                	j	800036fc <pipealloc+0xa8>
    800036f4:	6088                	ld	a0,0(s1)
    800036f6:	c10d                	beqz	a0,80003718 <pipealloc+0xc4>
    fileclose(*f0);
    800036f8:	c4dff0ef          	jal	80003344 <fileclose>
  if(*f1)
    800036fc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003700:	557d                	li	a0,-1
  if(*f1)
    80003702:	c789                	beqz	a5,8000370c <pipealloc+0xb8>
    fileclose(*f1);
    80003704:	853e                	mv	a0,a5
    80003706:	c3fff0ef          	jal	80003344 <fileclose>
  return -1;
    8000370a:	557d                	li	a0,-1
}
    8000370c:	70a2                	ld	ra,40(sp)
    8000370e:	7402                	ld	s0,32(sp)
    80003710:	64e2                	ld	s1,24(sp)
    80003712:	6a02                	ld	s4,0(sp)
    80003714:	6145                	addi	sp,sp,48
    80003716:	8082                	ret
  return -1;
    80003718:	557d                	li	a0,-1
    8000371a:	bfcd                	j	8000370c <pipealloc+0xb8>

000000008000371c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000371c:	1101                	addi	sp,sp,-32
    8000371e:	ec06                	sd	ra,24(sp)
    80003720:	e822                	sd	s0,16(sp)
    80003722:	e426                	sd	s1,8(sp)
    80003724:	e04a                	sd	s2,0(sp)
    80003726:	1000                	addi	s0,sp,32
    80003728:	84aa                	mv	s1,a0
    8000372a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000372c:	058020ef          	jal	80005784 <acquire>
  if(writable){
    80003730:	02090763          	beqz	s2,8000375e <pipeclose+0x42>
    pi->writeopen = 0;
    80003734:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003738:	21848513          	addi	a0,s1,536
    8000373c:	c47fd0ef          	jal	80001382 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003740:	2204b783          	ld	a5,544(s1)
    80003744:	e785                	bnez	a5,8000376c <pipeclose+0x50>
    release(&pi->lock);
    80003746:	8526                	mv	a0,s1
    80003748:	0d0020ef          	jal	80005818 <release>
    kfree((char*)pi);
    8000374c:	8526                	mv	a0,s1
    8000374e:	8cffc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003752:	60e2                	ld	ra,24(sp)
    80003754:	6442                	ld	s0,16(sp)
    80003756:	64a2                	ld	s1,8(sp)
    80003758:	6902                	ld	s2,0(sp)
    8000375a:	6105                	addi	sp,sp,32
    8000375c:	8082                	ret
    pi->readopen = 0;
    8000375e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003762:	21c48513          	addi	a0,s1,540
    80003766:	c1dfd0ef          	jal	80001382 <wakeup>
    8000376a:	bfd9                	j	80003740 <pipeclose+0x24>
    release(&pi->lock);
    8000376c:	8526                	mv	a0,s1
    8000376e:	0aa020ef          	jal	80005818 <release>
}
    80003772:	b7c5                	j	80003752 <pipeclose+0x36>

0000000080003774 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003774:	7159                	addi	sp,sp,-112
    80003776:	f486                	sd	ra,104(sp)
    80003778:	f0a2                	sd	s0,96(sp)
    8000377a:	eca6                	sd	s1,88(sp)
    8000377c:	e8ca                	sd	s2,80(sp)
    8000377e:	e4ce                	sd	s3,72(sp)
    80003780:	e0d2                	sd	s4,64(sp)
    80003782:	fc56                	sd	s5,56(sp)
    80003784:	1880                	addi	s0,sp,112
    80003786:	84aa                	mv	s1,a0
    80003788:	8aae                	mv	s5,a1
    8000378a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000378c:	dd0fd0ef          	jal	80000d5c <myproc>
    80003790:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003792:	8526                	mv	a0,s1
    80003794:	7f1010ef          	jal	80005784 <acquire>
  while(i < n){
    80003798:	0d405263          	blez	s4,8000385c <pipewrite+0xe8>
    8000379c:	f85a                	sd	s6,48(sp)
    8000379e:	f45e                	sd	s7,40(sp)
    800037a0:	f062                	sd	s8,32(sp)
    800037a2:	ec66                	sd	s9,24(sp)
    800037a4:	e86a                	sd	s10,16(sp)
  int i = 0;
    800037a6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037a8:	f9f40c13          	addi	s8,s0,-97
    800037ac:	4b85                	li	s7,1
    800037ae:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800037b0:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800037b4:	21c48c93          	addi	s9,s1,540
    800037b8:	a82d                	j	800037f2 <pipewrite+0x7e>
      release(&pi->lock);
    800037ba:	8526                	mv	a0,s1
    800037bc:	05c020ef          	jal	80005818 <release>
      return -1;
    800037c0:	597d                	li	s2,-1
    800037c2:	7b42                	ld	s6,48(sp)
    800037c4:	7ba2                	ld	s7,40(sp)
    800037c6:	7c02                	ld	s8,32(sp)
    800037c8:	6ce2                	ld	s9,24(sp)
    800037ca:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800037cc:	854a                	mv	a0,s2
    800037ce:	70a6                	ld	ra,104(sp)
    800037d0:	7406                	ld	s0,96(sp)
    800037d2:	64e6                	ld	s1,88(sp)
    800037d4:	6946                	ld	s2,80(sp)
    800037d6:	69a6                	ld	s3,72(sp)
    800037d8:	6a06                	ld	s4,64(sp)
    800037da:	7ae2                	ld	s5,56(sp)
    800037dc:	6165                	addi	sp,sp,112
    800037de:	8082                	ret
      wakeup(&pi->nread);
    800037e0:	856a                	mv	a0,s10
    800037e2:	ba1fd0ef          	jal	80001382 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800037e6:	85a6                	mv	a1,s1
    800037e8:	8566                	mv	a0,s9
    800037ea:	b4dfd0ef          	jal	80001336 <sleep>
  while(i < n){
    800037ee:	05495a63          	bge	s2,s4,80003842 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800037f2:	2204a783          	lw	a5,544(s1)
    800037f6:	d3f1                	beqz	a5,800037ba <pipewrite+0x46>
    800037f8:	854e                	mv	a0,s3
    800037fa:	d75fd0ef          	jal	8000156e <killed>
    800037fe:	fd55                	bnez	a0,800037ba <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003800:	2184a783          	lw	a5,536(s1)
    80003804:	21c4a703          	lw	a4,540(s1)
    80003808:	2007879b          	addiw	a5,a5,512
    8000380c:	fcf70ae3          	beq	a4,a5,800037e0 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003810:	86de                	mv	a3,s7
    80003812:	01590633          	add	a2,s2,s5
    80003816:	85e2                	mv	a1,s8
    80003818:	0509b503          	ld	a0,80(s3)
    8000381c:	a98fd0ef          	jal	80000ab4 <copyin>
    80003820:	05650063          	beq	a0,s6,80003860 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003824:	21c4a783          	lw	a5,540(s1)
    80003828:	0017871b          	addiw	a4,a5,1
    8000382c:	20e4ae23          	sw	a4,540(s1)
    80003830:	1ff7f793          	andi	a5,a5,511
    80003834:	97a6                	add	a5,a5,s1
    80003836:	f9f44703          	lbu	a4,-97(s0)
    8000383a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000383e:	2905                	addiw	s2,s2,1
    80003840:	b77d                	j	800037ee <pipewrite+0x7a>
    80003842:	7b42                	ld	s6,48(sp)
    80003844:	7ba2                	ld	s7,40(sp)
    80003846:	7c02                	ld	s8,32(sp)
    80003848:	6ce2                	ld	s9,24(sp)
    8000384a:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000384c:	21848513          	addi	a0,s1,536
    80003850:	b33fd0ef          	jal	80001382 <wakeup>
  release(&pi->lock);
    80003854:	8526                	mv	a0,s1
    80003856:	7c3010ef          	jal	80005818 <release>
  return i;
    8000385a:	bf8d                	j	800037cc <pipewrite+0x58>
  int i = 0;
    8000385c:	4901                	li	s2,0
    8000385e:	b7fd                	j	8000384c <pipewrite+0xd8>
    80003860:	7b42                	ld	s6,48(sp)
    80003862:	7ba2                	ld	s7,40(sp)
    80003864:	7c02                	ld	s8,32(sp)
    80003866:	6ce2                	ld	s9,24(sp)
    80003868:	6d42                	ld	s10,16(sp)
    8000386a:	b7cd                	j	8000384c <pipewrite+0xd8>

000000008000386c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000386c:	711d                	addi	sp,sp,-96
    8000386e:	ec86                	sd	ra,88(sp)
    80003870:	e8a2                	sd	s0,80(sp)
    80003872:	e4a6                	sd	s1,72(sp)
    80003874:	e0ca                	sd	s2,64(sp)
    80003876:	fc4e                	sd	s3,56(sp)
    80003878:	f852                	sd	s4,48(sp)
    8000387a:	f456                	sd	s5,40(sp)
    8000387c:	1080                	addi	s0,sp,96
    8000387e:	84aa                	mv	s1,a0
    80003880:	892e                	mv	s2,a1
    80003882:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003884:	cd8fd0ef          	jal	80000d5c <myproc>
    80003888:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000388a:	8526                	mv	a0,s1
    8000388c:	6f9010ef          	jal	80005784 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003890:	2184a703          	lw	a4,536(s1)
    80003894:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003898:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000389c:	02f71763          	bne	a4,a5,800038ca <piperead+0x5e>
    800038a0:	2244a783          	lw	a5,548(s1)
    800038a4:	cf85                	beqz	a5,800038dc <piperead+0x70>
    if(killed(pr)){
    800038a6:	8552                	mv	a0,s4
    800038a8:	cc7fd0ef          	jal	8000156e <killed>
    800038ac:	e11d                	bnez	a0,800038d2 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038ae:	85a6                	mv	a1,s1
    800038b0:	854e                	mv	a0,s3
    800038b2:	a85fd0ef          	jal	80001336 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038b6:	2184a703          	lw	a4,536(s1)
    800038ba:	21c4a783          	lw	a5,540(s1)
    800038be:	fef701e3          	beq	a4,a5,800038a0 <piperead+0x34>
    800038c2:	f05a                	sd	s6,32(sp)
    800038c4:	ec5e                	sd	s7,24(sp)
    800038c6:	e862                	sd	s8,16(sp)
    800038c8:	a829                	j	800038e2 <piperead+0x76>
    800038ca:	f05a                	sd	s6,32(sp)
    800038cc:	ec5e                	sd	s7,24(sp)
    800038ce:	e862                	sd	s8,16(sp)
    800038d0:	a809                	j	800038e2 <piperead+0x76>
      release(&pi->lock);
    800038d2:	8526                	mv	a0,s1
    800038d4:	745010ef          	jal	80005818 <release>
      return -1;
    800038d8:	59fd                	li	s3,-1
    800038da:	a0a5                	j	80003942 <piperead+0xd6>
    800038dc:	f05a                	sd	s6,32(sp)
    800038de:	ec5e                	sd	s7,24(sp)
    800038e0:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800038e4:	faf40c13          	addi	s8,s0,-81
    800038e8:	4b85                	li	s7,1
    800038ea:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038ec:	05505163          	blez	s5,8000392e <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    800038f0:	2184a783          	lw	a5,536(s1)
    800038f4:	21c4a703          	lw	a4,540(s1)
    800038f8:	02f70b63          	beq	a4,a5,8000392e <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800038fc:	0017871b          	addiw	a4,a5,1
    80003900:	20e4ac23          	sw	a4,536(s1)
    80003904:	1ff7f793          	andi	a5,a5,511
    80003908:	97a6                	add	a5,a5,s1
    8000390a:	0187c783          	lbu	a5,24(a5)
    8000390e:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003912:	86de                	mv	a3,s7
    80003914:	8662                	mv	a2,s8
    80003916:	85ca                	mv	a1,s2
    80003918:	050a3503          	ld	a0,80(s4)
    8000391c:	8e8fd0ef          	jal	80000a04 <copyout>
    80003920:	01650763          	beq	a0,s6,8000392e <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003924:	2985                	addiw	s3,s3,1
    80003926:	0905                	addi	s2,s2,1
    80003928:	fd3a94e3          	bne	s5,s3,800038f0 <piperead+0x84>
    8000392c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000392e:	21c48513          	addi	a0,s1,540
    80003932:	a51fd0ef          	jal	80001382 <wakeup>
  release(&pi->lock);
    80003936:	8526                	mv	a0,s1
    80003938:	6e1010ef          	jal	80005818 <release>
    8000393c:	7b02                	ld	s6,32(sp)
    8000393e:	6be2                	ld	s7,24(sp)
    80003940:	6c42                	ld	s8,16(sp)
  return i;
}
    80003942:	854e                	mv	a0,s3
    80003944:	60e6                	ld	ra,88(sp)
    80003946:	6446                	ld	s0,80(sp)
    80003948:	64a6                	ld	s1,72(sp)
    8000394a:	6906                	ld	s2,64(sp)
    8000394c:	79e2                	ld	s3,56(sp)
    8000394e:	7a42                	ld	s4,48(sp)
    80003950:	7aa2                	ld	s5,40(sp)
    80003952:	6125                	addi	sp,sp,96
    80003954:	8082                	ret

0000000080003956 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003956:	1141                	addi	sp,sp,-16
    80003958:	e406                	sd	ra,8(sp)
    8000395a:	e022                	sd	s0,0(sp)
    8000395c:	0800                	addi	s0,sp,16
    8000395e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003960:	0035151b          	slliw	a0,a0,0x3
    80003964:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003966:	8b89                	andi	a5,a5,2
    80003968:	c399                	beqz	a5,8000396e <flags2perm+0x18>
      perm |= PTE_W;
    8000396a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000396e:	60a2                	ld	ra,8(sp)
    80003970:	6402                	ld	s0,0(sp)
    80003972:	0141                	addi	sp,sp,16
    80003974:	8082                	ret

0000000080003976 <exec>:

int
exec(char *path, char **argv)
{
    80003976:	de010113          	addi	sp,sp,-544
    8000397a:	20113c23          	sd	ra,536(sp)
    8000397e:	20813823          	sd	s0,528(sp)
    80003982:	20913423          	sd	s1,520(sp)
    80003986:	21213023          	sd	s2,512(sp)
    8000398a:	1400                	addi	s0,sp,544
    8000398c:	892a                	mv	s2,a0
    8000398e:	dea43823          	sd	a0,-528(s0)
    80003992:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003996:	bc6fd0ef          	jal	80000d5c <myproc>
    8000399a:	84aa                	mv	s1,a0

  begin_op();
    8000399c:	d88ff0ef          	jal	80002f24 <begin_op>

  if((ip = namei(path)) == 0){
    800039a0:	854a                	mv	a0,s2
    800039a2:	bc0ff0ef          	jal	80002d62 <namei>
    800039a6:	cd21                	beqz	a0,800039fe <exec+0x88>
    800039a8:	fbd2                	sd	s4,496(sp)
    800039aa:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800039ac:	cc7fe0ef          	jal	80002672 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800039b0:	04000713          	li	a4,64
    800039b4:	4681                	li	a3,0
    800039b6:	e5040613          	addi	a2,s0,-432
    800039ba:	4581                	li	a1,0
    800039bc:	8552                	mv	a0,s4
    800039be:	f0dfe0ef          	jal	800028ca <readi>
    800039c2:	04000793          	li	a5,64
    800039c6:	00f51a63          	bne	a0,a5,800039da <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800039ca:	e5042703          	lw	a4,-432(s0)
    800039ce:	464c47b7          	lui	a5,0x464c4
    800039d2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800039d6:	02f70863          	beq	a4,a5,80003a06 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800039da:	8552                	mv	a0,s4
    800039dc:	ea1fe0ef          	jal	8000287c <iunlockput>
    end_op();
    800039e0:	daeff0ef          	jal	80002f8e <end_op>
  }
  return -1;
    800039e4:	557d                	li	a0,-1
    800039e6:	7a5e                	ld	s4,496(sp)
}
    800039e8:	21813083          	ld	ra,536(sp)
    800039ec:	21013403          	ld	s0,528(sp)
    800039f0:	20813483          	ld	s1,520(sp)
    800039f4:	20013903          	ld	s2,512(sp)
    800039f8:	22010113          	addi	sp,sp,544
    800039fc:	8082                	ret
    end_op();
    800039fe:	d90ff0ef          	jal	80002f8e <end_op>
    return -1;
    80003a02:	557d                	li	a0,-1
    80003a04:	b7d5                	j	800039e8 <exec+0x72>
    80003a06:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003a08:	8526                	mv	a0,s1
    80003a0a:	bfafd0ef          	jal	80000e04 <proc_pagetable>
    80003a0e:	8b2a                	mv	s6,a0
    80003a10:	26050d63          	beqz	a0,80003c8a <exec+0x314>
    80003a14:	ffce                	sd	s3,504(sp)
    80003a16:	f7d6                	sd	s5,488(sp)
    80003a18:	efde                	sd	s7,472(sp)
    80003a1a:	ebe2                	sd	s8,464(sp)
    80003a1c:	e7e6                	sd	s9,456(sp)
    80003a1e:	e3ea                	sd	s10,448(sp)
    80003a20:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a22:	e7042683          	lw	a3,-400(s0)
    80003a26:	e8845783          	lhu	a5,-376(s0)
    80003a2a:	0e078763          	beqz	a5,80003b18 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a2e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a30:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003a32:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003a36:	6c85                	lui	s9,0x1
    80003a38:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003a3c:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003a40:	6a85                	lui	s5,0x1
    80003a42:	a085                	j	80003aa2 <exec+0x12c>
      panic("loadseg: address should exist");
    80003a44:	00004517          	auipc	a0,0x4
    80003a48:	c1450513          	addi	a0,a0,-1004 # 80007658 <etext+0x658>
    80003a4c:	20b010ef          	jal	80005456 <panic>
    if(sz - i < PGSIZE)
    80003a50:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003a52:	874a                	mv	a4,s2
    80003a54:	009c06bb          	addw	a3,s8,s1
    80003a58:	4581                	li	a1,0
    80003a5a:	8552                	mv	a0,s4
    80003a5c:	e6ffe0ef          	jal	800028ca <readi>
    80003a60:	22a91963          	bne	s2,a0,80003c92 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003a64:	009a84bb          	addw	s1,s5,s1
    80003a68:	0334f263          	bgeu	s1,s3,80003a8c <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003a6c:	02049593          	slli	a1,s1,0x20
    80003a70:	9181                	srli	a1,a1,0x20
    80003a72:	95de                	add	a1,a1,s7
    80003a74:	855a                	mv	a0,s6
    80003a76:	a07fc0ef          	jal	8000047c <walkaddr>
    80003a7a:	862a                	mv	a2,a0
    if(pa == 0)
    80003a7c:	d561                	beqz	a0,80003a44 <exec+0xce>
    if(sz - i < PGSIZE)
    80003a7e:	409987bb          	subw	a5,s3,s1
    80003a82:	893e                	mv	s2,a5
    80003a84:	fcfcf6e3          	bgeu	s9,a5,80003a50 <exec+0xda>
    80003a88:	8956                	mv	s2,s5
    80003a8a:	b7d9                	j	80003a50 <exec+0xda>
    sz = sz1;
    80003a8c:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a90:	2d05                	addiw	s10,s10,1
    80003a92:	e0843783          	ld	a5,-504(s0)
    80003a96:	0387869b          	addiw	a3,a5,56
    80003a9a:	e8845783          	lhu	a5,-376(s0)
    80003a9e:	06fd5e63          	bge	s10,a5,80003b1a <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003aa2:	e0d43423          	sd	a3,-504(s0)
    80003aa6:	876e                	mv	a4,s11
    80003aa8:	e1840613          	addi	a2,s0,-488
    80003aac:	4581                	li	a1,0
    80003aae:	8552                	mv	a0,s4
    80003ab0:	e1bfe0ef          	jal	800028ca <readi>
    80003ab4:	1db51d63          	bne	a0,s11,80003c8e <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003ab8:	e1842783          	lw	a5,-488(s0)
    80003abc:	4705                	li	a4,1
    80003abe:	fce799e3          	bne	a5,a4,80003a90 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003ac2:	e4043483          	ld	s1,-448(s0)
    80003ac6:	e3843783          	ld	a5,-456(s0)
    80003aca:	1ef4e263          	bltu	s1,a5,80003cae <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003ace:	e2843783          	ld	a5,-472(s0)
    80003ad2:	94be                	add	s1,s1,a5
    80003ad4:	1ef4e063          	bltu	s1,a5,80003cb4 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003ad8:	de843703          	ld	a4,-536(s0)
    80003adc:	8ff9                	and	a5,a5,a4
    80003ade:	1c079e63          	bnez	a5,80003cba <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003ae2:	e1c42503          	lw	a0,-484(s0)
    80003ae6:	e71ff0ef          	jal	80003956 <flags2perm>
    80003aea:	86aa                	mv	a3,a0
    80003aec:	8626                	mv	a2,s1
    80003aee:	85ca                	mv	a1,s2
    80003af0:	855a                	mv	a0,s6
    80003af2:	cf3fc0ef          	jal	800007e4 <uvmalloc>
    80003af6:	dea43c23          	sd	a0,-520(s0)
    80003afa:	1c050363          	beqz	a0,80003cc0 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003afe:	e2843b83          	ld	s7,-472(s0)
    80003b02:	e2042c03          	lw	s8,-480(s0)
    80003b06:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b0a:	00098463          	beqz	s3,80003b12 <exec+0x19c>
    80003b0e:	4481                	li	s1,0
    80003b10:	bfb1                	j	80003a6c <exec+0xf6>
    sz = sz1;
    80003b12:	df843903          	ld	s2,-520(s0)
    80003b16:	bfad                	j	80003a90 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b18:	4901                	li	s2,0
  iunlockput(ip);
    80003b1a:	8552                	mv	a0,s4
    80003b1c:	d61fe0ef          	jal	8000287c <iunlockput>
  end_op();
    80003b20:	c6eff0ef          	jal	80002f8e <end_op>
  p = myproc();
    80003b24:	a38fd0ef          	jal	80000d5c <myproc>
    80003b28:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003b2a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003b2e:	6985                	lui	s3,0x1
    80003b30:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003b32:	99ca                	add	s3,s3,s2
    80003b34:	77fd                	lui	a5,0xfffff
    80003b36:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003b3a:	4691                	li	a3,4
    80003b3c:	660d                	lui	a2,0x3
    80003b3e:	964e                	add	a2,a2,s3
    80003b40:	85ce                	mv	a1,s3
    80003b42:	855a                	mv	a0,s6
    80003b44:	ca1fc0ef          	jal	800007e4 <uvmalloc>
    80003b48:	8a2a                	mv	s4,a0
    80003b4a:	e105                	bnez	a0,80003b6a <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003b4c:	85ce                	mv	a1,s3
    80003b4e:	855a                	mv	a0,s6
    80003b50:	b38fd0ef          	jal	80000e88 <proc_freepagetable>
  return -1;
    80003b54:	557d                	li	a0,-1
    80003b56:	79fe                	ld	s3,504(sp)
    80003b58:	7a5e                	ld	s4,496(sp)
    80003b5a:	7abe                	ld	s5,488(sp)
    80003b5c:	7b1e                	ld	s6,480(sp)
    80003b5e:	6bfe                	ld	s7,472(sp)
    80003b60:	6c5e                	ld	s8,464(sp)
    80003b62:	6cbe                	ld	s9,456(sp)
    80003b64:	6d1e                	ld	s10,448(sp)
    80003b66:	7dfa                	ld	s11,440(sp)
    80003b68:	b541                	j	800039e8 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003b6a:	75f5                	lui	a1,0xffffd
    80003b6c:	95aa                	add	a1,a1,a0
    80003b6e:	855a                	mv	a0,s6
    80003b70:	e6bfc0ef          	jal	800009da <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003b74:	7bf9                	lui	s7,0xffffe
    80003b76:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b78:	e0043783          	ld	a5,-512(s0)
    80003b7c:	6388                	ld	a0,0(a5)
  sp = sz;
    80003b7e:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b80:	4481                	li	s1,0
    ustack[argc] = sp;
    80003b82:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003b86:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003b8a:	cd21                	beqz	a0,80003be2 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003b8c:	f4afc0ef          	jal	800002d6 <strlen>
    80003b90:	0015079b          	addiw	a5,a0,1
    80003b94:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b98:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003b9c:	13796563          	bltu	s2,s7,80003cc6 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ba0:	e0043d83          	ld	s11,-512(s0)
    80003ba4:	000db983          	ld	s3,0(s11)
    80003ba8:	854e                	mv	a0,s3
    80003baa:	f2cfc0ef          	jal	800002d6 <strlen>
    80003bae:	0015069b          	addiw	a3,a0,1
    80003bb2:	864e                	mv	a2,s3
    80003bb4:	85ca                	mv	a1,s2
    80003bb6:	855a                	mv	a0,s6
    80003bb8:	e4dfc0ef          	jal	80000a04 <copyout>
    80003bbc:	10054763          	bltz	a0,80003cca <exec+0x354>
    ustack[argc] = sp;
    80003bc0:	00349793          	slli	a5,s1,0x3
    80003bc4:	97e6                	add	a5,a5,s9
    80003bc6:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb680>
  for(argc = 0; argv[argc]; argc++) {
    80003bca:	0485                	addi	s1,s1,1
    80003bcc:	008d8793          	addi	a5,s11,8
    80003bd0:	e0f43023          	sd	a5,-512(s0)
    80003bd4:	008db503          	ld	a0,8(s11)
    80003bd8:	c509                	beqz	a0,80003be2 <exec+0x26c>
    if(argc >= MAXARG)
    80003bda:	fb8499e3          	bne	s1,s8,80003b8c <exec+0x216>
  sz = sz1;
    80003bde:	89d2                	mv	s3,s4
    80003be0:	b7b5                	j	80003b4c <exec+0x1d6>
  ustack[argc] = 0;
    80003be2:	00349793          	slli	a5,s1,0x3
    80003be6:	f9078793          	addi	a5,a5,-112
    80003bea:	97a2                	add	a5,a5,s0
    80003bec:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003bf0:	00148693          	addi	a3,s1,1
    80003bf4:	068e                	slli	a3,a3,0x3
    80003bf6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003bfa:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003bfe:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003c00:	f57966e3          	bltu	s2,s7,80003b4c <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c04:	e9040613          	addi	a2,s0,-368
    80003c08:	85ca                	mv	a1,s2
    80003c0a:	855a                	mv	a0,s6
    80003c0c:	df9fc0ef          	jal	80000a04 <copyout>
    80003c10:	f2054ee3          	bltz	a0,80003b4c <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003c14:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003c18:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c1c:	df043783          	ld	a5,-528(s0)
    80003c20:	0007c703          	lbu	a4,0(a5)
    80003c24:	cf11                	beqz	a4,80003c40 <exec+0x2ca>
    80003c26:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003c28:	02f00693          	li	a3,47
    80003c2c:	a029                	j	80003c36 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003c2e:	0785                	addi	a5,a5,1
    80003c30:	fff7c703          	lbu	a4,-1(a5)
    80003c34:	c711                	beqz	a4,80003c40 <exec+0x2ca>
    if(*s == '/')
    80003c36:	fed71ce3          	bne	a4,a3,80003c2e <exec+0x2b8>
      last = s+1;
    80003c3a:	def43823          	sd	a5,-528(s0)
    80003c3e:	bfc5                	j	80003c2e <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003c40:	4641                	li	a2,16
    80003c42:	df043583          	ld	a1,-528(s0)
    80003c46:	158a8513          	addi	a0,s5,344
    80003c4a:	e56fc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003c4e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003c52:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003c56:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003c5a:	058ab783          	ld	a5,88(s5)
    80003c5e:	e6843703          	ld	a4,-408(s0)
    80003c62:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003c64:	058ab783          	ld	a5,88(s5)
    80003c68:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003c6c:	85ea                	mv	a1,s10
    80003c6e:	a1afd0ef          	jal	80000e88 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003c72:	0004851b          	sext.w	a0,s1
    80003c76:	79fe                	ld	s3,504(sp)
    80003c78:	7a5e                	ld	s4,496(sp)
    80003c7a:	7abe                	ld	s5,488(sp)
    80003c7c:	7b1e                	ld	s6,480(sp)
    80003c7e:	6bfe                	ld	s7,472(sp)
    80003c80:	6c5e                	ld	s8,464(sp)
    80003c82:	6cbe                	ld	s9,456(sp)
    80003c84:	6d1e                	ld	s10,448(sp)
    80003c86:	7dfa                	ld	s11,440(sp)
    80003c88:	b385                	j	800039e8 <exec+0x72>
    80003c8a:	7b1e                	ld	s6,480(sp)
    80003c8c:	b3b9                	j	800039da <exec+0x64>
    80003c8e:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003c92:	df843583          	ld	a1,-520(s0)
    80003c96:	855a                	mv	a0,s6
    80003c98:	9f0fd0ef          	jal	80000e88 <proc_freepagetable>
  if(ip){
    80003c9c:	79fe                	ld	s3,504(sp)
    80003c9e:	7abe                	ld	s5,488(sp)
    80003ca0:	7b1e                	ld	s6,480(sp)
    80003ca2:	6bfe                	ld	s7,472(sp)
    80003ca4:	6c5e                	ld	s8,464(sp)
    80003ca6:	6cbe                	ld	s9,456(sp)
    80003ca8:	6d1e                	ld	s10,448(sp)
    80003caa:	7dfa                	ld	s11,440(sp)
    80003cac:	b33d                	j	800039da <exec+0x64>
    80003cae:	df243c23          	sd	s2,-520(s0)
    80003cb2:	b7c5                	j	80003c92 <exec+0x31c>
    80003cb4:	df243c23          	sd	s2,-520(s0)
    80003cb8:	bfe9                	j	80003c92 <exec+0x31c>
    80003cba:	df243c23          	sd	s2,-520(s0)
    80003cbe:	bfd1                	j	80003c92 <exec+0x31c>
    80003cc0:	df243c23          	sd	s2,-520(s0)
    80003cc4:	b7f9                	j	80003c92 <exec+0x31c>
  sz = sz1;
    80003cc6:	89d2                	mv	s3,s4
    80003cc8:	b551                	j	80003b4c <exec+0x1d6>
    80003cca:	89d2                	mv	s3,s4
    80003ccc:	b541                	j	80003b4c <exec+0x1d6>

0000000080003cce <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003cce:	7179                	addi	sp,sp,-48
    80003cd0:	f406                	sd	ra,40(sp)
    80003cd2:	f022                	sd	s0,32(sp)
    80003cd4:	ec26                	sd	s1,24(sp)
    80003cd6:	e84a                	sd	s2,16(sp)
    80003cd8:	1800                	addi	s0,sp,48
    80003cda:	892e                	mv	s2,a1
    80003cdc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003cde:	fdc40593          	addi	a1,s0,-36
    80003ce2:	f39fd0ef          	jal	80001c1a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003ce6:	fdc42703          	lw	a4,-36(s0)
    80003cea:	47bd                	li	a5,15
    80003cec:	02e7e963          	bltu	a5,a4,80003d1e <argfd+0x50>
    80003cf0:	86cfd0ef          	jal	80000d5c <myproc>
    80003cf4:	fdc42703          	lw	a4,-36(s0)
    80003cf8:	01a70793          	addi	a5,a4,26
    80003cfc:	078e                	slli	a5,a5,0x3
    80003cfe:	953e                	add	a0,a0,a5
    80003d00:	611c                	ld	a5,0(a0)
    80003d02:	c385                	beqz	a5,80003d22 <argfd+0x54>
    return -1;
  if(pfd)
    80003d04:	00090463          	beqz	s2,80003d0c <argfd+0x3e>
    *pfd = fd;
    80003d08:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003d0c:	4501                	li	a0,0
  if(pf)
    80003d0e:	c091                	beqz	s1,80003d12 <argfd+0x44>
    *pf = f;
    80003d10:	e09c                	sd	a5,0(s1)
}
    80003d12:	70a2                	ld	ra,40(sp)
    80003d14:	7402                	ld	s0,32(sp)
    80003d16:	64e2                	ld	s1,24(sp)
    80003d18:	6942                	ld	s2,16(sp)
    80003d1a:	6145                	addi	sp,sp,48
    80003d1c:	8082                	ret
    return -1;
    80003d1e:	557d                	li	a0,-1
    80003d20:	bfcd                	j	80003d12 <argfd+0x44>
    80003d22:	557d                	li	a0,-1
    80003d24:	b7fd                	j	80003d12 <argfd+0x44>

0000000080003d26 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003d26:	1101                	addi	sp,sp,-32
    80003d28:	ec06                	sd	ra,24(sp)
    80003d2a:	e822                	sd	s0,16(sp)
    80003d2c:	e426                	sd	s1,8(sp)
    80003d2e:	1000                	addi	s0,sp,32
    80003d30:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003d32:	82afd0ef          	jal	80000d5c <myproc>
    80003d36:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003d38:	0d050793          	addi	a5,a0,208
    80003d3c:	4501                	li	a0,0
    80003d3e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003d40:	6398                	ld	a4,0(a5)
    80003d42:	cb19                	beqz	a4,80003d58 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003d44:	2505                	addiw	a0,a0,1
    80003d46:	07a1                	addi	a5,a5,8
    80003d48:	fed51ce3          	bne	a0,a3,80003d40 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003d4c:	557d                	li	a0,-1
}
    80003d4e:	60e2                	ld	ra,24(sp)
    80003d50:	6442                	ld	s0,16(sp)
    80003d52:	64a2                	ld	s1,8(sp)
    80003d54:	6105                	addi	sp,sp,32
    80003d56:	8082                	ret
      p->ofile[fd] = f;
    80003d58:	01a50793          	addi	a5,a0,26
    80003d5c:	078e                	slli	a5,a5,0x3
    80003d5e:	963e                	add	a2,a2,a5
    80003d60:	e204                	sd	s1,0(a2)
      return fd;
    80003d62:	b7f5                	j	80003d4e <fdalloc+0x28>

0000000080003d64 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003d64:	715d                	addi	sp,sp,-80
    80003d66:	e486                	sd	ra,72(sp)
    80003d68:	e0a2                	sd	s0,64(sp)
    80003d6a:	fc26                	sd	s1,56(sp)
    80003d6c:	f84a                	sd	s2,48(sp)
    80003d6e:	f44e                	sd	s3,40(sp)
    80003d70:	ec56                	sd	s5,24(sp)
    80003d72:	e85a                	sd	s6,16(sp)
    80003d74:	0880                	addi	s0,sp,80
    80003d76:	8b2e                	mv	s6,a1
    80003d78:	89b2                	mv	s3,a2
    80003d7a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d7c:	fb040593          	addi	a1,s0,-80
    80003d80:	ffdfe0ef          	jal	80002d7c <nameiparent>
    80003d84:	84aa                	mv	s1,a0
    80003d86:	10050a63          	beqz	a0,80003e9a <create+0x136>
    return 0;

  ilock(dp);
    80003d8a:	8e9fe0ef          	jal	80002672 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d8e:	4601                	li	a2,0
    80003d90:	fb040593          	addi	a1,s0,-80
    80003d94:	8526                	mv	a0,s1
    80003d96:	d41fe0ef          	jal	80002ad6 <dirlookup>
    80003d9a:	8aaa                	mv	s5,a0
    80003d9c:	c129                	beqz	a0,80003dde <create+0x7a>
    iunlockput(dp);
    80003d9e:	8526                	mv	a0,s1
    80003da0:	addfe0ef          	jal	8000287c <iunlockput>
    ilock(ip);
    80003da4:	8556                	mv	a0,s5
    80003da6:	8cdfe0ef          	jal	80002672 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003daa:	4789                	li	a5,2
    80003dac:	02fb1463          	bne	s6,a5,80003dd4 <create+0x70>
    80003db0:	044ad783          	lhu	a5,68(s5)
    80003db4:	37f9                	addiw	a5,a5,-2
    80003db6:	17c2                	slli	a5,a5,0x30
    80003db8:	93c1                	srli	a5,a5,0x30
    80003dba:	4705                	li	a4,1
    80003dbc:	00f76c63          	bltu	a4,a5,80003dd4 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003dc0:	8556                	mv	a0,s5
    80003dc2:	60a6                	ld	ra,72(sp)
    80003dc4:	6406                	ld	s0,64(sp)
    80003dc6:	74e2                	ld	s1,56(sp)
    80003dc8:	7942                	ld	s2,48(sp)
    80003dca:	79a2                	ld	s3,40(sp)
    80003dcc:	6ae2                	ld	s5,24(sp)
    80003dce:	6b42                	ld	s6,16(sp)
    80003dd0:	6161                	addi	sp,sp,80
    80003dd2:	8082                	ret
    iunlockput(ip);
    80003dd4:	8556                	mv	a0,s5
    80003dd6:	aa7fe0ef          	jal	8000287c <iunlockput>
    return 0;
    80003dda:	4a81                	li	s5,0
    80003ddc:	b7d5                	j	80003dc0 <create+0x5c>
    80003dde:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003de0:	85da                	mv	a1,s6
    80003de2:	4088                	lw	a0,0(s1)
    80003de4:	f1efe0ef          	jal	80002502 <ialloc>
    80003de8:	8a2a                	mv	s4,a0
    80003dea:	cd15                	beqz	a0,80003e26 <create+0xc2>
  ilock(ip);
    80003dec:	887fe0ef          	jal	80002672 <ilock>
  ip->major = major;
    80003df0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003df4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003df8:	4905                	li	s2,1
    80003dfa:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003dfe:	8552                	mv	a0,s4
    80003e00:	fbefe0ef          	jal	800025be <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003e04:	032b0763          	beq	s6,s2,80003e32 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e08:	004a2603          	lw	a2,4(s4)
    80003e0c:	fb040593          	addi	a1,s0,-80
    80003e10:	8526                	mv	a0,s1
    80003e12:	ea7fe0ef          	jal	80002cb8 <dirlink>
    80003e16:	06054563          	bltz	a0,80003e80 <create+0x11c>
  iunlockput(dp);
    80003e1a:	8526                	mv	a0,s1
    80003e1c:	a61fe0ef          	jal	8000287c <iunlockput>
  return ip;
    80003e20:	8ad2                	mv	s5,s4
    80003e22:	7a02                	ld	s4,32(sp)
    80003e24:	bf71                	j	80003dc0 <create+0x5c>
    iunlockput(dp);
    80003e26:	8526                	mv	a0,s1
    80003e28:	a55fe0ef          	jal	8000287c <iunlockput>
    return 0;
    80003e2c:	8ad2                	mv	s5,s4
    80003e2e:	7a02                	ld	s4,32(sp)
    80003e30:	bf41                	j	80003dc0 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003e32:	004a2603          	lw	a2,4(s4)
    80003e36:	00004597          	auipc	a1,0x4
    80003e3a:	84258593          	addi	a1,a1,-1982 # 80007678 <etext+0x678>
    80003e3e:	8552                	mv	a0,s4
    80003e40:	e79fe0ef          	jal	80002cb8 <dirlink>
    80003e44:	02054e63          	bltz	a0,80003e80 <create+0x11c>
    80003e48:	40d0                	lw	a2,4(s1)
    80003e4a:	00004597          	auipc	a1,0x4
    80003e4e:	83658593          	addi	a1,a1,-1994 # 80007680 <etext+0x680>
    80003e52:	8552                	mv	a0,s4
    80003e54:	e65fe0ef          	jal	80002cb8 <dirlink>
    80003e58:	02054463          	bltz	a0,80003e80 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e5c:	004a2603          	lw	a2,4(s4)
    80003e60:	fb040593          	addi	a1,s0,-80
    80003e64:	8526                	mv	a0,s1
    80003e66:	e53fe0ef          	jal	80002cb8 <dirlink>
    80003e6a:	00054b63          	bltz	a0,80003e80 <create+0x11c>
    dp->nlink++;  // for ".."
    80003e6e:	04a4d783          	lhu	a5,74(s1)
    80003e72:	2785                	addiw	a5,a5,1
    80003e74:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e78:	8526                	mv	a0,s1
    80003e7a:	f44fe0ef          	jal	800025be <iupdate>
    80003e7e:	bf71                	j	80003e1a <create+0xb6>
  ip->nlink = 0;
    80003e80:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e84:	8552                	mv	a0,s4
    80003e86:	f38fe0ef          	jal	800025be <iupdate>
  iunlockput(ip);
    80003e8a:	8552                	mv	a0,s4
    80003e8c:	9f1fe0ef          	jal	8000287c <iunlockput>
  iunlockput(dp);
    80003e90:	8526                	mv	a0,s1
    80003e92:	9ebfe0ef          	jal	8000287c <iunlockput>
  return 0;
    80003e96:	7a02                	ld	s4,32(sp)
    80003e98:	b725                	j	80003dc0 <create+0x5c>
    return 0;
    80003e9a:	8aaa                	mv	s5,a0
    80003e9c:	b715                	j	80003dc0 <create+0x5c>

0000000080003e9e <sys_dup>:
{
    80003e9e:	7179                	addi	sp,sp,-48
    80003ea0:	f406                	sd	ra,40(sp)
    80003ea2:	f022                	sd	s0,32(sp)
    80003ea4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003ea6:	fd840613          	addi	a2,s0,-40
    80003eaa:	4581                	li	a1,0
    80003eac:	4501                	li	a0,0
    80003eae:	e21ff0ef          	jal	80003cce <argfd>
    return -1;
    80003eb2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003eb4:	02054363          	bltz	a0,80003eda <sys_dup+0x3c>
    80003eb8:	ec26                	sd	s1,24(sp)
    80003eba:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003ebc:	fd843903          	ld	s2,-40(s0)
    80003ec0:	854a                	mv	a0,s2
    80003ec2:	e65ff0ef          	jal	80003d26 <fdalloc>
    80003ec6:	84aa                	mv	s1,a0
    return -1;
    80003ec8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003eca:	00054d63          	bltz	a0,80003ee4 <sys_dup+0x46>
  filedup(f);
    80003ece:	854a                	mv	a0,s2
    80003ed0:	c2eff0ef          	jal	800032fe <filedup>
  return fd;
    80003ed4:	87a6                	mv	a5,s1
    80003ed6:	64e2                	ld	s1,24(sp)
    80003ed8:	6942                	ld	s2,16(sp)
}
    80003eda:	853e                	mv	a0,a5
    80003edc:	70a2                	ld	ra,40(sp)
    80003ede:	7402                	ld	s0,32(sp)
    80003ee0:	6145                	addi	sp,sp,48
    80003ee2:	8082                	ret
    80003ee4:	64e2                	ld	s1,24(sp)
    80003ee6:	6942                	ld	s2,16(sp)
    80003ee8:	bfcd                	j	80003eda <sys_dup+0x3c>

0000000080003eea <sys_read>:
{
    80003eea:	7179                	addi	sp,sp,-48
    80003eec:	f406                	sd	ra,40(sp)
    80003eee:	f022                	sd	s0,32(sp)
    80003ef0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ef2:	fd840593          	addi	a1,s0,-40
    80003ef6:	4505                	li	a0,1
    80003ef8:	d3ffd0ef          	jal	80001c36 <argaddr>
  argint(2, &n);
    80003efc:	fe440593          	addi	a1,s0,-28
    80003f00:	4509                	li	a0,2
    80003f02:	d19fd0ef          	jal	80001c1a <argint>
  if(argfd(0, 0, &f) < 0)
    80003f06:	fe840613          	addi	a2,s0,-24
    80003f0a:	4581                	li	a1,0
    80003f0c:	4501                	li	a0,0
    80003f0e:	dc1ff0ef          	jal	80003cce <argfd>
    80003f12:	87aa                	mv	a5,a0
    return -1;
    80003f14:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f16:	0007ca63          	bltz	a5,80003f2a <sys_read+0x40>
  return fileread(f, p, n);
    80003f1a:	fe442603          	lw	a2,-28(s0)
    80003f1e:	fd843583          	ld	a1,-40(s0)
    80003f22:	fe843503          	ld	a0,-24(s0)
    80003f26:	d3eff0ef          	jal	80003464 <fileread>
}
    80003f2a:	70a2                	ld	ra,40(sp)
    80003f2c:	7402                	ld	s0,32(sp)
    80003f2e:	6145                	addi	sp,sp,48
    80003f30:	8082                	ret

0000000080003f32 <sys_write>:
{
    80003f32:	7179                	addi	sp,sp,-48
    80003f34:	f406                	sd	ra,40(sp)
    80003f36:	f022                	sd	s0,32(sp)
    80003f38:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f3a:	fd840593          	addi	a1,s0,-40
    80003f3e:	4505                	li	a0,1
    80003f40:	cf7fd0ef          	jal	80001c36 <argaddr>
  argint(2, &n);
    80003f44:	fe440593          	addi	a1,s0,-28
    80003f48:	4509                	li	a0,2
    80003f4a:	cd1fd0ef          	jal	80001c1a <argint>
  if(argfd(0, 0, &f) < 0)
    80003f4e:	fe840613          	addi	a2,s0,-24
    80003f52:	4581                	li	a1,0
    80003f54:	4501                	li	a0,0
    80003f56:	d79ff0ef          	jal	80003cce <argfd>
    80003f5a:	87aa                	mv	a5,a0
    return -1;
    80003f5c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f5e:	0007ca63          	bltz	a5,80003f72 <sys_write+0x40>
  return filewrite(f, p, n);
    80003f62:	fe442603          	lw	a2,-28(s0)
    80003f66:	fd843583          	ld	a1,-40(s0)
    80003f6a:	fe843503          	ld	a0,-24(s0)
    80003f6e:	db4ff0ef          	jal	80003522 <filewrite>
}
    80003f72:	70a2                	ld	ra,40(sp)
    80003f74:	7402                	ld	s0,32(sp)
    80003f76:	6145                	addi	sp,sp,48
    80003f78:	8082                	ret

0000000080003f7a <sys_close>:
{
    80003f7a:	1101                	addi	sp,sp,-32
    80003f7c:	ec06                	sd	ra,24(sp)
    80003f7e:	e822                	sd	s0,16(sp)
    80003f80:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f82:	fe040613          	addi	a2,s0,-32
    80003f86:	fec40593          	addi	a1,s0,-20
    80003f8a:	4501                	li	a0,0
    80003f8c:	d43ff0ef          	jal	80003cce <argfd>
    return -1;
    80003f90:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f92:	02054063          	bltz	a0,80003fb2 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f96:	dc7fc0ef          	jal	80000d5c <myproc>
    80003f9a:	fec42783          	lw	a5,-20(s0)
    80003f9e:	07e9                	addi	a5,a5,26
    80003fa0:	078e                	slli	a5,a5,0x3
    80003fa2:	953e                	add	a0,a0,a5
    80003fa4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003fa8:	fe043503          	ld	a0,-32(s0)
    80003fac:	b98ff0ef          	jal	80003344 <fileclose>
  return 0;
    80003fb0:	4781                	li	a5,0
}
    80003fb2:	853e                	mv	a0,a5
    80003fb4:	60e2                	ld	ra,24(sp)
    80003fb6:	6442                	ld	s0,16(sp)
    80003fb8:	6105                	addi	sp,sp,32
    80003fba:	8082                	ret

0000000080003fbc <sys_fstat>:
{
    80003fbc:	1101                	addi	sp,sp,-32
    80003fbe:	ec06                	sd	ra,24(sp)
    80003fc0:	e822                	sd	s0,16(sp)
    80003fc2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003fc4:	fe040593          	addi	a1,s0,-32
    80003fc8:	4505                	li	a0,1
    80003fca:	c6dfd0ef          	jal	80001c36 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003fce:	fe840613          	addi	a2,s0,-24
    80003fd2:	4581                	li	a1,0
    80003fd4:	4501                	li	a0,0
    80003fd6:	cf9ff0ef          	jal	80003cce <argfd>
    80003fda:	87aa                	mv	a5,a0
    return -1;
    80003fdc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fde:	0007c863          	bltz	a5,80003fee <sys_fstat+0x32>
  return filestat(f, st);
    80003fe2:	fe043583          	ld	a1,-32(s0)
    80003fe6:	fe843503          	ld	a0,-24(s0)
    80003fea:	c18ff0ef          	jal	80003402 <filestat>
}
    80003fee:	60e2                	ld	ra,24(sp)
    80003ff0:	6442                	ld	s0,16(sp)
    80003ff2:	6105                	addi	sp,sp,32
    80003ff4:	8082                	ret

0000000080003ff6 <sys_link>:
{
    80003ff6:	7169                	addi	sp,sp,-304
    80003ff8:	f606                	sd	ra,296(sp)
    80003ffa:	f222                	sd	s0,288(sp)
    80003ffc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003ffe:	08000613          	li	a2,128
    80004002:	ed040593          	addi	a1,s0,-304
    80004006:	4501                	li	a0,0
    80004008:	c4bfd0ef          	jal	80001c52 <argstr>
    return -1;
    8000400c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000400e:	0c054e63          	bltz	a0,800040ea <sys_link+0xf4>
    80004012:	08000613          	li	a2,128
    80004016:	f5040593          	addi	a1,s0,-176
    8000401a:	4505                	li	a0,1
    8000401c:	c37fd0ef          	jal	80001c52 <argstr>
    return -1;
    80004020:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004022:	0c054463          	bltz	a0,800040ea <sys_link+0xf4>
    80004026:	ee26                	sd	s1,280(sp)
  begin_op();
    80004028:	efdfe0ef          	jal	80002f24 <begin_op>
  if((ip = namei(old)) == 0){
    8000402c:	ed040513          	addi	a0,s0,-304
    80004030:	d33fe0ef          	jal	80002d62 <namei>
    80004034:	84aa                	mv	s1,a0
    80004036:	c53d                	beqz	a0,800040a4 <sys_link+0xae>
  ilock(ip);
    80004038:	e3afe0ef          	jal	80002672 <ilock>
  if(ip->type == T_DIR){
    8000403c:	04449703          	lh	a4,68(s1)
    80004040:	4785                	li	a5,1
    80004042:	06f70663          	beq	a4,a5,800040ae <sys_link+0xb8>
    80004046:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004048:	04a4d783          	lhu	a5,74(s1)
    8000404c:	2785                	addiw	a5,a5,1
    8000404e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004052:	8526                	mv	a0,s1
    80004054:	d6afe0ef          	jal	800025be <iupdate>
  iunlock(ip);
    80004058:	8526                	mv	a0,s1
    8000405a:	ec6fe0ef          	jal	80002720 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000405e:	fd040593          	addi	a1,s0,-48
    80004062:	f5040513          	addi	a0,s0,-176
    80004066:	d17fe0ef          	jal	80002d7c <nameiparent>
    8000406a:	892a                	mv	s2,a0
    8000406c:	cd21                	beqz	a0,800040c4 <sys_link+0xce>
  ilock(dp);
    8000406e:	e04fe0ef          	jal	80002672 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004072:	00092703          	lw	a4,0(s2)
    80004076:	409c                	lw	a5,0(s1)
    80004078:	04f71363          	bne	a4,a5,800040be <sys_link+0xc8>
    8000407c:	40d0                	lw	a2,4(s1)
    8000407e:	fd040593          	addi	a1,s0,-48
    80004082:	854a                	mv	a0,s2
    80004084:	c35fe0ef          	jal	80002cb8 <dirlink>
    80004088:	02054b63          	bltz	a0,800040be <sys_link+0xc8>
  iunlockput(dp);
    8000408c:	854a                	mv	a0,s2
    8000408e:	feefe0ef          	jal	8000287c <iunlockput>
  iput(ip);
    80004092:	8526                	mv	a0,s1
    80004094:	f60fe0ef          	jal	800027f4 <iput>
  end_op();
    80004098:	ef7fe0ef          	jal	80002f8e <end_op>
  return 0;
    8000409c:	4781                	li	a5,0
    8000409e:	64f2                	ld	s1,280(sp)
    800040a0:	6952                	ld	s2,272(sp)
    800040a2:	a0a1                	j	800040ea <sys_link+0xf4>
    end_op();
    800040a4:	eebfe0ef          	jal	80002f8e <end_op>
    return -1;
    800040a8:	57fd                	li	a5,-1
    800040aa:	64f2                	ld	s1,280(sp)
    800040ac:	a83d                	j	800040ea <sys_link+0xf4>
    iunlockput(ip);
    800040ae:	8526                	mv	a0,s1
    800040b0:	fccfe0ef          	jal	8000287c <iunlockput>
    end_op();
    800040b4:	edbfe0ef          	jal	80002f8e <end_op>
    return -1;
    800040b8:	57fd                	li	a5,-1
    800040ba:	64f2                	ld	s1,280(sp)
    800040bc:	a03d                	j	800040ea <sys_link+0xf4>
    iunlockput(dp);
    800040be:	854a                	mv	a0,s2
    800040c0:	fbcfe0ef          	jal	8000287c <iunlockput>
  ilock(ip);
    800040c4:	8526                	mv	a0,s1
    800040c6:	dacfe0ef          	jal	80002672 <ilock>
  ip->nlink--;
    800040ca:	04a4d783          	lhu	a5,74(s1)
    800040ce:	37fd                	addiw	a5,a5,-1
    800040d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800040d4:	8526                	mv	a0,s1
    800040d6:	ce8fe0ef          	jal	800025be <iupdate>
  iunlockput(ip);
    800040da:	8526                	mv	a0,s1
    800040dc:	fa0fe0ef          	jal	8000287c <iunlockput>
  end_op();
    800040e0:	eaffe0ef          	jal	80002f8e <end_op>
  return -1;
    800040e4:	57fd                	li	a5,-1
    800040e6:	64f2                	ld	s1,280(sp)
    800040e8:	6952                	ld	s2,272(sp)
}
    800040ea:	853e                	mv	a0,a5
    800040ec:	70b2                	ld	ra,296(sp)
    800040ee:	7412                	ld	s0,288(sp)
    800040f0:	6155                	addi	sp,sp,304
    800040f2:	8082                	ret

00000000800040f4 <sys_unlink>:
{
    800040f4:	7111                	addi	sp,sp,-256
    800040f6:	fd86                	sd	ra,248(sp)
    800040f8:	f9a2                	sd	s0,240(sp)
    800040fa:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800040fc:	08000613          	li	a2,128
    80004100:	f2040593          	addi	a1,s0,-224
    80004104:	4501                	li	a0,0
    80004106:	b4dfd0ef          	jal	80001c52 <argstr>
    8000410a:	16054663          	bltz	a0,80004276 <sys_unlink+0x182>
    8000410e:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004110:	e15fe0ef          	jal	80002f24 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004114:	fa040593          	addi	a1,s0,-96
    80004118:	f2040513          	addi	a0,s0,-224
    8000411c:	c61fe0ef          	jal	80002d7c <nameiparent>
    80004120:	84aa                	mv	s1,a0
    80004122:	c955                	beqz	a0,800041d6 <sys_unlink+0xe2>
  ilock(dp);
    80004124:	d4efe0ef          	jal	80002672 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004128:	00003597          	auipc	a1,0x3
    8000412c:	55058593          	addi	a1,a1,1360 # 80007678 <etext+0x678>
    80004130:	fa040513          	addi	a0,s0,-96
    80004134:	98dfe0ef          	jal	80002ac0 <namecmp>
    80004138:	12050463          	beqz	a0,80004260 <sys_unlink+0x16c>
    8000413c:	00003597          	auipc	a1,0x3
    80004140:	54458593          	addi	a1,a1,1348 # 80007680 <etext+0x680>
    80004144:	fa040513          	addi	a0,s0,-96
    80004148:	979fe0ef          	jal	80002ac0 <namecmp>
    8000414c:	10050a63          	beqz	a0,80004260 <sys_unlink+0x16c>
    80004150:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004152:	f1c40613          	addi	a2,s0,-228
    80004156:	fa040593          	addi	a1,s0,-96
    8000415a:	8526                	mv	a0,s1
    8000415c:	97bfe0ef          	jal	80002ad6 <dirlookup>
    80004160:	892a                	mv	s2,a0
    80004162:	0e050e63          	beqz	a0,8000425e <sys_unlink+0x16a>
    80004166:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004168:	d0afe0ef          	jal	80002672 <ilock>
  if(ip->nlink < 1)
    8000416c:	04a91783          	lh	a5,74(s2)
    80004170:	06f05863          	blez	a5,800041e0 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004174:	04491703          	lh	a4,68(s2)
    80004178:	4785                	li	a5,1
    8000417a:	06f70b63          	beq	a4,a5,800041f0 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    8000417e:	fb040993          	addi	s3,s0,-80
    80004182:	4641                	li	a2,16
    80004184:	4581                	li	a1,0
    80004186:	854e                	mv	a0,s3
    80004188:	fc7fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000418c:	4741                	li	a4,16
    8000418e:	f1c42683          	lw	a3,-228(s0)
    80004192:	864e                	mv	a2,s3
    80004194:	4581                	li	a1,0
    80004196:	8526                	mv	a0,s1
    80004198:	825fe0ef          	jal	800029bc <writei>
    8000419c:	47c1                	li	a5,16
    8000419e:	08f51f63          	bne	a0,a5,8000423c <sys_unlink+0x148>
  if(ip->type == T_DIR){
    800041a2:	04491703          	lh	a4,68(s2)
    800041a6:	4785                	li	a5,1
    800041a8:	0af70263          	beq	a4,a5,8000424c <sys_unlink+0x158>
  iunlockput(dp);
    800041ac:	8526                	mv	a0,s1
    800041ae:	ecefe0ef          	jal	8000287c <iunlockput>
  ip->nlink--;
    800041b2:	04a95783          	lhu	a5,74(s2)
    800041b6:	37fd                	addiw	a5,a5,-1
    800041b8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800041bc:	854a                	mv	a0,s2
    800041be:	c00fe0ef          	jal	800025be <iupdate>
  iunlockput(ip);
    800041c2:	854a                	mv	a0,s2
    800041c4:	eb8fe0ef          	jal	8000287c <iunlockput>
  end_op();
    800041c8:	dc7fe0ef          	jal	80002f8e <end_op>
  return 0;
    800041cc:	4501                	li	a0,0
    800041ce:	74ae                	ld	s1,232(sp)
    800041d0:	790e                	ld	s2,224(sp)
    800041d2:	69ee                	ld	s3,216(sp)
    800041d4:	a869                	j	8000426e <sys_unlink+0x17a>
    end_op();
    800041d6:	db9fe0ef          	jal	80002f8e <end_op>
    return -1;
    800041da:	557d                	li	a0,-1
    800041dc:	74ae                	ld	s1,232(sp)
    800041de:	a841                	j	8000426e <sys_unlink+0x17a>
    800041e0:	e9d2                	sd	s4,208(sp)
    800041e2:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    800041e4:	00003517          	auipc	a0,0x3
    800041e8:	4a450513          	addi	a0,a0,1188 # 80007688 <etext+0x688>
    800041ec:	26a010ef          	jal	80005456 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041f0:	04c92703          	lw	a4,76(s2)
    800041f4:	02000793          	li	a5,32
    800041f8:	f8e7f3e3          	bgeu	a5,a4,8000417e <sys_unlink+0x8a>
    800041fc:	e9d2                	sd	s4,208(sp)
    800041fe:	e5d6                	sd	s5,200(sp)
    80004200:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004202:	f0840a93          	addi	s5,s0,-248
    80004206:	4a41                	li	s4,16
    80004208:	8752                	mv	a4,s4
    8000420a:	86ce                	mv	a3,s3
    8000420c:	8656                	mv	a2,s5
    8000420e:	4581                	li	a1,0
    80004210:	854a                	mv	a0,s2
    80004212:	eb8fe0ef          	jal	800028ca <readi>
    80004216:	01451d63          	bne	a0,s4,80004230 <sys_unlink+0x13c>
    if(de.inum != 0)
    8000421a:	f0845783          	lhu	a5,-248(s0)
    8000421e:	efb1                	bnez	a5,8000427a <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004220:	29c1                	addiw	s3,s3,16
    80004222:	04c92783          	lw	a5,76(s2)
    80004226:	fef9e1e3          	bltu	s3,a5,80004208 <sys_unlink+0x114>
    8000422a:	6a4e                	ld	s4,208(sp)
    8000422c:	6aae                	ld	s5,200(sp)
    8000422e:	bf81                	j	8000417e <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004230:	00003517          	auipc	a0,0x3
    80004234:	47050513          	addi	a0,a0,1136 # 800076a0 <etext+0x6a0>
    80004238:	21e010ef          	jal	80005456 <panic>
    8000423c:	e9d2                	sd	s4,208(sp)
    8000423e:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004240:	00003517          	auipc	a0,0x3
    80004244:	47850513          	addi	a0,a0,1144 # 800076b8 <etext+0x6b8>
    80004248:	20e010ef          	jal	80005456 <panic>
    dp->nlink--;
    8000424c:	04a4d783          	lhu	a5,74(s1)
    80004250:	37fd                	addiw	a5,a5,-1
    80004252:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004256:	8526                	mv	a0,s1
    80004258:	b66fe0ef          	jal	800025be <iupdate>
    8000425c:	bf81                	j	800041ac <sys_unlink+0xb8>
    8000425e:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004260:	8526                	mv	a0,s1
    80004262:	e1afe0ef          	jal	8000287c <iunlockput>
  end_op();
    80004266:	d29fe0ef          	jal	80002f8e <end_op>
  return -1;
    8000426a:	557d                	li	a0,-1
    8000426c:	74ae                	ld	s1,232(sp)
}
    8000426e:	70ee                	ld	ra,248(sp)
    80004270:	744e                	ld	s0,240(sp)
    80004272:	6111                	addi	sp,sp,256
    80004274:	8082                	ret
    return -1;
    80004276:	557d                	li	a0,-1
    80004278:	bfdd                	j	8000426e <sys_unlink+0x17a>
    iunlockput(ip);
    8000427a:	854a                	mv	a0,s2
    8000427c:	e00fe0ef          	jal	8000287c <iunlockput>
    goto bad;
    80004280:	790e                	ld	s2,224(sp)
    80004282:	69ee                	ld	s3,216(sp)
    80004284:	6a4e                	ld	s4,208(sp)
    80004286:	6aae                	ld	s5,200(sp)
    80004288:	bfe1                	j	80004260 <sys_unlink+0x16c>

000000008000428a <sys_open>:

uint64
sys_open(void)
{
    8000428a:	7131                	addi	sp,sp,-192
    8000428c:	fd06                	sd	ra,184(sp)
    8000428e:	f922                	sd	s0,176(sp)
    80004290:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004292:	f4c40593          	addi	a1,s0,-180
    80004296:	4505                	li	a0,1
    80004298:	983fd0ef          	jal	80001c1a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000429c:	08000613          	li	a2,128
    800042a0:	f5040593          	addi	a1,s0,-176
    800042a4:	4501                	li	a0,0
    800042a6:	9adfd0ef          	jal	80001c52 <argstr>
    800042aa:	87aa                	mv	a5,a0
    return -1;
    800042ac:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042ae:	0a07c363          	bltz	a5,80004354 <sys_open+0xca>
    800042b2:	f526                	sd	s1,168(sp)

  begin_op();
    800042b4:	c71fe0ef          	jal	80002f24 <begin_op>

  if(omode & O_CREATE){
    800042b8:	f4c42783          	lw	a5,-180(s0)
    800042bc:	2007f793          	andi	a5,a5,512
    800042c0:	c3dd                	beqz	a5,80004366 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800042c2:	4681                	li	a3,0
    800042c4:	4601                	li	a2,0
    800042c6:	4589                	li	a1,2
    800042c8:	f5040513          	addi	a0,s0,-176
    800042cc:	a99ff0ef          	jal	80003d64 <create>
    800042d0:	84aa                	mv	s1,a0
    if(ip == 0){
    800042d2:	c549                	beqz	a0,8000435c <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800042d4:	04449703          	lh	a4,68(s1)
    800042d8:	478d                	li	a5,3
    800042da:	00f71763          	bne	a4,a5,800042e8 <sys_open+0x5e>
    800042de:	0464d703          	lhu	a4,70(s1)
    800042e2:	47a5                	li	a5,9
    800042e4:	0ae7ee63          	bltu	a5,a4,800043a0 <sys_open+0x116>
    800042e8:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800042ea:	fb7fe0ef          	jal	800032a0 <filealloc>
    800042ee:	892a                	mv	s2,a0
    800042f0:	c561                	beqz	a0,800043b8 <sys_open+0x12e>
    800042f2:	ed4e                	sd	s3,152(sp)
    800042f4:	a33ff0ef          	jal	80003d26 <fdalloc>
    800042f8:	89aa                	mv	s3,a0
    800042fa:	0a054b63          	bltz	a0,800043b0 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800042fe:	04449703          	lh	a4,68(s1)
    80004302:	478d                	li	a5,3
    80004304:	0cf70363          	beq	a4,a5,800043ca <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004308:	4789                	li	a5,2
    8000430a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000430e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004312:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004316:	f4c42783          	lw	a5,-180(s0)
    8000431a:	0017f713          	andi	a4,a5,1
    8000431e:	00174713          	xori	a4,a4,1
    80004322:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004326:	0037f713          	andi	a4,a5,3
    8000432a:	00e03733          	snez	a4,a4
    8000432e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004332:	4007f793          	andi	a5,a5,1024
    80004336:	c791                	beqz	a5,80004342 <sys_open+0xb8>
    80004338:	04449703          	lh	a4,68(s1)
    8000433c:	4789                	li	a5,2
    8000433e:	08f70d63          	beq	a4,a5,800043d8 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004342:	8526                	mv	a0,s1
    80004344:	bdcfe0ef          	jal	80002720 <iunlock>
  end_op();
    80004348:	c47fe0ef          	jal	80002f8e <end_op>

  return fd;
    8000434c:	854e                	mv	a0,s3
    8000434e:	74aa                	ld	s1,168(sp)
    80004350:	790a                	ld	s2,160(sp)
    80004352:	69ea                	ld	s3,152(sp)
}
    80004354:	70ea                	ld	ra,184(sp)
    80004356:	744a                	ld	s0,176(sp)
    80004358:	6129                	addi	sp,sp,192
    8000435a:	8082                	ret
      end_op();
    8000435c:	c33fe0ef          	jal	80002f8e <end_op>
      return -1;
    80004360:	557d                	li	a0,-1
    80004362:	74aa                	ld	s1,168(sp)
    80004364:	bfc5                	j	80004354 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004366:	f5040513          	addi	a0,s0,-176
    8000436a:	9f9fe0ef          	jal	80002d62 <namei>
    8000436e:	84aa                	mv	s1,a0
    80004370:	c11d                	beqz	a0,80004396 <sys_open+0x10c>
    ilock(ip);
    80004372:	b00fe0ef          	jal	80002672 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004376:	04449703          	lh	a4,68(s1)
    8000437a:	4785                	li	a5,1
    8000437c:	f4f71ce3          	bne	a4,a5,800042d4 <sys_open+0x4a>
    80004380:	f4c42783          	lw	a5,-180(s0)
    80004384:	d3b5                	beqz	a5,800042e8 <sys_open+0x5e>
      iunlockput(ip);
    80004386:	8526                	mv	a0,s1
    80004388:	cf4fe0ef          	jal	8000287c <iunlockput>
      end_op();
    8000438c:	c03fe0ef          	jal	80002f8e <end_op>
      return -1;
    80004390:	557d                	li	a0,-1
    80004392:	74aa                	ld	s1,168(sp)
    80004394:	b7c1                	j	80004354 <sys_open+0xca>
      end_op();
    80004396:	bf9fe0ef          	jal	80002f8e <end_op>
      return -1;
    8000439a:	557d                	li	a0,-1
    8000439c:	74aa                	ld	s1,168(sp)
    8000439e:	bf5d                	j	80004354 <sys_open+0xca>
    iunlockput(ip);
    800043a0:	8526                	mv	a0,s1
    800043a2:	cdafe0ef          	jal	8000287c <iunlockput>
    end_op();
    800043a6:	be9fe0ef          	jal	80002f8e <end_op>
    return -1;
    800043aa:	557d                	li	a0,-1
    800043ac:	74aa                	ld	s1,168(sp)
    800043ae:	b75d                	j	80004354 <sys_open+0xca>
      fileclose(f);
    800043b0:	854a                	mv	a0,s2
    800043b2:	f93fe0ef          	jal	80003344 <fileclose>
    800043b6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800043b8:	8526                	mv	a0,s1
    800043ba:	cc2fe0ef          	jal	8000287c <iunlockput>
    end_op();
    800043be:	bd1fe0ef          	jal	80002f8e <end_op>
    return -1;
    800043c2:	557d                	li	a0,-1
    800043c4:	74aa                	ld	s1,168(sp)
    800043c6:	790a                	ld	s2,160(sp)
    800043c8:	b771                	j	80004354 <sys_open+0xca>
    f->type = FD_DEVICE;
    800043ca:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800043ce:	04649783          	lh	a5,70(s1)
    800043d2:	02f91223          	sh	a5,36(s2)
    800043d6:	bf35                	j	80004312 <sys_open+0x88>
    itrunc(ip);
    800043d8:	8526                	mv	a0,s1
    800043da:	b86fe0ef          	jal	80002760 <itrunc>
    800043de:	b795                	j	80004342 <sys_open+0xb8>

00000000800043e0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800043e0:	7175                	addi	sp,sp,-144
    800043e2:	e506                	sd	ra,136(sp)
    800043e4:	e122                	sd	s0,128(sp)
    800043e6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800043e8:	b3dfe0ef          	jal	80002f24 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800043ec:	08000613          	li	a2,128
    800043f0:	f7040593          	addi	a1,s0,-144
    800043f4:	4501                	li	a0,0
    800043f6:	85dfd0ef          	jal	80001c52 <argstr>
    800043fa:	02054363          	bltz	a0,80004420 <sys_mkdir+0x40>
    800043fe:	4681                	li	a3,0
    80004400:	4601                	li	a2,0
    80004402:	4585                	li	a1,1
    80004404:	f7040513          	addi	a0,s0,-144
    80004408:	95dff0ef          	jal	80003d64 <create>
    8000440c:	c911                	beqz	a0,80004420 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000440e:	c6efe0ef          	jal	8000287c <iunlockput>
  end_op();
    80004412:	b7dfe0ef          	jal	80002f8e <end_op>
  return 0;
    80004416:	4501                	li	a0,0
}
    80004418:	60aa                	ld	ra,136(sp)
    8000441a:	640a                	ld	s0,128(sp)
    8000441c:	6149                	addi	sp,sp,144
    8000441e:	8082                	ret
    end_op();
    80004420:	b6ffe0ef          	jal	80002f8e <end_op>
    return -1;
    80004424:	557d                	li	a0,-1
    80004426:	bfcd                	j	80004418 <sys_mkdir+0x38>

0000000080004428 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004428:	7135                	addi	sp,sp,-160
    8000442a:	ed06                	sd	ra,152(sp)
    8000442c:	e922                	sd	s0,144(sp)
    8000442e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004430:	af5fe0ef          	jal	80002f24 <begin_op>
  argint(1, &major);
    80004434:	f6c40593          	addi	a1,s0,-148
    80004438:	4505                	li	a0,1
    8000443a:	fe0fd0ef          	jal	80001c1a <argint>
  argint(2, &minor);
    8000443e:	f6840593          	addi	a1,s0,-152
    80004442:	4509                	li	a0,2
    80004444:	fd6fd0ef          	jal	80001c1a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004448:	08000613          	li	a2,128
    8000444c:	f7040593          	addi	a1,s0,-144
    80004450:	4501                	li	a0,0
    80004452:	801fd0ef          	jal	80001c52 <argstr>
    80004456:	02054563          	bltz	a0,80004480 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000445a:	f6841683          	lh	a3,-152(s0)
    8000445e:	f6c41603          	lh	a2,-148(s0)
    80004462:	458d                	li	a1,3
    80004464:	f7040513          	addi	a0,s0,-144
    80004468:	8fdff0ef          	jal	80003d64 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000446c:	c911                	beqz	a0,80004480 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000446e:	c0efe0ef          	jal	8000287c <iunlockput>
  end_op();
    80004472:	b1dfe0ef          	jal	80002f8e <end_op>
  return 0;
    80004476:	4501                	li	a0,0
}
    80004478:	60ea                	ld	ra,152(sp)
    8000447a:	644a                	ld	s0,144(sp)
    8000447c:	610d                	addi	sp,sp,160
    8000447e:	8082                	ret
    end_op();
    80004480:	b0ffe0ef          	jal	80002f8e <end_op>
    return -1;
    80004484:	557d                	li	a0,-1
    80004486:	bfcd                	j	80004478 <sys_mknod+0x50>

0000000080004488 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004488:	7135                	addi	sp,sp,-160
    8000448a:	ed06                	sd	ra,152(sp)
    8000448c:	e922                	sd	s0,144(sp)
    8000448e:	e14a                	sd	s2,128(sp)
    80004490:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004492:	8cbfc0ef          	jal	80000d5c <myproc>
    80004496:	892a                	mv	s2,a0
  
  begin_op();
    80004498:	a8dfe0ef          	jal	80002f24 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000449c:	08000613          	li	a2,128
    800044a0:	f6040593          	addi	a1,s0,-160
    800044a4:	4501                	li	a0,0
    800044a6:	facfd0ef          	jal	80001c52 <argstr>
    800044aa:	04054363          	bltz	a0,800044f0 <sys_chdir+0x68>
    800044ae:	e526                	sd	s1,136(sp)
    800044b0:	f6040513          	addi	a0,s0,-160
    800044b4:	8affe0ef          	jal	80002d62 <namei>
    800044b8:	84aa                	mv	s1,a0
    800044ba:	c915                	beqz	a0,800044ee <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800044bc:	9b6fe0ef          	jal	80002672 <ilock>
  if(ip->type != T_DIR){
    800044c0:	04449703          	lh	a4,68(s1)
    800044c4:	4785                	li	a5,1
    800044c6:	02f71963          	bne	a4,a5,800044f8 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800044ca:	8526                	mv	a0,s1
    800044cc:	a54fe0ef          	jal	80002720 <iunlock>
  iput(p->cwd);
    800044d0:	15093503          	ld	a0,336(s2)
    800044d4:	b20fe0ef          	jal	800027f4 <iput>
  end_op();
    800044d8:	ab7fe0ef          	jal	80002f8e <end_op>
  p->cwd = ip;
    800044dc:	14993823          	sd	s1,336(s2)
  return 0;
    800044e0:	4501                	li	a0,0
    800044e2:	64aa                	ld	s1,136(sp)
}
    800044e4:	60ea                	ld	ra,152(sp)
    800044e6:	644a                	ld	s0,144(sp)
    800044e8:	690a                	ld	s2,128(sp)
    800044ea:	610d                	addi	sp,sp,160
    800044ec:	8082                	ret
    800044ee:	64aa                	ld	s1,136(sp)
    end_op();
    800044f0:	a9ffe0ef          	jal	80002f8e <end_op>
    return -1;
    800044f4:	557d                	li	a0,-1
    800044f6:	b7fd                	j	800044e4 <sys_chdir+0x5c>
    iunlockput(ip);
    800044f8:	8526                	mv	a0,s1
    800044fa:	b82fe0ef          	jal	8000287c <iunlockput>
    end_op();
    800044fe:	a91fe0ef          	jal	80002f8e <end_op>
    return -1;
    80004502:	557d                	li	a0,-1
    80004504:	64aa                	ld	s1,136(sp)
    80004506:	bff9                	j	800044e4 <sys_chdir+0x5c>

0000000080004508 <sys_exec>:

uint64
sys_exec(void)
{
    80004508:	7105                	addi	sp,sp,-480
    8000450a:	ef86                	sd	ra,472(sp)
    8000450c:	eba2                	sd	s0,464(sp)
    8000450e:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004510:	e2840593          	addi	a1,s0,-472
    80004514:	4505                	li	a0,1
    80004516:	f20fd0ef          	jal	80001c36 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000451a:	08000613          	li	a2,128
    8000451e:	f3040593          	addi	a1,s0,-208
    80004522:	4501                	li	a0,0
    80004524:	f2efd0ef          	jal	80001c52 <argstr>
    80004528:	87aa                	mv	a5,a0
    return -1;
    8000452a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000452c:	0e07c063          	bltz	a5,8000460c <sys_exec+0x104>
    80004530:	e7a6                	sd	s1,456(sp)
    80004532:	e3ca                	sd	s2,448(sp)
    80004534:	ff4e                	sd	s3,440(sp)
    80004536:	fb52                	sd	s4,432(sp)
    80004538:	f756                	sd	s5,424(sp)
    8000453a:	f35a                	sd	s6,416(sp)
    8000453c:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000453e:	e3040a13          	addi	s4,s0,-464
    80004542:	10000613          	li	a2,256
    80004546:	4581                	li	a1,0
    80004548:	8552                	mv	a0,s4
    8000454a:	c05fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000454e:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004550:	89d2                	mv	s3,s4
    80004552:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004554:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004558:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000455a:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000455e:	00391513          	slli	a0,s2,0x3
    80004562:	85d6                	mv	a1,s5
    80004564:	e2843783          	ld	a5,-472(s0)
    80004568:	953e                	add	a0,a0,a5
    8000456a:	e26fd0ef          	jal	80001b90 <fetchaddr>
    8000456e:	02054663          	bltz	a0,8000459a <sys_exec+0x92>
    if(uarg == 0){
    80004572:	e2043783          	ld	a5,-480(s0)
    80004576:	c7a1                	beqz	a5,800045be <sys_exec+0xb6>
    argv[i] = kalloc();
    80004578:	b87fb0ef          	jal	800000fe <kalloc>
    8000457c:	85aa                	mv	a1,a0
    8000457e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004582:	cd01                	beqz	a0,8000459a <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004584:	865a                	mv	a2,s6
    80004586:	e2043503          	ld	a0,-480(s0)
    8000458a:	e50fd0ef          	jal	80001bda <fetchstr>
    8000458e:	00054663          	bltz	a0,8000459a <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004592:	0905                	addi	s2,s2,1
    80004594:	09a1                	addi	s3,s3,8
    80004596:	fd7914e3          	bne	s2,s7,8000455e <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000459a:	100a0a13          	addi	s4,s4,256
    8000459e:	6088                	ld	a0,0(s1)
    800045a0:	cd31                	beqz	a0,800045fc <sys_exec+0xf4>
    kfree(argv[i]);
    800045a2:	a7bfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045a6:	04a1                	addi	s1,s1,8
    800045a8:	ff449be3          	bne	s1,s4,8000459e <sys_exec+0x96>
  return -1;
    800045ac:	557d                	li	a0,-1
    800045ae:	64be                	ld	s1,456(sp)
    800045b0:	691e                	ld	s2,448(sp)
    800045b2:	79fa                	ld	s3,440(sp)
    800045b4:	7a5a                	ld	s4,432(sp)
    800045b6:	7aba                	ld	s5,424(sp)
    800045b8:	7b1a                	ld	s6,416(sp)
    800045ba:	6bfa                	ld	s7,408(sp)
    800045bc:	a881                	j	8000460c <sys_exec+0x104>
      argv[i] = 0;
    800045be:	0009079b          	sext.w	a5,s2
    800045c2:	e3040593          	addi	a1,s0,-464
    800045c6:	078e                	slli	a5,a5,0x3
    800045c8:	97ae                	add	a5,a5,a1
    800045ca:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800045ce:	f3040513          	addi	a0,s0,-208
    800045d2:	ba4ff0ef          	jal	80003976 <exec>
    800045d6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045d8:	100a0a13          	addi	s4,s4,256
    800045dc:	6088                	ld	a0,0(s1)
    800045de:	c511                	beqz	a0,800045ea <sys_exec+0xe2>
    kfree(argv[i]);
    800045e0:	a3dfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045e4:	04a1                	addi	s1,s1,8
    800045e6:	ff449be3          	bne	s1,s4,800045dc <sys_exec+0xd4>
  return ret;
    800045ea:	854a                	mv	a0,s2
    800045ec:	64be                	ld	s1,456(sp)
    800045ee:	691e                	ld	s2,448(sp)
    800045f0:	79fa                	ld	s3,440(sp)
    800045f2:	7a5a                	ld	s4,432(sp)
    800045f4:	7aba                	ld	s5,424(sp)
    800045f6:	7b1a                	ld	s6,416(sp)
    800045f8:	6bfa                	ld	s7,408(sp)
    800045fa:	a809                	j	8000460c <sys_exec+0x104>
  return -1;
    800045fc:	557d                	li	a0,-1
    800045fe:	64be                	ld	s1,456(sp)
    80004600:	691e                	ld	s2,448(sp)
    80004602:	79fa                	ld	s3,440(sp)
    80004604:	7a5a                	ld	s4,432(sp)
    80004606:	7aba                	ld	s5,424(sp)
    80004608:	7b1a                	ld	s6,416(sp)
    8000460a:	6bfa                	ld	s7,408(sp)
}
    8000460c:	60fe                	ld	ra,472(sp)
    8000460e:	645e                	ld	s0,464(sp)
    80004610:	613d                	addi	sp,sp,480
    80004612:	8082                	ret

0000000080004614 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004614:	7139                	addi	sp,sp,-64
    80004616:	fc06                	sd	ra,56(sp)
    80004618:	f822                	sd	s0,48(sp)
    8000461a:	f426                	sd	s1,40(sp)
    8000461c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000461e:	f3efc0ef          	jal	80000d5c <myproc>
    80004622:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004624:	fd840593          	addi	a1,s0,-40
    80004628:	4501                	li	a0,0
    8000462a:	e0cfd0ef          	jal	80001c36 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000462e:	fc840593          	addi	a1,s0,-56
    80004632:	fd040513          	addi	a0,s0,-48
    80004636:	81eff0ef          	jal	80003654 <pipealloc>
    return -1;
    8000463a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000463c:	0a054463          	bltz	a0,800046e4 <sys_pipe+0xd0>
  fd0 = -1;
    80004640:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004644:	fd043503          	ld	a0,-48(s0)
    80004648:	edeff0ef          	jal	80003d26 <fdalloc>
    8000464c:	fca42223          	sw	a0,-60(s0)
    80004650:	08054163          	bltz	a0,800046d2 <sys_pipe+0xbe>
    80004654:	fc843503          	ld	a0,-56(s0)
    80004658:	eceff0ef          	jal	80003d26 <fdalloc>
    8000465c:	fca42023          	sw	a0,-64(s0)
    80004660:	06054063          	bltz	a0,800046c0 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004664:	4691                	li	a3,4
    80004666:	fc440613          	addi	a2,s0,-60
    8000466a:	fd843583          	ld	a1,-40(s0)
    8000466e:	68a8                	ld	a0,80(s1)
    80004670:	b94fc0ef          	jal	80000a04 <copyout>
    80004674:	00054e63          	bltz	a0,80004690 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004678:	4691                	li	a3,4
    8000467a:	fc040613          	addi	a2,s0,-64
    8000467e:	fd843583          	ld	a1,-40(s0)
    80004682:	95b6                	add	a1,a1,a3
    80004684:	68a8                	ld	a0,80(s1)
    80004686:	b7efc0ef          	jal	80000a04 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000468a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000468c:	04055c63          	bgez	a0,800046e4 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004690:	fc442783          	lw	a5,-60(s0)
    80004694:	07e9                	addi	a5,a5,26
    80004696:	078e                	slli	a5,a5,0x3
    80004698:	97a6                	add	a5,a5,s1
    8000469a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000469e:	fc042783          	lw	a5,-64(s0)
    800046a2:	07e9                	addi	a5,a5,26
    800046a4:	078e                	slli	a5,a5,0x3
    800046a6:	94be                	add	s1,s1,a5
    800046a8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800046ac:	fd043503          	ld	a0,-48(s0)
    800046b0:	c95fe0ef          	jal	80003344 <fileclose>
    fileclose(wf);
    800046b4:	fc843503          	ld	a0,-56(s0)
    800046b8:	c8dfe0ef          	jal	80003344 <fileclose>
    return -1;
    800046bc:	57fd                	li	a5,-1
    800046be:	a01d                	j	800046e4 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800046c0:	fc442783          	lw	a5,-60(s0)
    800046c4:	0007c763          	bltz	a5,800046d2 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800046c8:	07e9                	addi	a5,a5,26
    800046ca:	078e                	slli	a5,a5,0x3
    800046cc:	97a6                	add	a5,a5,s1
    800046ce:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800046d2:	fd043503          	ld	a0,-48(s0)
    800046d6:	c6ffe0ef          	jal	80003344 <fileclose>
    fileclose(wf);
    800046da:	fc843503          	ld	a0,-56(s0)
    800046de:	c67fe0ef          	jal	80003344 <fileclose>
    return -1;
    800046e2:	57fd                	li	a5,-1
}
    800046e4:	853e                	mv	a0,a5
    800046e6:	70e2                	ld	ra,56(sp)
    800046e8:	7442                	ld	s0,48(sp)
    800046ea:	74a2                	ld	s1,40(sp)
    800046ec:	6121                	addi	sp,sp,64
    800046ee:	8082                	ret

00000000800046f0 <kernelvec>:
    800046f0:	7111                	addi	sp,sp,-256
    800046f2:	e006                	sd	ra,0(sp)
    800046f4:	e40a                	sd	sp,8(sp)
    800046f6:	e80e                	sd	gp,16(sp)
    800046f8:	ec12                	sd	tp,24(sp)
    800046fa:	f016                	sd	t0,32(sp)
    800046fc:	f41a                	sd	t1,40(sp)
    800046fe:	f81e                	sd	t2,48(sp)
    80004700:	e4aa                	sd	a0,72(sp)
    80004702:	e8ae                	sd	a1,80(sp)
    80004704:	ecb2                	sd	a2,88(sp)
    80004706:	f0b6                	sd	a3,96(sp)
    80004708:	f4ba                	sd	a4,104(sp)
    8000470a:	f8be                	sd	a5,112(sp)
    8000470c:	fcc2                	sd	a6,120(sp)
    8000470e:	e146                	sd	a7,128(sp)
    80004710:	edf2                	sd	t3,216(sp)
    80004712:	f1f6                	sd	t4,224(sp)
    80004714:	f5fa                	sd	t5,232(sp)
    80004716:	f9fe                	sd	t6,240(sp)
    80004718:	b88fd0ef          	jal	80001aa0 <kerneltrap>
    8000471c:	6082                	ld	ra,0(sp)
    8000471e:	6122                	ld	sp,8(sp)
    80004720:	61c2                	ld	gp,16(sp)
    80004722:	7282                	ld	t0,32(sp)
    80004724:	7322                	ld	t1,40(sp)
    80004726:	73c2                	ld	t2,48(sp)
    80004728:	6526                	ld	a0,72(sp)
    8000472a:	65c6                	ld	a1,80(sp)
    8000472c:	6666                	ld	a2,88(sp)
    8000472e:	7686                	ld	a3,96(sp)
    80004730:	7726                	ld	a4,104(sp)
    80004732:	77c6                	ld	a5,112(sp)
    80004734:	7866                	ld	a6,120(sp)
    80004736:	688a                	ld	a7,128(sp)
    80004738:	6e6e                	ld	t3,216(sp)
    8000473a:	7e8e                	ld	t4,224(sp)
    8000473c:	7f2e                	ld	t5,232(sp)
    8000473e:	7fce                	ld	t6,240(sp)
    80004740:	6111                	addi	sp,sp,256
    80004742:	10200073          	sret
	...

000000008000474e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000474e:	1141                	addi	sp,sp,-16
    80004750:	e406                	sd	ra,8(sp)
    80004752:	e022                	sd	s0,0(sp)
    80004754:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004756:	0c000737          	lui	a4,0xc000
    8000475a:	4785                	li	a5,1
    8000475c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000475e:	c35c                	sw	a5,4(a4)
}
    80004760:	60a2                	ld	ra,8(sp)
    80004762:	6402                	ld	s0,0(sp)
    80004764:	0141                	addi	sp,sp,16
    80004766:	8082                	ret

0000000080004768 <plicinithart>:

void
plicinithart(void)
{
    80004768:	1141                	addi	sp,sp,-16
    8000476a:	e406                	sd	ra,8(sp)
    8000476c:	e022                	sd	s0,0(sp)
    8000476e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004770:	db8fc0ef          	jal	80000d28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004774:	0085171b          	slliw	a4,a0,0x8
    80004778:	0c0027b7          	lui	a5,0xc002
    8000477c:	97ba                	add	a5,a5,a4
    8000477e:	40200713          	li	a4,1026
    80004782:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004786:	00d5151b          	slliw	a0,a0,0xd
    8000478a:	0c2017b7          	lui	a5,0xc201
    8000478e:	97aa                	add	a5,a5,a0
    80004790:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004794:	60a2                	ld	ra,8(sp)
    80004796:	6402                	ld	s0,0(sp)
    80004798:	0141                	addi	sp,sp,16
    8000479a:	8082                	ret

000000008000479c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000479c:	1141                	addi	sp,sp,-16
    8000479e:	e406                	sd	ra,8(sp)
    800047a0:	e022                	sd	s0,0(sp)
    800047a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047a4:	d84fc0ef          	jal	80000d28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800047a8:	00d5151b          	slliw	a0,a0,0xd
    800047ac:	0c2017b7          	lui	a5,0xc201
    800047b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800047b2:	43c8                	lw	a0,4(a5)
    800047b4:	60a2                	ld	ra,8(sp)
    800047b6:	6402                	ld	s0,0(sp)
    800047b8:	0141                	addi	sp,sp,16
    800047ba:	8082                	ret

00000000800047bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800047bc:	1101                	addi	sp,sp,-32
    800047be:	ec06                	sd	ra,24(sp)
    800047c0:	e822                	sd	s0,16(sp)
    800047c2:	e426                	sd	s1,8(sp)
    800047c4:	1000                	addi	s0,sp,32
    800047c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800047c8:	d60fc0ef          	jal	80000d28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800047cc:	00d5179b          	slliw	a5,a0,0xd
    800047d0:	0c201737          	lui	a4,0xc201
    800047d4:	97ba                	add	a5,a5,a4
    800047d6:	c3c4                	sw	s1,4(a5)
}
    800047d8:	60e2                	ld	ra,24(sp)
    800047da:	6442                	ld	s0,16(sp)
    800047dc:	64a2                	ld	s1,8(sp)
    800047de:	6105                	addi	sp,sp,32
    800047e0:	8082                	ret

00000000800047e2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800047e2:	1141                	addi	sp,sp,-16
    800047e4:	e406                	sd	ra,8(sp)
    800047e6:	e022                	sd	s0,0(sp)
    800047e8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800047ea:	479d                	li	a5,7
    800047ec:	04a7ca63          	blt	a5,a0,80004840 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800047f0:	00017797          	auipc	a5,0x17
    800047f4:	f5078793          	addi	a5,a5,-176 # 8001b740 <disk>
    800047f8:	97aa                	add	a5,a5,a0
    800047fa:	0187c783          	lbu	a5,24(a5)
    800047fe:	e7b9                	bnez	a5,8000484c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004800:	00451693          	slli	a3,a0,0x4
    80004804:	00017797          	auipc	a5,0x17
    80004808:	f3c78793          	addi	a5,a5,-196 # 8001b740 <disk>
    8000480c:	6398                	ld	a4,0(a5)
    8000480e:	9736                	add	a4,a4,a3
    80004810:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004814:	6398                	ld	a4,0(a5)
    80004816:	9736                	add	a4,a4,a3
    80004818:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000481c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004820:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004824:	97aa                	add	a5,a5,a0
    80004826:	4705                	li	a4,1
    80004828:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000482c:	00017517          	auipc	a0,0x17
    80004830:	f2c50513          	addi	a0,a0,-212 # 8001b758 <disk+0x18>
    80004834:	b4ffc0ef          	jal	80001382 <wakeup>
}
    80004838:	60a2                	ld	ra,8(sp)
    8000483a:	6402                	ld	s0,0(sp)
    8000483c:	0141                	addi	sp,sp,16
    8000483e:	8082                	ret
    panic("free_desc 1");
    80004840:	00003517          	auipc	a0,0x3
    80004844:	e8850513          	addi	a0,a0,-376 # 800076c8 <etext+0x6c8>
    80004848:	40f000ef          	jal	80005456 <panic>
    panic("free_desc 2");
    8000484c:	00003517          	auipc	a0,0x3
    80004850:	e8c50513          	addi	a0,a0,-372 # 800076d8 <etext+0x6d8>
    80004854:	403000ef          	jal	80005456 <panic>

0000000080004858 <virtio_disk_init>:
{
    80004858:	1101                	addi	sp,sp,-32
    8000485a:	ec06                	sd	ra,24(sp)
    8000485c:	e822                	sd	s0,16(sp)
    8000485e:	e426                	sd	s1,8(sp)
    80004860:	e04a                	sd	s2,0(sp)
    80004862:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004864:	00003597          	auipc	a1,0x3
    80004868:	e8458593          	addi	a1,a1,-380 # 800076e8 <etext+0x6e8>
    8000486c:	00017517          	auipc	a0,0x17
    80004870:	ffc50513          	addi	a0,a0,-4 # 8001b868 <disk+0x128>
    80004874:	68d000ef          	jal	80005700 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004878:	100017b7          	lui	a5,0x10001
    8000487c:	4398                	lw	a4,0(a5)
    8000487e:	2701                	sext.w	a4,a4
    80004880:	747277b7          	lui	a5,0x74727
    80004884:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004888:	14f71863          	bne	a4,a5,800049d8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000488c:	100017b7          	lui	a5,0x10001
    80004890:	43dc                	lw	a5,4(a5)
    80004892:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004894:	4709                	li	a4,2
    80004896:	14e79163          	bne	a5,a4,800049d8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000489a:	100017b7          	lui	a5,0x10001
    8000489e:	479c                	lw	a5,8(a5)
    800048a0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048a2:	12e79b63          	bne	a5,a4,800049d8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800048a6:	100017b7          	lui	a5,0x10001
    800048aa:	47d8                	lw	a4,12(a5)
    800048ac:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048ae:	554d47b7          	lui	a5,0x554d4
    800048b2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800048b6:	12f71163          	bne	a4,a5,800049d8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048ba:	100017b7          	lui	a5,0x10001
    800048be:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048c2:	4705                	li	a4,1
    800048c4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048c6:	470d                	li	a4,3
    800048c8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800048ca:	10001737          	lui	a4,0x10001
    800048ce:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800048d0:	c7ffe6b7          	lui	a3,0xc7ffe
    800048d4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdaddf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800048d8:	8f75                	and	a4,a4,a3
    800048da:	100016b7          	lui	a3,0x10001
    800048de:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048e0:	472d                	li	a4,11
    800048e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048e4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800048e8:	439c                	lw	a5,0(a5)
    800048ea:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800048ee:	8ba1                	andi	a5,a5,8
    800048f0:	0e078a63          	beqz	a5,800049e4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800048f4:	100017b7          	lui	a5,0x10001
    800048f8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800048fc:	43fc                	lw	a5,68(a5)
    800048fe:	2781                	sext.w	a5,a5
    80004900:	0e079863          	bnez	a5,800049f0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004904:	100017b7          	lui	a5,0x10001
    80004908:	5bdc                	lw	a5,52(a5)
    8000490a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000490c:	0e078863          	beqz	a5,800049fc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004910:	471d                	li	a4,7
    80004912:	0ef77b63          	bgeu	a4,a5,80004a08 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004916:	fe8fb0ef          	jal	800000fe <kalloc>
    8000491a:	00017497          	auipc	s1,0x17
    8000491e:	e2648493          	addi	s1,s1,-474 # 8001b740 <disk>
    80004922:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004924:	fdafb0ef          	jal	800000fe <kalloc>
    80004928:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000492a:	fd4fb0ef          	jal	800000fe <kalloc>
    8000492e:	87aa                	mv	a5,a0
    80004930:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004932:	6088                	ld	a0,0(s1)
    80004934:	0e050063          	beqz	a0,80004a14 <virtio_disk_init+0x1bc>
    80004938:	00017717          	auipc	a4,0x17
    8000493c:	e1073703          	ld	a4,-496(a4) # 8001b748 <disk+0x8>
    80004940:	cb71                	beqz	a4,80004a14 <virtio_disk_init+0x1bc>
    80004942:	cbe9                	beqz	a5,80004a14 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004944:	6605                	lui	a2,0x1
    80004946:	4581                	li	a1,0
    80004948:	807fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    8000494c:	00017497          	auipc	s1,0x17
    80004950:	df448493          	addi	s1,s1,-524 # 8001b740 <disk>
    80004954:	6605                	lui	a2,0x1
    80004956:	4581                	li	a1,0
    80004958:	6488                	ld	a0,8(s1)
    8000495a:	ff4fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    8000495e:	6605                	lui	a2,0x1
    80004960:	4581                	li	a1,0
    80004962:	6888                	ld	a0,16(s1)
    80004964:	feafb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004968:	100017b7          	lui	a5,0x10001
    8000496c:	4721                	li	a4,8
    8000496e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004970:	4098                	lw	a4,0(s1)
    80004972:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004976:	40d8                	lw	a4,4(s1)
    80004978:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000497c:	649c                	ld	a5,8(s1)
    8000497e:	0007869b          	sext.w	a3,a5
    80004982:	10001737          	lui	a4,0x10001
    80004986:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000498a:	9781                	srai	a5,a5,0x20
    8000498c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004990:	689c                	ld	a5,16(s1)
    80004992:	0007869b          	sext.w	a3,a5
    80004996:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000499a:	9781                	srai	a5,a5,0x20
    8000499c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800049a0:	4785                	li	a5,1
    800049a2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800049a4:	00f48c23          	sb	a5,24(s1)
    800049a8:	00f48ca3          	sb	a5,25(s1)
    800049ac:	00f48d23          	sb	a5,26(s1)
    800049b0:	00f48da3          	sb	a5,27(s1)
    800049b4:	00f48e23          	sb	a5,28(s1)
    800049b8:	00f48ea3          	sb	a5,29(s1)
    800049bc:	00f48f23          	sb	a5,30(s1)
    800049c0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800049c4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800049c8:	07272823          	sw	s2,112(a4)
}
    800049cc:	60e2                	ld	ra,24(sp)
    800049ce:	6442                	ld	s0,16(sp)
    800049d0:	64a2                	ld	s1,8(sp)
    800049d2:	6902                	ld	s2,0(sp)
    800049d4:	6105                	addi	sp,sp,32
    800049d6:	8082                	ret
    panic("could not find virtio disk");
    800049d8:	00003517          	auipc	a0,0x3
    800049dc:	d2050513          	addi	a0,a0,-736 # 800076f8 <etext+0x6f8>
    800049e0:	277000ef          	jal	80005456 <panic>
    panic("virtio disk FEATURES_OK unset");
    800049e4:	00003517          	auipc	a0,0x3
    800049e8:	d3450513          	addi	a0,a0,-716 # 80007718 <etext+0x718>
    800049ec:	26b000ef          	jal	80005456 <panic>
    panic("virtio disk should not be ready");
    800049f0:	00003517          	auipc	a0,0x3
    800049f4:	d4850513          	addi	a0,a0,-696 # 80007738 <etext+0x738>
    800049f8:	25f000ef          	jal	80005456 <panic>
    panic("virtio disk has no queue 0");
    800049fc:	00003517          	auipc	a0,0x3
    80004a00:	d5c50513          	addi	a0,a0,-676 # 80007758 <etext+0x758>
    80004a04:	253000ef          	jal	80005456 <panic>
    panic("virtio disk max queue too short");
    80004a08:	00003517          	auipc	a0,0x3
    80004a0c:	d7050513          	addi	a0,a0,-656 # 80007778 <etext+0x778>
    80004a10:	247000ef          	jal	80005456 <panic>
    panic("virtio disk kalloc");
    80004a14:	00003517          	auipc	a0,0x3
    80004a18:	d8450513          	addi	a0,a0,-636 # 80007798 <etext+0x798>
    80004a1c:	23b000ef          	jal	80005456 <panic>

0000000080004a20 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004a20:	711d                	addi	sp,sp,-96
    80004a22:	ec86                	sd	ra,88(sp)
    80004a24:	e8a2                	sd	s0,80(sp)
    80004a26:	e4a6                	sd	s1,72(sp)
    80004a28:	e0ca                	sd	s2,64(sp)
    80004a2a:	fc4e                	sd	s3,56(sp)
    80004a2c:	f852                	sd	s4,48(sp)
    80004a2e:	f456                	sd	s5,40(sp)
    80004a30:	f05a                	sd	s6,32(sp)
    80004a32:	ec5e                	sd	s7,24(sp)
    80004a34:	e862                	sd	s8,16(sp)
    80004a36:	1080                	addi	s0,sp,96
    80004a38:	89aa                	mv	s3,a0
    80004a3a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004a3c:	00c52b83          	lw	s7,12(a0)
    80004a40:	001b9b9b          	slliw	s7,s7,0x1
    80004a44:	1b82                	slli	s7,s7,0x20
    80004a46:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004a4a:	00017517          	auipc	a0,0x17
    80004a4e:	e1e50513          	addi	a0,a0,-482 # 8001b868 <disk+0x128>
    80004a52:	533000ef          	jal	80005784 <acquire>
  for(int i = 0; i < NUM; i++){
    80004a56:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004a58:	00017a97          	auipc	s5,0x17
    80004a5c:	ce8a8a93          	addi	s5,s5,-792 # 8001b740 <disk>
  for(int i = 0; i < 3; i++){
    80004a60:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004a62:	5c7d                	li	s8,-1
    80004a64:	a095                	j	80004ac8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004a66:	00fa8733          	add	a4,s5,a5
    80004a6a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004a6e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a70:	0207c563          	bltz	a5,80004a9a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004a74:	2905                	addiw	s2,s2,1
    80004a76:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a78:	05490c63          	beq	s2,s4,80004ad0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004a7c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a7e:	00017717          	auipc	a4,0x17
    80004a82:	cc270713          	addi	a4,a4,-830 # 8001b740 <disk>
    80004a86:	4781                	li	a5,0
    if(disk.free[i]){
    80004a88:	01874683          	lbu	a3,24(a4)
    80004a8c:	fee9                	bnez	a3,80004a66 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004a8e:	2785                	addiw	a5,a5,1
    80004a90:	0705                	addi	a4,a4,1
    80004a92:	fe979be3          	bne	a5,s1,80004a88 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004a96:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004a9a:	01205d63          	blez	s2,80004ab4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004a9e:	fa042503          	lw	a0,-96(s0)
    80004aa2:	d41ff0ef          	jal	800047e2 <free_desc>
      for(int j = 0; j < i; j++)
    80004aa6:	4785                	li	a5,1
    80004aa8:	0127d663          	bge	a5,s2,80004ab4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004aac:	fa442503          	lw	a0,-92(s0)
    80004ab0:	d33ff0ef          	jal	800047e2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ab4:	00017597          	auipc	a1,0x17
    80004ab8:	db458593          	addi	a1,a1,-588 # 8001b868 <disk+0x128>
    80004abc:	00017517          	auipc	a0,0x17
    80004ac0:	c9c50513          	addi	a0,a0,-868 # 8001b758 <disk+0x18>
    80004ac4:	873fc0ef          	jal	80001336 <sleep>
  for(int i = 0; i < 3; i++){
    80004ac8:	fa040613          	addi	a2,s0,-96
    80004acc:	4901                	li	s2,0
    80004ace:	b77d                	j	80004a7c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ad0:	fa042503          	lw	a0,-96(s0)
    80004ad4:	00451693          	slli	a3,a0,0x4

  if(write)
    80004ad8:	00017797          	auipc	a5,0x17
    80004adc:	c6878793          	addi	a5,a5,-920 # 8001b740 <disk>
    80004ae0:	00a50713          	addi	a4,a0,10
    80004ae4:	0712                	slli	a4,a4,0x4
    80004ae6:	973e                	add	a4,a4,a5
    80004ae8:	01603633          	snez	a2,s6
    80004aec:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004aee:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004af2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004af6:	6398                	ld	a4,0(a5)
    80004af8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004afa:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004afe:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b00:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004b02:	6390                	ld	a2,0(a5)
    80004b04:	00d605b3          	add	a1,a2,a3
    80004b08:	4741                	li	a4,16
    80004b0a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004b0c:	4805                	li	a6,1
    80004b0e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004b12:	fa442703          	lw	a4,-92(s0)
    80004b16:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004b1a:	0712                	slli	a4,a4,0x4
    80004b1c:	963a                	add	a2,a2,a4
    80004b1e:	05898593          	addi	a1,s3,88
    80004b22:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004b24:	0007b883          	ld	a7,0(a5)
    80004b28:	9746                	add	a4,a4,a7
    80004b2a:	40000613          	li	a2,1024
    80004b2e:	c710                	sw	a2,8(a4)
  if(write)
    80004b30:	001b3613          	seqz	a2,s6
    80004b34:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004b38:	01066633          	or	a2,a2,a6
    80004b3c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004b40:	fa842583          	lw	a1,-88(s0)
    80004b44:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004b48:	00250613          	addi	a2,a0,2
    80004b4c:	0612                	slli	a2,a2,0x4
    80004b4e:	963e                	add	a2,a2,a5
    80004b50:	577d                	li	a4,-1
    80004b52:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004b56:	0592                	slli	a1,a1,0x4
    80004b58:	98ae                	add	a7,a7,a1
    80004b5a:	03068713          	addi	a4,a3,48
    80004b5e:	973e                	add	a4,a4,a5
    80004b60:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004b64:	6398                	ld	a4,0(a5)
    80004b66:	972e                	add	a4,a4,a1
    80004b68:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004b6c:	4689                	li	a3,2
    80004b6e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b72:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b76:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004b7a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b7e:	6794                	ld	a3,8(a5)
    80004b80:	0026d703          	lhu	a4,2(a3)
    80004b84:	8b1d                	andi	a4,a4,7
    80004b86:	0706                	slli	a4,a4,0x1
    80004b88:	96ba                	add	a3,a3,a4
    80004b8a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004b8e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b92:	6798                	ld	a4,8(a5)
    80004b94:	00275783          	lhu	a5,2(a4)
    80004b98:	2785                	addiw	a5,a5,1
    80004b9a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b9e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004ba2:	100017b7          	lui	a5,0x10001
    80004ba6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004baa:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004bae:	00017917          	auipc	s2,0x17
    80004bb2:	cba90913          	addi	s2,s2,-838 # 8001b868 <disk+0x128>
  while(b->disk == 1) {
    80004bb6:	84c2                	mv	s1,a6
    80004bb8:	01079a63          	bne	a5,a6,80004bcc <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004bbc:	85ca                	mv	a1,s2
    80004bbe:	854e                	mv	a0,s3
    80004bc0:	f76fc0ef          	jal	80001336 <sleep>
  while(b->disk == 1) {
    80004bc4:	0049a783          	lw	a5,4(s3)
    80004bc8:	fe978ae3          	beq	a5,s1,80004bbc <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004bcc:	fa042903          	lw	s2,-96(s0)
    80004bd0:	00290713          	addi	a4,s2,2
    80004bd4:	0712                	slli	a4,a4,0x4
    80004bd6:	00017797          	auipc	a5,0x17
    80004bda:	b6a78793          	addi	a5,a5,-1174 # 8001b740 <disk>
    80004bde:	97ba                	add	a5,a5,a4
    80004be0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004be4:	00017997          	auipc	s3,0x17
    80004be8:	b5c98993          	addi	s3,s3,-1188 # 8001b740 <disk>
    80004bec:	00491713          	slli	a4,s2,0x4
    80004bf0:	0009b783          	ld	a5,0(s3)
    80004bf4:	97ba                	add	a5,a5,a4
    80004bf6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004bfa:	854a                	mv	a0,s2
    80004bfc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004c00:	be3ff0ef          	jal	800047e2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004c04:	8885                	andi	s1,s1,1
    80004c06:	f0fd                	bnez	s1,80004bec <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004c08:	00017517          	auipc	a0,0x17
    80004c0c:	c6050513          	addi	a0,a0,-928 # 8001b868 <disk+0x128>
    80004c10:	409000ef          	jal	80005818 <release>
}
    80004c14:	60e6                	ld	ra,88(sp)
    80004c16:	6446                	ld	s0,80(sp)
    80004c18:	64a6                	ld	s1,72(sp)
    80004c1a:	6906                	ld	s2,64(sp)
    80004c1c:	79e2                	ld	s3,56(sp)
    80004c1e:	7a42                	ld	s4,48(sp)
    80004c20:	7aa2                	ld	s5,40(sp)
    80004c22:	7b02                	ld	s6,32(sp)
    80004c24:	6be2                	ld	s7,24(sp)
    80004c26:	6c42                	ld	s8,16(sp)
    80004c28:	6125                	addi	sp,sp,96
    80004c2a:	8082                	ret

0000000080004c2c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004c2c:	1101                	addi	sp,sp,-32
    80004c2e:	ec06                	sd	ra,24(sp)
    80004c30:	e822                	sd	s0,16(sp)
    80004c32:	e426                	sd	s1,8(sp)
    80004c34:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004c36:	00017497          	auipc	s1,0x17
    80004c3a:	b0a48493          	addi	s1,s1,-1270 # 8001b740 <disk>
    80004c3e:	00017517          	auipc	a0,0x17
    80004c42:	c2a50513          	addi	a0,a0,-982 # 8001b868 <disk+0x128>
    80004c46:	33f000ef          	jal	80005784 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004c4a:	100017b7          	lui	a5,0x10001
    80004c4e:	53bc                	lw	a5,96(a5)
    80004c50:	8b8d                	andi	a5,a5,3
    80004c52:	10001737          	lui	a4,0x10001
    80004c56:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004c58:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004c5c:	689c                	ld	a5,16(s1)
    80004c5e:	0204d703          	lhu	a4,32(s1)
    80004c62:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004c66:	04f70663          	beq	a4,a5,80004cb2 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004c6a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004c6e:	6898                	ld	a4,16(s1)
    80004c70:	0204d783          	lhu	a5,32(s1)
    80004c74:	8b9d                	andi	a5,a5,7
    80004c76:	078e                	slli	a5,a5,0x3
    80004c78:	97ba                	add	a5,a5,a4
    80004c7a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c7c:	00278713          	addi	a4,a5,2
    80004c80:	0712                	slli	a4,a4,0x4
    80004c82:	9726                	add	a4,a4,s1
    80004c84:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004c88:	e321                	bnez	a4,80004cc8 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c8a:	0789                	addi	a5,a5,2
    80004c8c:	0792                	slli	a5,a5,0x4
    80004c8e:	97a6                	add	a5,a5,s1
    80004c90:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c92:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c96:	eecfc0ef          	jal	80001382 <wakeup>

    disk.used_idx += 1;
    80004c9a:	0204d783          	lhu	a5,32(s1)
    80004c9e:	2785                	addiw	a5,a5,1
    80004ca0:	17c2                	slli	a5,a5,0x30
    80004ca2:	93c1                	srli	a5,a5,0x30
    80004ca4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004ca8:	6898                	ld	a4,16(s1)
    80004caa:	00275703          	lhu	a4,2(a4)
    80004cae:	faf71ee3          	bne	a4,a5,80004c6a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004cb2:	00017517          	auipc	a0,0x17
    80004cb6:	bb650513          	addi	a0,a0,-1098 # 8001b868 <disk+0x128>
    80004cba:	35f000ef          	jal	80005818 <release>
}
    80004cbe:	60e2                	ld	ra,24(sp)
    80004cc0:	6442                	ld	s0,16(sp)
    80004cc2:	64a2                	ld	s1,8(sp)
    80004cc4:	6105                	addi	sp,sp,32
    80004cc6:	8082                	ret
      panic("virtio_disk_intr status");
    80004cc8:	00003517          	auipc	a0,0x3
    80004ccc:	ae850513          	addi	a0,a0,-1304 # 800077b0 <etext+0x7b0>
    80004cd0:	786000ef          	jal	80005456 <panic>

0000000080004cd4 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004cd4:	1141                	addi	sp,sp,-16
    80004cd6:	e406                	sd	ra,8(sp)
    80004cd8:	e022                	sd	s0,0(sp)
    80004cda:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004cdc:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004ce0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004ce4:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004ce8:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004cec:	577d                	li	a4,-1
    80004cee:	177e                	slli	a4,a4,0x3f
    80004cf0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004cf2:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004cf6:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004cfa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004cfe:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004d02:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004d06:	000f4737          	lui	a4,0xf4
    80004d0a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004d0e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004d10:	14d79073          	csrw	stimecmp,a5
}
    80004d14:	60a2                	ld	ra,8(sp)
    80004d16:	6402                	ld	s0,0(sp)
    80004d18:	0141                	addi	sp,sp,16
    80004d1a:	8082                	ret

0000000080004d1c <start>:
{
    80004d1c:	1141                	addi	sp,sp,-16
    80004d1e:	e406                	sd	ra,8(sp)
    80004d20:	e022                	sd	s0,0(sp)
    80004d22:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004d24:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004d28:	7779                	lui	a4,0xffffe
    80004d2a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdae7f>
    80004d2e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004d30:	6705                	lui	a4,0x1
    80004d32:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004d36:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004d38:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004d3c:	ffffb797          	auipc	a5,0xffffb
    80004d40:	5c878793          	addi	a5,a5,1480 # 80000304 <main>
    80004d44:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004d48:	4781                	li	a5,0
    80004d4a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004d4e:	67c1                	lui	a5,0x10
    80004d50:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004d52:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004d56:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004d5a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004d5e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d62:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d66:	57fd                	li	a5,-1
    80004d68:	83a9                	srli	a5,a5,0xa
    80004d6a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d6e:	47bd                	li	a5,15
    80004d70:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d74:	f61ff0ef          	jal	80004cd4 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d78:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d7c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d7e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d80:	30200073          	mret
}
    80004d84:	60a2                	ld	ra,8(sp)
    80004d86:	6402                	ld	s0,0(sp)
    80004d88:	0141                	addi	sp,sp,16
    80004d8a:	8082                	ret

0000000080004d8c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d8c:	711d                	addi	sp,sp,-96
    80004d8e:	ec86                	sd	ra,88(sp)
    80004d90:	e8a2                	sd	s0,80(sp)
    80004d92:	e0ca                	sd	s2,64(sp)
    80004d94:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004d96:	04c05863          	blez	a2,80004de6 <consolewrite+0x5a>
    80004d9a:	e4a6                	sd	s1,72(sp)
    80004d9c:	fc4e                	sd	s3,56(sp)
    80004d9e:	f852                	sd	s4,48(sp)
    80004da0:	f456                	sd	s5,40(sp)
    80004da2:	f05a                	sd	s6,32(sp)
    80004da4:	ec5e                	sd	s7,24(sp)
    80004da6:	8a2a                	mv	s4,a0
    80004da8:	84ae                	mv	s1,a1
    80004daa:	89b2                	mv	s3,a2
    80004dac:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004dae:	faf40b93          	addi	s7,s0,-81
    80004db2:	4b05                	li	s6,1
    80004db4:	5afd                	li	s5,-1
    80004db6:	86da                	mv	a3,s6
    80004db8:	8626                	mv	a2,s1
    80004dba:	85d2                	mv	a1,s4
    80004dbc:	855e                	mv	a0,s7
    80004dbe:	919fc0ef          	jal	800016d6 <either_copyin>
    80004dc2:	03550463          	beq	a0,s5,80004dea <consolewrite+0x5e>
      break;
    uartputc(c);
    80004dc6:	faf44503          	lbu	a0,-81(s0)
    80004dca:	02d000ef          	jal	800055f6 <uartputc>
  for(i = 0; i < n; i++){
    80004dce:	2905                	addiw	s2,s2,1
    80004dd0:	0485                	addi	s1,s1,1
    80004dd2:	ff2992e3          	bne	s3,s2,80004db6 <consolewrite+0x2a>
    80004dd6:	894e                	mv	s2,s3
    80004dd8:	64a6                	ld	s1,72(sp)
    80004dda:	79e2                	ld	s3,56(sp)
    80004ddc:	7a42                	ld	s4,48(sp)
    80004dde:	7aa2                	ld	s5,40(sp)
    80004de0:	7b02                	ld	s6,32(sp)
    80004de2:	6be2                	ld	s7,24(sp)
    80004de4:	a809                	j	80004df6 <consolewrite+0x6a>
    80004de6:	4901                	li	s2,0
    80004de8:	a039                	j	80004df6 <consolewrite+0x6a>
    80004dea:	64a6                	ld	s1,72(sp)
    80004dec:	79e2                	ld	s3,56(sp)
    80004dee:	7a42                	ld	s4,48(sp)
    80004df0:	7aa2                	ld	s5,40(sp)
    80004df2:	7b02                	ld	s6,32(sp)
    80004df4:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004df6:	854a                	mv	a0,s2
    80004df8:	60e6                	ld	ra,88(sp)
    80004dfa:	6446                	ld	s0,80(sp)
    80004dfc:	6906                	ld	s2,64(sp)
    80004dfe:	6125                	addi	sp,sp,96
    80004e00:	8082                	ret

0000000080004e02 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004e02:	711d                	addi	sp,sp,-96
    80004e04:	ec86                	sd	ra,88(sp)
    80004e06:	e8a2                	sd	s0,80(sp)
    80004e08:	e4a6                	sd	s1,72(sp)
    80004e0a:	e0ca                	sd	s2,64(sp)
    80004e0c:	fc4e                	sd	s3,56(sp)
    80004e0e:	f852                	sd	s4,48(sp)
    80004e10:	f456                	sd	s5,40(sp)
    80004e12:	f05a                	sd	s6,32(sp)
    80004e14:	1080                	addi	s0,sp,96
    80004e16:	8aaa                	mv	s5,a0
    80004e18:	8a2e                	mv	s4,a1
    80004e1a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004e1c:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004e1e:	0001f517          	auipc	a0,0x1f
    80004e22:	a6250513          	addi	a0,a0,-1438 # 80023880 <cons>
    80004e26:	15f000ef          	jal	80005784 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004e2a:	0001f497          	auipc	s1,0x1f
    80004e2e:	a5648493          	addi	s1,s1,-1450 # 80023880 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004e32:	0001f917          	auipc	s2,0x1f
    80004e36:	ae690913          	addi	s2,s2,-1306 # 80023918 <cons+0x98>
  while(n > 0){
    80004e3a:	0b305b63          	blez	s3,80004ef0 <consoleread+0xee>
    while(cons.r == cons.w){
    80004e3e:	0984a783          	lw	a5,152(s1)
    80004e42:	09c4a703          	lw	a4,156(s1)
    80004e46:	0af71063          	bne	a4,a5,80004ee6 <consoleread+0xe4>
      if(killed(myproc())){
    80004e4a:	f13fb0ef          	jal	80000d5c <myproc>
    80004e4e:	f20fc0ef          	jal	8000156e <killed>
    80004e52:	e12d                	bnez	a0,80004eb4 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004e54:	85a6                	mv	a1,s1
    80004e56:	854a                	mv	a0,s2
    80004e58:	cdefc0ef          	jal	80001336 <sleep>
    while(cons.r == cons.w){
    80004e5c:	0984a783          	lw	a5,152(s1)
    80004e60:	09c4a703          	lw	a4,156(s1)
    80004e64:	fef703e3          	beq	a4,a5,80004e4a <consoleread+0x48>
    80004e68:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004e6a:	0001f717          	auipc	a4,0x1f
    80004e6e:	a1670713          	addi	a4,a4,-1514 # 80023880 <cons>
    80004e72:	0017869b          	addiw	a3,a5,1
    80004e76:	08d72c23          	sw	a3,152(a4)
    80004e7a:	07f7f693          	andi	a3,a5,127
    80004e7e:	9736                	add	a4,a4,a3
    80004e80:	01874703          	lbu	a4,24(a4)
    80004e84:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004e88:	4691                	li	a3,4
    80004e8a:	04db8663          	beq	s7,a3,80004ed6 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004e8e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e92:	4685                	li	a3,1
    80004e94:	faf40613          	addi	a2,s0,-81
    80004e98:	85d2                	mv	a1,s4
    80004e9a:	8556                	mv	a0,s5
    80004e9c:	ff0fc0ef          	jal	8000168c <either_copyout>
    80004ea0:	57fd                	li	a5,-1
    80004ea2:	04f50663          	beq	a0,a5,80004eee <consoleread+0xec>
      break;

    dst++;
    80004ea6:	0a05                	addi	s4,s4,1
    --n;
    80004ea8:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004eaa:	47a9                	li	a5,10
    80004eac:	04fb8b63          	beq	s7,a5,80004f02 <consoleread+0x100>
    80004eb0:	6be2                	ld	s7,24(sp)
    80004eb2:	b761                	j	80004e3a <consoleread+0x38>
        release(&cons.lock);
    80004eb4:	0001f517          	auipc	a0,0x1f
    80004eb8:	9cc50513          	addi	a0,a0,-1588 # 80023880 <cons>
    80004ebc:	15d000ef          	jal	80005818 <release>
        return -1;
    80004ec0:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004ec2:	60e6                	ld	ra,88(sp)
    80004ec4:	6446                	ld	s0,80(sp)
    80004ec6:	64a6                	ld	s1,72(sp)
    80004ec8:	6906                	ld	s2,64(sp)
    80004eca:	79e2                	ld	s3,56(sp)
    80004ecc:	7a42                	ld	s4,48(sp)
    80004ece:	7aa2                	ld	s5,40(sp)
    80004ed0:	7b02                	ld	s6,32(sp)
    80004ed2:	6125                	addi	sp,sp,96
    80004ed4:	8082                	ret
      if(n < target){
    80004ed6:	0169fa63          	bgeu	s3,s6,80004eea <consoleread+0xe8>
        cons.r--;
    80004eda:	0001f717          	auipc	a4,0x1f
    80004ede:	a2f72f23          	sw	a5,-1474(a4) # 80023918 <cons+0x98>
    80004ee2:	6be2                	ld	s7,24(sp)
    80004ee4:	a031                	j	80004ef0 <consoleread+0xee>
    80004ee6:	ec5e                	sd	s7,24(sp)
    80004ee8:	b749                	j	80004e6a <consoleread+0x68>
    80004eea:	6be2                	ld	s7,24(sp)
    80004eec:	a011                	j	80004ef0 <consoleread+0xee>
    80004eee:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004ef0:	0001f517          	auipc	a0,0x1f
    80004ef4:	99050513          	addi	a0,a0,-1648 # 80023880 <cons>
    80004ef8:	121000ef          	jal	80005818 <release>
  return target - n;
    80004efc:	413b053b          	subw	a0,s6,s3
    80004f00:	b7c9                	j	80004ec2 <consoleread+0xc0>
    80004f02:	6be2                	ld	s7,24(sp)
    80004f04:	b7f5                	j	80004ef0 <consoleread+0xee>

0000000080004f06 <consputc>:
{
    80004f06:	1141                	addi	sp,sp,-16
    80004f08:	e406                	sd	ra,8(sp)
    80004f0a:	e022                	sd	s0,0(sp)
    80004f0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004f0e:	10000793          	li	a5,256
    80004f12:	00f50863          	beq	a0,a5,80004f22 <consputc+0x1c>
    uartputc_sync(c);
    80004f16:	5fe000ef          	jal	80005514 <uartputc_sync>
}
    80004f1a:	60a2                	ld	ra,8(sp)
    80004f1c:	6402                	ld	s0,0(sp)
    80004f1e:	0141                	addi	sp,sp,16
    80004f20:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004f22:	4521                	li	a0,8
    80004f24:	5f0000ef          	jal	80005514 <uartputc_sync>
    80004f28:	02000513          	li	a0,32
    80004f2c:	5e8000ef          	jal	80005514 <uartputc_sync>
    80004f30:	4521                	li	a0,8
    80004f32:	5e2000ef          	jal	80005514 <uartputc_sync>
    80004f36:	b7d5                	j	80004f1a <consputc+0x14>

0000000080004f38 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004f38:	7179                	addi	sp,sp,-48
    80004f3a:	f406                	sd	ra,40(sp)
    80004f3c:	f022                	sd	s0,32(sp)
    80004f3e:	ec26                	sd	s1,24(sp)
    80004f40:	1800                	addi	s0,sp,48
    80004f42:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004f44:	0001f517          	auipc	a0,0x1f
    80004f48:	93c50513          	addi	a0,a0,-1732 # 80023880 <cons>
    80004f4c:	039000ef          	jal	80005784 <acquire>

  switch(c){
    80004f50:	47d5                	li	a5,21
    80004f52:	08f48e63          	beq	s1,a5,80004fee <consoleintr+0xb6>
    80004f56:	0297c563          	blt	a5,s1,80004f80 <consoleintr+0x48>
    80004f5a:	47a1                	li	a5,8
    80004f5c:	0ef48863          	beq	s1,a5,8000504c <consoleintr+0x114>
    80004f60:	47c1                	li	a5,16
    80004f62:	10f49963          	bne	s1,a5,80005074 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80004f66:	fbafc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f6a:	0001f517          	auipc	a0,0x1f
    80004f6e:	91650513          	addi	a0,a0,-1770 # 80023880 <cons>
    80004f72:	0a7000ef          	jal	80005818 <release>
}
    80004f76:	70a2                	ld	ra,40(sp)
    80004f78:	7402                	ld	s0,32(sp)
    80004f7a:	64e2                	ld	s1,24(sp)
    80004f7c:	6145                	addi	sp,sp,48
    80004f7e:	8082                	ret
  switch(c){
    80004f80:	07f00793          	li	a5,127
    80004f84:	0cf48463          	beq	s1,a5,8000504c <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f88:	0001f717          	auipc	a4,0x1f
    80004f8c:	8f870713          	addi	a4,a4,-1800 # 80023880 <cons>
    80004f90:	0a072783          	lw	a5,160(a4)
    80004f94:	09872703          	lw	a4,152(a4)
    80004f98:	9f99                	subw	a5,a5,a4
    80004f9a:	07f00713          	li	a4,127
    80004f9e:	fcf766e3          	bltu	a4,a5,80004f6a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004fa2:	47b5                	li	a5,13
    80004fa4:	0cf48b63          	beq	s1,a5,8000507a <consoleintr+0x142>
      consputc(c);
    80004fa8:	8526                	mv	a0,s1
    80004faa:	f5dff0ef          	jal	80004f06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004fae:	0001f797          	auipc	a5,0x1f
    80004fb2:	8d278793          	addi	a5,a5,-1838 # 80023880 <cons>
    80004fb6:	0a07a683          	lw	a3,160(a5)
    80004fba:	0016871b          	addiw	a4,a3,1
    80004fbe:	863a                	mv	a2,a4
    80004fc0:	0ae7a023          	sw	a4,160(a5)
    80004fc4:	07f6f693          	andi	a3,a3,127
    80004fc8:	97b6                	add	a5,a5,a3
    80004fca:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004fce:	47a9                	li	a5,10
    80004fd0:	0cf48963          	beq	s1,a5,800050a2 <consoleintr+0x16a>
    80004fd4:	4791                	li	a5,4
    80004fd6:	0cf48663          	beq	s1,a5,800050a2 <consoleintr+0x16a>
    80004fda:	0001f797          	auipc	a5,0x1f
    80004fde:	93e7a783          	lw	a5,-1730(a5) # 80023918 <cons+0x98>
    80004fe2:	9f1d                	subw	a4,a4,a5
    80004fe4:	08000793          	li	a5,128
    80004fe8:	f8f711e3          	bne	a4,a5,80004f6a <consoleintr+0x32>
    80004fec:	a85d                	j	800050a2 <consoleintr+0x16a>
    80004fee:	e84a                	sd	s2,16(sp)
    80004ff0:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80004ff2:	0001f717          	auipc	a4,0x1f
    80004ff6:	88e70713          	addi	a4,a4,-1906 # 80023880 <cons>
    80004ffa:	0a072783          	lw	a5,160(a4)
    80004ffe:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005002:	0001f497          	auipc	s1,0x1f
    80005006:	87e48493          	addi	s1,s1,-1922 # 80023880 <cons>
    while(cons.e != cons.w &&
    8000500a:	4929                	li	s2,10
      consputc(BACKSPACE);
    8000500c:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005010:	02f70863          	beq	a4,a5,80005040 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005014:	37fd                	addiw	a5,a5,-1
    80005016:	07f7f713          	andi	a4,a5,127
    8000501a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000501c:	01874703          	lbu	a4,24(a4)
    80005020:	03270363          	beq	a4,s2,80005046 <consoleintr+0x10e>
      cons.e--;
    80005024:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005028:	854e                	mv	a0,s3
    8000502a:	eddff0ef          	jal	80004f06 <consputc>
    while(cons.e != cons.w &&
    8000502e:	0a04a783          	lw	a5,160(s1)
    80005032:	09c4a703          	lw	a4,156(s1)
    80005036:	fcf71fe3          	bne	a4,a5,80005014 <consoleintr+0xdc>
    8000503a:	6942                	ld	s2,16(sp)
    8000503c:	69a2                	ld	s3,8(sp)
    8000503e:	b735                	j	80004f6a <consoleintr+0x32>
    80005040:	6942                	ld	s2,16(sp)
    80005042:	69a2                	ld	s3,8(sp)
    80005044:	b71d                	j	80004f6a <consoleintr+0x32>
    80005046:	6942                	ld	s2,16(sp)
    80005048:	69a2                	ld	s3,8(sp)
    8000504a:	b705                	j	80004f6a <consoleintr+0x32>
    if(cons.e != cons.w){
    8000504c:	0001f717          	auipc	a4,0x1f
    80005050:	83470713          	addi	a4,a4,-1996 # 80023880 <cons>
    80005054:	0a072783          	lw	a5,160(a4)
    80005058:	09c72703          	lw	a4,156(a4)
    8000505c:	f0f707e3          	beq	a4,a5,80004f6a <consoleintr+0x32>
      cons.e--;
    80005060:	37fd                	addiw	a5,a5,-1
    80005062:	0001f717          	auipc	a4,0x1f
    80005066:	8af72f23          	sw	a5,-1858(a4) # 80023920 <cons+0xa0>
      consputc(BACKSPACE);
    8000506a:	10000513          	li	a0,256
    8000506e:	e99ff0ef          	jal	80004f06 <consputc>
    80005072:	bde5                	j	80004f6a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005074:	ee048be3          	beqz	s1,80004f6a <consoleintr+0x32>
    80005078:	bf01                	j	80004f88 <consoleintr+0x50>
      consputc(c);
    8000507a:	4529                	li	a0,10
    8000507c:	e8bff0ef          	jal	80004f06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005080:	0001f797          	auipc	a5,0x1f
    80005084:	80078793          	addi	a5,a5,-2048 # 80023880 <cons>
    80005088:	0a07a703          	lw	a4,160(a5)
    8000508c:	0017069b          	addiw	a3,a4,1
    80005090:	8636                	mv	a2,a3
    80005092:	0ad7a023          	sw	a3,160(a5)
    80005096:	07f77713          	andi	a4,a4,127
    8000509a:	97ba                	add	a5,a5,a4
    8000509c:	4729                	li	a4,10
    8000509e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800050a2:	0001f797          	auipc	a5,0x1f
    800050a6:	86c7ad23          	sw	a2,-1926(a5) # 8002391c <cons+0x9c>
        wakeup(&cons.r);
    800050aa:	0001f517          	auipc	a0,0x1f
    800050ae:	86e50513          	addi	a0,a0,-1938 # 80023918 <cons+0x98>
    800050b2:	ad0fc0ef          	jal	80001382 <wakeup>
    800050b6:	bd55                	j	80004f6a <consoleintr+0x32>

00000000800050b8 <consoleinit>:

void
consoleinit(void)
{
    800050b8:	1141                	addi	sp,sp,-16
    800050ba:	e406                	sd	ra,8(sp)
    800050bc:	e022                	sd	s0,0(sp)
    800050be:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800050c0:	00002597          	auipc	a1,0x2
    800050c4:	70858593          	addi	a1,a1,1800 # 800077c8 <etext+0x7c8>
    800050c8:	0001e517          	auipc	a0,0x1e
    800050cc:	7b850513          	addi	a0,a0,1976 # 80023880 <cons>
    800050d0:	630000ef          	jal	80005700 <initlock>

  uartinit();
    800050d4:	3ea000ef          	jal	800054be <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800050d8:	00015797          	auipc	a5,0x15
    800050dc:	61078793          	addi	a5,a5,1552 # 8001a6e8 <devsw>
    800050e0:	00000717          	auipc	a4,0x0
    800050e4:	d2270713          	addi	a4,a4,-734 # 80004e02 <consoleread>
    800050e8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800050ea:	00000717          	auipc	a4,0x0
    800050ee:	ca270713          	addi	a4,a4,-862 # 80004d8c <consolewrite>
    800050f2:	ef98                	sd	a4,24(a5)
}
    800050f4:	60a2                	ld	ra,8(sp)
    800050f6:	6402                	ld	s0,0(sp)
    800050f8:	0141                	addi	sp,sp,16
    800050fa:	8082                	ret

00000000800050fc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800050fc:	7179                	addi	sp,sp,-48
    800050fe:	f406                	sd	ra,40(sp)
    80005100:	f022                	sd	s0,32(sp)
    80005102:	ec26                	sd	s1,24(sp)
    80005104:	e84a                	sd	s2,16(sp)
    80005106:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005108:	c219                	beqz	a2,8000510e <printint+0x12>
    8000510a:	06054a63          	bltz	a0,8000517e <printint+0x82>
    x = -xx;
  else
    x = xx;
    8000510e:	4e01                	li	t3,0

  i = 0;
    80005110:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005114:	869a                	mv	a3,t1
  i = 0;
    80005116:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005118:	00003817          	auipc	a6,0x3
    8000511c:	8c880813          	addi	a6,a6,-1848 # 800079e0 <digits>
    80005120:	88be                	mv	a7,a5
    80005122:	0017861b          	addiw	a2,a5,1
    80005126:	87b2                	mv	a5,a2
    80005128:	02b57733          	remu	a4,a0,a1
    8000512c:	9742                	add	a4,a4,a6
    8000512e:	00074703          	lbu	a4,0(a4)
    80005132:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005136:	872a                	mv	a4,a0
    80005138:	02b55533          	divu	a0,a0,a1
    8000513c:	0685                	addi	a3,a3,1
    8000513e:	feb771e3          	bgeu	a4,a1,80005120 <printint+0x24>

  if(sign)
    80005142:	000e0c63          	beqz	t3,8000515a <printint+0x5e>
    buf[i++] = '-';
    80005146:	fe060793          	addi	a5,a2,-32
    8000514a:	00878633          	add	a2,a5,s0
    8000514e:	02d00793          	li	a5,45
    80005152:	fef60823          	sb	a5,-16(a2)
    80005156:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    8000515a:	fff7891b          	addiw	s2,a5,-1
    8000515e:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005162:	fff4c503          	lbu	a0,-1(s1)
    80005166:	da1ff0ef          	jal	80004f06 <consputc>
  while(--i >= 0)
    8000516a:	397d                	addiw	s2,s2,-1
    8000516c:	14fd                	addi	s1,s1,-1
    8000516e:	fe095ae3          	bgez	s2,80005162 <printint+0x66>
}
    80005172:	70a2                	ld	ra,40(sp)
    80005174:	7402                	ld	s0,32(sp)
    80005176:	64e2                	ld	s1,24(sp)
    80005178:	6942                	ld	s2,16(sp)
    8000517a:	6145                	addi	sp,sp,48
    8000517c:	8082                	ret
    x = -xx;
    8000517e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005182:	4e05                	li	t3,1
    x = -xx;
    80005184:	b771                	j	80005110 <printint+0x14>

0000000080005186 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005186:	7155                	addi	sp,sp,-208
    80005188:	e506                	sd	ra,136(sp)
    8000518a:	e122                	sd	s0,128(sp)
    8000518c:	f0d2                	sd	s4,96(sp)
    8000518e:	0900                	addi	s0,sp,144
    80005190:	8a2a                	mv	s4,a0
    80005192:	e40c                	sd	a1,8(s0)
    80005194:	e810                	sd	a2,16(s0)
    80005196:	ec14                	sd	a3,24(s0)
    80005198:	f018                	sd	a4,32(s0)
    8000519a:	f41c                	sd	a5,40(s0)
    8000519c:	03043823          	sd	a6,48(s0)
    800051a0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800051a4:	0001e797          	auipc	a5,0x1e
    800051a8:	79c7a783          	lw	a5,1948(a5) # 80023940 <pr+0x18>
    800051ac:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800051b0:	e3a1                	bnez	a5,800051f0 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800051b2:	00840793          	addi	a5,s0,8
    800051b6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051ba:	00054503          	lbu	a0,0(a0)
    800051be:	26050663          	beqz	a0,8000542a <printf+0x2a4>
    800051c2:	fca6                	sd	s1,120(sp)
    800051c4:	f8ca                	sd	s2,112(sp)
    800051c6:	f4ce                	sd	s3,104(sp)
    800051c8:	ecd6                	sd	s5,88(sp)
    800051ca:	e8da                	sd	s6,80(sp)
    800051cc:	e0e2                	sd	s8,64(sp)
    800051ce:	fc66                	sd	s9,56(sp)
    800051d0:	f86a                	sd	s10,48(sp)
    800051d2:	f46e                	sd	s11,40(sp)
    800051d4:	4981                	li	s3,0
    if(cx != '%'){
    800051d6:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800051da:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800051de:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800051e2:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800051e6:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800051ea:	07000d93          	li	s11,112
    800051ee:	a80d                	j	80005220 <printf+0x9a>
    acquire(&pr.lock);
    800051f0:	0001e517          	auipc	a0,0x1e
    800051f4:	73850513          	addi	a0,a0,1848 # 80023928 <pr>
    800051f8:	58c000ef          	jal	80005784 <acquire>
  va_start(ap, fmt);
    800051fc:	00840793          	addi	a5,s0,8
    80005200:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005204:	000a4503          	lbu	a0,0(s4)
    80005208:	fd4d                	bnez	a0,800051c2 <printf+0x3c>
    8000520a:	ac3d                	j	80005448 <printf+0x2c2>
      consputc(cx);
    8000520c:	cfbff0ef          	jal	80004f06 <consputc>
      continue;
    80005210:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005212:	2485                	addiw	s1,s1,1
    80005214:	89a6                	mv	s3,s1
    80005216:	94d2                	add	s1,s1,s4
    80005218:	0004c503          	lbu	a0,0(s1)
    8000521c:	1e050b63          	beqz	a0,80005412 <printf+0x28c>
    if(cx != '%'){
    80005220:	ff5516e3          	bne	a0,s5,8000520c <printf+0x86>
    i++;
    80005224:	0019879b          	addiw	a5,s3,1
    80005228:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000522a:	00fa0733          	add	a4,s4,a5
    8000522e:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005232:	1e090063          	beqz	s2,80005412 <printf+0x28c>
    80005236:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    8000523a:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    8000523c:	c701                	beqz	a4,80005244 <printf+0xbe>
    8000523e:	97d2                	add	a5,a5,s4
    80005240:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005244:	03690763          	beq	s2,s6,80005272 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80005248:	05890163          	beq	s2,s8,8000528a <printf+0x104>
    } else if(c0 == 'u'){
    8000524c:	0d990b63          	beq	s2,s9,80005322 <printf+0x19c>
    } else if(c0 == 'x'){
    80005250:	13a90163          	beq	s2,s10,80005372 <printf+0x1ec>
    } else if(c0 == 'p'){
    80005254:	13b90b63          	beq	s2,s11,8000538a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005258:	07300793          	li	a5,115
    8000525c:	16f90a63          	beq	s2,a5,800053d0 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005260:	1b590463          	beq	s2,s5,80005408 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005264:	8556                	mv	a0,s5
    80005266:	ca1ff0ef          	jal	80004f06 <consputc>
      consputc(c0);
    8000526a:	854a                	mv	a0,s2
    8000526c:	c9bff0ef          	jal	80004f06 <consputc>
    80005270:	b74d                	j	80005212 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005272:	f8843783          	ld	a5,-120(s0)
    80005276:	00878713          	addi	a4,a5,8
    8000527a:	f8e43423          	sd	a4,-120(s0)
    8000527e:	4605                	li	a2,1
    80005280:	45a9                	li	a1,10
    80005282:	4388                	lw	a0,0(a5)
    80005284:	e79ff0ef          	jal	800050fc <printint>
    80005288:	b769                	j	80005212 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000528a:	03670663          	beq	a4,s6,800052b6 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000528e:	05870263          	beq	a4,s8,800052d2 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005292:	0b970463          	beq	a4,s9,8000533a <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005296:	fda717e3          	bne	a4,s10,80005264 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000529a:	f8843783          	ld	a5,-120(s0)
    8000529e:	00878713          	addi	a4,a5,8
    800052a2:	f8e43423          	sd	a4,-120(s0)
    800052a6:	4601                	li	a2,0
    800052a8:	45c1                	li	a1,16
    800052aa:	6388                	ld	a0,0(a5)
    800052ac:	e51ff0ef          	jal	800050fc <printint>
      i += 1;
    800052b0:	0029849b          	addiw	s1,s3,2
    800052b4:	bfb9                	j	80005212 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800052b6:	f8843783          	ld	a5,-120(s0)
    800052ba:	00878713          	addi	a4,a5,8
    800052be:	f8e43423          	sd	a4,-120(s0)
    800052c2:	4605                	li	a2,1
    800052c4:	45a9                	li	a1,10
    800052c6:	6388                	ld	a0,0(a5)
    800052c8:	e35ff0ef          	jal	800050fc <printint>
      i += 1;
    800052cc:	0029849b          	addiw	s1,s3,2
    800052d0:	b789                	j	80005212 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800052d2:	06400793          	li	a5,100
    800052d6:	02f68863          	beq	a3,a5,80005306 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800052da:	07500793          	li	a5,117
    800052de:	06f68c63          	beq	a3,a5,80005356 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800052e2:	07800793          	li	a5,120
    800052e6:	f6f69fe3          	bne	a3,a5,80005264 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800052ea:	f8843783          	ld	a5,-120(s0)
    800052ee:	00878713          	addi	a4,a5,8
    800052f2:	f8e43423          	sd	a4,-120(s0)
    800052f6:	4601                	li	a2,0
    800052f8:	45c1                	li	a1,16
    800052fa:	6388                	ld	a0,0(a5)
    800052fc:	e01ff0ef          	jal	800050fc <printint>
      i += 2;
    80005300:	0039849b          	addiw	s1,s3,3
    80005304:	b739                	j	80005212 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005306:	f8843783          	ld	a5,-120(s0)
    8000530a:	00878713          	addi	a4,a5,8
    8000530e:	f8e43423          	sd	a4,-120(s0)
    80005312:	4605                	li	a2,1
    80005314:	45a9                	li	a1,10
    80005316:	6388                	ld	a0,0(a5)
    80005318:	de5ff0ef          	jal	800050fc <printint>
      i += 2;
    8000531c:	0039849b          	addiw	s1,s3,3
    80005320:	bdcd                	j	80005212 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80005322:	f8843783          	ld	a5,-120(s0)
    80005326:	00878713          	addi	a4,a5,8
    8000532a:	f8e43423          	sd	a4,-120(s0)
    8000532e:	4601                	li	a2,0
    80005330:	45a9                	li	a1,10
    80005332:	4388                	lw	a0,0(a5)
    80005334:	dc9ff0ef          	jal	800050fc <printint>
    80005338:	bde9                	j	80005212 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000533a:	f8843783          	ld	a5,-120(s0)
    8000533e:	00878713          	addi	a4,a5,8
    80005342:	f8e43423          	sd	a4,-120(s0)
    80005346:	4601                	li	a2,0
    80005348:	45a9                	li	a1,10
    8000534a:	6388                	ld	a0,0(a5)
    8000534c:	db1ff0ef          	jal	800050fc <printint>
      i += 1;
    80005350:	0029849b          	addiw	s1,s3,2
    80005354:	bd7d                	j	80005212 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005356:	f8843783          	ld	a5,-120(s0)
    8000535a:	00878713          	addi	a4,a5,8
    8000535e:	f8e43423          	sd	a4,-120(s0)
    80005362:	4601                	li	a2,0
    80005364:	45a9                	li	a1,10
    80005366:	6388                	ld	a0,0(a5)
    80005368:	d95ff0ef          	jal	800050fc <printint>
      i += 2;
    8000536c:	0039849b          	addiw	s1,s3,3
    80005370:	b54d                	j	80005212 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005372:	f8843783          	ld	a5,-120(s0)
    80005376:	00878713          	addi	a4,a5,8
    8000537a:	f8e43423          	sd	a4,-120(s0)
    8000537e:	4601                	li	a2,0
    80005380:	45c1                	li	a1,16
    80005382:	4388                	lw	a0,0(a5)
    80005384:	d79ff0ef          	jal	800050fc <printint>
    80005388:	b569                	j	80005212 <printf+0x8c>
    8000538a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000538c:	f8843783          	ld	a5,-120(s0)
    80005390:	00878713          	addi	a4,a5,8
    80005394:	f8e43423          	sd	a4,-120(s0)
    80005398:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000539c:	03000513          	li	a0,48
    800053a0:	b67ff0ef          	jal	80004f06 <consputc>
  consputc('x');
    800053a4:	07800513          	li	a0,120
    800053a8:	b5fff0ef          	jal	80004f06 <consputc>
    800053ac:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800053ae:	00002b97          	auipc	s7,0x2
    800053b2:	632b8b93          	addi	s7,s7,1586 # 800079e0 <digits>
    800053b6:	03c9d793          	srli	a5,s3,0x3c
    800053ba:	97de                	add	a5,a5,s7
    800053bc:	0007c503          	lbu	a0,0(a5)
    800053c0:	b47ff0ef          	jal	80004f06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800053c4:	0992                	slli	s3,s3,0x4
    800053c6:	397d                	addiw	s2,s2,-1
    800053c8:	fe0917e3          	bnez	s2,800053b6 <printf+0x230>
    800053cc:	6ba6                	ld	s7,72(sp)
    800053ce:	b591                	j	80005212 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800053d0:	f8843783          	ld	a5,-120(s0)
    800053d4:	00878713          	addi	a4,a5,8
    800053d8:	f8e43423          	sd	a4,-120(s0)
    800053dc:	0007b903          	ld	s2,0(a5)
    800053e0:	00090d63          	beqz	s2,800053fa <printf+0x274>
      for(; *s; s++)
    800053e4:	00094503          	lbu	a0,0(s2)
    800053e8:	e20505e3          	beqz	a0,80005212 <printf+0x8c>
        consputc(*s);
    800053ec:	b1bff0ef          	jal	80004f06 <consputc>
      for(; *s; s++)
    800053f0:	0905                	addi	s2,s2,1
    800053f2:	00094503          	lbu	a0,0(s2)
    800053f6:	f97d                	bnez	a0,800053ec <printf+0x266>
    800053f8:	bd29                	j	80005212 <printf+0x8c>
        s = "(null)";
    800053fa:	00002917          	auipc	s2,0x2
    800053fe:	3d690913          	addi	s2,s2,982 # 800077d0 <etext+0x7d0>
      for(; *s; s++)
    80005402:	02800513          	li	a0,40
    80005406:	b7dd                	j	800053ec <printf+0x266>
      consputc('%');
    80005408:	02500513          	li	a0,37
    8000540c:	afbff0ef          	jal	80004f06 <consputc>
    80005410:	b509                	j	80005212 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80005412:	f7843783          	ld	a5,-136(s0)
    80005416:	e385                	bnez	a5,80005436 <printf+0x2b0>
    80005418:	74e6                	ld	s1,120(sp)
    8000541a:	7946                	ld	s2,112(sp)
    8000541c:	79a6                	ld	s3,104(sp)
    8000541e:	6ae6                	ld	s5,88(sp)
    80005420:	6b46                	ld	s6,80(sp)
    80005422:	6c06                	ld	s8,64(sp)
    80005424:	7ce2                	ld	s9,56(sp)
    80005426:	7d42                	ld	s10,48(sp)
    80005428:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    8000542a:	4501                	li	a0,0
    8000542c:	60aa                	ld	ra,136(sp)
    8000542e:	640a                	ld	s0,128(sp)
    80005430:	7a06                	ld	s4,96(sp)
    80005432:	6169                	addi	sp,sp,208
    80005434:	8082                	ret
    80005436:	74e6                	ld	s1,120(sp)
    80005438:	7946                	ld	s2,112(sp)
    8000543a:	79a6                	ld	s3,104(sp)
    8000543c:	6ae6                	ld	s5,88(sp)
    8000543e:	6b46                	ld	s6,80(sp)
    80005440:	6c06                	ld	s8,64(sp)
    80005442:	7ce2                	ld	s9,56(sp)
    80005444:	7d42                	ld	s10,48(sp)
    80005446:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005448:	0001e517          	auipc	a0,0x1e
    8000544c:	4e050513          	addi	a0,a0,1248 # 80023928 <pr>
    80005450:	3c8000ef          	jal	80005818 <release>
    80005454:	bfd9                	j	8000542a <printf+0x2a4>

0000000080005456 <panic>:

void
panic(char *s)
{
    80005456:	1101                	addi	sp,sp,-32
    80005458:	ec06                	sd	ra,24(sp)
    8000545a:	e822                	sd	s0,16(sp)
    8000545c:	e426                	sd	s1,8(sp)
    8000545e:	1000                	addi	s0,sp,32
    80005460:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005462:	0001e797          	auipc	a5,0x1e
    80005466:	4c07af23          	sw	zero,1246(a5) # 80023940 <pr+0x18>
  printf("panic: ");
    8000546a:	00002517          	auipc	a0,0x2
    8000546e:	36e50513          	addi	a0,a0,878 # 800077d8 <etext+0x7d8>
    80005472:	d15ff0ef          	jal	80005186 <printf>
  printf("%s\n", s);
    80005476:	85a6                	mv	a1,s1
    80005478:	00002517          	auipc	a0,0x2
    8000547c:	36850513          	addi	a0,a0,872 # 800077e0 <etext+0x7e0>
    80005480:	d07ff0ef          	jal	80005186 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005484:	4785                	li	a5,1
    80005486:	00005717          	auipc	a4,0x5
    8000548a:	faf72b23          	sw	a5,-74(a4) # 8000a43c <panicked>
  for(;;)
    8000548e:	a001                	j	8000548e <panic+0x38>

0000000080005490 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005490:	1101                	addi	sp,sp,-32
    80005492:	ec06                	sd	ra,24(sp)
    80005494:	e822                	sd	s0,16(sp)
    80005496:	e426                	sd	s1,8(sp)
    80005498:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000549a:	0001e497          	auipc	s1,0x1e
    8000549e:	48e48493          	addi	s1,s1,1166 # 80023928 <pr>
    800054a2:	00002597          	auipc	a1,0x2
    800054a6:	34658593          	addi	a1,a1,838 # 800077e8 <etext+0x7e8>
    800054aa:	8526                	mv	a0,s1
    800054ac:	254000ef          	jal	80005700 <initlock>
  pr.locking = 1;
    800054b0:	4785                	li	a5,1
    800054b2:	cc9c                	sw	a5,24(s1)
}
    800054b4:	60e2                	ld	ra,24(sp)
    800054b6:	6442                	ld	s0,16(sp)
    800054b8:	64a2                	ld	s1,8(sp)
    800054ba:	6105                	addi	sp,sp,32
    800054bc:	8082                	ret

00000000800054be <uartinit>:

void uartstart();

void
uartinit(void)
{
    800054be:	1141                	addi	sp,sp,-16
    800054c0:	e406                	sd	ra,8(sp)
    800054c2:	e022                	sd	s0,0(sp)
    800054c4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800054c6:	100007b7          	lui	a5,0x10000
    800054ca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800054ce:	10000737          	lui	a4,0x10000
    800054d2:	f8000693          	li	a3,-128
    800054d6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800054da:	468d                	li	a3,3
    800054dc:	10000637          	lui	a2,0x10000
    800054e0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800054e4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800054e8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800054ec:	8732                	mv	a4,a2
    800054ee:	461d                	li	a2,7
    800054f0:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800054f4:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800054f8:	00002597          	auipc	a1,0x2
    800054fc:	2f858593          	addi	a1,a1,760 # 800077f0 <etext+0x7f0>
    80005500:	0001e517          	auipc	a0,0x1e
    80005504:	44850513          	addi	a0,a0,1096 # 80023948 <uart_tx_lock>
    80005508:	1f8000ef          	jal	80005700 <initlock>
}
    8000550c:	60a2                	ld	ra,8(sp)
    8000550e:	6402                	ld	s0,0(sp)
    80005510:	0141                	addi	sp,sp,16
    80005512:	8082                	ret

0000000080005514 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005514:	1101                	addi	sp,sp,-32
    80005516:	ec06                	sd	ra,24(sp)
    80005518:	e822                	sd	s0,16(sp)
    8000551a:	e426                	sd	s1,8(sp)
    8000551c:	1000                	addi	s0,sp,32
    8000551e:	84aa                	mv	s1,a0
  push_off();
    80005520:	224000ef          	jal	80005744 <push_off>

  if(panicked){
    80005524:	00005797          	auipc	a5,0x5
    80005528:	f187a783          	lw	a5,-232(a5) # 8000a43c <panicked>
    8000552c:	e795                	bnez	a5,80005558 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000552e:	10000737          	lui	a4,0x10000
    80005532:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005534:	00074783          	lbu	a5,0(a4)
    80005538:	0207f793          	andi	a5,a5,32
    8000553c:	dfe5                	beqz	a5,80005534 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000553e:	0ff4f513          	zext.b	a0,s1
    80005542:	100007b7          	lui	a5,0x10000
    80005546:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000554a:	27e000ef          	jal	800057c8 <pop_off>
}
    8000554e:	60e2                	ld	ra,24(sp)
    80005550:	6442                	ld	s0,16(sp)
    80005552:	64a2                	ld	s1,8(sp)
    80005554:	6105                	addi	sp,sp,32
    80005556:	8082                	ret
    for(;;)
    80005558:	a001                	j	80005558 <uartputc_sync+0x44>

000000008000555a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000555a:	00005797          	auipc	a5,0x5
    8000555e:	ee67b783          	ld	a5,-282(a5) # 8000a440 <uart_tx_r>
    80005562:	00005717          	auipc	a4,0x5
    80005566:	ee673703          	ld	a4,-282(a4) # 8000a448 <uart_tx_w>
    8000556a:	08f70163          	beq	a4,a5,800055ec <uartstart+0x92>
{
    8000556e:	7139                	addi	sp,sp,-64
    80005570:	fc06                	sd	ra,56(sp)
    80005572:	f822                	sd	s0,48(sp)
    80005574:	f426                	sd	s1,40(sp)
    80005576:	f04a                	sd	s2,32(sp)
    80005578:	ec4e                	sd	s3,24(sp)
    8000557a:	e852                	sd	s4,16(sp)
    8000557c:	e456                	sd	s5,8(sp)
    8000557e:	e05a                	sd	s6,0(sp)
    80005580:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005582:	10000937          	lui	s2,0x10000
    80005586:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005588:	0001ea97          	auipc	s5,0x1e
    8000558c:	3c0a8a93          	addi	s5,s5,960 # 80023948 <uart_tx_lock>
    uart_tx_r += 1;
    80005590:	00005497          	auipc	s1,0x5
    80005594:	eb048493          	addi	s1,s1,-336 # 8000a440 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005598:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000559c:	00005997          	auipc	s3,0x5
    800055a0:	eac98993          	addi	s3,s3,-340 # 8000a448 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055a4:	00094703          	lbu	a4,0(s2)
    800055a8:	02077713          	andi	a4,a4,32
    800055ac:	c715                	beqz	a4,800055d8 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055ae:	01f7f713          	andi	a4,a5,31
    800055b2:	9756                	add	a4,a4,s5
    800055b4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800055b8:	0785                	addi	a5,a5,1
    800055ba:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800055bc:	8526                	mv	a0,s1
    800055be:	dc5fb0ef          	jal	80001382 <wakeup>
    WriteReg(THR, c);
    800055c2:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800055c6:	609c                	ld	a5,0(s1)
    800055c8:	0009b703          	ld	a4,0(s3)
    800055cc:	fcf71ce3          	bne	a4,a5,800055a4 <uartstart+0x4a>
      ReadReg(ISR);
    800055d0:	100007b7          	lui	a5,0x10000
    800055d4:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800055d8:	70e2                	ld	ra,56(sp)
    800055da:	7442                	ld	s0,48(sp)
    800055dc:	74a2                	ld	s1,40(sp)
    800055de:	7902                	ld	s2,32(sp)
    800055e0:	69e2                	ld	s3,24(sp)
    800055e2:	6a42                	ld	s4,16(sp)
    800055e4:	6aa2                	ld	s5,8(sp)
    800055e6:	6b02                	ld	s6,0(sp)
    800055e8:	6121                	addi	sp,sp,64
    800055ea:	8082                	ret
      ReadReg(ISR);
    800055ec:	100007b7          	lui	a5,0x10000
    800055f0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800055f4:	8082                	ret

00000000800055f6 <uartputc>:
{
    800055f6:	7179                	addi	sp,sp,-48
    800055f8:	f406                	sd	ra,40(sp)
    800055fa:	f022                	sd	s0,32(sp)
    800055fc:	ec26                	sd	s1,24(sp)
    800055fe:	e84a                	sd	s2,16(sp)
    80005600:	e44e                	sd	s3,8(sp)
    80005602:	e052                	sd	s4,0(sp)
    80005604:	1800                	addi	s0,sp,48
    80005606:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005608:	0001e517          	auipc	a0,0x1e
    8000560c:	34050513          	addi	a0,a0,832 # 80023948 <uart_tx_lock>
    80005610:	174000ef          	jal	80005784 <acquire>
  if(panicked){
    80005614:	00005797          	auipc	a5,0x5
    80005618:	e287a783          	lw	a5,-472(a5) # 8000a43c <panicked>
    8000561c:	efbd                	bnez	a5,8000569a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000561e:	00005717          	auipc	a4,0x5
    80005622:	e2a73703          	ld	a4,-470(a4) # 8000a448 <uart_tx_w>
    80005626:	00005797          	auipc	a5,0x5
    8000562a:	e1a7b783          	ld	a5,-486(a5) # 8000a440 <uart_tx_r>
    8000562e:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005632:	0001e997          	auipc	s3,0x1e
    80005636:	31698993          	addi	s3,s3,790 # 80023948 <uart_tx_lock>
    8000563a:	00005497          	auipc	s1,0x5
    8000563e:	e0648493          	addi	s1,s1,-506 # 8000a440 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005642:	00005917          	auipc	s2,0x5
    80005646:	e0690913          	addi	s2,s2,-506 # 8000a448 <uart_tx_w>
    8000564a:	00e79d63          	bne	a5,a4,80005664 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000564e:	85ce                	mv	a1,s3
    80005650:	8526                	mv	a0,s1
    80005652:	ce5fb0ef          	jal	80001336 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005656:	00093703          	ld	a4,0(s2)
    8000565a:	609c                	ld	a5,0(s1)
    8000565c:	02078793          	addi	a5,a5,32
    80005660:	fee787e3          	beq	a5,a4,8000564e <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005664:	0001e497          	auipc	s1,0x1e
    80005668:	2e448493          	addi	s1,s1,740 # 80023948 <uart_tx_lock>
    8000566c:	01f77793          	andi	a5,a4,31
    80005670:	97a6                	add	a5,a5,s1
    80005672:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005676:	0705                	addi	a4,a4,1
    80005678:	00005797          	auipc	a5,0x5
    8000567c:	dce7b823          	sd	a4,-560(a5) # 8000a448 <uart_tx_w>
  uartstart();
    80005680:	edbff0ef          	jal	8000555a <uartstart>
  release(&uart_tx_lock);
    80005684:	8526                	mv	a0,s1
    80005686:	192000ef          	jal	80005818 <release>
}
    8000568a:	70a2                	ld	ra,40(sp)
    8000568c:	7402                	ld	s0,32(sp)
    8000568e:	64e2                	ld	s1,24(sp)
    80005690:	6942                	ld	s2,16(sp)
    80005692:	69a2                	ld	s3,8(sp)
    80005694:	6a02                	ld	s4,0(sp)
    80005696:	6145                	addi	sp,sp,48
    80005698:	8082                	ret
    for(;;)
    8000569a:	a001                	j	8000569a <uartputc+0xa4>

000000008000569c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000569c:	1141                	addi	sp,sp,-16
    8000569e:	e406                	sd	ra,8(sp)
    800056a0:	e022                	sd	s0,0(sp)
    800056a2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800056a4:	100007b7          	lui	a5,0x10000
    800056a8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800056ac:	8b85                	andi	a5,a5,1
    800056ae:	cb89                	beqz	a5,800056c0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800056b0:	100007b7          	lui	a5,0x10000
    800056b4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800056b8:	60a2                	ld	ra,8(sp)
    800056ba:	6402                	ld	s0,0(sp)
    800056bc:	0141                	addi	sp,sp,16
    800056be:	8082                	ret
    return -1;
    800056c0:	557d                	li	a0,-1
    800056c2:	bfdd                	j	800056b8 <uartgetc+0x1c>

00000000800056c4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800056c4:	1101                	addi	sp,sp,-32
    800056c6:	ec06                	sd	ra,24(sp)
    800056c8:	e822                	sd	s0,16(sp)
    800056ca:	e426                	sd	s1,8(sp)
    800056cc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800056ce:	54fd                	li	s1,-1
    int c = uartgetc();
    800056d0:	fcdff0ef          	jal	8000569c <uartgetc>
    if(c == -1)
    800056d4:	00950563          	beq	a0,s1,800056de <uartintr+0x1a>
      break;
    consoleintr(c);
    800056d8:	861ff0ef          	jal	80004f38 <consoleintr>
  while(1){
    800056dc:	bfd5                	j	800056d0 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800056de:	0001e497          	auipc	s1,0x1e
    800056e2:	26a48493          	addi	s1,s1,618 # 80023948 <uart_tx_lock>
    800056e6:	8526                	mv	a0,s1
    800056e8:	09c000ef          	jal	80005784 <acquire>
  uartstart();
    800056ec:	e6fff0ef          	jal	8000555a <uartstart>
  release(&uart_tx_lock);
    800056f0:	8526                	mv	a0,s1
    800056f2:	126000ef          	jal	80005818 <release>
}
    800056f6:	60e2                	ld	ra,24(sp)
    800056f8:	6442                	ld	s0,16(sp)
    800056fa:	64a2                	ld	s1,8(sp)
    800056fc:	6105                	addi	sp,sp,32
    800056fe:	8082                	ret

0000000080005700 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005700:	1141                	addi	sp,sp,-16
    80005702:	e406                	sd	ra,8(sp)
    80005704:	e022                	sd	s0,0(sp)
    80005706:	0800                	addi	s0,sp,16
  lk->name = name;
    80005708:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000570a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000570e:	00053823          	sd	zero,16(a0)
}
    80005712:	60a2                	ld	ra,8(sp)
    80005714:	6402                	ld	s0,0(sp)
    80005716:	0141                	addi	sp,sp,16
    80005718:	8082                	ret

000000008000571a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000571a:	411c                	lw	a5,0(a0)
    8000571c:	e399                	bnez	a5,80005722 <holding+0x8>
    8000571e:	4501                	li	a0,0
  return r;
}
    80005720:	8082                	ret
{
    80005722:	1101                	addi	sp,sp,-32
    80005724:	ec06                	sd	ra,24(sp)
    80005726:	e822                	sd	s0,16(sp)
    80005728:	e426                	sd	s1,8(sp)
    8000572a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000572c:	6904                	ld	s1,16(a0)
    8000572e:	e0efb0ef          	jal	80000d3c <mycpu>
    80005732:	40a48533          	sub	a0,s1,a0
    80005736:	00153513          	seqz	a0,a0
}
    8000573a:	60e2                	ld	ra,24(sp)
    8000573c:	6442                	ld	s0,16(sp)
    8000573e:	64a2                	ld	s1,8(sp)
    80005740:	6105                	addi	sp,sp,32
    80005742:	8082                	ret

0000000080005744 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005744:	1101                	addi	sp,sp,-32
    80005746:	ec06                	sd	ra,24(sp)
    80005748:	e822                	sd	s0,16(sp)
    8000574a:	e426                	sd	s1,8(sp)
    8000574c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000574e:	100024f3          	csrr	s1,sstatus
    80005752:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005756:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005758:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000575c:	de0fb0ef          	jal	80000d3c <mycpu>
    80005760:	5d3c                	lw	a5,120(a0)
    80005762:	cb99                	beqz	a5,80005778 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005764:	dd8fb0ef          	jal	80000d3c <mycpu>
    80005768:	5d3c                	lw	a5,120(a0)
    8000576a:	2785                	addiw	a5,a5,1
    8000576c:	dd3c                	sw	a5,120(a0)
}
    8000576e:	60e2                	ld	ra,24(sp)
    80005770:	6442                	ld	s0,16(sp)
    80005772:	64a2                	ld	s1,8(sp)
    80005774:	6105                	addi	sp,sp,32
    80005776:	8082                	ret
    mycpu()->intena = old;
    80005778:	dc4fb0ef          	jal	80000d3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000577c:	8085                	srli	s1,s1,0x1
    8000577e:	8885                	andi	s1,s1,1
    80005780:	dd64                	sw	s1,124(a0)
    80005782:	b7cd                	j	80005764 <push_off+0x20>

0000000080005784 <acquire>:
{
    80005784:	1101                	addi	sp,sp,-32
    80005786:	ec06                	sd	ra,24(sp)
    80005788:	e822                	sd	s0,16(sp)
    8000578a:	e426                	sd	s1,8(sp)
    8000578c:	1000                	addi	s0,sp,32
    8000578e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005790:	fb5ff0ef          	jal	80005744 <push_off>
  if(holding(lk))
    80005794:	8526                	mv	a0,s1
    80005796:	f85ff0ef          	jal	8000571a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000579a:	4705                	li	a4,1
  if(holding(lk))
    8000579c:	e105                	bnez	a0,800057bc <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000579e:	87ba                	mv	a5,a4
    800057a0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800057a4:	2781                	sext.w	a5,a5
    800057a6:	ffe5                	bnez	a5,8000579e <acquire+0x1a>
  __sync_synchronize();
    800057a8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800057ac:	d90fb0ef          	jal	80000d3c <mycpu>
    800057b0:	e888                	sd	a0,16(s1)
}
    800057b2:	60e2                	ld	ra,24(sp)
    800057b4:	6442                	ld	s0,16(sp)
    800057b6:	64a2                	ld	s1,8(sp)
    800057b8:	6105                	addi	sp,sp,32
    800057ba:	8082                	ret
    panic("acquire");
    800057bc:	00002517          	auipc	a0,0x2
    800057c0:	03c50513          	addi	a0,a0,60 # 800077f8 <etext+0x7f8>
    800057c4:	c93ff0ef          	jal	80005456 <panic>

00000000800057c8 <pop_off>:

void
pop_off(void)
{
    800057c8:	1141                	addi	sp,sp,-16
    800057ca:	e406                	sd	ra,8(sp)
    800057cc:	e022                	sd	s0,0(sp)
    800057ce:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800057d0:	d6cfb0ef          	jal	80000d3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800057d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800057d8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800057da:	e39d                	bnez	a5,80005800 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800057dc:	5d3c                	lw	a5,120(a0)
    800057de:	02f05763          	blez	a5,8000580c <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    800057e2:	37fd                	addiw	a5,a5,-1
    800057e4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800057e6:	eb89                	bnez	a5,800057f8 <pop_off+0x30>
    800057e8:	5d7c                	lw	a5,124(a0)
    800057ea:	c799                	beqz	a5,800057f8 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800057ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800057f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800057f4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800057f8:	60a2                	ld	ra,8(sp)
    800057fa:	6402                	ld	s0,0(sp)
    800057fc:	0141                	addi	sp,sp,16
    800057fe:	8082                	ret
    panic("pop_off - interruptible");
    80005800:	00002517          	auipc	a0,0x2
    80005804:	00050513          	mv	a0,a0
    80005808:	c4fff0ef          	jal	80005456 <panic>
    panic("pop_off");
    8000580c:	00002517          	auipc	a0,0x2
    80005810:	00c50513          	addi	a0,a0,12 # 80007818 <etext+0x818>
    80005814:	c43ff0ef          	jal	80005456 <panic>

0000000080005818 <release>:
{
    80005818:	1101                	addi	sp,sp,-32
    8000581a:	ec06                	sd	ra,24(sp)
    8000581c:	e822                	sd	s0,16(sp)
    8000581e:	e426                	sd	s1,8(sp)
    80005820:	1000                	addi	s0,sp,32
    80005822:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005824:	ef7ff0ef          	jal	8000571a <holding>
    80005828:	c105                	beqz	a0,80005848 <release+0x30>
  lk->cpu = 0;
    8000582a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000582e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005832:	0310000f          	fence	rw,w
    80005836:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000583a:	f8fff0ef          	jal	800057c8 <pop_off>
}
    8000583e:	60e2                	ld	ra,24(sp)
    80005840:	6442                	ld	s0,16(sp)
    80005842:	64a2                	ld	s1,8(sp)
    80005844:	6105                	addi	sp,sp,32
    80005846:	8082                	ret
    panic("release");
    80005848:	00002517          	auipc	a0,0x2
    8000584c:	fd850513          	addi	a0,a0,-40 # 80007820 <etext+0x820>
    80005850:	c07ff0ef          	jal	80005456 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
