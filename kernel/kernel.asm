
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	26013103          	ld	sp,608(sp) # 8000a260 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	497040ef          	jal	80004cac <start>

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
    80000030:	00023797          	auipc	a5,0x23
    80000034:	5b078793          	addi	a5,a5,1456 # 800235e0 <end>
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
    80000050:	26490913          	addi	s2,s2,612 # 8000a2b0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	6be050ef          	jal	80005714 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	742050ef          	jal	800057a8 <release>
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
    8000007e:	368050ef          	jal	800053e6 <panic>

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
    800000de:	1d650513          	addi	a0,a0,470 # 8000a2b0 <kmem>
    800000e2:	5ae050ef          	jal	80005690 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	4f650513          	addi	a0,a0,1270 # 800235e0 <end>
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
    8000010c:	1a848493          	addi	s1,s1,424 # 8000a2b0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	602050ef          	jal	80005714 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	19450513          	addi	a0,a0,404 # 8000a2b0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	682050ef          	jal	800057a8 <release>

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
    80000144:	17050513          	addi	a0,a0,368 # 8000a2b0 <kmem>
    80000148:	660050ef          	jal	800057a8 <release>
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
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdba21>
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
    80000314:	f7070713          	addi	a4,a4,-144 # 8000a280 <started>
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
    80000332:	5e5040ef          	jal	80005116 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	50c010ef          	jal	80001846 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	3ba040ef          	jal	800046f8 <plicinithart>
  }

  scheduler();        
    80000342:	64f000ef          	jal	80001190 <scheduler>
    consoleinit();
    80000346:	503040ef          	jal	80005048 <consoleinit>
    printfinit();
    8000034a:	0d6050ef          	jal	80005420 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	5c1040ef          	jal	80005116 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	5b5040ef          	jal	80005116 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	5a9040ef          	jal	80005116 <printf>
    kinit();         // physical page allocator
    80000372:	d59ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    80000376:	2ce000ef          	jal	80000644 <kvminit>
    kvminithart();   // turn on paging
    8000037a:	03c000ef          	jal	800003b6 <kvminithart>
    procinit();      // process table
    8000037e:	0fb000ef          	jal	80000c78 <procinit>
    trapinit();      // trap vectors
    80000382:	4a0010ef          	jal	80001822 <trapinit>
    trapinithart();  // install kernel trap vector
    80000386:	4c0010ef          	jal	80001846 <trapinithart>
    plicinit();      // set up interrupt controller
    8000038a:	354040ef          	jal	800046de <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	36a040ef          	jal	800046f8 <plicinithart>
    binit();         // buffer cache
    80000392:	2d9010ef          	jal	80001e6a <binit>
    iinit();         // inode table
    80000396:	0a4020ef          	jal	8000243a <iinit>
    fileinit();      // file table
    8000039a:	673020ef          	jal	8000320c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	44a040ef          	jal	800047e8 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	423000ef          	jal	80000fc4 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	0000a717          	auipc	a4,0xa
    800003b0:	ecf72a23          	sw	a5,-300(a4) # 8000a280 <started>
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
    800003c6:	ec67b783          	ld	a5,-314(a5) # 8000a288 <kernel_pagetable>
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
    80000450:	797040ef          	jal	800053e6 <panic>
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
    8000052a:	6bd040ef          	jal	800053e6 <panic>
    panic("mappages: size not aligned");
    8000052e:	00007517          	auipc	a0,0x7
    80000532:	b4a50513          	addi	a0,a0,-1206 # 80007078 <etext+0x78>
    80000536:	6b1040ef          	jal	800053e6 <panic>
    panic("mappages: size");
    8000053a:	00007517          	auipc	a0,0x7
    8000053e:	b5e50513          	addi	a0,a0,-1186 # 80007098 <etext+0x98>
    80000542:	6a5040ef          	jal	800053e6 <panic>
      panic("mappages: remap");
    80000546:	00007517          	auipc	a0,0x7
    8000054a:	b6250513          	addi	a0,a0,-1182 # 800070a8 <etext+0xa8>
    8000054e:	699040ef          	jal	800053e6 <panic>
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
    80000594:	653040ef          	jal	800053e6 <panic>

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
    80000654:	c2a7bc23          	sd	a0,-968(a5) # 8000a288 <kernel_pagetable>
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
    800006a8:	53f040ef          	jal	800053e6 <panic>
      panic("uvmunmap: walk");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	533040ef          	jal	800053e6 <panic>
      panic("uvmunmap: not mapped");
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a3050513          	addi	a0,a0,-1488 # 800070e8 <etext+0xe8>
    800006c0:	527040ef          	jal	800053e6 <panic>
      panic("uvmunmap: not a leaf");
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a3c50513          	addi	a0,a0,-1476 # 80007100 <etext+0x100>
    800006cc:	51b040ef          	jal	800053e6 <panic>
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
    8000079c:	44b040ef          	jal	800053e6 <panic>

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
    800008d8:	30f040ef          	jal	800053e6 <panic>
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
    80000998:	24f040ef          	jal	800053e6 <panic>
      panic("uvmcopy: page not present");
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	243040ef          	jal	800053e6 <panic>
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
    80000a00:	1e7040ef          	jal	800053e6 <panic>

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
    80000bf8:	b0c48493          	addi	s1,s1,-1268 # 8000a700 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfc:	8c26                	mv	s8,s1
    80000bfe:	a4fa57b7          	lui	a5,0xa4fa5
    80000c02:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f819c5>
    80000c06:	4fa50937          	lui	s2,0x4fa50
    80000c0a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000c0e:	1902                	slli	s2,s2,0x20
    80000c10:	993e                	add	s2,s2,a5
    80000c12:	040009b7          	lui	s3,0x4000
    80000c16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c18:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c1a:	4b99                	li	s7,6
    80000c1c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	0000fa97          	auipc	s5,0xf
    80000c22:	4e2a8a93          	addi	s5,s5,1250 # 80010100 <tickslock>
    char *pa = kalloc();
    80000c26:	cd8ff0ef          	jal	800000fe <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	c121                	beqz	a0,80000c6c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	418485b3          	sub	a1,s1,s8
    80000c32:	858d                	srai	a1,a1,0x3
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
    80000c4c:	16848493          	addi	s1,s1,360
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
    80000c74:	772040ef          	jal	800053e6 <panic>

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
    80000c98:	63c50513          	addi	a0,a0,1596 # 8000a2d0 <pid_lock>
    80000c9c:	1f5040ef          	jal	80005690 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ca0:	00006597          	auipc	a1,0x6
    80000ca4:	50858593          	addi	a1,a1,1288 # 800071a8 <etext+0x1a8>
    80000ca8:	00009517          	auipc	a0,0x9
    80000cac:	64050513          	addi	a0,a0,1600 # 8000a2e8 <wait_lock>
    80000cb0:	1e1040ef          	jal	80005690 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb4:	0000a497          	auipc	s1,0xa
    80000cb8:	a4c48493          	addi	s1,s1,-1460 # 8000a700 <proc>
      initlock(&p->lock, "proc");
    80000cbc:	00006b17          	auipc	s6,0x6
    80000cc0:	4fcb0b13          	addi	s6,s6,1276 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc4:	8aa6                	mv	s5,s1
    80000cc6:	a4fa57b7          	lui	a5,0xa4fa5
    80000cca:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f819c5>
    80000cce:	4fa50937          	lui	s2,0x4fa50
    80000cd2:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000cd6:	1902                	slli	s2,s2,0x20
    80000cd8:	993e                	add	s2,s2,a5
    80000cda:	040009b7          	lui	s3,0x4000
    80000cde:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce2:	0000fa17          	auipc	s4,0xf
    80000ce6:	41ea0a13          	addi	s4,s4,1054 # 80010100 <tickslock>
      initlock(&p->lock, "proc");
    80000cea:	85da                	mv	a1,s6
    80000cec:	8526                	mv	a0,s1
    80000cee:	1a3040ef          	jal	80005690 <initlock>
      p->state = UNUSED;
    80000cf2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf6:	415487b3          	sub	a5,s1,s5
    80000cfa:	878d                	srai	a5,a5,0x3
    80000cfc:	032787b3          	mul	a5,a5,s2
    80000d00:	2785                	addiw	a5,a5,1
    80000d02:	00d7979b          	slliw	a5,a5,0xd
    80000d06:	40f987b3          	sub	a5,s3,a5
    80000d0a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	16848493          	addi	s1,s1,360
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
    80000d4e:	5b650513          	addi	a0,a0,1462 # 8000a300 <cpus>
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
    80000d66:	16f040ef          	jal	800056d4 <push_off>
    80000d6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d6c:	2781                	sext.w	a5,a5
    80000d6e:	079e                	slli	a5,a5,0x7
    80000d70:	00009717          	auipc	a4,0x9
    80000d74:	56070713          	addi	a4,a4,1376 # 8000a2d0 <pid_lock>
    80000d78:	97ba                	add	a5,a5,a4
    80000d7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d7c:	1dd040ef          	jal	80005758 <pop_off>
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
    80000d98:	211040ef          	jal	800057a8 <release>

  if (first) {
    80000d9c:	00009797          	auipc	a5,0x9
    80000da0:	4747a783          	lw	a5,1140(a5) # 8000a210 <first.1>
    80000da4:	e799                	bnez	a5,80000db2 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da6:	2bd000ef          	jal	80001862 <usertrapret>
}
    80000daa:	60a2                	ld	ra,8(sp)
    80000dac:	6402                	ld	s0,0(sp)
    80000dae:	0141                	addi	sp,sp,16
    80000db0:	8082                	ret
    fsinit(ROOTDEV);
    80000db2:	4505                	li	a0,1
    80000db4:	61a010ef          	jal	800023ce <fsinit>
    first = 0;
    80000db8:	00009797          	auipc	a5,0x9
    80000dbc:	4407ac23          	sw	zero,1112(a5) # 8000a210 <first.1>
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
    80000dd6:	4fe90913          	addi	s2,s2,1278 # 8000a2d0 <pid_lock>
    80000dda:	854a                	mv	a0,s2
    80000ddc:	139040ef          	jal	80005714 <acquire>
  pid = nextpid;
    80000de0:	00009797          	auipc	a5,0x9
    80000de4:	43478793          	addi	a5,a5,1076 # 8000a214 <nextpid>
    80000de8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000dea:	0014871b          	addiw	a4,s1,1
    80000dee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000df0:	854a                	mv	a0,s2
    80000df2:	1b7040ef          	jal	800057a8 <release>
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
    80000f2a:	00009497          	auipc	s1,0x9
    80000f2e:	7d648493          	addi	s1,s1,2006 # 8000a700 <proc>
    80000f32:	0000f917          	auipc	s2,0xf
    80000f36:	1ce90913          	addi	s2,s2,462 # 80010100 <tickslock>
    acquire(&p->lock);
    80000f3a:	8526                	mv	a0,s1
    80000f3c:	7d8040ef          	jal	80005714 <acquire>
    if(p->state == UNUSED) {
    80000f40:	4c9c                	lw	a5,24(s1)
    80000f42:	cb91                	beqz	a5,80000f56 <allocproc+0x38>
      release(&p->lock);
    80000f44:	8526                	mv	a0,s1
    80000f46:	063040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4a:	16848493          	addi	s1,s1,360
    80000f4e:	ff2496e3          	bne	s1,s2,80000f3a <allocproc+0x1c>
  return 0;
    80000f52:	4481                	li	s1,0
    80000f54:	a089                	j	80000f96 <allocproc+0x78>
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
    80000f68:	cd15                	beqz	a0,80000fa4 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	e99ff0ef          	jal	80000e04 <proc_pagetable>
    80000f70:	892a                	mv	s2,a0
    80000f72:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f74:	c121                	beqz	a0,80000fb4 <allocproc+0x96>
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
}
    80000f96:	8526                	mv	a0,s1
    80000f98:	60e2                	ld	ra,24(sp)
    80000f9a:	6442                	ld	s0,16(sp)
    80000f9c:	64a2                	ld	s1,8(sp)
    80000f9e:	6902                	ld	s2,0(sp)
    80000fa0:	6105                	addi	sp,sp,32
    80000fa2:	8082                	ret
    freeproc(p);
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	f29ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000faa:	8526                	mv	a0,s1
    80000fac:	7fc040ef          	jal	800057a8 <release>
    return 0;
    80000fb0:	84ca                	mv	s1,s2
    80000fb2:	b7d5                	j	80000f96 <allocproc+0x78>
    freeproc(p);
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	f19ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000fba:	8526                	mv	a0,s1
    80000fbc:	7ec040ef          	jal	800057a8 <release>
    return 0;
    80000fc0:	84ca                	mv	s1,s2
    80000fc2:	bfd1                	j	80000f96 <allocproc+0x78>

0000000080000fc4 <userinit>:
{
    80000fc4:	1101                	addi	sp,sp,-32
    80000fc6:	ec06                	sd	ra,24(sp)
    80000fc8:	e822                	sd	s0,16(sp)
    80000fca:	e426                	sd	s1,8(sp)
    80000fcc:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fce:	f51ff0ef          	jal	80000f1e <allocproc>
    80000fd2:	84aa                	mv	s1,a0
  initproc = p;
    80000fd4:	00009797          	auipc	a5,0x9
    80000fd8:	2aa7be23          	sd	a0,700(a5) # 8000a290 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fdc:	03400613          	li	a2,52
    80000fe0:	00009597          	auipc	a1,0x9
    80000fe4:	24058593          	addi	a1,a1,576 # 8000a220 <initcode>
    80000fe8:	6928                	ld	a0,80(a0)
    80000fea:	f58ff0ef          	jal	80000742 <uvmfirst>
  p->sz = PGSIZE;
    80000fee:	6785                	lui	a5,0x1
    80000ff0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ff2:	6cb8                	ld	a4,88(s1)
    80000ff4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ff8:	6cb8                	ld	a4,88(s1)
    80000ffa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000ffc:	4641                	li	a2,16
    80000ffe:	00006597          	auipc	a1,0x6
    80001002:	1c258593          	addi	a1,a1,450 # 800071c0 <etext+0x1c0>
    80001006:	15848513          	addi	a0,s1,344
    8000100a:	a96ff0ef          	jal	800002a0 <safestrcpy>
  p->cwd = namei("/");
    8000100e:	00006517          	auipc	a0,0x6
    80001012:	1c250513          	addi	a0,a0,450 # 800071d0 <etext+0x1d0>
    80001016:	4dd010ef          	jal	80002cf2 <namei>
    8000101a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101e:	478d                	li	a5,3
    80001020:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001022:	8526                	mv	a0,s1
    80001024:	784040ef          	jal	800057a8 <release>
}
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6105                	addi	sp,sp,32
    80001030:	8082                	ret

0000000080001032 <growproc>:
{
    80001032:	1101                	addi	sp,sp,-32
    80001034:	ec06                	sd	ra,24(sp)
    80001036:	e822                	sd	s0,16(sp)
    80001038:	e426                	sd	s1,8(sp)
    8000103a:	e04a                	sd	s2,0(sp)
    8000103c:	1000                	addi	s0,sp,32
    8000103e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001040:	d1dff0ef          	jal	80000d5c <myproc>
    80001044:	84aa                	mv	s1,a0
  sz = p->sz;
    80001046:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001048:	01204c63          	bgtz	s2,80001060 <growproc+0x2e>
  } else if(n < 0){
    8000104c:	02094463          	bltz	s2,80001074 <growproc+0x42>
  p->sz = sz;
    80001050:	e4ac                	sd	a1,72(s1)
  return 0;
    80001052:	4501                	li	a0,0
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	addi	sp,sp,32
    8000105e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001060:	4691                	li	a3,4
    80001062:	00b90633          	add	a2,s2,a1
    80001066:	6928                	ld	a0,80(a0)
    80001068:	f7cff0ef          	jal	800007e4 <uvmalloc>
    8000106c:	85aa                	mv	a1,a0
    8000106e:	f16d                	bnez	a0,80001050 <growproc+0x1e>
      return -1;
    80001070:	557d                	li	a0,-1
    80001072:	b7cd                	j	80001054 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001074:	00b90633          	add	a2,s2,a1
    80001078:	6928                	ld	a0,80(a0)
    8000107a:	f26ff0ef          	jal	800007a0 <uvmdealloc>
    8000107e:	85aa                	mv	a1,a0
    80001080:	bfc1                	j	80001050 <growproc+0x1e>

0000000080001082 <fork>:
{
    80001082:	7139                	addi	sp,sp,-64
    80001084:	fc06                	sd	ra,56(sp)
    80001086:	f822                	sd	s0,48(sp)
    80001088:	f04a                	sd	s2,32(sp)
    8000108a:	e456                	sd	s5,8(sp)
    8000108c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000108e:	ccfff0ef          	jal	80000d5c <myproc>
    80001092:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001094:	e8bff0ef          	jal	80000f1e <allocproc>
    80001098:	0e050a63          	beqz	a0,8000118c <fork+0x10a>
    8000109c:	e852                	sd	s4,16(sp)
    8000109e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010a0:	048ab603          	ld	a2,72(s5)
    800010a4:	692c                	ld	a1,80(a0)
    800010a6:	050ab503          	ld	a0,80(s5)
    800010aa:	87bff0ef          	jal	80000924 <uvmcopy>
    800010ae:	04054a63          	bltz	a0,80001102 <fork+0x80>
    800010b2:	f426                	sd	s1,40(sp)
    800010b4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010b6:	048ab783          	ld	a5,72(s5)
    800010ba:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010be:	058ab683          	ld	a3,88(s5)
    800010c2:	87b6                	mv	a5,a3
    800010c4:	058a3703          	ld	a4,88(s4)
    800010c8:	12068693          	addi	a3,a3,288
    800010cc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010d0:	6788                	ld	a0,8(a5)
    800010d2:	6b8c                	ld	a1,16(a5)
    800010d4:	6f90                	ld	a2,24(a5)
    800010d6:	01073023          	sd	a6,0(a4)
    800010da:	e708                	sd	a0,8(a4)
    800010dc:	eb0c                	sd	a1,16(a4)
    800010de:	ef10                	sd	a2,24(a4)
    800010e0:	02078793          	addi	a5,a5,32
    800010e4:	02070713          	addi	a4,a4,32
    800010e8:	fed792e3          	bne	a5,a3,800010cc <fork+0x4a>
  np->trapframe->a0 = 0;
    800010ec:	058a3783          	ld	a5,88(s4)
    800010f0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010f4:	0d0a8493          	addi	s1,s5,208
    800010f8:	0d0a0913          	addi	s2,s4,208
    800010fc:	150a8993          	addi	s3,s5,336
    80001100:	a831                	j	8000111c <fork+0x9a>
    freeproc(np);
    80001102:	8552                	mv	a0,s4
    80001104:	dcbff0ef          	jal	80000ece <freeproc>
    release(&np->lock);
    80001108:	8552                	mv	a0,s4
    8000110a:	69e040ef          	jal	800057a8 <release>
    return -1;
    8000110e:	597d                	li	s2,-1
    80001110:	6a42                	ld	s4,16(sp)
    80001112:	a0b5                	j	8000117e <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001114:	04a1                	addi	s1,s1,8
    80001116:	0921                	addi	s2,s2,8
    80001118:	01348963          	beq	s1,s3,8000112a <fork+0xa8>
    if(p->ofile[i])
    8000111c:	6088                	ld	a0,0(s1)
    8000111e:	d97d                	beqz	a0,80001114 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001120:	16e020ef          	jal	8000328e <filedup>
    80001124:	00a93023          	sd	a0,0(s2)
    80001128:	b7f5                	j	80001114 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000112a:	150ab503          	ld	a0,336(s5)
    8000112e:	49e010ef          	jal	800025cc <idup>
    80001132:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001136:	4641                	li	a2,16
    80001138:	158a8593          	addi	a1,s5,344
    8000113c:	158a0513          	addi	a0,s4,344
    80001140:	960ff0ef          	jal	800002a0 <safestrcpy>
  pid = np->pid;
    80001144:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001148:	8552                	mv	a0,s4
    8000114a:	65e040ef          	jal	800057a8 <release>
  acquire(&wait_lock);
    8000114e:	00009497          	auipc	s1,0x9
    80001152:	19a48493          	addi	s1,s1,410 # 8000a2e8 <wait_lock>
    80001156:	8526                	mv	a0,s1
    80001158:	5bc040ef          	jal	80005714 <acquire>
  np->parent = p;
    8000115c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001160:	8526                	mv	a0,s1
    80001162:	646040ef          	jal	800057a8 <release>
  acquire(&np->lock);
    80001166:	8552                	mv	a0,s4
    80001168:	5ac040ef          	jal	80005714 <acquire>
  np->state = RUNNABLE;
    8000116c:	478d                	li	a5,3
    8000116e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001172:	8552                	mv	a0,s4
    80001174:	634040ef          	jal	800057a8 <release>
  return pid;
    80001178:	74a2                	ld	s1,40(sp)
    8000117a:	69e2                	ld	s3,24(sp)
    8000117c:	6a42                	ld	s4,16(sp)
}
    8000117e:	854a                	mv	a0,s2
    80001180:	70e2                	ld	ra,56(sp)
    80001182:	7442                	ld	s0,48(sp)
    80001184:	7902                	ld	s2,32(sp)
    80001186:	6aa2                	ld	s5,8(sp)
    80001188:	6121                	addi	sp,sp,64
    8000118a:	8082                	ret
    return -1;
    8000118c:	597d                	li	s2,-1
    8000118e:	bfc5                	j	8000117e <fork+0xfc>

0000000080001190 <scheduler>:
{
    80001190:	715d                	addi	sp,sp,-80
    80001192:	e486                	sd	ra,72(sp)
    80001194:	e0a2                	sd	s0,64(sp)
    80001196:	fc26                	sd	s1,56(sp)
    80001198:	f84a                	sd	s2,48(sp)
    8000119a:	f44e                	sd	s3,40(sp)
    8000119c:	f052                	sd	s4,32(sp)
    8000119e:	ec56                	sd	s5,24(sp)
    800011a0:	e85a                	sd	s6,16(sp)
    800011a2:	e45e                	sd	s7,8(sp)
    800011a4:	e062                	sd	s8,0(sp)
    800011a6:	0880                	addi	s0,sp,80
    800011a8:	8792                	mv	a5,tp
  int id = r_tp();
    800011aa:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011ac:	00779b13          	slli	s6,a5,0x7
    800011b0:	00009717          	auipc	a4,0x9
    800011b4:	12070713          	addi	a4,a4,288 # 8000a2d0 <pid_lock>
    800011b8:	975a                	add	a4,a4,s6
    800011ba:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011be:	00009717          	auipc	a4,0x9
    800011c2:	14a70713          	addi	a4,a4,330 # 8000a308 <cpus+0x8>
    800011c6:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011c8:	4c11                	li	s8,4
        c->proc = p;
    800011ca:	079e                	slli	a5,a5,0x7
    800011cc:	00009a17          	auipc	s4,0x9
    800011d0:	104a0a13          	addi	s4,s4,260 # 8000a2d0 <pid_lock>
    800011d4:	9a3e                	add	s4,s4,a5
        found = 1;
    800011d6:	4b85                	li	s7,1
    800011d8:	a0a9                	j	80001222 <scheduler+0x92>
      release(&p->lock);
    800011da:	8526                	mv	a0,s1
    800011dc:	5cc040ef          	jal	800057a8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e0:	16848493          	addi	s1,s1,360
    800011e4:	03248563          	beq	s1,s2,8000120e <scheduler+0x7e>
      acquire(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	52a040ef          	jal	80005714 <acquire>
      if(p->state == RUNNABLE) {
    800011ee:	4c9c                	lw	a5,24(s1)
    800011f0:	ff3795e3          	bne	a5,s3,800011da <scheduler+0x4a>
        p->state = RUNNING;
    800011f4:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800011f8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800011fc:	06048593          	addi	a1,s1,96
    80001200:	855a                	mv	a0,s6
    80001202:	5b6000ef          	jal	800017b8 <swtch>
        c->proc = 0;
    80001206:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000120a:	8ade                	mv	s5,s7
    8000120c:	b7f9                	j	800011da <scheduler+0x4a>
    if(found == 0) {
    8000120e:	000a9a63          	bnez	s5,80001222 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001212:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001216:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000121a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000121e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001222:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001226:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000122a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000122e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001230:	00009497          	auipc	s1,0x9
    80001234:	4d048493          	addi	s1,s1,1232 # 8000a700 <proc>
      if(p->state == RUNNABLE) {
    80001238:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123a:	0000f917          	auipc	s2,0xf
    8000123e:	ec690913          	addi	s2,s2,-314 # 80010100 <tickslock>
    80001242:	b75d                	j	800011e8 <scheduler+0x58>

0000000080001244 <sched>:
{
    80001244:	7179                	addi	sp,sp,-48
    80001246:	f406                	sd	ra,40(sp)
    80001248:	f022                	sd	s0,32(sp)
    8000124a:	ec26                	sd	s1,24(sp)
    8000124c:	e84a                	sd	s2,16(sp)
    8000124e:	e44e                	sd	s3,8(sp)
    80001250:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001252:	b0bff0ef          	jal	80000d5c <myproc>
    80001256:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001258:	452040ef          	jal	800056aa <holding>
    8000125c:	c92d                	beqz	a0,800012ce <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000125e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001260:	2781                	sext.w	a5,a5
    80001262:	079e                	slli	a5,a5,0x7
    80001264:	00009717          	auipc	a4,0x9
    80001268:	06c70713          	addi	a4,a4,108 # 8000a2d0 <pid_lock>
    8000126c:	97ba                	add	a5,a5,a4
    8000126e:	0a87a703          	lw	a4,168(a5)
    80001272:	4785                	li	a5,1
    80001274:	06f71363          	bne	a4,a5,800012da <sched+0x96>
  if(p->state == RUNNING)
    80001278:	4c98                	lw	a4,24(s1)
    8000127a:	4791                	li	a5,4
    8000127c:	06f70563          	beq	a4,a5,800012e6 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001280:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001284:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001286:	e7b5                	bnez	a5,800012f2 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001288:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000128a:	00009917          	auipc	s2,0x9
    8000128e:	04690913          	addi	s2,s2,70 # 8000a2d0 <pid_lock>
    80001292:	2781                	sext.w	a5,a5
    80001294:	079e                	slli	a5,a5,0x7
    80001296:	97ca                	add	a5,a5,s2
    80001298:	0ac7a983          	lw	s3,172(a5)
    8000129c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000129e:	2781                	sext.w	a5,a5
    800012a0:	079e                	slli	a5,a5,0x7
    800012a2:	00009597          	auipc	a1,0x9
    800012a6:	06658593          	addi	a1,a1,102 # 8000a308 <cpus+0x8>
    800012aa:	95be                	add	a1,a1,a5
    800012ac:	06048513          	addi	a0,s1,96
    800012b0:	508000ef          	jal	800017b8 <swtch>
    800012b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012b6:	2781                	sext.w	a5,a5
    800012b8:	079e                	slli	a5,a5,0x7
    800012ba:	993e                	add	s2,s2,a5
    800012bc:	0b392623          	sw	s3,172(s2)
}
    800012c0:	70a2                	ld	ra,40(sp)
    800012c2:	7402                	ld	s0,32(sp)
    800012c4:	64e2                	ld	s1,24(sp)
    800012c6:	6942                	ld	s2,16(sp)
    800012c8:	69a2                	ld	s3,8(sp)
    800012ca:	6145                	addi	sp,sp,48
    800012cc:	8082                	ret
    panic("sched p->lock");
    800012ce:	00006517          	auipc	a0,0x6
    800012d2:	f0a50513          	addi	a0,a0,-246 # 800071d8 <etext+0x1d8>
    800012d6:	110040ef          	jal	800053e6 <panic>
    panic("sched locks");
    800012da:	00006517          	auipc	a0,0x6
    800012de:	f0e50513          	addi	a0,a0,-242 # 800071e8 <etext+0x1e8>
    800012e2:	104040ef          	jal	800053e6 <panic>
    panic("sched running");
    800012e6:	00006517          	auipc	a0,0x6
    800012ea:	f1250513          	addi	a0,a0,-238 # 800071f8 <etext+0x1f8>
    800012ee:	0f8040ef          	jal	800053e6 <panic>
    panic("sched interruptible");
    800012f2:	00006517          	auipc	a0,0x6
    800012f6:	f1650513          	addi	a0,a0,-234 # 80007208 <etext+0x208>
    800012fa:	0ec040ef          	jal	800053e6 <panic>

00000000800012fe <yield>:
{
    800012fe:	1101                	addi	sp,sp,-32
    80001300:	ec06                	sd	ra,24(sp)
    80001302:	e822                	sd	s0,16(sp)
    80001304:	e426                	sd	s1,8(sp)
    80001306:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001308:	a55ff0ef          	jal	80000d5c <myproc>
    8000130c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000130e:	406040ef          	jal	80005714 <acquire>
  p->state = RUNNABLE;
    80001312:	478d                	li	a5,3
    80001314:	cc9c                	sw	a5,24(s1)
  sched();
    80001316:	f2fff0ef          	jal	80001244 <sched>
  release(&p->lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	48c040ef          	jal	800057a8 <release>
}
    80001320:	60e2                	ld	ra,24(sp)
    80001322:	6442                	ld	s0,16(sp)
    80001324:	64a2                	ld	s1,8(sp)
    80001326:	6105                	addi	sp,sp,32
    80001328:	8082                	ret

000000008000132a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000132a:	7179                	addi	sp,sp,-48
    8000132c:	f406                	sd	ra,40(sp)
    8000132e:	f022                	sd	s0,32(sp)
    80001330:	ec26                	sd	s1,24(sp)
    80001332:	e84a                	sd	s2,16(sp)
    80001334:	e44e                	sd	s3,8(sp)
    80001336:	1800                	addi	s0,sp,48
    80001338:	89aa                	mv	s3,a0
    8000133a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000133c:	a21ff0ef          	jal	80000d5c <myproc>
    80001340:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001342:	3d2040ef          	jal	80005714 <acquire>
  release(lk);
    80001346:	854a                	mv	a0,s2
    80001348:	460040ef          	jal	800057a8 <release>

  // Go to sleep.
  p->chan = chan;
    8000134c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001350:	4789                	li	a5,2
    80001352:	cc9c                	sw	a5,24(s1)

  sched();
    80001354:	ef1ff0ef          	jal	80001244 <sched>

  // Tidy up.
  p->chan = 0;
    80001358:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000135c:	8526                	mv	a0,s1
    8000135e:	44a040ef          	jal	800057a8 <release>
  acquire(lk);
    80001362:	854a                	mv	a0,s2
    80001364:	3b0040ef          	jal	80005714 <acquire>
}
    80001368:	70a2                	ld	ra,40(sp)
    8000136a:	7402                	ld	s0,32(sp)
    8000136c:	64e2                	ld	s1,24(sp)
    8000136e:	6942                	ld	s2,16(sp)
    80001370:	69a2                	ld	s3,8(sp)
    80001372:	6145                	addi	sp,sp,48
    80001374:	8082                	ret

0000000080001376 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001376:	7139                	addi	sp,sp,-64
    80001378:	fc06                	sd	ra,56(sp)
    8000137a:	f822                	sd	s0,48(sp)
    8000137c:	f426                	sd	s1,40(sp)
    8000137e:	f04a                	sd	s2,32(sp)
    80001380:	ec4e                	sd	s3,24(sp)
    80001382:	e852                	sd	s4,16(sp)
    80001384:	e456                	sd	s5,8(sp)
    80001386:	0080                	addi	s0,sp,64
    80001388:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000138a:	00009497          	auipc	s1,0x9
    8000138e:	37648493          	addi	s1,s1,886 # 8000a700 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001392:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001394:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	0000f917          	auipc	s2,0xf
    8000139a:	d6a90913          	addi	s2,s2,-662 # 80010100 <tickslock>
    8000139e:	a801                	j	800013ae <wakeup+0x38>
      }
      release(&p->lock);
    800013a0:	8526                	mv	a0,s1
    800013a2:	406040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a6:	16848493          	addi	s1,s1,360
    800013aa:	03248263          	beq	s1,s2,800013ce <wakeup+0x58>
    if(p != myproc()){
    800013ae:	9afff0ef          	jal	80000d5c <myproc>
    800013b2:	fea48ae3          	beq	s1,a0,800013a6 <wakeup+0x30>
      acquire(&p->lock);
    800013b6:	8526                	mv	a0,s1
    800013b8:	35c040ef          	jal	80005714 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013bc:	4c9c                	lw	a5,24(s1)
    800013be:	ff3791e3          	bne	a5,s3,800013a0 <wakeup+0x2a>
    800013c2:	709c                	ld	a5,32(s1)
    800013c4:	fd479ee3          	bne	a5,s4,800013a0 <wakeup+0x2a>
        p->state = RUNNABLE;
    800013c8:	0154ac23          	sw	s5,24(s1)
    800013cc:	bfd1                	j	800013a0 <wakeup+0x2a>
    }
  }
}
    800013ce:	70e2                	ld	ra,56(sp)
    800013d0:	7442                	ld	s0,48(sp)
    800013d2:	74a2                	ld	s1,40(sp)
    800013d4:	7902                	ld	s2,32(sp)
    800013d6:	69e2                	ld	s3,24(sp)
    800013d8:	6a42                	ld	s4,16(sp)
    800013da:	6aa2                	ld	s5,8(sp)
    800013dc:	6121                	addi	sp,sp,64
    800013de:	8082                	ret

00000000800013e0 <reparent>:
{
    800013e0:	7179                	addi	sp,sp,-48
    800013e2:	f406                	sd	ra,40(sp)
    800013e4:	f022                	sd	s0,32(sp)
    800013e6:	ec26                	sd	s1,24(sp)
    800013e8:	e84a                	sd	s2,16(sp)
    800013ea:	e44e                	sd	s3,8(sp)
    800013ec:	e052                	sd	s4,0(sp)
    800013ee:	1800                	addi	s0,sp,48
    800013f0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f2:	00009497          	auipc	s1,0x9
    800013f6:	30e48493          	addi	s1,s1,782 # 8000a700 <proc>
      pp->parent = initproc;
    800013fa:	00009a17          	auipc	s4,0x9
    800013fe:	e96a0a13          	addi	s4,s4,-362 # 8000a290 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001402:	0000f997          	auipc	s3,0xf
    80001406:	cfe98993          	addi	s3,s3,-770 # 80010100 <tickslock>
    8000140a:	a029                	j	80001414 <reparent+0x34>
    8000140c:	16848493          	addi	s1,s1,360
    80001410:	01348b63          	beq	s1,s3,80001426 <reparent+0x46>
    if(pp->parent == p){
    80001414:	7c9c                	ld	a5,56(s1)
    80001416:	ff279be3          	bne	a5,s2,8000140c <reparent+0x2c>
      pp->parent = initproc;
    8000141a:	000a3503          	ld	a0,0(s4)
    8000141e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001420:	f57ff0ef          	jal	80001376 <wakeup>
    80001424:	b7e5                	j	8000140c <reparent+0x2c>
}
    80001426:	70a2                	ld	ra,40(sp)
    80001428:	7402                	ld	s0,32(sp)
    8000142a:	64e2                	ld	s1,24(sp)
    8000142c:	6942                	ld	s2,16(sp)
    8000142e:	69a2                	ld	s3,8(sp)
    80001430:	6a02                	ld	s4,0(sp)
    80001432:	6145                	addi	sp,sp,48
    80001434:	8082                	ret

0000000080001436 <exit>:
{
    80001436:	7179                	addi	sp,sp,-48
    80001438:	f406                	sd	ra,40(sp)
    8000143a:	f022                	sd	s0,32(sp)
    8000143c:	ec26                	sd	s1,24(sp)
    8000143e:	e84a                	sd	s2,16(sp)
    80001440:	e44e                	sd	s3,8(sp)
    80001442:	e052                	sd	s4,0(sp)
    80001444:	1800                	addi	s0,sp,48
    80001446:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001448:	915ff0ef          	jal	80000d5c <myproc>
    8000144c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000144e:	00009797          	auipc	a5,0x9
    80001452:	e427b783          	ld	a5,-446(a5) # 8000a290 <initproc>
    80001456:	0d050493          	addi	s1,a0,208
    8000145a:	15050913          	addi	s2,a0,336
    8000145e:	00a79b63          	bne	a5,a0,80001474 <exit+0x3e>
    panic("init exiting");
    80001462:	00006517          	auipc	a0,0x6
    80001466:	dbe50513          	addi	a0,a0,-578 # 80007220 <etext+0x220>
    8000146a:	77d030ef          	jal	800053e6 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000146e:	04a1                	addi	s1,s1,8
    80001470:	01248963          	beq	s1,s2,80001482 <exit+0x4c>
    if(p->ofile[fd]){
    80001474:	6088                	ld	a0,0(s1)
    80001476:	dd65                	beqz	a0,8000146e <exit+0x38>
      fileclose(f);
    80001478:	65d010ef          	jal	800032d4 <fileclose>
      p->ofile[fd] = 0;
    8000147c:	0004b023          	sd	zero,0(s1)
    80001480:	b7fd                	j	8000146e <exit+0x38>
  begin_op();
    80001482:	233010ef          	jal	80002eb4 <begin_op>
  iput(p->cwd);
    80001486:	1509b503          	ld	a0,336(s3)
    8000148a:	2fa010ef          	jal	80002784 <iput>
  end_op();
    8000148e:	291010ef          	jal	80002f1e <end_op>
  p->cwd = 0;
    80001492:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001496:	00009497          	auipc	s1,0x9
    8000149a:	e5248493          	addi	s1,s1,-430 # 8000a2e8 <wait_lock>
    8000149e:	8526                	mv	a0,s1
    800014a0:	274040ef          	jal	80005714 <acquire>
  reparent(p);
    800014a4:	854e                	mv	a0,s3
    800014a6:	f3bff0ef          	jal	800013e0 <reparent>
  wakeup(p->parent);
    800014aa:	0389b503          	ld	a0,56(s3)
    800014ae:	ec9ff0ef          	jal	80001376 <wakeup>
  acquire(&p->lock);
    800014b2:	854e                	mv	a0,s3
    800014b4:	260040ef          	jal	80005714 <acquire>
  p->xstate = status;
    800014b8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014bc:	4795                	li	a5,5
    800014be:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c2:	8526                	mv	a0,s1
    800014c4:	2e4040ef          	jal	800057a8 <release>
  sched();
    800014c8:	d7dff0ef          	jal	80001244 <sched>
  panic("zombie exit");
    800014cc:	00006517          	auipc	a0,0x6
    800014d0:	d6450513          	addi	a0,a0,-668 # 80007230 <etext+0x230>
    800014d4:	713030ef          	jal	800053e6 <panic>

00000000800014d8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014d8:	7179                	addi	sp,sp,-48
    800014da:	f406                	sd	ra,40(sp)
    800014dc:	f022                	sd	s0,32(sp)
    800014de:	ec26                	sd	s1,24(sp)
    800014e0:	e84a                	sd	s2,16(sp)
    800014e2:	e44e                	sd	s3,8(sp)
    800014e4:	1800                	addi	s0,sp,48
    800014e6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014e8:	00009497          	auipc	s1,0x9
    800014ec:	21848493          	addi	s1,s1,536 # 8000a700 <proc>
    800014f0:	0000f997          	auipc	s3,0xf
    800014f4:	c1098993          	addi	s3,s3,-1008 # 80010100 <tickslock>
    acquire(&p->lock);
    800014f8:	8526                	mv	a0,s1
    800014fa:	21a040ef          	jal	80005714 <acquire>
    if(p->pid == pid){
    800014fe:	589c                	lw	a5,48(s1)
    80001500:	01278b63          	beq	a5,s2,80001516 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001504:	8526                	mv	a0,s1
    80001506:	2a2040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000150a:	16848493          	addi	s1,s1,360
    8000150e:	ff3495e3          	bne	s1,s3,800014f8 <kill+0x20>
  }
  return -1;
    80001512:	557d                	li	a0,-1
    80001514:	a819                	j	8000152a <kill+0x52>
      p->killed = 1;
    80001516:	4785                	li	a5,1
    80001518:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000151a:	4c98                	lw	a4,24(s1)
    8000151c:	4789                	li	a5,2
    8000151e:	00f70d63          	beq	a4,a5,80001538 <kill+0x60>
      release(&p->lock);
    80001522:	8526                	mv	a0,s1
    80001524:	284040ef          	jal	800057a8 <release>
      return 0;
    80001528:	4501                	li	a0,0
}
    8000152a:	70a2                	ld	ra,40(sp)
    8000152c:	7402                	ld	s0,32(sp)
    8000152e:	64e2                	ld	s1,24(sp)
    80001530:	6942                	ld	s2,16(sp)
    80001532:	69a2                	ld	s3,8(sp)
    80001534:	6145                	addi	sp,sp,48
    80001536:	8082                	ret
        p->state = RUNNABLE;
    80001538:	478d                	li	a5,3
    8000153a:	cc9c                	sw	a5,24(s1)
    8000153c:	b7dd                	j	80001522 <kill+0x4a>

000000008000153e <setkilled>:

void
setkilled(struct proc *p)
{
    8000153e:	1101                	addi	sp,sp,-32
    80001540:	ec06                	sd	ra,24(sp)
    80001542:	e822                	sd	s0,16(sp)
    80001544:	e426                	sd	s1,8(sp)
    80001546:	1000                	addi	s0,sp,32
    80001548:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000154a:	1ca040ef          	jal	80005714 <acquire>
  p->killed = 1;
    8000154e:	4785                	li	a5,1
    80001550:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001552:	8526                	mv	a0,s1
    80001554:	254040ef          	jal	800057a8 <release>
}
    80001558:	60e2                	ld	ra,24(sp)
    8000155a:	6442                	ld	s0,16(sp)
    8000155c:	64a2                	ld	s1,8(sp)
    8000155e:	6105                	addi	sp,sp,32
    80001560:	8082                	ret

0000000080001562 <killed>:

int
killed(struct proc *p)
{
    80001562:	1101                	addi	sp,sp,-32
    80001564:	ec06                	sd	ra,24(sp)
    80001566:	e822                	sd	s0,16(sp)
    80001568:	e426                	sd	s1,8(sp)
    8000156a:	e04a                	sd	s2,0(sp)
    8000156c:	1000                	addi	s0,sp,32
    8000156e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001570:	1a4040ef          	jal	80005714 <acquire>
  k = p->killed;
    80001574:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	22e040ef          	jal	800057a8 <release>
  return k;
}
    8000157e:	854a                	mv	a0,s2
    80001580:	60e2                	ld	ra,24(sp)
    80001582:	6442                	ld	s0,16(sp)
    80001584:	64a2                	ld	s1,8(sp)
    80001586:	6902                	ld	s2,0(sp)
    80001588:	6105                	addi	sp,sp,32
    8000158a:	8082                	ret

000000008000158c <wait>:
{
    8000158c:	715d                	addi	sp,sp,-80
    8000158e:	e486                	sd	ra,72(sp)
    80001590:	e0a2                	sd	s0,64(sp)
    80001592:	fc26                	sd	s1,56(sp)
    80001594:	f84a                	sd	s2,48(sp)
    80001596:	f44e                	sd	s3,40(sp)
    80001598:	f052                	sd	s4,32(sp)
    8000159a:	ec56                	sd	s5,24(sp)
    8000159c:	e85a                	sd	s6,16(sp)
    8000159e:	e45e                	sd	s7,8(sp)
    800015a0:	0880                	addi	s0,sp,80
    800015a2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015a4:	fb8ff0ef          	jal	80000d5c <myproc>
    800015a8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015aa:	00009517          	auipc	a0,0x9
    800015ae:	d3e50513          	addi	a0,a0,-706 # 8000a2e8 <wait_lock>
    800015b2:	162040ef          	jal	80005714 <acquire>
        if(pp->state == ZOMBIE){
    800015b6:	4a15                	li	s4,5
        havekids = 1;
    800015b8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ba:	0000f997          	auipc	s3,0xf
    800015be:	b4698993          	addi	s3,s3,-1210 # 80010100 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015c2:	00009b97          	auipc	s7,0x9
    800015c6:	d26b8b93          	addi	s7,s7,-730 # 8000a2e8 <wait_lock>
    800015ca:	a869                	j	80001664 <wait+0xd8>
          pid = pp->pid;
    800015cc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015d0:	000b0c63          	beqz	s6,800015e8 <wait+0x5c>
    800015d4:	4691                	li	a3,4
    800015d6:	02c48613          	addi	a2,s1,44
    800015da:	85da                	mv	a1,s6
    800015dc:	05093503          	ld	a0,80(s2)
    800015e0:	c24ff0ef          	jal	80000a04 <copyout>
    800015e4:	02054a63          	bltz	a0,80001618 <wait+0x8c>
          freeproc(pp);
    800015e8:	8526                	mv	a0,s1
    800015ea:	8e5ff0ef          	jal	80000ece <freeproc>
          release(&pp->lock);
    800015ee:	8526                	mv	a0,s1
    800015f0:	1b8040ef          	jal	800057a8 <release>
          release(&wait_lock);
    800015f4:	00009517          	auipc	a0,0x9
    800015f8:	cf450513          	addi	a0,a0,-780 # 8000a2e8 <wait_lock>
    800015fc:	1ac040ef          	jal	800057a8 <release>
}
    80001600:	854e                	mv	a0,s3
    80001602:	60a6                	ld	ra,72(sp)
    80001604:	6406                	ld	s0,64(sp)
    80001606:	74e2                	ld	s1,56(sp)
    80001608:	7942                	ld	s2,48(sp)
    8000160a:	79a2                	ld	s3,40(sp)
    8000160c:	7a02                	ld	s4,32(sp)
    8000160e:	6ae2                	ld	s5,24(sp)
    80001610:	6b42                	ld	s6,16(sp)
    80001612:	6ba2                	ld	s7,8(sp)
    80001614:	6161                	addi	sp,sp,80
    80001616:	8082                	ret
            release(&pp->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	18e040ef          	jal	800057a8 <release>
            release(&wait_lock);
    8000161e:	00009517          	auipc	a0,0x9
    80001622:	cca50513          	addi	a0,a0,-822 # 8000a2e8 <wait_lock>
    80001626:	182040ef          	jal	800057a8 <release>
            return -1;
    8000162a:	59fd                	li	s3,-1
    8000162c:	bfd1                	j	80001600 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000162e:	16848493          	addi	s1,s1,360
    80001632:	03348063          	beq	s1,s3,80001652 <wait+0xc6>
      if(pp->parent == p){
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <wait+0xa2>
        acquire(&pp->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	0d6040ef          	jal	80005714 <acquire>
        if(pp->state == ZOMBIE){
    80001642:	4c9c                	lw	a5,24(s1)
    80001644:	f94784e3          	beq	a5,s4,800015cc <wait+0x40>
        release(&pp->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	15e040ef          	jal	800057a8 <release>
        havekids = 1;
    8000164e:	8756                	mv	a4,s5
    80001650:	bff9                	j	8000162e <wait+0xa2>
    if(!havekids || killed(p)){
    80001652:	cf19                	beqz	a4,80001670 <wait+0xe4>
    80001654:	854a                	mv	a0,s2
    80001656:	f0dff0ef          	jal	80001562 <killed>
    8000165a:	e919                	bnez	a0,80001670 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000165c:	85de                	mv	a1,s7
    8000165e:	854a                	mv	a0,s2
    80001660:	ccbff0ef          	jal	8000132a <sleep>
    havekids = 0;
    80001664:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001666:	00009497          	auipc	s1,0x9
    8000166a:	09a48493          	addi	s1,s1,154 # 8000a700 <proc>
    8000166e:	b7e1                	j	80001636 <wait+0xaa>
      release(&wait_lock);
    80001670:	00009517          	auipc	a0,0x9
    80001674:	c7850513          	addi	a0,a0,-904 # 8000a2e8 <wait_lock>
    80001678:	130040ef          	jal	800057a8 <release>
      return -1;
    8000167c:	59fd                	li	s3,-1
    8000167e:	b749                	j	80001600 <wait+0x74>

0000000080001680 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001680:	7179                	addi	sp,sp,-48
    80001682:	f406                	sd	ra,40(sp)
    80001684:	f022                	sd	s0,32(sp)
    80001686:	ec26                	sd	s1,24(sp)
    80001688:	e84a                	sd	s2,16(sp)
    8000168a:	e44e                	sd	s3,8(sp)
    8000168c:	e052                	sd	s4,0(sp)
    8000168e:	1800                	addi	s0,sp,48
    80001690:	84aa                	mv	s1,a0
    80001692:	892e                	mv	s2,a1
    80001694:	89b2                	mv	s3,a2
    80001696:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001698:	ec4ff0ef          	jal	80000d5c <myproc>
  if(user_dst){
    8000169c:	cc99                	beqz	s1,800016ba <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000169e:	86d2                	mv	a3,s4
    800016a0:	864e                	mv	a2,s3
    800016a2:	85ca                	mv	a1,s2
    800016a4:	6928                	ld	a0,80(a0)
    800016a6:	b5eff0ef          	jal	80000a04 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016aa:	70a2                	ld	ra,40(sp)
    800016ac:	7402                	ld	s0,32(sp)
    800016ae:	64e2                	ld	s1,24(sp)
    800016b0:	6942                	ld	s2,16(sp)
    800016b2:	69a2                	ld	s3,8(sp)
    800016b4:	6a02                	ld	s4,0(sp)
    800016b6:	6145                	addi	sp,sp,48
    800016b8:	8082                	ret
    memmove((char *)dst, src, len);
    800016ba:	000a061b          	sext.w	a2,s4
    800016be:	85ce                	mv	a1,s3
    800016c0:	854a                	mv	a0,s2
    800016c2:	af1fe0ef          	jal	800001b2 <memmove>
    return 0;
    800016c6:	8526                	mv	a0,s1
    800016c8:	b7cd                	j	800016aa <either_copyout+0x2a>

00000000800016ca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016ca:	7179                	addi	sp,sp,-48
    800016cc:	f406                	sd	ra,40(sp)
    800016ce:	f022                	sd	s0,32(sp)
    800016d0:	ec26                	sd	s1,24(sp)
    800016d2:	e84a                	sd	s2,16(sp)
    800016d4:	e44e                	sd	s3,8(sp)
    800016d6:	e052                	sd	s4,0(sp)
    800016d8:	1800                	addi	s0,sp,48
    800016da:	892a                	mv	s2,a0
    800016dc:	84ae                	mv	s1,a1
    800016de:	89b2                	mv	s3,a2
    800016e0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016e2:	e7aff0ef          	jal	80000d5c <myproc>
  if(user_src){
    800016e6:	cc99                	beqz	s1,80001704 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016e8:	86d2                	mv	a3,s4
    800016ea:	864e                	mv	a2,s3
    800016ec:	85ca                	mv	a1,s2
    800016ee:	6928                	ld	a0,80(a0)
    800016f0:	bc4ff0ef          	jal	80000ab4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016f4:	70a2                	ld	ra,40(sp)
    800016f6:	7402                	ld	s0,32(sp)
    800016f8:	64e2                	ld	s1,24(sp)
    800016fa:	6942                	ld	s2,16(sp)
    800016fc:	69a2                	ld	s3,8(sp)
    800016fe:	6a02                	ld	s4,0(sp)
    80001700:	6145                	addi	sp,sp,48
    80001702:	8082                	ret
    memmove(dst, (char*)src, len);
    80001704:	000a061b          	sext.w	a2,s4
    80001708:	85ce                	mv	a1,s3
    8000170a:	854a                	mv	a0,s2
    8000170c:	aa7fe0ef          	jal	800001b2 <memmove>
    return 0;
    80001710:	8526                	mv	a0,s1
    80001712:	b7cd                	j	800016f4 <either_copyin+0x2a>

0000000080001714 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001714:	715d                	addi	sp,sp,-80
    80001716:	e486                	sd	ra,72(sp)
    80001718:	e0a2                	sd	s0,64(sp)
    8000171a:	fc26                	sd	s1,56(sp)
    8000171c:	f84a                	sd	s2,48(sp)
    8000171e:	f44e                	sd	s3,40(sp)
    80001720:	f052                	sd	s4,32(sp)
    80001722:	ec56                	sd	s5,24(sp)
    80001724:	e85a                	sd	s6,16(sp)
    80001726:	e45e                	sd	s7,8(sp)
    80001728:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000172a:	00006517          	auipc	a0,0x6
    8000172e:	8ee50513          	addi	a0,a0,-1810 # 80007018 <etext+0x18>
    80001732:	1e5030ef          	jal	80005116 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001736:	00009497          	auipc	s1,0x9
    8000173a:	12248493          	addi	s1,s1,290 # 8000a858 <proc+0x158>
    8000173e:	0000f917          	auipc	s2,0xf
    80001742:	b1a90913          	addi	s2,s2,-1254 # 80010258 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001746:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001748:	00006997          	auipc	s3,0x6
    8000174c:	af898993          	addi	s3,s3,-1288 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001750:	00006a97          	auipc	s5,0x6
    80001754:	af8a8a93          	addi	s5,s5,-1288 # 80007248 <etext+0x248>
    printf("\n");
    80001758:	00006a17          	auipc	s4,0x6
    8000175c:	8c0a0a13          	addi	s4,s4,-1856 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001760:	00006b97          	auipc	s7,0x6
    80001764:	010b8b93          	addi	s7,s7,16 # 80007770 <states.0>
    80001768:	a829                	j	80001782 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000176a:	ed86a583          	lw	a1,-296(a3)
    8000176e:	8556                	mv	a0,s5
    80001770:	1a7030ef          	jal	80005116 <printf>
    printf("\n");
    80001774:	8552                	mv	a0,s4
    80001776:	1a1030ef          	jal	80005116 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000177a:	16848493          	addi	s1,s1,360
    8000177e:	03248263          	beq	s1,s2,800017a2 <procdump+0x8e>
    if(p->state == UNUSED)
    80001782:	86a6                	mv	a3,s1
    80001784:	ec04a783          	lw	a5,-320(s1)
    80001788:	dbed                	beqz	a5,8000177a <procdump+0x66>
      state = "???";
    8000178a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000178c:	fcfb6fe3          	bltu	s6,a5,8000176a <procdump+0x56>
    80001790:	02079713          	slli	a4,a5,0x20
    80001794:	01d75793          	srli	a5,a4,0x1d
    80001798:	97de                	add	a5,a5,s7
    8000179a:	6390                	ld	a2,0(a5)
    8000179c:	f679                	bnez	a2,8000176a <procdump+0x56>
      state = "???";
    8000179e:	864e                	mv	a2,s3
    800017a0:	b7e9                	j	8000176a <procdump+0x56>
  }
}
    800017a2:	60a6                	ld	ra,72(sp)
    800017a4:	6406                	ld	s0,64(sp)
    800017a6:	74e2                	ld	s1,56(sp)
    800017a8:	7942                	ld	s2,48(sp)
    800017aa:	79a2                	ld	s3,40(sp)
    800017ac:	7a02                	ld	s4,32(sp)
    800017ae:	6ae2                	ld	s5,24(sp)
    800017b0:	6b42                	ld	s6,16(sp)
    800017b2:	6ba2                	ld	s7,8(sp)
    800017b4:	6161                	addi	sp,sp,80
    800017b6:	8082                	ret

00000000800017b8 <swtch>:
    800017b8:	00153023          	sd	ra,0(a0)
    800017bc:	00253423          	sd	sp,8(a0)
    800017c0:	e900                	sd	s0,16(a0)
    800017c2:	ed04                	sd	s1,24(a0)
    800017c4:	03253023          	sd	s2,32(a0)
    800017c8:	03353423          	sd	s3,40(a0)
    800017cc:	03453823          	sd	s4,48(a0)
    800017d0:	03553c23          	sd	s5,56(a0)
    800017d4:	05653023          	sd	s6,64(a0)
    800017d8:	05753423          	sd	s7,72(a0)
    800017dc:	05853823          	sd	s8,80(a0)
    800017e0:	05953c23          	sd	s9,88(a0)
    800017e4:	07a53023          	sd	s10,96(a0)
    800017e8:	07b53423          	sd	s11,104(a0)
    800017ec:	0005b083          	ld	ra,0(a1)
    800017f0:	0085b103          	ld	sp,8(a1)
    800017f4:	6980                	ld	s0,16(a1)
    800017f6:	6d84                	ld	s1,24(a1)
    800017f8:	0205b903          	ld	s2,32(a1)
    800017fc:	0285b983          	ld	s3,40(a1)
    80001800:	0305ba03          	ld	s4,48(a1)
    80001804:	0385ba83          	ld	s5,56(a1)
    80001808:	0405bb03          	ld	s6,64(a1)
    8000180c:	0485bb83          	ld	s7,72(a1)
    80001810:	0505bc03          	ld	s8,80(a1)
    80001814:	0585bc83          	ld	s9,88(a1)
    80001818:	0605bd03          	ld	s10,96(a1)
    8000181c:	0685bd83          	ld	s11,104(a1)
    80001820:	8082                	ret

0000000080001822 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001822:	1141                	addi	sp,sp,-16
    80001824:	e406                	sd	ra,8(sp)
    80001826:	e022                	sd	s0,0(sp)
    80001828:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000182a:	00006597          	auipc	a1,0x6
    8000182e:	a5e58593          	addi	a1,a1,-1442 # 80007288 <etext+0x288>
    80001832:	0000f517          	auipc	a0,0xf
    80001836:	8ce50513          	addi	a0,a0,-1842 # 80010100 <tickslock>
    8000183a:	657030ef          	jal	80005690 <initlock>
}
    8000183e:	60a2                	ld	ra,8(sp)
    80001840:	6402                	ld	s0,0(sp)
    80001842:	0141                	addi	sp,sp,16
    80001844:	8082                	ret

0000000080001846 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001846:	1141                	addi	sp,sp,-16
    80001848:	e406                	sd	ra,8(sp)
    8000184a:	e022                	sd	s0,0(sp)
    8000184c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000184e:	00003797          	auipc	a5,0x3
    80001852:	e3278793          	addi	a5,a5,-462 # 80004680 <kernelvec>
    80001856:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000185a:	60a2                	ld	ra,8(sp)
    8000185c:	6402                	ld	s0,0(sp)
    8000185e:	0141                	addi	sp,sp,16
    80001860:	8082                	ret

0000000080001862 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001862:	1141                	addi	sp,sp,-16
    80001864:	e406                	sd	ra,8(sp)
    80001866:	e022                	sd	s0,0(sp)
    80001868:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000186a:	cf2ff0ef          	jal	80000d5c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000186e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001872:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001874:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001878:	00004697          	auipc	a3,0x4
    8000187c:	78868693          	addi	a3,a3,1928 # 80006000 <_trampoline>
    80001880:	00004717          	auipc	a4,0x4
    80001884:	78070713          	addi	a4,a4,1920 # 80006000 <_trampoline>
    80001888:	8f15                	sub	a4,a4,a3
    8000188a:	040007b7          	lui	a5,0x4000
    8000188e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001890:	07b2                	slli	a5,a5,0xc
    80001892:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001894:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001898:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000189a:	18002673          	csrr	a2,satp
    8000189e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018a0:	6d30                	ld	a2,88(a0)
    800018a2:	6138                	ld	a4,64(a0)
    800018a4:	6585                	lui	a1,0x1
    800018a6:	972e                	add	a4,a4,a1
    800018a8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018aa:	6d38                	ld	a4,88(a0)
    800018ac:	00000617          	auipc	a2,0x0
    800018b0:	11060613          	addi	a2,a2,272 # 800019bc <usertrap>
    800018b4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018b6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018b8:	8612                	mv	a2,tp
    800018ba:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018bc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018c0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018c4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018c8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018cc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018ce:	6f18                	ld	a4,24(a4)
    800018d0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018d4:	6928                	ld	a0,80(a0)
    800018d6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018d8:	00004717          	auipc	a4,0x4
    800018dc:	7c470713          	addi	a4,a4,1988 # 8000609c <userret>
    800018e0:	8f15                	sub	a4,a4,a3
    800018e2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018e4:	577d                	li	a4,-1
    800018e6:	177e                	slli	a4,a4,0x3f
    800018e8:	8d59                	or	a0,a0,a4
    800018ea:	9782                	jalr	a5
}
    800018ec:	60a2                	ld	ra,8(sp)
    800018ee:	6402                	ld	s0,0(sp)
    800018f0:	0141                	addi	sp,sp,16
    800018f2:	8082                	ret

00000000800018f4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018f4:	1101                	addi	sp,sp,-32
    800018f6:	ec06                	sd	ra,24(sp)
    800018f8:	e822                	sd	s0,16(sp)
    800018fa:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018fc:	c2cff0ef          	jal	80000d28 <cpuid>
    80001900:	cd11                	beqz	a0,8000191c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001902:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001906:	000f4737          	lui	a4,0xf4
    8000190a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000190e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001910:	14d79073          	csrw	stimecmp,a5
}
    80001914:	60e2                	ld	ra,24(sp)
    80001916:	6442                	ld	s0,16(sp)
    80001918:	6105                	addi	sp,sp,32
    8000191a:	8082                	ret
    8000191c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000191e:	0000e497          	auipc	s1,0xe
    80001922:	7e248493          	addi	s1,s1,2018 # 80010100 <tickslock>
    80001926:	8526                	mv	a0,s1
    80001928:	5ed030ef          	jal	80005714 <acquire>
    ticks++;
    8000192c:	00009517          	auipc	a0,0x9
    80001930:	96c50513          	addi	a0,a0,-1684 # 8000a298 <ticks>
    80001934:	411c                	lw	a5,0(a0)
    80001936:	2785                	addiw	a5,a5,1
    80001938:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000193a:	a3dff0ef          	jal	80001376 <wakeup>
    release(&tickslock);
    8000193e:	8526                	mv	a0,s1
    80001940:	669030ef          	jal	800057a8 <release>
    80001944:	64a2                	ld	s1,8(sp)
    80001946:	bf75                	j	80001902 <clockintr+0xe>

0000000080001948 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001948:	1101                	addi	sp,sp,-32
    8000194a:	ec06                	sd	ra,24(sp)
    8000194c:	e822                	sd	s0,16(sp)
    8000194e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001950:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001954:	57fd                	li	a5,-1
    80001956:	17fe                	slli	a5,a5,0x3f
    80001958:	07a5                	addi	a5,a5,9
    8000195a:	00f70c63          	beq	a4,a5,80001972 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000195e:	57fd                	li	a5,-1
    80001960:	17fe                	slli	a5,a5,0x3f
    80001962:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001964:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001966:	04f70763          	beq	a4,a5,800019b4 <devintr+0x6c>
  }
}
    8000196a:	60e2                	ld	ra,24(sp)
    8000196c:	6442                	ld	s0,16(sp)
    8000196e:	6105                	addi	sp,sp,32
    80001970:	8082                	ret
    80001972:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001974:	5b9020ef          	jal	8000472c <plic_claim>
    80001978:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000197a:	47a9                	li	a5,10
    8000197c:	00f50963          	beq	a0,a5,8000198e <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001980:	4785                	li	a5,1
    80001982:	00f50963          	beq	a0,a5,80001994 <devintr+0x4c>
    return 1;
    80001986:	4505                	li	a0,1
    } else if(irq){
    80001988:	e889                	bnez	s1,8000199a <devintr+0x52>
    8000198a:	64a2                	ld	s1,8(sp)
    8000198c:	bff9                	j	8000196a <devintr+0x22>
      uartintr();
    8000198e:	4c7030ef          	jal	80005654 <uartintr>
    if(irq)
    80001992:	a819                	j	800019a8 <devintr+0x60>
      virtio_disk_intr();
    80001994:	228030ef          	jal	80004bbc <virtio_disk_intr>
    if(irq)
    80001998:	a801                	j	800019a8 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000199a:	85a6                	mv	a1,s1
    8000199c:	00006517          	auipc	a0,0x6
    800019a0:	8f450513          	addi	a0,a0,-1804 # 80007290 <etext+0x290>
    800019a4:	772030ef          	jal	80005116 <printf>
      plic_complete(irq);
    800019a8:	8526                	mv	a0,s1
    800019aa:	5a3020ef          	jal	8000474c <plic_complete>
    return 1;
    800019ae:	4505                	li	a0,1
    800019b0:	64a2                	ld	s1,8(sp)
    800019b2:	bf65                	j	8000196a <devintr+0x22>
    clockintr();
    800019b4:	f41ff0ef          	jal	800018f4 <clockintr>
    return 2;
    800019b8:	4509                	li	a0,2
    800019ba:	bf45                	j	8000196a <devintr+0x22>

00000000800019bc <usertrap>:
{
    800019bc:	1101                	addi	sp,sp,-32
    800019be:	ec06                	sd	ra,24(sp)
    800019c0:	e822                	sd	s0,16(sp)
    800019c2:	e426                	sd	s1,8(sp)
    800019c4:	e04a                	sd	s2,0(sp)
    800019c6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019c8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019cc:	1007f793          	andi	a5,a5,256
    800019d0:	ef85                	bnez	a5,80001a08 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019d2:	00003797          	auipc	a5,0x3
    800019d6:	cae78793          	addi	a5,a5,-850 # 80004680 <kernelvec>
    800019da:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019de:	b7eff0ef          	jal	80000d5c <myproc>
    800019e2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019e4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019e6:	14102773          	csrr	a4,sepc
    800019ea:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ec:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019f0:	47a1                	li	a5,8
    800019f2:	02f70163          	beq	a4,a5,80001a14 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019f6:	f53ff0ef          	jal	80001948 <devintr>
    800019fa:	892a                	mv	s2,a0
    800019fc:	c135                	beqz	a0,80001a60 <usertrap+0xa4>
  if(killed(p))
    800019fe:	8526                	mv	a0,s1
    80001a00:	b63ff0ef          	jal	80001562 <killed>
    80001a04:	cd1d                	beqz	a0,80001a42 <usertrap+0x86>
    80001a06:	a81d                	j	80001a3c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a08:	00006517          	auipc	a0,0x6
    80001a0c:	8a850513          	addi	a0,a0,-1880 # 800072b0 <etext+0x2b0>
    80001a10:	1d7030ef          	jal	800053e6 <panic>
    if(killed(p))
    80001a14:	b4fff0ef          	jal	80001562 <killed>
    80001a18:	e121                	bnez	a0,80001a58 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a1a:	6cb8                	ld	a4,88(s1)
    80001a1c:	6f1c                	ld	a5,24(a4)
    80001a1e:	0791                	addi	a5,a5,4
    80001a20:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a26:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a2a:	10079073          	csrw	sstatus,a5
    syscall();
    80001a2e:	240000ef          	jal	80001c6e <syscall>
  if(killed(p))
    80001a32:	8526                	mv	a0,s1
    80001a34:	b2fff0ef          	jal	80001562 <killed>
    80001a38:	c901                	beqz	a0,80001a48 <usertrap+0x8c>
    80001a3a:	4901                	li	s2,0
    exit(-1);
    80001a3c:	557d                	li	a0,-1
    80001a3e:	9f9ff0ef          	jal	80001436 <exit>
  if(which_dev == 2)
    80001a42:	4789                	li	a5,2
    80001a44:	04f90563          	beq	s2,a5,80001a8e <usertrap+0xd2>
  usertrapret();
    80001a48:	e1bff0ef          	jal	80001862 <usertrapret>
}
    80001a4c:	60e2                	ld	ra,24(sp)
    80001a4e:	6442                	ld	s0,16(sp)
    80001a50:	64a2                	ld	s1,8(sp)
    80001a52:	6902                	ld	s2,0(sp)
    80001a54:	6105                	addi	sp,sp,32
    80001a56:	8082                	ret
      exit(-1);
    80001a58:	557d                	li	a0,-1
    80001a5a:	9ddff0ef          	jal	80001436 <exit>
    80001a5e:	bf75                	j	80001a1a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a60:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a64:	5890                	lw	a2,48(s1)
    80001a66:	00006517          	auipc	a0,0x6
    80001a6a:	86a50513          	addi	a0,a0,-1942 # 800072d0 <etext+0x2d0>
    80001a6e:	6a8030ef          	jal	80005116 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a76:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a7a:	00006517          	auipc	a0,0x6
    80001a7e:	88650513          	addi	a0,a0,-1914 # 80007300 <etext+0x300>
    80001a82:	694030ef          	jal	80005116 <printf>
    setkilled(p);
    80001a86:	8526                	mv	a0,s1
    80001a88:	ab7ff0ef          	jal	8000153e <setkilled>
    80001a8c:	b75d                	j	80001a32 <usertrap+0x76>
    yield();
    80001a8e:	871ff0ef          	jal	800012fe <yield>
    80001a92:	bf5d                	j	80001a48 <usertrap+0x8c>

0000000080001a94 <kerneltrap>:
{
    80001a94:	7179                	addi	sp,sp,-48
    80001a96:	f406                	sd	ra,40(sp)
    80001a98:	f022                	sd	s0,32(sp)
    80001a9a:	ec26                	sd	s1,24(sp)
    80001a9c:	e84a                	sd	s2,16(sp)
    80001a9e:	e44e                	sd	s3,8(sp)
    80001aa0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aa2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aa6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aaa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001aae:	1004f793          	andi	a5,s1,256
    80001ab2:	c795                	beqz	a5,80001ade <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ab8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001aba:	eb85                	bnez	a5,80001aea <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001abc:	e8dff0ef          	jal	80001948 <devintr>
    80001ac0:	c91d                	beqz	a0,80001af6 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ac2:	4789                	li	a5,2
    80001ac4:	04f50a63          	beq	a0,a5,80001b18 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ac8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001acc:	10049073          	csrw	sstatus,s1
}
    80001ad0:	70a2                	ld	ra,40(sp)
    80001ad2:	7402                	ld	s0,32(sp)
    80001ad4:	64e2                	ld	s1,24(sp)
    80001ad6:	6942                	ld	s2,16(sp)
    80001ad8:	69a2                	ld	s3,8(sp)
    80001ada:	6145                	addi	sp,sp,48
    80001adc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ade:	00006517          	auipc	a0,0x6
    80001ae2:	84a50513          	addi	a0,a0,-1974 # 80007328 <etext+0x328>
    80001ae6:	101030ef          	jal	800053e6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001aea:	00006517          	auipc	a0,0x6
    80001aee:	86650513          	addi	a0,a0,-1946 # 80007350 <etext+0x350>
    80001af2:	0f5030ef          	jal	800053e6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001af6:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001afa:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001afe:	85ce                	mv	a1,s3
    80001b00:	00006517          	auipc	a0,0x6
    80001b04:	87050513          	addi	a0,a0,-1936 # 80007370 <etext+0x370>
    80001b08:	60e030ef          	jal	80005116 <printf>
    panic("kerneltrap");
    80001b0c:	00006517          	auipc	a0,0x6
    80001b10:	88c50513          	addi	a0,a0,-1908 # 80007398 <etext+0x398>
    80001b14:	0d3030ef          	jal	800053e6 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b18:	a44ff0ef          	jal	80000d5c <myproc>
    80001b1c:	d555                	beqz	a0,80001ac8 <kerneltrap+0x34>
    yield();
    80001b1e:	fe0ff0ef          	jal	800012fe <yield>
    80001b22:	b75d                	j	80001ac8 <kerneltrap+0x34>

0000000080001b24 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b24:	1101                	addi	sp,sp,-32
    80001b26:	ec06                	sd	ra,24(sp)
    80001b28:	e822                	sd	s0,16(sp)
    80001b2a:	e426                	sd	s1,8(sp)
    80001b2c:	1000                	addi	s0,sp,32
    80001b2e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b30:	a2cff0ef          	jal	80000d5c <myproc>
  switch (n) {
    80001b34:	4795                	li	a5,5
    80001b36:	0497e163          	bltu	a5,s1,80001b78 <argraw+0x54>
    80001b3a:	048a                	slli	s1,s1,0x2
    80001b3c:	00006717          	auipc	a4,0x6
    80001b40:	c6470713          	addi	a4,a4,-924 # 800077a0 <states.0+0x30>
    80001b44:	94ba                	add	s1,s1,a4
    80001b46:	409c                	lw	a5,0(s1)
    80001b48:	97ba                	add	a5,a5,a4
    80001b4a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b4c:	6d3c                	ld	a5,88(a0)
    80001b4e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b50:	60e2                	ld	ra,24(sp)
    80001b52:	6442                	ld	s0,16(sp)
    80001b54:	64a2                	ld	s1,8(sp)
    80001b56:	6105                	addi	sp,sp,32
    80001b58:	8082                	ret
    return p->trapframe->a1;
    80001b5a:	6d3c                	ld	a5,88(a0)
    80001b5c:	7fa8                	ld	a0,120(a5)
    80001b5e:	bfcd                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a2;
    80001b60:	6d3c                	ld	a5,88(a0)
    80001b62:	63c8                	ld	a0,128(a5)
    80001b64:	b7f5                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a3;
    80001b66:	6d3c                	ld	a5,88(a0)
    80001b68:	67c8                	ld	a0,136(a5)
    80001b6a:	b7dd                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a4;
    80001b6c:	6d3c                	ld	a5,88(a0)
    80001b6e:	6bc8                	ld	a0,144(a5)
    80001b70:	b7c5                	j	80001b50 <argraw+0x2c>
    return p->trapframe->a5;
    80001b72:	6d3c                	ld	a5,88(a0)
    80001b74:	6fc8                	ld	a0,152(a5)
    80001b76:	bfe9                	j	80001b50 <argraw+0x2c>
  panic("argraw");
    80001b78:	00006517          	auipc	a0,0x6
    80001b7c:	83050513          	addi	a0,a0,-2000 # 800073a8 <etext+0x3a8>
    80001b80:	067030ef          	jal	800053e6 <panic>

0000000080001b84 <fetchaddr>:
{
    80001b84:	1101                	addi	sp,sp,-32
    80001b86:	ec06                	sd	ra,24(sp)
    80001b88:	e822                	sd	s0,16(sp)
    80001b8a:	e426                	sd	s1,8(sp)
    80001b8c:	e04a                	sd	s2,0(sp)
    80001b8e:	1000                	addi	s0,sp,32
    80001b90:	84aa                	mv	s1,a0
    80001b92:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b94:	9c8ff0ef          	jal	80000d5c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b98:	653c                	ld	a5,72(a0)
    80001b9a:	02f4f663          	bgeu	s1,a5,80001bc6 <fetchaddr+0x42>
    80001b9e:	00848713          	addi	a4,s1,8
    80001ba2:	02e7e463          	bltu	a5,a4,80001bca <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ba6:	46a1                	li	a3,8
    80001ba8:	8626                	mv	a2,s1
    80001baa:	85ca                	mv	a1,s2
    80001bac:	6928                	ld	a0,80(a0)
    80001bae:	f07fe0ef          	jal	80000ab4 <copyin>
    80001bb2:	00a03533          	snez	a0,a0
    80001bb6:	40a0053b          	negw	a0,a0
}
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6902                	ld	s2,0(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
    return -1;
    80001bc6:	557d                	li	a0,-1
    80001bc8:	bfcd                	j	80001bba <fetchaddr+0x36>
    80001bca:	557d                	li	a0,-1
    80001bcc:	b7fd                	j	80001bba <fetchaddr+0x36>

0000000080001bce <fetchstr>:
{
    80001bce:	7179                	addi	sp,sp,-48
    80001bd0:	f406                	sd	ra,40(sp)
    80001bd2:	f022                	sd	s0,32(sp)
    80001bd4:	ec26                	sd	s1,24(sp)
    80001bd6:	e84a                	sd	s2,16(sp)
    80001bd8:	e44e                	sd	s3,8(sp)
    80001bda:	1800                	addi	s0,sp,48
    80001bdc:	892a                	mv	s2,a0
    80001bde:	84ae                	mv	s1,a1
    80001be0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001be2:	97aff0ef          	jal	80000d5c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001be6:	86ce                	mv	a3,s3
    80001be8:	864a                	mv	a2,s2
    80001bea:	85a6                	mv	a1,s1
    80001bec:	6928                	ld	a0,80(a0)
    80001bee:	f4dfe0ef          	jal	80000b3a <copyinstr>
    80001bf2:	00054c63          	bltz	a0,80001c0a <fetchstr+0x3c>
  return strlen(buf);
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	edefe0ef          	jal	800002d6 <strlen>
}
    80001bfc:	70a2                	ld	ra,40(sp)
    80001bfe:	7402                	ld	s0,32(sp)
    80001c00:	64e2                	ld	s1,24(sp)
    80001c02:	6942                	ld	s2,16(sp)
    80001c04:	69a2                	ld	s3,8(sp)
    80001c06:	6145                	addi	sp,sp,48
    80001c08:	8082                	ret
    return -1;
    80001c0a:	557d                	li	a0,-1
    80001c0c:	bfc5                	j	80001bfc <fetchstr+0x2e>

0000000080001c0e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c0e:	1101                	addi	sp,sp,-32
    80001c10:	ec06                	sd	ra,24(sp)
    80001c12:	e822                	sd	s0,16(sp)
    80001c14:	e426                	sd	s1,8(sp)
    80001c16:	1000                	addi	s0,sp,32
    80001c18:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c1a:	f0bff0ef          	jal	80001b24 <argraw>
    80001c1e:	c088                	sw	a0,0(s1)
}
    80001c20:	60e2                	ld	ra,24(sp)
    80001c22:	6442                	ld	s0,16(sp)
    80001c24:	64a2                	ld	s1,8(sp)
    80001c26:	6105                	addi	sp,sp,32
    80001c28:	8082                	ret

0000000080001c2a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c2a:	1101                	addi	sp,sp,-32
    80001c2c:	ec06                	sd	ra,24(sp)
    80001c2e:	e822                	sd	s0,16(sp)
    80001c30:	e426                	sd	s1,8(sp)
    80001c32:	1000                	addi	s0,sp,32
    80001c34:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c36:	eefff0ef          	jal	80001b24 <argraw>
    80001c3a:	e088                	sd	a0,0(s1)
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret

0000000080001c46 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c46:	1101                	addi	sp,sp,-32
    80001c48:	ec06                	sd	ra,24(sp)
    80001c4a:	e822                	sd	s0,16(sp)
    80001c4c:	e426                	sd	s1,8(sp)
    80001c4e:	e04a                	sd	s2,0(sp)
    80001c50:	1000                	addi	s0,sp,32
    80001c52:	84ae                	mv	s1,a1
    80001c54:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001c56:	ecfff0ef          	jal	80001b24 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001c5a:	864a                	mv	a2,s2
    80001c5c:	85a6                	mv	a1,s1
    80001c5e:	f71ff0ef          	jal	80001bce <fetchstr>
}
    80001c62:	60e2                	ld	ra,24(sp)
    80001c64:	6442                	ld	s0,16(sp)
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	6902                	ld	s2,0(sp)
    80001c6a:	6105                	addi	sp,sp,32
    80001c6c:	8082                	ret

0000000080001c6e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c78:	8e4ff0ef          	jal	80000d5c <myproc>
    80001c7c:	84aa                	mv	s1,a0

  // num = p->trapframe->a7;
  num = *(int*)0;
    80001c7e:	00002683          	lw	a3,0(zero) # 0 <_entry-0x80000000>
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c82:	fff6871b          	addiw	a4,a3,-1
    80001c86:	47d1                	li	a5,20
    80001c88:	00e7ef63          	bltu	a5,a4,80001ca6 <syscall+0x38>
    80001c8c:	00369713          	slli	a4,a3,0x3
    80001c90:	00006797          	auipc	a5,0x6
    80001c94:	b2878793          	addi	a5,a5,-1240 # 800077b8 <syscalls>
    80001c98:	97ba                	add	a5,a5,a4
    80001c9a:	639c                	ld	a5,0(a5)
    80001c9c:	c789                	beqz	a5,80001ca6 <syscall+0x38>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001c9e:	6d24                	ld	s1,88(a0)
    80001ca0:	9782                	jalr	a5
    80001ca2:	f8a8                	sd	a0,112(s1)
    80001ca4:	a829                	j	80001cbe <syscall+0x50>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001ca6:	15848613          	addi	a2,s1,344
    80001caa:	588c                	lw	a1,48(s1)
    80001cac:	00005517          	auipc	a0,0x5
    80001cb0:	70450513          	addi	a0,a0,1796 # 800073b0 <etext+0x3b0>
    80001cb4:	462030ef          	jal	80005116 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cb8:	6cbc                	ld	a5,88(s1)
    80001cba:	577d                	li	a4,-1
    80001cbc:	fbb8                	sd	a4,112(a5)
  }
}
    80001cbe:	60e2                	ld	ra,24(sp)
    80001cc0:	6442                	ld	s0,16(sp)
    80001cc2:	64a2                	ld	s1,8(sp)
    80001cc4:	6105                	addi	sp,sp,32
    80001cc6:	8082                	ret

0000000080001cc8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001cc8:	1101                	addi	sp,sp,-32
    80001cca:	ec06                	sd	ra,24(sp)
    80001ccc:	e822                	sd	s0,16(sp)
    80001cce:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cd0:	fec40593          	addi	a1,s0,-20
    80001cd4:	4501                	li	a0,0
    80001cd6:	f39ff0ef          	jal	80001c0e <argint>
  exit(n);
    80001cda:	fec42503          	lw	a0,-20(s0)
    80001cde:	f58ff0ef          	jal	80001436 <exit>
  return 0;  // not reached
}
    80001ce2:	4501                	li	a0,0
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	6105                	addi	sp,sp,32
    80001cea:	8082                	ret

0000000080001cec <sys_getpid>:

uint64
sys_getpid(void)
{
    80001cec:	1141                	addi	sp,sp,-16
    80001cee:	e406                	sd	ra,8(sp)
    80001cf0:	e022                	sd	s0,0(sp)
    80001cf2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001cf4:	868ff0ef          	jal	80000d5c <myproc>
}
    80001cf8:	5908                	lw	a0,48(a0)
    80001cfa:	60a2                	ld	ra,8(sp)
    80001cfc:	6402                	ld	s0,0(sp)
    80001cfe:	0141                	addi	sp,sp,16
    80001d00:	8082                	ret

0000000080001d02 <sys_fork>:

uint64
sys_fork(void)
{
    80001d02:	1141                	addi	sp,sp,-16
    80001d04:	e406                	sd	ra,8(sp)
    80001d06:	e022                	sd	s0,0(sp)
    80001d08:	0800                	addi	s0,sp,16
  return fork();
    80001d0a:	b78ff0ef          	jal	80001082 <fork>
}
    80001d0e:	60a2                	ld	ra,8(sp)
    80001d10:	6402                	ld	s0,0(sp)
    80001d12:	0141                	addi	sp,sp,16
    80001d14:	8082                	ret

0000000080001d16 <sys_wait>:

uint64
sys_wait(void)
{
    80001d16:	1101                	addi	sp,sp,-32
    80001d18:	ec06                	sd	ra,24(sp)
    80001d1a:	e822                	sd	s0,16(sp)
    80001d1c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d1e:	fe840593          	addi	a1,s0,-24
    80001d22:	4501                	li	a0,0
    80001d24:	f07ff0ef          	jal	80001c2a <argaddr>
  return wait(p);
    80001d28:	fe843503          	ld	a0,-24(s0)
    80001d2c:	861ff0ef          	jal	8000158c <wait>
}
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret

0000000080001d38 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d38:	7179                	addi	sp,sp,-48
    80001d3a:	f406                	sd	ra,40(sp)
    80001d3c:	f022                	sd	s0,32(sp)
    80001d3e:	ec26                	sd	s1,24(sp)
    80001d40:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d42:	fdc40593          	addi	a1,s0,-36
    80001d46:	4501                	li	a0,0
    80001d48:	ec7ff0ef          	jal	80001c0e <argint>
  addr = myproc()->sz;
    80001d4c:	810ff0ef          	jal	80000d5c <myproc>
    80001d50:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d52:	fdc42503          	lw	a0,-36(s0)
    80001d56:	adcff0ef          	jal	80001032 <growproc>
    80001d5a:	00054863          	bltz	a0,80001d6a <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d5e:	8526                	mv	a0,s1
    80001d60:	70a2                	ld	ra,40(sp)
    80001d62:	7402                	ld	s0,32(sp)
    80001d64:	64e2                	ld	s1,24(sp)
    80001d66:	6145                	addi	sp,sp,48
    80001d68:	8082                	ret
    return -1;
    80001d6a:	54fd                	li	s1,-1
    80001d6c:	bfcd                	j	80001d5e <sys_sbrk+0x26>

0000000080001d6e <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d6e:	7139                	addi	sp,sp,-64
    80001d70:	fc06                	sd	ra,56(sp)
    80001d72:	f822                	sd	s0,48(sp)
    80001d74:	f04a                	sd	s2,32(sp)
    80001d76:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d78:	fcc40593          	addi	a1,s0,-52
    80001d7c:	4501                	li	a0,0
    80001d7e:	e91ff0ef          	jal	80001c0e <argint>
  if(n < 0)
    80001d82:	fcc42783          	lw	a5,-52(s0)
    80001d86:	0607c763          	bltz	a5,80001df4 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001d8a:	0000e517          	auipc	a0,0xe
    80001d8e:	37650513          	addi	a0,a0,886 # 80010100 <tickslock>
    80001d92:	183030ef          	jal	80005714 <acquire>
  ticks0 = ticks;
    80001d96:	00008917          	auipc	s2,0x8
    80001d9a:	50292903          	lw	s2,1282(s2) # 8000a298 <ticks>
  while(ticks - ticks0 < n){
    80001d9e:	fcc42783          	lw	a5,-52(s0)
    80001da2:	cf8d                	beqz	a5,80001ddc <sys_sleep+0x6e>
    80001da4:	f426                	sd	s1,40(sp)
    80001da6:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001da8:	0000e997          	auipc	s3,0xe
    80001dac:	35898993          	addi	s3,s3,856 # 80010100 <tickslock>
    80001db0:	00008497          	auipc	s1,0x8
    80001db4:	4e848493          	addi	s1,s1,1256 # 8000a298 <ticks>
    if(killed(myproc())){
    80001db8:	fa5fe0ef          	jal	80000d5c <myproc>
    80001dbc:	fa6ff0ef          	jal	80001562 <killed>
    80001dc0:	ed0d                	bnez	a0,80001dfa <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001dc2:	85ce                	mv	a1,s3
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	d64ff0ef          	jal	8000132a <sleep>
  while(ticks - ticks0 < n){
    80001dca:	409c                	lw	a5,0(s1)
    80001dcc:	412787bb          	subw	a5,a5,s2
    80001dd0:	fcc42703          	lw	a4,-52(s0)
    80001dd4:	fee7e2e3          	bltu	a5,a4,80001db8 <sys_sleep+0x4a>
    80001dd8:	74a2                	ld	s1,40(sp)
    80001dda:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ddc:	0000e517          	auipc	a0,0xe
    80001de0:	32450513          	addi	a0,a0,804 # 80010100 <tickslock>
    80001de4:	1c5030ef          	jal	800057a8 <release>
  return 0;
    80001de8:	4501                	li	a0,0
}
    80001dea:	70e2                	ld	ra,56(sp)
    80001dec:	7442                	ld	s0,48(sp)
    80001dee:	7902                	ld	s2,32(sp)
    80001df0:	6121                	addi	sp,sp,64
    80001df2:	8082                	ret
    n = 0;
    80001df4:	fc042623          	sw	zero,-52(s0)
    80001df8:	bf49                	j	80001d8a <sys_sleep+0x1c>
      release(&tickslock);
    80001dfa:	0000e517          	auipc	a0,0xe
    80001dfe:	30650513          	addi	a0,a0,774 # 80010100 <tickslock>
    80001e02:	1a7030ef          	jal	800057a8 <release>
      return -1;
    80001e06:	557d                	li	a0,-1
    80001e08:	74a2                	ld	s1,40(sp)
    80001e0a:	69e2                	ld	s3,24(sp)
    80001e0c:	bff9                	j	80001dea <sys_sleep+0x7c>

0000000080001e0e <sys_kill>:

uint64
sys_kill(void)
{
    80001e0e:	1101                	addi	sp,sp,-32
    80001e10:	ec06                	sd	ra,24(sp)
    80001e12:	e822                	sd	s0,16(sp)
    80001e14:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e16:	fec40593          	addi	a1,s0,-20
    80001e1a:	4501                	li	a0,0
    80001e1c:	df3ff0ef          	jal	80001c0e <argint>
  return kill(pid);
    80001e20:	fec42503          	lw	a0,-20(s0)
    80001e24:	eb4ff0ef          	jal	800014d8 <kill>
}
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	6105                	addi	sp,sp,32
    80001e2e:	8082                	ret

0000000080001e30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e30:	1101                	addi	sp,sp,-32
    80001e32:	ec06                	sd	ra,24(sp)
    80001e34:	e822                	sd	s0,16(sp)
    80001e36:	e426                	sd	s1,8(sp)
    80001e38:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e3a:	0000e517          	auipc	a0,0xe
    80001e3e:	2c650513          	addi	a0,a0,710 # 80010100 <tickslock>
    80001e42:	0d3030ef          	jal	80005714 <acquire>
  xticks = ticks;
    80001e46:	00008497          	auipc	s1,0x8
    80001e4a:	4524a483          	lw	s1,1106(s1) # 8000a298 <ticks>
  release(&tickslock);
    80001e4e:	0000e517          	auipc	a0,0xe
    80001e52:	2b250513          	addi	a0,a0,690 # 80010100 <tickslock>
    80001e56:	153030ef          	jal	800057a8 <release>
  return xticks;
}
    80001e5a:	02049513          	slli	a0,s1,0x20
    80001e5e:	9101                	srli	a0,a0,0x20
    80001e60:	60e2                	ld	ra,24(sp)
    80001e62:	6442                	ld	s0,16(sp)
    80001e64:	64a2                	ld	s1,8(sp)
    80001e66:	6105                	addi	sp,sp,32
    80001e68:	8082                	ret

0000000080001e6a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e6a:	7179                	addi	sp,sp,-48
    80001e6c:	f406                	sd	ra,40(sp)
    80001e6e:	f022                	sd	s0,32(sp)
    80001e70:	ec26                	sd	s1,24(sp)
    80001e72:	e84a                	sd	s2,16(sp)
    80001e74:	e44e                	sd	s3,8(sp)
    80001e76:	e052                	sd	s4,0(sp)
    80001e78:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e7a:	00005597          	auipc	a1,0x5
    80001e7e:	55658593          	addi	a1,a1,1366 # 800073d0 <etext+0x3d0>
    80001e82:	0000e517          	auipc	a0,0xe
    80001e86:	29650513          	addi	a0,a0,662 # 80010118 <bcache>
    80001e8a:	007030ef          	jal	80005690 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001e8e:	00016797          	auipc	a5,0x16
    80001e92:	28a78793          	addi	a5,a5,650 # 80018118 <bcache+0x8000>
    80001e96:	00016717          	auipc	a4,0x16
    80001e9a:	4ea70713          	addi	a4,a4,1258 # 80018380 <bcache+0x8268>
    80001e9e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001ea2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ea6:	0000e497          	auipc	s1,0xe
    80001eaa:	28a48493          	addi	s1,s1,650 # 80010130 <bcache+0x18>
    b->next = bcache.head.next;
    80001eae:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001eb0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001eb2:	00005a17          	auipc	s4,0x5
    80001eb6:	526a0a13          	addi	s4,s4,1318 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001eba:	2b893783          	ld	a5,696(s2)
    80001ebe:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ec0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ec4:	85d2                	mv	a1,s4
    80001ec6:	01048513          	addi	a0,s1,16
    80001eca:	244010ef          	jal	8000310e <initsleeplock>
    bcache.head.next->prev = b;
    80001ece:	2b893783          	ld	a5,696(s2)
    80001ed2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ed4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ed8:	45848493          	addi	s1,s1,1112
    80001edc:	fd349fe3          	bne	s1,s3,80001eba <binit+0x50>
  }
}
    80001ee0:	70a2                	ld	ra,40(sp)
    80001ee2:	7402                	ld	s0,32(sp)
    80001ee4:	64e2                	ld	s1,24(sp)
    80001ee6:	6942                	ld	s2,16(sp)
    80001ee8:	69a2                	ld	s3,8(sp)
    80001eea:	6a02                	ld	s4,0(sp)
    80001eec:	6145                	addi	sp,sp,48
    80001eee:	8082                	ret

0000000080001ef0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001ef0:	7179                	addi	sp,sp,-48
    80001ef2:	f406                	sd	ra,40(sp)
    80001ef4:	f022                	sd	s0,32(sp)
    80001ef6:	ec26                	sd	s1,24(sp)
    80001ef8:	e84a                	sd	s2,16(sp)
    80001efa:	e44e                	sd	s3,8(sp)
    80001efc:	1800                	addi	s0,sp,48
    80001efe:	892a                	mv	s2,a0
    80001f00:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f02:	0000e517          	auipc	a0,0xe
    80001f06:	21650513          	addi	a0,a0,534 # 80010118 <bcache>
    80001f0a:	00b030ef          	jal	80005714 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f0e:	00016497          	auipc	s1,0x16
    80001f12:	4c24b483          	ld	s1,1218(s1) # 800183d0 <bcache+0x82b8>
    80001f16:	00016797          	auipc	a5,0x16
    80001f1a:	46a78793          	addi	a5,a5,1130 # 80018380 <bcache+0x8268>
    80001f1e:	02f48b63          	beq	s1,a5,80001f54 <bread+0x64>
    80001f22:	873e                	mv	a4,a5
    80001f24:	a021                	j	80001f2c <bread+0x3c>
    80001f26:	68a4                	ld	s1,80(s1)
    80001f28:	02e48663          	beq	s1,a4,80001f54 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f2c:	449c                	lw	a5,8(s1)
    80001f2e:	ff279ce3          	bne	a5,s2,80001f26 <bread+0x36>
    80001f32:	44dc                	lw	a5,12(s1)
    80001f34:	ff3799e3          	bne	a5,s3,80001f26 <bread+0x36>
      b->refcnt++;
    80001f38:	40bc                	lw	a5,64(s1)
    80001f3a:	2785                	addiw	a5,a5,1
    80001f3c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f3e:	0000e517          	auipc	a0,0xe
    80001f42:	1da50513          	addi	a0,a0,474 # 80010118 <bcache>
    80001f46:	063030ef          	jal	800057a8 <release>
      acquiresleep(&b->lock);
    80001f4a:	01048513          	addi	a0,s1,16
    80001f4e:	1f6010ef          	jal	80003144 <acquiresleep>
      return b;
    80001f52:	a889                	j	80001fa4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f54:	00016497          	auipc	s1,0x16
    80001f58:	4744b483          	ld	s1,1140(s1) # 800183c8 <bcache+0x82b0>
    80001f5c:	00016797          	auipc	a5,0x16
    80001f60:	42478793          	addi	a5,a5,1060 # 80018380 <bcache+0x8268>
    80001f64:	00f48863          	beq	s1,a5,80001f74 <bread+0x84>
    80001f68:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f6a:	40bc                	lw	a5,64(s1)
    80001f6c:	cb91                	beqz	a5,80001f80 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f6e:	64a4                	ld	s1,72(s1)
    80001f70:	fee49de3          	bne	s1,a4,80001f6a <bread+0x7a>
  panic("bget: no buffers");
    80001f74:	00005517          	auipc	a0,0x5
    80001f78:	46c50513          	addi	a0,a0,1132 # 800073e0 <etext+0x3e0>
    80001f7c:	46a030ef          	jal	800053e6 <panic>
      b->dev = dev;
    80001f80:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001f84:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001f88:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001f8c:	4785                	li	a5,1
    80001f8e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f90:	0000e517          	auipc	a0,0xe
    80001f94:	18850513          	addi	a0,a0,392 # 80010118 <bcache>
    80001f98:	011030ef          	jal	800057a8 <release>
      acquiresleep(&b->lock);
    80001f9c:	01048513          	addi	a0,s1,16
    80001fa0:	1a4010ef          	jal	80003144 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fa4:	409c                	lw	a5,0(s1)
    80001fa6:	cb89                	beqz	a5,80001fb8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fa8:	8526                	mv	a0,s1
    80001faa:	70a2                	ld	ra,40(sp)
    80001fac:	7402                	ld	s0,32(sp)
    80001fae:	64e2                	ld	s1,24(sp)
    80001fb0:	6942                	ld	s2,16(sp)
    80001fb2:	69a2                	ld	s3,8(sp)
    80001fb4:	6145                	addi	sp,sp,48
    80001fb6:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fb8:	4581                	li	a1,0
    80001fba:	8526                	mv	a0,s1
    80001fbc:	1f5020ef          	jal	800049b0 <virtio_disk_rw>
    b->valid = 1;
    80001fc0:	4785                	li	a5,1
    80001fc2:	c09c                	sw	a5,0(s1)
  return b;
    80001fc4:	b7d5                	j	80001fa8 <bread+0xb8>

0000000080001fc6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	1000                	addi	s0,sp,32
    80001fd0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fd2:	0541                	addi	a0,a0,16
    80001fd4:	1ee010ef          	jal	800031c2 <holdingsleep>
    80001fd8:	c911                	beqz	a0,80001fec <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001fda:	4585                	li	a1,1
    80001fdc:	8526                	mv	a0,s1
    80001fde:	1d3020ef          	jal	800049b0 <virtio_disk_rw>
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6105                	addi	sp,sp,32
    80001fea:	8082                	ret
    panic("bwrite");
    80001fec:	00005517          	auipc	a0,0x5
    80001ff0:	40c50513          	addi	a0,a0,1036 # 800073f8 <etext+0x3f8>
    80001ff4:	3f2030ef          	jal	800053e6 <panic>

0000000080001ff8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80001ff8:	1101                	addi	sp,sp,-32
    80001ffa:	ec06                	sd	ra,24(sp)
    80001ffc:	e822                	sd	s0,16(sp)
    80001ffe:	e426                	sd	s1,8(sp)
    80002000:	e04a                	sd	s2,0(sp)
    80002002:	1000                	addi	s0,sp,32
    80002004:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002006:	01050913          	addi	s2,a0,16
    8000200a:	854a                	mv	a0,s2
    8000200c:	1b6010ef          	jal	800031c2 <holdingsleep>
    80002010:	c125                	beqz	a0,80002070 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002012:	854a                	mv	a0,s2
    80002014:	176010ef          	jal	8000318a <releasesleep>

  acquire(&bcache.lock);
    80002018:	0000e517          	auipc	a0,0xe
    8000201c:	10050513          	addi	a0,a0,256 # 80010118 <bcache>
    80002020:	6f4030ef          	jal	80005714 <acquire>
  b->refcnt--;
    80002024:	40bc                	lw	a5,64(s1)
    80002026:	37fd                	addiw	a5,a5,-1
    80002028:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000202a:	e79d                	bnez	a5,80002058 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000202c:	68b8                	ld	a4,80(s1)
    8000202e:	64bc                	ld	a5,72(s1)
    80002030:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002032:	68b8                	ld	a4,80(s1)
    80002034:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002036:	00016797          	auipc	a5,0x16
    8000203a:	0e278793          	addi	a5,a5,226 # 80018118 <bcache+0x8000>
    8000203e:	2b87b703          	ld	a4,696(a5)
    80002042:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002044:	00016717          	auipc	a4,0x16
    80002048:	33c70713          	addi	a4,a4,828 # 80018380 <bcache+0x8268>
    8000204c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000204e:	2b87b703          	ld	a4,696(a5)
    80002052:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002054:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002058:	0000e517          	auipc	a0,0xe
    8000205c:	0c050513          	addi	a0,a0,192 # 80010118 <bcache>
    80002060:	748030ef          	jal	800057a8 <release>
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6902                	ld	s2,0(sp)
    8000206c:	6105                	addi	sp,sp,32
    8000206e:	8082                	ret
    panic("brelse");
    80002070:	00005517          	auipc	a0,0x5
    80002074:	39050513          	addi	a0,a0,912 # 80007400 <etext+0x400>
    80002078:	36e030ef          	jal	800053e6 <panic>

000000008000207c <bpin>:

void
bpin(struct buf *b) {
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	e426                	sd	s1,8(sp)
    80002084:	1000                	addi	s0,sp,32
    80002086:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002088:	0000e517          	auipc	a0,0xe
    8000208c:	09050513          	addi	a0,a0,144 # 80010118 <bcache>
    80002090:	684030ef          	jal	80005714 <acquire>
  b->refcnt++;
    80002094:	40bc                	lw	a5,64(s1)
    80002096:	2785                	addiw	a5,a5,1
    80002098:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000209a:	0000e517          	auipc	a0,0xe
    8000209e:	07e50513          	addi	a0,a0,126 # 80010118 <bcache>
    800020a2:	706030ef          	jal	800057a8 <release>
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6105                	addi	sp,sp,32
    800020ae:	8082                	ret

00000000800020b0 <bunpin>:

void
bunpin(struct buf *b) {
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	e426                	sd	s1,8(sp)
    800020b8:	1000                	addi	s0,sp,32
    800020ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020bc:	0000e517          	auipc	a0,0xe
    800020c0:	05c50513          	addi	a0,a0,92 # 80010118 <bcache>
    800020c4:	650030ef          	jal	80005714 <acquire>
  b->refcnt--;
    800020c8:	40bc                	lw	a5,64(s1)
    800020ca:	37fd                	addiw	a5,a5,-1
    800020cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020ce:	0000e517          	auipc	a0,0xe
    800020d2:	04a50513          	addi	a0,a0,74 # 80010118 <bcache>
    800020d6:	6d2030ef          	jal	800057a8 <release>
}
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	64a2                	ld	s1,8(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret

00000000800020e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800020e4:	1101                	addi	sp,sp,-32
    800020e6:	ec06                	sd	ra,24(sp)
    800020e8:	e822                	sd	s0,16(sp)
    800020ea:	e426                	sd	s1,8(sp)
    800020ec:	e04a                	sd	s2,0(sp)
    800020ee:	1000                	addi	s0,sp,32
    800020f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800020f2:	00d5d79b          	srliw	a5,a1,0xd
    800020f6:	00016597          	auipc	a1,0x16
    800020fa:	6fe5a583          	lw	a1,1790(a1) # 800187f4 <sb+0x1c>
    800020fe:	9dbd                	addw	a1,a1,a5
    80002100:	df1ff0ef          	jal	80001ef0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002104:	0074f713          	andi	a4,s1,7
    80002108:	4785                	li	a5,1
    8000210a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000210e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002110:	90d9                	srli	s1,s1,0x36
    80002112:	00950733          	add	a4,a0,s1
    80002116:	05874703          	lbu	a4,88(a4)
    8000211a:	00e7f6b3          	and	a3,a5,a4
    8000211e:	c29d                	beqz	a3,80002144 <bfree+0x60>
    80002120:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002122:	94aa                	add	s1,s1,a0
    80002124:	fff7c793          	not	a5,a5
    80002128:	8f7d                	and	a4,a4,a5
    8000212a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000212e:	711000ef          	jal	8000303e <log_write>
  brelse(bp);
    80002132:	854a                	mv	a0,s2
    80002134:	ec5ff0ef          	jal	80001ff8 <brelse>
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6902                	ld	s2,0(sp)
    80002140:	6105                	addi	sp,sp,32
    80002142:	8082                	ret
    panic("freeing free block");
    80002144:	00005517          	auipc	a0,0x5
    80002148:	2c450513          	addi	a0,a0,708 # 80007408 <etext+0x408>
    8000214c:	29a030ef          	jal	800053e6 <panic>

0000000080002150 <balloc>:
{
    80002150:	715d                	addi	sp,sp,-80
    80002152:	e486                	sd	ra,72(sp)
    80002154:	e0a2                	sd	s0,64(sp)
    80002156:	fc26                	sd	s1,56(sp)
    80002158:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000215a:	00016797          	auipc	a5,0x16
    8000215e:	6827a783          	lw	a5,1666(a5) # 800187dc <sb+0x4>
    80002162:	0e078863          	beqz	a5,80002252 <balloc+0x102>
    80002166:	f84a                	sd	s2,48(sp)
    80002168:	f44e                	sd	s3,40(sp)
    8000216a:	f052                	sd	s4,32(sp)
    8000216c:	ec56                	sd	s5,24(sp)
    8000216e:	e85a                	sd	s6,16(sp)
    80002170:	e45e                	sd	s7,8(sp)
    80002172:	e062                	sd	s8,0(sp)
    80002174:	8baa                	mv	s7,a0
    80002176:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002178:	00016b17          	auipc	s6,0x16
    8000217c:	660b0b13          	addi	s6,s6,1632 # 800187d8 <sb>
      m = 1 << (bi % 8);
    80002180:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002182:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002184:	6c09                	lui	s8,0x2
    80002186:	a09d                	j	800021ec <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002188:	97ca                	add	a5,a5,s2
    8000218a:	8e55                	or	a2,a2,a3
    8000218c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002190:	854a                	mv	a0,s2
    80002192:	6ad000ef          	jal	8000303e <log_write>
        brelse(bp);
    80002196:	854a                	mv	a0,s2
    80002198:	e61ff0ef          	jal	80001ff8 <brelse>
  bp = bread(dev, bno);
    8000219c:	85a6                	mv	a1,s1
    8000219e:	855e                	mv	a0,s7
    800021a0:	d51ff0ef          	jal	80001ef0 <bread>
    800021a4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021a6:	40000613          	li	a2,1024
    800021aa:	4581                	li	a1,0
    800021ac:	05850513          	addi	a0,a0,88
    800021b0:	f9ffd0ef          	jal	8000014e <memset>
  log_write(bp);
    800021b4:	854a                	mv	a0,s2
    800021b6:	689000ef          	jal	8000303e <log_write>
  brelse(bp);
    800021ba:	854a                	mv	a0,s2
    800021bc:	e3dff0ef          	jal	80001ff8 <brelse>
}
    800021c0:	7942                	ld	s2,48(sp)
    800021c2:	79a2                	ld	s3,40(sp)
    800021c4:	7a02                	ld	s4,32(sp)
    800021c6:	6ae2                	ld	s5,24(sp)
    800021c8:	6b42                	ld	s6,16(sp)
    800021ca:	6ba2                	ld	s7,8(sp)
    800021cc:	6c02                	ld	s8,0(sp)
}
    800021ce:	8526                	mv	a0,s1
    800021d0:	60a6                	ld	ra,72(sp)
    800021d2:	6406                	ld	s0,64(sp)
    800021d4:	74e2                	ld	s1,56(sp)
    800021d6:	6161                	addi	sp,sp,80
    800021d8:	8082                	ret
    brelse(bp);
    800021da:	854a                	mv	a0,s2
    800021dc:	e1dff0ef          	jal	80001ff8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800021e0:	015c0abb          	addw	s5,s8,s5
    800021e4:	004b2783          	lw	a5,4(s6)
    800021e8:	04fafe63          	bgeu	s5,a5,80002244 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800021ec:	41fad79b          	sraiw	a5,s5,0x1f
    800021f0:	0137d79b          	srliw	a5,a5,0x13
    800021f4:	015787bb          	addw	a5,a5,s5
    800021f8:	40d7d79b          	sraiw	a5,a5,0xd
    800021fc:	01cb2583          	lw	a1,28(s6)
    80002200:	9dbd                	addw	a1,a1,a5
    80002202:	855e                	mv	a0,s7
    80002204:	cedff0ef          	jal	80001ef0 <bread>
    80002208:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000220a:	004b2503          	lw	a0,4(s6)
    8000220e:	84d6                	mv	s1,s5
    80002210:	4701                	li	a4,0
    80002212:	fca4f4e3          	bgeu	s1,a0,800021da <balloc+0x8a>
      m = 1 << (bi % 8);
    80002216:	00777693          	andi	a3,a4,7
    8000221a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000221e:	41f7579b          	sraiw	a5,a4,0x1f
    80002222:	01d7d79b          	srliw	a5,a5,0x1d
    80002226:	9fb9                	addw	a5,a5,a4
    80002228:	4037d79b          	sraiw	a5,a5,0x3
    8000222c:	00f90633          	add	a2,s2,a5
    80002230:	05864603          	lbu	a2,88(a2)
    80002234:	00c6f5b3          	and	a1,a3,a2
    80002238:	d9a1                	beqz	a1,80002188 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000223a:	2705                	addiw	a4,a4,1
    8000223c:	2485                	addiw	s1,s1,1
    8000223e:	fd471ae3          	bne	a4,s4,80002212 <balloc+0xc2>
    80002242:	bf61                	j	800021da <balloc+0x8a>
    80002244:	7942                	ld	s2,48(sp)
    80002246:	79a2                	ld	s3,40(sp)
    80002248:	7a02                	ld	s4,32(sp)
    8000224a:	6ae2                	ld	s5,24(sp)
    8000224c:	6b42                	ld	s6,16(sp)
    8000224e:	6ba2                	ld	s7,8(sp)
    80002250:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002252:	00005517          	auipc	a0,0x5
    80002256:	1ce50513          	addi	a0,a0,462 # 80007420 <etext+0x420>
    8000225a:	6bd020ef          	jal	80005116 <printf>
  return 0;
    8000225e:	4481                	li	s1,0
    80002260:	b7bd                	j	800021ce <balloc+0x7e>

0000000080002262 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002262:	7179                	addi	sp,sp,-48
    80002264:	f406                	sd	ra,40(sp)
    80002266:	f022                	sd	s0,32(sp)
    80002268:	ec26                	sd	s1,24(sp)
    8000226a:	e84a                	sd	s2,16(sp)
    8000226c:	e44e                	sd	s3,8(sp)
    8000226e:	1800                	addi	s0,sp,48
    80002270:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002272:	47ad                	li	a5,11
    80002274:	02b7e363          	bltu	a5,a1,8000229a <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002278:	02059793          	slli	a5,a1,0x20
    8000227c:	01e7d593          	srli	a1,a5,0x1e
    80002280:	00b504b3          	add	s1,a0,a1
    80002284:	0504a903          	lw	s2,80(s1)
    80002288:	06091363          	bnez	s2,800022ee <bmap+0x8c>
      addr = balloc(ip->dev);
    8000228c:	4108                	lw	a0,0(a0)
    8000228e:	ec3ff0ef          	jal	80002150 <balloc>
    80002292:	892a                	mv	s2,a0
      if(addr == 0)
    80002294:	cd29                	beqz	a0,800022ee <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    80002296:	c8a8                	sw	a0,80(s1)
    80002298:	a899                	j	800022ee <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000229a:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000229e:	0ff00793          	li	a5,255
    800022a2:	0697e963          	bltu	a5,s1,80002314 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022a6:	08052903          	lw	s2,128(a0)
    800022aa:	00091b63          	bnez	s2,800022c0 <bmap+0x5e>
      addr = balloc(ip->dev);
    800022ae:	4108                	lw	a0,0(a0)
    800022b0:	ea1ff0ef          	jal	80002150 <balloc>
    800022b4:	892a                	mv	s2,a0
      if(addr == 0)
    800022b6:	cd05                	beqz	a0,800022ee <bmap+0x8c>
    800022b8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800022ba:	08a9a023          	sw	a0,128(s3)
    800022be:	a011                	j	800022c2 <bmap+0x60>
    800022c0:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800022c2:	85ca                	mv	a1,s2
    800022c4:	0009a503          	lw	a0,0(s3)
    800022c8:	c29ff0ef          	jal	80001ef0 <bread>
    800022cc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800022ce:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800022d2:	02049713          	slli	a4,s1,0x20
    800022d6:	01e75593          	srli	a1,a4,0x1e
    800022da:	00b784b3          	add	s1,a5,a1
    800022de:	0004a903          	lw	s2,0(s1)
    800022e2:	00090e63          	beqz	s2,800022fe <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800022e6:	8552                	mv	a0,s4
    800022e8:	d11ff0ef          	jal	80001ff8 <brelse>
    return addr;
    800022ec:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800022ee:	854a                	mv	a0,s2
    800022f0:	70a2                	ld	ra,40(sp)
    800022f2:	7402                	ld	s0,32(sp)
    800022f4:	64e2                	ld	s1,24(sp)
    800022f6:	6942                	ld	s2,16(sp)
    800022f8:	69a2                	ld	s3,8(sp)
    800022fa:	6145                	addi	sp,sp,48
    800022fc:	8082                	ret
      addr = balloc(ip->dev);
    800022fe:	0009a503          	lw	a0,0(s3)
    80002302:	e4fff0ef          	jal	80002150 <balloc>
    80002306:	892a                	mv	s2,a0
      if(addr){
    80002308:	dd79                	beqz	a0,800022e6 <bmap+0x84>
        a[bn] = addr;
    8000230a:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000230c:	8552                	mv	a0,s4
    8000230e:	531000ef          	jal	8000303e <log_write>
    80002312:	bfd1                	j	800022e6 <bmap+0x84>
    80002314:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002316:	00005517          	auipc	a0,0x5
    8000231a:	12250513          	addi	a0,a0,290 # 80007438 <etext+0x438>
    8000231e:	0c8030ef          	jal	800053e6 <panic>

0000000080002322 <iget>:
{
    80002322:	7179                	addi	sp,sp,-48
    80002324:	f406                	sd	ra,40(sp)
    80002326:	f022                	sd	s0,32(sp)
    80002328:	ec26                	sd	s1,24(sp)
    8000232a:	e84a                	sd	s2,16(sp)
    8000232c:	e44e                	sd	s3,8(sp)
    8000232e:	e052                	sd	s4,0(sp)
    80002330:	1800                	addi	s0,sp,48
    80002332:	89aa                	mv	s3,a0
    80002334:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002336:	00016517          	auipc	a0,0x16
    8000233a:	4c250513          	addi	a0,a0,1218 # 800187f8 <itable>
    8000233e:	3d6030ef          	jal	80005714 <acquire>
  empty = 0;
    80002342:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002344:	00016497          	auipc	s1,0x16
    80002348:	4cc48493          	addi	s1,s1,1228 # 80018810 <itable+0x18>
    8000234c:	00018697          	auipc	a3,0x18
    80002350:	f5468693          	addi	a3,a3,-172 # 8001a2a0 <log>
    80002354:	a039                	j	80002362 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002356:	02090963          	beqz	s2,80002388 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000235a:	08848493          	addi	s1,s1,136
    8000235e:	02d48863          	beq	s1,a3,8000238e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002362:	449c                	lw	a5,8(s1)
    80002364:	fef059e3          	blez	a5,80002356 <iget+0x34>
    80002368:	4098                	lw	a4,0(s1)
    8000236a:	ff3716e3          	bne	a4,s3,80002356 <iget+0x34>
    8000236e:	40d8                	lw	a4,4(s1)
    80002370:	ff4713e3          	bne	a4,s4,80002356 <iget+0x34>
      ip->ref++;
    80002374:	2785                	addiw	a5,a5,1
    80002376:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002378:	00016517          	auipc	a0,0x16
    8000237c:	48050513          	addi	a0,a0,1152 # 800187f8 <itable>
    80002380:	428030ef          	jal	800057a8 <release>
      return ip;
    80002384:	8926                	mv	s2,s1
    80002386:	a02d                	j	800023b0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002388:	fbe9                	bnez	a5,8000235a <iget+0x38>
      empty = ip;
    8000238a:	8926                	mv	s2,s1
    8000238c:	b7f9                	j	8000235a <iget+0x38>
  if(empty == 0)
    8000238e:	02090a63          	beqz	s2,800023c2 <iget+0xa0>
  ip->dev = dev;
    80002392:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002396:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000239a:	4785                	li	a5,1
    8000239c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800023a0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800023a4:	00016517          	auipc	a0,0x16
    800023a8:	45450513          	addi	a0,a0,1108 # 800187f8 <itable>
    800023ac:	3fc030ef          	jal	800057a8 <release>
}
    800023b0:	854a                	mv	a0,s2
    800023b2:	70a2                	ld	ra,40(sp)
    800023b4:	7402                	ld	s0,32(sp)
    800023b6:	64e2                	ld	s1,24(sp)
    800023b8:	6942                	ld	s2,16(sp)
    800023ba:	69a2                	ld	s3,8(sp)
    800023bc:	6a02                	ld	s4,0(sp)
    800023be:	6145                	addi	sp,sp,48
    800023c0:	8082                	ret
    panic("iget: no inodes");
    800023c2:	00005517          	auipc	a0,0x5
    800023c6:	08e50513          	addi	a0,a0,142 # 80007450 <etext+0x450>
    800023ca:	01c030ef          	jal	800053e6 <panic>

00000000800023ce <fsinit>:
fsinit(int dev) {
    800023ce:	7179                	addi	sp,sp,-48
    800023d0:	f406                	sd	ra,40(sp)
    800023d2:	f022                	sd	s0,32(sp)
    800023d4:	ec26                	sd	s1,24(sp)
    800023d6:	e84a                	sd	s2,16(sp)
    800023d8:	e44e                	sd	s3,8(sp)
    800023da:	1800                	addi	s0,sp,48
    800023dc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800023de:	4585                	li	a1,1
    800023e0:	b11ff0ef          	jal	80001ef0 <bread>
    800023e4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800023e6:	00016997          	auipc	s3,0x16
    800023ea:	3f298993          	addi	s3,s3,1010 # 800187d8 <sb>
    800023ee:	02000613          	li	a2,32
    800023f2:	05850593          	addi	a1,a0,88
    800023f6:	854e                	mv	a0,s3
    800023f8:	dbbfd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    800023fc:	8526                	mv	a0,s1
    800023fe:	bfbff0ef          	jal	80001ff8 <brelse>
  if(sb.magic != FSMAGIC)
    80002402:	0009a703          	lw	a4,0(s3)
    80002406:	102037b7          	lui	a5,0x10203
    8000240a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000240e:	02f71063          	bne	a4,a5,8000242e <fsinit+0x60>
  initlog(dev, &sb);
    80002412:	00016597          	auipc	a1,0x16
    80002416:	3c658593          	addi	a1,a1,966 # 800187d8 <sb>
    8000241a:	854a                	mv	a0,s2
    8000241c:	215000ef          	jal	80002e30 <initlog>
}
    80002420:	70a2                	ld	ra,40(sp)
    80002422:	7402                	ld	s0,32(sp)
    80002424:	64e2                	ld	s1,24(sp)
    80002426:	6942                	ld	s2,16(sp)
    80002428:	69a2                	ld	s3,8(sp)
    8000242a:	6145                	addi	sp,sp,48
    8000242c:	8082                	ret
    panic("invalid file system");
    8000242e:	00005517          	auipc	a0,0x5
    80002432:	03250513          	addi	a0,a0,50 # 80007460 <etext+0x460>
    80002436:	7b1020ef          	jal	800053e6 <panic>

000000008000243a <iinit>:
{
    8000243a:	7179                	addi	sp,sp,-48
    8000243c:	f406                	sd	ra,40(sp)
    8000243e:	f022                	sd	s0,32(sp)
    80002440:	ec26                	sd	s1,24(sp)
    80002442:	e84a                	sd	s2,16(sp)
    80002444:	e44e                	sd	s3,8(sp)
    80002446:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002448:	00005597          	auipc	a1,0x5
    8000244c:	03058593          	addi	a1,a1,48 # 80007478 <etext+0x478>
    80002450:	00016517          	auipc	a0,0x16
    80002454:	3a850513          	addi	a0,a0,936 # 800187f8 <itable>
    80002458:	238030ef          	jal	80005690 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000245c:	00016497          	auipc	s1,0x16
    80002460:	3c448493          	addi	s1,s1,964 # 80018820 <itable+0x28>
    80002464:	00018997          	auipc	s3,0x18
    80002468:	e4c98993          	addi	s3,s3,-436 # 8001a2b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000246c:	00005917          	auipc	s2,0x5
    80002470:	01490913          	addi	s2,s2,20 # 80007480 <etext+0x480>
    80002474:	85ca                	mv	a1,s2
    80002476:	8526                	mv	a0,s1
    80002478:	497000ef          	jal	8000310e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000247c:	08848493          	addi	s1,s1,136
    80002480:	ff349ae3          	bne	s1,s3,80002474 <iinit+0x3a>
}
    80002484:	70a2                	ld	ra,40(sp)
    80002486:	7402                	ld	s0,32(sp)
    80002488:	64e2                	ld	s1,24(sp)
    8000248a:	6942                	ld	s2,16(sp)
    8000248c:	69a2                	ld	s3,8(sp)
    8000248e:	6145                	addi	sp,sp,48
    80002490:	8082                	ret

0000000080002492 <ialloc>:
{
    80002492:	7139                	addi	sp,sp,-64
    80002494:	fc06                	sd	ra,56(sp)
    80002496:	f822                	sd	s0,48(sp)
    80002498:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000249a:	00016717          	auipc	a4,0x16
    8000249e:	34a72703          	lw	a4,842(a4) # 800187e4 <sb+0xc>
    800024a2:	4785                	li	a5,1
    800024a4:	06e7f063          	bgeu	a5,a4,80002504 <ialloc+0x72>
    800024a8:	f426                	sd	s1,40(sp)
    800024aa:	f04a                	sd	s2,32(sp)
    800024ac:	ec4e                	sd	s3,24(sp)
    800024ae:	e852                	sd	s4,16(sp)
    800024b0:	e456                	sd	s5,8(sp)
    800024b2:	e05a                	sd	s6,0(sp)
    800024b4:	8aaa                	mv	s5,a0
    800024b6:	8b2e                	mv	s6,a1
    800024b8:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800024ba:	00016a17          	auipc	s4,0x16
    800024be:	31ea0a13          	addi	s4,s4,798 # 800187d8 <sb>
    800024c2:	00495593          	srli	a1,s2,0x4
    800024c6:	018a2783          	lw	a5,24(s4)
    800024ca:	9dbd                	addw	a1,a1,a5
    800024cc:	8556                	mv	a0,s5
    800024ce:	a23ff0ef          	jal	80001ef0 <bread>
    800024d2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800024d4:	05850993          	addi	s3,a0,88
    800024d8:	00f97793          	andi	a5,s2,15
    800024dc:	079a                	slli	a5,a5,0x6
    800024de:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800024e0:	00099783          	lh	a5,0(s3)
    800024e4:	cb9d                	beqz	a5,8000251a <ialloc+0x88>
    brelse(bp);
    800024e6:	b13ff0ef          	jal	80001ff8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800024ea:	0905                	addi	s2,s2,1
    800024ec:	00ca2703          	lw	a4,12(s4)
    800024f0:	0009079b          	sext.w	a5,s2
    800024f4:	fce7e7e3          	bltu	a5,a4,800024c2 <ialloc+0x30>
    800024f8:	74a2                	ld	s1,40(sp)
    800024fa:	7902                	ld	s2,32(sp)
    800024fc:	69e2                	ld	s3,24(sp)
    800024fe:	6a42                	ld	s4,16(sp)
    80002500:	6aa2                	ld	s5,8(sp)
    80002502:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002504:	00005517          	auipc	a0,0x5
    80002508:	f8450513          	addi	a0,a0,-124 # 80007488 <etext+0x488>
    8000250c:	40b020ef          	jal	80005116 <printf>
  return 0;
    80002510:	4501                	li	a0,0
}
    80002512:	70e2                	ld	ra,56(sp)
    80002514:	7442                	ld	s0,48(sp)
    80002516:	6121                	addi	sp,sp,64
    80002518:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000251a:	04000613          	li	a2,64
    8000251e:	4581                	li	a1,0
    80002520:	854e                	mv	a0,s3
    80002522:	c2dfd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002526:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000252a:	8526                	mv	a0,s1
    8000252c:	313000ef          	jal	8000303e <log_write>
      brelse(bp);
    80002530:	8526                	mv	a0,s1
    80002532:	ac7ff0ef          	jal	80001ff8 <brelse>
      return iget(dev, inum);
    80002536:	0009059b          	sext.w	a1,s2
    8000253a:	8556                	mv	a0,s5
    8000253c:	de7ff0ef          	jal	80002322 <iget>
    80002540:	74a2                	ld	s1,40(sp)
    80002542:	7902                	ld	s2,32(sp)
    80002544:	69e2                	ld	s3,24(sp)
    80002546:	6a42                	ld	s4,16(sp)
    80002548:	6aa2                	ld	s5,8(sp)
    8000254a:	6b02                	ld	s6,0(sp)
    8000254c:	b7d9                	j	80002512 <ialloc+0x80>

000000008000254e <iupdate>:
{
    8000254e:	1101                	addi	sp,sp,-32
    80002550:	ec06                	sd	ra,24(sp)
    80002552:	e822                	sd	s0,16(sp)
    80002554:	e426                	sd	s1,8(sp)
    80002556:	e04a                	sd	s2,0(sp)
    80002558:	1000                	addi	s0,sp,32
    8000255a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000255c:	415c                	lw	a5,4(a0)
    8000255e:	0047d79b          	srliw	a5,a5,0x4
    80002562:	00016597          	auipc	a1,0x16
    80002566:	28e5a583          	lw	a1,654(a1) # 800187f0 <sb+0x18>
    8000256a:	9dbd                	addw	a1,a1,a5
    8000256c:	4108                	lw	a0,0(a0)
    8000256e:	983ff0ef          	jal	80001ef0 <bread>
    80002572:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002574:	05850793          	addi	a5,a0,88
    80002578:	40d8                	lw	a4,4(s1)
    8000257a:	8b3d                	andi	a4,a4,15
    8000257c:	071a                	slli	a4,a4,0x6
    8000257e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002580:	04449703          	lh	a4,68(s1)
    80002584:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002588:	04649703          	lh	a4,70(s1)
    8000258c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002590:	04849703          	lh	a4,72(s1)
    80002594:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002598:	04a49703          	lh	a4,74(s1)
    8000259c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800025a0:	44f8                	lw	a4,76(s1)
    800025a2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800025a4:	03400613          	li	a2,52
    800025a8:	05048593          	addi	a1,s1,80
    800025ac:	00c78513          	addi	a0,a5,12
    800025b0:	c03fd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    800025b4:	854a                	mv	a0,s2
    800025b6:	289000ef          	jal	8000303e <log_write>
  brelse(bp);
    800025ba:	854a                	mv	a0,s2
    800025bc:	a3dff0ef          	jal	80001ff8 <brelse>
}
    800025c0:	60e2                	ld	ra,24(sp)
    800025c2:	6442                	ld	s0,16(sp)
    800025c4:	64a2                	ld	s1,8(sp)
    800025c6:	6902                	ld	s2,0(sp)
    800025c8:	6105                	addi	sp,sp,32
    800025ca:	8082                	ret

00000000800025cc <idup>:
{
    800025cc:	1101                	addi	sp,sp,-32
    800025ce:	ec06                	sd	ra,24(sp)
    800025d0:	e822                	sd	s0,16(sp)
    800025d2:	e426                	sd	s1,8(sp)
    800025d4:	1000                	addi	s0,sp,32
    800025d6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800025d8:	00016517          	auipc	a0,0x16
    800025dc:	22050513          	addi	a0,a0,544 # 800187f8 <itable>
    800025e0:	134030ef          	jal	80005714 <acquire>
  ip->ref++;
    800025e4:	449c                	lw	a5,8(s1)
    800025e6:	2785                	addiw	a5,a5,1
    800025e8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800025ea:	00016517          	auipc	a0,0x16
    800025ee:	20e50513          	addi	a0,a0,526 # 800187f8 <itable>
    800025f2:	1b6030ef          	jal	800057a8 <release>
}
    800025f6:	8526                	mv	a0,s1
    800025f8:	60e2                	ld	ra,24(sp)
    800025fa:	6442                	ld	s0,16(sp)
    800025fc:	64a2                	ld	s1,8(sp)
    800025fe:	6105                	addi	sp,sp,32
    80002600:	8082                	ret

0000000080002602 <ilock>:
{
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000260c:	cd19                	beqz	a0,8000262a <ilock+0x28>
    8000260e:	84aa                	mv	s1,a0
    80002610:	451c                	lw	a5,8(a0)
    80002612:	00f05c63          	blez	a5,8000262a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002616:	0541                	addi	a0,a0,16
    80002618:	32d000ef          	jal	80003144 <acquiresleep>
  if(ip->valid == 0){
    8000261c:	40bc                	lw	a5,64(s1)
    8000261e:	cf89                	beqz	a5,80002638 <ilock+0x36>
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret
    8000262a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000262c:	00005517          	auipc	a0,0x5
    80002630:	e7450513          	addi	a0,a0,-396 # 800074a0 <etext+0x4a0>
    80002634:	5b3020ef          	jal	800053e6 <panic>
    80002638:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000263a:	40dc                	lw	a5,4(s1)
    8000263c:	0047d79b          	srliw	a5,a5,0x4
    80002640:	00016597          	auipc	a1,0x16
    80002644:	1b05a583          	lw	a1,432(a1) # 800187f0 <sb+0x18>
    80002648:	9dbd                	addw	a1,a1,a5
    8000264a:	4088                	lw	a0,0(s1)
    8000264c:	8a5ff0ef          	jal	80001ef0 <bread>
    80002650:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002652:	05850593          	addi	a1,a0,88
    80002656:	40dc                	lw	a5,4(s1)
    80002658:	8bbd                	andi	a5,a5,15
    8000265a:	079a                	slli	a5,a5,0x6
    8000265c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000265e:	00059783          	lh	a5,0(a1)
    80002662:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002666:	00259783          	lh	a5,2(a1)
    8000266a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000266e:	00459783          	lh	a5,4(a1)
    80002672:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002676:	00659783          	lh	a5,6(a1)
    8000267a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000267e:	459c                	lw	a5,8(a1)
    80002680:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002682:	03400613          	li	a2,52
    80002686:	05b1                	addi	a1,a1,12
    80002688:	05048513          	addi	a0,s1,80
    8000268c:	b27fd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    80002690:	854a                	mv	a0,s2
    80002692:	967ff0ef          	jal	80001ff8 <brelse>
    ip->valid = 1;
    80002696:	4785                	li	a5,1
    80002698:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000269a:	04449783          	lh	a5,68(s1)
    8000269e:	c399                	beqz	a5,800026a4 <ilock+0xa2>
    800026a0:	6902                	ld	s2,0(sp)
    800026a2:	bfbd                	j	80002620 <ilock+0x1e>
      panic("ilock: no type");
    800026a4:	00005517          	auipc	a0,0x5
    800026a8:	e0450513          	addi	a0,a0,-508 # 800074a8 <etext+0x4a8>
    800026ac:	53b020ef          	jal	800053e6 <panic>

00000000800026b0 <iunlock>:
{
    800026b0:	1101                	addi	sp,sp,-32
    800026b2:	ec06                	sd	ra,24(sp)
    800026b4:	e822                	sd	s0,16(sp)
    800026b6:	e426                	sd	s1,8(sp)
    800026b8:	e04a                	sd	s2,0(sp)
    800026ba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800026bc:	c505                	beqz	a0,800026e4 <iunlock+0x34>
    800026be:	84aa                	mv	s1,a0
    800026c0:	01050913          	addi	s2,a0,16
    800026c4:	854a                	mv	a0,s2
    800026c6:	2fd000ef          	jal	800031c2 <holdingsleep>
    800026ca:	cd09                	beqz	a0,800026e4 <iunlock+0x34>
    800026cc:	449c                	lw	a5,8(s1)
    800026ce:	00f05b63          	blez	a5,800026e4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800026d2:	854a                	mv	a0,s2
    800026d4:	2b7000ef          	jal	8000318a <releasesleep>
}
    800026d8:	60e2                	ld	ra,24(sp)
    800026da:	6442                	ld	s0,16(sp)
    800026dc:	64a2                	ld	s1,8(sp)
    800026de:	6902                	ld	s2,0(sp)
    800026e0:	6105                	addi	sp,sp,32
    800026e2:	8082                	ret
    panic("iunlock");
    800026e4:	00005517          	auipc	a0,0x5
    800026e8:	dd450513          	addi	a0,a0,-556 # 800074b8 <etext+0x4b8>
    800026ec:	4fb020ef          	jal	800053e6 <panic>

00000000800026f0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800026f0:	7179                	addi	sp,sp,-48
    800026f2:	f406                	sd	ra,40(sp)
    800026f4:	f022                	sd	s0,32(sp)
    800026f6:	ec26                	sd	s1,24(sp)
    800026f8:	e84a                	sd	s2,16(sp)
    800026fa:	e44e                	sd	s3,8(sp)
    800026fc:	1800                	addi	s0,sp,48
    800026fe:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002700:	05050493          	addi	s1,a0,80
    80002704:	08050913          	addi	s2,a0,128
    80002708:	a021                	j	80002710 <itrunc+0x20>
    8000270a:	0491                	addi	s1,s1,4
    8000270c:	01248b63          	beq	s1,s2,80002722 <itrunc+0x32>
    if(ip->addrs[i]){
    80002710:	408c                	lw	a1,0(s1)
    80002712:	dde5                	beqz	a1,8000270a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002714:	0009a503          	lw	a0,0(s3)
    80002718:	9cdff0ef          	jal	800020e4 <bfree>
      ip->addrs[i] = 0;
    8000271c:	0004a023          	sw	zero,0(s1)
    80002720:	b7ed                	j	8000270a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002722:	0809a583          	lw	a1,128(s3)
    80002726:	ed89                	bnez	a1,80002740 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002728:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000272c:	854e                	mv	a0,s3
    8000272e:	e21ff0ef          	jal	8000254e <iupdate>
}
    80002732:	70a2                	ld	ra,40(sp)
    80002734:	7402                	ld	s0,32(sp)
    80002736:	64e2                	ld	s1,24(sp)
    80002738:	6942                	ld	s2,16(sp)
    8000273a:	69a2                	ld	s3,8(sp)
    8000273c:	6145                	addi	sp,sp,48
    8000273e:	8082                	ret
    80002740:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002742:	0009a503          	lw	a0,0(s3)
    80002746:	faaff0ef          	jal	80001ef0 <bread>
    8000274a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000274c:	05850493          	addi	s1,a0,88
    80002750:	45850913          	addi	s2,a0,1112
    80002754:	a021                	j	8000275c <itrunc+0x6c>
    80002756:	0491                	addi	s1,s1,4
    80002758:	01248963          	beq	s1,s2,8000276a <itrunc+0x7a>
      if(a[j])
    8000275c:	408c                	lw	a1,0(s1)
    8000275e:	dde5                	beqz	a1,80002756 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002760:	0009a503          	lw	a0,0(s3)
    80002764:	981ff0ef          	jal	800020e4 <bfree>
    80002768:	b7fd                	j	80002756 <itrunc+0x66>
    brelse(bp);
    8000276a:	8552                	mv	a0,s4
    8000276c:	88dff0ef          	jal	80001ff8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002770:	0809a583          	lw	a1,128(s3)
    80002774:	0009a503          	lw	a0,0(s3)
    80002778:	96dff0ef          	jal	800020e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000277c:	0809a023          	sw	zero,128(s3)
    80002780:	6a02                	ld	s4,0(sp)
    80002782:	b75d                	j	80002728 <itrunc+0x38>

0000000080002784 <iput>:
{
    80002784:	1101                	addi	sp,sp,-32
    80002786:	ec06                	sd	ra,24(sp)
    80002788:	e822                	sd	s0,16(sp)
    8000278a:	e426                	sd	s1,8(sp)
    8000278c:	1000                	addi	s0,sp,32
    8000278e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002790:	00016517          	auipc	a0,0x16
    80002794:	06850513          	addi	a0,a0,104 # 800187f8 <itable>
    80002798:	77d020ef          	jal	80005714 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000279c:	4498                	lw	a4,8(s1)
    8000279e:	4785                	li	a5,1
    800027a0:	02f70063          	beq	a4,a5,800027c0 <iput+0x3c>
  ip->ref--;
    800027a4:	449c                	lw	a5,8(s1)
    800027a6:	37fd                	addiw	a5,a5,-1
    800027a8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027aa:	00016517          	auipc	a0,0x16
    800027ae:	04e50513          	addi	a0,a0,78 # 800187f8 <itable>
    800027b2:	7f7020ef          	jal	800057a8 <release>
}
    800027b6:	60e2                	ld	ra,24(sp)
    800027b8:	6442                	ld	s0,16(sp)
    800027ba:	64a2                	ld	s1,8(sp)
    800027bc:	6105                	addi	sp,sp,32
    800027be:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027c0:	40bc                	lw	a5,64(s1)
    800027c2:	d3ed                	beqz	a5,800027a4 <iput+0x20>
    800027c4:	04a49783          	lh	a5,74(s1)
    800027c8:	fff1                	bnez	a5,800027a4 <iput+0x20>
    800027ca:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800027cc:	01048913          	addi	s2,s1,16
    800027d0:	854a                	mv	a0,s2
    800027d2:	173000ef          	jal	80003144 <acquiresleep>
    release(&itable.lock);
    800027d6:	00016517          	auipc	a0,0x16
    800027da:	02250513          	addi	a0,a0,34 # 800187f8 <itable>
    800027de:	7cb020ef          	jal	800057a8 <release>
    itrunc(ip);
    800027e2:	8526                	mv	a0,s1
    800027e4:	f0dff0ef          	jal	800026f0 <itrunc>
    ip->type = 0;
    800027e8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800027ec:	8526                	mv	a0,s1
    800027ee:	d61ff0ef          	jal	8000254e <iupdate>
    ip->valid = 0;
    800027f2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800027f6:	854a                	mv	a0,s2
    800027f8:	193000ef          	jal	8000318a <releasesleep>
    acquire(&itable.lock);
    800027fc:	00016517          	auipc	a0,0x16
    80002800:	ffc50513          	addi	a0,a0,-4 # 800187f8 <itable>
    80002804:	711020ef          	jal	80005714 <acquire>
    80002808:	6902                	ld	s2,0(sp)
    8000280a:	bf69                	j	800027a4 <iput+0x20>

000000008000280c <iunlockput>:
{
    8000280c:	1101                	addi	sp,sp,-32
    8000280e:	ec06                	sd	ra,24(sp)
    80002810:	e822                	sd	s0,16(sp)
    80002812:	e426                	sd	s1,8(sp)
    80002814:	1000                	addi	s0,sp,32
    80002816:	84aa                	mv	s1,a0
  iunlock(ip);
    80002818:	e99ff0ef          	jal	800026b0 <iunlock>
  iput(ip);
    8000281c:	8526                	mv	a0,s1
    8000281e:	f67ff0ef          	jal	80002784 <iput>
}
    80002822:	60e2                	ld	ra,24(sp)
    80002824:	6442                	ld	s0,16(sp)
    80002826:	64a2                	ld	s1,8(sp)
    80002828:	6105                	addi	sp,sp,32
    8000282a:	8082                	ret

000000008000282c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000282c:	1141                	addi	sp,sp,-16
    8000282e:	e406                	sd	ra,8(sp)
    80002830:	e022                	sd	s0,0(sp)
    80002832:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002834:	411c                	lw	a5,0(a0)
    80002836:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002838:	415c                	lw	a5,4(a0)
    8000283a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000283c:	04451783          	lh	a5,68(a0)
    80002840:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002844:	04a51783          	lh	a5,74(a0)
    80002848:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000284c:	04c56783          	lwu	a5,76(a0)
    80002850:	e99c                	sd	a5,16(a1)
}
    80002852:	60a2                	ld	ra,8(sp)
    80002854:	6402                	ld	s0,0(sp)
    80002856:	0141                	addi	sp,sp,16
    80002858:	8082                	ret

000000008000285a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000285a:	457c                	lw	a5,76(a0)
    8000285c:	0ed7e663          	bltu	a5,a3,80002948 <readi+0xee>
{
    80002860:	7159                	addi	sp,sp,-112
    80002862:	f486                	sd	ra,104(sp)
    80002864:	f0a2                	sd	s0,96(sp)
    80002866:	eca6                	sd	s1,88(sp)
    80002868:	e0d2                	sd	s4,64(sp)
    8000286a:	fc56                	sd	s5,56(sp)
    8000286c:	f85a                	sd	s6,48(sp)
    8000286e:	f45e                	sd	s7,40(sp)
    80002870:	1880                	addi	s0,sp,112
    80002872:	8b2a                	mv	s6,a0
    80002874:	8bae                	mv	s7,a1
    80002876:	8a32                	mv	s4,a2
    80002878:	84b6                	mv	s1,a3
    8000287a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000287c:	9f35                	addw	a4,a4,a3
    return 0;
    8000287e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002880:	0ad76b63          	bltu	a4,a3,80002936 <readi+0xdc>
    80002884:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002886:	00e7f463          	bgeu	a5,a4,8000288e <readi+0x34>
    n = ip->size - off;
    8000288a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000288e:	080a8b63          	beqz	s5,80002924 <readi+0xca>
    80002892:	e8ca                	sd	s2,80(sp)
    80002894:	f062                	sd	s8,32(sp)
    80002896:	ec66                	sd	s9,24(sp)
    80002898:	e86a                	sd	s10,16(sp)
    8000289a:	e46e                	sd	s11,8(sp)
    8000289c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000289e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800028a2:	5c7d                	li	s8,-1
    800028a4:	a80d                	j	800028d6 <readi+0x7c>
    800028a6:	020d1d93          	slli	s11,s10,0x20
    800028aa:	020ddd93          	srli	s11,s11,0x20
    800028ae:	05890613          	addi	a2,s2,88
    800028b2:	86ee                	mv	a3,s11
    800028b4:	963e                	add	a2,a2,a5
    800028b6:	85d2                	mv	a1,s4
    800028b8:	855e                	mv	a0,s7
    800028ba:	dc7fe0ef          	jal	80001680 <either_copyout>
    800028be:	05850363          	beq	a0,s8,80002904 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800028c2:	854a                	mv	a0,s2
    800028c4:	f34ff0ef          	jal	80001ff8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028c8:	013d09bb          	addw	s3,s10,s3
    800028cc:	009d04bb          	addw	s1,s10,s1
    800028d0:	9a6e                	add	s4,s4,s11
    800028d2:	0559f363          	bgeu	s3,s5,80002918 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800028d6:	00a4d59b          	srliw	a1,s1,0xa
    800028da:	855a                	mv	a0,s6
    800028dc:	987ff0ef          	jal	80002262 <bmap>
    800028e0:	85aa                	mv	a1,a0
    if(addr == 0)
    800028e2:	c139                	beqz	a0,80002928 <readi+0xce>
    bp = bread(ip->dev, addr);
    800028e4:	000b2503          	lw	a0,0(s6)
    800028e8:	e08ff0ef          	jal	80001ef0 <bread>
    800028ec:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800028ee:	3ff4f793          	andi	a5,s1,1023
    800028f2:	40fc873b          	subw	a4,s9,a5
    800028f6:	413a86bb          	subw	a3,s5,s3
    800028fa:	8d3a                	mv	s10,a4
    800028fc:	fae6f5e3          	bgeu	a3,a4,800028a6 <readi+0x4c>
    80002900:	8d36                	mv	s10,a3
    80002902:	b755                	j	800028a6 <readi+0x4c>
      brelse(bp);
    80002904:	854a                	mv	a0,s2
    80002906:	ef2ff0ef          	jal	80001ff8 <brelse>
      tot = -1;
    8000290a:	59fd                	li	s3,-1
      break;
    8000290c:	6946                	ld	s2,80(sp)
    8000290e:	7c02                	ld	s8,32(sp)
    80002910:	6ce2                	ld	s9,24(sp)
    80002912:	6d42                	ld	s10,16(sp)
    80002914:	6da2                	ld	s11,8(sp)
    80002916:	a831                	j	80002932 <readi+0xd8>
    80002918:	6946                	ld	s2,80(sp)
    8000291a:	7c02                	ld	s8,32(sp)
    8000291c:	6ce2                	ld	s9,24(sp)
    8000291e:	6d42                	ld	s10,16(sp)
    80002920:	6da2                	ld	s11,8(sp)
    80002922:	a801                	j	80002932 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002924:	89d6                	mv	s3,s5
    80002926:	a031                	j	80002932 <readi+0xd8>
    80002928:	6946                	ld	s2,80(sp)
    8000292a:	7c02                	ld	s8,32(sp)
    8000292c:	6ce2                	ld	s9,24(sp)
    8000292e:	6d42                	ld	s10,16(sp)
    80002930:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002932:	854e                	mv	a0,s3
    80002934:	69a6                	ld	s3,72(sp)
}
    80002936:	70a6                	ld	ra,104(sp)
    80002938:	7406                	ld	s0,96(sp)
    8000293a:	64e6                	ld	s1,88(sp)
    8000293c:	6a06                	ld	s4,64(sp)
    8000293e:	7ae2                	ld	s5,56(sp)
    80002940:	7b42                	ld	s6,48(sp)
    80002942:	7ba2                	ld	s7,40(sp)
    80002944:	6165                	addi	sp,sp,112
    80002946:	8082                	ret
    return 0;
    80002948:	4501                	li	a0,0
}
    8000294a:	8082                	ret

000000008000294c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000294c:	457c                	lw	a5,76(a0)
    8000294e:	0ed7eb63          	bltu	a5,a3,80002a44 <writei+0xf8>
{
    80002952:	7159                	addi	sp,sp,-112
    80002954:	f486                	sd	ra,104(sp)
    80002956:	f0a2                	sd	s0,96(sp)
    80002958:	e8ca                	sd	s2,80(sp)
    8000295a:	e0d2                	sd	s4,64(sp)
    8000295c:	fc56                	sd	s5,56(sp)
    8000295e:	f85a                	sd	s6,48(sp)
    80002960:	f45e                	sd	s7,40(sp)
    80002962:	1880                	addi	s0,sp,112
    80002964:	8aaa                	mv	s5,a0
    80002966:	8bae                	mv	s7,a1
    80002968:	8a32                	mv	s4,a2
    8000296a:	8936                	mv	s2,a3
    8000296c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000296e:	00e687bb          	addw	a5,a3,a4
    80002972:	0cd7eb63          	bltu	a5,a3,80002a48 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002976:	00043737          	lui	a4,0x43
    8000297a:	0cf76963          	bltu	a4,a5,80002a4c <writei+0x100>
    8000297e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002980:	0a0b0a63          	beqz	s6,80002a34 <writei+0xe8>
    80002984:	eca6                	sd	s1,88(sp)
    80002986:	f062                	sd	s8,32(sp)
    80002988:	ec66                	sd	s9,24(sp)
    8000298a:	e86a                	sd	s10,16(sp)
    8000298c:	e46e                	sd	s11,8(sp)
    8000298e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002990:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002994:	5c7d                	li	s8,-1
    80002996:	a825                	j	800029ce <writei+0x82>
    80002998:	020d1d93          	slli	s11,s10,0x20
    8000299c:	020ddd93          	srli	s11,s11,0x20
    800029a0:	05848513          	addi	a0,s1,88
    800029a4:	86ee                	mv	a3,s11
    800029a6:	8652                	mv	a2,s4
    800029a8:	85de                	mv	a1,s7
    800029aa:	953e                	add	a0,a0,a5
    800029ac:	d1ffe0ef          	jal	800016ca <either_copyin>
    800029b0:	05850663          	beq	a0,s8,800029fc <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    800029b4:	8526                	mv	a0,s1
    800029b6:	688000ef          	jal	8000303e <log_write>
    brelse(bp);
    800029ba:	8526                	mv	a0,s1
    800029bc:	e3cff0ef          	jal	80001ff8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029c0:	013d09bb          	addw	s3,s10,s3
    800029c4:	012d093b          	addw	s2,s10,s2
    800029c8:	9a6e                	add	s4,s4,s11
    800029ca:	0369fc63          	bgeu	s3,s6,80002a02 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800029ce:	00a9559b          	srliw	a1,s2,0xa
    800029d2:	8556                	mv	a0,s5
    800029d4:	88fff0ef          	jal	80002262 <bmap>
    800029d8:	85aa                	mv	a1,a0
    if(addr == 0)
    800029da:	c505                	beqz	a0,80002a02 <writei+0xb6>
    bp = bread(ip->dev, addr);
    800029dc:	000aa503          	lw	a0,0(s5)
    800029e0:	d10ff0ef          	jal	80001ef0 <bread>
    800029e4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029e6:	3ff97793          	andi	a5,s2,1023
    800029ea:	40fc873b          	subw	a4,s9,a5
    800029ee:	413b06bb          	subw	a3,s6,s3
    800029f2:	8d3a                	mv	s10,a4
    800029f4:	fae6f2e3          	bgeu	a3,a4,80002998 <writei+0x4c>
    800029f8:	8d36                	mv	s10,a3
    800029fa:	bf79                	j	80002998 <writei+0x4c>
      brelse(bp);
    800029fc:	8526                	mv	a0,s1
    800029fe:	dfaff0ef          	jal	80001ff8 <brelse>
  }

  if(off > ip->size)
    80002a02:	04caa783          	lw	a5,76(s5)
    80002a06:	0327f963          	bgeu	a5,s2,80002a38 <writei+0xec>
    ip->size = off;
    80002a0a:	052aa623          	sw	s2,76(s5)
    80002a0e:	64e6                	ld	s1,88(sp)
    80002a10:	7c02                	ld	s8,32(sp)
    80002a12:	6ce2                	ld	s9,24(sp)
    80002a14:	6d42                	ld	s10,16(sp)
    80002a16:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a18:	8556                	mv	a0,s5
    80002a1a:	b35ff0ef          	jal	8000254e <iupdate>

  return tot;
    80002a1e:	854e                	mv	a0,s3
    80002a20:	69a6                	ld	s3,72(sp)
}
    80002a22:	70a6                	ld	ra,104(sp)
    80002a24:	7406                	ld	s0,96(sp)
    80002a26:	6946                	ld	s2,80(sp)
    80002a28:	6a06                	ld	s4,64(sp)
    80002a2a:	7ae2                	ld	s5,56(sp)
    80002a2c:	7b42                	ld	s6,48(sp)
    80002a2e:	7ba2                	ld	s7,40(sp)
    80002a30:	6165                	addi	sp,sp,112
    80002a32:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a34:	89da                	mv	s3,s6
    80002a36:	b7cd                	j	80002a18 <writei+0xcc>
    80002a38:	64e6                	ld	s1,88(sp)
    80002a3a:	7c02                	ld	s8,32(sp)
    80002a3c:	6ce2                	ld	s9,24(sp)
    80002a3e:	6d42                	ld	s10,16(sp)
    80002a40:	6da2                	ld	s11,8(sp)
    80002a42:	bfd9                	j	80002a18 <writei+0xcc>
    return -1;
    80002a44:	557d                	li	a0,-1
}
    80002a46:	8082                	ret
    return -1;
    80002a48:	557d                	li	a0,-1
    80002a4a:	bfe1                	j	80002a22 <writei+0xd6>
    return -1;
    80002a4c:	557d                	li	a0,-1
    80002a4e:	bfd1                	j	80002a22 <writei+0xd6>

0000000080002a50 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002a50:	1141                	addi	sp,sp,-16
    80002a52:	e406                	sd	ra,8(sp)
    80002a54:	e022                	sd	s0,0(sp)
    80002a56:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002a58:	4639                	li	a2,14
    80002a5a:	fccfd0ef          	jal	80000226 <strncmp>
}
    80002a5e:	60a2                	ld	ra,8(sp)
    80002a60:	6402                	ld	s0,0(sp)
    80002a62:	0141                	addi	sp,sp,16
    80002a64:	8082                	ret

0000000080002a66 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002a66:	711d                	addi	sp,sp,-96
    80002a68:	ec86                	sd	ra,88(sp)
    80002a6a:	e8a2                	sd	s0,80(sp)
    80002a6c:	e4a6                	sd	s1,72(sp)
    80002a6e:	e0ca                	sd	s2,64(sp)
    80002a70:	fc4e                	sd	s3,56(sp)
    80002a72:	f852                	sd	s4,48(sp)
    80002a74:	f456                	sd	s5,40(sp)
    80002a76:	f05a                	sd	s6,32(sp)
    80002a78:	ec5e                	sd	s7,24(sp)
    80002a7a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002a7c:	04451703          	lh	a4,68(a0)
    80002a80:	4785                	li	a5,1
    80002a82:	00f71f63          	bne	a4,a5,80002aa0 <dirlookup+0x3a>
    80002a86:	892a                	mv	s2,a0
    80002a88:	8aae                	mv	s5,a1
    80002a8a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a8c:	457c                	lw	a5,76(a0)
    80002a8e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002a90:	fa040a13          	addi	s4,s0,-96
    80002a94:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002a96:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002a9a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a9c:	e39d                	bnez	a5,80002ac2 <dirlookup+0x5c>
    80002a9e:	a8b9                	j	80002afc <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002aa0:	00005517          	auipc	a0,0x5
    80002aa4:	a2050513          	addi	a0,a0,-1504 # 800074c0 <etext+0x4c0>
    80002aa8:	13f020ef          	jal	800053e6 <panic>
      panic("dirlookup read");
    80002aac:	00005517          	auipc	a0,0x5
    80002ab0:	a2c50513          	addi	a0,a0,-1492 # 800074d8 <etext+0x4d8>
    80002ab4:	133020ef          	jal	800053e6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ab8:	24c1                	addiw	s1,s1,16
    80002aba:	04c92783          	lw	a5,76(s2)
    80002abe:	02f4fe63          	bgeu	s1,a5,80002afa <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ac2:	874e                	mv	a4,s3
    80002ac4:	86a6                	mv	a3,s1
    80002ac6:	8652                	mv	a2,s4
    80002ac8:	4581                	li	a1,0
    80002aca:	854a                	mv	a0,s2
    80002acc:	d8fff0ef          	jal	8000285a <readi>
    80002ad0:	fd351ee3          	bne	a0,s3,80002aac <dirlookup+0x46>
    if(de.inum == 0)
    80002ad4:	fa045783          	lhu	a5,-96(s0)
    80002ad8:	d3e5                	beqz	a5,80002ab8 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002ada:	85da                	mv	a1,s6
    80002adc:	8556                	mv	a0,s5
    80002ade:	f73ff0ef          	jal	80002a50 <namecmp>
    80002ae2:	f979                	bnez	a0,80002ab8 <dirlookup+0x52>
      if(poff)
    80002ae4:	000b8463          	beqz	s7,80002aec <dirlookup+0x86>
        *poff = off;
    80002ae8:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002aec:	fa045583          	lhu	a1,-96(s0)
    80002af0:	00092503          	lw	a0,0(s2)
    80002af4:	82fff0ef          	jal	80002322 <iget>
    80002af8:	a011                	j	80002afc <dirlookup+0x96>
  return 0;
    80002afa:	4501                	li	a0,0
}
    80002afc:	60e6                	ld	ra,88(sp)
    80002afe:	6446                	ld	s0,80(sp)
    80002b00:	64a6                	ld	s1,72(sp)
    80002b02:	6906                	ld	s2,64(sp)
    80002b04:	79e2                	ld	s3,56(sp)
    80002b06:	7a42                	ld	s4,48(sp)
    80002b08:	7aa2                	ld	s5,40(sp)
    80002b0a:	7b02                	ld	s6,32(sp)
    80002b0c:	6be2                	ld	s7,24(sp)
    80002b0e:	6125                	addi	sp,sp,96
    80002b10:	8082                	ret

0000000080002b12 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b12:	711d                	addi	sp,sp,-96
    80002b14:	ec86                	sd	ra,88(sp)
    80002b16:	e8a2                	sd	s0,80(sp)
    80002b18:	e4a6                	sd	s1,72(sp)
    80002b1a:	e0ca                	sd	s2,64(sp)
    80002b1c:	fc4e                	sd	s3,56(sp)
    80002b1e:	f852                	sd	s4,48(sp)
    80002b20:	f456                	sd	s5,40(sp)
    80002b22:	f05a                	sd	s6,32(sp)
    80002b24:	ec5e                	sd	s7,24(sp)
    80002b26:	e862                	sd	s8,16(sp)
    80002b28:	e466                	sd	s9,8(sp)
    80002b2a:	e06a                	sd	s10,0(sp)
    80002b2c:	1080                	addi	s0,sp,96
    80002b2e:	84aa                	mv	s1,a0
    80002b30:	8b2e                	mv	s6,a1
    80002b32:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002b34:	00054703          	lbu	a4,0(a0)
    80002b38:	02f00793          	li	a5,47
    80002b3c:	00f70f63          	beq	a4,a5,80002b5a <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002b40:	a1cfe0ef          	jal	80000d5c <myproc>
    80002b44:	15053503          	ld	a0,336(a0)
    80002b48:	a85ff0ef          	jal	800025cc <idup>
    80002b4c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002b4e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002b52:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002b54:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002b56:	4b85                	li	s7,1
    80002b58:	a879                	j	80002bf6 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002b5a:	4585                	li	a1,1
    80002b5c:	852e                	mv	a0,a1
    80002b5e:	fc4ff0ef          	jal	80002322 <iget>
    80002b62:	8a2a                	mv	s4,a0
    80002b64:	b7ed                	j	80002b4e <namex+0x3c>
      iunlockput(ip);
    80002b66:	8552                	mv	a0,s4
    80002b68:	ca5ff0ef          	jal	8000280c <iunlockput>
      return 0;
    80002b6c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002b6e:	8552                	mv	a0,s4
    80002b70:	60e6                	ld	ra,88(sp)
    80002b72:	6446                	ld	s0,80(sp)
    80002b74:	64a6                	ld	s1,72(sp)
    80002b76:	6906                	ld	s2,64(sp)
    80002b78:	79e2                	ld	s3,56(sp)
    80002b7a:	7a42                	ld	s4,48(sp)
    80002b7c:	7aa2                	ld	s5,40(sp)
    80002b7e:	7b02                	ld	s6,32(sp)
    80002b80:	6be2                	ld	s7,24(sp)
    80002b82:	6c42                	ld	s8,16(sp)
    80002b84:	6ca2                	ld	s9,8(sp)
    80002b86:	6d02                	ld	s10,0(sp)
    80002b88:	6125                	addi	sp,sp,96
    80002b8a:	8082                	ret
      iunlock(ip);
    80002b8c:	8552                	mv	a0,s4
    80002b8e:	b23ff0ef          	jal	800026b0 <iunlock>
      return ip;
    80002b92:	bff1                	j	80002b6e <namex+0x5c>
      iunlockput(ip);
    80002b94:	8552                	mv	a0,s4
    80002b96:	c77ff0ef          	jal	8000280c <iunlockput>
      return 0;
    80002b9a:	8a4e                	mv	s4,s3
    80002b9c:	bfc9                	j	80002b6e <namex+0x5c>
  len = path - s;
    80002b9e:	40998633          	sub	a2,s3,s1
    80002ba2:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002ba6:	09ac5063          	bge	s8,s10,80002c26 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002baa:	8666                	mv	a2,s9
    80002bac:	85a6                	mv	a1,s1
    80002bae:	8556                	mv	a0,s5
    80002bb0:	e02fd0ef          	jal	800001b2 <memmove>
    80002bb4:	84ce                	mv	s1,s3
  while(*path == '/')
    80002bb6:	0004c783          	lbu	a5,0(s1)
    80002bba:	01279763          	bne	a5,s2,80002bc8 <namex+0xb6>
    path++;
    80002bbe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002bc0:	0004c783          	lbu	a5,0(s1)
    80002bc4:	ff278de3          	beq	a5,s2,80002bbe <namex+0xac>
    ilock(ip);
    80002bc8:	8552                	mv	a0,s4
    80002bca:	a39ff0ef          	jal	80002602 <ilock>
    if(ip->type != T_DIR){
    80002bce:	044a1783          	lh	a5,68(s4)
    80002bd2:	f9779ae3          	bne	a5,s7,80002b66 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002bd6:	000b0563          	beqz	s6,80002be0 <namex+0xce>
    80002bda:	0004c783          	lbu	a5,0(s1)
    80002bde:	d7dd                	beqz	a5,80002b8c <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002be0:	4601                	li	a2,0
    80002be2:	85d6                	mv	a1,s5
    80002be4:	8552                	mv	a0,s4
    80002be6:	e81ff0ef          	jal	80002a66 <dirlookup>
    80002bea:	89aa                	mv	s3,a0
    80002bec:	d545                	beqz	a0,80002b94 <namex+0x82>
    iunlockput(ip);
    80002bee:	8552                	mv	a0,s4
    80002bf0:	c1dff0ef          	jal	8000280c <iunlockput>
    ip = next;
    80002bf4:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002bf6:	0004c783          	lbu	a5,0(s1)
    80002bfa:	01279763          	bne	a5,s2,80002c08 <namex+0xf6>
    path++;
    80002bfe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c00:	0004c783          	lbu	a5,0(s1)
    80002c04:	ff278de3          	beq	a5,s2,80002bfe <namex+0xec>
  if(*path == 0)
    80002c08:	cb8d                	beqz	a5,80002c3a <namex+0x128>
  while(*path != '/' && *path != 0)
    80002c0a:	0004c783          	lbu	a5,0(s1)
    80002c0e:	89a6                	mv	s3,s1
  len = path - s;
    80002c10:	4d01                	li	s10,0
    80002c12:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002c14:	01278963          	beq	a5,s2,80002c26 <namex+0x114>
    80002c18:	d3d9                	beqz	a5,80002b9e <namex+0x8c>
    path++;
    80002c1a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c1c:	0009c783          	lbu	a5,0(s3)
    80002c20:	ff279ce3          	bne	a5,s2,80002c18 <namex+0x106>
    80002c24:	bfad                	j	80002b9e <namex+0x8c>
    memmove(name, s, len);
    80002c26:	2601                	sext.w	a2,a2
    80002c28:	85a6                	mv	a1,s1
    80002c2a:	8556                	mv	a0,s5
    80002c2c:	d86fd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002c30:	9d56                	add	s10,s10,s5
    80002c32:	000d0023          	sb	zero,0(s10)
    80002c36:	84ce                	mv	s1,s3
    80002c38:	bfbd                	j	80002bb6 <namex+0xa4>
  if(nameiparent){
    80002c3a:	f20b0ae3          	beqz	s6,80002b6e <namex+0x5c>
    iput(ip);
    80002c3e:	8552                	mv	a0,s4
    80002c40:	b45ff0ef          	jal	80002784 <iput>
    return 0;
    80002c44:	4a01                	li	s4,0
    80002c46:	b725                	j	80002b6e <namex+0x5c>

0000000080002c48 <dirlink>:
{
    80002c48:	715d                	addi	sp,sp,-80
    80002c4a:	e486                	sd	ra,72(sp)
    80002c4c:	e0a2                	sd	s0,64(sp)
    80002c4e:	f84a                	sd	s2,48(sp)
    80002c50:	ec56                	sd	s5,24(sp)
    80002c52:	e85a                	sd	s6,16(sp)
    80002c54:	0880                	addi	s0,sp,80
    80002c56:	892a                	mv	s2,a0
    80002c58:	8aae                	mv	s5,a1
    80002c5a:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002c5c:	4601                	li	a2,0
    80002c5e:	e09ff0ef          	jal	80002a66 <dirlookup>
    80002c62:	ed1d                	bnez	a0,80002ca0 <dirlink+0x58>
    80002c64:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c66:	04c92483          	lw	s1,76(s2)
    80002c6a:	c4b9                	beqz	s1,80002cb8 <dirlink+0x70>
    80002c6c:	f44e                	sd	s3,40(sp)
    80002c6e:	f052                	sd	s4,32(sp)
    80002c70:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c72:	fb040a13          	addi	s4,s0,-80
    80002c76:	49c1                	li	s3,16
    80002c78:	874e                	mv	a4,s3
    80002c7a:	86a6                	mv	a3,s1
    80002c7c:	8652                	mv	a2,s4
    80002c7e:	4581                	li	a1,0
    80002c80:	854a                	mv	a0,s2
    80002c82:	bd9ff0ef          	jal	8000285a <readi>
    80002c86:	03351163          	bne	a0,s3,80002ca8 <dirlink+0x60>
    if(de.inum == 0)
    80002c8a:	fb045783          	lhu	a5,-80(s0)
    80002c8e:	c39d                	beqz	a5,80002cb4 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c90:	24c1                	addiw	s1,s1,16
    80002c92:	04c92783          	lw	a5,76(s2)
    80002c96:	fef4e1e3          	bltu	s1,a5,80002c78 <dirlink+0x30>
    80002c9a:	79a2                	ld	s3,40(sp)
    80002c9c:	7a02                	ld	s4,32(sp)
    80002c9e:	a829                	j	80002cb8 <dirlink+0x70>
    iput(ip);
    80002ca0:	ae5ff0ef          	jal	80002784 <iput>
    return -1;
    80002ca4:	557d                	li	a0,-1
    80002ca6:	a83d                	j	80002ce4 <dirlink+0x9c>
      panic("dirlink read");
    80002ca8:	00005517          	auipc	a0,0x5
    80002cac:	84050513          	addi	a0,a0,-1984 # 800074e8 <etext+0x4e8>
    80002cb0:	736020ef          	jal	800053e6 <panic>
    80002cb4:	79a2                	ld	s3,40(sp)
    80002cb6:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002cb8:	4639                	li	a2,14
    80002cba:	85d6                	mv	a1,s5
    80002cbc:	fb240513          	addi	a0,s0,-78
    80002cc0:	da0fd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002cc4:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cc8:	4741                	li	a4,16
    80002cca:	86a6                	mv	a3,s1
    80002ccc:	fb040613          	addi	a2,s0,-80
    80002cd0:	4581                	li	a1,0
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	c79ff0ef          	jal	8000294c <writei>
    80002cd8:	1541                	addi	a0,a0,-16
    80002cda:	00a03533          	snez	a0,a0
    80002cde:	40a0053b          	negw	a0,a0
    80002ce2:	74e2                	ld	s1,56(sp)
}
    80002ce4:	60a6                	ld	ra,72(sp)
    80002ce6:	6406                	ld	s0,64(sp)
    80002ce8:	7942                	ld	s2,48(sp)
    80002cea:	6ae2                	ld	s5,24(sp)
    80002cec:	6b42                	ld	s6,16(sp)
    80002cee:	6161                	addi	sp,sp,80
    80002cf0:	8082                	ret

0000000080002cf2 <namei>:

struct inode*
namei(char *path)
{
    80002cf2:	1101                	addi	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002cfa:	fe040613          	addi	a2,s0,-32
    80002cfe:	4581                	li	a1,0
    80002d00:	e13ff0ef          	jal	80002b12 <namex>
}
    80002d04:	60e2                	ld	ra,24(sp)
    80002d06:	6442                	ld	s0,16(sp)
    80002d08:	6105                	addi	sp,sp,32
    80002d0a:	8082                	ret

0000000080002d0c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d0c:	1141                	addi	sp,sp,-16
    80002d0e:	e406                	sd	ra,8(sp)
    80002d10:	e022                	sd	s0,0(sp)
    80002d12:	0800                	addi	s0,sp,16
    80002d14:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d16:	4585                	li	a1,1
    80002d18:	dfbff0ef          	jal	80002b12 <namex>
}
    80002d1c:	60a2                	ld	ra,8(sp)
    80002d1e:	6402                	ld	s0,0(sp)
    80002d20:	0141                	addi	sp,sp,16
    80002d22:	8082                	ret

0000000080002d24 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d24:	1101                	addi	sp,sp,-32
    80002d26:	ec06                	sd	ra,24(sp)
    80002d28:	e822                	sd	s0,16(sp)
    80002d2a:	e426                	sd	s1,8(sp)
    80002d2c:	e04a                	sd	s2,0(sp)
    80002d2e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002d30:	00017917          	auipc	s2,0x17
    80002d34:	57090913          	addi	s2,s2,1392 # 8001a2a0 <log>
    80002d38:	01892583          	lw	a1,24(s2)
    80002d3c:	02892503          	lw	a0,40(s2)
    80002d40:	9b0ff0ef          	jal	80001ef0 <bread>
    80002d44:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002d46:	02c92603          	lw	a2,44(s2)
    80002d4a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002d4c:	00c05f63          	blez	a2,80002d6a <write_head+0x46>
    80002d50:	00017717          	auipc	a4,0x17
    80002d54:	58070713          	addi	a4,a4,1408 # 8001a2d0 <log+0x30>
    80002d58:	87aa                	mv	a5,a0
    80002d5a:	060a                	slli	a2,a2,0x2
    80002d5c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002d5e:	4314                	lw	a3,0(a4)
    80002d60:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002d62:	0711                	addi	a4,a4,4
    80002d64:	0791                	addi	a5,a5,4
    80002d66:	fec79ce3          	bne	a5,a2,80002d5e <write_head+0x3a>
  }
  bwrite(buf);
    80002d6a:	8526                	mv	a0,s1
    80002d6c:	a5aff0ef          	jal	80001fc6 <bwrite>
  brelse(buf);
    80002d70:	8526                	mv	a0,s1
    80002d72:	a86ff0ef          	jal	80001ff8 <brelse>
}
    80002d76:	60e2                	ld	ra,24(sp)
    80002d78:	6442                	ld	s0,16(sp)
    80002d7a:	64a2                	ld	s1,8(sp)
    80002d7c:	6902                	ld	s2,0(sp)
    80002d7e:	6105                	addi	sp,sp,32
    80002d80:	8082                	ret

0000000080002d82 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002d82:	00017797          	auipc	a5,0x17
    80002d86:	54a7a783          	lw	a5,1354(a5) # 8001a2cc <log+0x2c>
    80002d8a:	0af05263          	blez	a5,80002e2e <install_trans+0xac>
{
    80002d8e:	715d                	addi	sp,sp,-80
    80002d90:	e486                	sd	ra,72(sp)
    80002d92:	e0a2                	sd	s0,64(sp)
    80002d94:	fc26                	sd	s1,56(sp)
    80002d96:	f84a                	sd	s2,48(sp)
    80002d98:	f44e                	sd	s3,40(sp)
    80002d9a:	f052                	sd	s4,32(sp)
    80002d9c:	ec56                	sd	s5,24(sp)
    80002d9e:	e85a                	sd	s6,16(sp)
    80002da0:	e45e                	sd	s7,8(sp)
    80002da2:	0880                	addi	s0,sp,80
    80002da4:	8b2a                	mv	s6,a0
    80002da6:	00017a97          	auipc	s5,0x17
    80002daa:	52aa8a93          	addi	s5,s5,1322 # 8001a2d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dae:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002db0:	00017997          	auipc	s3,0x17
    80002db4:	4f098993          	addi	s3,s3,1264 # 8001a2a0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002db8:	40000b93          	li	s7,1024
    80002dbc:	a829                	j	80002dd6 <install_trans+0x54>
    brelse(lbuf);
    80002dbe:	854a                	mv	a0,s2
    80002dc0:	a38ff0ef          	jal	80001ff8 <brelse>
    brelse(dbuf);
    80002dc4:	8526                	mv	a0,s1
    80002dc6:	a32ff0ef          	jal	80001ff8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dca:	2a05                	addiw	s4,s4,1
    80002dcc:	0a91                	addi	s5,s5,4
    80002dce:	02c9a783          	lw	a5,44(s3)
    80002dd2:	04fa5363          	bge	s4,a5,80002e18 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dd6:	0189a583          	lw	a1,24(s3)
    80002dda:	014585bb          	addw	a1,a1,s4
    80002dde:	2585                	addiw	a1,a1,1
    80002de0:	0289a503          	lw	a0,40(s3)
    80002de4:	90cff0ef          	jal	80001ef0 <bread>
    80002de8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002dea:	000aa583          	lw	a1,0(s5)
    80002dee:	0289a503          	lw	a0,40(s3)
    80002df2:	8feff0ef          	jal	80001ef0 <bread>
    80002df6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002df8:	865e                	mv	a2,s7
    80002dfa:	05890593          	addi	a1,s2,88
    80002dfe:	05850513          	addi	a0,a0,88
    80002e02:	bb0fd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002e06:	8526                	mv	a0,s1
    80002e08:	9beff0ef          	jal	80001fc6 <bwrite>
    if(recovering == 0)
    80002e0c:	fa0b19e3          	bnez	s6,80002dbe <install_trans+0x3c>
      bunpin(dbuf);
    80002e10:	8526                	mv	a0,s1
    80002e12:	a9eff0ef          	jal	800020b0 <bunpin>
    80002e16:	b765                	j	80002dbe <install_trans+0x3c>
}
    80002e18:	60a6                	ld	ra,72(sp)
    80002e1a:	6406                	ld	s0,64(sp)
    80002e1c:	74e2                	ld	s1,56(sp)
    80002e1e:	7942                	ld	s2,48(sp)
    80002e20:	79a2                	ld	s3,40(sp)
    80002e22:	7a02                	ld	s4,32(sp)
    80002e24:	6ae2                	ld	s5,24(sp)
    80002e26:	6b42                	ld	s6,16(sp)
    80002e28:	6ba2                	ld	s7,8(sp)
    80002e2a:	6161                	addi	sp,sp,80
    80002e2c:	8082                	ret
    80002e2e:	8082                	ret

0000000080002e30 <initlog>:
{
    80002e30:	7179                	addi	sp,sp,-48
    80002e32:	f406                	sd	ra,40(sp)
    80002e34:	f022                	sd	s0,32(sp)
    80002e36:	ec26                	sd	s1,24(sp)
    80002e38:	e84a                	sd	s2,16(sp)
    80002e3a:	e44e                	sd	s3,8(sp)
    80002e3c:	1800                	addi	s0,sp,48
    80002e3e:	892a                	mv	s2,a0
    80002e40:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002e42:	00017497          	auipc	s1,0x17
    80002e46:	45e48493          	addi	s1,s1,1118 # 8001a2a0 <log>
    80002e4a:	00004597          	auipc	a1,0x4
    80002e4e:	6ae58593          	addi	a1,a1,1710 # 800074f8 <etext+0x4f8>
    80002e52:	8526                	mv	a0,s1
    80002e54:	03d020ef          	jal	80005690 <initlock>
  log.start = sb->logstart;
    80002e58:	0149a583          	lw	a1,20(s3)
    80002e5c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002e5e:	0109a783          	lw	a5,16(s3)
    80002e62:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002e64:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002e68:	854a                	mv	a0,s2
    80002e6a:	886ff0ef          	jal	80001ef0 <bread>
  log.lh.n = lh->n;
    80002e6e:	4d30                	lw	a2,88(a0)
    80002e70:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e72:	00c05f63          	blez	a2,80002e90 <initlog+0x60>
    80002e76:	87aa                	mv	a5,a0
    80002e78:	00017717          	auipc	a4,0x17
    80002e7c:	45870713          	addi	a4,a4,1112 # 8001a2d0 <log+0x30>
    80002e80:	060a                	slli	a2,a2,0x2
    80002e82:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002e84:	4ff4                	lw	a3,92(a5)
    80002e86:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002e88:	0791                	addi	a5,a5,4
    80002e8a:	0711                	addi	a4,a4,4
    80002e8c:	fec79ce3          	bne	a5,a2,80002e84 <initlog+0x54>
  brelse(buf);
    80002e90:	968ff0ef          	jal	80001ff8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002e94:	4505                	li	a0,1
    80002e96:	eedff0ef          	jal	80002d82 <install_trans>
  log.lh.n = 0;
    80002e9a:	00017797          	auipc	a5,0x17
    80002e9e:	4207a923          	sw	zero,1074(a5) # 8001a2cc <log+0x2c>
  write_head(); // clear the log
    80002ea2:	e83ff0ef          	jal	80002d24 <write_head>
}
    80002ea6:	70a2                	ld	ra,40(sp)
    80002ea8:	7402                	ld	s0,32(sp)
    80002eaa:	64e2                	ld	s1,24(sp)
    80002eac:	6942                	ld	s2,16(sp)
    80002eae:	69a2                	ld	s3,8(sp)
    80002eb0:	6145                	addi	sp,sp,48
    80002eb2:	8082                	ret

0000000080002eb4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002eb4:	1101                	addi	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	e426                	sd	s1,8(sp)
    80002ebc:	e04a                	sd	s2,0(sp)
    80002ebe:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ec0:	00017517          	auipc	a0,0x17
    80002ec4:	3e050513          	addi	a0,a0,992 # 8001a2a0 <log>
    80002ec8:	04d020ef          	jal	80005714 <acquire>
  while(1){
    if(log.committing){
    80002ecc:	00017497          	auipc	s1,0x17
    80002ed0:	3d448493          	addi	s1,s1,980 # 8001a2a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002ed4:	4979                	li	s2,30
    80002ed6:	a029                	j	80002ee0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002ed8:	85a6                	mv	a1,s1
    80002eda:	8526                	mv	a0,s1
    80002edc:	c4efe0ef          	jal	8000132a <sleep>
    if(log.committing){
    80002ee0:	50dc                	lw	a5,36(s1)
    80002ee2:	fbfd                	bnez	a5,80002ed8 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002ee4:	5098                	lw	a4,32(s1)
    80002ee6:	2705                	addiw	a4,a4,1
    80002ee8:	0027179b          	slliw	a5,a4,0x2
    80002eec:	9fb9                	addw	a5,a5,a4
    80002eee:	0017979b          	slliw	a5,a5,0x1
    80002ef2:	54d4                	lw	a3,44(s1)
    80002ef4:	9fb5                	addw	a5,a5,a3
    80002ef6:	00f95763          	bge	s2,a5,80002f04 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002efa:	85a6                	mv	a1,s1
    80002efc:	8526                	mv	a0,s1
    80002efe:	c2cfe0ef          	jal	8000132a <sleep>
    80002f02:	bff9                	j	80002ee0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002f04:	00017517          	auipc	a0,0x17
    80002f08:	39c50513          	addi	a0,a0,924 # 8001a2a0 <log>
    80002f0c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002f0e:	09b020ef          	jal	800057a8 <release>
      break;
    }
  }
}
    80002f12:	60e2                	ld	ra,24(sp)
    80002f14:	6442                	ld	s0,16(sp)
    80002f16:	64a2                	ld	s1,8(sp)
    80002f18:	6902                	ld	s2,0(sp)
    80002f1a:	6105                	addi	sp,sp,32
    80002f1c:	8082                	ret

0000000080002f1e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f1e:	7139                	addi	sp,sp,-64
    80002f20:	fc06                	sd	ra,56(sp)
    80002f22:	f822                	sd	s0,48(sp)
    80002f24:	f426                	sd	s1,40(sp)
    80002f26:	f04a                	sd	s2,32(sp)
    80002f28:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f2a:	00017497          	auipc	s1,0x17
    80002f2e:	37648493          	addi	s1,s1,886 # 8001a2a0 <log>
    80002f32:	8526                	mv	a0,s1
    80002f34:	7e0020ef          	jal	80005714 <acquire>
  log.outstanding -= 1;
    80002f38:	509c                	lw	a5,32(s1)
    80002f3a:	37fd                	addiw	a5,a5,-1
    80002f3c:	893e                	mv	s2,a5
    80002f3e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002f40:	50dc                	lw	a5,36(s1)
    80002f42:	ef9d                	bnez	a5,80002f80 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80002f44:	04091863          	bnez	s2,80002f94 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002f48:	00017497          	auipc	s1,0x17
    80002f4c:	35848493          	addi	s1,s1,856 # 8001a2a0 <log>
    80002f50:	4785                	li	a5,1
    80002f52:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002f54:	8526                	mv	a0,s1
    80002f56:	053020ef          	jal	800057a8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f5a:	54dc                	lw	a5,44(s1)
    80002f5c:	04f04c63          	bgtz	a5,80002fb4 <end_op+0x96>
    acquire(&log.lock);
    80002f60:	00017497          	auipc	s1,0x17
    80002f64:	34048493          	addi	s1,s1,832 # 8001a2a0 <log>
    80002f68:	8526                	mv	a0,s1
    80002f6a:	7aa020ef          	jal	80005714 <acquire>
    log.committing = 0;
    80002f6e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002f72:	8526                	mv	a0,s1
    80002f74:	c02fe0ef          	jal	80001376 <wakeup>
    release(&log.lock);
    80002f78:	8526                	mv	a0,s1
    80002f7a:	02f020ef          	jal	800057a8 <release>
}
    80002f7e:	a02d                	j	80002fa8 <end_op+0x8a>
    80002f80:	ec4e                	sd	s3,24(sp)
    80002f82:	e852                	sd	s4,16(sp)
    80002f84:	e456                	sd	s5,8(sp)
    80002f86:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80002f88:	00004517          	auipc	a0,0x4
    80002f8c:	57850513          	addi	a0,a0,1400 # 80007500 <etext+0x500>
    80002f90:	456020ef          	jal	800053e6 <panic>
    wakeup(&log);
    80002f94:	00017497          	auipc	s1,0x17
    80002f98:	30c48493          	addi	s1,s1,780 # 8001a2a0 <log>
    80002f9c:	8526                	mv	a0,s1
    80002f9e:	bd8fe0ef          	jal	80001376 <wakeup>
  release(&log.lock);
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	005020ef          	jal	800057a8 <release>
}
    80002fa8:	70e2                	ld	ra,56(sp)
    80002faa:	7442                	ld	s0,48(sp)
    80002fac:	74a2                	ld	s1,40(sp)
    80002fae:	7902                	ld	s2,32(sp)
    80002fb0:	6121                	addi	sp,sp,64
    80002fb2:	8082                	ret
    80002fb4:	ec4e                	sd	s3,24(sp)
    80002fb6:	e852                	sd	s4,16(sp)
    80002fb8:	e456                	sd	s5,8(sp)
    80002fba:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fbc:	00017a97          	auipc	s5,0x17
    80002fc0:	314a8a93          	addi	s5,s5,788 # 8001a2d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fc4:	00017a17          	auipc	s4,0x17
    80002fc8:	2dca0a13          	addi	s4,s4,732 # 8001a2a0 <log>
    memmove(to->data, from->data, BSIZE);
    80002fcc:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fd0:	018a2583          	lw	a1,24(s4)
    80002fd4:	012585bb          	addw	a1,a1,s2
    80002fd8:	2585                	addiw	a1,a1,1
    80002fda:	028a2503          	lw	a0,40(s4)
    80002fde:	f13fe0ef          	jal	80001ef0 <bread>
    80002fe2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80002fe4:	000aa583          	lw	a1,0(s5)
    80002fe8:	028a2503          	lw	a0,40(s4)
    80002fec:	f05fe0ef          	jal	80001ef0 <bread>
    80002ff0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80002ff2:	865a                	mv	a2,s6
    80002ff4:	05850593          	addi	a1,a0,88
    80002ff8:	05848513          	addi	a0,s1,88
    80002ffc:	9b6fd0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    80003000:	8526                	mv	a0,s1
    80003002:	fc5fe0ef          	jal	80001fc6 <bwrite>
    brelse(from);
    80003006:	854e                	mv	a0,s3
    80003008:	ff1fe0ef          	jal	80001ff8 <brelse>
    brelse(to);
    8000300c:	8526                	mv	a0,s1
    8000300e:	febfe0ef          	jal	80001ff8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003012:	2905                	addiw	s2,s2,1
    80003014:	0a91                	addi	s5,s5,4
    80003016:	02ca2783          	lw	a5,44(s4)
    8000301a:	faf94be3          	blt	s2,a5,80002fd0 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000301e:	d07ff0ef          	jal	80002d24 <write_head>
    install_trans(0); // Now install writes to home locations
    80003022:	4501                	li	a0,0
    80003024:	d5fff0ef          	jal	80002d82 <install_trans>
    log.lh.n = 0;
    80003028:	00017797          	auipc	a5,0x17
    8000302c:	2a07a223          	sw	zero,676(a5) # 8001a2cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003030:	cf5ff0ef          	jal	80002d24 <write_head>
    80003034:	69e2                	ld	s3,24(sp)
    80003036:	6a42                	ld	s4,16(sp)
    80003038:	6aa2                	ld	s5,8(sp)
    8000303a:	6b02                	ld	s6,0(sp)
    8000303c:	b715                	j	80002f60 <end_op+0x42>

000000008000303e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000303e:	1101                	addi	sp,sp,-32
    80003040:	ec06                	sd	ra,24(sp)
    80003042:	e822                	sd	s0,16(sp)
    80003044:	e426                	sd	s1,8(sp)
    80003046:	e04a                	sd	s2,0(sp)
    80003048:	1000                	addi	s0,sp,32
    8000304a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000304c:	00017917          	auipc	s2,0x17
    80003050:	25490913          	addi	s2,s2,596 # 8001a2a0 <log>
    80003054:	854a                	mv	a0,s2
    80003056:	6be020ef          	jal	80005714 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000305a:	02c92603          	lw	a2,44(s2)
    8000305e:	47f5                	li	a5,29
    80003060:	06c7c363          	blt	a5,a2,800030c6 <log_write+0x88>
    80003064:	00017797          	auipc	a5,0x17
    80003068:	2587a783          	lw	a5,600(a5) # 8001a2bc <log+0x1c>
    8000306c:	37fd                	addiw	a5,a5,-1
    8000306e:	04f65c63          	bge	a2,a5,800030c6 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003072:	00017797          	auipc	a5,0x17
    80003076:	24e7a783          	lw	a5,590(a5) # 8001a2c0 <log+0x20>
    8000307a:	04f05c63          	blez	a5,800030d2 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000307e:	4781                	li	a5,0
    80003080:	04c05f63          	blez	a2,800030de <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003084:	44cc                	lw	a1,12(s1)
    80003086:	00017717          	auipc	a4,0x17
    8000308a:	24a70713          	addi	a4,a4,586 # 8001a2d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000308e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003090:	4314                	lw	a3,0(a4)
    80003092:	04b68663          	beq	a3,a1,800030de <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003096:	2785                	addiw	a5,a5,1
    80003098:	0711                	addi	a4,a4,4
    8000309a:	fef61be3          	bne	a2,a5,80003090 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000309e:	0621                	addi	a2,a2,8
    800030a0:	060a                	slli	a2,a2,0x2
    800030a2:	00017797          	auipc	a5,0x17
    800030a6:	1fe78793          	addi	a5,a5,510 # 8001a2a0 <log>
    800030aa:	97b2                	add	a5,a5,a2
    800030ac:	44d8                	lw	a4,12(s1)
    800030ae:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800030b0:	8526                	mv	a0,s1
    800030b2:	fcbfe0ef          	jal	8000207c <bpin>
    log.lh.n++;
    800030b6:	00017717          	auipc	a4,0x17
    800030ba:	1ea70713          	addi	a4,a4,490 # 8001a2a0 <log>
    800030be:	575c                	lw	a5,44(a4)
    800030c0:	2785                	addiw	a5,a5,1
    800030c2:	d75c                	sw	a5,44(a4)
    800030c4:	a80d                	j	800030f6 <log_write+0xb8>
    panic("too big a transaction");
    800030c6:	00004517          	auipc	a0,0x4
    800030ca:	44a50513          	addi	a0,a0,1098 # 80007510 <etext+0x510>
    800030ce:	318020ef          	jal	800053e6 <panic>
    panic("log_write outside of trans");
    800030d2:	00004517          	auipc	a0,0x4
    800030d6:	45650513          	addi	a0,a0,1110 # 80007528 <etext+0x528>
    800030da:	30c020ef          	jal	800053e6 <panic>
  log.lh.block[i] = b->blockno;
    800030de:	00878693          	addi	a3,a5,8
    800030e2:	068a                	slli	a3,a3,0x2
    800030e4:	00017717          	auipc	a4,0x17
    800030e8:	1bc70713          	addi	a4,a4,444 # 8001a2a0 <log>
    800030ec:	9736                	add	a4,a4,a3
    800030ee:	44d4                	lw	a3,12(s1)
    800030f0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800030f2:	faf60fe3          	beq	a2,a5,800030b0 <log_write+0x72>
  }
  release(&log.lock);
    800030f6:	00017517          	auipc	a0,0x17
    800030fa:	1aa50513          	addi	a0,a0,426 # 8001a2a0 <log>
    800030fe:	6aa020ef          	jal	800057a8 <release>
}
    80003102:	60e2                	ld	ra,24(sp)
    80003104:	6442                	ld	s0,16(sp)
    80003106:	64a2                	ld	s1,8(sp)
    80003108:	6902                	ld	s2,0(sp)
    8000310a:	6105                	addi	sp,sp,32
    8000310c:	8082                	ret

000000008000310e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000310e:	1101                	addi	sp,sp,-32
    80003110:	ec06                	sd	ra,24(sp)
    80003112:	e822                	sd	s0,16(sp)
    80003114:	e426                	sd	s1,8(sp)
    80003116:	e04a                	sd	s2,0(sp)
    80003118:	1000                	addi	s0,sp,32
    8000311a:	84aa                	mv	s1,a0
    8000311c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000311e:	00004597          	auipc	a1,0x4
    80003122:	42a58593          	addi	a1,a1,1066 # 80007548 <etext+0x548>
    80003126:	0521                	addi	a0,a0,8
    80003128:	568020ef          	jal	80005690 <initlock>
  lk->name = name;
    8000312c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003130:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003134:	0204a423          	sw	zero,40(s1)
}
    80003138:	60e2                	ld	ra,24(sp)
    8000313a:	6442                	ld	s0,16(sp)
    8000313c:	64a2                	ld	s1,8(sp)
    8000313e:	6902                	ld	s2,0(sp)
    80003140:	6105                	addi	sp,sp,32
    80003142:	8082                	ret

0000000080003144 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003144:	1101                	addi	sp,sp,-32
    80003146:	ec06                	sd	ra,24(sp)
    80003148:	e822                	sd	s0,16(sp)
    8000314a:	e426                	sd	s1,8(sp)
    8000314c:	e04a                	sd	s2,0(sp)
    8000314e:	1000                	addi	s0,sp,32
    80003150:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003152:	00850913          	addi	s2,a0,8
    80003156:	854a                	mv	a0,s2
    80003158:	5bc020ef          	jal	80005714 <acquire>
  while (lk->locked) {
    8000315c:	409c                	lw	a5,0(s1)
    8000315e:	c799                	beqz	a5,8000316c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003160:	85ca                	mv	a1,s2
    80003162:	8526                	mv	a0,s1
    80003164:	9c6fe0ef          	jal	8000132a <sleep>
  while (lk->locked) {
    80003168:	409c                	lw	a5,0(s1)
    8000316a:	fbfd                	bnez	a5,80003160 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000316c:	4785                	li	a5,1
    8000316e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003170:	bedfd0ef          	jal	80000d5c <myproc>
    80003174:	591c                	lw	a5,48(a0)
    80003176:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003178:	854a                	mv	a0,s2
    8000317a:	62e020ef          	jal	800057a8 <release>
}
    8000317e:	60e2                	ld	ra,24(sp)
    80003180:	6442                	ld	s0,16(sp)
    80003182:	64a2                	ld	s1,8(sp)
    80003184:	6902                	ld	s2,0(sp)
    80003186:	6105                	addi	sp,sp,32
    80003188:	8082                	ret

000000008000318a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	e04a                	sd	s2,0(sp)
    80003194:	1000                	addi	s0,sp,32
    80003196:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003198:	00850913          	addi	s2,a0,8
    8000319c:	854a                	mv	a0,s2
    8000319e:	576020ef          	jal	80005714 <acquire>
  lk->locked = 0;
    800031a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031a6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800031aa:	8526                	mv	a0,s1
    800031ac:	9cafe0ef          	jal	80001376 <wakeup>
  release(&lk->lk);
    800031b0:	854a                	mv	a0,s2
    800031b2:	5f6020ef          	jal	800057a8 <release>
}
    800031b6:	60e2                	ld	ra,24(sp)
    800031b8:	6442                	ld	s0,16(sp)
    800031ba:	64a2                	ld	s1,8(sp)
    800031bc:	6902                	ld	s2,0(sp)
    800031be:	6105                	addi	sp,sp,32
    800031c0:	8082                	ret

00000000800031c2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800031c2:	7179                	addi	sp,sp,-48
    800031c4:	f406                	sd	ra,40(sp)
    800031c6:	f022                	sd	s0,32(sp)
    800031c8:	ec26                	sd	s1,24(sp)
    800031ca:	e84a                	sd	s2,16(sp)
    800031cc:	1800                	addi	s0,sp,48
    800031ce:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800031d0:	00850913          	addi	s2,a0,8
    800031d4:	854a                	mv	a0,s2
    800031d6:	53e020ef          	jal	80005714 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800031da:	409c                	lw	a5,0(s1)
    800031dc:	ef81                	bnez	a5,800031f4 <holdingsleep+0x32>
    800031de:	4481                	li	s1,0
  release(&lk->lk);
    800031e0:	854a                	mv	a0,s2
    800031e2:	5c6020ef          	jal	800057a8 <release>
  return r;
}
    800031e6:	8526                	mv	a0,s1
    800031e8:	70a2                	ld	ra,40(sp)
    800031ea:	7402                	ld	s0,32(sp)
    800031ec:	64e2                	ld	s1,24(sp)
    800031ee:	6942                	ld	s2,16(sp)
    800031f0:	6145                	addi	sp,sp,48
    800031f2:	8082                	ret
    800031f4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800031f6:	0284a983          	lw	s3,40(s1)
    800031fa:	b63fd0ef          	jal	80000d5c <myproc>
    800031fe:	5904                	lw	s1,48(a0)
    80003200:	413484b3          	sub	s1,s1,s3
    80003204:	0014b493          	seqz	s1,s1
    80003208:	69a2                	ld	s3,8(sp)
    8000320a:	bfd9                	j	800031e0 <holdingsleep+0x1e>

000000008000320c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000320c:	1141                	addi	sp,sp,-16
    8000320e:	e406                	sd	ra,8(sp)
    80003210:	e022                	sd	s0,0(sp)
    80003212:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003214:	00004597          	auipc	a1,0x4
    80003218:	34458593          	addi	a1,a1,836 # 80007558 <etext+0x558>
    8000321c:	00017517          	auipc	a0,0x17
    80003220:	1cc50513          	addi	a0,a0,460 # 8001a3e8 <ftable>
    80003224:	46c020ef          	jal	80005690 <initlock>
}
    80003228:	60a2                	ld	ra,8(sp)
    8000322a:	6402                	ld	s0,0(sp)
    8000322c:	0141                	addi	sp,sp,16
    8000322e:	8082                	ret

0000000080003230 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003230:	1101                	addi	sp,sp,-32
    80003232:	ec06                	sd	ra,24(sp)
    80003234:	e822                	sd	s0,16(sp)
    80003236:	e426                	sd	s1,8(sp)
    80003238:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000323a:	00017517          	auipc	a0,0x17
    8000323e:	1ae50513          	addi	a0,a0,430 # 8001a3e8 <ftable>
    80003242:	4d2020ef          	jal	80005714 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003246:	00017497          	auipc	s1,0x17
    8000324a:	1ba48493          	addi	s1,s1,442 # 8001a400 <ftable+0x18>
    8000324e:	00018717          	auipc	a4,0x18
    80003252:	15270713          	addi	a4,a4,338 # 8001b3a0 <disk>
    if(f->ref == 0){
    80003256:	40dc                	lw	a5,4(s1)
    80003258:	cf89                	beqz	a5,80003272 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000325a:	02848493          	addi	s1,s1,40
    8000325e:	fee49ce3          	bne	s1,a4,80003256 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003262:	00017517          	auipc	a0,0x17
    80003266:	18650513          	addi	a0,a0,390 # 8001a3e8 <ftable>
    8000326a:	53e020ef          	jal	800057a8 <release>
  return 0;
    8000326e:	4481                	li	s1,0
    80003270:	a809                	j	80003282 <filealloc+0x52>
      f->ref = 1;
    80003272:	4785                	li	a5,1
    80003274:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003276:	00017517          	auipc	a0,0x17
    8000327a:	17250513          	addi	a0,a0,370 # 8001a3e8 <ftable>
    8000327e:	52a020ef          	jal	800057a8 <release>
}
    80003282:	8526                	mv	a0,s1
    80003284:	60e2                	ld	ra,24(sp)
    80003286:	6442                	ld	s0,16(sp)
    80003288:	64a2                	ld	s1,8(sp)
    8000328a:	6105                	addi	sp,sp,32
    8000328c:	8082                	ret

000000008000328e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000328e:	1101                	addi	sp,sp,-32
    80003290:	ec06                	sd	ra,24(sp)
    80003292:	e822                	sd	s0,16(sp)
    80003294:	e426                	sd	s1,8(sp)
    80003296:	1000                	addi	s0,sp,32
    80003298:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000329a:	00017517          	auipc	a0,0x17
    8000329e:	14e50513          	addi	a0,a0,334 # 8001a3e8 <ftable>
    800032a2:	472020ef          	jal	80005714 <acquire>
  if(f->ref < 1)
    800032a6:	40dc                	lw	a5,4(s1)
    800032a8:	02f05063          	blez	a5,800032c8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800032ac:	2785                	addiw	a5,a5,1
    800032ae:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800032b0:	00017517          	auipc	a0,0x17
    800032b4:	13850513          	addi	a0,a0,312 # 8001a3e8 <ftable>
    800032b8:	4f0020ef          	jal	800057a8 <release>
  return f;
}
    800032bc:	8526                	mv	a0,s1
    800032be:	60e2                	ld	ra,24(sp)
    800032c0:	6442                	ld	s0,16(sp)
    800032c2:	64a2                	ld	s1,8(sp)
    800032c4:	6105                	addi	sp,sp,32
    800032c6:	8082                	ret
    panic("filedup");
    800032c8:	00004517          	auipc	a0,0x4
    800032cc:	29850513          	addi	a0,a0,664 # 80007560 <etext+0x560>
    800032d0:	116020ef          	jal	800053e6 <panic>

00000000800032d4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800032d4:	7139                	addi	sp,sp,-64
    800032d6:	fc06                	sd	ra,56(sp)
    800032d8:	f822                	sd	s0,48(sp)
    800032da:	f426                	sd	s1,40(sp)
    800032dc:	0080                	addi	s0,sp,64
    800032de:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800032e0:	00017517          	auipc	a0,0x17
    800032e4:	10850513          	addi	a0,a0,264 # 8001a3e8 <ftable>
    800032e8:	42c020ef          	jal	80005714 <acquire>
  if(f->ref < 1)
    800032ec:	40dc                	lw	a5,4(s1)
    800032ee:	04f05863          	blez	a5,8000333e <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    800032f2:	37fd                	addiw	a5,a5,-1
    800032f4:	c0dc                	sw	a5,4(s1)
    800032f6:	04f04e63          	bgtz	a5,80003352 <fileclose+0x7e>
    800032fa:	f04a                	sd	s2,32(sp)
    800032fc:	ec4e                	sd	s3,24(sp)
    800032fe:	e852                	sd	s4,16(sp)
    80003300:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003302:	0004a903          	lw	s2,0(s1)
    80003306:	0094ca83          	lbu	s5,9(s1)
    8000330a:	0104ba03          	ld	s4,16(s1)
    8000330e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003312:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003316:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000331a:	00017517          	auipc	a0,0x17
    8000331e:	0ce50513          	addi	a0,a0,206 # 8001a3e8 <ftable>
    80003322:	486020ef          	jal	800057a8 <release>

  if(ff.type == FD_PIPE){
    80003326:	4785                	li	a5,1
    80003328:	04f90063          	beq	s2,a5,80003368 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000332c:	3979                	addiw	s2,s2,-2
    8000332e:	4785                	li	a5,1
    80003330:	0527f563          	bgeu	a5,s2,8000337a <fileclose+0xa6>
    80003334:	7902                	ld	s2,32(sp)
    80003336:	69e2                	ld	s3,24(sp)
    80003338:	6a42                	ld	s4,16(sp)
    8000333a:	6aa2                	ld	s5,8(sp)
    8000333c:	a00d                	j	8000335e <fileclose+0x8a>
    8000333e:	f04a                	sd	s2,32(sp)
    80003340:	ec4e                	sd	s3,24(sp)
    80003342:	e852                	sd	s4,16(sp)
    80003344:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003346:	00004517          	auipc	a0,0x4
    8000334a:	22250513          	addi	a0,a0,546 # 80007568 <etext+0x568>
    8000334e:	098020ef          	jal	800053e6 <panic>
    release(&ftable.lock);
    80003352:	00017517          	auipc	a0,0x17
    80003356:	09650513          	addi	a0,a0,150 # 8001a3e8 <ftable>
    8000335a:	44e020ef          	jal	800057a8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000335e:	70e2                	ld	ra,56(sp)
    80003360:	7442                	ld	s0,48(sp)
    80003362:	74a2                	ld	s1,40(sp)
    80003364:	6121                	addi	sp,sp,64
    80003366:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003368:	85d6                	mv	a1,s5
    8000336a:	8552                	mv	a0,s4
    8000336c:	340000ef          	jal	800036ac <pipeclose>
    80003370:	7902                	ld	s2,32(sp)
    80003372:	69e2                	ld	s3,24(sp)
    80003374:	6a42                	ld	s4,16(sp)
    80003376:	6aa2                	ld	s5,8(sp)
    80003378:	b7dd                	j	8000335e <fileclose+0x8a>
    begin_op();
    8000337a:	b3bff0ef          	jal	80002eb4 <begin_op>
    iput(ff.ip);
    8000337e:	854e                	mv	a0,s3
    80003380:	c04ff0ef          	jal	80002784 <iput>
    end_op();
    80003384:	b9bff0ef          	jal	80002f1e <end_op>
    80003388:	7902                	ld	s2,32(sp)
    8000338a:	69e2                	ld	s3,24(sp)
    8000338c:	6a42                	ld	s4,16(sp)
    8000338e:	6aa2                	ld	s5,8(sp)
    80003390:	b7f9                	j	8000335e <fileclose+0x8a>

0000000080003392 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003392:	715d                	addi	sp,sp,-80
    80003394:	e486                	sd	ra,72(sp)
    80003396:	e0a2                	sd	s0,64(sp)
    80003398:	fc26                	sd	s1,56(sp)
    8000339a:	f44e                	sd	s3,40(sp)
    8000339c:	0880                	addi	s0,sp,80
    8000339e:	84aa                	mv	s1,a0
    800033a0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800033a2:	9bbfd0ef          	jal	80000d5c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800033a6:	409c                	lw	a5,0(s1)
    800033a8:	37f9                	addiw	a5,a5,-2
    800033aa:	4705                	li	a4,1
    800033ac:	04f76263          	bltu	a4,a5,800033f0 <filestat+0x5e>
    800033b0:	f84a                	sd	s2,48(sp)
    800033b2:	f052                	sd	s4,32(sp)
    800033b4:	892a                	mv	s2,a0
    ilock(f->ip);
    800033b6:	6c88                	ld	a0,24(s1)
    800033b8:	a4aff0ef          	jal	80002602 <ilock>
    stati(f->ip, &st);
    800033bc:	fb840a13          	addi	s4,s0,-72
    800033c0:	85d2                	mv	a1,s4
    800033c2:	6c88                	ld	a0,24(s1)
    800033c4:	c68ff0ef          	jal	8000282c <stati>
    iunlock(f->ip);
    800033c8:	6c88                	ld	a0,24(s1)
    800033ca:	ae6ff0ef          	jal	800026b0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800033ce:	46e1                	li	a3,24
    800033d0:	8652                	mv	a2,s4
    800033d2:	85ce                	mv	a1,s3
    800033d4:	05093503          	ld	a0,80(s2)
    800033d8:	e2cfd0ef          	jal	80000a04 <copyout>
    800033dc:	41f5551b          	sraiw	a0,a0,0x1f
    800033e0:	7942                	ld	s2,48(sp)
    800033e2:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800033e4:	60a6                	ld	ra,72(sp)
    800033e6:	6406                	ld	s0,64(sp)
    800033e8:	74e2                	ld	s1,56(sp)
    800033ea:	79a2                	ld	s3,40(sp)
    800033ec:	6161                	addi	sp,sp,80
    800033ee:	8082                	ret
  return -1;
    800033f0:	557d                	li	a0,-1
    800033f2:	bfcd                	j	800033e4 <filestat+0x52>

00000000800033f4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800033f4:	7179                	addi	sp,sp,-48
    800033f6:	f406                	sd	ra,40(sp)
    800033f8:	f022                	sd	s0,32(sp)
    800033fa:	e84a                	sd	s2,16(sp)
    800033fc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800033fe:	00854783          	lbu	a5,8(a0)
    80003402:	cfd1                	beqz	a5,8000349e <fileread+0xaa>
    80003404:	ec26                	sd	s1,24(sp)
    80003406:	e44e                	sd	s3,8(sp)
    80003408:	84aa                	mv	s1,a0
    8000340a:	89ae                	mv	s3,a1
    8000340c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000340e:	411c                	lw	a5,0(a0)
    80003410:	4705                	li	a4,1
    80003412:	04e78363          	beq	a5,a4,80003458 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003416:	470d                	li	a4,3
    80003418:	04e78763          	beq	a5,a4,80003466 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000341c:	4709                	li	a4,2
    8000341e:	06e79a63          	bne	a5,a4,80003492 <fileread+0x9e>
    ilock(f->ip);
    80003422:	6d08                	ld	a0,24(a0)
    80003424:	9deff0ef          	jal	80002602 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003428:	874a                	mv	a4,s2
    8000342a:	5094                	lw	a3,32(s1)
    8000342c:	864e                	mv	a2,s3
    8000342e:	4585                	li	a1,1
    80003430:	6c88                	ld	a0,24(s1)
    80003432:	c28ff0ef          	jal	8000285a <readi>
    80003436:	892a                	mv	s2,a0
    80003438:	00a05563          	blez	a0,80003442 <fileread+0x4e>
      f->off += r;
    8000343c:	509c                	lw	a5,32(s1)
    8000343e:	9fa9                	addw	a5,a5,a0
    80003440:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003442:	6c88                	ld	a0,24(s1)
    80003444:	a6cff0ef          	jal	800026b0 <iunlock>
    80003448:	64e2                	ld	s1,24(sp)
    8000344a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000344c:	854a                	mv	a0,s2
    8000344e:	70a2                	ld	ra,40(sp)
    80003450:	7402                	ld	s0,32(sp)
    80003452:	6942                	ld	s2,16(sp)
    80003454:	6145                	addi	sp,sp,48
    80003456:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003458:	6908                	ld	a0,16(a0)
    8000345a:	3a2000ef          	jal	800037fc <piperead>
    8000345e:	892a                	mv	s2,a0
    80003460:	64e2                	ld	s1,24(sp)
    80003462:	69a2                	ld	s3,8(sp)
    80003464:	b7e5                	j	8000344c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003466:	02451783          	lh	a5,36(a0)
    8000346a:	03079693          	slli	a3,a5,0x30
    8000346e:	92c1                	srli	a3,a3,0x30
    80003470:	4725                	li	a4,9
    80003472:	02d76863          	bltu	a4,a3,800034a2 <fileread+0xae>
    80003476:	0792                	slli	a5,a5,0x4
    80003478:	00017717          	auipc	a4,0x17
    8000347c:	ed070713          	addi	a4,a4,-304 # 8001a348 <devsw>
    80003480:	97ba                	add	a5,a5,a4
    80003482:	639c                	ld	a5,0(a5)
    80003484:	c39d                	beqz	a5,800034aa <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003486:	4505                	li	a0,1
    80003488:	9782                	jalr	a5
    8000348a:	892a                	mv	s2,a0
    8000348c:	64e2                	ld	s1,24(sp)
    8000348e:	69a2                	ld	s3,8(sp)
    80003490:	bf75                	j	8000344c <fileread+0x58>
    panic("fileread");
    80003492:	00004517          	auipc	a0,0x4
    80003496:	0e650513          	addi	a0,a0,230 # 80007578 <etext+0x578>
    8000349a:	74d010ef          	jal	800053e6 <panic>
    return -1;
    8000349e:	597d                	li	s2,-1
    800034a0:	b775                	j	8000344c <fileread+0x58>
      return -1;
    800034a2:	597d                	li	s2,-1
    800034a4:	64e2                	ld	s1,24(sp)
    800034a6:	69a2                	ld	s3,8(sp)
    800034a8:	b755                	j	8000344c <fileread+0x58>
    800034aa:	597d                	li	s2,-1
    800034ac:	64e2                	ld	s1,24(sp)
    800034ae:	69a2                	ld	s3,8(sp)
    800034b0:	bf71                	j	8000344c <fileread+0x58>

00000000800034b2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800034b2:	00954783          	lbu	a5,9(a0)
    800034b6:	10078e63          	beqz	a5,800035d2 <filewrite+0x120>
{
    800034ba:	711d                	addi	sp,sp,-96
    800034bc:	ec86                	sd	ra,88(sp)
    800034be:	e8a2                	sd	s0,80(sp)
    800034c0:	e0ca                	sd	s2,64(sp)
    800034c2:	f456                	sd	s5,40(sp)
    800034c4:	f05a                	sd	s6,32(sp)
    800034c6:	1080                	addi	s0,sp,96
    800034c8:	892a                	mv	s2,a0
    800034ca:	8b2e                	mv	s6,a1
    800034cc:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800034ce:	411c                	lw	a5,0(a0)
    800034d0:	4705                	li	a4,1
    800034d2:	02e78963          	beq	a5,a4,80003504 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034d6:	470d                	li	a4,3
    800034d8:	02e78a63          	beq	a5,a4,8000350c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800034dc:	4709                	li	a4,2
    800034de:	0ce79e63          	bne	a5,a4,800035ba <filewrite+0x108>
    800034e2:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800034e4:	0ac05963          	blez	a2,80003596 <filewrite+0xe4>
    800034e8:	e4a6                	sd	s1,72(sp)
    800034ea:	fc4e                	sd	s3,56(sp)
    800034ec:	ec5e                	sd	s7,24(sp)
    800034ee:	e862                	sd	s8,16(sp)
    800034f0:	e466                	sd	s9,8(sp)
    int i = 0;
    800034f2:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800034f4:	6b85                	lui	s7,0x1
    800034f6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800034fa:	6c85                	lui	s9,0x1
    800034fc:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003500:	4c05                	li	s8,1
    80003502:	a8ad                	j	8000357c <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003504:	6908                	ld	a0,16(a0)
    80003506:	1fe000ef          	jal	80003704 <pipewrite>
    8000350a:	a04d                	j	800035ac <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000350c:	02451783          	lh	a5,36(a0)
    80003510:	03079693          	slli	a3,a5,0x30
    80003514:	92c1                	srli	a3,a3,0x30
    80003516:	4725                	li	a4,9
    80003518:	0ad76f63          	bltu	a4,a3,800035d6 <filewrite+0x124>
    8000351c:	0792                	slli	a5,a5,0x4
    8000351e:	00017717          	auipc	a4,0x17
    80003522:	e2a70713          	addi	a4,a4,-470 # 8001a348 <devsw>
    80003526:	97ba                	add	a5,a5,a4
    80003528:	679c                	ld	a5,8(a5)
    8000352a:	cbc5                	beqz	a5,800035da <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    8000352c:	4505                	li	a0,1
    8000352e:	9782                	jalr	a5
    80003530:	a8b5                	j	800035ac <filewrite+0xfa>
      if(n1 > max)
    80003532:	2981                	sext.w	s3,s3
      begin_op();
    80003534:	981ff0ef          	jal	80002eb4 <begin_op>
      ilock(f->ip);
    80003538:	01893503          	ld	a0,24(s2)
    8000353c:	8c6ff0ef          	jal	80002602 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003540:	874e                	mv	a4,s3
    80003542:	02092683          	lw	a3,32(s2)
    80003546:	016a0633          	add	a2,s4,s6
    8000354a:	85e2                	mv	a1,s8
    8000354c:	01893503          	ld	a0,24(s2)
    80003550:	bfcff0ef          	jal	8000294c <writei>
    80003554:	84aa                	mv	s1,a0
    80003556:	00a05763          	blez	a0,80003564 <filewrite+0xb2>
        f->off += r;
    8000355a:	02092783          	lw	a5,32(s2)
    8000355e:	9fa9                	addw	a5,a5,a0
    80003560:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003564:	01893503          	ld	a0,24(s2)
    80003568:	948ff0ef          	jal	800026b0 <iunlock>
      end_op();
    8000356c:	9b3ff0ef          	jal	80002f1e <end_op>

      if(r != n1){
    80003570:	02999563          	bne	s3,s1,8000359a <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    80003574:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003578:	015a5963          	bge	s4,s5,8000358a <filewrite+0xd8>
      int n1 = n - i;
    8000357c:	414a87bb          	subw	a5,s5,s4
    80003580:	89be                	mv	s3,a5
      if(n1 > max)
    80003582:	fafbd8e3          	bge	s7,a5,80003532 <filewrite+0x80>
    80003586:	89e6                	mv	s3,s9
    80003588:	b76d                	j	80003532 <filewrite+0x80>
    8000358a:	64a6                	ld	s1,72(sp)
    8000358c:	79e2                	ld	s3,56(sp)
    8000358e:	6be2                	ld	s7,24(sp)
    80003590:	6c42                	ld	s8,16(sp)
    80003592:	6ca2                	ld	s9,8(sp)
    80003594:	a801                	j	800035a4 <filewrite+0xf2>
    int i = 0;
    80003596:	4a01                	li	s4,0
    80003598:	a031                	j	800035a4 <filewrite+0xf2>
    8000359a:	64a6                	ld	s1,72(sp)
    8000359c:	79e2                	ld	s3,56(sp)
    8000359e:	6be2                	ld	s7,24(sp)
    800035a0:	6c42                	ld	s8,16(sp)
    800035a2:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800035a4:	034a9d63          	bne	s5,s4,800035de <filewrite+0x12c>
    800035a8:	8556                	mv	a0,s5
    800035aa:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800035ac:	60e6                	ld	ra,88(sp)
    800035ae:	6446                	ld	s0,80(sp)
    800035b0:	6906                	ld	s2,64(sp)
    800035b2:	7aa2                	ld	s5,40(sp)
    800035b4:	7b02                	ld	s6,32(sp)
    800035b6:	6125                	addi	sp,sp,96
    800035b8:	8082                	ret
    800035ba:	e4a6                	sd	s1,72(sp)
    800035bc:	fc4e                	sd	s3,56(sp)
    800035be:	f852                	sd	s4,48(sp)
    800035c0:	ec5e                	sd	s7,24(sp)
    800035c2:	e862                	sd	s8,16(sp)
    800035c4:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800035c6:	00004517          	auipc	a0,0x4
    800035ca:	fc250513          	addi	a0,a0,-62 # 80007588 <etext+0x588>
    800035ce:	619010ef          	jal	800053e6 <panic>
    return -1;
    800035d2:	557d                	li	a0,-1
}
    800035d4:	8082                	ret
      return -1;
    800035d6:	557d                	li	a0,-1
    800035d8:	bfd1                	j	800035ac <filewrite+0xfa>
    800035da:	557d                	li	a0,-1
    800035dc:	bfc1                	j	800035ac <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800035de:	557d                	li	a0,-1
    800035e0:	7a42                	ld	s4,48(sp)
    800035e2:	b7e9                	j	800035ac <filewrite+0xfa>

00000000800035e4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800035e4:	7179                	addi	sp,sp,-48
    800035e6:	f406                	sd	ra,40(sp)
    800035e8:	f022                	sd	s0,32(sp)
    800035ea:	ec26                	sd	s1,24(sp)
    800035ec:	e052                	sd	s4,0(sp)
    800035ee:	1800                	addi	s0,sp,48
    800035f0:	84aa                	mv	s1,a0
    800035f2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800035f4:	0005b023          	sd	zero,0(a1)
    800035f8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800035fc:	c35ff0ef          	jal	80003230 <filealloc>
    80003600:	e088                	sd	a0,0(s1)
    80003602:	c549                	beqz	a0,8000368c <pipealloc+0xa8>
    80003604:	c2dff0ef          	jal	80003230 <filealloc>
    80003608:	00aa3023          	sd	a0,0(s4)
    8000360c:	cd25                	beqz	a0,80003684 <pipealloc+0xa0>
    8000360e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003610:	aeffc0ef          	jal	800000fe <kalloc>
    80003614:	892a                	mv	s2,a0
    80003616:	c12d                	beqz	a0,80003678 <pipealloc+0x94>
    80003618:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000361a:	4985                	li	s3,1
    8000361c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003620:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003624:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003628:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000362c:	00004597          	auipc	a1,0x4
    80003630:	f6c58593          	addi	a1,a1,-148 # 80007598 <etext+0x598>
    80003634:	05c020ef          	jal	80005690 <initlock>
  (*f0)->type = FD_PIPE;
    80003638:	609c                	ld	a5,0(s1)
    8000363a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000363e:	609c                	ld	a5,0(s1)
    80003640:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003644:	609c                	ld	a5,0(s1)
    80003646:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000364a:	609c                	ld	a5,0(s1)
    8000364c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003650:	000a3783          	ld	a5,0(s4)
    80003654:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003658:	000a3783          	ld	a5,0(s4)
    8000365c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003660:	000a3783          	ld	a5,0(s4)
    80003664:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003668:	000a3783          	ld	a5,0(s4)
    8000366c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003670:	4501                	li	a0,0
    80003672:	6942                	ld	s2,16(sp)
    80003674:	69a2                	ld	s3,8(sp)
    80003676:	a01d                	j	8000369c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003678:	6088                	ld	a0,0(s1)
    8000367a:	c119                	beqz	a0,80003680 <pipealloc+0x9c>
    8000367c:	6942                	ld	s2,16(sp)
    8000367e:	a029                	j	80003688 <pipealloc+0xa4>
    80003680:	6942                	ld	s2,16(sp)
    80003682:	a029                	j	8000368c <pipealloc+0xa8>
    80003684:	6088                	ld	a0,0(s1)
    80003686:	c10d                	beqz	a0,800036a8 <pipealloc+0xc4>
    fileclose(*f0);
    80003688:	c4dff0ef          	jal	800032d4 <fileclose>
  if(*f1)
    8000368c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003690:	557d                	li	a0,-1
  if(*f1)
    80003692:	c789                	beqz	a5,8000369c <pipealloc+0xb8>
    fileclose(*f1);
    80003694:	853e                	mv	a0,a5
    80003696:	c3fff0ef          	jal	800032d4 <fileclose>
  return -1;
    8000369a:	557d                	li	a0,-1
}
    8000369c:	70a2                	ld	ra,40(sp)
    8000369e:	7402                	ld	s0,32(sp)
    800036a0:	64e2                	ld	s1,24(sp)
    800036a2:	6a02                	ld	s4,0(sp)
    800036a4:	6145                	addi	sp,sp,48
    800036a6:	8082                	ret
  return -1;
    800036a8:	557d                	li	a0,-1
    800036aa:	bfcd                	j	8000369c <pipealloc+0xb8>

00000000800036ac <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800036ac:	1101                	addi	sp,sp,-32
    800036ae:	ec06                	sd	ra,24(sp)
    800036b0:	e822                	sd	s0,16(sp)
    800036b2:	e426                	sd	s1,8(sp)
    800036b4:	e04a                	sd	s2,0(sp)
    800036b6:	1000                	addi	s0,sp,32
    800036b8:	84aa                	mv	s1,a0
    800036ba:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800036bc:	058020ef          	jal	80005714 <acquire>
  if(writable){
    800036c0:	02090763          	beqz	s2,800036ee <pipeclose+0x42>
    pi->writeopen = 0;
    800036c4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800036c8:	21848513          	addi	a0,s1,536
    800036cc:	cabfd0ef          	jal	80001376 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800036d0:	2204b783          	ld	a5,544(s1)
    800036d4:	e785                	bnez	a5,800036fc <pipeclose+0x50>
    release(&pi->lock);
    800036d6:	8526                	mv	a0,s1
    800036d8:	0d0020ef          	jal	800057a8 <release>
    kfree((char*)pi);
    800036dc:	8526                	mv	a0,s1
    800036de:	93ffc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800036e2:	60e2                	ld	ra,24(sp)
    800036e4:	6442                	ld	s0,16(sp)
    800036e6:	64a2                	ld	s1,8(sp)
    800036e8:	6902                	ld	s2,0(sp)
    800036ea:	6105                	addi	sp,sp,32
    800036ec:	8082                	ret
    pi->readopen = 0;
    800036ee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800036f2:	21c48513          	addi	a0,s1,540
    800036f6:	c81fd0ef          	jal	80001376 <wakeup>
    800036fa:	bfd9                	j	800036d0 <pipeclose+0x24>
    release(&pi->lock);
    800036fc:	8526                	mv	a0,s1
    800036fe:	0aa020ef          	jal	800057a8 <release>
}
    80003702:	b7c5                	j	800036e2 <pipeclose+0x36>

0000000080003704 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003704:	7159                	addi	sp,sp,-112
    80003706:	f486                	sd	ra,104(sp)
    80003708:	f0a2                	sd	s0,96(sp)
    8000370a:	eca6                	sd	s1,88(sp)
    8000370c:	e8ca                	sd	s2,80(sp)
    8000370e:	e4ce                	sd	s3,72(sp)
    80003710:	e0d2                	sd	s4,64(sp)
    80003712:	fc56                	sd	s5,56(sp)
    80003714:	1880                	addi	s0,sp,112
    80003716:	84aa                	mv	s1,a0
    80003718:	8aae                	mv	s5,a1
    8000371a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000371c:	e40fd0ef          	jal	80000d5c <myproc>
    80003720:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003722:	8526                	mv	a0,s1
    80003724:	7f1010ef          	jal	80005714 <acquire>
  while(i < n){
    80003728:	0d405263          	blez	s4,800037ec <pipewrite+0xe8>
    8000372c:	f85a                	sd	s6,48(sp)
    8000372e:	f45e                	sd	s7,40(sp)
    80003730:	f062                	sd	s8,32(sp)
    80003732:	ec66                	sd	s9,24(sp)
    80003734:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003736:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003738:	f9f40c13          	addi	s8,s0,-97
    8000373c:	4b85                	li	s7,1
    8000373e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003740:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003744:	21c48c93          	addi	s9,s1,540
    80003748:	a82d                	j	80003782 <pipewrite+0x7e>
      release(&pi->lock);
    8000374a:	8526                	mv	a0,s1
    8000374c:	05c020ef          	jal	800057a8 <release>
      return -1;
    80003750:	597d                	li	s2,-1
    80003752:	7b42                	ld	s6,48(sp)
    80003754:	7ba2                	ld	s7,40(sp)
    80003756:	7c02                	ld	s8,32(sp)
    80003758:	6ce2                	ld	s9,24(sp)
    8000375a:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000375c:	854a                	mv	a0,s2
    8000375e:	70a6                	ld	ra,104(sp)
    80003760:	7406                	ld	s0,96(sp)
    80003762:	64e6                	ld	s1,88(sp)
    80003764:	6946                	ld	s2,80(sp)
    80003766:	69a6                	ld	s3,72(sp)
    80003768:	6a06                	ld	s4,64(sp)
    8000376a:	7ae2                	ld	s5,56(sp)
    8000376c:	6165                	addi	sp,sp,112
    8000376e:	8082                	ret
      wakeup(&pi->nread);
    80003770:	856a                	mv	a0,s10
    80003772:	c05fd0ef          	jal	80001376 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003776:	85a6                	mv	a1,s1
    80003778:	8566                	mv	a0,s9
    8000377a:	bb1fd0ef          	jal	8000132a <sleep>
  while(i < n){
    8000377e:	05495a63          	bge	s2,s4,800037d2 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003782:	2204a783          	lw	a5,544(s1)
    80003786:	d3f1                	beqz	a5,8000374a <pipewrite+0x46>
    80003788:	854e                	mv	a0,s3
    8000378a:	dd9fd0ef          	jal	80001562 <killed>
    8000378e:	fd55                	bnez	a0,8000374a <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003790:	2184a783          	lw	a5,536(s1)
    80003794:	21c4a703          	lw	a4,540(s1)
    80003798:	2007879b          	addiw	a5,a5,512
    8000379c:	fcf70ae3          	beq	a4,a5,80003770 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037a0:	86de                	mv	a3,s7
    800037a2:	01590633          	add	a2,s2,s5
    800037a6:	85e2                	mv	a1,s8
    800037a8:	0509b503          	ld	a0,80(s3)
    800037ac:	b08fd0ef          	jal	80000ab4 <copyin>
    800037b0:	05650063          	beq	a0,s6,800037f0 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800037b4:	21c4a783          	lw	a5,540(s1)
    800037b8:	0017871b          	addiw	a4,a5,1
    800037bc:	20e4ae23          	sw	a4,540(s1)
    800037c0:	1ff7f793          	andi	a5,a5,511
    800037c4:	97a6                	add	a5,a5,s1
    800037c6:	f9f44703          	lbu	a4,-97(s0)
    800037ca:	00e78c23          	sb	a4,24(a5)
      i++;
    800037ce:	2905                	addiw	s2,s2,1
    800037d0:	b77d                	j	8000377e <pipewrite+0x7a>
    800037d2:	7b42                	ld	s6,48(sp)
    800037d4:	7ba2                	ld	s7,40(sp)
    800037d6:	7c02                	ld	s8,32(sp)
    800037d8:	6ce2                	ld	s9,24(sp)
    800037da:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800037dc:	21848513          	addi	a0,s1,536
    800037e0:	b97fd0ef          	jal	80001376 <wakeup>
  release(&pi->lock);
    800037e4:	8526                	mv	a0,s1
    800037e6:	7c3010ef          	jal	800057a8 <release>
  return i;
    800037ea:	bf8d                	j	8000375c <pipewrite+0x58>
  int i = 0;
    800037ec:	4901                	li	s2,0
    800037ee:	b7fd                	j	800037dc <pipewrite+0xd8>
    800037f0:	7b42                	ld	s6,48(sp)
    800037f2:	7ba2                	ld	s7,40(sp)
    800037f4:	7c02                	ld	s8,32(sp)
    800037f6:	6ce2                	ld	s9,24(sp)
    800037f8:	6d42                	ld	s10,16(sp)
    800037fa:	b7cd                	j	800037dc <pipewrite+0xd8>

00000000800037fc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800037fc:	711d                	addi	sp,sp,-96
    800037fe:	ec86                	sd	ra,88(sp)
    80003800:	e8a2                	sd	s0,80(sp)
    80003802:	e4a6                	sd	s1,72(sp)
    80003804:	e0ca                	sd	s2,64(sp)
    80003806:	fc4e                	sd	s3,56(sp)
    80003808:	f852                	sd	s4,48(sp)
    8000380a:	f456                	sd	s5,40(sp)
    8000380c:	1080                	addi	s0,sp,96
    8000380e:	84aa                	mv	s1,a0
    80003810:	892e                	mv	s2,a1
    80003812:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003814:	d48fd0ef          	jal	80000d5c <myproc>
    80003818:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000381a:	8526                	mv	a0,s1
    8000381c:	6f9010ef          	jal	80005714 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003820:	2184a703          	lw	a4,536(s1)
    80003824:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003828:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000382c:	02f71763          	bne	a4,a5,8000385a <piperead+0x5e>
    80003830:	2244a783          	lw	a5,548(s1)
    80003834:	cf85                	beqz	a5,8000386c <piperead+0x70>
    if(killed(pr)){
    80003836:	8552                	mv	a0,s4
    80003838:	d2bfd0ef          	jal	80001562 <killed>
    8000383c:	e11d                	bnez	a0,80003862 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000383e:	85a6                	mv	a1,s1
    80003840:	854e                	mv	a0,s3
    80003842:	ae9fd0ef          	jal	8000132a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003846:	2184a703          	lw	a4,536(s1)
    8000384a:	21c4a783          	lw	a5,540(s1)
    8000384e:	fef701e3          	beq	a4,a5,80003830 <piperead+0x34>
    80003852:	f05a                	sd	s6,32(sp)
    80003854:	ec5e                	sd	s7,24(sp)
    80003856:	e862                	sd	s8,16(sp)
    80003858:	a829                	j	80003872 <piperead+0x76>
    8000385a:	f05a                	sd	s6,32(sp)
    8000385c:	ec5e                	sd	s7,24(sp)
    8000385e:	e862                	sd	s8,16(sp)
    80003860:	a809                	j	80003872 <piperead+0x76>
      release(&pi->lock);
    80003862:	8526                	mv	a0,s1
    80003864:	745010ef          	jal	800057a8 <release>
      return -1;
    80003868:	59fd                	li	s3,-1
    8000386a:	a0a5                	j	800038d2 <piperead+0xd6>
    8000386c:	f05a                	sd	s6,32(sp)
    8000386e:	ec5e                	sd	s7,24(sp)
    80003870:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003872:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003874:	faf40c13          	addi	s8,s0,-81
    80003878:	4b85                	li	s7,1
    8000387a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000387c:	05505163          	blez	s5,800038be <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80003880:	2184a783          	lw	a5,536(s1)
    80003884:	21c4a703          	lw	a4,540(s1)
    80003888:	02f70b63          	beq	a4,a5,800038be <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000388c:	0017871b          	addiw	a4,a5,1
    80003890:	20e4ac23          	sw	a4,536(s1)
    80003894:	1ff7f793          	andi	a5,a5,511
    80003898:	97a6                	add	a5,a5,s1
    8000389a:	0187c783          	lbu	a5,24(a5)
    8000389e:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800038a2:	86de                	mv	a3,s7
    800038a4:	8662                	mv	a2,s8
    800038a6:	85ca                	mv	a1,s2
    800038a8:	050a3503          	ld	a0,80(s4)
    800038ac:	958fd0ef          	jal	80000a04 <copyout>
    800038b0:	01650763          	beq	a0,s6,800038be <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038b4:	2985                	addiw	s3,s3,1
    800038b6:	0905                	addi	s2,s2,1
    800038b8:	fd3a94e3          	bne	s5,s3,80003880 <piperead+0x84>
    800038bc:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800038be:	21c48513          	addi	a0,s1,540
    800038c2:	ab5fd0ef          	jal	80001376 <wakeup>
  release(&pi->lock);
    800038c6:	8526                	mv	a0,s1
    800038c8:	6e1010ef          	jal	800057a8 <release>
    800038cc:	7b02                	ld	s6,32(sp)
    800038ce:	6be2                	ld	s7,24(sp)
    800038d0:	6c42                	ld	s8,16(sp)
  return i;
}
    800038d2:	854e                	mv	a0,s3
    800038d4:	60e6                	ld	ra,88(sp)
    800038d6:	6446                	ld	s0,80(sp)
    800038d8:	64a6                	ld	s1,72(sp)
    800038da:	6906                	ld	s2,64(sp)
    800038dc:	79e2                	ld	s3,56(sp)
    800038de:	7a42                	ld	s4,48(sp)
    800038e0:	7aa2                	ld	s5,40(sp)
    800038e2:	6125                	addi	sp,sp,96
    800038e4:	8082                	ret

00000000800038e6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800038e6:	1141                	addi	sp,sp,-16
    800038e8:	e406                	sd	ra,8(sp)
    800038ea:	e022                	sd	s0,0(sp)
    800038ec:	0800                	addi	s0,sp,16
    800038ee:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800038f0:	0035151b          	slliw	a0,a0,0x3
    800038f4:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800038f6:	8b89                	andi	a5,a5,2
    800038f8:	c399                	beqz	a5,800038fe <flags2perm+0x18>
      perm |= PTE_W;
    800038fa:	00456513          	ori	a0,a0,4
    return perm;
}
    800038fe:	60a2                	ld	ra,8(sp)
    80003900:	6402                	ld	s0,0(sp)
    80003902:	0141                	addi	sp,sp,16
    80003904:	8082                	ret

0000000080003906 <exec>:

int
exec(char *path, char **argv)
{
    80003906:	de010113          	addi	sp,sp,-544
    8000390a:	20113c23          	sd	ra,536(sp)
    8000390e:	20813823          	sd	s0,528(sp)
    80003912:	20913423          	sd	s1,520(sp)
    80003916:	21213023          	sd	s2,512(sp)
    8000391a:	1400                	addi	s0,sp,544
    8000391c:	892a                	mv	s2,a0
    8000391e:	dea43823          	sd	a0,-528(s0)
    80003922:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003926:	c36fd0ef          	jal	80000d5c <myproc>
    8000392a:	84aa                	mv	s1,a0

  begin_op();
    8000392c:	d88ff0ef          	jal	80002eb4 <begin_op>

  if((ip = namei(path)) == 0){
    80003930:	854a                	mv	a0,s2
    80003932:	bc0ff0ef          	jal	80002cf2 <namei>
    80003936:	cd21                	beqz	a0,8000398e <exec+0x88>
    80003938:	fbd2                	sd	s4,496(sp)
    8000393a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000393c:	cc7fe0ef          	jal	80002602 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003940:	04000713          	li	a4,64
    80003944:	4681                	li	a3,0
    80003946:	e5040613          	addi	a2,s0,-432
    8000394a:	4581                	li	a1,0
    8000394c:	8552                	mv	a0,s4
    8000394e:	f0dfe0ef          	jal	8000285a <readi>
    80003952:	04000793          	li	a5,64
    80003956:	00f51a63          	bne	a0,a5,8000396a <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000395a:	e5042703          	lw	a4,-432(s0)
    8000395e:	464c47b7          	lui	a5,0x464c4
    80003962:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003966:	02f70863          	beq	a4,a5,80003996 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000396a:	8552                	mv	a0,s4
    8000396c:	ea1fe0ef          	jal	8000280c <iunlockput>
    end_op();
    80003970:	daeff0ef          	jal	80002f1e <end_op>
  }
  return -1;
    80003974:	557d                	li	a0,-1
    80003976:	7a5e                	ld	s4,496(sp)
}
    80003978:	21813083          	ld	ra,536(sp)
    8000397c:	21013403          	ld	s0,528(sp)
    80003980:	20813483          	ld	s1,520(sp)
    80003984:	20013903          	ld	s2,512(sp)
    80003988:	22010113          	addi	sp,sp,544
    8000398c:	8082                	ret
    end_op();
    8000398e:	d90ff0ef          	jal	80002f1e <end_op>
    return -1;
    80003992:	557d                	li	a0,-1
    80003994:	b7d5                	j	80003978 <exec+0x72>
    80003996:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003998:	8526                	mv	a0,s1
    8000399a:	c6afd0ef          	jal	80000e04 <proc_pagetable>
    8000399e:	8b2a                	mv	s6,a0
    800039a0:	26050d63          	beqz	a0,80003c1a <exec+0x314>
    800039a4:	ffce                	sd	s3,504(sp)
    800039a6:	f7d6                	sd	s5,488(sp)
    800039a8:	efde                	sd	s7,472(sp)
    800039aa:	ebe2                	sd	s8,464(sp)
    800039ac:	e7e6                	sd	s9,456(sp)
    800039ae:	e3ea                	sd	s10,448(sp)
    800039b0:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039b2:	e7042683          	lw	a3,-400(s0)
    800039b6:	e8845783          	lhu	a5,-376(s0)
    800039ba:	0e078763          	beqz	a5,80003aa8 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800039be:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039c0:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800039c2:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800039c6:	6c85                	lui	s9,0x1
    800039c8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800039cc:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800039d0:	6a85                	lui	s5,0x1
    800039d2:	a085                	j	80003a32 <exec+0x12c>
      panic("loadseg: address should exist");
    800039d4:	00004517          	auipc	a0,0x4
    800039d8:	bcc50513          	addi	a0,a0,-1076 # 800075a0 <etext+0x5a0>
    800039dc:	20b010ef          	jal	800053e6 <panic>
    if(sz - i < PGSIZE)
    800039e0:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800039e2:	874a                	mv	a4,s2
    800039e4:	009c06bb          	addw	a3,s8,s1
    800039e8:	4581                	li	a1,0
    800039ea:	8552                	mv	a0,s4
    800039ec:	e6ffe0ef          	jal	8000285a <readi>
    800039f0:	22a91963          	bne	s2,a0,80003c22 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    800039f4:	009a84bb          	addw	s1,s5,s1
    800039f8:	0334f263          	bgeu	s1,s3,80003a1c <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    800039fc:	02049593          	slli	a1,s1,0x20
    80003a00:	9181                	srli	a1,a1,0x20
    80003a02:	95de                	add	a1,a1,s7
    80003a04:	855a                	mv	a0,s6
    80003a06:	a77fc0ef          	jal	8000047c <walkaddr>
    80003a0a:	862a                	mv	a2,a0
    if(pa == 0)
    80003a0c:	d561                	beqz	a0,800039d4 <exec+0xce>
    if(sz - i < PGSIZE)
    80003a0e:	409987bb          	subw	a5,s3,s1
    80003a12:	893e                	mv	s2,a5
    80003a14:	fcfcf6e3          	bgeu	s9,a5,800039e0 <exec+0xda>
    80003a18:	8956                	mv	s2,s5
    80003a1a:	b7d9                	j	800039e0 <exec+0xda>
    sz = sz1;
    80003a1c:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a20:	2d05                	addiw	s10,s10,1
    80003a22:	e0843783          	ld	a5,-504(s0)
    80003a26:	0387869b          	addiw	a3,a5,56
    80003a2a:	e8845783          	lhu	a5,-376(s0)
    80003a2e:	06fd5e63          	bge	s10,a5,80003aaa <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003a32:	e0d43423          	sd	a3,-504(s0)
    80003a36:	876e                	mv	a4,s11
    80003a38:	e1840613          	addi	a2,s0,-488
    80003a3c:	4581                	li	a1,0
    80003a3e:	8552                	mv	a0,s4
    80003a40:	e1bfe0ef          	jal	8000285a <readi>
    80003a44:	1db51d63          	bne	a0,s11,80003c1e <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003a48:	e1842783          	lw	a5,-488(s0)
    80003a4c:	4705                	li	a4,1
    80003a4e:	fce799e3          	bne	a5,a4,80003a20 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003a52:	e4043483          	ld	s1,-448(s0)
    80003a56:	e3843783          	ld	a5,-456(s0)
    80003a5a:	1ef4e263          	bltu	s1,a5,80003c3e <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003a5e:	e2843783          	ld	a5,-472(s0)
    80003a62:	94be                	add	s1,s1,a5
    80003a64:	1ef4e063          	bltu	s1,a5,80003c44 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003a68:	de843703          	ld	a4,-536(s0)
    80003a6c:	8ff9                	and	a5,a5,a4
    80003a6e:	1c079e63          	bnez	a5,80003c4a <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003a72:	e1c42503          	lw	a0,-484(s0)
    80003a76:	e71ff0ef          	jal	800038e6 <flags2perm>
    80003a7a:	86aa                	mv	a3,a0
    80003a7c:	8626                	mv	a2,s1
    80003a7e:	85ca                	mv	a1,s2
    80003a80:	855a                	mv	a0,s6
    80003a82:	d63fc0ef          	jal	800007e4 <uvmalloc>
    80003a86:	dea43c23          	sd	a0,-520(s0)
    80003a8a:	1c050363          	beqz	a0,80003c50 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003a8e:	e2843b83          	ld	s7,-472(s0)
    80003a92:	e2042c03          	lw	s8,-480(s0)
    80003a96:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003a9a:	00098463          	beqz	s3,80003aa2 <exec+0x19c>
    80003a9e:	4481                	li	s1,0
    80003aa0:	bfb1                	j	800039fc <exec+0xf6>
    sz = sz1;
    80003aa2:	df843903          	ld	s2,-520(s0)
    80003aa6:	bfad                	j	80003a20 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003aa8:	4901                	li	s2,0
  iunlockput(ip);
    80003aaa:	8552                	mv	a0,s4
    80003aac:	d61fe0ef          	jal	8000280c <iunlockput>
  end_op();
    80003ab0:	c6eff0ef          	jal	80002f1e <end_op>
  p = myproc();
    80003ab4:	aa8fd0ef          	jal	80000d5c <myproc>
    80003ab8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003aba:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003abe:	6985                	lui	s3,0x1
    80003ac0:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003ac2:	99ca                	add	s3,s3,s2
    80003ac4:	77fd                	lui	a5,0xfffff
    80003ac6:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003aca:	4691                	li	a3,4
    80003acc:	660d                	lui	a2,0x3
    80003ace:	964e                	add	a2,a2,s3
    80003ad0:	85ce                	mv	a1,s3
    80003ad2:	855a                	mv	a0,s6
    80003ad4:	d11fc0ef          	jal	800007e4 <uvmalloc>
    80003ad8:	8a2a                	mv	s4,a0
    80003ada:	e105                	bnez	a0,80003afa <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003adc:	85ce                	mv	a1,s3
    80003ade:	855a                	mv	a0,s6
    80003ae0:	ba8fd0ef          	jal	80000e88 <proc_freepagetable>
  return -1;
    80003ae4:	557d                	li	a0,-1
    80003ae6:	79fe                	ld	s3,504(sp)
    80003ae8:	7a5e                	ld	s4,496(sp)
    80003aea:	7abe                	ld	s5,488(sp)
    80003aec:	7b1e                	ld	s6,480(sp)
    80003aee:	6bfe                	ld	s7,472(sp)
    80003af0:	6c5e                	ld	s8,464(sp)
    80003af2:	6cbe                	ld	s9,456(sp)
    80003af4:	6d1e                	ld	s10,448(sp)
    80003af6:	7dfa                	ld	s11,440(sp)
    80003af8:	b541                	j	80003978 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003afa:	75f5                	lui	a1,0xffffd
    80003afc:	95aa                	add	a1,a1,a0
    80003afe:	855a                	mv	a0,s6
    80003b00:	edbfc0ef          	jal	800009da <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003b04:	7bf9                	lui	s7,0xffffe
    80003b06:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b08:	e0043783          	ld	a5,-512(s0)
    80003b0c:	6388                	ld	a0,0(a5)
  sp = sz;
    80003b0e:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b10:	4481                	li	s1,0
    ustack[argc] = sp;
    80003b12:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003b16:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003b1a:	cd21                	beqz	a0,80003b72 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003b1c:	fbafc0ef          	jal	800002d6 <strlen>
    80003b20:	0015079b          	addiw	a5,a0,1
    80003b24:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b28:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003b2c:	13796563          	bltu	s2,s7,80003c56 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b30:	e0043d83          	ld	s11,-512(s0)
    80003b34:	000db983          	ld	s3,0(s11)
    80003b38:	854e                	mv	a0,s3
    80003b3a:	f9cfc0ef          	jal	800002d6 <strlen>
    80003b3e:	0015069b          	addiw	a3,a0,1
    80003b42:	864e                	mv	a2,s3
    80003b44:	85ca                	mv	a1,s2
    80003b46:	855a                	mv	a0,s6
    80003b48:	ebdfc0ef          	jal	80000a04 <copyout>
    80003b4c:	10054763          	bltz	a0,80003c5a <exec+0x354>
    ustack[argc] = sp;
    80003b50:	00349793          	slli	a5,s1,0x3
    80003b54:	97e6                	add	a5,a5,s9
    80003b56:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdba20>
  for(argc = 0; argv[argc]; argc++) {
    80003b5a:	0485                	addi	s1,s1,1
    80003b5c:	008d8793          	addi	a5,s11,8
    80003b60:	e0f43023          	sd	a5,-512(s0)
    80003b64:	008db503          	ld	a0,8(s11)
    80003b68:	c509                	beqz	a0,80003b72 <exec+0x26c>
    if(argc >= MAXARG)
    80003b6a:	fb8499e3          	bne	s1,s8,80003b1c <exec+0x216>
  sz = sz1;
    80003b6e:	89d2                	mv	s3,s4
    80003b70:	b7b5                	j	80003adc <exec+0x1d6>
  ustack[argc] = 0;
    80003b72:	00349793          	slli	a5,s1,0x3
    80003b76:	f9078793          	addi	a5,a5,-112
    80003b7a:	97a2                	add	a5,a5,s0
    80003b7c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003b80:	00148693          	addi	a3,s1,1
    80003b84:	068e                	slli	a3,a3,0x3
    80003b86:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b8a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003b8e:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003b90:	f57966e3          	bltu	s2,s7,80003adc <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003b94:	e9040613          	addi	a2,s0,-368
    80003b98:	85ca                	mv	a1,s2
    80003b9a:	855a                	mv	a0,s6
    80003b9c:	e69fc0ef          	jal	80000a04 <copyout>
    80003ba0:	f2054ee3          	bltz	a0,80003adc <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003ba4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003ba8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003bac:	df043783          	ld	a5,-528(s0)
    80003bb0:	0007c703          	lbu	a4,0(a5)
    80003bb4:	cf11                	beqz	a4,80003bd0 <exec+0x2ca>
    80003bb6:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003bb8:	02f00693          	li	a3,47
    80003bbc:	a029                	j	80003bc6 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003bbe:	0785                	addi	a5,a5,1
    80003bc0:	fff7c703          	lbu	a4,-1(a5)
    80003bc4:	c711                	beqz	a4,80003bd0 <exec+0x2ca>
    if(*s == '/')
    80003bc6:	fed71ce3          	bne	a4,a3,80003bbe <exec+0x2b8>
      last = s+1;
    80003bca:	def43823          	sd	a5,-528(s0)
    80003bce:	bfc5                	j	80003bbe <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003bd0:	4641                	li	a2,16
    80003bd2:	df043583          	ld	a1,-528(s0)
    80003bd6:	158a8513          	addi	a0,s5,344
    80003bda:	ec6fc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003bde:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003be2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003be6:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003bea:	058ab783          	ld	a5,88(s5)
    80003bee:	e6843703          	ld	a4,-408(s0)
    80003bf2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003bf4:	058ab783          	ld	a5,88(s5)
    80003bf8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003bfc:	85ea                	mv	a1,s10
    80003bfe:	a8afd0ef          	jal	80000e88 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003c02:	0004851b          	sext.w	a0,s1
    80003c06:	79fe                	ld	s3,504(sp)
    80003c08:	7a5e                	ld	s4,496(sp)
    80003c0a:	7abe                	ld	s5,488(sp)
    80003c0c:	7b1e                	ld	s6,480(sp)
    80003c0e:	6bfe                	ld	s7,472(sp)
    80003c10:	6c5e                	ld	s8,464(sp)
    80003c12:	6cbe                	ld	s9,456(sp)
    80003c14:	6d1e                	ld	s10,448(sp)
    80003c16:	7dfa                	ld	s11,440(sp)
    80003c18:	b385                	j	80003978 <exec+0x72>
    80003c1a:	7b1e                	ld	s6,480(sp)
    80003c1c:	b3b9                	j	8000396a <exec+0x64>
    80003c1e:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003c22:	df843583          	ld	a1,-520(s0)
    80003c26:	855a                	mv	a0,s6
    80003c28:	a60fd0ef          	jal	80000e88 <proc_freepagetable>
  if(ip){
    80003c2c:	79fe                	ld	s3,504(sp)
    80003c2e:	7abe                	ld	s5,488(sp)
    80003c30:	7b1e                	ld	s6,480(sp)
    80003c32:	6bfe                	ld	s7,472(sp)
    80003c34:	6c5e                	ld	s8,464(sp)
    80003c36:	6cbe                	ld	s9,456(sp)
    80003c38:	6d1e                	ld	s10,448(sp)
    80003c3a:	7dfa                	ld	s11,440(sp)
    80003c3c:	b33d                	j	8000396a <exec+0x64>
    80003c3e:	df243c23          	sd	s2,-520(s0)
    80003c42:	b7c5                	j	80003c22 <exec+0x31c>
    80003c44:	df243c23          	sd	s2,-520(s0)
    80003c48:	bfe9                	j	80003c22 <exec+0x31c>
    80003c4a:	df243c23          	sd	s2,-520(s0)
    80003c4e:	bfd1                	j	80003c22 <exec+0x31c>
    80003c50:	df243c23          	sd	s2,-520(s0)
    80003c54:	b7f9                	j	80003c22 <exec+0x31c>
  sz = sz1;
    80003c56:	89d2                	mv	s3,s4
    80003c58:	b551                	j	80003adc <exec+0x1d6>
    80003c5a:	89d2                	mv	s3,s4
    80003c5c:	b541                	j	80003adc <exec+0x1d6>

0000000080003c5e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003c5e:	7179                	addi	sp,sp,-48
    80003c60:	f406                	sd	ra,40(sp)
    80003c62:	f022                	sd	s0,32(sp)
    80003c64:	ec26                	sd	s1,24(sp)
    80003c66:	e84a                	sd	s2,16(sp)
    80003c68:	1800                	addi	s0,sp,48
    80003c6a:	892e                	mv	s2,a1
    80003c6c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003c6e:	fdc40593          	addi	a1,s0,-36
    80003c72:	f9dfd0ef          	jal	80001c0e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003c76:	fdc42703          	lw	a4,-36(s0)
    80003c7a:	47bd                	li	a5,15
    80003c7c:	02e7e963          	bltu	a5,a4,80003cae <argfd+0x50>
    80003c80:	8dcfd0ef          	jal	80000d5c <myproc>
    80003c84:	fdc42703          	lw	a4,-36(s0)
    80003c88:	01a70793          	addi	a5,a4,26
    80003c8c:	078e                	slli	a5,a5,0x3
    80003c8e:	953e                	add	a0,a0,a5
    80003c90:	611c                	ld	a5,0(a0)
    80003c92:	c385                	beqz	a5,80003cb2 <argfd+0x54>
    return -1;
  if(pfd)
    80003c94:	00090463          	beqz	s2,80003c9c <argfd+0x3e>
    *pfd = fd;
    80003c98:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003c9c:	4501                	li	a0,0
  if(pf)
    80003c9e:	c091                	beqz	s1,80003ca2 <argfd+0x44>
    *pf = f;
    80003ca0:	e09c                	sd	a5,0(s1)
}
    80003ca2:	70a2                	ld	ra,40(sp)
    80003ca4:	7402                	ld	s0,32(sp)
    80003ca6:	64e2                	ld	s1,24(sp)
    80003ca8:	6942                	ld	s2,16(sp)
    80003caa:	6145                	addi	sp,sp,48
    80003cac:	8082                	ret
    return -1;
    80003cae:	557d                	li	a0,-1
    80003cb0:	bfcd                	j	80003ca2 <argfd+0x44>
    80003cb2:	557d                	li	a0,-1
    80003cb4:	b7fd                	j	80003ca2 <argfd+0x44>

0000000080003cb6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003cb6:	1101                	addi	sp,sp,-32
    80003cb8:	ec06                	sd	ra,24(sp)
    80003cba:	e822                	sd	s0,16(sp)
    80003cbc:	e426                	sd	s1,8(sp)
    80003cbe:	1000                	addi	s0,sp,32
    80003cc0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003cc2:	89afd0ef          	jal	80000d5c <myproc>
    80003cc6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003cc8:	0d050793          	addi	a5,a0,208
    80003ccc:	4501                	li	a0,0
    80003cce:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003cd0:	6398                	ld	a4,0(a5)
    80003cd2:	cb19                	beqz	a4,80003ce8 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003cd4:	2505                	addiw	a0,a0,1
    80003cd6:	07a1                	addi	a5,a5,8
    80003cd8:	fed51ce3          	bne	a0,a3,80003cd0 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003cdc:	557d                	li	a0,-1
}
    80003cde:	60e2                	ld	ra,24(sp)
    80003ce0:	6442                	ld	s0,16(sp)
    80003ce2:	64a2                	ld	s1,8(sp)
    80003ce4:	6105                	addi	sp,sp,32
    80003ce6:	8082                	ret
      p->ofile[fd] = f;
    80003ce8:	01a50793          	addi	a5,a0,26
    80003cec:	078e                	slli	a5,a5,0x3
    80003cee:	963e                	add	a2,a2,a5
    80003cf0:	e204                	sd	s1,0(a2)
      return fd;
    80003cf2:	b7f5                	j	80003cde <fdalloc+0x28>

0000000080003cf4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003cf4:	715d                	addi	sp,sp,-80
    80003cf6:	e486                	sd	ra,72(sp)
    80003cf8:	e0a2                	sd	s0,64(sp)
    80003cfa:	fc26                	sd	s1,56(sp)
    80003cfc:	f84a                	sd	s2,48(sp)
    80003cfe:	f44e                	sd	s3,40(sp)
    80003d00:	ec56                	sd	s5,24(sp)
    80003d02:	e85a                	sd	s6,16(sp)
    80003d04:	0880                	addi	s0,sp,80
    80003d06:	8b2e                	mv	s6,a1
    80003d08:	89b2                	mv	s3,a2
    80003d0a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d0c:	fb040593          	addi	a1,s0,-80
    80003d10:	ffdfe0ef          	jal	80002d0c <nameiparent>
    80003d14:	84aa                	mv	s1,a0
    80003d16:	10050a63          	beqz	a0,80003e2a <create+0x136>
    return 0;

  ilock(dp);
    80003d1a:	8e9fe0ef          	jal	80002602 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d1e:	4601                	li	a2,0
    80003d20:	fb040593          	addi	a1,s0,-80
    80003d24:	8526                	mv	a0,s1
    80003d26:	d41fe0ef          	jal	80002a66 <dirlookup>
    80003d2a:	8aaa                	mv	s5,a0
    80003d2c:	c129                	beqz	a0,80003d6e <create+0x7a>
    iunlockput(dp);
    80003d2e:	8526                	mv	a0,s1
    80003d30:	addfe0ef          	jal	8000280c <iunlockput>
    ilock(ip);
    80003d34:	8556                	mv	a0,s5
    80003d36:	8cdfe0ef          	jal	80002602 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003d3a:	4789                	li	a5,2
    80003d3c:	02fb1463          	bne	s6,a5,80003d64 <create+0x70>
    80003d40:	044ad783          	lhu	a5,68(s5)
    80003d44:	37f9                	addiw	a5,a5,-2
    80003d46:	17c2                	slli	a5,a5,0x30
    80003d48:	93c1                	srli	a5,a5,0x30
    80003d4a:	4705                	li	a4,1
    80003d4c:	00f76c63          	bltu	a4,a5,80003d64 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003d50:	8556                	mv	a0,s5
    80003d52:	60a6                	ld	ra,72(sp)
    80003d54:	6406                	ld	s0,64(sp)
    80003d56:	74e2                	ld	s1,56(sp)
    80003d58:	7942                	ld	s2,48(sp)
    80003d5a:	79a2                	ld	s3,40(sp)
    80003d5c:	6ae2                	ld	s5,24(sp)
    80003d5e:	6b42                	ld	s6,16(sp)
    80003d60:	6161                	addi	sp,sp,80
    80003d62:	8082                	ret
    iunlockput(ip);
    80003d64:	8556                	mv	a0,s5
    80003d66:	aa7fe0ef          	jal	8000280c <iunlockput>
    return 0;
    80003d6a:	4a81                	li	s5,0
    80003d6c:	b7d5                	j	80003d50 <create+0x5c>
    80003d6e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003d70:	85da                	mv	a1,s6
    80003d72:	4088                	lw	a0,0(s1)
    80003d74:	f1efe0ef          	jal	80002492 <ialloc>
    80003d78:	8a2a                	mv	s4,a0
    80003d7a:	cd15                	beqz	a0,80003db6 <create+0xc2>
  ilock(ip);
    80003d7c:	887fe0ef          	jal	80002602 <ilock>
  ip->major = major;
    80003d80:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003d84:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003d88:	4905                	li	s2,1
    80003d8a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003d8e:	8552                	mv	a0,s4
    80003d90:	fbefe0ef          	jal	8000254e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003d94:	032b0763          	beq	s6,s2,80003dc2 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003d98:	004a2603          	lw	a2,4(s4)
    80003d9c:	fb040593          	addi	a1,s0,-80
    80003da0:	8526                	mv	a0,s1
    80003da2:	ea7fe0ef          	jal	80002c48 <dirlink>
    80003da6:	06054563          	bltz	a0,80003e10 <create+0x11c>
  iunlockput(dp);
    80003daa:	8526                	mv	a0,s1
    80003dac:	a61fe0ef          	jal	8000280c <iunlockput>
  return ip;
    80003db0:	8ad2                	mv	s5,s4
    80003db2:	7a02                	ld	s4,32(sp)
    80003db4:	bf71                	j	80003d50 <create+0x5c>
    iunlockput(dp);
    80003db6:	8526                	mv	a0,s1
    80003db8:	a55fe0ef          	jal	8000280c <iunlockput>
    return 0;
    80003dbc:	8ad2                	mv	s5,s4
    80003dbe:	7a02                	ld	s4,32(sp)
    80003dc0:	bf41                	j	80003d50 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003dc2:	004a2603          	lw	a2,4(s4)
    80003dc6:	00003597          	auipc	a1,0x3
    80003dca:	7fa58593          	addi	a1,a1,2042 # 800075c0 <etext+0x5c0>
    80003dce:	8552                	mv	a0,s4
    80003dd0:	e79fe0ef          	jal	80002c48 <dirlink>
    80003dd4:	02054e63          	bltz	a0,80003e10 <create+0x11c>
    80003dd8:	40d0                	lw	a2,4(s1)
    80003dda:	00003597          	auipc	a1,0x3
    80003dde:	7ee58593          	addi	a1,a1,2030 # 800075c8 <etext+0x5c8>
    80003de2:	8552                	mv	a0,s4
    80003de4:	e65fe0ef          	jal	80002c48 <dirlink>
    80003de8:	02054463          	bltz	a0,80003e10 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003dec:	004a2603          	lw	a2,4(s4)
    80003df0:	fb040593          	addi	a1,s0,-80
    80003df4:	8526                	mv	a0,s1
    80003df6:	e53fe0ef          	jal	80002c48 <dirlink>
    80003dfa:	00054b63          	bltz	a0,80003e10 <create+0x11c>
    dp->nlink++;  // for ".."
    80003dfe:	04a4d783          	lhu	a5,74(s1)
    80003e02:	2785                	addiw	a5,a5,1
    80003e04:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e08:	8526                	mv	a0,s1
    80003e0a:	f44fe0ef          	jal	8000254e <iupdate>
    80003e0e:	bf71                	j	80003daa <create+0xb6>
  ip->nlink = 0;
    80003e10:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e14:	8552                	mv	a0,s4
    80003e16:	f38fe0ef          	jal	8000254e <iupdate>
  iunlockput(ip);
    80003e1a:	8552                	mv	a0,s4
    80003e1c:	9f1fe0ef          	jal	8000280c <iunlockput>
  iunlockput(dp);
    80003e20:	8526                	mv	a0,s1
    80003e22:	9ebfe0ef          	jal	8000280c <iunlockput>
  return 0;
    80003e26:	7a02                	ld	s4,32(sp)
    80003e28:	b725                	j	80003d50 <create+0x5c>
    return 0;
    80003e2a:	8aaa                	mv	s5,a0
    80003e2c:	b715                	j	80003d50 <create+0x5c>

0000000080003e2e <sys_dup>:
{
    80003e2e:	7179                	addi	sp,sp,-48
    80003e30:	f406                	sd	ra,40(sp)
    80003e32:	f022                	sd	s0,32(sp)
    80003e34:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003e36:	fd840613          	addi	a2,s0,-40
    80003e3a:	4581                	li	a1,0
    80003e3c:	4501                	li	a0,0
    80003e3e:	e21ff0ef          	jal	80003c5e <argfd>
    return -1;
    80003e42:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003e44:	02054363          	bltz	a0,80003e6a <sys_dup+0x3c>
    80003e48:	ec26                	sd	s1,24(sp)
    80003e4a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003e4c:	fd843903          	ld	s2,-40(s0)
    80003e50:	854a                	mv	a0,s2
    80003e52:	e65ff0ef          	jal	80003cb6 <fdalloc>
    80003e56:	84aa                	mv	s1,a0
    return -1;
    80003e58:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003e5a:	00054d63          	bltz	a0,80003e74 <sys_dup+0x46>
  filedup(f);
    80003e5e:	854a                	mv	a0,s2
    80003e60:	c2eff0ef          	jal	8000328e <filedup>
  return fd;
    80003e64:	87a6                	mv	a5,s1
    80003e66:	64e2                	ld	s1,24(sp)
    80003e68:	6942                	ld	s2,16(sp)
}
    80003e6a:	853e                	mv	a0,a5
    80003e6c:	70a2                	ld	ra,40(sp)
    80003e6e:	7402                	ld	s0,32(sp)
    80003e70:	6145                	addi	sp,sp,48
    80003e72:	8082                	ret
    80003e74:	64e2                	ld	s1,24(sp)
    80003e76:	6942                	ld	s2,16(sp)
    80003e78:	bfcd                	j	80003e6a <sys_dup+0x3c>

0000000080003e7a <sys_read>:
{
    80003e7a:	7179                	addi	sp,sp,-48
    80003e7c:	f406                	sd	ra,40(sp)
    80003e7e:	f022                	sd	s0,32(sp)
    80003e80:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e82:	fd840593          	addi	a1,s0,-40
    80003e86:	4505                	li	a0,1
    80003e88:	da3fd0ef          	jal	80001c2a <argaddr>
  argint(2, &n);
    80003e8c:	fe440593          	addi	a1,s0,-28
    80003e90:	4509                	li	a0,2
    80003e92:	d7dfd0ef          	jal	80001c0e <argint>
  if(argfd(0, 0, &f) < 0)
    80003e96:	fe840613          	addi	a2,s0,-24
    80003e9a:	4581                	li	a1,0
    80003e9c:	4501                	li	a0,0
    80003e9e:	dc1ff0ef          	jal	80003c5e <argfd>
    80003ea2:	87aa                	mv	a5,a0
    return -1;
    80003ea4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ea6:	0007ca63          	bltz	a5,80003eba <sys_read+0x40>
  return fileread(f, p, n);
    80003eaa:	fe442603          	lw	a2,-28(s0)
    80003eae:	fd843583          	ld	a1,-40(s0)
    80003eb2:	fe843503          	ld	a0,-24(s0)
    80003eb6:	d3eff0ef          	jal	800033f4 <fileread>
}
    80003eba:	70a2                	ld	ra,40(sp)
    80003ebc:	7402                	ld	s0,32(sp)
    80003ebe:	6145                	addi	sp,sp,48
    80003ec0:	8082                	ret

0000000080003ec2 <sys_write>:
{
    80003ec2:	7179                	addi	sp,sp,-48
    80003ec4:	f406                	sd	ra,40(sp)
    80003ec6:	f022                	sd	s0,32(sp)
    80003ec8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003eca:	fd840593          	addi	a1,s0,-40
    80003ece:	4505                	li	a0,1
    80003ed0:	d5bfd0ef          	jal	80001c2a <argaddr>
  argint(2, &n);
    80003ed4:	fe440593          	addi	a1,s0,-28
    80003ed8:	4509                	li	a0,2
    80003eda:	d35fd0ef          	jal	80001c0e <argint>
  if(argfd(0, 0, &f) < 0)
    80003ede:	fe840613          	addi	a2,s0,-24
    80003ee2:	4581                	li	a1,0
    80003ee4:	4501                	li	a0,0
    80003ee6:	d79ff0ef          	jal	80003c5e <argfd>
    80003eea:	87aa                	mv	a5,a0
    return -1;
    80003eec:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003eee:	0007ca63          	bltz	a5,80003f02 <sys_write+0x40>
  return filewrite(f, p, n);
    80003ef2:	fe442603          	lw	a2,-28(s0)
    80003ef6:	fd843583          	ld	a1,-40(s0)
    80003efa:	fe843503          	ld	a0,-24(s0)
    80003efe:	db4ff0ef          	jal	800034b2 <filewrite>
}
    80003f02:	70a2                	ld	ra,40(sp)
    80003f04:	7402                	ld	s0,32(sp)
    80003f06:	6145                	addi	sp,sp,48
    80003f08:	8082                	ret

0000000080003f0a <sys_close>:
{
    80003f0a:	1101                	addi	sp,sp,-32
    80003f0c:	ec06                	sd	ra,24(sp)
    80003f0e:	e822                	sd	s0,16(sp)
    80003f10:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f12:	fe040613          	addi	a2,s0,-32
    80003f16:	fec40593          	addi	a1,s0,-20
    80003f1a:	4501                	li	a0,0
    80003f1c:	d43ff0ef          	jal	80003c5e <argfd>
    return -1;
    80003f20:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f22:	02054063          	bltz	a0,80003f42 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f26:	e37fc0ef          	jal	80000d5c <myproc>
    80003f2a:	fec42783          	lw	a5,-20(s0)
    80003f2e:	07e9                	addi	a5,a5,26
    80003f30:	078e                	slli	a5,a5,0x3
    80003f32:	953e                	add	a0,a0,a5
    80003f34:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003f38:	fe043503          	ld	a0,-32(s0)
    80003f3c:	b98ff0ef          	jal	800032d4 <fileclose>
  return 0;
    80003f40:	4781                	li	a5,0
}
    80003f42:	853e                	mv	a0,a5
    80003f44:	60e2                	ld	ra,24(sp)
    80003f46:	6442                	ld	s0,16(sp)
    80003f48:	6105                	addi	sp,sp,32
    80003f4a:	8082                	ret

0000000080003f4c <sys_fstat>:
{
    80003f4c:	1101                	addi	sp,sp,-32
    80003f4e:	ec06                	sd	ra,24(sp)
    80003f50:	e822                	sd	s0,16(sp)
    80003f52:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003f54:	fe040593          	addi	a1,s0,-32
    80003f58:	4505                	li	a0,1
    80003f5a:	cd1fd0ef          	jal	80001c2a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003f5e:	fe840613          	addi	a2,s0,-24
    80003f62:	4581                	li	a1,0
    80003f64:	4501                	li	a0,0
    80003f66:	cf9ff0ef          	jal	80003c5e <argfd>
    80003f6a:	87aa                	mv	a5,a0
    return -1;
    80003f6c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f6e:	0007c863          	bltz	a5,80003f7e <sys_fstat+0x32>
  return filestat(f, st);
    80003f72:	fe043583          	ld	a1,-32(s0)
    80003f76:	fe843503          	ld	a0,-24(s0)
    80003f7a:	c18ff0ef          	jal	80003392 <filestat>
}
    80003f7e:	60e2                	ld	ra,24(sp)
    80003f80:	6442                	ld	s0,16(sp)
    80003f82:	6105                	addi	sp,sp,32
    80003f84:	8082                	ret

0000000080003f86 <sys_link>:
{
    80003f86:	7169                	addi	sp,sp,-304
    80003f88:	f606                	sd	ra,296(sp)
    80003f8a:	f222                	sd	s0,288(sp)
    80003f8c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f8e:	08000613          	li	a2,128
    80003f92:	ed040593          	addi	a1,s0,-304
    80003f96:	4501                	li	a0,0
    80003f98:	caffd0ef          	jal	80001c46 <argstr>
    return -1;
    80003f9c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f9e:	0c054e63          	bltz	a0,8000407a <sys_link+0xf4>
    80003fa2:	08000613          	li	a2,128
    80003fa6:	f5040593          	addi	a1,s0,-176
    80003faa:	4505                	li	a0,1
    80003fac:	c9bfd0ef          	jal	80001c46 <argstr>
    return -1;
    80003fb0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fb2:	0c054463          	bltz	a0,8000407a <sys_link+0xf4>
    80003fb6:	ee26                	sd	s1,280(sp)
  begin_op();
    80003fb8:	efdfe0ef          	jal	80002eb4 <begin_op>
  if((ip = namei(old)) == 0){
    80003fbc:	ed040513          	addi	a0,s0,-304
    80003fc0:	d33fe0ef          	jal	80002cf2 <namei>
    80003fc4:	84aa                	mv	s1,a0
    80003fc6:	c53d                	beqz	a0,80004034 <sys_link+0xae>
  ilock(ip);
    80003fc8:	e3afe0ef          	jal	80002602 <ilock>
  if(ip->type == T_DIR){
    80003fcc:	04449703          	lh	a4,68(s1)
    80003fd0:	4785                	li	a5,1
    80003fd2:	06f70663          	beq	a4,a5,8000403e <sys_link+0xb8>
    80003fd6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80003fd8:	04a4d783          	lhu	a5,74(s1)
    80003fdc:	2785                	addiw	a5,a5,1
    80003fde:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	d6afe0ef          	jal	8000254e <iupdate>
  iunlock(ip);
    80003fe8:	8526                	mv	a0,s1
    80003fea:	ec6fe0ef          	jal	800026b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003fee:	fd040593          	addi	a1,s0,-48
    80003ff2:	f5040513          	addi	a0,s0,-176
    80003ff6:	d17fe0ef          	jal	80002d0c <nameiparent>
    80003ffa:	892a                	mv	s2,a0
    80003ffc:	cd21                	beqz	a0,80004054 <sys_link+0xce>
  ilock(dp);
    80003ffe:	e04fe0ef          	jal	80002602 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004002:	00092703          	lw	a4,0(s2)
    80004006:	409c                	lw	a5,0(s1)
    80004008:	04f71363          	bne	a4,a5,8000404e <sys_link+0xc8>
    8000400c:	40d0                	lw	a2,4(s1)
    8000400e:	fd040593          	addi	a1,s0,-48
    80004012:	854a                	mv	a0,s2
    80004014:	c35fe0ef          	jal	80002c48 <dirlink>
    80004018:	02054b63          	bltz	a0,8000404e <sys_link+0xc8>
  iunlockput(dp);
    8000401c:	854a                	mv	a0,s2
    8000401e:	feefe0ef          	jal	8000280c <iunlockput>
  iput(ip);
    80004022:	8526                	mv	a0,s1
    80004024:	f60fe0ef          	jal	80002784 <iput>
  end_op();
    80004028:	ef7fe0ef          	jal	80002f1e <end_op>
  return 0;
    8000402c:	4781                	li	a5,0
    8000402e:	64f2                	ld	s1,280(sp)
    80004030:	6952                	ld	s2,272(sp)
    80004032:	a0a1                	j	8000407a <sys_link+0xf4>
    end_op();
    80004034:	eebfe0ef          	jal	80002f1e <end_op>
    return -1;
    80004038:	57fd                	li	a5,-1
    8000403a:	64f2                	ld	s1,280(sp)
    8000403c:	a83d                	j	8000407a <sys_link+0xf4>
    iunlockput(ip);
    8000403e:	8526                	mv	a0,s1
    80004040:	fccfe0ef          	jal	8000280c <iunlockput>
    end_op();
    80004044:	edbfe0ef          	jal	80002f1e <end_op>
    return -1;
    80004048:	57fd                	li	a5,-1
    8000404a:	64f2                	ld	s1,280(sp)
    8000404c:	a03d                	j	8000407a <sys_link+0xf4>
    iunlockput(dp);
    8000404e:	854a                	mv	a0,s2
    80004050:	fbcfe0ef          	jal	8000280c <iunlockput>
  ilock(ip);
    80004054:	8526                	mv	a0,s1
    80004056:	dacfe0ef          	jal	80002602 <ilock>
  ip->nlink--;
    8000405a:	04a4d783          	lhu	a5,74(s1)
    8000405e:	37fd                	addiw	a5,a5,-1
    80004060:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004064:	8526                	mv	a0,s1
    80004066:	ce8fe0ef          	jal	8000254e <iupdate>
  iunlockput(ip);
    8000406a:	8526                	mv	a0,s1
    8000406c:	fa0fe0ef          	jal	8000280c <iunlockput>
  end_op();
    80004070:	eaffe0ef          	jal	80002f1e <end_op>
  return -1;
    80004074:	57fd                	li	a5,-1
    80004076:	64f2                	ld	s1,280(sp)
    80004078:	6952                	ld	s2,272(sp)
}
    8000407a:	853e                	mv	a0,a5
    8000407c:	70b2                	ld	ra,296(sp)
    8000407e:	7412                	ld	s0,288(sp)
    80004080:	6155                	addi	sp,sp,304
    80004082:	8082                	ret

0000000080004084 <sys_unlink>:
{
    80004084:	7111                	addi	sp,sp,-256
    80004086:	fd86                	sd	ra,248(sp)
    80004088:	f9a2                	sd	s0,240(sp)
    8000408a:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    8000408c:	08000613          	li	a2,128
    80004090:	f2040593          	addi	a1,s0,-224
    80004094:	4501                	li	a0,0
    80004096:	bb1fd0ef          	jal	80001c46 <argstr>
    8000409a:	16054663          	bltz	a0,80004206 <sys_unlink+0x182>
    8000409e:	f5a6                	sd	s1,232(sp)
  begin_op();
    800040a0:	e15fe0ef          	jal	80002eb4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800040a4:	fa040593          	addi	a1,s0,-96
    800040a8:	f2040513          	addi	a0,s0,-224
    800040ac:	c61fe0ef          	jal	80002d0c <nameiparent>
    800040b0:	84aa                	mv	s1,a0
    800040b2:	c955                	beqz	a0,80004166 <sys_unlink+0xe2>
  ilock(dp);
    800040b4:	d4efe0ef          	jal	80002602 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800040b8:	00003597          	auipc	a1,0x3
    800040bc:	50858593          	addi	a1,a1,1288 # 800075c0 <etext+0x5c0>
    800040c0:	fa040513          	addi	a0,s0,-96
    800040c4:	98dfe0ef          	jal	80002a50 <namecmp>
    800040c8:	12050463          	beqz	a0,800041f0 <sys_unlink+0x16c>
    800040cc:	00003597          	auipc	a1,0x3
    800040d0:	4fc58593          	addi	a1,a1,1276 # 800075c8 <etext+0x5c8>
    800040d4:	fa040513          	addi	a0,s0,-96
    800040d8:	979fe0ef          	jal	80002a50 <namecmp>
    800040dc:	10050a63          	beqz	a0,800041f0 <sys_unlink+0x16c>
    800040e0:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800040e2:	f1c40613          	addi	a2,s0,-228
    800040e6:	fa040593          	addi	a1,s0,-96
    800040ea:	8526                	mv	a0,s1
    800040ec:	97bfe0ef          	jal	80002a66 <dirlookup>
    800040f0:	892a                	mv	s2,a0
    800040f2:	0e050e63          	beqz	a0,800041ee <sys_unlink+0x16a>
    800040f6:	edce                	sd	s3,216(sp)
  ilock(ip);
    800040f8:	d0afe0ef          	jal	80002602 <ilock>
  if(ip->nlink < 1)
    800040fc:	04a91783          	lh	a5,74(s2)
    80004100:	06f05863          	blez	a5,80004170 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004104:	04491703          	lh	a4,68(s2)
    80004108:	4785                	li	a5,1
    8000410a:	06f70b63          	beq	a4,a5,80004180 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    8000410e:	fb040993          	addi	s3,s0,-80
    80004112:	4641                	li	a2,16
    80004114:	4581                	li	a1,0
    80004116:	854e                	mv	a0,s3
    80004118:	836fc0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000411c:	4741                	li	a4,16
    8000411e:	f1c42683          	lw	a3,-228(s0)
    80004122:	864e                	mv	a2,s3
    80004124:	4581                	li	a1,0
    80004126:	8526                	mv	a0,s1
    80004128:	825fe0ef          	jal	8000294c <writei>
    8000412c:	47c1                	li	a5,16
    8000412e:	08f51f63          	bne	a0,a5,800041cc <sys_unlink+0x148>
  if(ip->type == T_DIR){
    80004132:	04491703          	lh	a4,68(s2)
    80004136:	4785                	li	a5,1
    80004138:	0af70263          	beq	a4,a5,800041dc <sys_unlink+0x158>
  iunlockput(dp);
    8000413c:	8526                	mv	a0,s1
    8000413e:	ecefe0ef          	jal	8000280c <iunlockput>
  ip->nlink--;
    80004142:	04a95783          	lhu	a5,74(s2)
    80004146:	37fd                	addiw	a5,a5,-1
    80004148:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000414c:	854a                	mv	a0,s2
    8000414e:	c00fe0ef          	jal	8000254e <iupdate>
  iunlockput(ip);
    80004152:	854a                	mv	a0,s2
    80004154:	eb8fe0ef          	jal	8000280c <iunlockput>
  end_op();
    80004158:	dc7fe0ef          	jal	80002f1e <end_op>
  return 0;
    8000415c:	4501                	li	a0,0
    8000415e:	74ae                	ld	s1,232(sp)
    80004160:	790e                	ld	s2,224(sp)
    80004162:	69ee                	ld	s3,216(sp)
    80004164:	a869                	j	800041fe <sys_unlink+0x17a>
    end_op();
    80004166:	db9fe0ef          	jal	80002f1e <end_op>
    return -1;
    8000416a:	557d                	li	a0,-1
    8000416c:	74ae                	ld	s1,232(sp)
    8000416e:	a841                	j	800041fe <sys_unlink+0x17a>
    80004170:	e9d2                	sd	s4,208(sp)
    80004172:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004174:	00003517          	auipc	a0,0x3
    80004178:	45c50513          	addi	a0,a0,1116 # 800075d0 <etext+0x5d0>
    8000417c:	26a010ef          	jal	800053e6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004180:	04c92703          	lw	a4,76(s2)
    80004184:	02000793          	li	a5,32
    80004188:	f8e7f3e3          	bgeu	a5,a4,8000410e <sys_unlink+0x8a>
    8000418c:	e9d2                	sd	s4,208(sp)
    8000418e:	e5d6                	sd	s5,200(sp)
    80004190:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004192:	f0840a93          	addi	s5,s0,-248
    80004196:	4a41                	li	s4,16
    80004198:	8752                	mv	a4,s4
    8000419a:	86ce                	mv	a3,s3
    8000419c:	8656                	mv	a2,s5
    8000419e:	4581                	li	a1,0
    800041a0:	854a                	mv	a0,s2
    800041a2:	eb8fe0ef          	jal	8000285a <readi>
    800041a6:	01451d63          	bne	a0,s4,800041c0 <sys_unlink+0x13c>
    if(de.inum != 0)
    800041aa:	f0845783          	lhu	a5,-248(s0)
    800041ae:	efb1                	bnez	a5,8000420a <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041b0:	29c1                	addiw	s3,s3,16
    800041b2:	04c92783          	lw	a5,76(s2)
    800041b6:	fef9e1e3          	bltu	s3,a5,80004198 <sys_unlink+0x114>
    800041ba:	6a4e                	ld	s4,208(sp)
    800041bc:	6aae                	ld	s5,200(sp)
    800041be:	bf81                	j	8000410e <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800041c0:	00003517          	auipc	a0,0x3
    800041c4:	42850513          	addi	a0,a0,1064 # 800075e8 <etext+0x5e8>
    800041c8:	21e010ef          	jal	800053e6 <panic>
    800041cc:	e9d2                	sd	s4,208(sp)
    800041ce:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800041d0:	00003517          	auipc	a0,0x3
    800041d4:	43050513          	addi	a0,a0,1072 # 80007600 <etext+0x600>
    800041d8:	20e010ef          	jal	800053e6 <panic>
    dp->nlink--;
    800041dc:	04a4d783          	lhu	a5,74(s1)
    800041e0:	37fd                	addiw	a5,a5,-1
    800041e2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800041e6:	8526                	mv	a0,s1
    800041e8:	b66fe0ef          	jal	8000254e <iupdate>
    800041ec:	bf81                	j	8000413c <sys_unlink+0xb8>
    800041ee:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800041f0:	8526                	mv	a0,s1
    800041f2:	e1afe0ef          	jal	8000280c <iunlockput>
  end_op();
    800041f6:	d29fe0ef          	jal	80002f1e <end_op>
  return -1;
    800041fa:	557d                	li	a0,-1
    800041fc:	74ae                	ld	s1,232(sp)
}
    800041fe:	70ee                	ld	ra,248(sp)
    80004200:	744e                	ld	s0,240(sp)
    80004202:	6111                	addi	sp,sp,256
    80004204:	8082                	ret
    return -1;
    80004206:	557d                	li	a0,-1
    80004208:	bfdd                	j	800041fe <sys_unlink+0x17a>
    iunlockput(ip);
    8000420a:	854a                	mv	a0,s2
    8000420c:	e00fe0ef          	jal	8000280c <iunlockput>
    goto bad;
    80004210:	790e                	ld	s2,224(sp)
    80004212:	69ee                	ld	s3,216(sp)
    80004214:	6a4e                	ld	s4,208(sp)
    80004216:	6aae                	ld	s5,200(sp)
    80004218:	bfe1                	j	800041f0 <sys_unlink+0x16c>

000000008000421a <sys_open>:

uint64
sys_open(void)
{
    8000421a:	7131                	addi	sp,sp,-192
    8000421c:	fd06                	sd	ra,184(sp)
    8000421e:	f922                	sd	s0,176(sp)
    80004220:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004222:	f4c40593          	addi	a1,s0,-180
    80004226:	4505                	li	a0,1
    80004228:	9e7fd0ef          	jal	80001c0e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000422c:	08000613          	li	a2,128
    80004230:	f5040593          	addi	a1,s0,-176
    80004234:	4501                	li	a0,0
    80004236:	a11fd0ef          	jal	80001c46 <argstr>
    8000423a:	87aa                	mv	a5,a0
    return -1;
    8000423c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000423e:	0a07c363          	bltz	a5,800042e4 <sys_open+0xca>
    80004242:	f526                	sd	s1,168(sp)

  begin_op();
    80004244:	c71fe0ef          	jal	80002eb4 <begin_op>

  if(omode & O_CREATE){
    80004248:	f4c42783          	lw	a5,-180(s0)
    8000424c:	2007f793          	andi	a5,a5,512
    80004250:	c3dd                	beqz	a5,800042f6 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004252:	4681                	li	a3,0
    80004254:	4601                	li	a2,0
    80004256:	4589                	li	a1,2
    80004258:	f5040513          	addi	a0,s0,-176
    8000425c:	a99ff0ef          	jal	80003cf4 <create>
    80004260:	84aa                	mv	s1,a0
    if(ip == 0){
    80004262:	c549                	beqz	a0,800042ec <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004264:	04449703          	lh	a4,68(s1)
    80004268:	478d                	li	a5,3
    8000426a:	00f71763          	bne	a4,a5,80004278 <sys_open+0x5e>
    8000426e:	0464d703          	lhu	a4,70(s1)
    80004272:	47a5                	li	a5,9
    80004274:	0ae7ee63          	bltu	a5,a4,80004330 <sys_open+0x116>
    80004278:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000427a:	fb7fe0ef          	jal	80003230 <filealloc>
    8000427e:	892a                	mv	s2,a0
    80004280:	c561                	beqz	a0,80004348 <sys_open+0x12e>
    80004282:	ed4e                	sd	s3,152(sp)
    80004284:	a33ff0ef          	jal	80003cb6 <fdalloc>
    80004288:	89aa                	mv	s3,a0
    8000428a:	0a054b63          	bltz	a0,80004340 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000428e:	04449703          	lh	a4,68(s1)
    80004292:	478d                	li	a5,3
    80004294:	0cf70363          	beq	a4,a5,8000435a <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004298:	4789                	li	a5,2
    8000429a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000429e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800042a2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800042a6:	f4c42783          	lw	a5,-180(s0)
    800042aa:	0017f713          	andi	a4,a5,1
    800042ae:	00174713          	xori	a4,a4,1
    800042b2:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800042b6:	0037f713          	andi	a4,a5,3
    800042ba:	00e03733          	snez	a4,a4
    800042be:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800042c2:	4007f793          	andi	a5,a5,1024
    800042c6:	c791                	beqz	a5,800042d2 <sys_open+0xb8>
    800042c8:	04449703          	lh	a4,68(s1)
    800042cc:	4789                	li	a5,2
    800042ce:	08f70d63          	beq	a4,a5,80004368 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800042d2:	8526                	mv	a0,s1
    800042d4:	bdcfe0ef          	jal	800026b0 <iunlock>
  end_op();
    800042d8:	c47fe0ef          	jal	80002f1e <end_op>

  return fd;
    800042dc:	854e                	mv	a0,s3
    800042de:	74aa                	ld	s1,168(sp)
    800042e0:	790a                	ld	s2,160(sp)
    800042e2:	69ea                	ld	s3,152(sp)
}
    800042e4:	70ea                	ld	ra,184(sp)
    800042e6:	744a                	ld	s0,176(sp)
    800042e8:	6129                	addi	sp,sp,192
    800042ea:	8082                	ret
      end_op();
    800042ec:	c33fe0ef          	jal	80002f1e <end_op>
      return -1;
    800042f0:	557d                	li	a0,-1
    800042f2:	74aa                	ld	s1,168(sp)
    800042f4:	bfc5                	j	800042e4 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800042f6:	f5040513          	addi	a0,s0,-176
    800042fa:	9f9fe0ef          	jal	80002cf2 <namei>
    800042fe:	84aa                	mv	s1,a0
    80004300:	c11d                	beqz	a0,80004326 <sys_open+0x10c>
    ilock(ip);
    80004302:	b00fe0ef          	jal	80002602 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004306:	04449703          	lh	a4,68(s1)
    8000430a:	4785                	li	a5,1
    8000430c:	f4f71ce3          	bne	a4,a5,80004264 <sys_open+0x4a>
    80004310:	f4c42783          	lw	a5,-180(s0)
    80004314:	d3b5                	beqz	a5,80004278 <sys_open+0x5e>
      iunlockput(ip);
    80004316:	8526                	mv	a0,s1
    80004318:	cf4fe0ef          	jal	8000280c <iunlockput>
      end_op();
    8000431c:	c03fe0ef          	jal	80002f1e <end_op>
      return -1;
    80004320:	557d                	li	a0,-1
    80004322:	74aa                	ld	s1,168(sp)
    80004324:	b7c1                	j	800042e4 <sys_open+0xca>
      end_op();
    80004326:	bf9fe0ef          	jal	80002f1e <end_op>
      return -1;
    8000432a:	557d                	li	a0,-1
    8000432c:	74aa                	ld	s1,168(sp)
    8000432e:	bf5d                	j	800042e4 <sys_open+0xca>
    iunlockput(ip);
    80004330:	8526                	mv	a0,s1
    80004332:	cdafe0ef          	jal	8000280c <iunlockput>
    end_op();
    80004336:	be9fe0ef          	jal	80002f1e <end_op>
    return -1;
    8000433a:	557d                	li	a0,-1
    8000433c:	74aa                	ld	s1,168(sp)
    8000433e:	b75d                	j	800042e4 <sys_open+0xca>
      fileclose(f);
    80004340:	854a                	mv	a0,s2
    80004342:	f93fe0ef          	jal	800032d4 <fileclose>
    80004346:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004348:	8526                	mv	a0,s1
    8000434a:	cc2fe0ef          	jal	8000280c <iunlockput>
    end_op();
    8000434e:	bd1fe0ef          	jal	80002f1e <end_op>
    return -1;
    80004352:	557d                	li	a0,-1
    80004354:	74aa                	ld	s1,168(sp)
    80004356:	790a                	ld	s2,160(sp)
    80004358:	b771                	j	800042e4 <sys_open+0xca>
    f->type = FD_DEVICE;
    8000435a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000435e:	04649783          	lh	a5,70(s1)
    80004362:	02f91223          	sh	a5,36(s2)
    80004366:	bf35                	j	800042a2 <sys_open+0x88>
    itrunc(ip);
    80004368:	8526                	mv	a0,s1
    8000436a:	b86fe0ef          	jal	800026f0 <itrunc>
    8000436e:	b795                	j	800042d2 <sys_open+0xb8>

0000000080004370 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004370:	7175                	addi	sp,sp,-144
    80004372:	e506                	sd	ra,136(sp)
    80004374:	e122                	sd	s0,128(sp)
    80004376:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004378:	b3dfe0ef          	jal	80002eb4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000437c:	08000613          	li	a2,128
    80004380:	f7040593          	addi	a1,s0,-144
    80004384:	4501                	li	a0,0
    80004386:	8c1fd0ef          	jal	80001c46 <argstr>
    8000438a:	02054363          	bltz	a0,800043b0 <sys_mkdir+0x40>
    8000438e:	4681                	li	a3,0
    80004390:	4601                	li	a2,0
    80004392:	4585                	li	a1,1
    80004394:	f7040513          	addi	a0,s0,-144
    80004398:	95dff0ef          	jal	80003cf4 <create>
    8000439c:	c911                	beqz	a0,800043b0 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000439e:	c6efe0ef          	jal	8000280c <iunlockput>
  end_op();
    800043a2:	b7dfe0ef          	jal	80002f1e <end_op>
  return 0;
    800043a6:	4501                	li	a0,0
}
    800043a8:	60aa                	ld	ra,136(sp)
    800043aa:	640a                	ld	s0,128(sp)
    800043ac:	6149                	addi	sp,sp,144
    800043ae:	8082                	ret
    end_op();
    800043b0:	b6ffe0ef          	jal	80002f1e <end_op>
    return -1;
    800043b4:	557d                	li	a0,-1
    800043b6:	bfcd                	j	800043a8 <sys_mkdir+0x38>

00000000800043b8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800043b8:	7135                	addi	sp,sp,-160
    800043ba:	ed06                	sd	ra,152(sp)
    800043bc:	e922                	sd	s0,144(sp)
    800043be:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043c0:	af5fe0ef          	jal	80002eb4 <begin_op>
  argint(1, &major);
    800043c4:	f6c40593          	addi	a1,s0,-148
    800043c8:	4505                	li	a0,1
    800043ca:	845fd0ef          	jal	80001c0e <argint>
  argint(2, &minor);
    800043ce:	f6840593          	addi	a1,s0,-152
    800043d2:	4509                	li	a0,2
    800043d4:	83bfd0ef          	jal	80001c0e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043d8:	08000613          	li	a2,128
    800043dc:	f7040593          	addi	a1,s0,-144
    800043e0:	4501                	li	a0,0
    800043e2:	865fd0ef          	jal	80001c46 <argstr>
    800043e6:	02054563          	bltz	a0,80004410 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800043ea:	f6841683          	lh	a3,-152(s0)
    800043ee:	f6c41603          	lh	a2,-148(s0)
    800043f2:	458d                	li	a1,3
    800043f4:	f7040513          	addi	a0,s0,-144
    800043f8:	8fdff0ef          	jal	80003cf4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043fc:	c911                	beqz	a0,80004410 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043fe:	c0efe0ef          	jal	8000280c <iunlockput>
  end_op();
    80004402:	b1dfe0ef          	jal	80002f1e <end_op>
  return 0;
    80004406:	4501                	li	a0,0
}
    80004408:	60ea                	ld	ra,152(sp)
    8000440a:	644a                	ld	s0,144(sp)
    8000440c:	610d                	addi	sp,sp,160
    8000440e:	8082                	ret
    end_op();
    80004410:	b0ffe0ef          	jal	80002f1e <end_op>
    return -1;
    80004414:	557d                	li	a0,-1
    80004416:	bfcd                	j	80004408 <sys_mknod+0x50>

0000000080004418 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004418:	7135                	addi	sp,sp,-160
    8000441a:	ed06                	sd	ra,152(sp)
    8000441c:	e922                	sd	s0,144(sp)
    8000441e:	e14a                	sd	s2,128(sp)
    80004420:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004422:	93bfc0ef          	jal	80000d5c <myproc>
    80004426:	892a                	mv	s2,a0
  
  begin_op();
    80004428:	a8dfe0ef          	jal	80002eb4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000442c:	08000613          	li	a2,128
    80004430:	f6040593          	addi	a1,s0,-160
    80004434:	4501                	li	a0,0
    80004436:	811fd0ef          	jal	80001c46 <argstr>
    8000443a:	04054363          	bltz	a0,80004480 <sys_chdir+0x68>
    8000443e:	e526                	sd	s1,136(sp)
    80004440:	f6040513          	addi	a0,s0,-160
    80004444:	8affe0ef          	jal	80002cf2 <namei>
    80004448:	84aa                	mv	s1,a0
    8000444a:	c915                	beqz	a0,8000447e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000444c:	9b6fe0ef          	jal	80002602 <ilock>
  if(ip->type != T_DIR){
    80004450:	04449703          	lh	a4,68(s1)
    80004454:	4785                	li	a5,1
    80004456:	02f71963          	bne	a4,a5,80004488 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000445a:	8526                	mv	a0,s1
    8000445c:	a54fe0ef          	jal	800026b0 <iunlock>
  iput(p->cwd);
    80004460:	15093503          	ld	a0,336(s2)
    80004464:	b20fe0ef          	jal	80002784 <iput>
  end_op();
    80004468:	ab7fe0ef          	jal	80002f1e <end_op>
  p->cwd = ip;
    8000446c:	14993823          	sd	s1,336(s2)
  return 0;
    80004470:	4501                	li	a0,0
    80004472:	64aa                	ld	s1,136(sp)
}
    80004474:	60ea                	ld	ra,152(sp)
    80004476:	644a                	ld	s0,144(sp)
    80004478:	690a                	ld	s2,128(sp)
    8000447a:	610d                	addi	sp,sp,160
    8000447c:	8082                	ret
    8000447e:	64aa                	ld	s1,136(sp)
    end_op();
    80004480:	a9ffe0ef          	jal	80002f1e <end_op>
    return -1;
    80004484:	557d                	li	a0,-1
    80004486:	b7fd                	j	80004474 <sys_chdir+0x5c>
    iunlockput(ip);
    80004488:	8526                	mv	a0,s1
    8000448a:	b82fe0ef          	jal	8000280c <iunlockput>
    end_op();
    8000448e:	a91fe0ef          	jal	80002f1e <end_op>
    return -1;
    80004492:	557d                	li	a0,-1
    80004494:	64aa                	ld	s1,136(sp)
    80004496:	bff9                	j	80004474 <sys_chdir+0x5c>

0000000080004498 <sys_exec>:

uint64
sys_exec(void)
{
    80004498:	7105                	addi	sp,sp,-480
    8000449a:	ef86                	sd	ra,472(sp)
    8000449c:	eba2                	sd	s0,464(sp)
    8000449e:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800044a0:	e2840593          	addi	a1,s0,-472
    800044a4:	4505                	li	a0,1
    800044a6:	f84fd0ef          	jal	80001c2a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800044aa:	08000613          	li	a2,128
    800044ae:	f3040593          	addi	a1,s0,-208
    800044b2:	4501                	li	a0,0
    800044b4:	f92fd0ef          	jal	80001c46 <argstr>
    800044b8:	87aa                	mv	a5,a0
    return -1;
    800044ba:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044bc:	0e07c063          	bltz	a5,8000459c <sys_exec+0x104>
    800044c0:	e7a6                	sd	s1,456(sp)
    800044c2:	e3ca                	sd	s2,448(sp)
    800044c4:	ff4e                	sd	s3,440(sp)
    800044c6:	fb52                	sd	s4,432(sp)
    800044c8:	f756                	sd	s5,424(sp)
    800044ca:	f35a                	sd	s6,416(sp)
    800044cc:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800044ce:	e3040a13          	addi	s4,s0,-464
    800044d2:	10000613          	li	a2,256
    800044d6:	4581                	li	a1,0
    800044d8:	8552                	mv	a0,s4
    800044da:	c75fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044de:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800044e0:	89d2                	mv	s3,s4
    800044e2:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044e4:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800044e8:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800044ea:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044ee:	00391513          	slli	a0,s2,0x3
    800044f2:	85d6                	mv	a1,s5
    800044f4:	e2843783          	ld	a5,-472(s0)
    800044f8:	953e                	add	a0,a0,a5
    800044fa:	e8afd0ef          	jal	80001b84 <fetchaddr>
    800044fe:	02054663          	bltz	a0,8000452a <sys_exec+0x92>
    if(uarg == 0){
    80004502:	e2043783          	ld	a5,-480(s0)
    80004506:	c7a1                	beqz	a5,8000454e <sys_exec+0xb6>
    argv[i] = kalloc();
    80004508:	bf7fb0ef          	jal	800000fe <kalloc>
    8000450c:	85aa                	mv	a1,a0
    8000450e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004512:	cd01                	beqz	a0,8000452a <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004514:	865a                	mv	a2,s6
    80004516:	e2043503          	ld	a0,-480(s0)
    8000451a:	eb4fd0ef          	jal	80001bce <fetchstr>
    8000451e:	00054663          	bltz	a0,8000452a <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004522:	0905                	addi	s2,s2,1
    80004524:	09a1                	addi	s3,s3,8
    80004526:	fd7914e3          	bne	s2,s7,800044ee <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000452a:	100a0a13          	addi	s4,s4,256
    8000452e:	6088                	ld	a0,0(s1)
    80004530:	cd31                	beqz	a0,8000458c <sys_exec+0xf4>
    kfree(argv[i]);
    80004532:	aebfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004536:	04a1                	addi	s1,s1,8
    80004538:	ff449be3          	bne	s1,s4,8000452e <sys_exec+0x96>
  return -1;
    8000453c:	557d                	li	a0,-1
    8000453e:	64be                	ld	s1,456(sp)
    80004540:	691e                	ld	s2,448(sp)
    80004542:	79fa                	ld	s3,440(sp)
    80004544:	7a5a                	ld	s4,432(sp)
    80004546:	7aba                	ld	s5,424(sp)
    80004548:	7b1a                	ld	s6,416(sp)
    8000454a:	6bfa                	ld	s7,408(sp)
    8000454c:	a881                	j	8000459c <sys_exec+0x104>
      argv[i] = 0;
    8000454e:	0009079b          	sext.w	a5,s2
    80004552:	e3040593          	addi	a1,s0,-464
    80004556:	078e                	slli	a5,a5,0x3
    80004558:	97ae                	add	a5,a5,a1
    8000455a:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    8000455e:	f3040513          	addi	a0,s0,-208
    80004562:	ba4ff0ef          	jal	80003906 <exec>
    80004566:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004568:	100a0a13          	addi	s4,s4,256
    8000456c:	6088                	ld	a0,0(s1)
    8000456e:	c511                	beqz	a0,8000457a <sys_exec+0xe2>
    kfree(argv[i]);
    80004570:	aadfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004574:	04a1                	addi	s1,s1,8
    80004576:	ff449be3          	bne	s1,s4,8000456c <sys_exec+0xd4>
  return ret;
    8000457a:	854a                	mv	a0,s2
    8000457c:	64be                	ld	s1,456(sp)
    8000457e:	691e                	ld	s2,448(sp)
    80004580:	79fa                	ld	s3,440(sp)
    80004582:	7a5a                	ld	s4,432(sp)
    80004584:	7aba                	ld	s5,424(sp)
    80004586:	7b1a                	ld	s6,416(sp)
    80004588:	6bfa                	ld	s7,408(sp)
    8000458a:	a809                	j	8000459c <sys_exec+0x104>
  return -1;
    8000458c:	557d                	li	a0,-1
    8000458e:	64be                	ld	s1,456(sp)
    80004590:	691e                	ld	s2,448(sp)
    80004592:	79fa                	ld	s3,440(sp)
    80004594:	7a5a                	ld	s4,432(sp)
    80004596:	7aba                	ld	s5,424(sp)
    80004598:	7b1a                	ld	s6,416(sp)
    8000459a:	6bfa                	ld	s7,408(sp)
}
    8000459c:	60fe                	ld	ra,472(sp)
    8000459e:	645e                	ld	s0,464(sp)
    800045a0:	613d                	addi	sp,sp,480
    800045a2:	8082                	ret

00000000800045a4 <sys_pipe>:

uint64
sys_pipe(void)
{
    800045a4:	7139                	addi	sp,sp,-64
    800045a6:	fc06                	sd	ra,56(sp)
    800045a8:	f822                	sd	s0,48(sp)
    800045aa:	f426                	sd	s1,40(sp)
    800045ac:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800045ae:	faefc0ef          	jal	80000d5c <myproc>
    800045b2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800045b4:	fd840593          	addi	a1,s0,-40
    800045b8:	4501                	li	a0,0
    800045ba:	e70fd0ef          	jal	80001c2a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800045be:	fc840593          	addi	a1,s0,-56
    800045c2:	fd040513          	addi	a0,s0,-48
    800045c6:	81eff0ef          	jal	800035e4 <pipealloc>
    return -1;
    800045ca:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800045cc:	0a054463          	bltz	a0,80004674 <sys_pipe+0xd0>
  fd0 = -1;
    800045d0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800045d4:	fd043503          	ld	a0,-48(s0)
    800045d8:	edeff0ef          	jal	80003cb6 <fdalloc>
    800045dc:	fca42223          	sw	a0,-60(s0)
    800045e0:	08054163          	bltz	a0,80004662 <sys_pipe+0xbe>
    800045e4:	fc843503          	ld	a0,-56(s0)
    800045e8:	eceff0ef          	jal	80003cb6 <fdalloc>
    800045ec:	fca42023          	sw	a0,-64(s0)
    800045f0:	06054063          	bltz	a0,80004650 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045f4:	4691                	li	a3,4
    800045f6:	fc440613          	addi	a2,s0,-60
    800045fa:	fd843583          	ld	a1,-40(s0)
    800045fe:	68a8                	ld	a0,80(s1)
    80004600:	c04fc0ef          	jal	80000a04 <copyout>
    80004604:	00054e63          	bltz	a0,80004620 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004608:	4691                	li	a3,4
    8000460a:	fc040613          	addi	a2,s0,-64
    8000460e:	fd843583          	ld	a1,-40(s0)
    80004612:	95b6                	add	a1,a1,a3
    80004614:	68a8                	ld	a0,80(s1)
    80004616:	beefc0ef          	jal	80000a04 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000461a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000461c:	04055c63          	bgez	a0,80004674 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004620:	fc442783          	lw	a5,-60(s0)
    80004624:	07e9                	addi	a5,a5,26
    80004626:	078e                	slli	a5,a5,0x3
    80004628:	97a6                	add	a5,a5,s1
    8000462a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000462e:	fc042783          	lw	a5,-64(s0)
    80004632:	07e9                	addi	a5,a5,26
    80004634:	078e                	slli	a5,a5,0x3
    80004636:	94be                	add	s1,s1,a5
    80004638:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000463c:	fd043503          	ld	a0,-48(s0)
    80004640:	c95fe0ef          	jal	800032d4 <fileclose>
    fileclose(wf);
    80004644:	fc843503          	ld	a0,-56(s0)
    80004648:	c8dfe0ef          	jal	800032d4 <fileclose>
    return -1;
    8000464c:	57fd                	li	a5,-1
    8000464e:	a01d                	j	80004674 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004650:	fc442783          	lw	a5,-60(s0)
    80004654:	0007c763          	bltz	a5,80004662 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004658:	07e9                	addi	a5,a5,26
    8000465a:	078e                	slli	a5,a5,0x3
    8000465c:	97a6                	add	a5,a5,s1
    8000465e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004662:	fd043503          	ld	a0,-48(s0)
    80004666:	c6ffe0ef          	jal	800032d4 <fileclose>
    fileclose(wf);
    8000466a:	fc843503          	ld	a0,-56(s0)
    8000466e:	c67fe0ef          	jal	800032d4 <fileclose>
    return -1;
    80004672:	57fd                	li	a5,-1
}
    80004674:	853e                	mv	a0,a5
    80004676:	70e2                	ld	ra,56(sp)
    80004678:	7442                	ld	s0,48(sp)
    8000467a:	74a2                	ld	s1,40(sp)
    8000467c:	6121                	addi	sp,sp,64
    8000467e:	8082                	ret

0000000080004680 <kernelvec>:
    80004680:	7111                	addi	sp,sp,-256
    80004682:	e006                	sd	ra,0(sp)
    80004684:	e40a                	sd	sp,8(sp)
    80004686:	e80e                	sd	gp,16(sp)
    80004688:	ec12                	sd	tp,24(sp)
    8000468a:	f016                	sd	t0,32(sp)
    8000468c:	f41a                	sd	t1,40(sp)
    8000468e:	f81e                	sd	t2,48(sp)
    80004690:	e4aa                	sd	a0,72(sp)
    80004692:	e8ae                	sd	a1,80(sp)
    80004694:	ecb2                	sd	a2,88(sp)
    80004696:	f0b6                	sd	a3,96(sp)
    80004698:	f4ba                	sd	a4,104(sp)
    8000469a:	f8be                	sd	a5,112(sp)
    8000469c:	fcc2                	sd	a6,120(sp)
    8000469e:	e146                	sd	a7,128(sp)
    800046a0:	edf2                	sd	t3,216(sp)
    800046a2:	f1f6                	sd	t4,224(sp)
    800046a4:	f5fa                	sd	t5,232(sp)
    800046a6:	f9fe                	sd	t6,240(sp)
    800046a8:	becfd0ef          	jal	80001a94 <kerneltrap>
    800046ac:	6082                	ld	ra,0(sp)
    800046ae:	6122                	ld	sp,8(sp)
    800046b0:	61c2                	ld	gp,16(sp)
    800046b2:	7282                	ld	t0,32(sp)
    800046b4:	7322                	ld	t1,40(sp)
    800046b6:	73c2                	ld	t2,48(sp)
    800046b8:	6526                	ld	a0,72(sp)
    800046ba:	65c6                	ld	a1,80(sp)
    800046bc:	6666                	ld	a2,88(sp)
    800046be:	7686                	ld	a3,96(sp)
    800046c0:	7726                	ld	a4,104(sp)
    800046c2:	77c6                	ld	a5,112(sp)
    800046c4:	7866                	ld	a6,120(sp)
    800046c6:	688a                	ld	a7,128(sp)
    800046c8:	6e6e                	ld	t3,216(sp)
    800046ca:	7e8e                	ld	t4,224(sp)
    800046cc:	7f2e                	ld	t5,232(sp)
    800046ce:	7fce                	ld	t6,240(sp)
    800046d0:	6111                	addi	sp,sp,256
    800046d2:	10200073          	sret
	...

00000000800046de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800046de:	1141                	addi	sp,sp,-16
    800046e0:	e406                	sd	ra,8(sp)
    800046e2:	e022                	sd	s0,0(sp)
    800046e4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800046e6:	0c000737          	lui	a4,0xc000
    800046ea:	4785                	li	a5,1
    800046ec:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800046ee:	c35c                	sw	a5,4(a4)
}
    800046f0:	60a2                	ld	ra,8(sp)
    800046f2:	6402                	ld	s0,0(sp)
    800046f4:	0141                	addi	sp,sp,16
    800046f6:	8082                	ret

00000000800046f8 <plicinithart>:

void
plicinithart(void)
{
    800046f8:	1141                	addi	sp,sp,-16
    800046fa:	e406                	sd	ra,8(sp)
    800046fc:	e022                	sd	s0,0(sp)
    800046fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004700:	e28fc0ef          	jal	80000d28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004704:	0085171b          	slliw	a4,a0,0x8
    80004708:	0c0027b7          	lui	a5,0xc002
    8000470c:	97ba                	add	a5,a5,a4
    8000470e:	40200713          	li	a4,1026
    80004712:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004716:	00d5151b          	slliw	a0,a0,0xd
    8000471a:	0c2017b7          	lui	a5,0xc201
    8000471e:	97aa                	add	a5,a5,a0
    80004720:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004724:	60a2                	ld	ra,8(sp)
    80004726:	6402                	ld	s0,0(sp)
    80004728:	0141                	addi	sp,sp,16
    8000472a:	8082                	ret

000000008000472c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000472c:	1141                	addi	sp,sp,-16
    8000472e:	e406                	sd	ra,8(sp)
    80004730:	e022                	sd	s0,0(sp)
    80004732:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004734:	df4fc0ef          	jal	80000d28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004738:	00d5151b          	slliw	a0,a0,0xd
    8000473c:	0c2017b7          	lui	a5,0xc201
    80004740:	97aa                	add	a5,a5,a0
  return irq;
}
    80004742:	43c8                	lw	a0,4(a5)
    80004744:	60a2                	ld	ra,8(sp)
    80004746:	6402                	ld	s0,0(sp)
    80004748:	0141                	addi	sp,sp,16
    8000474a:	8082                	ret

000000008000474c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000474c:	1101                	addi	sp,sp,-32
    8000474e:	ec06                	sd	ra,24(sp)
    80004750:	e822                	sd	s0,16(sp)
    80004752:	e426                	sd	s1,8(sp)
    80004754:	1000                	addi	s0,sp,32
    80004756:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004758:	dd0fc0ef          	jal	80000d28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000475c:	00d5179b          	slliw	a5,a0,0xd
    80004760:	0c201737          	lui	a4,0xc201
    80004764:	97ba                	add	a5,a5,a4
    80004766:	c3c4                	sw	s1,4(a5)
}
    80004768:	60e2                	ld	ra,24(sp)
    8000476a:	6442                	ld	s0,16(sp)
    8000476c:	64a2                	ld	s1,8(sp)
    8000476e:	6105                	addi	sp,sp,32
    80004770:	8082                	ret

0000000080004772 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004772:	1141                	addi	sp,sp,-16
    80004774:	e406                	sd	ra,8(sp)
    80004776:	e022                	sd	s0,0(sp)
    80004778:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000477a:	479d                	li	a5,7
    8000477c:	04a7ca63          	blt	a5,a0,800047d0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004780:	00017797          	auipc	a5,0x17
    80004784:	c2078793          	addi	a5,a5,-992 # 8001b3a0 <disk>
    80004788:	97aa                	add	a5,a5,a0
    8000478a:	0187c783          	lbu	a5,24(a5)
    8000478e:	e7b9                	bnez	a5,800047dc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004790:	00451693          	slli	a3,a0,0x4
    80004794:	00017797          	auipc	a5,0x17
    80004798:	c0c78793          	addi	a5,a5,-1012 # 8001b3a0 <disk>
    8000479c:	6398                	ld	a4,0(a5)
    8000479e:	9736                	add	a4,a4,a3
    800047a0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800047a4:	6398                	ld	a4,0(a5)
    800047a6:	9736                	add	a4,a4,a3
    800047a8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800047ac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800047b0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800047b4:	97aa                	add	a5,a5,a0
    800047b6:	4705                	li	a4,1
    800047b8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800047bc:	00017517          	auipc	a0,0x17
    800047c0:	bfc50513          	addi	a0,a0,-1028 # 8001b3b8 <disk+0x18>
    800047c4:	bb3fc0ef          	jal	80001376 <wakeup>
}
    800047c8:	60a2                	ld	ra,8(sp)
    800047ca:	6402                	ld	s0,0(sp)
    800047cc:	0141                	addi	sp,sp,16
    800047ce:	8082                	ret
    panic("free_desc 1");
    800047d0:	00003517          	auipc	a0,0x3
    800047d4:	e4050513          	addi	a0,a0,-448 # 80007610 <etext+0x610>
    800047d8:	40f000ef          	jal	800053e6 <panic>
    panic("free_desc 2");
    800047dc:	00003517          	auipc	a0,0x3
    800047e0:	e4450513          	addi	a0,a0,-444 # 80007620 <etext+0x620>
    800047e4:	403000ef          	jal	800053e6 <panic>

00000000800047e8 <virtio_disk_init>:
{
    800047e8:	1101                	addi	sp,sp,-32
    800047ea:	ec06                	sd	ra,24(sp)
    800047ec:	e822                	sd	s0,16(sp)
    800047ee:	e426                	sd	s1,8(sp)
    800047f0:	e04a                	sd	s2,0(sp)
    800047f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800047f4:	00003597          	auipc	a1,0x3
    800047f8:	e3c58593          	addi	a1,a1,-452 # 80007630 <etext+0x630>
    800047fc:	00017517          	auipc	a0,0x17
    80004800:	ccc50513          	addi	a0,a0,-820 # 8001b4c8 <disk+0x128>
    80004804:	68d000ef          	jal	80005690 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004808:	100017b7          	lui	a5,0x10001
    8000480c:	4398                	lw	a4,0(a5)
    8000480e:	2701                	sext.w	a4,a4
    80004810:	747277b7          	lui	a5,0x74727
    80004814:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004818:	14f71863          	bne	a4,a5,80004968 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000481c:	100017b7          	lui	a5,0x10001
    80004820:	43dc                	lw	a5,4(a5)
    80004822:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004824:	4709                	li	a4,2
    80004826:	14e79163          	bne	a5,a4,80004968 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000482a:	100017b7          	lui	a5,0x10001
    8000482e:	479c                	lw	a5,8(a5)
    80004830:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004832:	12e79b63          	bne	a5,a4,80004968 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004836:	100017b7          	lui	a5,0x10001
    8000483a:	47d8                	lw	a4,12(a5)
    8000483c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000483e:	554d47b7          	lui	a5,0x554d4
    80004842:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004846:	12f71163          	bne	a4,a5,80004968 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000484a:	100017b7          	lui	a5,0x10001
    8000484e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004852:	4705                	li	a4,1
    80004854:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004856:	470d                	li	a4,3
    80004858:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000485a:	10001737          	lui	a4,0x10001
    8000485e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004860:	c7ffe6b7          	lui	a3,0xc7ffe
    80004864:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb17f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004868:	8f75                	and	a4,a4,a3
    8000486a:	100016b7          	lui	a3,0x10001
    8000486e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004870:	472d                	li	a4,11
    80004872:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004874:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004878:	439c                	lw	a5,0(a5)
    8000487a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000487e:	8ba1                	andi	a5,a5,8
    80004880:	0e078a63          	beqz	a5,80004974 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004884:	100017b7          	lui	a5,0x10001
    80004888:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000488c:	43fc                	lw	a5,68(a5)
    8000488e:	2781                	sext.w	a5,a5
    80004890:	0e079863          	bnez	a5,80004980 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004894:	100017b7          	lui	a5,0x10001
    80004898:	5bdc                	lw	a5,52(a5)
    8000489a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000489c:	0e078863          	beqz	a5,8000498c <virtio_disk_init+0x1a4>
  if(max < NUM)
    800048a0:	471d                	li	a4,7
    800048a2:	0ef77b63          	bgeu	a4,a5,80004998 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800048a6:	859fb0ef          	jal	800000fe <kalloc>
    800048aa:	00017497          	auipc	s1,0x17
    800048ae:	af648493          	addi	s1,s1,-1290 # 8001b3a0 <disk>
    800048b2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800048b4:	84bfb0ef          	jal	800000fe <kalloc>
    800048b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800048ba:	845fb0ef          	jal	800000fe <kalloc>
    800048be:	87aa                	mv	a5,a0
    800048c0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800048c2:	6088                	ld	a0,0(s1)
    800048c4:	0e050063          	beqz	a0,800049a4 <virtio_disk_init+0x1bc>
    800048c8:	00017717          	auipc	a4,0x17
    800048cc:	ae073703          	ld	a4,-1312(a4) # 8001b3a8 <disk+0x8>
    800048d0:	cb71                	beqz	a4,800049a4 <virtio_disk_init+0x1bc>
    800048d2:	cbe9                	beqz	a5,800049a4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800048d4:	6605                	lui	a2,0x1
    800048d6:	4581                	li	a1,0
    800048d8:	877fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    800048dc:	00017497          	auipc	s1,0x17
    800048e0:	ac448493          	addi	s1,s1,-1340 # 8001b3a0 <disk>
    800048e4:	6605                	lui	a2,0x1
    800048e6:	4581                	li	a1,0
    800048e8:	6488                	ld	a0,8(s1)
    800048ea:	865fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    800048ee:	6605                	lui	a2,0x1
    800048f0:	4581                	li	a1,0
    800048f2:	6888                	ld	a0,16(s1)
    800048f4:	85bfb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800048f8:	100017b7          	lui	a5,0x10001
    800048fc:	4721                	li	a4,8
    800048fe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004900:	4098                	lw	a4,0(s1)
    80004902:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004906:	40d8                	lw	a4,4(s1)
    80004908:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000490c:	649c                	ld	a5,8(s1)
    8000490e:	0007869b          	sext.w	a3,a5
    80004912:	10001737          	lui	a4,0x10001
    80004916:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000491a:	9781                	srai	a5,a5,0x20
    8000491c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004920:	689c                	ld	a5,16(s1)
    80004922:	0007869b          	sext.w	a3,a5
    80004926:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000492a:	9781                	srai	a5,a5,0x20
    8000492c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004930:	4785                	li	a5,1
    80004932:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004934:	00f48c23          	sb	a5,24(s1)
    80004938:	00f48ca3          	sb	a5,25(s1)
    8000493c:	00f48d23          	sb	a5,26(s1)
    80004940:	00f48da3          	sb	a5,27(s1)
    80004944:	00f48e23          	sb	a5,28(s1)
    80004948:	00f48ea3          	sb	a5,29(s1)
    8000494c:	00f48f23          	sb	a5,30(s1)
    80004950:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004954:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004958:	07272823          	sw	s2,112(a4)
}
    8000495c:	60e2                	ld	ra,24(sp)
    8000495e:	6442                	ld	s0,16(sp)
    80004960:	64a2                	ld	s1,8(sp)
    80004962:	6902                	ld	s2,0(sp)
    80004964:	6105                	addi	sp,sp,32
    80004966:	8082                	ret
    panic("could not find virtio disk");
    80004968:	00003517          	auipc	a0,0x3
    8000496c:	cd850513          	addi	a0,a0,-808 # 80007640 <etext+0x640>
    80004970:	277000ef          	jal	800053e6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004974:	00003517          	auipc	a0,0x3
    80004978:	cec50513          	addi	a0,a0,-788 # 80007660 <etext+0x660>
    8000497c:	26b000ef          	jal	800053e6 <panic>
    panic("virtio disk should not be ready");
    80004980:	00003517          	auipc	a0,0x3
    80004984:	d0050513          	addi	a0,a0,-768 # 80007680 <etext+0x680>
    80004988:	25f000ef          	jal	800053e6 <panic>
    panic("virtio disk has no queue 0");
    8000498c:	00003517          	auipc	a0,0x3
    80004990:	d1450513          	addi	a0,a0,-748 # 800076a0 <etext+0x6a0>
    80004994:	253000ef          	jal	800053e6 <panic>
    panic("virtio disk max queue too short");
    80004998:	00003517          	auipc	a0,0x3
    8000499c:	d2850513          	addi	a0,a0,-728 # 800076c0 <etext+0x6c0>
    800049a0:	247000ef          	jal	800053e6 <panic>
    panic("virtio disk kalloc");
    800049a4:	00003517          	auipc	a0,0x3
    800049a8:	d3c50513          	addi	a0,a0,-708 # 800076e0 <etext+0x6e0>
    800049ac:	23b000ef          	jal	800053e6 <panic>

00000000800049b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800049b0:	711d                	addi	sp,sp,-96
    800049b2:	ec86                	sd	ra,88(sp)
    800049b4:	e8a2                	sd	s0,80(sp)
    800049b6:	e4a6                	sd	s1,72(sp)
    800049b8:	e0ca                	sd	s2,64(sp)
    800049ba:	fc4e                	sd	s3,56(sp)
    800049bc:	f852                	sd	s4,48(sp)
    800049be:	f456                	sd	s5,40(sp)
    800049c0:	f05a                	sd	s6,32(sp)
    800049c2:	ec5e                	sd	s7,24(sp)
    800049c4:	e862                	sd	s8,16(sp)
    800049c6:	1080                	addi	s0,sp,96
    800049c8:	89aa                	mv	s3,a0
    800049ca:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800049cc:	00c52b83          	lw	s7,12(a0)
    800049d0:	001b9b9b          	slliw	s7,s7,0x1
    800049d4:	1b82                	slli	s7,s7,0x20
    800049d6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800049da:	00017517          	auipc	a0,0x17
    800049de:	aee50513          	addi	a0,a0,-1298 # 8001b4c8 <disk+0x128>
    800049e2:	533000ef          	jal	80005714 <acquire>
  for(int i = 0; i < NUM; i++){
    800049e6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800049e8:	00017a97          	auipc	s5,0x17
    800049ec:	9b8a8a93          	addi	s5,s5,-1608 # 8001b3a0 <disk>
  for(int i = 0; i < 3; i++){
    800049f0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800049f2:	5c7d                	li	s8,-1
    800049f4:	a095                	j	80004a58 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800049f6:	00fa8733          	add	a4,s5,a5
    800049fa:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800049fe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a00:	0207c563          	bltz	a5,80004a2a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004a04:	2905                	addiw	s2,s2,1
    80004a06:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a08:	05490c63          	beq	s2,s4,80004a60 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004a0c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a0e:	00017717          	auipc	a4,0x17
    80004a12:	99270713          	addi	a4,a4,-1646 # 8001b3a0 <disk>
    80004a16:	4781                	li	a5,0
    if(disk.free[i]){
    80004a18:	01874683          	lbu	a3,24(a4)
    80004a1c:	fee9                	bnez	a3,800049f6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004a1e:	2785                	addiw	a5,a5,1
    80004a20:	0705                	addi	a4,a4,1
    80004a22:	fe979be3          	bne	a5,s1,80004a18 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004a26:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004a2a:	01205d63          	blez	s2,80004a44 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004a2e:	fa042503          	lw	a0,-96(s0)
    80004a32:	d41ff0ef          	jal	80004772 <free_desc>
      for(int j = 0; j < i; j++)
    80004a36:	4785                	li	a5,1
    80004a38:	0127d663          	bge	a5,s2,80004a44 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004a3c:	fa442503          	lw	a0,-92(s0)
    80004a40:	d33ff0ef          	jal	80004772 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a44:	00017597          	auipc	a1,0x17
    80004a48:	a8458593          	addi	a1,a1,-1404 # 8001b4c8 <disk+0x128>
    80004a4c:	00017517          	auipc	a0,0x17
    80004a50:	96c50513          	addi	a0,a0,-1684 # 8001b3b8 <disk+0x18>
    80004a54:	8d7fc0ef          	jal	8000132a <sleep>
  for(int i = 0; i < 3; i++){
    80004a58:	fa040613          	addi	a2,s0,-96
    80004a5c:	4901                	li	s2,0
    80004a5e:	b77d                	j	80004a0c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a60:	fa042503          	lw	a0,-96(s0)
    80004a64:	00451693          	slli	a3,a0,0x4

  if(write)
    80004a68:	00017797          	auipc	a5,0x17
    80004a6c:	93878793          	addi	a5,a5,-1736 # 8001b3a0 <disk>
    80004a70:	00a50713          	addi	a4,a0,10
    80004a74:	0712                	slli	a4,a4,0x4
    80004a76:	973e                	add	a4,a4,a5
    80004a78:	01603633          	snez	a2,s6
    80004a7c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004a7e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004a82:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a86:	6398                	ld	a4,0(a5)
    80004a88:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a8a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004a8e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a90:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004a92:	6390                	ld	a2,0(a5)
    80004a94:	00d605b3          	add	a1,a2,a3
    80004a98:	4741                	li	a4,16
    80004a9a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004a9c:	4805                	li	a6,1
    80004a9e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004aa2:	fa442703          	lw	a4,-92(s0)
    80004aa6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004aaa:	0712                	slli	a4,a4,0x4
    80004aac:	963a                	add	a2,a2,a4
    80004aae:	05898593          	addi	a1,s3,88
    80004ab2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ab4:	0007b883          	ld	a7,0(a5)
    80004ab8:	9746                	add	a4,a4,a7
    80004aba:	40000613          	li	a2,1024
    80004abe:	c710                	sw	a2,8(a4)
  if(write)
    80004ac0:	001b3613          	seqz	a2,s6
    80004ac4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ac8:	01066633          	or	a2,a2,a6
    80004acc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ad0:	fa842583          	lw	a1,-88(s0)
    80004ad4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ad8:	00250613          	addi	a2,a0,2
    80004adc:	0612                	slli	a2,a2,0x4
    80004ade:	963e                	add	a2,a2,a5
    80004ae0:	577d                	li	a4,-1
    80004ae2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004ae6:	0592                	slli	a1,a1,0x4
    80004ae8:	98ae                	add	a7,a7,a1
    80004aea:	03068713          	addi	a4,a3,48
    80004aee:	973e                	add	a4,a4,a5
    80004af0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004af4:	6398                	ld	a4,0(a5)
    80004af6:	972e                	add	a4,a4,a1
    80004af8:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004afc:	4689                	li	a3,2
    80004afe:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b02:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b06:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004b0a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b0e:	6794                	ld	a3,8(a5)
    80004b10:	0026d703          	lhu	a4,2(a3)
    80004b14:	8b1d                	andi	a4,a4,7
    80004b16:	0706                	slli	a4,a4,0x1
    80004b18:	96ba                	add	a3,a3,a4
    80004b1a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004b1e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b22:	6798                	ld	a4,8(a5)
    80004b24:	00275783          	lhu	a5,2(a4)
    80004b28:	2785                	addiw	a5,a5,1
    80004b2a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b2e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b32:	100017b7          	lui	a5,0x10001
    80004b36:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b3a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004b3e:	00017917          	auipc	s2,0x17
    80004b42:	98a90913          	addi	s2,s2,-1654 # 8001b4c8 <disk+0x128>
  while(b->disk == 1) {
    80004b46:	84c2                	mv	s1,a6
    80004b48:	01079a63          	bne	a5,a6,80004b5c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004b4c:	85ca                	mv	a1,s2
    80004b4e:	854e                	mv	a0,s3
    80004b50:	fdafc0ef          	jal	8000132a <sleep>
  while(b->disk == 1) {
    80004b54:	0049a783          	lw	a5,4(s3)
    80004b58:	fe978ae3          	beq	a5,s1,80004b4c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004b5c:	fa042903          	lw	s2,-96(s0)
    80004b60:	00290713          	addi	a4,s2,2
    80004b64:	0712                	slli	a4,a4,0x4
    80004b66:	00017797          	auipc	a5,0x17
    80004b6a:	83a78793          	addi	a5,a5,-1990 # 8001b3a0 <disk>
    80004b6e:	97ba                	add	a5,a5,a4
    80004b70:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004b74:	00017997          	auipc	s3,0x17
    80004b78:	82c98993          	addi	s3,s3,-2004 # 8001b3a0 <disk>
    80004b7c:	00491713          	slli	a4,s2,0x4
    80004b80:	0009b783          	ld	a5,0(s3)
    80004b84:	97ba                	add	a5,a5,a4
    80004b86:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004b90:	be3ff0ef          	jal	80004772 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004b94:	8885                	andi	s1,s1,1
    80004b96:	f0fd                	bnez	s1,80004b7c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004b98:	00017517          	auipc	a0,0x17
    80004b9c:	93050513          	addi	a0,a0,-1744 # 8001b4c8 <disk+0x128>
    80004ba0:	409000ef          	jal	800057a8 <release>
}
    80004ba4:	60e6                	ld	ra,88(sp)
    80004ba6:	6446                	ld	s0,80(sp)
    80004ba8:	64a6                	ld	s1,72(sp)
    80004baa:	6906                	ld	s2,64(sp)
    80004bac:	79e2                	ld	s3,56(sp)
    80004bae:	7a42                	ld	s4,48(sp)
    80004bb0:	7aa2                	ld	s5,40(sp)
    80004bb2:	7b02                	ld	s6,32(sp)
    80004bb4:	6be2                	ld	s7,24(sp)
    80004bb6:	6c42                	ld	s8,16(sp)
    80004bb8:	6125                	addi	sp,sp,96
    80004bba:	8082                	ret

0000000080004bbc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004bbc:	1101                	addi	sp,sp,-32
    80004bbe:	ec06                	sd	ra,24(sp)
    80004bc0:	e822                	sd	s0,16(sp)
    80004bc2:	e426                	sd	s1,8(sp)
    80004bc4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004bc6:	00016497          	auipc	s1,0x16
    80004bca:	7da48493          	addi	s1,s1,2010 # 8001b3a0 <disk>
    80004bce:	00017517          	auipc	a0,0x17
    80004bd2:	8fa50513          	addi	a0,a0,-1798 # 8001b4c8 <disk+0x128>
    80004bd6:	33f000ef          	jal	80005714 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004bda:	100017b7          	lui	a5,0x10001
    80004bde:	53bc                	lw	a5,96(a5)
    80004be0:	8b8d                	andi	a5,a5,3
    80004be2:	10001737          	lui	a4,0x10001
    80004be6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004be8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004bec:	689c                	ld	a5,16(s1)
    80004bee:	0204d703          	lhu	a4,32(s1)
    80004bf2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004bf6:	04f70663          	beq	a4,a5,80004c42 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004bfa:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004bfe:	6898                	ld	a4,16(s1)
    80004c00:	0204d783          	lhu	a5,32(s1)
    80004c04:	8b9d                	andi	a5,a5,7
    80004c06:	078e                	slli	a5,a5,0x3
    80004c08:	97ba                	add	a5,a5,a4
    80004c0a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c0c:	00278713          	addi	a4,a5,2
    80004c10:	0712                	slli	a4,a4,0x4
    80004c12:	9726                	add	a4,a4,s1
    80004c14:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004c18:	e321                	bnez	a4,80004c58 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c1a:	0789                	addi	a5,a5,2
    80004c1c:	0792                	slli	a5,a5,0x4
    80004c1e:	97a6                	add	a5,a5,s1
    80004c20:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c22:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c26:	f50fc0ef          	jal	80001376 <wakeup>

    disk.used_idx += 1;
    80004c2a:	0204d783          	lhu	a5,32(s1)
    80004c2e:	2785                	addiw	a5,a5,1
    80004c30:	17c2                	slli	a5,a5,0x30
    80004c32:	93c1                	srli	a5,a5,0x30
    80004c34:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c38:	6898                	ld	a4,16(s1)
    80004c3a:	00275703          	lhu	a4,2(a4)
    80004c3e:	faf71ee3          	bne	a4,a5,80004bfa <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004c42:	00017517          	auipc	a0,0x17
    80004c46:	88650513          	addi	a0,a0,-1914 # 8001b4c8 <disk+0x128>
    80004c4a:	35f000ef          	jal	800057a8 <release>
}
    80004c4e:	60e2                	ld	ra,24(sp)
    80004c50:	6442                	ld	s0,16(sp)
    80004c52:	64a2                	ld	s1,8(sp)
    80004c54:	6105                	addi	sp,sp,32
    80004c56:	8082                	ret
      panic("virtio_disk_intr status");
    80004c58:	00003517          	auipc	a0,0x3
    80004c5c:	aa050513          	addi	a0,a0,-1376 # 800076f8 <etext+0x6f8>
    80004c60:	786000ef          	jal	800053e6 <panic>

0000000080004c64 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004c64:	1141                	addi	sp,sp,-16
    80004c66:	e406                	sd	ra,8(sp)
    80004c68:	e022                	sd	s0,0(sp)
    80004c6a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004c6c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004c70:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004c74:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004c78:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004c7c:	577d                	li	a4,-1
    80004c7e:	177e                	slli	a4,a4,0x3f
    80004c80:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004c82:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004c86:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004c8a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004c8e:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004c92:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004c96:	000f4737          	lui	a4,0xf4
    80004c9a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004c9e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004ca0:	14d79073          	csrw	stimecmp,a5
}
    80004ca4:	60a2                	ld	ra,8(sp)
    80004ca6:	6402                	ld	s0,0(sp)
    80004ca8:	0141                	addi	sp,sp,16
    80004caa:	8082                	ret

0000000080004cac <start>:
{
    80004cac:	1141                	addi	sp,sp,-16
    80004cae:	e406                	sd	ra,8(sp)
    80004cb0:	e022                	sd	s0,0(sp)
    80004cb2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004cb4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cb8:	7779                	lui	a4,0xffffe
    80004cba:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb21f>
    80004cbe:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004cc0:	6705                	lui	a4,0x1
    80004cc2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004cc6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004cc8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ccc:	ffffb797          	auipc	a5,0xffffb
    80004cd0:	63878793          	addi	a5,a5,1592 # 80000304 <main>
    80004cd4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004cd8:	4781                	li	a5,0
    80004cda:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004cde:	67c1                	lui	a5,0x10
    80004ce0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ce2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ce6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004cea:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004cee:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004cf2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004cf6:	57fd                	li	a5,-1
    80004cf8:	83a9                	srli	a5,a5,0xa
    80004cfa:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004cfe:	47bd                	li	a5,15
    80004d00:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d04:	f61ff0ef          	jal	80004c64 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d08:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d0c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d0e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d10:	30200073          	mret
}
    80004d14:	60a2                	ld	ra,8(sp)
    80004d16:	6402                	ld	s0,0(sp)
    80004d18:	0141                	addi	sp,sp,16
    80004d1a:	8082                	ret

0000000080004d1c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d1c:	711d                	addi	sp,sp,-96
    80004d1e:	ec86                	sd	ra,88(sp)
    80004d20:	e8a2                	sd	s0,80(sp)
    80004d22:	e0ca                	sd	s2,64(sp)
    80004d24:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004d26:	04c05863          	blez	a2,80004d76 <consolewrite+0x5a>
    80004d2a:	e4a6                	sd	s1,72(sp)
    80004d2c:	fc4e                	sd	s3,56(sp)
    80004d2e:	f852                	sd	s4,48(sp)
    80004d30:	f456                	sd	s5,40(sp)
    80004d32:	f05a                	sd	s6,32(sp)
    80004d34:	ec5e                	sd	s7,24(sp)
    80004d36:	8a2a                	mv	s4,a0
    80004d38:	84ae                	mv	s1,a1
    80004d3a:	89b2                	mv	s3,a2
    80004d3c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d3e:	faf40b93          	addi	s7,s0,-81
    80004d42:	4b05                	li	s6,1
    80004d44:	5afd                	li	s5,-1
    80004d46:	86da                	mv	a3,s6
    80004d48:	8626                	mv	a2,s1
    80004d4a:	85d2                	mv	a1,s4
    80004d4c:	855e                	mv	a0,s7
    80004d4e:	97dfc0ef          	jal	800016ca <either_copyin>
    80004d52:	03550463          	beq	a0,s5,80004d7a <consolewrite+0x5e>
      break;
    uartputc(c);
    80004d56:	faf44503          	lbu	a0,-81(s0)
    80004d5a:	02d000ef          	jal	80005586 <uartputc>
  for(i = 0; i < n; i++){
    80004d5e:	2905                	addiw	s2,s2,1
    80004d60:	0485                	addi	s1,s1,1
    80004d62:	ff2992e3          	bne	s3,s2,80004d46 <consolewrite+0x2a>
    80004d66:	894e                	mv	s2,s3
    80004d68:	64a6                	ld	s1,72(sp)
    80004d6a:	79e2                	ld	s3,56(sp)
    80004d6c:	7a42                	ld	s4,48(sp)
    80004d6e:	7aa2                	ld	s5,40(sp)
    80004d70:	7b02                	ld	s6,32(sp)
    80004d72:	6be2                	ld	s7,24(sp)
    80004d74:	a809                	j	80004d86 <consolewrite+0x6a>
    80004d76:	4901                	li	s2,0
    80004d78:	a039                	j	80004d86 <consolewrite+0x6a>
    80004d7a:	64a6                	ld	s1,72(sp)
    80004d7c:	79e2                	ld	s3,56(sp)
    80004d7e:	7a42                	ld	s4,48(sp)
    80004d80:	7aa2                	ld	s5,40(sp)
    80004d82:	7b02                	ld	s6,32(sp)
    80004d84:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004d86:	854a                	mv	a0,s2
    80004d88:	60e6                	ld	ra,88(sp)
    80004d8a:	6446                	ld	s0,80(sp)
    80004d8c:	6906                	ld	s2,64(sp)
    80004d8e:	6125                	addi	sp,sp,96
    80004d90:	8082                	ret

0000000080004d92 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004d92:	711d                	addi	sp,sp,-96
    80004d94:	ec86                	sd	ra,88(sp)
    80004d96:	e8a2                	sd	s0,80(sp)
    80004d98:	e4a6                	sd	s1,72(sp)
    80004d9a:	e0ca                	sd	s2,64(sp)
    80004d9c:	fc4e                	sd	s3,56(sp)
    80004d9e:	f852                	sd	s4,48(sp)
    80004da0:	f456                	sd	s5,40(sp)
    80004da2:	f05a                	sd	s6,32(sp)
    80004da4:	1080                	addi	s0,sp,96
    80004da6:	8aaa                	mv	s5,a0
    80004da8:	8a2e                	mv	s4,a1
    80004daa:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004dac:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004dae:	0001e517          	auipc	a0,0x1e
    80004db2:	73250513          	addi	a0,a0,1842 # 800234e0 <cons>
    80004db6:	15f000ef          	jal	80005714 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004dba:	0001e497          	auipc	s1,0x1e
    80004dbe:	72648493          	addi	s1,s1,1830 # 800234e0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004dc2:	0001e917          	auipc	s2,0x1e
    80004dc6:	7b690913          	addi	s2,s2,1974 # 80023578 <cons+0x98>
  while(n > 0){
    80004dca:	0b305b63          	blez	s3,80004e80 <consoleread+0xee>
    while(cons.r == cons.w){
    80004dce:	0984a783          	lw	a5,152(s1)
    80004dd2:	09c4a703          	lw	a4,156(s1)
    80004dd6:	0af71063          	bne	a4,a5,80004e76 <consoleread+0xe4>
      if(killed(myproc())){
    80004dda:	f83fb0ef          	jal	80000d5c <myproc>
    80004dde:	f84fc0ef          	jal	80001562 <killed>
    80004de2:	e12d                	bnez	a0,80004e44 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004de4:	85a6                	mv	a1,s1
    80004de6:	854a                	mv	a0,s2
    80004de8:	d42fc0ef          	jal	8000132a <sleep>
    while(cons.r == cons.w){
    80004dec:	0984a783          	lw	a5,152(s1)
    80004df0:	09c4a703          	lw	a4,156(s1)
    80004df4:	fef703e3          	beq	a4,a5,80004dda <consoleread+0x48>
    80004df8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004dfa:	0001e717          	auipc	a4,0x1e
    80004dfe:	6e670713          	addi	a4,a4,1766 # 800234e0 <cons>
    80004e02:	0017869b          	addiw	a3,a5,1
    80004e06:	08d72c23          	sw	a3,152(a4)
    80004e0a:	07f7f693          	andi	a3,a5,127
    80004e0e:	9736                	add	a4,a4,a3
    80004e10:	01874703          	lbu	a4,24(a4)
    80004e14:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004e18:	4691                	li	a3,4
    80004e1a:	04db8663          	beq	s7,a3,80004e66 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004e1e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e22:	4685                	li	a3,1
    80004e24:	faf40613          	addi	a2,s0,-81
    80004e28:	85d2                	mv	a1,s4
    80004e2a:	8556                	mv	a0,s5
    80004e2c:	855fc0ef          	jal	80001680 <either_copyout>
    80004e30:	57fd                	li	a5,-1
    80004e32:	04f50663          	beq	a0,a5,80004e7e <consoleread+0xec>
      break;

    dst++;
    80004e36:	0a05                	addi	s4,s4,1
    --n;
    80004e38:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004e3a:	47a9                	li	a5,10
    80004e3c:	04fb8b63          	beq	s7,a5,80004e92 <consoleread+0x100>
    80004e40:	6be2                	ld	s7,24(sp)
    80004e42:	b761                	j	80004dca <consoleread+0x38>
        release(&cons.lock);
    80004e44:	0001e517          	auipc	a0,0x1e
    80004e48:	69c50513          	addi	a0,a0,1692 # 800234e0 <cons>
    80004e4c:	15d000ef          	jal	800057a8 <release>
        return -1;
    80004e50:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004e52:	60e6                	ld	ra,88(sp)
    80004e54:	6446                	ld	s0,80(sp)
    80004e56:	64a6                	ld	s1,72(sp)
    80004e58:	6906                	ld	s2,64(sp)
    80004e5a:	79e2                	ld	s3,56(sp)
    80004e5c:	7a42                	ld	s4,48(sp)
    80004e5e:	7aa2                	ld	s5,40(sp)
    80004e60:	7b02                	ld	s6,32(sp)
    80004e62:	6125                	addi	sp,sp,96
    80004e64:	8082                	ret
      if(n < target){
    80004e66:	0169fa63          	bgeu	s3,s6,80004e7a <consoleread+0xe8>
        cons.r--;
    80004e6a:	0001e717          	auipc	a4,0x1e
    80004e6e:	70f72723          	sw	a5,1806(a4) # 80023578 <cons+0x98>
    80004e72:	6be2                	ld	s7,24(sp)
    80004e74:	a031                	j	80004e80 <consoleread+0xee>
    80004e76:	ec5e                	sd	s7,24(sp)
    80004e78:	b749                	j	80004dfa <consoleread+0x68>
    80004e7a:	6be2                	ld	s7,24(sp)
    80004e7c:	a011                	j	80004e80 <consoleread+0xee>
    80004e7e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004e80:	0001e517          	auipc	a0,0x1e
    80004e84:	66050513          	addi	a0,a0,1632 # 800234e0 <cons>
    80004e88:	121000ef          	jal	800057a8 <release>
  return target - n;
    80004e8c:	413b053b          	subw	a0,s6,s3
    80004e90:	b7c9                	j	80004e52 <consoleread+0xc0>
    80004e92:	6be2                	ld	s7,24(sp)
    80004e94:	b7f5                	j	80004e80 <consoleread+0xee>

0000000080004e96 <consputc>:
{
    80004e96:	1141                	addi	sp,sp,-16
    80004e98:	e406                	sd	ra,8(sp)
    80004e9a:	e022                	sd	s0,0(sp)
    80004e9c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004e9e:	10000793          	li	a5,256
    80004ea2:	00f50863          	beq	a0,a5,80004eb2 <consputc+0x1c>
    uartputc_sync(c);
    80004ea6:	5fe000ef          	jal	800054a4 <uartputc_sync>
}
    80004eaa:	60a2                	ld	ra,8(sp)
    80004eac:	6402                	ld	s0,0(sp)
    80004eae:	0141                	addi	sp,sp,16
    80004eb0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004eb2:	4521                	li	a0,8
    80004eb4:	5f0000ef          	jal	800054a4 <uartputc_sync>
    80004eb8:	02000513          	li	a0,32
    80004ebc:	5e8000ef          	jal	800054a4 <uartputc_sync>
    80004ec0:	4521                	li	a0,8
    80004ec2:	5e2000ef          	jal	800054a4 <uartputc_sync>
    80004ec6:	b7d5                	j	80004eaa <consputc+0x14>

0000000080004ec8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ec8:	7179                	addi	sp,sp,-48
    80004eca:	f406                	sd	ra,40(sp)
    80004ecc:	f022                	sd	s0,32(sp)
    80004ece:	ec26                	sd	s1,24(sp)
    80004ed0:	1800                	addi	s0,sp,48
    80004ed2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004ed4:	0001e517          	auipc	a0,0x1e
    80004ed8:	60c50513          	addi	a0,a0,1548 # 800234e0 <cons>
    80004edc:	039000ef          	jal	80005714 <acquire>

  switch(c){
    80004ee0:	47d5                	li	a5,21
    80004ee2:	08f48e63          	beq	s1,a5,80004f7e <consoleintr+0xb6>
    80004ee6:	0297c563          	blt	a5,s1,80004f10 <consoleintr+0x48>
    80004eea:	47a1                	li	a5,8
    80004eec:	0ef48863          	beq	s1,a5,80004fdc <consoleintr+0x114>
    80004ef0:	47c1                	li	a5,16
    80004ef2:	10f49963          	bne	s1,a5,80005004 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80004ef6:	81ffc0ef          	jal	80001714 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004efa:	0001e517          	auipc	a0,0x1e
    80004efe:	5e650513          	addi	a0,a0,1510 # 800234e0 <cons>
    80004f02:	0a7000ef          	jal	800057a8 <release>
}
    80004f06:	70a2                	ld	ra,40(sp)
    80004f08:	7402                	ld	s0,32(sp)
    80004f0a:	64e2                	ld	s1,24(sp)
    80004f0c:	6145                	addi	sp,sp,48
    80004f0e:	8082                	ret
  switch(c){
    80004f10:	07f00793          	li	a5,127
    80004f14:	0cf48463          	beq	s1,a5,80004fdc <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f18:	0001e717          	auipc	a4,0x1e
    80004f1c:	5c870713          	addi	a4,a4,1480 # 800234e0 <cons>
    80004f20:	0a072783          	lw	a5,160(a4)
    80004f24:	09872703          	lw	a4,152(a4)
    80004f28:	9f99                	subw	a5,a5,a4
    80004f2a:	07f00713          	li	a4,127
    80004f2e:	fcf766e3          	bltu	a4,a5,80004efa <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004f32:	47b5                	li	a5,13
    80004f34:	0cf48b63          	beq	s1,a5,8000500a <consoleintr+0x142>
      consputc(c);
    80004f38:	8526                	mv	a0,s1
    80004f3a:	f5dff0ef          	jal	80004e96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f3e:	0001e797          	auipc	a5,0x1e
    80004f42:	5a278793          	addi	a5,a5,1442 # 800234e0 <cons>
    80004f46:	0a07a683          	lw	a3,160(a5)
    80004f4a:	0016871b          	addiw	a4,a3,1
    80004f4e:	863a                	mv	a2,a4
    80004f50:	0ae7a023          	sw	a4,160(a5)
    80004f54:	07f6f693          	andi	a3,a3,127
    80004f58:	97b6                	add	a5,a5,a3
    80004f5a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004f5e:	47a9                	li	a5,10
    80004f60:	0cf48963          	beq	s1,a5,80005032 <consoleintr+0x16a>
    80004f64:	4791                	li	a5,4
    80004f66:	0cf48663          	beq	s1,a5,80005032 <consoleintr+0x16a>
    80004f6a:	0001e797          	auipc	a5,0x1e
    80004f6e:	60e7a783          	lw	a5,1550(a5) # 80023578 <cons+0x98>
    80004f72:	9f1d                	subw	a4,a4,a5
    80004f74:	08000793          	li	a5,128
    80004f78:	f8f711e3          	bne	a4,a5,80004efa <consoleintr+0x32>
    80004f7c:	a85d                	j	80005032 <consoleintr+0x16a>
    80004f7e:	e84a                	sd	s2,16(sp)
    80004f80:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80004f82:	0001e717          	auipc	a4,0x1e
    80004f86:	55e70713          	addi	a4,a4,1374 # 800234e0 <cons>
    80004f8a:	0a072783          	lw	a5,160(a4)
    80004f8e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004f92:	0001e497          	auipc	s1,0x1e
    80004f96:	54e48493          	addi	s1,s1,1358 # 800234e0 <cons>
    while(cons.e != cons.w &&
    80004f9a:	4929                	li	s2,10
      consputc(BACKSPACE);
    80004f9c:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80004fa0:	02f70863          	beq	a4,a5,80004fd0 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fa4:	37fd                	addiw	a5,a5,-1
    80004fa6:	07f7f713          	andi	a4,a5,127
    80004faa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fac:	01874703          	lbu	a4,24(a4)
    80004fb0:	03270363          	beq	a4,s2,80004fd6 <consoleintr+0x10e>
      cons.e--;
    80004fb4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004fb8:	854e                	mv	a0,s3
    80004fba:	eddff0ef          	jal	80004e96 <consputc>
    while(cons.e != cons.w &&
    80004fbe:	0a04a783          	lw	a5,160(s1)
    80004fc2:	09c4a703          	lw	a4,156(s1)
    80004fc6:	fcf71fe3          	bne	a4,a5,80004fa4 <consoleintr+0xdc>
    80004fca:	6942                	ld	s2,16(sp)
    80004fcc:	69a2                	ld	s3,8(sp)
    80004fce:	b735                	j	80004efa <consoleintr+0x32>
    80004fd0:	6942                	ld	s2,16(sp)
    80004fd2:	69a2                	ld	s3,8(sp)
    80004fd4:	b71d                	j	80004efa <consoleintr+0x32>
    80004fd6:	6942                	ld	s2,16(sp)
    80004fd8:	69a2                	ld	s3,8(sp)
    80004fda:	b705                	j	80004efa <consoleintr+0x32>
    if(cons.e != cons.w){
    80004fdc:	0001e717          	auipc	a4,0x1e
    80004fe0:	50470713          	addi	a4,a4,1284 # 800234e0 <cons>
    80004fe4:	0a072783          	lw	a5,160(a4)
    80004fe8:	09c72703          	lw	a4,156(a4)
    80004fec:	f0f707e3          	beq	a4,a5,80004efa <consoleintr+0x32>
      cons.e--;
    80004ff0:	37fd                	addiw	a5,a5,-1
    80004ff2:	0001e717          	auipc	a4,0x1e
    80004ff6:	58f72723          	sw	a5,1422(a4) # 80023580 <cons+0xa0>
      consputc(BACKSPACE);
    80004ffa:	10000513          	li	a0,256
    80004ffe:	e99ff0ef          	jal	80004e96 <consputc>
    80005002:	bde5                	j	80004efa <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005004:	ee048be3          	beqz	s1,80004efa <consoleintr+0x32>
    80005008:	bf01                	j	80004f18 <consoleintr+0x50>
      consputc(c);
    8000500a:	4529                	li	a0,10
    8000500c:	e8bff0ef          	jal	80004e96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005010:	0001e797          	auipc	a5,0x1e
    80005014:	4d078793          	addi	a5,a5,1232 # 800234e0 <cons>
    80005018:	0a07a703          	lw	a4,160(a5)
    8000501c:	0017069b          	addiw	a3,a4,1
    80005020:	8636                	mv	a2,a3
    80005022:	0ad7a023          	sw	a3,160(a5)
    80005026:	07f77713          	andi	a4,a4,127
    8000502a:	97ba                	add	a5,a5,a4
    8000502c:	4729                	li	a4,10
    8000502e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005032:	0001e797          	auipc	a5,0x1e
    80005036:	54c7a523          	sw	a2,1354(a5) # 8002357c <cons+0x9c>
        wakeup(&cons.r);
    8000503a:	0001e517          	auipc	a0,0x1e
    8000503e:	53e50513          	addi	a0,a0,1342 # 80023578 <cons+0x98>
    80005042:	b34fc0ef          	jal	80001376 <wakeup>
    80005046:	bd55                	j	80004efa <consoleintr+0x32>

0000000080005048 <consoleinit>:

void
consoleinit(void)
{
    80005048:	1141                	addi	sp,sp,-16
    8000504a:	e406                	sd	ra,8(sp)
    8000504c:	e022                	sd	s0,0(sp)
    8000504e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005050:	00002597          	auipc	a1,0x2
    80005054:	6c058593          	addi	a1,a1,1728 # 80007710 <etext+0x710>
    80005058:	0001e517          	auipc	a0,0x1e
    8000505c:	48850513          	addi	a0,a0,1160 # 800234e0 <cons>
    80005060:	630000ef          	jal	80005690 <initlock>

  uartinit();
    80005064:	3ea000ef          	jal	8000544e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005068:	00015797          	auipc	a5,0x15
    8000506c:	2e078793          	addi	a5,a5,736 # 8001a348 <devsw>
    80005070:	00000717          	auipc	a4,0x0
    80005074:	d2270713          	addi	a4,a4,-734 # 80004d92 <consoleread>
    80005078:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000507a:	00000717          	auipc	a4,0x0
    8000507e:	ca270713          	addi	a4,a4,-862 # 80004d1c <consolewrite>
    80005082:	ef98                	sd	a4,24(a5)
}
    80005084:	60a2                	ld	ra,8(sp)
    80005086:	6402                	ld	s0,0(sp)
    80005088:	0141                	addi	sp,sp,16
    8000508a:	8082                	ret

000000008000508c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000508c:	7179                	addi	sp,sp,-48
    8000508e:	f406                	sd	ra,40(sp)
    80005090:	f022                	sd	s0,32(sp)
    80005092:	ec26                	sd	s1,24(sp)
    80005094:	e84a                	sd	s2,16(sp)
    80005096:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005098:	c219                	beqz	a2,8000509e <printint+0x12>
    8000509a:	06054a63          	bltz	a0,8000510e <printint+0x82>
    x = -xx;
  else
    x = xx;
    8000509e:	4e01                	li	t3,0

  i = 0;
    800050a0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800050a4:	869a                	mv	a3,t1
  i = 0;
    800050a6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050a8:	00002817          	auipc	a6,0x2
    800050ac:	7c080813          	addi	a6,a6,1984 # 80007868 <digits>
    800050b0:	88be                	mv	a7,a5
    800050b2:	0017861b          	addiw	a2,a5,1
    800050b6:	87b2                	mv	a5,a2
    800050b8:	02b57733          	remu	a4,a0,a1
    800050bc:	9742                	add	a4,a4,a6
    800050be:	00074703          	lbu	a4,0(a4)
    800050c2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050c6:	872a                	mv	a4,a0
    800050c8:	02b55533          	divu	a0,a0,a1
    800050cc:	0685                	addi	a3,a3,1
    800050ce:	feb771e3          	bgeu	a4,a1,800050b0 <printint+0x24>

  if(sign)
    800050d2:	000e0c63          	beqz	t3,800050ea <printint+0x5e>
    buf[i++] = '-';
    800050d6:	fe060793          	addi	a5,a2,-32
    800050da:	00878633          	add	a2,a5,s0
    800050de:	02d00793          	li	a5,45
    800050e2:	fef60823          	sb	a5,-16(a2)
    800050e6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800050ea:	fff7891b          	addiw	s2,a5,-1
    800050ee:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800050f2:	fff4c503          	lbu	a0,-1(s1)
    800050f6:	da1ff0ef          	jal	80004e96 <consputc>
  while(--i >= 0)
    800050fa:	397d                	addiw	s2,s2,-1
    800050fc:	14fd                	addi	s1,s1,-1
    800050fe:	fe095ae3          	bgez	s2,800050f2 <printint+0x66>
}
    80005102:	70a2                	ld	ra,40(sp)
    80005104:	7402                	ld	s0,32(sp)
    80005106:	64e2                	ld	s1,24(sp)
    80005108:	6942                	ld	s2,16(sp)
    8000510a:	6145                	addi	sp,sp,48
    8000510c:	8082                	ret
    x = -xx;
    8000510e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005112:	4e05                	li	t3,1
    x = -xx;
    80005114:	b771                	j	800050a0 <printint+0x14>

0000000080005116 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005116:	7155                	addi	sp,sp,-208
    80005118:	e506                	sd	ra,136(sp)
    8000511a:	e122                	sd	s0,128(sp)
    8000511c:	f0d2                	sd	s4,96(sp)
    8000511e:	0900                	addi	s0,sp,144
    80005120:	8a2a                	mv	s4,a0
    80005122:	e40c                	sd	a1,8(s0)
    80005124:	e810                	sd	a2,16(s0)
    80005126:	ec14                	sd	a3,24(s0)
    80005128:	f018                	sd	a4,32(s0)
    8000512a:	f41c                	sd	a5,40(s0)
    8000512c:	03043823          	sd	a6,48(s0)
    80005130:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005134:	0001e797          	auipc	a5,0x1e
    80005138:	46c7a783          	lw	a5,1132(a5) # 800235a0 <pr+0x18>
    8000513c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005140:	e3a1                	bnez	a5,80005180 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005142:	00840793          	addi	a5,s0,8
    80005146:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000514a:	00054503          	lbu	a0,0(a0)
    8000514e:	26050663          	beqz	a0,800053ba <printf+0x2a4>
    80005152:	fca6                	sd	s1,120(sp)
    80005154:	f8ca                	sd	s2,112(sp)
    80005156:	f4ce                	sd	s3,104(sp)
    80005158:	ecd6                	sd	s5,88(sp)
    8000515a:	e8da                	sd	s6,80(sp)
    8000515c:	e0e2                	sd	s8,64(sp)
    8000515e:	fc66                	sd	s9,56(sp)
    80005160:	f86a                	sd	s10,48(sp)
    80005162:	f46e                	sd	s11,40(sp)
    80005164:	4981                	li	s3,0
    if(cx != '%'){
    80005166:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000516a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000516e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005172:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005176:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000517a:	07000d93          	li	s11,112
    8000517e:	a80d                	j	800051b0 <printf+0x9a>
    acquire(&pr.lock);
    80005180:	0001e517          	auipc	a0,0x1e
    80005184:	40850513          	addi	a0,a0,1032 # 80023588 <pr>
    80005188:	58c000ef          	jal	80005714 <acquire>
  va_start(ap, fmt);
    8000518c:	00840793          	addi	a5,s0,8
    80005190:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005194:	000a4503          	lbu	a0,0(s4)
    80005198:	fd4d                	bnez	a0,80005152 <printf+0x3c>
    8000519a:	ac3d                	j	800053d8 <printf+0x2c2>
      consputc(cx);
    8000519c:	cfbff0ef          	jal	80004e96 <consputc>
      continue;
    800051a0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051a2:	2485                	addiw	s1,s1,1
    800051a4:	89a6                	mv	s3,s1
    800051a6:	94d2                	add	s1,s1,s4
    800051a8:	0004c503          	lbu	a0,0(s1)
    800051ac:	1e050b63          	beqz	a0,800053a2 <printf+0x28c>
    if(cx != '%'){
    800051b0:	ff5516e3          	bne	a0,s5,8000519c <printf+0x86>
    i++;
    800051b4:	0019879b          	addiw	a5,s3,1
    800051b8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800051ba:	00fa0733          	add	a4,s4,a5
    800051be:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051c2:	1e090063          	beqz	s2,800053a2 <printf+0x28c>
    800051c6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800051ca:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800051cc:	c701                	beqz	a4,800051d4 <printf+0xbe>
    800051ce:	97d2                	add	a5,a5,s4
    800051d0:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    800051d4:	03690763          	beq	s2,s6,80005202 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    800051d8:	05890163          	beq	s2,s8,8000521a <printf+0x104>
    } else if(c0 == 'u'){
    800051dc:	0d990b63          	beq	s2,s9,800052b2 <printf+0x19c>
    } else if(c0 == 'x'){
    800051e0:	13a90163          	beq	s2,s10,80005302 <printf+0x1ec>
    } else if(c0 == 'p'){
    800051e4:	13b90b63          	beq	s2,s11,8000531a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800051e8:	07300793          	li	a5,115
    800051ec:	16f90a63          	beq	s2,a5,80005360 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800051f0:	1b590463          	beq	s2,s5,80005398 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800051f4:	8556                	mv	a0,s5
    800051f6:	ca1ff0ef          	jal	80004e96 <consputc>
      consputc(c0);
    800051fa:	854a                	mv	a0,s2
    800051fc:	c9bff0ef          	jal	80004e96 <consputc>
    80005200:	b74d                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005202:	f8843783          	ld	a5,-120(s0)
    80005206:	00878713          	addi	a4,a5,8
    8000520a:	f8e43423          	sd	a4,-120(s0)
    8000520e:	4605                	li	a2,1
    80005210:	45a9                	li	a1,10
    80005212:	4388                	lw	a0,0(a5)
    80005214:	e79ff0ef          	jal	8000508c <printint>
    80005218:	b769                	j	800051a2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000521a:	03670663          	beq	a4,s6,80005246 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000521e:	05870263          	beq	a4,s8,80005262 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005222:	0b970463          	beq	a4,s9,800052ca <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005226:	fda717e3          	bne	a4,s10,800051f4 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000522a:	f8843783          	ld	a5,-120(s0)
    8000522e:	00878713          	addi	a4,a5,8
    80005232:	f8e43423          	sd	a4,-120(s0)
    80005236:	4601                	li	a2,0
    80005238:	45c1                	li	a1,16
    8000523a:	6388                	ld	a0,0(a5)
    8000523c:	e51ff0ef          	jal	8000508c <printint>
      i += 1;
    80005240:	0029849b          	addiw	s1,s3,2
    80005244:	bfb9                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005246:	f8843783          	ld	a5,-120(s0)
    8000524a:	00878713          	addi	a4,a5,8
    8000524e:	f8e43423          	sd	a4,-120(s0)
    80005252:	4605                	li	a2,1
    80005254:	45a9                	li	a1,10
    80005256:	6388                	ld	a0,0(a5)
    80005258:	e35ff0ef          	jal	8000508c <printint>
      i += 1;
    8000525c:	0029849b          	addiw	s1,s3,2
    80005260:	b789                	j	800051a2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005262:	06400793          	li	a5,100
    80005266:	02f68863          	beq	a3,a5,80005296 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000526a:	07500793          	li	a5,117
    8000526e:	06f68c63          	beq	a3,a5,800052e6 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005272:	07800793          	li	a5,120
    80005276:	f6f69fe3          	bne	a3,a5,800051f4 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000527a:	f8843783          	ld	a5,-120(s0)
    8000527e:	00878713          	addi	a4,a5,8
    80005282:	f8e43423          	sd	a4,-120(s0)
    80005286:	4601                	li	a2,0
    80005288:	45c1                	li	a1,16
    8000528a:	6388                	ld	a0,0(a5)
    8000528c:	e01ff0ef          	jal	8000508c <printint>
      i += 2;
    80005290:	0039849b          	addiw	s1,s3,3
    80005294:	b739                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005296:	f8843783          	ld	a5,-120(s0)
    8000529a:	00878713          	addi	a4,a5,8
    8000529e:	f8e43423          	sd	a4,-120(s0)
    800052a2:	4605                	li	a2,1
    800052a4:	45a9                	li	a1,10
    800052a6:	6388                	ld	a0,0(a5)
    800052a8:	de5ff0ef          	jal	8000508c <printint>
      i += 2;
    800052ac:	0039849b          	addiw	s1,s3,3
    800052b0:	bdcd                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800052b2:	f8843783          	ld	a5,-120(s0)
    800052b6:	00878713          	addi	a4,a5,8
    800052ba:	f8e43423          	sd	a4,-120(s0)
    800052be:	4601                	li	a2,0
    800052c0:	45a9                	li	a1,10
    800052c2:	4388                	lw	a0,0(a5)
    800052c4:	dc9ff0ef          	jal	8000508c <printint>
    800052c8:	bde9                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052ca:	f8843783          	ld	a5,-120(s0)
    800052ce:	00878713          	addi	a4,a5,8
    800052d2:	f8e43423          	sd	a4,-120(s0)
    800052d6:	4601                	li	a2,0
    800052d8:	45a9                	li	a1,10
    800052da:	6388                	ld	a0,0(a5)
    800052dc:	db1ff0ef          	jal	8000508c <printint>
      i += 1;
    800052e0:	0029849b          	addiw	s1,s3,2
    800052e4:	bd7d                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052e6:	f8843783          	ld	a5,-120(s0)
    800052ea:	00878713          	addi	a4,a5,8
    800052ee:	f8e43423          	sd	a4,-120(s0)
    800052f2:	4601                	li	a2,0
    800052f4:	45a9                	li	a1,10
    800052f6:	6388                	ld	a0,0(a5)
    800052f8:	d95ff0ef          	jal	8000508c <printint>
      i += 2;
    800052fc:	0039849b          	addiw	s1,s3,3
    80005300:	b54d                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005302:	f8843783          	ld	a5,-120(s0)
    80005306:	00878713          	addi	a4,a5,8
    8000530a:	f8e43423          	sd	a4,-120(s0)
    8000530e:	4601                	li	a2,0
    80005310:	45c1                	li	a1,16
    80005312:	4388                	lw	a0,0(a5)
    80005314:	d79ff0ef          	jal	8000508c <printint>
    80005318:	b569                	j	800051a2 <printf+0x8c>
    8000531a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000531c:	f8843783          	ld	a5,-120(s0)
    80005320:	00878713          	addi	a4,a5,8
    80005324:	f8e43423          	sd	a4,-120(s0)
    80005328:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000532c:	03000513          	li	a0,48
    80005330:	b67ff0ef          	jal	80004e96 <consputc>
  consputc('x');
    80005334:	07800513          	li	a0,120
    80005338:	b5fff0ef          	jal	80004e96 <consputc>
    8000533c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000533e:	00002b97          	auipc	s7,0x2
    80005342:	52ab8b93          	addi	s7,s7,1322 # 80007868 <digits>
    80005346:	03c9d793          	srli	a5,s3,0x3c
    8000534a:	97de                	add	a5,a5,s7
    8000534c:	0007c503          	lbu	a0,0(a5)
    80005350:	b47ff0ef          	jal	80004e96 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005354:	0992                	slli	s3,s3,0x4
    80005356:	397d                	addiw	s2,s2,-1
    80005358:	fe0917e3          	bnez	s2,80005346 <printf+0x230>
    8000535c:	6ba6                	ld	s7,72(sp)
    8000535e:	b591                	j	800051a2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005360:	f8843783          	ld	a5,-120(s0)
    80005364:	00878713          	addi	a4,a5,8
    80005368:	f8e43423          	sd	a4,-120(s0)
    8000536c:	0007b903          	ld	s2,0(a5)
    80005370:	00090d63          	beqz	s2,8000538a <printf+0x274>
      for(; *s; s++)
    80005374:	00094503          	lbu	a0,0(s2)
    80005378:	e20505e3          	beqz	a0,800051a2 <printf+0x8c>
        consputc(*s);
    8000537c:	b1bff0ef          	jal	80004e96 <consputc>
      for(; *s; s++)
    80005380:	0905                	addi	s2,s2,1
    80005382:	00094503          	lbu	a0,0(s2)
    80005386:	f97d                	bnez	a0,8000537c <printf+0x266>
    80005388:	bd29                	j	800051a2 <printf+0x8c>
        s = "(null)";
    8000538a:	00002917          	auipc	s2,0x2
    8000538e:	38e90913          	addi	s2,s2,910 # 80007718 <etext+0x718>
      for(; *s; s++)
    80005392:	02800513          	li	a0,40
    80005396:	b7dd                	j	8000537c <printf+0x266>
      consputc('%');
    80005398:	02500513          	li	a0,37
    8000539c:	afbff0ef          	jal	80004e96 <consputc>
    800053a0:	b509                	j	800051a2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800053a2:	f7843783          	ld	a5,-136(s0)
    800053a6:	e385                	bnez	a5,800053c6 <printf+0x2b0>
    800053a8:	74e6                	ld	s1,120(sp)
    800053aa:	7946                	ld	s2,112(sp)
    800053ac:	79a6                	ld	s3,104(sp)
    800053ae:	6ae6                	ld	s5,88(sp)
    800053b0:	6b46                	ld	s6,80(sp)
    800053b2:	6c06                	ld	s8,64(sp)
    800053b4:	7ce2                	ld	s9,56(sp)
    800053b6:	7d42                	ld	s10,48(sp)
    800053b8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800053ba:	4501                	li	a0,0
    800053bc:	60aa                	ld	ra,136(sp)
    800053be:	640a                	ld	s0,128(sp)
    800053c0:	7a06                	ld	s4,96(sp)
    800053c2:	6169                	addi	sp,sp,208
    800053c4:	8082                	ret
    800053c6:	74e6                	ld	s1,120(sp)
    800053c8:	7946                	ld	s2,112(sp)
    800053ca:	79a6                	ld	s3,104(sp)
    800053cc:	6ae6                	ld	s5,88(sp)
    800053ce:	6b46                	ld	s6,80(sp)
    800053d0:	6c06                	ld	s8,64(sp)
    800053d2:	7ce2                	ld	s9,56(sp)
    800053d4:	7d42                	ld	s10,48(sp)
    800053d6:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800053d8:	0001e517          	auipc	a0,0x1e
    800053dc:	1b050513          	addi	a0,a0,432 # 80023588 <pr>
    800053e0:	3c8000ef          	jal	800057a8 <release>
    800053e4:	bfd9                	j	800053ba <printf+0x2a4>

00000000800053e6 <panic>:

void
panic(char *s)
{
    800053e6:	1101                	addi	sp,sp,-32
    800053e8:	ec06                	sd	ra,24(sp)
    800053ea:	e822                	sd	s0,16(sp)
    800053ec:	e426                	sd	s1,8(sp)
    800053ee:	1000                	addi	s0,sp,32
    800053f0:	84aa                	mv	s1,a0
  pr.locking = 0;
    800053f2:	0001e797          	auipc	a5,0x1e
    800053f6:	1a07a723          	sw	zero,430(a5) # 800235a0 <pr+0x18>
  printf("panic: ");
    800053fa:	00002517          	auipc	a0,0x2
    800053fe:	32650513          	addi	a0,a0,806 # 80007720 <etext+0x720>
    80005402:	d15ff0ef          	jal	80005116 <printf>
  printf("%s\n", s);
    80005406:	85a6                	mv	a1,s1
    80005408:	00002517          	auipc	a0,0x2
    8000540c:	32050513          	addi	a0,a0,800 # 80007728 <etext+0x728>
    80005410:	d07ff0ef          	jal	80005116 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005414:	4785                	li	a5,1
    80005416:	00005717          	auipc	a4,0x5
    8000541a:	e8f72323          	sw	a5,-378(a4) # 8000a29c <panicked>
  for(;;)
    8000541e:	a001                	j	8000541e <panic+0x38>

0000000080005420 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005420:	1101                	addi	sp,sp,-32
    80005422:	ec06                	sd	ra,24(sp)
    80005424:	e822                	sd	s0,16(sp)
    80005426:	e426                	sd	s1,8(sp)
    80005428:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000542a:	0001e497          	auipc	s1,0x1e
    8000542e:	15e48493          	addi	s1,s1,350 # 80023588 <pr>
    80005432:	00002597          	auipc	a1,0x2
    80005436:	2fe58593          	addi	a1,a1,766 # 80007730 <etext+0x730>
    8000543a:	8526                	mv	a0,s1
    8000543c:	254000ef          	jal	80005690 <initlock>
  pr.locking = 1;
    80005440:	4785                	li	a5,1
    80005442:	cc9c                	sw	a5,24(s1)
}
    80005444:	60e2                	ld	ra,24(sp)
    80005446:	6442                	ld	s0,16(sp)
    80005448:	64a2                	ld	s1,8(sp)
    8000544a:	6105                	addi	sp,sp,32
    8000544c:	8082                	ret

000000008000544e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000544e:	1141                	addi	sp,sp,-16
    80005450:	e406                	sd	ra,8(sp)
    80005452:	e022                	sd	s0,0(sp)
    80005454:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005456:	100007b7          	lui	a5,0x10000
    8000545a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000545e:	10000737          	lui	a4,0x10000
    80005462:	f8000693          	li	a3,-128
    80005466:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000546a:	468d                	li	a3,3
    8000546c:	10000637          	lui	a2,0x10000
    80005470:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005474:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005478:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000547c:	8732                	mv	a4,a2
    8000547e:	461d                	li	a2,7
    80005480:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005484:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005488:	00002597          	auipc	a1,0x2
    8000548c:	2b058593          	addi	a1,a1,688 # 80007738 <etext+0x738>
    80005490:	0001e517          	auipc	a0,0x1e
    80005494:	11850513          	addi	a0,a0,280 # 800235a8 <uart_tx_lock>
    80005498:	1f8000ef          	jal	80005690 <initlock>
}
    8000549c:	60a2                	ld	ra,8(sp)
    8000549e:	6402                	ld	s0,0(sp)
    800054a0:	0141                	addi	sp,sp,16
    800054a2:	8082                	ret

00000000800054a4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800054a4:	1101                	addi	sp,sp,-32
    800054a6:	ec06                	sd	ra,24(sp)
    800054a8:	e822                	sd	s0,16(sp)
    800054aa:	e426                	sd	s1,8(sp)
    800054ac:	1000                	addi	s0,sp,32
    800054ae:	84aa                	mv	s1,a0
  push_off();
    800054b0:	224000ef          	jal	800056d4 <push_off>

  if(panicked){
    800054b4:	00005797          	auipc	a5,0x5
    800054b8:	de87a783          	lw	a5,-536(a5) # 8000a29c <panicked>
    800054bc:	e795                	bnez	a5,800054e8 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054be:	10000737          	lui	a4,0x10000
    800054c2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800054c4:	00074783          	lbu	a5,0(a4)
    800054c8:	0207f793          	andi	a5,a5,32
    800054cc:	dfe5                	beqz	a5,800054c4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800054ce:	0ff4f513          	zext.b	a0,s1
    800054d2:	100007b7          	lui	a5,0x10000
    800054d6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800054da:	27e000ef          	jal	80005758 <pop_off>
}
    800054de:	60e2                	ld	ra,24(sp)
    800054e0:	6442                	ld	s0,16(sp)
    800054e2:	64a2                	ld	s1,8(sp)
    800054e4:	6105                	addi	sp,sp,32
    800054e6:	8082                	ret
    for(;;)
    800054e8:	a001                	j	800054e8 <uartputc_sync+0x44>

00000000800054ea <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800054ea:	00005797          	auipc	a5,0x5
    800054ee:	db67b783          	ld	a5,-586(a5) # 8000a2a0 <uart_tx_r>
    800054f2:	00005717          	auipc	a4,0x5
    800054f6:	db673703          	ld	a4,-586(a4) # 8000a2a8 <uart_tx_w>
    800054fa:	08f70163          	beq	a4,a5,8000557c <uartstart+0x92>
{
    800054fe:	7139                	addi	sp,sp,-64
    80005500:	fc06                	sd	ra,56(sp)
    80005502:	f822                	sd	s0,48(sp)
    80005504:	f426                	sd	s1,40(sp)
    80005506:	f04a                	sd	s2,32(sp)
    80005508:	ec4e                	sd	s3,24(sp)
    8000550a:	e852                	sd	s4,16(sp)
    8000550c:	e456                	sd	s5,8(sp)
    8000550e:	e05a                	sd	s6,0(sp)
    80005510:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005512:	10000937          	lui	s2,0x10000
    80005516:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005518:	0001ea97          	auipc	s5,0x1e
    8000551c:	090a8a93          	addi	s5,s5,144 # 800235a8 <uart_tx_lock>
    uart_tx_r += 1;
    80005520:	00005497          	auipc	s1,0x5
    80005524:	d8048493          	addi	s1,s1,-640 # 8000a2a0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005528:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000552c:	00005997          	auipc	s3,0x5
    80005530:	d7c98993          	addi	s3,s3,-644 # 8000a2a8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005534:	00094703          	lbu	a4,0(s2)
    80005538:	02077713          	andi	a4,a4,32
    8000553c:	c715                	beqz	a4,80005568 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000553e:	01f7f713          	andi	a4,a5,31
    80005542:	9756                	add	a4,a4,s5
    80005544:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005548:	0785                	addi	a5,a5,1
    8000554a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000554c:	8526                	mv	a0,s1
    8000554e:	e29fb0ef          	jal	80001376 <wakeup>
    WriteReg(THR, c);
    80005552:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005556:	609c                	ld	a5,0(s1)
    80005558:	0009b703          	ld	a4,0(s3)
    8000555c:	fcf71ce3          	bne	a4,a5,80005534 <uartstart+0x4a>
      ReadReg(ISR);
    80005560:	100007b7          	lui	a5,0x10000
    80005564:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005568:	70e2                	ld	ra,56(sp)
    8000556a:	7442                	ld	s0,48(sp)
    8000556c:	74a2                	ld	s1,40(sp)
    8000556e:	7902                	ld	s2,32(sp)
    80005570:	69e2                	ld	s3,24(sp)
    80005572:	6a42                	ld	s4,16(sp)
    80005574:	6aa2                	ld	s5,8(sp)
    80005576:	6b02                	ld	s6,0(sp)
    80005578:	6121                	addi	sp,sp,64
    8000557a:	8082                	ret
      ReadReg(ISR);
    8000557c:	100007b7          	lui	a5,0x10000
    80005580:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80005584:	8082                	ret

0000000080005586 <uartputc>:
{
    80005586:	7179                	addi	sp,sp,-48
    80005588:	f406                	sd	ra,40(sp)
    8000558a:	f022                	sd	s0,32(sp)
    8000558c:	ec26                	sd	s1,24(sp)
    8000558e:	e84a                	sd	s2,16(sp)
    80005590:	e44e                	sd	s3,8(sp)
    80005592:	e052                	sd	s4,0(sp)
    80005594:	1800                	addi	s0,sp,48
    80005596:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005598:	0001e517          	auipc	a0,0x1e
    8000559c:	01050513          	addi	a0,a0,16 # 800235a8 <uart_tx_lock>
    800055a0:	174000ef          	jal	80005714 <acquire>
  if(panicked){
    800055a4:	00005797          	auipc	a5,0x5
    800055a8:	cf87a783          	lw	a5,-776(a5) # 8000a29c <panicked>
    800055ac:	efbd                	bnez	a5,8000562a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055ae:	00005717          	auipc	a4,0x5
    800055b2:	cfa73703          	ld	a4,-774(a4) # 8000a2a8 <uart_tx_w>
    800055b6:	00005797          	auipc	a5,0x5
    800055ba:	cea7b783          	ld	a5,-790(a5) # 8000a2a0 <uart_tx_r>
    800055be:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800055c2:	0001e997          	auipc	s3,0x1e
    800055c6:	fe698993          	addi	s3,s3,-26 # 800235a8 <uart_tx_lock>
    800055ca:	00005497          	auipc	s1,0x5
    800055ce:	cd648493          	addi	s1,s1,-810 # 8000a2a0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055d2:	00005917          	auipc	s2,0x5
    800055d6:	cd690913          	addi	s2,s2,-810 # 8000a2a8 <uart_tx_w>
    800055da:	00e79d63          	bne	a5,a4,800055f4 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800055de:	85ce                	mv	a1,s3
    800055e0:	8526                	mv	a0,s1
    800055e2:	d49fb0ef          	jal	8000132a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055e6:	00093703          	ld	a4,0(s2)
    800055ea:	609c                	ld	a5,0(s1)
    800055ec:	02078793          	addi	a5,a5,32
    800055f0:	fee787e3          	beq	a5,a4,800055de <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800055f4:	0001e497          	auipc	s1,0x1e
    800055f8:	fb448493          	addi	s1,s1,-76 # 800235a8 <uart_tx_lock>
    800055fc:	01f77793          	andi	a5,a4,31
    80005600:	97a6                	add	a5,a5,s1
    80005602:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005606:	0705                	addi	a4,a4,1
    80005608:	00005797          	auipc	a5,0x5
    8000560c:	cae7b023          	sd	a4,-864(a5) # 8000a2a8 <uart_tx_w>
  uartstart();
    80005610:	edbff0ef          	jal	800054ea <uartstart>
  release(&uart_tx_lock);
    80005614:	8526                	mv	a0,s1
    80005616:	192000ef          	jal	800057a8 <release>
}
    8000561a:	70a2                	ld	ra,40(sp)
    8000561c:	7402                	ld	s0,32(sp)
    8000561e:	64e2                	ld	s1,24(sp)
    80005620:	6942                	ld	s2,16(sp)
    80005622:	69a2                	ld	s3,8(sp)
    80005624:	6a02                	ld	s4,0(sp)
    80005626:	6145                	addi	sp,sp,48
    80005628:	8082                	ret
    for(;;)
    8000562a:	a001                	j	8000562a <uartputc+0xa4>

000000008000562c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000562c:	1141                	addi	sp,sp,-16
    8000562e:	e406                	sd	ra,8(sp)
    80005630:	e022                	sd	s0,0(sp)
    80005632:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005634:	100007b7          	lui	a5,0x10000
    80005638:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000563c:	8b85                	andi	a5,a5,1
    8000563e:	cb89                	beqz	a5,80005650 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005640:	100007b7          	lui	a5,0x10000
    80005644:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005648:	60a2                	ld	ra,8(sp)
    8000564a:	6402                	ld	s0,0(sp)
    8000564c:	0141                	addi	sp,sp,16
    8000564e:	8082                	ret
    return -1;
    80005650:	557d                	li	a0,-1
    80005652:	bfdd                	j	80005648 <uartgetc+0x1c>

0000000080005654 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005654:	1101                	addi	sp,sp,-32
    80005656:	ec06                	sd	ra,24(sp)
    80005658:	e822                	sd	s0,16(sp)
    8000565a:	e426                	sd	s1,8(sp)
    8000565c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000565e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005660:	fcdff0ef          	jal	8000562c <uartgetc>
    if(c == -1)
    80005664:	00950563          	beq	a0,s1,8000566e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005668:	861ff0ef          	jal	80004ec8 <consoleintr>
  while(1){
    8000566c:	bfd5                	j	80005660 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000566e:	0001e497          	auipc	s1,0x1e
    80005672:	f3a48493          	addi	s1,s1,-198 # 800235a8 <uart_tx_lock>
    80005676:	8526                	mv	a0,s1
    80005678:	09c000ef          	jal	80005714 <acquire>
  uartstart();
    8000567c:	e6fff0ef          	jal	800054ea <uartstart>
  release(&uart_tx_lock);
    80005680:	8526                	mv	a0,s1
    80005682:	126000ef          	jal	800057a8 <release>
}
    80005686:	60e2                	ld	ra,24(sp)
    80005688:	6442                	ld	s0,16(sp)
    8000568a:	64a2                	ld	s1,8(sp)
    8000568c:	6105                	addi	sp,sp,32
    8000568e:	8082                	ret

0000000080005690 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005690:	1141                	addi	sp,sp,-16
    80005692:	e406                	sd	ra,8(sp)
    80005694:	e022                	sd	s0,0(sp)
    80005696:	0800                	addi	s0,sp,16
  lk->name = name;
    80005698:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000569a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000569e:	00053823          	sd	zero,16(a0)
}
    800056a2:	60a2                	ld	ra,8(sp)
    800056a4:	6402                	ld	s0,0(sp)
    800056a6:	0141                	addi	sp,sp,16
    800056a8:	8082                	ret

00000000800056aa <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800056aa:	411c                	lw	a5,0(a0)
    800056ac:	e399                	bnez	a5,800056b2 <holding+0x8>
    800056ae:	4501                	li	a0,0
  return r;
}
    800056b0:	8082                	ret
{
    800056b2:	1101                	addi	sp,sp,-32
    800056b4:	ec06                	sd	ra,24(sp)
    800056b6:	e822                	sd	s0,16(sp)
    800056b8:	e426                	sd	s1,8(sp)
    800056ba:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800056bc:	6904                	ld	s1,16(a0)
    800056be:	e7efb0ef          	jal	80000d3c <mycpu>
    800056c2:	40a48533          	sub	a0,s1,a0
    800056c6:	00153513          	seqz	a0,a0
}
    800056ca:	60e2                	ld	ra,24(sp)
    800056cc:	6442                	ld	s0,16(sp)
    800056ce:	64a2                	ld	s1,8(sp)
    800056d0:	6105                	addi	sp,sp,32
    800056d2:	8082                	ret

00000000800056d4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056d4:	1101                	addi	sp,sp,-32
    800056d6:	ec06                	sd	ra,24(sp)
    800056d8:	e822                	sd	s0,16(sp)
    800056da:	e426                	sd	s1,8(sp)
    800056dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056de:	100024f3          	csrr	s1,sstatus
    800056e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056e6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056e8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800056ec:	e50fb0ef          	jal	80000d3c <mycpu>
    800056f0:	5d3c                	lw	a5,120(a0)
    800056f2:	cb99                	beqz	a5,80005708 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800056f4:	e48fb0ef          	jal	80000d3c <mycpu>
    800056f8:	5d3c                	lw	a5,120(a0)
    800056fa:	2785                	addiw	a5,a5,1
    800056fc:	dd3c                	sw	a5,120(a0)
}
    800056fe:	60e2                	ld	ra,24(sp)
    80005700:	6442                	ld	s0,16(sp)
    80005702:	64a2                	ld	s1,8(sp)
    80005704:	6105                	addi	sp,sp,32
    80005706:	8082                	ret
    mycpu()->intena = old;
    80005708:	e34fb0ef          	jal	80000d3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000570c:	8085                	srli	s1,s1,0x1
    8000570e:	8885                	andi	s1,s1,1
    80005710:	dd64                	sw	s1,124(a0)
    80005712:	b7cd                	j	800056f4 <push_off+0x20>

0000000080005714 <acquire>:
{
    80005714:	1101                	addi	sp,sp,-32
    80005716:	ec06                	sd	ra,24(sp)
    80005718:	e822                	sd	s0,16(sp)
    8000571a:	e426                	sd	s1,8(sp)
    8000571c:	1000                	addi	s0,sp,32
    8000571e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005720:	fb5ff0ef          	jal	800056d4 <push_off>
  if(holding(lk))
    80005724:	8526                	mv	a0,s1
    80005726:	f85ff0ef          	jal	800056aa <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000572a:	4705                	li	a4,1
  if(holding(lk))
    8000572c:	e105                	bnez	a0,8000574c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000572e:	87ba                	mv	a5,a4
    80005730:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005734:	2781                	sext.w	a5,a5
    80005736:	ffe5                	bnez	a5,8000572e <acquire+0x1a>
  __sync_synchronize();
    80005738:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000573c:	e00fb0ef          	jal	80000d3c <mycpu>
    80005740:	e888                	sd	a0,16(s1)
}
    80005742:	60e2                	ld	ra,24(sp)
    80005744:	6442                	ld	s0,16(sp)
    80005746:	64a2                	ld	s1,8(sp)
    80005748:	6105                	addi	sp,sp,32
    8000574a:	8082                	ret
    panic("acquire");
    8000574c:	00002517          	auipc	a0,0x2
    80005750:	ff450513          	addi	a0,a0,-12 # 80007740 <etext+0x740>
    80005754:	c93ff0ef          	jal	800053e6 <panic>

0000000080005758 <pop_off>:

void
pop_off(void)
{
    80005758:	1141                	addi	sp,sp,-16
    8000575a:	e406                	sd	ra,8(sp)
    8000575c:	e022                	sd	s0,0(sp)
    8000575e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005760:	ddcfb0ef          	jal	80000d3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005764:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005768:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000576a:	e39d                	bnez	a5,80005790 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000576c:	5d3c                	lw	a5,120(a0)
    8000576e:	02f05763          	blez	a5,8000579c <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005772:	37fd                	addiw	a5,a5,-1
    80005774:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005776:	eb89                	bnez	a5,80005788 <pop_off+0x30>
    80005778:	5d7c                	lw	a5,124(a0)
    8000577a:	c799                	beqz	a5,80005788 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000577c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005780:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005784:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005788:	60a2                	ld	ra,8(sp)
    8000578a:	6402                	ld	s0,0(sp)
    8000578c:	0141                	addi	sp,sp,16
    8000578e:	8082                	ret
    panic("pop_off - interruptible");
    80005790:	00002517          	auipc	a0,0x2
    80005794:	fb850513          	addi	a0,a0,-72 # 80007748 <etext+0x748>
    80005798:	c4fff0ef          	jal	800053e6 <panic>
    panic("pop_off");
    8000579c:	00002517          	auipc	a0,0x2
    800057a0:	fc450513          	addi	a0,a0,-60 # 80007760 <etext+0x760>
    800057a4:	c43ff0ef          	jal	800053e6 <panic>

00000000800057a8 <release>:
{
    800057a8:	1101                	addi	sp,sp,-32
    800057aa:	ec06                	sd	ra,24(sp)
    800057ac:	e822                	sd	s0,16(sp)
    800057ae:	e426                	sd	s1,8(sp)
    800057b0:	1000                	addi	s0,sp,32
    800057b2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800057b4:	ef7ff0ef          	jal	800056aa <holding>
    800057b8:	c105                	beqz	a0,800057d8 <release+0x30>
  lk->cpu = 0;
    800057ba:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800057be:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800057c2:	0310000f          	fence	rw,w
    800057c6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800057ca:	f8fff0ef          	jal	80005758 <pop_off>
}
    800057ce:	60e2                	ld	ra,24(sp)
    800057d0:	6442                	ld	s0,16(sp)
    800057d2:	64a2                	ld	s1,8(sp)
    800057d4:	6105                	addi	sp,sp,32
    800057d6:	8082                	ret
    panic("release");
    800057d8:	00002517          	auipc	a0,0x2
    800057dc:	f9050513          	addi	a0,a0,-112 # 80007768 <etext+0x768>
    800057e0:	c07ff0ef          	jal	800053e6 <panic>
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
