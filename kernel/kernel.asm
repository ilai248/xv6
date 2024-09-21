
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	4a013103          	ld	sp,1184(sp) # 8000a4a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5c7040ef          	jal	80004ddc <start>

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
    80000034:	9f078793          	addi	a5,a5,-1552 # 80023a20 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	148000ef          	jal	80000190 <memset>
  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	4a490913          	addi	s2,s2,1188 # 8000a4f0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	7ee050ef          	jal	80005844 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	073050ef          	jal	800058d8 <release>
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
    8000007e:	498050ef          	jal	80005516 <panic>

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
    800000de:	41650513          	addi	a0,a0,1046 # 8000a4f0 <kmem>
    800000e2:	6de050ef          	jal	800057c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00024517          	auipc	a0,0x24
    800000ee:	93650513          	addi	a0,a0,-1738 # 80023a20 <end>
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
    8000010c:	3e848493          	addi	s1,s1,1000 # 8000a4f0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	732050ef          	jal	80005844 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	3d450513          	addi	a0,a0,980 # 8000a4f0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	7b2050ef          	jal	800058d8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	060000ef          	jal	80000190 <memset>

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
    80000144:	3b050513          	addi	a0,a0,944 # 8000a4f0 <kmem>
    80000148:	790050ef          	jal	800058d8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <getFreeMem>:

uint64 getFreeMem(void)
{
    8000014e:	1101                	addi	sp,sp,-32
    80000150:	ec06                	sd	ra,24(sp)
    80000152:	e822                	sd	s0,16(sp)
    80000154:	e426                	sd	s1,8(sp)
    80000156:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 freePages = 0;

  acquire(&kmem.lock);
    80000158:	0000a497          	auipc	s1,0xa
    8000015c:	39848493          	addi	s1,s1,920 # 8000a4f0 <kmem>
    80000160:	8526                	mv	a0,s1
    80000162:	6e2050ef          	jal	80005844 <acquire>
  r = kmem.freelist;
    80000166:	6c9c                	ld	a5,24(s1)
  while (r) {
    80000168:	c395                	beqz	a5,8000018c <getFreeMem+0x3e>
  uint64 freePages = 0;
    8000016a:	4481                	li	s1,0
    r = r->next;
    8000016c:	639c                	ld	a5,0(a5)
    ++freePages;
    8000016e:	0485                	addi	s1,s1,1
  while (r) {
    80000170:	fff5                	bnez	a5,8000016c <getFreeMem+0x1e>
  }
  release(&kmem.lock);
    80000172:	0000a517          	auipc	a0,0xa
    80000176:	37e50513          	addi	a0,a0,894 # 8000a4f0 <kmem>
    8000017a:	75e050ef          	jal	800058d8 <release>
  return freePages * PGSIZE;
}
    8000017e:	00c49513          	slli	a0,s1,0xc
    80000182:	60e2                	ld	ra,24(sp)
    80000184:	6442                	ld	s0,16(sp)
    80000186:	64a2                	ld	s1,8(sp)
    80000188:	6105                	addi	sp,sp,32
    8000018a:	8082                	ret
  uint64 freePages = 0;
    8000018c:	4481                	li	s1,0
    8000018e:	b7d5                	j	80000172 <getFreeMem+0x24>

0000000080000190 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e406                	sd	ra,8(sp)
    80000194:	e022                	sd	s0,0(sp)
    80000196:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000198:	ca19                	beqz	a2,800001ae <memset+0x1e>
    8000019a:	87aa                	mv	a5,a0
    8000019c:	1602                	slli	a2,a2,0x20
    8000019e:	9201                	srli	a2,a2,0x20
    800001a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001a8:	0785                	addi	a5,a5,1
    800001aa:	fee79de3          	bne	a5,a4,800001a4 <memset+0x14>
  }
  return dst;
}
    800001ae:	60a2                	ld	ra,8(sp)
    800001b0:	6402                	ld	s0,0(sp)
    800001b2:	0141                	addi	sp,sp,16
    800001b4:	8082                	ret

00000000800001b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001b6:	1141                	addi	sp,sp,-16
    800001b8:	e406                	sd	ra,8(sp)
    800001ba:	e022                	sd	s0,0(sp)
    800001bc:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001be:	ca0d                	beqz	a2,800001f0 <memcmp+0x3a>
    800001c0:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001c4:	1682                	slli	a3,a3,0x20
    800001c6:	9281                	srli	a3,a3,0x20
    800001c8:	0685                	addi	a3,a3,1
    800001ca:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001cc:	00054783          	lbu	a5,0(a0)
    800001d0:	0005c703          	lbu	a4,0(a1)
    800001d4:	00e79863          	bne	a5,a4,800001e4 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    800001d8:	0505                	addi	a0,a0,1
    800001da:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001dc:	fed518e3          	bne	a0,a3,800001cc <memcmp+0x16>
  }

  return 0;
    800001e0:	4501                	li	a0,0
    800001e2:	a019                	j	800001e8 <memcmp+0x32>
      return *s1 - *s2;
    800001e4:	40e7853b          	subw	a0,a5,a4
}
    800001e8:	60a2                	ld	ra,8(sp)
    800001ea:	6402                	ld	s0,0(sp)
    800001ec:	0141                	addi	sp,sp,16
    800001ee:	8082                	ret
  return 0;
    800001f0:	4501                	li	a0,0
    800001f2:	bfdd                	j	800001e8 <memcmp+0x32>

00000000800001f4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001f4:	1141                	addi	sp,sp,-16
    800001f6:	e406                	sd	ra,8(sp)
    800001f8:	e022                	sd	s0,0(sp)
    800001fa:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001fc:	c205                	beqz	a2,8000021c <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001fe:	02a5e363          	bltu	a1,a0,80000224 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000202:	1602                	slli	a2,a2,0x20
    80000204:	9201                	srli	a2,a2,0x20
    80000206:	00c587b3          	add	a5,a1,a2
{
    8000020a:	872a                	mv	a4,a0
      *d++ = *s++;
    8000020c:	0585                	addi	a1,a1,1
    8000020e:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb5e1>
    80000210:	fff5c683          	lbu	a3,-1(a1)
    80000214:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000218:	feb79ae3          	bne	a5,a1,8000020c <memmove+0x18>

  return dst;
}
    8000021c:	60a2                	ld	ra,8(sp)
    8000021e:	6402                	ld	s0,0(sp)
    80000220:	0141                	addi	sp,sp,16
    80000222:	8082                	ret
  if(s < d && s + n > d){
    80000224:	02061693          	slli	a3,a2,0x20
    80000228:	9281                	srli	a3,a3,0x20
    8000022a:	00d58733          	add	a4,a1,a3
    8000022e:	fce57ae3          	bgeu	a0,a4,80000202 <memmove+0xe>
    d += n;
    80000232:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000234:	fff6079b          	addiw	a5,a2,-1
    80000238:	1782                	slli	a5,a5,0x20
    8000023a:	9381                	srli	a5,a5,0x20
    8000023c:	fff7c793          	not	a5,a5
    80000240:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000242:	177d                	addi	a4,a4,-1
    80000244:	16fd                	addi	a3,a3,-1
    80000246:	00074603          	lbu	a2,0(a4)
    8000024a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000024e:	fee79ae3          	bne	a5,a4,80000242 <memmove+0x4e>
    80000252:	b7e9                	j	8000021c <memmove+0x28>

0000000080000254 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000254:	1141                	addi	sp,sp,-16
    80000256:	e406                	sd	ra,8(sp)
    80000258:	e022                	sd	s0,0(sp)
    8000025a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000025c:	f99ff0ef          	jal	800001f4 <memmove>
}
    80000260:	60a2                	ld	ra,8(sp)
    80000262:	6402                	ld	s0,0(sp)
    80000264:	0141                	addi	sp,sp,16
    80000266:	8082                	ret

0000000080000268 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e406                	sd	ra,8(sp)
    8000026c:	e022                	sd	s0,0(sp)
    8000026e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000270:	ce11                	beqz	a2,8000028c <strncmp+0x24>
    80000272:	00054783          	lbu	a5,0(a0)
    80000276:	cf89                	beqz	a5,80000290 <strncmp+0x28>
    80000278:	0005c703          	lbu	a4,0(a1)
    8000027c:	00f71a63          	bne	a4,a5,80000290 <strncmp+0x28>
    n--, p++, q++;
    80000280:	367d                	addiw	a2,a2,-1
    80000282:	0505                	addi	a0,a0,1
    80000284:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000286:	f675                	bnez	a2,80000272 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	a801                	j	8000029a <strncmp+0x32>
    8000028c:	4501                	li	a0,0
    8000028e:	a031                	j	8000029a <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000290:	00054503          	lbu	a0,0(a0)
    80000294:	0005c783          	lbu	a5,0(a1)
    80000298:	9d1d                	subw	a0,a0,a5
}
    8000029a:	60a2                	ld	ra,8(sp)
    8000029c:	6402                	ld	s0,0(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret

00000000800002a2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002a2:	1141                	addi	sp,sp,-16
    800002a4:	e406                	sd	ra,8(sp)
    800002a6:	e022                	sd	s0,0(sp)
    800002a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002aa:	87aa                	mv	a5,a0
    800002ac:	86b2                	mv	a3,a2
    800002ae:	367d                	addiw	a2,a2,-1
    800002b0:	02d05563          	blez	a3,800002da <strncpy+0x38>
    800002b4:	0785                	addi	a5,a5,1
    800002b6:	0005c703          	lbu	a4,0(a1)
    800002ba:	fee78fa3          	sb	a4,-1(a5)
    800002be:	0585                	addi	a1,a1,1
    800002c0:	f775                	bnez	a4,800002ac <strncpy+0xa>
    ;
  while(n-- > 0)
    800002c2:	873e                	mv	a4,a5
    800002c4:	00c05b63          	blez	a2,800002da <strncpy+0x38>
    800002c8:	9fb5                	addw	a5,a5,a3
    800002ca:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    800002cc:	0705                	addi	a4,a4,1
    800002ce:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002d2:	40e786bb          	subw	a3,a5,a4
    800002d6:	fed04be3          	bgtz	a3,800002cc <strncpy+0x2a>
  return os;
}
    800002da:	60a2                	ld	ra,8(sp)
    800002dc:	6402                	ld	s0,0(sp)
    800002de:	0141                	addi	sp,sp,16
    800002e0:	8082                	ret

00000000800002e2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002e2:	1141                	addi	sp,sp,-16
    800002e4:	e406                	sd	ra,8(sp)
    800002e6:	e022                	sd	s0,0(sp)
    800002e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ea:	02c05363          	blez	a2,80000310 <safestrcpy+0x2e>
    800002ee:	fff6069b          	addiw	a3,a2,-1
    800002f2:	1682                	slli	a3,a3,0x20
    800002f4:	9281                	srli	a3,a3,0x20
    800002f6:	96ae                	add	a3,a3,a1
    800002f8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002fa:	00d58963          	beq	a1,a3,8000030c <safestrcpy+0x2a>
    800002fe:	0585                	addi	a1,a1,1
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff5c703          	lbu	a4,-1(a1)
    80000306:	fee78fa3          	sb	a4,-1(a5)
    8000030a:	fb65                	bnez	a4,800002fa <safestrcpy+0x18>
    ;
  *s = 0;
    8000030c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000310:	60a2                	ld	ra,8(sp)
    80000312:	6402                	ld	s0,0(sp)
    80000314:	0141                	addi	sp,sp,16
    80000316:	8082                	ret

0000000080000318 <strlen>:

int
strlen(const char *s)
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000320:	00054783          	lbu	a5,0(a0)
    80000324:	cf99                	beqz	a5,80000342 <strlen+0x2a>
    80000326:	0505                	addi	a0,a0,1
    80000328:	87aa                	mv	a5,a0
    8000032a:	86be                	mv	a3,a5
    8000032c:	0785                	addi	a5,a5,1
    8000032e:	fff7c703          	lbu	a4,-1(a5)
    80000332:	ff65                	bnez	a4,8000032a <strlen+0x12>
    80000334:	40a6853b          	subw	a0,a3,a0
    80000338:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000033a:	60a2                	ld	ra,8(sp)
    8000033c:	6402                	ld	s0,0(sp)
    8000033e:	0141                	addi	sp,sp,16
    80000340:	8082                	ret
  for(n = 0; s[n]; n++)
    80000342:	4501                	li	a0,0
    80000344:	bfdd                	j	8000033a <strlen+0x22>

0000000080000346 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e406                	sd	ra,8(sp)
    8000034a:	e022                	sd	s0,0(sp)
    8000034c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000034e:	251000ef          	jal	80000d9e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000352:	0000a717          	auipc	a4,0xa
    80000356:	16e70713          	addi	a4,a4,366 # 8000a4c0 <started>
  if(cpuid() == 0){
    8000035a:	c51d                	beqz	a0,80000388 <main+0x42>
    while(started == 0)
    8000035c:	431c                	lw	a5,0(a4)
    8000035e:	2781                	sext.w	a5,a5
    80000360:	dff5                	beqz	a5,8000035c <main+0x16>
      ;
    __sync_synchronize();
    80000362:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000366:	239000ef          	jal	80000d9e <cpuid>
    8000036a:	85aa                	mv	a1,a0
    8000036c:	00007517          	auipc	a0,0x7
    80000370:	ccc50513          	addi	a0,a0,-820 # 80007038 <etext+0x38>
    80000374:	6d3040ef          	jal	80005246 <printf>
    kvminithart();    // turn on paging
    80000378:	080000ef          	jal	800003f8 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000037c:	54c010ef          	jal	800018c8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000380:	4a8040ef          	jal	80004828 <plicinithart>
  }

  scheduler();        
    80000384:	68f000ef          	jal	80001212 <scheduler>
    consoleinit();
    80000388:	5f1040ef          	jal	80005178 <consoleinit>
    printfinit();
    8000038c:	1c4050ef          	jal	80005550 <printfinit>
    printf("\n");
    80000390:	00007517          	auipc	a0,0x7
    80000394:	c8850513          	addi	a0,a0,-888 # 80007018 <etext+0x18>
    80000398:	6af040ef          	jal	80005246 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00007517          	auipc	a0,0x7
    800003a0:	c8450513          	addi	a0,a0,-892 # 80007020 <etext+0x20>
    800003a4:	6a3040ef          	jal	80005246 <printf>
    printf("\n");
    800003a8:	00007517          	auipc	a0,0x7
    800003ac:	c7050513          	addi	a0,a0,-912 # 80007018 <etext+0x18>
    800003b0:	697040ef          	jal	80005246 <printf>
    kinit();         // physical page allocator
    800003b4:	d17ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    800003b8:	2ce000ef          	jal	80000686 <kvminit>
    kvminithart();   // turn on paging
    800003bc:	03c000ef          	jal	800003f8 <kvminithart>
    procinit();      // process table
    800003c0:	12f000ef          	jal	80000cee <procinit>
    trapinit();      // trap vectors
    800003c4:	4e0010ef          	jal	800018a4 <trapinit>
    trapinithart();  // install kernel trap vector
    800003c8:	500010ef          	jal	800018c8 <trapinithart>
    plicinit();      // set up interrupt controller
    800003cc:	442040ef          	jal	8000480e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003d0:	458040ef          	jal	80004828 <plicinithart>
    binit();         // buffer cache
    800003d4:	3c3010ef          	jal	80001f96 <binit>
    iinit();         // inode table
    800003d8:	18e020ef          	jal	80002566 <iinit>
    fileinit();      // file table
    800003dc:	75d020ef          	jal	80003338 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003e0:	538040ef          	jal	80004918 <virtio_disk_init>
    userinit();      // first user process
    800003e4:	45b000ef          	jal	8000103e <userinit>
    __sync_synchronize();
    800003e8:	0330000f          	fence	rw,rw
    started = 1;
    800003ec:	4785                	li	a5,1
    800003ee:	0000a717          	auipc	a4,0xa
    800003f2:	0cf72923          	sw	a5,210(a4) # 8000a4c0 <started>
    800003f6:	b779                	j	80000384 <main+0x3e>

00000000800003f8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003f8:	1141                	addi	sp,sp,-16
    800003fa:	e406                	sd	ra,8(sp)
    800003fc:	e022                	sd	s0,0(sp)
    800003fe:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000400:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000404:	0000a797          	auipc	a5,0xa
    80000408:	0c47b783          	ld	a5,196(a5) # 8000a4c8 <kernel_pagetable>
    8000040c:	83b1                	srli	a5,a5,0xc
    8000040e:	577d                	li	a4,-1
    80000410:	177e                	slli	a4,a4,0x3f
    80000412:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000414:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000418:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000041c:	60a2                	ld	ra,8(sp)
    8000041e:	6402                	ld	s0,0(sp)
    80000420:	0141                	addi	sp,sp,16
    80000422:	8082                	ret

0000000080000424 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000424:	7139                	addi	sp,sp,-64
    80000426:	fc06                	sd	ra,56(sp)
    80000428:	f822                	sd	s0,48(sp)
    8000042a:	f426                	sd	s1,40(sp)
    8000042c:	f04a                	sd	s2,32(sp)
    8000042e:	ec4e                	sd	s3,24(sp)
    80000430:	e852                	sd	s4,16(sp)
    80000432:	e456                	sd	s5,8(sp)
    80000434:	e05a                	sd	s6,0(sp)
    80000436:	0080                	addi	s0,sp,64
    80000438:	84aa                	mv	s1,a0
    8000043a:	89ae                	mv	s3,a1
    8000043c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000043e:	57fd                	li	a5,-1
    80000440:	83e9                	srli	a5,a5,0x1a
    80000442:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000444:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000446:	04b7e263          	bltu	a5,a1,8000048a <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    8000044a:	0149d933          	srl	s2,s3,s4
    8000044e:	1ff97913          	andi	s2,s2,511
    80000452:	090e                	slli	s2,s2,0x3
    80000454:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000456:	00093483          	ld	s1,0(s2)
    8000045a:	0014f793          	andi	a5,s1,1
    8000045e:	cf85                	beqz	a5,80000496 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000460:	80a9                	srli	s1,s1,0xa
    80000462:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000464:	3a5d                	addiw	s4,s4,-9
    80000466:	ff6a12e3          	bne	s4,s6,8000044a <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000046a:	00c9d513          	srli	a0,s3,0xc
    8000046e:	1ff57513          	andi	a0,a0,511
    80000472:	050e                	slli	a0,a0,0x3
    80000474:	9526                	add	a0,a0,s1
}
    80000476:	70e2                	ld	ra,56(sp)
    80000478:	7442                	ld	s0,48(sp)
    8000047a:	74a2                	ld	s1,40(sp)
    8000047c:	7902                	ld	s2,32(sp)
    8000047e:	69e2                	ld	s3,24(sp)
    80000480:	6a42                	ld	s4,16(sp)
    80000482:	6aa2                	ld	s5,8(sp)
    80000484:	6b02                	ld	s6,0(sp)
    80000486:	6121                	addi	sp,sp,64
    80000488:	8082                	ret
    panic("walk");
    8000048a:	00007517          	auipc	a0,0x7
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80007050 <etext+0x50>
    80000492:	084050ef          	jal	80005516 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	020a8263          	beqz	s5,800004ba <walk+0x96>
    8000049a:	c65ff0ef          	jal	800000fe <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	d979                	beqz	a0,80000476 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	cebff0ef          	jal	80000190 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004aa:	00c4d793          	srli	a5,s1,0xc
    800004ae:	07aa                	slli	a5,a5,0xa
    800004b0:	0017e793          	ori	a5,a5,1
    800004b4:	00f93023          	sd	a5,0(s2)
    800004b8:	b775                	j	80000464 <walk+0x40>
        return 0;
    800004ba:	4501                	li	a0,0
    800004bc:	bf6d                	j	80000476 <walk+0x52>

00000000800004be <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004be:	57fd                	li	a5,-1
    800004c0:	83e9                	srli	a5,a5,0x1a
    800004c2:	00b7f463          	bgeu	a5,a1,800004ca <walkaddr+0xc>
    return 0;
    800004c6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004c8:	8082                	ret
{
    800004ca:	1141                	addi	sp,sp,-16
    800004cc:	e406                	sd	ra,8(sp)
    800004ce:	e022                	sd	s0,0(sp)
    800004d0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004d2:	4601                	li	a2,0
    800004d4:	f51ff0ef          	jal	80000424 <walk>
  if(pte == 0)
    800004d8:	c105                	beqz	a0,800004f8 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004da:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004dc:	0117f693          	andi	a3,a5,17
    800004e0:	4745                	li	a4,17
    return 0;
    800004e2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004e4:	00e68663          	beq	a3,a4,800004f0 <walkaddr+0x32>
}
    800004e8:	60a2                	ld	ra,8(sp)
    800004ea:	6402                	ld	s0,0(sp)
    800004ec:	0141                	addi	sp,sp,16
    800004ee:	8082                	ret
  pa = PTE2PA(*pte);
    800004f0:	83a9                	srli	a5,a5,0xa
    800004f2:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004f6:	bfcd                	j	800004e8 <walkaddr+0x2a>
    return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	b7fd                	j	800004e8 <walkaddr+0x2a>

00000000800004fc <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004fc:	715d                	addi	sp,sp,-80
    800004fe:	e486                	sd	ra,72(sp)
    80000500:	e0a2                	sd	s0,64(sp)
    80000502:	fc26                	sd	s1,56(sp)
    80000504:	f84a                	sd	s2,48(sp)
    80000506:	f44e                	sd	s3,40(sp)
    80000508:	f052                	sd	s4,32(sp)
    8000050a:	ec56                	sd	s5,24(sp)
    8000050c:	e85a                	sd	s6,16(sp)
    8000050e:	e45e                	sd	s7,8(sp)
    80000510:	e062                	sd	s8,0(sp)
    80000512:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000514:	03459793          	slli	a5,a1,0x34
    80000518:	e7b1                	bnez	a5,80000564 <mappages+0x68>
    8000051a:	8aaa                	mv	s5,a0
    8000051c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000051e:	03461793          	slli	a5,a2,0x34
    80000522:	e7b9                	bnez	a5,80000570 <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    80000524:	ce21                	beqz	a2,8000057c <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000526:	77fd                	lui	a5,0xfffff
    80000528:	963e                	add	a2,a2,a5
    8000052a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000052e:	892e                	mv	s2,a1
    80000530:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80000534:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000536:	6c05                	lui	s8,0x1
    80000538:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000053c:	865e                	mv	a2,s7
    8000053e:	85ca                	mv	a1,s2
    80000540:	8556                	mv	a0,s5
    80000542:	ee3ff0ef          	jal	80000424 <walk>
    80000546:	c539                	beqz	a0,80000594 <mappages+0x98>
    if(*pte & PTE_V)
    80000548:	611c                	ld	a5,0(a0)
    8000054a:	8b85                	andi	a5,a5,1
    8000054c:	ef95                	bnez	a5,80000588 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000054e:	80b1                	srli	s1,s1,0xc
    80000550:	04aa                	slli	s1,s1,0xa
    80000552:	0164e4b3          	or	s1,s1,s6
    80000556:	0014e493          	ori	s1,s1,1
    8000055a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000055c:	05390963          	beq	s2,s3,800005ae <mappages+0xb2>
    a += PGSIZE;
    80000560:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000562:	bfd9                	j	80000538 <mappages+0x3c>
    panic("mappages: va not aligned");
    80000564:	00007517          	auipc	a0,0x7
    80000568:	af450513          	addi	a0,a0,-1292 # 80007058 <etext+0x58>
    8000056c:	7ab040ef          	jal	80005516 <panic>
    panic("mappages: size not aligned");
    80000570:	00007517          	auipc	a0,0x7
    80000574:	b0850513          	addi	a0,a0,-1272 # 80007078 <etext+0x78>
    80000578:	79f040ef          	jal	80005516 <panic>
    panic("mappages: size");
    8000057c:	00007517          	auipc	a0,0x7
    80000580:	b1c50513          	addi	a0,a0,-1252 # 80007098 <etext+0x98>
    80000584:	793040ef          	jal	80005516 <panic>
      panic("mappages: remap");
    80000588:	00007517          	auipc	a0,0x7
    8000058c:	b2050513          	addi	a0,a0,-1248 # 800070a8 <etext+0xa8>
    80000590:	787040ef          	jal	80005516 <panic>
      return -1;
    80000594:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000596:	60a6                	ld	ra,72(sp)
    80000598:	6406                	ld	s0,64(sp)
    8000059a:	74e2                	ld	s1,56(sp)
    8000059c:	7942                	ld	s2,48(sp)
    8000059e:	79a2                	ld	s3,40(sp)
    800005a0:	7a02                	ld	s4,32(sp)
    800005a2:	6ae2                	ld	s5,24(sp)
    800005a4:	6b42                	ld	s6,16(sp)
    800005a6:	6ba2                	ld	s7,8(sp)
    800005a8:	6c02                	ld	s8,0(sp)
    800005aa:	6161                	addi	sp,sp,80
    800005ac:	8082                	ret
  return 0;
    800005ae:	4501                	li	a0,0
    800005b0:	b7dd                	j	80000596 <mappages+0x9a>

00000000800005b2 <kvmmap>:
{
    800005b2:	1141                	addi	sp,sp,-16
    800005b4:	e406                	sd	ra,8(sp)
    800005b6:	e022                	sd	s0,0(sp)
    800005b8:	0800                	addi	s0,sp,16
    800005ba:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005bc:	86b2                	mv	a3,a2
    800005be:	863e                	mv	a2,a5
    800005c0:	f3dff0ef          	jal	800004fc <mappages>
    800005c4:	e509                	bnez	a0,800005ce <kvmmap+0x1c>
}
    800005c6:	60a2                	ld	ra,8(sp)
    800005c8:	6402                	ld	s0,0(sp)
    800005ca:	0141                	addi	sp,sp,16
    800005cc:	8082                	ret
    panic("kvmmap");
    800005ce:	00007517          	auipc	a0,0x7
    800005d2:	aea50513          	addi	a0,a0,-1302 # 800070b8 <etext+0xb8>
    800005d6:	741040ef          	jal	80005516 <panic>

00000000800005da <kvmmake>:
{
    800005da:	1101                	addi	sp,sp,-32
    800005dc:	ec06                	sd	ra,24(sp)
    800005de:	e822                	sd	s0,16(sp)
    800005e0:	e426                	sd	s1,8(sp)
    800005e2:	e04a                	sd	s2,0(sp)
    800005e4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005e6:	b19ff0ef          	jal	800000fe <kalloc>
    800005ea:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005ec:	6605                	lui	a2,0x1
    800005ee:	4581                	li	a1,0
    800005f0:	ba1ff0ef          	jal	80000190 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005f4:	4719                	li	a4,6
    800005f6:	6685                	lui	a3,0x1
    800005f8:	10000637          	lui	a2,0x10000
    800005fc:	85b2                	mv	a1,a2
    800005fe:	8526                	mv	a0,s1
    80000600:	fb3ff0ef          	jal	800005b2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000604:	4719                	li	a4,6
    80000606:	6685                	lui	a3,0x1
    80000608:	10001637          	lui	a2,0x10001
    8000060c:	85b2                	mv	a1,a2
    8000060e:	8526                	mv	a0,s1
    80000610:	fa3ff0ef          	jal	800005b2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80000614:	4719                	li	a4,6
    80000616:	040006b7          	lui	a3,0x4000
    8000061a:	0c000637          	lui	a2,0xc000
    8000061e:	85b2                	mv	a1,a2
    80000620:	8526                	mv	a0,s1
    80000622:	f91ff0ef          	jal	800005b2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000626:	00007917          	auipc	s2,0x7
    8000062a:	9da90913          	addi	s2,s2,-1574 # 80007000 <etext>
    8000062e:	4729                	li	a4,10
    80000630:	80007697          	auipc	a3,0x80007
    80000634:	9d068693          	addi	a3,a3,-1584 # 7000 <_entry-0x7fff9000>
    80000638:	4605                	li	a2,1
    8000063a:	067e                	slli	a2,a2,0x1f
    8000063c:	85b2                	mv	a1,a2
    8000063e:	8526                	mv	a0,s1
    80000640:	f73ff0ef          	jal	800005b2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000644:	4719                	li	a4,6
    80000646:	46c5                	li	a3,17
    80000648:	06ee                	slli	a3,a3,0x1b
    8000064a:	412686b3          	sub	a3,a3,s2
    8000064e:	864a                	mv	a2,s2
    80000650:	85ca                	mv	a1,s2
    80000652:	8526                	mv	a0,s1
    80000654:	f5fff0ef          	jal	800005b2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000658:	4729                	li	a4,10
    8000065a:	6685                	lui	a3,0x1
    8000065c:	00006617          	auipc	a2,0x6
    80000660:	9a460613          	addi	a2,a2,-1628 # 80006000 <_trampoline>
    80000664:	040005b7          	lui	a1,0x4000
    80000668:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000066a:	05b2                	slli	a1,a1,0xc
    8000066c:	8526                	mv	a0,s1
    8000066e:	f45ff0ef          	jal	800005b2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000672:	8526                	mv	a0,s1
    80000674:	5dc000ef          	jal	80000c50 <proc_mapstacks>
}
    80000678:	8526                	mv	a0,s1
    8000067a:	60e2                	ld	ra,24(sp)
    8000067c:	6442                	ld	s0,16(sp)
    8000067e:	64a2                	ld	s1,8(sp)
    80000680:	6902                	ld	s2,0(sp)
    80000682:	6105                	addi	sp,sp,32
    80000684:	8082                	ret

0000000080000686 <kvminit>:
{
    80000686:	1141                	addi	sp,sp,-16
    80000688:	e406                	sd	ra,8(sp)
    8000068a:	e022                	sd	s0,0(sp)
    8000068c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000068e:	f4dff0ef          	jal	800005da <kvmmake>
    80000692:	0000a797          	auipc	a5,0xa
    80000696:	e2a7bb23          	sd	a0,-458(a5) # 8000a4c8 <kernel_pagetable>
}
    8000069a:	60a2                	ld	ra,8(sp)
    8000069c:	6402                	ld	s0,0(sp)
    8000069e:	0141                	addi	sp,sp,16
    800006a0:	8082                	ret

00000000800006a2 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800006a2:	715d                	addi	sp,sp,-80
    800006a4:	e486                	sd	ra,72(sp)
    800006a6:	e0a2                	sd	s0,64(sp)
    800006a8:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800006aa:	03459793          	slli	a5,a1,0x34
    800006ae:	e39d                	bnez	a5,800006d4 <uvmunmap+0x32>
    800006b0:	f84a                	sd	s2,48(sp)
    800006b2:	f44e                	sd	s3,40(sp)
    800006b4:	f052                	sd	s4,32(sp)
    800006b6:	ec56                	sd	s5,24(sp)
    800006b8:	e85a                	sd	s6,16(sp)
    800006ba:	e45e                	sd	s7,8(sp)
    800006bc:	8a2a                	mv	s4,a0
    800006be:	892e                	mv	s2,a1
    800006c0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006c2:	0632                	slli	a2,a2,0xc
    800006c4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800006c8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006ca:	6b05                	lui	s6,0x1
    800006cc:	0735ff63          	bgeu	a1,s3,8000074a <uvmunmap+0xa8>
    800006d0:	fc26                	sd	s1,56(sp)
    800006d2:	a0a9                	j	8000071c <uvmunmap+0x7a>
    800006d4:	fc26                	sd	s1,56(sp)
    800006d6:	f84a                	sd	s2,48(sp)
    800006d8:	f44e                	sd	s3,40(sp)
    800006da:	f052                	sd	s4,32(sp)
    800006dc:	ec56                	sd	s5,24(sp)
    800006de:	e85a                	sd	s6,16(sp)
    800006e0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006e2:	00007517          	auipc	a0,0x7
    800006e6:	9de50513          	addi	a0,a0,-1570 # 800070c0 <etext+0xc0>
    800006ea:	62d040ef          	jal	80005516 <panic>
      panic("uvmunmap: walk");
    800006ee:	00007517          	auipc	a0,0x7
    800006f2:	9ea50513          	addi	a0,a0,-1558 # 800070d8 <etext+0xd8>
    800006f6:	621040ef          	jal	80005516 <panic>
      panic("uvmunmap: not mapped");
    800006fa:	00007517          	auipc	a0,0x7
    800006fe:	9ee50513          	addi	a0,a0,-1554 # 800070e8 <etext+0xe8>
    80000702:	615040ef          	jal	80005516 <panic>
      panic("uvmunmap: not a leaf");
    80000706:	00007517          	auipc	a0,0x7
    8000070a:	9fa50513          	addi	a0,a0,-1542 # 80007100 <etext+0x100>
    8000070e:	609040ef          	jal	80005516 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000712:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000716:	995a                	add	s2,s2,s6
    80000718:	03397863          	bgeu	s2,s3,80000748 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000071c:	4601                	li	a2,0
    8000071e:	85ca                	mv	a1,s2
    80000720:	8552                	mv	a0,s4
    80000722:	d03ff0ef          	jal	80000424 <walk>
    80000726:	84aa                	mv	s1,a0
    80000728:	d179                	beqz	a0,800006ee <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000072a:	6108                	ld	a0,0(a0)
    8000072c:	00157793          	andi	a5,a0,1
    80000730:	d7e9                	beqz	a5,800006fa <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	3ff57793          	andi	a5,a0,1023
    80000736:	fd7788e3          	beq	a5,s7,80000706 <uvmunmap+0x64>
    if(do_free){
    8000073a:	fc0a8ce3          	beqz	s5,80000712 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000073e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000740:	0532                	slli	a0,a0,0xc
    80000742:	8dbff0ef          	jal	8000001c <kfree>
    80000746:	b7f1                	j	80000712 <uvmunmap+0x70>
    80000748:	74e2                	ld	s1,56(sp)
    8000074a:	7942                	ld	s2,48(sp)
    8000074c:	79a2                	ld	s3,40(sp)
    8000074e:	7a02                	ld	s4,32(sp)
    80000750:	6ae2                	ld	s5,24(sp)
    80000752:	6b42                	ld	s6,16(sp)
    80000754:	6ba2                	ld	s7,8(sp)
  }
}
    80000756:	60a6                	ld	ra,72(sp)
    80000758:	6406                	ld	s0,64(sp)
    8000075a:	6161                	addi	sp,sp,80
    8000075c:	8082                	ret

000000008000075e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000075e:	1101                	addi	sp,sp,-32
    80000760:	ec06                	sd	ra,24(sp)
    80000762:	e822                	sd	s0,16(sp)
    80000764:	e426                	sd	s1,8(sp)
    80000766:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000768:	997ff0ef          	jal	800000fe <kalloc>
    8000076c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000076e:	c509                	beqz	a0,80000778 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000770:	6605                	lui	a2,0x1
    80000772:	4581                	li	a1,0
    80000774:	a1dff0ef          	jal	80000190 <memset>
  return pagetable;
}
    80000778:	8526                	mv	a0,s1
    8000077a:	60e2                	ld	ra,24(sp)
    8000077c:	6442                	ld	s0,16(sp)
    8000077e:	64a2                	ld	s1,8(sp)
    80000780:	6105                	addi	sp,sp,32
    80000782:	8082                	ret

0000000080000784 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000784:	7179                	addi	sp,sp,-48
    80000786:	f406                	sd	ra,40(sp)
    80000788:	f022                	sd	s0,32(sp)
    8000078a:	ec26                	sd	s1,24(sp)
    8000078c:	e84a                	sd	s2,16(sp)
    8000078e:	e44e                	sd	s3,8(sp)
    80000790:	e052                	sd	s4,0(sp)
    80000792:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000794:	6785                	lui	a5,0x1
    80000796:	04f67063          	bgeu	a2,a5,800007d6 <uvmfirst+0x52>
    8000079a:	8a2a                	mv	s4,a0
    8000079c:	89ae                	mv	s3,a1
    8000079e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800007a0:	95fff0ef          	jal	800000fe <kalloc>
    800007a4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800007a6:	6605                	lui	a2,0x1
    800007a8:	4581                	li	a1,0
    800007aa:	9e7ff0ef          	jal	80000190 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800007ae:	4779                	li	a4,30
    800007b0:	86ca                	mv	a3,s2
    800007b2:	6605                	lui	a2,0x1
    800007b4:	4581                	li	a1,0
    800007b6:	8552                	mv	a0,s4
    800007b8:	d45ff0ef          	jal	800004fc <mappages>
  memmove(mem, src, sz);
    800007bc:	8626                	mv	a2,s1
    800007be:	85ce                	mv	a1,s3
    800007c0:	854a                	mv	a0,s2
    800007c2:	a33ff0ef          	jal	800001f4 <memmove>
}
    800007c6:	70a2                	ld	ra,40(sp)
    800007c8:	7402                	ld	s0,32(sp)
    800007ca:	64e2                	ld	s1,24(sp)
    800007cc:	6942                	ld	s2,16(sp)
    800007ce:	69a2                	ld	s3,8(sp)
    800007d0:	6a02                	ld	s4,0(sp)
    800007d2:	6145                	addi	sp,sp,48
    800007d4:	8082                	ret
    panic("uvmfirst: more than a page");
    800007d6:	00007517          	auipc	a0,0x7
    800007da:	94250513          	addi	a0,a0,-1726 # 80007118 <etext+0x118>
    800007de:	539040ef          	jal	80005516 <panic>

00000000800007e2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007e2:	1101                	addi	sp,sp,-32
    800007e4:	ec06                	sd	ra,24(sp)
    800007e6:	e822                	sd	s0,16(sp)
    800007e8:	e426                	sd	s1,8(sp)
    800007ea:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007ec:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ee:	00b67d63          	bgeu	a2,a1,80000808 <uvmdealloc+0x26>
    800007f2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007f4:	6785                	lui	a5,0x1
    800007f6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007f8:	00f60733          	add	a4,a2,a5
    800007fc:	76fd                	lui	a3,0xfffff
    800007fe:	8f75                	and	a4,a4,a3
    80000800:	97ae                	add	a5,a5,a1
    80000802:	8ff5                	and	a5,a5,a3
    80000804:	00f76863          	bltu	a4,a5,80000814 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000808:	8526                	mv	a0,s1
    8000080a:	60e2                	ld	ra,24(sp)
    8000080c:	6442                	ld	s0,16(sp)
    8000080e:	64a2                	ld	s1,8(sp)
    80000810:	6105                	addi	sp,sp,32
    80000812:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000814:	8f99                	sub	a5,a5,a4
    80000816:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000818:	4685                	li	a3,1
    8000081a:	0007861b          	sext.w	a2,a5
    8000081e:	85ba                	mv	a1,a4
    80000820:	e83ff0ef          	jal	800006a2 <uvmunmap>
    80000824:	b7d5                	j	80000808 <uvmdealloc+0x26>

0000000080000826 <uvmalloc>:
  if(newsz < oldsz)
    80000826:	0ab66363          	bltu	a2,a1,800008cc <uvmalloc+0xa6>
{
    8000082a:	715d                	addi	sp,sp,-80
    8000082c:	e486                	sd	ra,72(sp)
    8000082e:	e0a2                	sd	s0,64(sp)
    80000830:	f052                	sd	s4,32(sp)
    80000832:	ec56                	sd	s5,24(sp)
    80000834:	e85a                	sd	s6,16(sp)
    80000836:	0880                	addi	s0,sp,80
    80000838:	8b2a                	mv	s6,a0
    8000083a:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000083c:	6785                	lui	a5,0x1
    8000083e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000840:	95be                	add	a1,a1,a5
    80000842:	77fd                	lui	a5,0xfffff
    80000844:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000848:	08ca7463          	bgeu	s4,a2,800008d0 <uvmalloc+0xaa>
    8000084c:	fc26                	sd	s1,56(sp)
    8000084e:	f84a                	sd	s2,48(sp)
    80000850:	f44e                	sd	s3,40(sp)
    80000852:	e45e                	sd	s7,8(sp)
    80000854:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80000856:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000858:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000085c:	8a3ff0ef          	jal	800000fe <kalloc>
    80000860:	84aa                	mv	s1,a0
    if(mem == 0){
    80000862:	c515                	beqz	a0,8000088e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000864:	864e                	mv	a2,s3
    80000866:	4581                	li	a1,0
    80000868:	929ff0ef          	jal	80000190 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000086c:	875e                	mv	a4,s7
    8000086e:	86a6                	mv	a3,s1
    80000870:	864e                	mv	a2,s3
    80000872:	85ca                	mv	a1,s2
    80000874:	855a                	mv	a0,s6
    80000876:	c87ff0ef          	jal	800004fc <mappages>
    8000087a:	e91d                	bnez	a0,800008b0 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000087c:	994e                	add	s2,s2,s3
    8000087e:	fd596fe3          	bltu	s2,s5,8000085c <uvmalloc+0x36>
  return newsz;
    80000882:	8556                	mv	a0,s5
    80000884:	74e2                	ld	s1,56(sp)
    80000886:	7942                	ld	s2,48(sp)
    80000888:	79a2                	ld	s3,40(sp)
    8000088a:	6ba2                	ld	s7,8(sp)
    8000088c:	a819                	j	800008a2 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000088e:	8652                	mv	a2,s4
    80000890:	85ca                	mv	a1,s2
    80000892:	855a                	mv	a0,s6
    80000894:	f4fff0ef          	jal	800007e2 <uvmdealloc>
      return 0;
    80000898:	4501                	li	a0,0
    8000089a:	74e2                	ld	s1,56(sp)
    8000089c:	7942                	ld	s2,48(sp)
    8000089e:	79a2                	ld	s3,40(sp)
    800008a0:	6ba2                	ld	s7,8(sp)
}
    800008a2:	60a6                	ld	ra,72(sp)
    800008a4:	6406                	ld	s0,64(sp)
    800008a6:	7a02                	ld	s4,32(sp)
    800008a8:	6ae2                	ld	s5,24(sp)
    800008aa:	6b42                	ld	s6,16(sp)
    800008ac:	6161                	addi	sp,sp,80
    800008ae:	8082                	ret
      kfree(mem);
    800008b0:	8526                	mv	a0,s1
    800008b2:	f6aff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800008b6:	8652                	mv	a2,s4
    800008b8:	85ca                	mv	a1,s2
    800008ba:	855a                	mv	a0,s6
    800008bc:	f27ff0ef          	jal	800007e2 <uvmdealloc>
      return 0;
    800008c0:	4501                	li	a0,0
    800008c2:	74e2                	ld	s1,56(sp)
    800008c4:	7942                	ld	s2,48(sp)
    800008c6:	79a2                	ld	s3,40(sp)
    800008c8:	6ba2                	ld	s7,8(sp)
    800008ca:	bfe1                	j	800008a2 <uvmalloc+0x7c>
    return oldsz;
    800008cc:	852e                	mv	a0,a1
}
    800008ce:	8082                	ret
  return newsz;
    800008d0:	8532                	mv	a0,a2
    800008d2:	bfc1                	j	800008a2 <uvmalloc+0x7c>

00000000800008d4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008d4:	7179                	addi	sp,sp,-48
    800008d6:	f406                	sd	ra,40(sp)
    800008d8:	f022                	sd	s0,32(sp)
    800008da:	ec26                	sd	s1,24(sp)
    800008dc:	e84a                	sd	s2,16(sp)
    800008de:	e44e                	sd	s3,8(sp)
    800008e0:	e052                	sd	s4,0(sp)
    800008e2:	1800                	addi	s0,sp,48
    800008e4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008e6:	84aa                	mv	s1,a0
    800008e8:	6905                	lui	s2,0x1
    800008ea:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008ec:	4985                	li	s3,1
    800008ee:	a819                	j	80000904 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008f0:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008f2:	00c79513          	slli	a0,a5,0xc
    800008f6:	fdfff0ef          	jal	800008d4 <freewalk>
      pagetable[i] = 0;
    800008fa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008fe:	04a1                	addi	s1,s1,8
    80000900:	01248f63          	beq	s1,s2,8000091e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000904:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000906:	00f7f713          	andi	a4,a5,15
    8000090a:	ff3703e3          	beq	a4,s3,800008f0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000090e:	8b85                	andi	a5,a5,1
    80000910:	d7fd                	beqz	a5,800008fe <freewalk+0x2a>
      panic("freewalk: leaf");
    80000912:	00007517          	auipc	a0,0x7
    80000916:	82650513          	addi	a0,a0,-2010 # 80007138 <etext+0x138>
    8000091a:	3fd040ef          	jal	80005516 <panic>
    }
  }
  kfree((void*)pagetable);
    8000091e:	8552                	mv	a0,s4
    80000920:	efcff0ef          	jal	8000001c <kfree>
}
    80000924:	70a2                	ld	ra,40(sp)
    80000926:	7402                	ld	s0,32(sp)
    80000928:	64e2                	ld	s1,24(sp)
    8000092a:	6942                	ld	s2,16(sp)
    8000092c:	69a2                	ld	s3,8(sp)
    8000092e:	6a02                	ld	s4,0(sp)
    80000930:	6145                	addi	sp,sp,48
    80000932:	8082                	ret

0000000080000934 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000934:	1101                	addi	sp,sp,-32
    80000936:	ec06                	sd	ra,24(sp)
    80000938:	e822                	sd	s0,16(sp)
    8000093a:	e426                	sd	s1,8(sp)
    8000093c:	1000                	addi	s0,sp,32
    8000093e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000940:	e989                	bnez	a1,80000952 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000942:	8526                	mv	a0,s1
    80000944:	f91ff0ef          	jal	800008d4 <freewalk>
}
    80000948:	60e2                	ld	ra,24(sp)
    8000094a:	6442                	ld	s0,16(sp)
    8000094c:	64a2                	ld	s1,8(sp)
    8000094e:	6105                	addi	sp,sp,32
    80000950:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000952:	6785                	lui	a5,0x1
    80000954:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000956:	95be                	add	a1,a1,a5
    80000958:	4685                	li	a3,1
    8000095a:	00c5d613          	srli	a2,a1,0xc
    8000095e:	4581                	li	a1,0
    80000960:	d43ff0ef          	jal	800006a2 <uvmunmap>
    80000964:	bff9                	j	80000942 <uvmfree+0xe>

0000000080000966 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000966:	ca4d                	beqz	a2,80000a18 <uvmcopy+0xb2>
{
    80000968:	715d                	addi	sp,sp,-80
    8000096a:	e486                	sd	ra,72(sp)
    8000096c:	e0a2                	sd	s0,64(sp)
    8000096e:	fc26                	sd	s1,56(sp)
    80000970:	f84a                	sd	s2,48(sp)
    80000972:	f44e                	sd	s3,40(sp)
    80000974:	f052                	sd	s4,32(sp)
    80000976:	ec56                	sd	s5,24(sp)
    80000978:	e85a                	sd	s6,16(sp)
    8000097a:	e45e                	sd	s7,8(sp)
    8000097c:	e062                	sd	s8,0(sp)
    8000097e:	0880                	addi	s0,sp,80
    80000980:	8baa                	mv	s7,a0
    80000982:	8b2e                	mv	s6,a1
    80000984:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000986:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000988:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000098a:	4601                	li	a2,0
    8000098c:	85ce                	mv	a1,s3
    8000098e:	855e                	mv	a0,s7
    80000990:	a95ff0ef          	jal	80000424 <walk>
    80000994:	cd1d                	beqz	a0,800009d2 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    80000996:	6118                	ld	a4,0(a0)
    80000998:	00177793          	andi	a5,a4,1
    8000099c:	c3a9                	beqz	a5,800009de <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    8000099e:	00a75593          	srli	a1,a4,0xa
    800009a2:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    800009a6:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800009aa:	f54ff0ef          	jal	800000fe <kalloc>
    800009ae:	892a                	mv	s2,a0
    800009b0:	c121                	beqz	a0,800009f0 <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    800009b2:	8652                	mv	a2,s4
    800009b4:	85e2                	mv	a1,s8
    800009b6:	83fff0ef          	jal	800001f4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800009ba:	8726                	mv	a4,s1
    800009bc:	86ca                	mv	a3,s2
    800009be:	8652                	mv	a2,s4
    800009c0:	85ce                	mv	a1,s3
    800009c2:	855a                	mv	a0,s6
    800009c4:	b39ff0ef          	jal	800004fc <mappages>
    800009c8:	e10d                	bnez	a0,800009ea <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    800009ca:	99d2                	add	s3,s3,s4
    800009cc:	fb59efe3          	bltu	s3,s5,8000098a <uvmcopy+0x24>
    800009d0:	a805                	j	80000a00 <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    800009d2:	00006517          	auipc	a0,0x6
    800009d6:	77650513          	addi	a0,a0,1910 # 80007148 <etext+0x148>
    800009da:	33d040ef          	jal	80005516 <panic>
      panic("uvmcopy: page not present");
    800009de:	00006517          	auipc	a0,0x6
    800009e2:	78a50513          	addi	a0,a0,1930 # 80007168 <etext+0x168>
    800009e6:	331040ef          	jal	80005516 <panic>
      kfree(mem);
    800009ea:	854a                	mv	a0,s2
    800009ec:	e30ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009f0:	4685                	li	a3,1
    800009f2:	00c9d613          	srli	a2,s3,0xc
    800009f6:	4581                	li	a1,0
    800009f8:	855a                	mv	a0,s6
    800009fa:	ca9ff0ef          	jal	800006a2 <uvmunmap>
  return -1;
    800009fe:	557d                	li	a0,-1
}
    80000a00:	60a6                	ld	ra,72(sp)
    80000a02:	6406                	ld	s0,64(sp)
    80000a04:	74e2                	ld	s1,56(sp)
    80000a06:	7942                	ld	s2,48(sp)
    80000a08:	79a2                	ld	s3,40(sp)
    80000a0a:	7a02                	ld	s4,32(sp)
    80000a0c:	6ae2                	ld	s5,24(sp)
    80000a0e:	6b42                	ld	s6,16(sp)
    80000a10:	6ba2                	ld	s7,8(sp)
    80000a12:	6c02                	ld	s8,0(sp)
    80000a14:	6161                	addi	sp,sp,80
    80000a16:	8082                	ret
  return 0;
    80000a18:	4501                	li	a0,0
}
    80000a1a:	8082                	ret

0000000080000a1c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000a1c:	1141                	addi	sp,sp,-16
    80000a1e:	e406                	sd	ra,8(sp)
    80000a20:	e022                	sd	s0,0(sp)
    80000a22:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000a24:	4601                	li	a2,0
    80000a26:	9ffff0ef          	jal	80000424 <walk>
  if(pte == 0)
    80000a2a:	c901                	beqz	a0,80000a3a <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a2c:	611c                	ld	a5,0(a0)
    80000a2e:	9bbd                	andi	a5,a5,-17
    80000a30:	e11c                	sd	a5,0(a0)
}
    80000a32:	60a2                	ld	ra,8(sp)
    80000a34:	6402                	ld	s0,0(sp)
    80000a36:	0141                	addi	sp,sp,16
    80000a38:	8082                	ret
    panic("uvmclear");
    80000a3a:	00006517          	auipc	a0,0x6
    80000a3e:	74e50513          	addi	a0,a0,1870 # 80007188 <etext+0x188>
    80000a42:	2d5040ef          	jal	80005516 <panic>

0000000080000a46 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a46:	c2d9                	beqz	a3,80000acc <copyout+0x86>
{
    80000a48:	711d                	addi	sp,sp,-96
    80000a4a:	ec86                	sd	ra,88(sp)
    80000a4c:	e8a2                	sd	s0,80(sp)
    80000a4e:	e4a6                	sd	s1,72(sp)
    80000a50:	e0ca                	sd	s2,64(sp)
    80000a52:	fc4e                	sd	s3,56(sp)
    80000a54:	f852                	sd	s4,48(sp)
    80000a56:	f456                	sd	s5,40(sp)
    80000a58:	f05a                	sd	s6,32(sp)
    80000a5a:	ec5e                	sd	s7,24(sp)
    80000a5c:	e862                	sd	s8,16(sp)
    80000a5e:	e466                	sd	s9,8(sp)
    80000a60:	e06a                	sd	s10,0(sp)
    80000a62:	1080                	addi	s0,sp,96
    80000a64:	8c2a                	mv	s8,a0
    80000a66:	892e                	mv	s2,a1
    80000a68:	8ab2                	mv	s5,a2
    80000a6a:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a6c:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    80000a6e:	5bfd                	li	s7,-1
    80000a70:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a74:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000a76:	6b05                	lui	s6,0x1
    80000a78:	a015                	j	80000a9c <copyout+0x56>
    pa0 = PTE2PA(*pte);
    80000a7a:	83a9                	srli	a5,a5,0xa
    80000a7c:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a7e:	41390533          	sub	a0,s2,s3
    80000a82:	0004861b          	sext.w	a2,s1
    80000a86:	85d6                	mv	a1,s5
    80000a88:	953e                	add	a0,a0,a5
    80000a8a:	f6aff0ef          	jal	800001f4 <memmove>

    len -= n;
    80000a8e:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a92:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a94:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000a98:	020a0863          	beqz	s4,80000ac8 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    80000a9c:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    80000aa0:	033be863          	bltu	s7,s3,80000ad0 <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    80000aa4:	4601                	li	a2,0
    80000aa6:	85ce                	mv	a1,s3
    80000aa8:	8562                	mv	a0,s8
    80000aaa:	97bff0ef          	jal	80000424 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000aae:	c121                	beqz	a0,80000aee <copyout+0xa8>
    80000ab0:	611c                	ld	a5,0(a0)
    80000ab2:	0157f713          	andi	a4,a5,21
    80000ab6:	03a71e63          	bne	a4,s10,80000af2 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000aba:	412984b3          	sub	s1,s3,s2
    80000abe:	94da                	add	s1,s1,s6
    if(n > len)
    80000ac0:	fa9a7de3          	bgeu	s4,s1,80000a7a <copyout+0x34>
    80000ac4:	84d2                	mv	s1,s4
    80000ac6:	bf55                	j	80000a7a <copyout+0x34>
  }
  return 0;
    80000ac8:	4501                	li	a0,0
    80000aca:	a021                	j	80000ad2 <copyout+0x8c>
    80000acc:	4501                	li	a0,0
}
    80000ace:	8082                	ret
      return -1;
    80000ad0:	557d                	li	a0,-1
}
    80000ad2:	60e6                	ld	ra,88(sp)
    80000ad4:	6446                	ld	s0,80(sp)
    80000ad6:	64a6                	ld	s1,72(sp)
    80000ad8:	6906                	ld	s2,64(sp)
    80000ada:	79e2                	ld	s3,56(sp)
    80000adc:	7a42                	ld	s4,48(sp)
    80000ade:	7aa2                	ld	s5,40(sp)
    80000ae0:	7b02                	ld	s6,32(sp)
    80000ae2:	6be2                	ld	s7,24(sp)
    80000ae4:	6c42                	ld	s8,16(sp)
    80000ae6:	6ca2                	ld	s9,8(sp)
    80000ae8:	6d02                	ld	s10,0(sp)
    80000aea:	6125                	addi	sp,sp,96
    80000aec:	8082                	ret
      return -1;
    80000aee:	557d                	li	a0,-1
    80000af0:	b7cd                	j	80000ad2 <copyout+0x8c>
    80000af2:	557d                	li	a0,-1
    80000af4:	bff9                	j	80000ad2 <copyout+0x8c>

0000000080000af6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af6:	c6a5                	beqz	a3,80000b5e <copyin+0x68>
{
    80000af8:	715d                	addi	sp,sp,-80
    80000afa:	e486                	sd	ra,72(sp)
    80000afc:	e0a2                	sd	s0,64(sp)
    80000afe:	fc26                	sd	s1,56(sp)
    80000b00:	f84a                	sd	s2,48(sp)
    80000b02:	f44e                	sd	s3,40(sp)
    80000b04:	f052                	sd	s4,32(sp)
    80000b06:	ec56                	sd	s5,24(sp)
    80000b08:	e85a                	sd	s6,16(sp)
    80000b0a:	e45e                	sd	s7,8(sp)
    80000b0c:	e062                	sd	s8,0(sp)
    80000b0e:	0880                	addi	s0,sp,80
    80000b10:	8b2a                	mv	s6,a0
    80000b12:	8a2e                	mv	s4,a1
    80000b14:	8c32                	mv	s8,a2
    80000b16:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b18:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b1a:	6a85                	lui	s5,0x1
    80000b1c:	a00d                	j	80000b3e <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b1e:	018505b3          	add	a1,a0,s8
    80000b22:	0004861b          	sext.w	a2,s1
    80000b26:	412585b3          	sub	a1,a1,s2
    80000b2a:	8552                	mv	a0,s4
    80000b2c:	ec8ff0ef          	jal	800001f4 <memmove>

    len -= n;
    80000b30:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b34:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b36:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b3a:	02098063          	beqz	s3,80000b5a <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b3e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b42:	85ca                	mv	a1,s2
    80000b44:	855a                	mv	a0,s6
    80000b46:	979ff0ef          	jal	800004be <walkaddr>
    if(pa0 == 0)
    80000b4a:	cd01                	beqz	a0,80000b62 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b4c:	418904b3          	sub	s1,s2,s8
    80000b50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b52:	fc99f6e3          	bgeu	s3,s1,80000b1e <copyin+0x28>
    80000b56:	84ce                	mv	s1,s3
    80000b58:	b7d9                	j	80000b1e <copyin+0x28>
  }
  return 0;
    80000b5a:	4501                	li	a0,0
    80000b5c:	a021                	j	80000b64 <copyin+0x6e>
    80000b5e:	4501                	li	a0,0
}
    80000b60:	8082                	ret
      return -1;
    80000b62:	557d                	li	a0,-1
}
    80000b64:	60a6                	ld	ra,72(sp)
    80000b66:	6406                	ld	s0,64(sp)
    80000b68:	74e2                	ld	s1,56(sp)
    80000b6a:	7942                	ld	s2,48(sp)
    80000b6c:	79a2                	ld	s3,40(sp)
    80000b6e:	7a02                	ld	s4,32(sp)
    80000b70:	6ae2                	ld	s5,24(sp)
    80000b72:	6b42                	ld	s6,16(sp)
    80000b74:	6ba2                	ld	s7,8(sp)
    80000b76:	6c02                	ld	s8,0(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret

0000000080000b7c <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b7c:	715d                	addi	sp,sp,-80
    80000b7e:	e486                	sd	ra,72(sp)
    80000b80:	e0a2                	sd	s0,64(sp)
    80000b82:	fc26                	sd	s1,56(sp)
    80000b84:	f84a                	sd	s2,48(sp)
    80000b86:	f44e                	sd	s3,40(sp)
    80000b88:	f052                	sd	s4,32(sp)
    80000b8a:	ec56                	sd	s5,24(sp)
    80000b8c:	e85a                	sd	s6,16(sp)
    80000b8e:	e45e                	sd	s7,8(sp)
    80000b90:	0880                	addi	s0,sp,80
    80000b92:	8aaa                	mv	s5,a0
    80000b94:	89ae                	mv	s3,a1
    80000b96:	8bb2                	mv	s7,a2
    80000b98:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b9a:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b9c:	6a05                	lui	s4,0x1
    80000b9e:	a02d                	j	80000bc8 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ba0:	00078023          	sb	zero,0(a5)
    80000ba4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ba6:	0017c793          	xori	a5,a5,1
    80000baa:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000bae:	60a6                	ld	ra,72(sp)
    80000bb0:	6406                	ld	s0,64(sp)
    80000bb2:	74e2                	ld	s1,56(sp)
    80000bb4:	7942                	ld	s2,48(sp)
    80000bb6:	79a2                	ld	s3,40(sp)
    80000bb8:	7a02                	ld	s4,32(sp)
    80000bba:	6ae2                	ld	s5,24(sp)
    80000bbc:	6b42                	ld	s6,16(sp)
    80000bbe:	6ba2                	ld	s7,8(sp)
    80000bc0:	6161                	addi	sp,sp,80
    80000bc2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000bc4:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000bc8:	c4b1                	beqz	s1,80000c14 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000bca:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000bce:	85ca                	mv	a1,s2
    80000bd0:	8556                	mv	a0,s5
    80000bd2:	8edff0ef          	jal	800004be <walkaddr>
    if(pa0 == 0)
    80000bd6:	c129                	beqz	a0,80000c18 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000bd8:	41790633          	sub	a2,s2,s7
    80000bdc:	9652                	add	a2,a2,s4
    if(n > max)
    80000bde:	00c4f363          	bgeu	s1,a2,80000be4 <copyinstr+0x68>
    80000be2:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000be4:	412b8bb3          	sub	s7,s7,s2
    80000be8:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000bea:	de69                	beqz	a2,80000bc4 <copyinstr+0x48>
    80000bec:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000bee:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000bf2:	964e                	add	a2,a2,s3
    80000bf4:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bf6:	00f68733          	add	a4,a3,a5
    80000bfa:	00074703          	lbu	a4,0(a4)
    80000bfe:	d34d                	beqz	a4,80000ba0 <copyinstr+0x24>
        *dst = *p;
    80000c00:	00e78023          	sb	a4,0(a5)
      dst++;
    80000c04:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c06:	fec797e3          	bne	a5,a2,80000bf4 <copyinstr+0x78>
    80000c0a:	14fd                	addi	s1,s1,-1
    80000c0c:	94ce                	add	s1,s1,s3
      --max;
    80000c0e:	8c8d                	sub	s1,s1,a1
    80000c10:	89be                	mv	s3,a5
    80000c12:	bf4d                	j	80000bc4 <copyinstr+0x48>
    80000c14:	4781                	li	a5,0
    80000c16:	bf41                	j	80000ba6 <copyinstr+0x2a>
      return -1;
    80000c18:	557d                	li	a0,-1
    80000c1a:	bf51                	j	80000bae <copyinstr+0x32>

0000000080000c1c <getNProc>:
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Get the number of currently running processes.
int getNProc() {
    80000c1c:	1141                	addi	sp,sp,-16
    80000c1e:	e406                	sd	ra,8(sp)
    80000c20:	e022                	sd	s0,0(sp)
    80000c22:	0800                	addi	s0,sp,16
  int nproc = 0;
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++)
    80000c24:	0000a797          	auipc	a5,0xa
    80000c28:	d1c78793          	addi	a5,a5,-740 # 8000a940 <proc>
  int nproc = 0;
    80000c2c:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++)
    80000c2e:	00010697          	auipc	a3,0x10
    80000c32:	91268693          	addi	a3,a3,-1774 # 80010540 <tickslock>
    80000c36:	a029                	j	80000c40 <getNProc+0x24>
    80000c38:	17078793          	addi	a5,a5,368
    80000c3c:	00d78663          	beq	a5,a3,80000c48 <getNProc+0x2c>
    if(p->state != UNUSED) ++nproc;
    80000c40:	4f98                	lw	a4,24(a5)
    80000c42:	db7d                	beqz	a4,80000c38 <getNProc+0x1c>
    80000c44:	2505                	addiw	a0,a0,1
    80000c46:	bfcd                	j	80000c38 <getNProc+0x1c>
  return nproc;
}
    80000c48:	60a2                	ld	ra,8(sp)
    80000c4a:	6402                	ld	s0,0(sp)
    80000c4c:	0141                	addi	sp,sp,16
    80000c4e:	8082                	ret

0000000080000c50 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c50:	715d                	addi	sp,sp,-80
    80000c52:	e486                	sd	ra,72(sp)
    80000c54:	e0a2                	sd	s0,64(sp)
    80000c56:	fc26                	sd	s1,56(sp)
    80000c58:	f84a                	sd	s2,48(sp)
    80000c5a:	f44e                	sd	s3,40(sp)
    80000c5c:	f052                	sd	s4,32(sp)
    80000c5e:	ec56                	sd	s5,24(sp)
    80000c60:	e85a                	sd	s6,16(sp)
    80000c62:	e45e                	sd	s7,8(sp)
    80000c64:	e062                	sd	s8,0(sp)
    80000c66:	0880                	addi	s0,sp,80
    80000c68:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c6a:	0000a497          	auipc	s1,0xa
    80000c6e:	cd648493          	addi	s1,s1,-810 # 8000a940 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c72:	8c26                	mv	s8,s1
    80000c74:	e9bd37b7          	lui	a5,0xe9bd3
    80000c78:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bafd87>
    80000c7c:	d37a7937          	lui	s2,0xd37a7
    80000c80:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff5378352e>
    80000c84:	1902                	slli	s2,s2,0x20
    80000c86:	993e                	add	s2,s2,a5
    80000c88:	040009b7          	lui	s3,0x4000
    80000c8c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c8e:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c90:	4b99                	li	s7,6
    80000c92:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c94:	00010a97          	auipc	s5,0x10
    80000c98:	8aca8a93          	addi	s5,s5,-1876 # 80010540 <tickslock>
    char *pa = kalloc();
    80000c9c:	c62ff0ef          	jal	800000fe <kalloc>
    80000ca0:	862a                	mv	a2,a0
    if(pa == 0)
    80000ca2:	c121                	beqz	a0,80000ce2 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000ca4:	418485b3          	sub	a1,s1,s8
    80000ca8:	8591                	srai	a1,a1,0x4
    80000caa:	032585b3          	mul	a1,a1,s2
    80000cae:	2585                	addiw	a1,a1,1
    80000cb0:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cb4:	875e                	mv	a4,s7
    80000cb6:	86da                	mv	a3,s6
    80000cb8:	40b985b3          	sub	a1,s3,a1
    80000cbc:	8552                	mv	a0,s4
    80000cbe:	8f5ff0ef          	jal	800005b2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc2:	17048493          	addi	s1,s1,368
    80000cc6:	fd549be3          	bne	s1,s5,80000c9c <proc_mapstacks+0x4c>
  }
}
    80000cca:	60a6                	ld	ra,72(sp)
    80000ccc:	6406                	ld	s0,64(sp)
    80000cce:	74e2                	ld	s1,56(sp)
    80000cd0:	7942                	ld	s2,48(sp)
    80000cd2:	79a2                	ld	s3,40(sp)
    80000cd4:	7a02                	ld	s4,32(sp)
    80000cd6:	6ae2                	ld	s5,24(sp)
    80000cd8:	6b42                	ld	s6,16(sp)
    80000cda:	6ba2                	ld	s7,8(sp)
    80000cdc:	6c02                	ld	s8,0(sp)
    80000cde:	6161                	addi	sp,sp,80
    80000ce0:	8082                	ret
      panic("kalloc");
    80000ce2:	00006517          	auipc	a0,0x6
    80000ce6:	4b650513          	addi	a0,a0,1206 # 80007198 <etext+0x198>
    80000cea:	02d040ef          	jal	80005516 <panic>

0000000080000cee <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cee:	7139                	addi	sp,sp,-64
    80000cf0:	fc06                	sd	ra,56(sp)
    80000cf2:	f822                	sd	s0,48(sp)
    80000cf4:	f426                	sd	s1,40(sp)
    80000cf6:	f04a                	sd	s2,32(sp)
    80000cf8:	ec4e                	sd	s3,24(sp)
    80000cfa:	e852                	sd	s4,16(sp)
    80000cfc:	e456                	sd	s5,8(sp)
    80000cfe:	e05a                	sd	s6,0(sp)
    80000d00:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d02:	00006597          	auipc	a1,0x6
    80000d06:	49e58593          	addi	a1,a1,1182 # 800071a0 <etext+0x1a0>
    80000d0a:	0000a517          	auipc	a0,0xa
    80000d0e:	80650513          	addi	a0,a0,-2042 # 8000a510 <pid_lock>
    80000d12:	2af040ef          	jal	800057c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d16:	00006597          	auipc	a1,0x6
    80000d1a:	49258593          	addi	a1,a1,1170 # 800071a8 <etext+0x1a8>
    80000d1e:	0000a517          	auipc	a0,0xa
    80000d22:	80a50513          	addi	a0,a0,-2038 # 8000a528 <wait_lock>
    80000d26:	29b040ef          	jal	800057c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2a:	0000a497          	auipc	s1,0xa
    80000d2e:	c1648493          	addi	s1,s1,-1002 # 8000a940 <proc>
      initlock(&p->lock, "proc");
    80000d32:	00006b17          	auipc	s6,0x6
    80000d36:	486b0b13          	addi	s6,s6,1158 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d3a:	8aa6                	mv	s5,s1
    80000d3c:	e9bd37b7          	lui	a5,0xe9bd3
    80000d40:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bafd87>
    80000d44:	d37a7937          	lui	s2,0xd37a7
    80000d48:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff5378352e>
    80000d4c:	1902                	slli	s2,s2,0x20
    80000d4e:	993e                	add	s2,s2,a5
    80000d50:	040009b7          	lui	s3,0x4000
    80000d54:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d56:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d58:	0000fa17          	auipc	s4,0xf
    80000d5c:	7e8a0a13          	addi	s4,s4,2024 # 80010540 <tickslock>
      initlock(&p->lock, "proc");
    80000d60:	85da                	mv	a1,s6
    80000d62:	8526                	mv	a0,s1
    80000d64:	25d040ef          	jal	800057c0 <initlock>
      p->state = UNUSED;
    80000d68:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d6c:	415487b3          	sub	a5,s1,s5
    80000d70:	8791                	srai	a5,a5,0x4
    80000d72:	032787b3          	mul	a5,a5,s2
    80000d76:	2785                	addiw	a5,a5,1
    80000d78:	00d7979b          	slliw	a5,a5,0xd
    80000d7c:	40f987b3          	sub	a5,s3,a5
    80000d80:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d82:	17048493          	addi	s1,s1,368
    80000d86:	fd449de3          	bne	s1,s4,80000d60 <procinit+0x72>
  }
}
    80000d8a:	70e2                	ld	ra,56(sp)
    80000d8c:	7442                	ld	s0,48(sp)
    80000d8e:	74a2                	ld	s1,40(sp)
    80000d90:	7902                	ld	s2,32(sp)
    80000d92:	69e2                	ld	s3,24(sp)
    80000d94:	6a42                	ld	s4,16(sp)
    80000d96:	6aa2                	ld	s5,8(sp)
    80000d98:	6b02                	ld	s6,0(sp)
    80000d9a:	6121                	addi	sp,sp,64
    80000d9c:	8082                	ret

0000000080000d9e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	e022                	sd	s0,0(sp)
    80000da4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000da6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000da8:	2501                	sext.w	a0,a0
    80000daa:	60a2                	ld	ra,8(sp)
    80000dac:	6402                	ld	s0,0(sp)
    80000dae:	0141                	addi	sp,sp,16
    80000db0:	8082                	ret

0000000080000db2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000db2:	1141                	addi	sp,sp,-16
    80000db4:	e406                	sd	ra,8(sp)
    80000db6:	e022                	sd	s0,0(sp)
    80000db8:	0800                	addi	s0,sp,16
    80000dba:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000dbc:	2781                	sext.w	a5,a5
    80000dbe:	079e                	slli	a5,a5,0x7
  return c;
}
    80000dc0:	00009517          	auipc	a0,0x9
    80000dc4:	78050513          	addi	a0,a0,1920 # 8000a540 <cpus>
    80000dc8:	953e                	add	a0,a0,a5
    80000dca:	60a2                	ld	ra,8(sp)
    80000dcc:	6402                	ld	s0,0(sp)
    80000dce:	0141                	addi	sp,sp,16
    80000dd0:	8082                	ret

0000000080000dd2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000dd2:	1101                	addi	sp,sp,-32
    80000dd4:	ec06                	sd	ra,24(sp)
    80000dd6:	e822                	sd	s0,16(sp)
    80000dd8:	e426                	sd	s1,8(sp)
    80000dda:	1000                	addi	s0,sp,32
  push_off();
    80000ddc:	229040ef          	jal	80005804 <push_off>
    80000de0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000de2:	2781                	sext.w	a5,a5
    80000de4:	079e                	slli	a5,a5,0x7
    80000de6:	00009717          	auipc	a4,0x9
    80000dea:	72a70713          	addi	a4,a4,1834 # 8000a510 <pid_lock>
    80000dee:	97ba                	add	a5,a5,a4
    80000df0:	7b84                	ld	s1,48(a5)
  pop_off();
    80000df2:	297040ef          	jal	80005888 <pop_off>
  return p;
}
    80000df6:	8526                	mv	a0,s1
    80000df8:	60e2                	ld	ra,24(sp)
    80000dfa:	6442                	ld	s0,16(sp)
    80000dfc:	64a2                	ld	s1,8(sp)
    80000dfe:	6105                	addi	sp,sp,32
    80000e00:	8082                	ret

0000000080000e02 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e02:	1141                	addi	sp,sp,-16
    80000e04:	e406                	sd	ra,8(sp)
    80000e06:	e022                	sd	s0,0(sp)
    80000e08:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e0a:	fc9ff0ef          	jal	80000dd2 <myproc>
    80000e0e:	2cb040ef          	jal	800058d8 <release>

  if (first) {
    80000e12:	00009797          	auipc	a5,0x9
    80000e16:	63e7a783          	lw	a5,1598(a5) # 8000a450 <first.1>
    80000e1a:	e799                	bnez	a5,80000e28 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000e1c:	2c9000ef          	jal	800018e4 <usertrapret>
}
    80000e20:	60a2                	ld	ra,8(sp)
    80000e22:	6402                	ld	s0,0(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret
    fsinit(ROOTDEV);
    80000e28:	4505                	li	a0,1
    80000e2a:	6d0010ef          	jal	800024fa <fsinit>
    first = 0;
    80000e2e:	00009797          	auipc	a5,0x9
    80000e32:	6207a123          	sw	zero,1570(a5) # 8000a450 <first.1>
    __sync_synchronize();
    80000e36:	0330000f          	fence	rw,rw
    80000e3a:	b7cd                	j	80000e1c <forkret+0x1a>

0000000080000e3c <allocpid>:
{
    80000e3c:	1101                	addi	sp,sp,-32
    80000e3e:	ec06                	sd	ra,24(sp)
    80000e40:	e822                	sd	s0,16(sp)
    80000e42:	e426                	sd	s1,8(sp)
    80000e44:	e04a                	sd	s2,0(sp)
    80000e46:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e48:	00009917          	auipc	s2,0x9
    80000e4c:	6c890913          	addi	s2,s2,1736 # 8000a510 <pid_lock>
    80000e50:	854a                	mv	a0,s2
    80000e52:	1f3040ef          	jal	80005844 <acquire>
  pid = nextpid;
    80000e56:	00009797          	auipc	a5,0x9
    80000e5a:	5fe78793          	addi	a5,a5,1534 # 8000a454 <nextpid>
    80000e5e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e60:	0014871b          	addiw	a4,s1,1
    80000e64:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e66:	854a                	mv	a0,s2
    80000e68:	271040ef          	jal	800058d8 <release>
}
    80000e6c:	8526                	mv	a0,s1
    80000e6e:	60e2                	ld	ra,24(sp)
    80000e70:	6442                	ld	s0,16(sp)
    80000e72:	64a2                	ld	s1,8(sp)
    80000e74:	6902                	ld	s2,0(sp)
    80000e76:	6105                	addi	sp,sp,32
    80000e78:	8082                	ret

0000000080000e7a <proc_pagetable>:
{
    80000e7a:	1101                	addi	sp,sp,-32
    80000e7c:	ec06                	sd	ra,24(sp)
    80000e7e:	e822                	sd	s0,16(sp)
    80000e80:	e426                	sd	s1,8(sp)
    80000e82:	e04a                	sd	s2,0(sp)
    80000e84:	1000                	addi	s0,sp,32
    80000e86:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e88:	8d7ff0ef          	jal	8000075e <uvmcreate>
    80000e8c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e8e:	cd05                	beqz	a0,80000ec6 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e90:	4729                	li	a4,10
    80000e92:	00005697          	auipc	a3,0x5
    80000e96:	16e68693          	addi	a3,a3,366 # 80006000 <_trampoline>
    80000e9a:	6605                	lui	a2,0x1
    80000e9c:	040005b7          	lui	a1,0x4000
    80000ea0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea2:	05b2                	slli	a1,a1,0xc
    80000ea4:	e58ff0ef          	jal	800004fc <mappages>
    80000ea8:	02054663          	bltz	a0,80000ed4 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eac:	4719                	li	a4,6
    80000eae:	05893683          	ld	a3,88(s2)
    80000eb2:	6605                	lui	a2,0x1
    80000eb4:	020005b7          	lui	a1,0x2000
    80000eb8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eba:	05b6                	slli	a1,a1,0xd
    80000ebc:	8526                	mv	a0,s1
    80000ebe:	e3eff0ef          	jal	800004fc <mappages>
    80000ec2:	00054f63          	bltz	a0,80000ee0 <proc_pagetable+0x66>
}
    80000ec6:	8526                	mv	a0,s1
    80000ec8:	60e2                	ld	ra,24(sp)
    80000eca:	6442                	ld	s0,16(sp)
    80000ecc:	64a2                	ld	s1,8(sp)
    80000ece:	6902                	ld	s2,0(sp)
    80000ed0:	6105                	addi	sp,sp,32
    80000ed2:	8082                	ret
    uvmfree(pagetable, 0);
    80000ed4:	4581                	li	a1,0
    80000ed6:	8526                	mv	a0,s1
    80000ed8:	a5dff0ef          	jal	80000934 <uvmfree>
    return 0;
    80000edc:	4481                	li	s1,0
    80000ede:	b7e5                	j	80000ec6 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee0:	4681                	li	a3,0
    80000ee2:	4605                	li	a2,1
    80000ee4:	040005b7          	lui	a1,0x4000
    80000ee8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eea:	05b2                	slli	a1,a1,0xc
    80000eec:	8526                	mv	a0,s1
    80000eee:	fb4ff0ef          	jal	800006a2 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ef2:	4581                	li	a1,0
    80000ef4:	8526                	mv	a0,s1
    80000ef6:	a3fff0ef          	jal	80000934 <uvmfree>
    return 0;
    80000efa:	4481                	li	s1,0
    80000efc:	b7e9                	j	80000ec6 <proc_pagetable+0x4c>

0000000080000efe <proc_freepagetable>:
{
    80000efe:	1101                	addi	sp,sp,-32
    80000f00:	ec06                	sd	ra,24(sp)
    80000f02:	e822                	sd	s0,16(sp)
    80000f04:	e426                	sd	s1,8(sp)
    80000f06:	e04a                	sd	s2,0(sp)
    80000f08:	1000                	addi	s0,sp,32
    80000f0a:	84aa                	mv	s1,a0
    80000f0c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f0e:	4681                	li	a3,0
    80000f10:	4605                	li	a2,1
    80000f12:	040005b7          	lui	a1,0x4000
    80000f16:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f18:	05b2                	slli	a1,a1,0xc
    80000f1a:	f88ff0ef          	jal	800006a2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f1e:	4681                	li	a3,0
    80000f20:	4605                	li	a2,1
    80000f22:	020005b7          	lui	a1,0x2000
    80000f26:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f28:	05b6                	slli	a1,a1,0xd
    80000f2a:	8526                	mv	a0,s1
    80000f2c:	f76ff0ef          	jal	800006a2 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f30:	85ca                	mv	a1,s2
    80000f32:	8526                	mv	a0,s1
    80000f34:	a01ff0ef          	jal	80000934 <uvmfree>
}
    80000f38:	60e2                	ld	ra,24(sp)
    80000f3a:	6442                	ld	s0,16(sp)
    80000f3c:	64a2                	ld	s1,8(sp)
    80000f3e:	6902                	ld	s2,0(sp)
    80000f40:	6105                	addi	sp,sp,32
    80000f42:	8082                	ret

0000000080000f44 <freeproc>:
{
    80000f44:	1101                	addi	sp,sp,-32
    80000f46:	ec06                	sd	ra,24(sp)
    80000f48:	e822                	sd	s0,16(sp)
    80000f4a:	e426                	sd	s1,8(sp)
    80000f4c:	1000                	addi	s0,sp,32
    80000f4e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f50:	6d28                	ld	a0,88(a0)
    80000f52:	c119                	beqz	a0,80000f58 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f54:	8c8ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f58:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f5c:	68a8                	ld	a0,80(s1)
    80000f5e:	c501                	beqz	a0,80000f66 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f60:	64ac                	ld	a1,72(s1)
    80000f62:	f9dff0ef          	jal	80000efe <proc_freepagetable>
  p->pagetable = 0;
    80000f66:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f6a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f6e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f72:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f76:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f7a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f7e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f82:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f86:	0004ac23          	sw	zero,24(s1)
}
    80000f8a:	60e2                	ld	ra,24(sp)
    80000f8c:	6442                	ld	s0,16(sp)
    80000f8e:	64a2                	ld	s1,8(sp)
    80000f90:	6105                	addi	sp,sp,32
    80000f92:	8082                	ret

0000000080000f94 <allocproc>:
{
    80000f94:	1101                	addi	sp,sp,-32
    80000f96:	ec06                	sd	ra,24(sp)
    80000f98:	e822                	sd	s0,16(sp)
    80000f9a:	e426                	sd	s1,8(sp)
    80000f9c:	e04a                	sd	s2,0(sp)
    80000f9e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa0:	0000a497          	auipc	s1,0xa
    80000fa4:	9a048493          	addi	s1,s1,-1632 # 8000a940 <proc>
    80000fa8:	0000f917          	auipc	s2,0xf
    80000fac:	59890913          	addi	s2,s2,1432 # 80010540 <tickslock>
    acquire(&p->lock);
    80000fb0:	8526                	mv	a0,s1
    80000fb2:	093040ef          	jal	80005844 <acquire>
    if(p->state == UNUSED) {
    80000fb6:	4c9c                	lw	a5,24(s1)
    80000fb8:	cb91                	beqz	a5,80000fcc <allocproc+0x38>
      release(&p->lock);
    80000fba:	8526                	mv	a0,s1
    80000fbc:	11d040ef          	jal	800058d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc0:	17048493          	addi	s1,s1,368
    80000fc4:	ff2496e3          	bne	s1,s2,80000fb0 <allocproc+0x1c>
  return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	a099                	j	80001010 <allocproc+0x7c>
  p->pid = allocpid();
    80000fcc:	e71ff0ef          	jal	80000e3c <allocpid>
    80000fd0:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fd2:	4785                	li	a5,1
    80000fd4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fd6:	928ff0ef          	jal	800000fe <kalloc>
    80000fda:	892a                	mv	s2,a0
    80000fdc:	eca8                	sd	a0,88(s1)
    80000fde:	c121                	beqz	a0,8000101e <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	e99ff0ef          	jal	80000e7a <proc_pagetable>
    80000fe6:	892a                	mv	s2,a0
    80000fe8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fea:	c131                	beqz	a0,8000102e <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80000fec:	07000613          	li	a2,112
    80000ff0:	4581                	li	a1,0
    80000ff2:	06048513          	addi	a0,s1,96
    80000ff6:	99aff0ef          	jal	80000190 <memset>
  p->context.ra = (uint64)forkret;
    80000ffa:	00000797          	auipc	a5,0x0
    80000ffe:	e0878793          	addi	a5,a5,-504 # 80000e02 <forkret>
    80001002:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001004:	60bc                	ld	a5,64(s1)
    80001006:	6705                	lui	a4,0x1
    80001008:	97ba                	add	a5,a5,a4
    8000100a:	f4bc                	sd	a5,104(s1)
  p->syscallMask = 0;
    8000100c:	1604a423          	sw	zero,360(s1)
}
    80001010:	8526                	mv	a0,s1
    80001012:	60e2                	ld	ra,24(sp)
    80001014:	6442                	ld	s0,16(sp)
    80001016:	64a2                	ld	s1,8(sp)
    80001018:	6902                	ld	s2,0(sp)
    8000101a:	6105                	addi	sp,sp,32
    8000101c:	8082                	ret
    freeproc(p);
    8000101e:	8526                	mv	a0,s1
    80001020:	f25ff0ef          	jal	80000f44 <freeproc>
    release(&p->lock);
    80001024:	8526                	mv	a0,s1
    80001026:	0b3040ef          	jal	800058d8 <release>
    return 0;
    8000102a:	84ca                	mv	s1,s2
    8000102c:	b7d5                	j	80001010 <allocproc+0x7c>
    freeproc(p);
    8000102e:	8526                	mv	a0,s1
    80001030:	f15ff0ef          	jal	80000f44 <freeproc>
    release(&p->lock);
    80001034:	8526                	mv	a0,s1
    80001036:	0a3040ef          	jal	800058d8 <release>
    return 0;
    8000103a:	84ca                	mv	s1,s2
    8000103c:	bfd1                	j	80001010 <allocproc+0x7c>

000000008000103e <userinit>:
{
    8000103e:	1101                	addi	sp,sp,-32
    80001040:	ec06                	sd	ra,24(sp)
    80001042:	e822                	sd	s0,16(sp)
    80001044:	e426                	sd	s1,8(sp)
    80001046:	1000                	addi	s0,sp,32
  p = allocproc();
    80001048:	f4dff0ef          	jal	80000f94 <allocproc>
    8000104c:	84aa                	mv	s1,a0
  initproc = p;
    8000104e:	00009797          	auipc	a5,0x9
    80001052:	48a7b123          	sd	a0,1154(a5) # 8000a4d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001056:	03400613          	li	a2,52
    8000105a:	00009597          	auipc	a1,0x9
    8000105e:	40658593          	addi	a1,a1,1030 # 8000a460 <initcode>
    80001062:	6928                	ld	a0,80(a0)
    80001064:	f20ff0ef          	jal	80000784 <uvmfirst>
  p->sz = PGSIZE;
    80001068:	6785                	lui	a5,0x1
    8000106a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000106c:	6cb8                	ld	a4,88(s1)
    8000106e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001072:	6cb8                	ld	a4,88(s1)
    80001074:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001076:	4641                	li	a2,16
    80001078:	00006597          	auipc	a1,0x6
    8000107c:	14858593          	addi	a1,a1,328 # 800071c0 <etext+0x1c0>
    80001080:	15848513          	addi	a0,s1,344
    80001084:	a5eff0ef          	jal	800002e2 <safestrcpy>
  p->cwd = namei("/");
    80001088:	00006517          	auipc	a0,0x6
    8000108c:	14850513          	addi	a0,a0,328 # 800071d0 <etext+0x1d0>
    80001090:	58f010ef          	jal	80002e1e <namei>
    80001094:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001098:	478d                	li	a5,3
    8000109a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000109c:	8526                	mv	a0,s1
    8000109e:	03b040ef          	jal	800058d8 <release>
}
    800010a2:	60e2                	ld	ra,24(sp)
    800010a4:	6442                	ld	s0,16(sp)
    800010a6:	64a2                	ld	s1,8(sp)
    800010a8:	6105                	addi	sp,sp,32
    800010aa:	8082                	ret

00000000800010ac <growproc>:
{
    800010ac:	1101                	addi	sp,sp,-32
    800010ae:	ec06                	sd	ra,24(sp)
    800010b0:	e822                	sd	s0,16(sp)
    800010b2:	e426                	sd	s1,8(sp)
    800010b4:	e04a                	sd	s2,0(sp)
    800010b6:	1000                	addi	s0,sp,32
    800010b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010ba:	d19ff0ef          	jal	80000dd2 <myproc>
    800010be:	84aa                	mv	s1,a0
  sz = p->sz;
    800010c0:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010c2:	01204c63          	bgtz	s2,800010da <growproc+0x2e>
  } else if(n < 0){
    800010c6:	02094463          	bltz	s2,800010ee <growproc+0x42>
  p->sz = sz;
    800010ca:	e4ac                	sd	a1,72(s1)
  return 0;
    800010cc:	4501                	li	a0,0
}
    800010ce:	60e2                	ld	ra,24(sp)
    800010d0:	6442                	ld	s0,16(sp)
    800010d2:	64a2                	ld	s1,8(sp)
    800010d4:	6902                	ld	s2,0(sp)
    800010d6:	6105                	addi	sp,sp,32
    800010d8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010da:	4691                	li	a3,4
    800010dc:	00b90633          	add	a2,s2,a1
    800010e0:	6928                	ld	a0,80(a0)
    800010e2:	f44ff0ef          	jal	80000826 <uvmalloc>
    800010e6:	85aa                	mv	a1,a0
    800010e8:	f16d                	bnez	a0,800010ca <growproc+0x1e>
      return -1;
    800010ea:	557d                	li	a0,-1
    800010ec:	b7cd                	j	800010ce <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010ee:	00b90633          	add	a2,s2,a1
    800010f2:	6928                	ld	a0,80(a0)
    800010f4:	eeeff0ef          	jal	800007e2 <uvmdealloc>
    800010f8:	85aa                	mv	a1,a0
    800010fa:	bfc1                	j	800010ca <growproc+0x1e>

00000000800010fc <fork>:
{
    800010fc:	7139                	addi	sp,sp,-64
    800010fe:	fc06                	sd	ra,56(sp)
    80001100:	f822                	sd	s0,48(sp)
    80001102:	f04a                	sd	s2,32(sp)
    80001104:	e456                	sd	s5,8(sp)
    80001106:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001108:	ccbff0ef          	jal	80000dd2 <myproc>
    8000110c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000110e:	e87ff0ef          	jal	80000f94 <allocproc>
    80001112:	0e050e63          	beqz	a0,8000120e <fork+0x112>
    80001116:	ec4e                	sd	s3,24(sp)
    80001118:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000111a:	048ab603          	ld	a2,72(s5)
    8000111e:	692c                	ld	a1,80(a0)
    80001120:	050ab503          	ld	a0,80(s5)
    80001124:	843ff0ef          	jal	80000966 <uvmcopy>
    80001128:	04054a63          	bltz	a0,8000117c <fork+0x80>
    8000112c:	f426                	sd	s1,40(sp)
    8000112e:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001130:	048ab783          	ld	a5,72(s5)
    80001134:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001138:	058ab683          	ld	a3,88(s5)
    8000113c:	87b6                	mv	a5,a3
    8000113e:	0589b703          	ld	a4,88(s3)
    80001142:	12068693          	addi	a3,a3,288
    80001146:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000114a:	6788                	ld	a0,8(a5)
    8000114c:	6b8c                	ld	a1,16(a5)
    8000114e:	6f90                	ld	a2,24(a5)
    80001150:	01073023          	sd	a6,0(a4)
    80001154:	e708                	sd	a0,8(a4)
    80001156:	eb0c                	sd	a1,16(a4)
    80001158:	ef10                	sd	a2,24(a4)
    8000115a:	02078793          	addi	a5,a5,32
    8000115e:	02070713          	addi	a4,a4,32
    80001162:	fed792e3          	bne	a5,a3,80001146 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001166:	0589b783          	ld	a5,88(s3)
    8000116a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000116e:	0d0a8493          	addi	s1,s5,208
    80001172:	0d098913          	addi	s2,s3,208
    80001176:	150a8a13          	addi	s4,s5,336
    8000117a:	a831                	j	80001196 <fork+0x9a>
    freeproc(np);
    8000117c:	854e                	mv	a0,s3
    8000117e:	dc7ff0ef          	jal	80000f44 <freeproc>
    release(&np->lock);
    80001182:	854e                	mv	a0,s3
    80001184:	754040ef          	jal	800058d8 <release>
    return -1;
    80001188:	597d                	li	s2,-1
    8000118a:	69e2                	ld	s3,24(sp)
    8000118c:	a895                	j	80001200 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    8000118e:	04a1                	addi	s1,s1,8
    80001190:	0921                	addi	s2,s2,8
    80001192:	01448963          	beq	s1,s4,800011a4 <fork+0xa8>
    if(p->ofile[i])
    80001196:	6088                	ld	a0,0(s1)
    80001198:	d97d                	beqz	a0,8000118e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000119a:	220020ef          	jal	800033ba <filedup>
    8000119e:	00a93023          	sd	a0,0(s2)
    800011a2:	b7f5                	j	8000118e <fork+0x92>
  np->cwd = idup(p->cwd);
    800011a4:	150ab503          	ld	a0,336(s5)
    800011a8:	550010ef          	jal	800026f8 <idup>
    800011ac:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800011b0:	4641                	li	a2,16
    800011b2:	158a8593          	addi	a1,s5,344
    800011b6:	15898513          	addi	a0,s3,344
    800011ba:	928ff0ef          	jal	800002e2 <safestrcpy>
  pid = np->pid;
    800011be:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800011c2:	854e                	mv	a0,s3
    800011c4:	714040ef          	jal	800058d8 <release>
  acquire(&wait_lock);
    800011c8:	00009497          	auipc	s1,0x9
    800011cc:	36048493          	addi	s1,s1,864 # 8000a528 <wait_lock>
    800011d0:	8526                	mv	a0,s1
    800011d2:	672040ef          	jal	80005844 <acquire>
  np->parent = p;
    800011d6:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800011da:	8526                	mv	a0,s1
    800011dc:	6fc040ef          	jal	800058d8 <release>
  acquire(&np->lock);
    800011e0:	854e                	mv	a0,s3
    800011e2:	662040ef          	jal	80005844 <acquire>
  np->state = RUNNABLE;
    800011e6:	478d                	li	a5,3
    800011e8:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011ec:	854e                	mv	a0,s3
    800011ee:	6ea040ef          	jal	800058d8 <release>
  np->syscallMask = p->syscallMask;
    800011f2:	168aa783          	lw	a5,360(s5)
    800011f6:	16f9a423          	sw	a5,360(s3)
  return pid;
    800011fa:	74a2                	ld	s1,40(sp)
    800011fc:	69e2                	ld	s3,24(sp)
    800011fe:	6a42                	ld	s4,16(sp)
}
    80001200:	854a                	mv	a0,s2
    80001202:	70e2                	ld	ra,56(sp)
    80001204:	7442                	ld	s0,48(sp)
    80001206:	7902                	ld	s2,32(sp)
    80001208:	6aa2                	ld	s5,8(sp)
    8000120a:	6121                	addi	sp,sp,64
    8000120c:	8082                	ret
    return -1;
    8000120e:	597d                	li	s2,-1
    80001210:	bfc5                	j	80001200 <fork+0x104>

0000000080001212 <scheduler>:
{
    80001212:	715d                	addi	sp,sp,-80
    80001214:	e486                	sd	ra,72(sp)
    80001216:	e0a2                	sd	s0,64(sp)
    80001218:	fc26                	sd	s1,56(sp)
    8000121a:	f84a                	sd	s2,48(sp)
    8000121c:	f44e                	sd	s3,40(sp)
    8000121e:	f052                	sd	s4,32(sp)
    80001220:	ec56                	sd	s5,24(sp)
    80001222:	e85a                	sd	s6,16(sp)
    80001224:	e45e                	sd	s7,8(sp)
    80001226:	e062                	sd	s8,0(sp)
    80001228:	0880                	addi	s0,sp,80
    8000122a:	8792                	mv	a5,tp
  int id = r_tp();
    8000122c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000122e:	00779b13          	slli	s6,a5,0x7
    80001232:	00009717          	auipc	a4,0x9
    80001236:	2de70713          	addi	a4,a4,734 # 8000a510 <pid_lock>
    8000123a:	975a                	add	a4,a4,s6
    8000123c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001240:	00009717          	auipc	a4,0x9
    80001244:	30870713          	addi	a4,a4,776 # 8000a548 <cpus+0x8>
    80001248:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000124a:	4c11                	li	s8,4
        c->proc = p;
    8000124c:	079e                	slli	a5,a5,0x7
    8000124e:	00009a17          	auipc	s4,0x9
    80001252:	2c2a0a13          	addi	s4,s4,706 # 8000a510 <pid_lock>
    80001256:	9a3e                	add	s4,s4,a5
        found = 1;
    80001258:	4b85                	li	s7,1
    8000125a:	a0a9                	j	800012a4 <scheduler+0x92>
      release(&p->lock);
    8000125c:	8526                	mv	a0,s1
    8000125e:	67a040ef          	jal	800058d8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001262:	17048493          	addi	s1,s1,368
    80001266:	03248563          	beq	s1,s2,80001290 <scheduler+0x7e>
      acquire(&p->lock);
    8000126a:	8526                	mv	a0,s1
    8000126c:	5d8040ef          	jal	80005844 <acquire>
      if(p->state == RUNNABLE) {
    80001270:	4c9c                	lw	a5,24(s1)
    80001272:	ff3795e3          	bne	a5,s3,8000125c <scheduler+0x4a>
        p->state = RUNNING;
    80001276:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000127a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000127e:	06048593          	addi	a1,s1,96
    80001282:	855a                	mv	a0,s6
    80001284:	5b6000ef          	jal	8000183a <swtch>
        c->proc = 0;
    80001288:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000128c:	8ade                	mv	s5,s7
    8000128e:	b7f9                	j	8000125c <scheduler+0x4a>
    if(found == 0) {
    80001290:	000a9a63          	bnez	s5,800012a4 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001294:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001298:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000129c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800012a0:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012a8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012ac:	10079073          	csrw	sstatus,a5
    int found = 0;
    800012b0:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012b2:	00009497          	auipc	s1,0x9
    800012b6:	68e48493          	addi	s1,s1,1678 # 8000a940 <proc>
      if(p->state == RUNNABLE) {
    800012ba:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800012bc:	0000f917          	auipc	s2,0xf
    800012c0:	28490913          	addi	s2,s2,644 # 80010540 <tickslock>
    800012c4:	b75d                	j	8000126a <scheduler+0x58>

00000000800012c6 <sched>:
{
    800012c6:	7179                	addi	sp,sp,-48
    800012c8:	f406                	sd	ra,40(sp)
    800012ca:	f022                	sd	s0,32(sp)
    800012cc:	ec26                	sd	s1,24(sp)
    800012ce:	e84a                	sd	s2,16(sp)
    800012d0:	e44e                	sd	s3,8(sp)
    800012d2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012d4:	affff0ef          	jal	80000dd2 <myproc>
    800012d8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012da:	500040ef          	jal	800057da <holding>
    800012de:	c92d                	beqz	a0,80001350 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012e0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012e2:	2781                	sext.w	a5,a5
    800012e4:	079e                	slli	a5,a5,0x7
    800012e6:	00009717          	auipc	a4,0x9
    800012ea:	22a70713          	addi	a4,a4,554 # 8000a510 <pid_lock>
    800012ee:	97ba                	add	a5,a5,a4
    800012f0:	0a87a703          	lw	a4,168(a5)
    800012f4:	4785                	li	a5,1
    800012f6:	06f71363          	bne	a4,a5,8000135c <sched+0x96>
  if(p->state == RUNNING)
    800012fa:	4c98                	lw	a4,24(s1)
    800012fc:	4791                	li	a5,4
    800012fe:	06f70563          	beq	a4,a5,80001368 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001302:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001306:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001308:	e7b5                	bnez	a5,80001374 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000130a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000130c:	00009917          	auipc	s2,0x9
    80001310:	20490913          	addi	s2,s2,516 # 8000a510 <pid_lock>
    80001314:	2781                	sext.w	a5,a5
    80001316:	079e                	slli	a5,a5,0x7
    80001318:	97ca                	add	a5,a5,s2
    8000131a:	0ac7a983          	lw	s3,172(a5)
    8000131e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001320:	2781                	sext.w	a5,a5
    80001322:	079e                	slli	a5,a5,0x7
    80001324:	00009597          	auipc	a1,0x9
    80001328:	22458593          	addi	a1,a1,548 # 8000a548 <cpus+0x8>
    8000132c:	95be                	add	a1,a1,a5
    8000132e:	06048513          	addi	a0,s1,96
    80001332:	508000ef          	jal	8000183a <swtch>
    80001336:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001338:	2781                	sext.w	a5,a5
    8000133a:	079e                	slli	a5,a5,0x7
    8000133c:	993e                	add	s2,s2,a5
    8000133e:	0b392623          	sw	s3,172(s2)
}
    80001342:	70a2                	ld	ra,40(sp)
    80001344:	7402                	ld	s0,32(sp)
    80001346:	64e2                	ld	s1,24(sp)
    80001348:	6942                	ld	s2,16(sp)
    8000134a:	69a2                	ld	s3,8(sp)
    8000134c:	6145                	addi	sp,sp,48
    8000134e:	8082                	ret
    panic("sched p->lock");
    80001350:	00006517          	auipc	a0,0x6
    80001354:	e8850513          	addi	a0,a0,-376 # 800071d8 <etext+0x1d8>
    80001358:	1be040ef          	jal	80005516 <panic>
    panic("sched locks");
    8000135c:	00006517          	auipc	a0,0x6
    80001360:	e8c50513          	addi	a0,a0,-372 # 800071e8 <etext+0x1e8>
    80001364:	1b2040ef          	jal	80005516 <panic>
    panic("sched running");
    80001368:	00006517          	auipc	a0,0x6
    8000136c:	e9050513          	addi	a0,a0,-368 # 800071f8 <etext+0x1f8>
    80001370:	1a6040ef          	jal	80005516 <panic>
    panic("sched interruptible");
    80001374:	00006517          	auipc	a0,0x6
    80001378:	e9450513          	addi	a0,a0,-364 # 80007208 <etext+0x208>
    8000137c:	19a040ef          	jal	80005516 <panic>

0000000080001380 <yield>:
{
    80001380:	1101                	addi	sp,sp,-32
    80001382:	ec06                	sd	ra,24(sp)
    80001384:	e822                	sd	s0,16(sp)
    80001386:	e426                	sd	s1,8(sp)
    80001388:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000138a:	a49ff0ef          	jal	80000dd2 <myproc>
    8000138e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001390:	4b4040ef          	jal	80005844 <acquire>
  p->state = RUNNABLE;
    80001394:	478d                	li	a5,3
    80001396:	cc9c                	sw	a5,24(s1)
  sched();
    80001398:	f2fff0ef          	jal	800012c6 <sched>
  release(&p->lock);
    8000139c:	8526                	mv	a0,s1
    8000139e:	53a040ef          	jal	800058d8 <release>
}
    800013a2:	60e2                	ld	ra,24(sp)
    800013a4:	6442                	ld	s0,16(sp)
    800013a6:	64a2                	ld	s1,8(sp)
    800013a8:	6105                	addi	sp,sp,32
    800013aa:	8082                	ret

00000000800013ac <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800013ac:	7179                	addi	sp,sp,-48
    800013ae:	f406                	sd	ra,40(sp)
    800013b0:	f022                	sd	s0,32(sp)
    800013b2:	ec26                	sd	s1,24(sp)
    800013b4:	e84a                	sd	s2,16(sp)
    800013b6:	e44e                	sd	s3,8(sp)
    800013b8:	1800                	addi	s0,sp,48
    800013ba:	89aa                	mv	s3,a0
    800013bc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013be:	a15ff0ef          	jal	80000dd2 <myproc>
    800013c2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013c4:	480040ef          	jal	80005844 <acquire>
  release(lk);
    800013c8:	854a                	mv	a0,s2
    800013ca:	50e040ef          	jal	800058d8 <release>

  // Go to sleep.
  p->chan = chan;
    800013ce:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013d2:	4789                	li	a5,2
    800013d4:	cc9c                	sw	a5,24(s1)

  sched();
    800013d6:	ef1ff0ef          	jal	800012c6 <sched>

  // Tidy up.
  p->chan = 0;
    800013da:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013de:	8526                	mv	a0,s1
    800013e0:	4f8040ef          	jal	800058d8 <release>
  acquire(lk);
    800013e4:	854a                	mv	a0,s2
    800013e6:	45e040ef          	jal	80005844 <acquire>
}
    800013ea:	70a2                	ld	ra,40(sp)
    800013ec:	7402                	ld	s0,32(sp)
    800013ee:	64e2                	ld	s1,24(sp)
    800013f0:	6942                	ld	s2,16(sp)
    800013f2:	69a2                	ld	s3,8(sp)
    800013f4:	6145                	addi	sp,sp,48
    800013f6:	8082                	ret

00000000800013f8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013f8:	7139                	addi	sp,sp,-64
    800013fa:	fc06                	sd	ra,56(sp)
    800013fc:	f822                	sd	s0,48(sp)
    800013fe:	f426                	sd	s1,40(sp)
    80001400:	f04a                	sd	s2,32(sp)
    80001402:	ec4e                	sd	s3,24(sp)
    80001404:	e852                	sd	s4,16(sp)
    80001406:	e456                	sd	s5,8(sp)
    80001408:	0080                	addi	s0,sp,64
    8000140a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000140c:	00009497          	auipc	s1,0x9
    80001410:	53448493          	addi	s1,s1,1332 # 8000a940 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001414:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001416:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001418:	0000f917          	auipc	s2,0xf
    8000141c:	12890913          	addi	s2,s2,296 # 80010540 <tickslock>
    80001420:	a801                	j	80001430 <wakeup+0x38>
      }
      release(&p->lock);
    80001422:	8526                	mv	a0,s1
    80001424:	4b4040ef          	jal	800058d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001428:	17048493          	addi	s1,s1,368
    8000142c:	03248263          	beq	s1,s2,80001450 <wakeup+0x58>
    if(p != myproc()){
    80001430:	9a3ff0ef          	jal	80000dd2 <myproc>
    80001434:	fea48ae3          	beq	s1,a0,80001428 <wakeup+0x30>
      acquire(&p->lock);
    80001438:	8526                	mv	a0,s1
    8000143a:	40a040ef          	jal	80005844 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000143e:	4c9c                	lw	a5,24(s1)
    80001440:	ff3791e3          	bne	a5,s3,80001422 <wakeup+0x2a>
    80001444:	709c                	ld	a5,32(s1)
    80001446:	fd479ee3          	bne	a5,s4,80001422 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000144a:	0154ac23          	sw	s5,24(s1)
    8000144e:	bfd1                	j	80001422 <wakeup+0x2a>
    }
  }
}
    80001450:	70e2                	ld	ra,56(sp)
    80001452:	7442                	ld	s0,48(sp)
    80001454:	74a2                	ld	s1,40(sp)
    80001456:	7902                	ld	s2,32(sp)
    80001458:	69e2                	ld	s3,24(sp)
    8000145a:	6a42                	ld	s4,16(sp)
    8000145c:	6aa2                	ld	s5,8(sp)
    8000145e:	6121                	addi	sp,sp,64
    80001460:	8082                	ret

0000000080001462 <reparent>:
{
    80001462:	7179                	addi	sp,sp,-48
    80001464:	f406                	sd	ra,40(sp)
    80001466:	f022                	sd	s0,32(sp)
    80001468:	ec26                	sd	s1,24(sp)
    8000146a:	e84a                	sd	s2,16(sp)
    8000146c:	e44e                	sd	s3,8(sp)
    8000146e:	e052                	sd	s4,0(sp)
    80001470:	1800                	addi	s0,sp,48
    80001472:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001474:	00009497          	auipc	s1,0x9
    80001478:	4cc48493          	addi	s1,s1,1228 # 8000a940 <proc>
      pp->parent = initproc;
    8000147c:	00009a17          	auipc	s4,0x9
    80001480:	054a0a13          	addi	s4,s4,84 # 8000a4d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001484:	0000f997          	auipc	s3,0xf
    80001488:	0bc98993          	addi	s3,s3,188 # 80010540 <tickslock>
    8000148c:	a029                	j	80001496 <reparent+0x34>
    8000148e:	17048493          	addi	s1,s1,368
    80001492:	01348b63          	beq	s1,s3,800014a8 <reparent+0x46>
    if(pp->parent == p){
    80001496:	7c9c                	ld	a5,56(s1)
    80001498:	ff279be3          	bne	a5,s2,8000148e <reparent+0x2c>
      pp->parent = initproc;
    8000149c:	000a3503          	ld	a0,0(s4)
    800014a0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800014a2:	f57ff0ef          	jal	800013f8 <wakeup>
    800014a6:	b7e5                	j	8000148e <reparent+0x2c>
}
    800014a8:	70a2                	ld	ra,40(sp)
    800014aa:	7402                	ld	s0,32(sp)
    800014ac:	64e2                	ld	s1,24(sp)
    800014ae:	6942                	ld	s2,16(sp)
    800014b0:	69a2                	ld	s3,8(sp)
    800014b2:	6a02                	ld	s4,0(sp)
    800014b4:	6145                	addi	sp,sp,48
    800014b6:	8082                	ret

00000000800014b8 <exit>:
{
    800014b8:	7179                	addi	sp,sp,-48
    800014ba:	f406                	sd	ra,40(sp)
    800014bc:	f022                	sd	s0,32(sp)
    800014be:	ec26                	sd	s1,24(sp)
    800014c0:	e84a                	sd	s2,16(sp)
    800014c2:	e44e                	sd	s3,8(sp)
    800014c4:	e052                	sd	s4,0(sp)
    800014c6:	1800                	addi	s0,sp,48
    800014c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014ca:	909ff0ef          	jal	80000dd2 <myproc>
    800014ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800014d0:	00009797          	auipc	a5,0x9
    800014d4:	0007b783          	ld	a5,0(a5) # 8000a4d0 <initproc>
    800014d8:	0d050493          	addi	s1,a0,208
    800014dc:	15050913          	addi	s2,a0,336
    800014e0:	00a79b63          	bne	a5,a0,800014f6 <exit+0x3e>
    panic("init exiting");
    800014e4:	00006517          	auipc	a0,0x6
    800014e8:	d3c50513          	addi	a0,a0,-708 # 80007220 <etext+0x220>
    800014ec:	02a040ef          	jal	80005516 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800014f0:	04a1                	addi	s1,s1,8
    800014f2:	01248963          	beq	s1,s2,80001504 <exit+0x4c>
    if(p->ofile[fd]){
    800014f6:	6088                	ld	a0,0(s1)
    800014f8:	dd65                	beqz	a0,800014f0 <exit+0x38>
      fileclose(f);
    800014fa:	707010ef          	jal	80003400 <fileclose>
      p->ofile[fd] = 0;
    800014fe:	0004b023          	sd	zero,0(s1)
    80001502:	b7fd                	j	800014f0 <exit+0x38>
  begin_op();
    80001504:	2dd010ef          	jal	80002fe0 <begin_op>
  iput(p->cwd);
    80001508:	1509b503          	ld	a0,336(s3)
    8000150c:	3a4010ef          	jal	800028b0 <iput>
  end_op();
    80001510:	33b010ef          	jal	8000304a <end_op>
  p->cwd = 0;
    80001514:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001518:	00009497          	auipc	s1,0x9
    8000151c:	01048493          	addi	s1,s1,16 # 8000a528 <wait_lock>
    80001520:	8526                	mv	a0,s1
    80001522:	322040ef          	jal	80005844 <acquire>
  reparent(p);
    80001526:	854e                	mv	a0,s3
    80001528:	f3bff0ef          	jal	80001462 <reparent>
  wakeup(p->parent);
    8000152c:	0389b503          	ld	a0,56(s3)
    80001530:	ec9ff0ef          	jal	800013f8 <wakeup>
  acquire(&p->lock);
    80001534:	854e                	mv	a0,s3
    80001536:	30e040ef          	jal	80005844 <acquire>
  p->xstate = status;
    8000153a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000153e:	4795                	li	a5,5
    80001540:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001544:	8526                	mv	a0,s1
    80001546:	392040ef          	jal	800058d8 <release>
  sched();
    8000154a:	d7dff0ef          	jal	800012c6 <sched>
  panic("zombie exit");
    8000154e:	00006517          	auipc	a0,0x6
    80001552:	ce250513          	addi	a0,a0,-798 # 80007230 <etext+0x230>
    80001556:	7c1030ef          	jal	80005516 <panic>

000000008000155a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000155a:	7179                	addi	sp,sp,-48
    8000155c:	f406                	sd	ra,40(sp)
    8000155e:	f022                	sd	s0,32(sp)
    80001560:	ec26                	sd	s1,24(sp)
    80001562:	e84a                	sd	s2,16(sp)
    80001564:	e44e                	sd	s3,8(sp)
    80001566:	1800                	addi	s0,sp,48
    80001568:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000156a:	00009497          	auipc	s1,0x9
    8000156e:	3d648493          	addi	s1,s1,982 # 8000a940 <proc>
    80001572:	0000f997          	auipc	s3,0xf
    80001576:	fce98993          	addi	s3,s3,-50 # 80010540 <tickslock>
    acquire(&p->lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	2c8040ef          	jal	80005844 <acquire>
    if(p->pid == pid){
    80001580:	589c                	lw	a5,48(s1)
    80001582:	01278b63          	beq	a5,s2,80001598 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001586:	8526                	mv	a0,s1
    80001588:	350040ef          	jal	800058d8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000158c:	17048493          	addi	s1,s1,368
    80001590:	ff3495e3          	bne	s1,s3,8000157a <kill+0x20>
  }
  return -1;
    80001594:	557d                	li	a0,-1
    80001596:	a819                	j	800015ac <kill+0x52>
      p->killed = 1;
    80001598:	4785                	li	a5,1
    8000159a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000159c:	4c98                	lw	a4,24(s1)
    8000159e:	4789                	li	a5,2
    800015a0:	00f70d63          	beq	a4,a5,800015ba <kill+0x60>
      release(&p->lock);
    800015a4:	8526                	mv	a0,s1
    800015a6:	332040ef          	jal	800058d8 <release>
      return 0;
    800015aa:	4501                	li	a0,0
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret
        p->state = RUNNABLE;
    800015ba:	478d                	li	a5,3
    800015bc:	cc9c                	sw	a5,24(s1)
    800015be:	b7dd                	j	800015a4 <kill+0x4a>

00000000800015c0 <setkilled>:

void
setkilled(struct proc *p)
{
    800015c0:	1101                	addi	sp,sp,-32
    800015c2:	ec06                	sd	ra,24(sp)
    800015c4:	e822                	sd	s0,16(sp)
    800015c6:	e426                	sd	s1,8(sp)
    800015c8:	1000                	addi	s0,sp,32
    800015ca:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015cc:	278040ef          	jal	80005844 <acquire>
  p->killed = 1;
    800015d0:	4785                	li	a5,1
    800015d2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015d4:	8526                	mv	a0,s1
    800015d6:	302040ef          	jal	800058d8 <release>
}
    800015da:	60e2                	ld	ra,24(sp)
    800015dc:	6442                	ld	s0,16(sp)
    800015de:	64a2                	ld	s1,8(sp)
    800015e0:	6105                	addi	sp,sp,32
    800015e2:	8082                	ret

00000000800015e4 <killed>:

int
killed(struct proc *p)
{
    800015e4:	1101                	addi	sp,sp,-32
    800015e6:	ec06                	sd	ra,24(sp)
    800015e8:	e822                	sd	s0,16(sp)
    800015ea:	e426                	sd	s1,8(sp)
    800015ec:	e04a                	sd	s2,0(sp)
    800015ee:	1000                	addi	s0,sp,32
    800015f0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015f2:	252040ef          	jal	80005844 <acquire>
  k = p->killed;
    800015f6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015fa:	8526                	mv	a0,s1
    800015fc:	2dc040ef          	jal	800058d8 <release>
  return k;
}
    80001600:	854a                	mv	a0,s2
    80001602:	60e2                	ld	ra,24(sp)
    80001604:	6442                	ld	s0,16(sp)
    80001606:	64a2                	ld	s1,8(sp)
    80001608:	6902                	ld	s2,0(sp)
    8000160a:	6105                	addi	sp,sp,32
    8000160c:	8082                	ret

000000008000160e <wait>:
{
    8000160e:	715d                	addi	sp,sp,-80
    80001610:	e486                	sd	ra,72(sp)
    80001612:	e0a2                	sd	s0,64(sp)
    80001614:	fc26                	sd	s1,56(sp)
    80001616:	f84a                	sd	s2,48(sp)
    80001618:	f44e                	sd	s3,40(sp)
    8000161a:	f052                	sd	s4,32(sp)
    8000161c:	ec56                	sd	s5,24(sp)
    8000161e:	e85a                	sd	s6,16(sp)
    80001620:	e45e                	sd	s7,8(sp)
    80001622:	0880                	addi	s0,sp,80
    80001624:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001626:	facff0ef          	jal	80000dd2 <myproc>
    8000162a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000162c:	00009517          	auipc	a0,0x9
    80001630:	efc50513          	addi	a0,a0,-260 # 8000a528 <wait_lock>
    80001634:	210040ef          	jal	80005844 <acquire>
        if(pp->state == ZOMBIE){
    80001638:	4a15                	li	s4,5
        havekids = 1;
    8000163a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163c:	0000f997          	auipc	s3,0xf
    80001640:	f0498993          	addi	s3,s3,-252 # 80010540 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001644:	00009b97          	auipc	s7,0x9
    80001648:	ee4b8b93          	addi	s7,s7,-284 # 8000a528 <wait_lock>
    8000164c:	a869                	j	800016e6 <wait+0xd8>
          pid = pp->pid;
    8000164e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001652:	000b0c63          	beqz	s6,8000166a <wait+0x5c>
    80001656:	4691                	li	a3,4
    80001658:	02c48613          	addi	a2,s1,44
    8000165c:	85da                	mv	a1,s6
    8000165e:	05093503          	ld	a0,80(s2)
    80001662:	be4ff0ef          	jal	80000a46 <copyout>
    80001666:	02054a63          	bltz	a0,8000169a <wait+0x8c>
          freeproc(pp);
    8000166a:	8526                	mv	a0,s1
    8000166c:	8d9ff0ef          	jal	80000f44 <freeproc>
          release(&pp->lock);
    80001670:	8526                	mv	a0,s1
    80001672:	266040ef          	jal	800058d8 <release>
          release(&wait_lock);
    80001676:	00009517          	auipc	a0,0x9
    8000167a:	eb250513          	addi	a0,a0,-334 # 8000a528 <wait_lock>
    8000167e:	25a040ef          	jal	800058d8 <release>
}
    80001682:	854e                	mv	a0,s3
    80001684:	60a6                	ld	ra,72(sp)
    80001686:	6406                	ld	s0,64(sp)
    80001688:	74e2                	ld	s1,56(sp)
    8000168a:	7942                	ld	s2,48(sp)
    8000168c:	79a2                	ld	s3,40(sp)
    8000168e:	7a02                	ld	s4,32(sp)
    80001690:	6ae2                	ld	s5,24(sp)
    80001692:	6b42                	ld	s6,16(sp)
    80001694:	6ba2                	ld	s7,8(sp)
    80001696:	6161                	addi	sp,sp,80
    80001698:	8082                	ret
            release(&pp->lock);
    8000169a:	8526                	mv	a0,s1
    8000169c:	23c040ef          	jal	800058d8 <release>
            release(&wait_lock);
    800016a0:	00009517          	auipc	a0,0x9
    800016a4:	e8850513          	addi	a0,a0,-376 # 8000a528 <wait_lock>
    800016a8:	230040ef          	jal	800058d8 <release>
            return -1;
    800016ac:	59fd                	li	s3,-1
    800016ae:	bfd1                	j	80001682 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b0:	17048493          	addi	s1,s1,368
    800016b4:	03348063          	beq	s1,s3,800016d4 <wait+0xc6>
      if(pp->parent == p){
    800016b8:	7c9c                	ld	a5,56(s1)
    800016ba:	ff279be3          	bne	a5,s2,800016b0 <wait+0xa2>
        acquire(&pp->lock);
    800016be:	8526                	mv	a0,s1
    800016c0:	184040ef          	jal	80005844 <acquire>
        if(pp->state == ZOMBIE){
    800016c4:	4c9c                	lw	a5,24(s1)
    800016c6:	f94784e3          	beq	a5,s4,8000164e <wait+0x40>
        release(&pp->lock);
    800016ca:	8526                	mv	a0,s1
    800016cc:	20c040ef          	jal	800058d8 <release>
        havekids = 1;
    800016d0:	8756                	mv	a4,s5
    800016d2:	bff9                	j	800016b0 <wait+0xa2>
    if(!havekids || killed(p)){
    800016d4:	cf19                	beqz	a4,800016f2 <wait+0xe4>
    800016d6:	854a                	mv	a0,s2
    800016d8:	f0dff0ef          	jal	800015e4 <killed>
    800016dc:	e919                	bnez	a0,800016f2 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016de:	85de                	mv	a1,s7
    800016e0:	854a                	mv	a0,s2
    800016e2:	ccbff0ef          	jal	800013ac <sleep>
    havekids = 0;
    800016e6:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016e8:	00009497          	auipc	s1,0x9
    800016ec:	25848493          	addi	s1,s1,600 # 8000a940 <proc>
    800016f0:	b7e1                	j	800016b8 <wait+0xaa>
      release(&wait_lock);
    800016f2:	00009517          	auipc	a0,0x9
    800016f6:	e3650513          	addi	a0,a0,-458 # 8000a528 <wait_lock>
    800016fa:	1de040ef          	jal	800058d8 <release>
      return -1;
    800016fe:	59fd                	li	s3,-1
    80001700:	b749                	j	80001682 <wait+0x74>

0000000080001702 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001702:	7179                	addi	sp,sp,-48
    80001704:	f406                	sd	ra,40(sp)
    80001706:	f022                	sd	s0,32(sp)
    80001708:	ec26                	sd	s1,24(sp)
    8000170a:	e84a                	sd	s2,16(sp)
    8000170c:	e44e                	sd	s3,8(sp)
    8000170e:	e052                	sd	s4,0(sp)
    80001710:	1800                	addi	s0,sp,48
    80001712:	84aa                	mv	s1,a0
    80001714:	892e                	mv	s2,a1
    80001716:	89b2                	mv	s3,a2
    80001718:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000171a:	eb8ff0ef          	jal	80000dd2 <myproc>
  if(user_dst){
    8000171e:	cc99                	beqz	s1,8000173c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001720:	86d2                	mv	a3,s4
    80001722:	864e                	mv	a2,s3
    80001724:	85ca                	mv	a1,s2
    80001726:	6928                	ld	a0,80(a0)
    80001728:	b1eff0ef          	jal	80000a46 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000172c:	70a2                	ld	ra,40(sp)
    8000172e:	7402                	ld	s0,32(sp)
    80001730:	64e2                	ld	s1,24(sp)
    80001732:	6942                	ld	s2,16(sp)
    80001734:	69a2                	ld	s3,8(sp)
    80001736:	6a02                	ld	s4,0(sp)
    80001738:	6145                	addi	sp,sp,48
    8000173a:	8082                	ret
    memmove((char *)dst, src, len);
    8000173c:	000a061b          	sext.w	a2,s4
    80001740:	85ce                	mv	a1,s3
    80001742:	854a                	mv	a0,s2
    80001744:	ab1fe0ef          	jal	800001f4 <memmove>
    return 0;
    80001748:	8526                	mv	a0,s1
    8000174a:	b7cd                	j	8000172c <either_copyout+0x2a>

000000008000174c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000174c:	7179                	addi	sp,sp,-48
    8000174e:	f406                	sd	ra,40(sp)
    80001750:	f022                	sd	s0,32(sp)
    80001752:	ec26                	sd	s1,24(sp)
    80001754:	e84a                	sd	s2,16(sp)
    80001756:	e44e                	sd	s3,8(sp)
    80001758:	e052                	sd	s4,0(sp)
    8000175a:	1800                	addi	s0,sp,48
    8000175c:	892a                	mv	s2,a0
    8000175e:	84ae                	mv	s1,a1
    80001760:	89b2                	mv	s3,a2
    80001762:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001764:	e6eff0ef          	jal	80000dd2 <myproc>
  if(user_src){
    80001768:	cc99                	beqz	s1,80001786 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000176a:	86d2                	mv	a3,s4
    8000176c:	864e                	mv	a2,s3
    8000176e:	85ca                	mv	a1,s2
    80001770:	6928                	ld	a0,80(a0)
    80001772:	b84ff0ef          	jal	80000af6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001776:	70a2                	ld	ra,40(sp)
    80001778:	7402                	ld	s0,32(sp)
    8000177a:	64e2                	ld	s1,24(sp)
    8000177c:	6942                	ld	s2,16(sp)
    8000177e:	69a2                	ld	s3,8(sp)
    80001780:	6a02                	ld	s4,0(sp)
    80001782:	6145                	addi	sp,sp,48
    80001784:	8082                	ret
    memmove(dst, (char*)src, len);
    80001786:	000a061b          	sext.w	a2,s4
    8000178a:	85ce                	mv	a1,s3
    8000178c:	854a                	mv	a0,s2
    8000178e:	a67fe0ef          	jal	800001f4 <memmove>
    return 0;
    80001792:	8526                	mv	a0,s1
    80001794:	b7cd                	j	80001776 <either_copyin+0x2a>

0000000080001796 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001796:	715d                	addi	sp,sp,-80
    80001798:	e486                	sd	ra,72(sp)
    8000179a:	e0a2                	sd	s0,64(sp)
    8000179c:	fc26                	sd	s1,56(sp)
    8000179e:	f84a                	sd	s2,48(sp)
    800017a0:	f44e                	sd	s3,40(sp)
    800017a2:	f052                	sd	s4,32(sp)
    800017a4:	ec56                	sd	s5,24(sp)
    800017a6:	e85a                	sd	s6,16(sp)
    800017a8:	e45e                	sd	s7,8(sp)
    800017aa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017ac:	00006517          	auipc	a0,0x6
    800017b0:	86c50513          	addi	a0,a0,-1940 # 80007018 <etext+0x18>
    800017b4:	293030ef          	jal	80005246 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017b8:	00009497          	auipc	s1,0x9
    800017bc:	2e048493          	addi	s1,s1,736 # 8000aa98 <proc+0x158>
    800017c0:	0000f917          	auipc	s2,0xf
    800017c4:	ed890913          	addi	s2,s2,-296 # 80010698 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017c8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017ca:	00006997          	auipc	s3,0x6
    800017ce:	a7698993          	addi	s3,s3,-1418 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800017d2:	00006a97          	auipc	s5,0x6
    800017d6:	a76a8a93          	addi	s5,s5,-1418 # 80007248 <etext+0x248>
    printf("\n");
    800017da:	00006a17          	auipc	s4,0x6
    800017de:	83ea0a13          	addi	s4,s4,-1986 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017e2:	00006b97          	auipc	s7,0x6
    800017e6:	04eb8b93          	addi	s7,s7,78 # 80007830 <states.0>
    800017ea:	a829                	j	80001804 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017ec:	ed86a583          	lw	a1,-296(a3)
    800017f0:	8556                	mv	a0,s5
    800017f2:	255030ef          	jal	80005246 <printf>
    printf("\n");
    800017f6:	8552                	mv	a0,s4
    800017f8:	24f030ef          	jal	80005246 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017fc:	17048493          	addi	s1,s1,368
    80001800:	03248263          	beq	s1,s2,80001824 <procdump+0x8e>
    if(p->state == UNUSED)
    80001804:	86a6                	mv	a3,s1
    80001806:	ec04a783          	lw	a5,-320(s1)
    8000180a:	dbed                	beqz	a5,800017fc <procdump+0x66>
      state = "???";
    8000180c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000180e:	fcfb6fe3          	bltu	s6,a5,800017ec <procdump+0x56>
    80001812:	02079713          	slli	a4,a5,0x20
    80001816:	01d75793          	srli	a5,a4,0x1d
    8000181a:	97de                	add	a5,a5,s7
    8000181c:	6390                	ld	a2,0(a5)
    8000181e:	f679                	bnez	a2,800017ec <procdump+0x56>
      state = "???";
    80001820:	864e                	mv	a2,s3
    80001822:	b7e9                	j	800017ec <procdump+0x56>
  }
}
    80001824:	60a6                	ld	ra,72(sp)
    80001826:	6406                	ld	s0,64(sp)
    80001828:	74e2                	ld	s1,56(sp)
    8000182a:	7942                	ld	s2,48(sp)
    8000182c:	79a2                	ld	s3,40(sp)
    8000182e:	7a02                	ld	s4,32(sp)
    80001830:	6ae2                	ld	s5,24(sp)
    80001832:	6b42                	ld	s6,16(sp)
    80001834:	6ba2                	ld	s7,8(sp)
    80001836:	6161                	addi	sp,sp,80
    80001838:	8082                	ret

000000008000183a <swtch>:
    8000183a:	00153023          	sd	ra,0(a0)
    8000183e:	00253423          	sd	sp,8(a0)
    80001842:	e900                	sd	s0,16(a0)
    80001844:	ed04                	sd	s1,24(a0)
    80001846:	03253023          	sd	s2,32(a0)
    8000184a:	03353423          	sd	s3,40(a0)
    8000184e:	03453823          	sd	s4,48(a0)
    80001852:	03553c23          	sd	s5,56(a0)
    80001856:	05653023          	sd	s6,64(a0)
    8000185a:	05753423          	sd	s7,72(a0)
    8000185e:	05853823          	sd	s8,80(a0)
    80001862:	05953c23          	sd	s9,88(a0)
    80001866:	07a53023          	sd	s10,96(a0)
    8000186a:	07b53423          	sd	s11,104(a0)
    8000186e:	0005b083          	ld	ra,0(a1)
    80001872:	0085b103          	ld	sp,8(a1)
    80001876:	6980                	ld	s0,16(a1)
    80001878:	6d84                	ld	s1,24(a1)
    8000187a:	0205b903          	ld	s2,32(a1)
    8000187e:	0285b983          	ld	s3,40(a1)
    80001882:	0305ba03          	ld	s4,48(a1)
    80001886:	0385ba83          	ld	s5,56(a1)
    8000188a:	0405bb03          	ld	s6,64(a1)
    8000188e:	0485bb83          	ld	s7,72(a1)
    80001892:	0505bc03          	ld	s8,80(a1)
    80001896:	0585bc83          	ld	s9,88(a1)
    8000189a:	0605bd03          	ld	s10,96(a1)
    8000189e:	0685bd83          	ld	s11,104(a1)
    800018a2:	8082                	ret

00000000800018a4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018a4:	1141                	addi	sp,sp,-16
    800018a6:	e406                	sd	ra,8(sp)
    800018a8:	e022                	sd	s0,0(sp)
    800018aa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018ac:	00006597          	auipc	a1,0x6
    800018b0:	9dc58593          	addi	a1,a1,-1572 # 80007288 <etext+0x288>
    800018b4:	0000f517          	auipc	a0,0xf
    800018b8:	c8c50513          	addi	a0,a0,-884 # 80010540 <tickslock>
    800018bc:	705030ef          	jal	800057c0 <initlock>
}
    800018c0:	60a2                	ld	ra,8(sp)
    800018c2:	6402                	ld	s0,0(sp)
    800018c4:	0141                	addi	sp,sp,16
    800018c6:	8082                	ret

00000000800018c8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018c8:	1141                	addi	sp,sp,-16
    800018ca:	e406                	sd	ra,8(sp)
    800018cc:	e022                	sd	s0,0(sp)
    800018ce:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018d0:	00003797          	auipc	a5,0x3
    800018d4:	ee078793          	addi	a5,a5,-288 # 800047b0 <kernelvec>
    800018d8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018dc:	60a2                	ld	ra,8(sp)
    800018de:	6402                	ld	s0,0(sp)
    800018e0:	0141                	addi	sp,sp,16
    800018e2:	8082                	ret

00000000800018e4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018e4:	1141                	addi	sp,sp,-16
    800018e6:	e406                	sd	ra,8(sp)
    800018e8:	e022                	sd	s0,0(sp)
    800018ea:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018ec:	ce6ff0ef          	jal	80000dd2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018f4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018f6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018fa:	00004697          	auipc	a3,0x4
    800018fe:	70668693          	addi	a3,a3,1798 # 80006000 <_trampoline>
    80001902:	00004717          	auipc	a4,0x4
    80001906:	6fe70713          	addi	a4,a4,1790 # 80006000 <_trampoline>
    8000190a:	8f15                	sub	a4,a4,a3
    8000190c:	040007b7          	lui	a5,0x4000
    80001910:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001912:	07b2                	slli	a5,a5,0xc
    80001914:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001916:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000191a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000191c:	18002673          	csrr	a2,satp
    80001920:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001922:	6d30                	ld	a2,88(a0)
    80001924:	6138                	ld	a4,64(a0)
    80001926:	6585                	lui	a1,0x1
    80001928:	972e                	add	a4,a4,a1
    8000192a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000192c:	6d38                	ld	a4,88(a0)
    8000192e:	00000617          	auipc	a2,0x0
    80001932:	11060613          	addi	a2,a2,272 # 80001a3e <usertrap>
    80001936:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001938:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000193a:	8612                	mv	a2,tp
    8000193c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000193e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001942:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001946:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000194a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000194e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001950:	6f18                	ld	a4,24(a4)
    80001952:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001956:	6928                	ld	a0,80(a0)
    80001958:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000195a:	00004717          	auipc	a4,0x4
    8000195e:	74270713          	addi	a4,a4,1858 # 8000609c <userret>
    80001962:	8f15                	sub	a4,a4,a3
    80001964:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001966:	577d                	li	a4,-1
    80001968:	177e                	slli	a4,a4,0x3f
    8000196a:	8d59                	or	a0,a0,a4
    8000196c:	9782                	jalr	a5
}
    8000196e:	60a2                	ld	ra,8(sp)
    80001970:	6402                	ld	s0,0(sp)
    80001972:	0141                	addi	sp,sp,16
    80001974:	8082                	ret

0000000080001976 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001976:	1101                	addi	sp,sp,-32
    80001978:	ec06                	sd	ra,24(sp)
    8000197a:	e822                	sd	s0,16(sp)
    8000197c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000197e:	c20ff0ef          	jal	80000d9e <cpuid>
    80001982:	cd11                	beqz	a0,8000199e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001984:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001988:	000f4737          	lui	a4,0xf4
    8000198c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001990:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001992:	14d79073          	csrw	stimecmp,a5
}
    80001996:	60e2                	ld	ra,24(sp)
    80001998:	6442                	ld	s0,16(sp)
    8000199a:	6105                	addi	sp,sp,32
    8000199c:	8082                	ret
    8000199e:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019a0:	0000f497          	auipc	s1,0xf
    800019a4:	ba048493          	addi	s1,s1,-1120 # 80010540 <tickslock>
    800019a8:	8526                	mv	a0,s1
    800019aa:	69b030ef          	jal	80005844 <acquire>
    ticks++;
    800019ae:	00009517          	auipc	a0,0x9
    800019b2:	b2a50513          	addi	a0,a0,-1238 # 8000a4d8 <ticks>
    800019b6:	411c                	lw	a5,0(a0)
    800019b8:	2785                	addiw	a5,a5,1
    800019ba:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019bc:	a3dff0ef          	jal	800013f8 <wakeup>
    release(&tickslock);
    800019c0:	8526                	mv	a0,s1
    800019c2:	717030ef          	jal	800058d8 <release>
    800019c6:	64a2                	ld	s1,8(sp)
    800019c8:	bf75                	j	80001984 <clockintr+0xe>

00000000800019ca <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019ca:	1101                	addi	sp,sp,-32
    800019cc:	ec06                	sd	ra,24(sp)
    800019ce:	e822                	sd	s0,16(sp)
    800019d0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019d2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019d6:	57fd                	li	a5,-1
    800019d8:	17fe                	slli	a5,a5,0x3f
    800019da:	07a5                	addi	a5,a5,9
    800019dc:	00f70c63          	beq	a4,a5,800019f4 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019e0:	57fd                	li	a5,-1
    800019e2:	17fe                	slli	a5,a5,0x3f
    800019e4:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019e6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019e8:	04f70763          	beq	a4,a5,80001a36 <devintr+0x6c>
  }
}
    800019ec:	60e2                	ld	ra,24(sp)
    800019ee:	6442                	ld	s0,16(sp)
    800019f0:	6105                	addi	sp,sp,32
    800019f2:	8082                	ret
    800019f4:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019f6:	667020ef          	jal	8000485c <plic_claim>
    800019fa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019fc:	47a9                	li	a5,10
    800019fe:	00f50963          	beq	a0,a5,80001a10 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a02:	4785                	li	a5,1
    80001a04:	00f50963          	beq	a0,a5,80001a16 <devintr+0x4c>
    return 1;
    80001a08:	4505                	li	a0,1
    } else if(irq){
    80001a0a:	e889                	bnez	s1,80001a1c <devintr+0x52>
    80001a0c:	64a2                	ld	s1,8(sp)
    80001a0e:	bff9                	j	800019ec <devintr+0x22>
      uartintr();
    80001a10:	575030ef          	jal	80005784 <uartintr>
    if(irq)
    80001a14:	a819                	j	80001a2a <devintr+0x60>
      virtio_disk_intr();
    80001a16:	2d6030ef          	jal	80004cec <virtio_disk_intr>
    if(irq)
    80001a1a:	a801                	j	80001a2a <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a1c:	85a6                	mv	a1,s1
    80001a1e:	00006517          	auipc	a0,0x6
    80001a22:	87250513          	addi	a0,a0,-1934 # 80007290 <etext+0x290>
    80001a26:	021030ef          	jal	80005246 <printf>
      plic_complete(irq);
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	651020ef          	jal	8000487c <plic_complete>
    return 1;
    80001a30:	4505                	li	a0,1
    80001a32:	64a2                	ld	s1,8(sp)
    80001a34:	bf65                	j	800019ec <devintr+0x22>
    clockintr();
    80001a36:	f41ff0ef          	jal	80001976 <clockintr>
    return 2;
    80001a3a:	4509                	li	a0,2
    80001a3c:	bf45                	j	800019ec <devintr+0x22>

0000000080001a3e <usertrap>:
{
    80001a3e:	1101                	addi	sp,sp,-32
    80001a40:	ec06                	sd	ra,24(sp)
    80001a42:	e822                	sd	s0,16(sp)
    80001a44:	e426                	sd	s1,8(sp)
    80001a46:	e04a                	sd	s2,0(sp)
    80001a48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a4a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a4e:	1007f793          	andi	a5,a5,256
    80001a52:	ef85                	bnez	a5,80001a8a <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a54:	00003797          	auipc	a5,0x3
    80001a58:	d5c78793          	addi	a5,a5,-676 # 800047b0 <kernelvec>
    80001a5c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a60:	b72ff0ef          	jal	80000dd2 <myproc>
    80001a64:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a66:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a68:	14102773          	csrr	a4,sepc
    80001a6c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a6e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a72:	47a1                	li	a5,8
    80001a74:	02f70163          	beq	a4,a5,80001a96 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a78:	f53ff0ef          	jal	800019ca <devintr>
    80001a7c:	892a                	mv	s2,a0
    80001a7e:	c135                	beqz	a0,80001ae2 <usertrap+0xa4>
  if(killed(p))
    80001a80:	8526                	mv	a0,s1
    80001a82:	b63ff0ef          	jal	800015e4 <killed>
    80001a86:	cd1d                	beqz	a0,80001ac4 <usertrap+0x86>
    80001a88:	a81d                	j	80001abe <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a8a:	00006517          	auipc	a0,0x6
    80001a8e:	82650513          	addi	a0,a0,-2010 # 800072b0 <etext+0x2b0>
    80001a92:	285030ef          	jal	80005516 <panic>
    if(killed(p))
    80001a96:	b4fff0ef          	jal	800015e4 <killed>
    80001a9a:	e121                	bnez	a0,80001ada <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a9c:	6cb8                	ld	a4,88(s1)
    80001a9e:	6f1c                	ld	a5,24(a4)
    80001aa0:	0791                	addi	a5,a5,4
    80001aa2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aa8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aac:	10079073          	csrw	sstatus,a5
    syscall();
    80001ab0:	240000ef          	jal	80001cf0 <syscall>
  if(killed(p))
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	b2fff0ef          	jal	800015e4 <killed>
    80001aba:	c901                	beqz	a0,80001aca <usertrap+0x8c>
    80001abc:	4901                	li	s2,0
    exit(-1);
    80001abe:	557d                	li	a0,-1
    80001ac0:	9f9ff0ef          	jal	800014b8 <exit>
  if(which_dev == 2)
    80001ac4:	4789                	li	a5,2
    80001ac6:	04f90563          	beq	s2,a5,80001b10 <usertrap+0xd2>
  usertrapret();
    80001aca:	e1bff0ef          	jal	800018e4 <usertrapret>
}
    80001ace:	60e2                	ld	ra,24(sp)
    80001ad0:	6442                	ld	s0,16(sp)
    80001ad2:	64a2                	ld	s1,8(sp)
    80001ad4:	6902                	ld	s2,0(sp)
    80001ad6:	6105                	addi	sp,sp,32
    80001ad8:	8082                	ret
      exit(-1);
    80001ada:	557d                	li	a0,-1
    80001adc:	9ddff0ef          	jal	800014b8 <exit>
    80001ae0:	bf75                	j	80001a9c <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ae2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001ae6:	5890                	lw	a2,48(s1)
    80001ae8:	00005517          	auipc	a0,0x5
    80001aec:	7e850513          	addi	a0,a0,2024 # 800072d0 <etext+0x2d0>
    80001af0:	756030ef          	jal	80005246 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001af4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af8:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001afc:	00006517          	auipc	a0,0x6
    80001b00:	80450513          	addi	a0,a0,-2044 # 80007300 <etext+0x300>
    80001b04:	742030ef          	jal	80005246 <printf>
    setkilled(p);
    80001b08:	8526                	mv	a0,s1
    80001b0a:	ab7ff0ef          	jal	800015c0 <setkilled>
    80001b0e:	b75d                	j	80001ab4 <usertrap+0x76>
    yield();
    80001b10:	871ff0ef          	jal	80001380 <yield>
    80001b14:	bf5d                	j	80001aca <usertrap+0x8c>

0000000080001b16 <kerneltrap>:
{
    80001b16:	7179                	addi	sp,sp,-48
    80001b18:	f406                	sd	ra,40(sp)
    80001b1a:	f022                	sd	s0,32(sp)
    80001b1c:	ec26                	sd	s1,24(sp)
    80001b1e:	e84a                	sd	s2,16(sp)
    80001b20:	e44e                	sd	s3,8(sp)
    80001b22:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b24:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b28:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b2c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b30:	1004f793          	andi	a5,s1,256
    80001b34:	c795                	beqz	a5,80001b60 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b3a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b3c:	eb85                	bnez	a5,80001b6c <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b3e:	e8dff0ef          	jal	800019ca <devintr>
    80001b42:	c91d                	beqz	a0,80001b78 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b44:	4789                	li	a5,2
    80001b46:	04f50a63          	beq	a0,a5,80001b9a <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b4a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b4e:	10049073          	csrw	sstatus,s1
}
    80001b52:	70a2                	ld	ra,40(sp)
    80001b54:	7402                	ld	s0,32(sp)
    80001b56:	64e2                	ld	s1,24(sp)
    80001b58:	6942                	ld	s2,16(sp)
    80001b5a:	69a2                	ld	s3,8(sp)
    80001b5c:	6145                	addi	sp,sp,48
    80001b5e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b60:	00005517          	auipc	a0,0x5
    80001b64:	7c850513          	addi	a0,a0,1992 # 80007328 <etext+0x328>
    80001b68:	1af030ef          	jal	80005516 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b6c:	00005517          	auipc	a0,0x5
    80001b70:	7e450513          	addi	a0,a0,2020 # 80007350 <etext+0x350>
    80001b74:	1a3030ef          	jal	80005516 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b78:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b7c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b80:	85ce                	mv	a1,s3
    80001b82:	00005517          	auipc	a0,0x5
    80001b86:	7ee50513          	addi	a0,a0,2030 # 80007370 <etext+0x370>
    80001b8a:	6bc030ef          	jal	80005246 <printf>
    panic("kerneltrap");
    80001b8e:	00006517          	auipc	a0,0x6
    80001b92:	80a50513          	addi	a0,a0,-2038 # 80007398 <etext+0x398>
    80001b96:	181030ef          	jal	80005516 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b9a:	a38ff0ef          	jal	80000dd2 <myproc>
    80001b9e:	d555                	beqz	a0,80001b4a <kerneltrap+0x34>
    yield();
    80001ba0:	fe0ff0ef          	jal	80001380 <yield>
    80001ba4:	b75d                	j	80001b4a <kerneltrap+0x34>

0000000080001ba6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ba6:	1101                	addi	sp,sp,-32
    80001ba8:	ec06                	sd	ra,24(sp)
    80001baa:	e822                	sd	s0,16(sp)
    80001bac:	e426                	sd	s1,8(sp)
    80001bae:	1000                	addi	s0,sp,32
    80001bb0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bb2:	a20ff0ef          	jal	80000dd2 <myproc>
  switch (n) {
    80001bb6:	4795                	li	a5,5
    80001bb8:	0497e163          	bltu	a5,s1,80001bfa <argraw+0x54>
    80001bbc:	048a                	slli	s1,s1,0x2
    80001bbe:	00006717          	auipc	a4,0x6
    80001bc2:	ca270713          	addi	a4,a4,-862 # 80007860 <states.0+0x30>
    80001bc6:	94ba                	add	s1,s1,a4
    80001bc8:	409c                	lw	a5,0(s1)
    80001bca:	97ba                	add	a5,a5,a4
    80001bcc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bce:	6d3c                	ld	a5,88(a0)
    80001bd0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bd2:	60e2                	ld	ra,24(sp)
    80001bd4:	6442                	ld	s0,16(sp)
    80001bd6:	64a2                	ld	s1,8(sp)
    80001bd8:	6105                	addi	sp,sp,32
    80001bda:	8082                	ret
    return p->trapframe->a1;
    80001bdc:	6d3c                	ld	a5,88(a0)
    80001bde:	7fa8                	ld	a0,120(a5)
    80001be0:	bfcd                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a2;
    80001be2:	6d3c                	ld	a5,88(a0)
    80001be4:	63c8                	ld	a0,128(a5)
    80001be6:	b7f5                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a3;
    80001be8:	6d3c                	ld	a5,88(a0)
    80001bea:	67c8                	ld	a0,136(a5)
    80001bec:	b7dd                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a4;
    80001bee:	6d3c                	ld	a5,88(a0)
    80001bf0:	6bc8                	ld	a0,144(a5)
    80001bf2:	b7c5                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a5;
    80001bf4:	6d3c                	ld	a5,88(a0)
    80001bf6:	6fc8                	ld	a0,152(a5)
    80001bf8:	bfe9                	j	80001bd2 <argraw+0x2c>
  panic("argraw");
    80001bfa:	00005517          	auipc	a0,0x5
    80001bfe:	7ae50513          	addi	a0,a0,1966 # 800073a8 <etext+0x3a8>
    80001c02:	115030ef          	jal	80005516 <panic>

0000000080001c06 <fetchaddr>:
{
    80001c06:	1101                	addi	sp,sp,-32
    80001c08:	ec06                	sd	ra,24(sp)
    80001c0a:	e822                	sd	s0,16(sp)
    80001c0c:	e426                	sd	s1,8(sp)
    80001c0e:	e04a                	sd	s2,0(sp)
    80001c10:	1000                	addi	s0,sp,32
    80001c12:	84aa                	mv	s1,a0
    80001c14:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c16:	9bcff0ef          	jal	80000dd2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c1a:	653c                	ld	a5,72(a0)
    80001c1c:	02f4f663          	bgeu	s1,a5,80001c48 <fetchaddr+0x42>
    80001c20:	00848713          	addi	a4,s1,8
    80001c24:	02e7e463          	bltu	a5,a4,80001c4c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c28:	46a1                	li	a3,8
    80001c2a:	8626                	mv	a2,s1
    80001c2c:	85ca                	mv	a1,s2
    80001c2e:	6928                	ld	a0,80(a0)
    80001c30:	ec7fe0ef          	jal	80000af6 <copyin>
    80001c34:	00a03533          	snez	a0,a0
    80001c38:	40a0053b          	negw	a0,a0
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6902                	ld	s2,0(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret
    return -1;
    80001c48:	557d                	li	a0,-1
    80001c4a:	bfcd                	j	80001c3c <fetchaddr+0x36>
    80001c4c:	557d                	li	a0,-1
    80001c4e:	b7fd                	j	80001c3c <fetchaddr+0x36>

0000000080001c50 <fetchstr>:
{
    80001c50:	7179                	addi	sp,sp,-48
    80001c52:	f406                	sd	ra,40(sp)
    80001c54:	f022                	sd	s0,32(sp)
    80001c56:	ec26                	sd	s1,24(sp)
    80001c58:	e84a                	sd	s2,16(sp)
    80001c5a:	e44e                	sd	s3,8(sp)
    80001c5c:	1800                	addi	s0,sp,48
    80001c5e:	892a                	mv	s2,a0
    80001c60:	84ae                	mv	s1,a1
    80001c62:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c64:	96eff0ef          	jal	80000dd2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c68:	86ce                	mv	a3,s3
    80001c6a:	864a                	mv	a2,s2
    80001c6c:	85a6                	mv	a1,s1
    80001c6e:	6928                	ld	a0,80(a0)
    80001c70:	f0dfe0ef          	jal	80000b7c <copyinstr>
    80001c74:	00054c63          	bltz	a0,80001c8c <fetchstr+0x3c>
  return strlen(buf);
    80001c78:	8526                	mv	a0,s1
    80001c7a:	e9efe0ef          	jal	80000318 <strlen>
}
    80001c7e:	70a2                	ld	ra,40(sp)
    80001c80:	7402                	ld	s0,32(sp)
    80001c82:	64e2                	ld	s1,24(sp)
    80001c84:	6942                	ld	s2,16(sp)
    80001c86:	69a2                	ld	s3,8(sp)
    80001c88:	6145                	addi	sp,sp,48
    80001c8a:	8082                	ret
    return -1;
    80001c8c:	557d                	li	a0,-1
    80001c8e:	bfc5                	j	80001c7e <fetchstr+0x2e>

0000000080001c90 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c90:	1101                	addi	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	1000                	addi	s0,sp,32
    80001c9a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c9c:	f0bff0ef          	jal	80001ba6 <argraw>
    80001ca0:	c088                	sw	a0,0(s1)
}
    80001ca2:	60e2                	ld	ra,24(sp)
    80001ca4:	6442                	ld	s0,16(sp)
    80001ca6:	64a2                	ld	s1,8(sp)
    80001ca8:	6105                	addi	sp,sp,32
    80001caa:	8082                	ret

0000000080001cac <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cac:	1101                	addi	sp,sp,-32
    80001cae:	ec06                	sd	ra,24(sp)
    80001cb0:	e822                	sd	s0,16(sp)
    80001cb2:	e426                	sd	s1,8(sp)
    80001cb4:	1000                	addi	s0,sp,32
    80001cb6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb8:	eefff0ef          	jal	80001ba6 <argraw>
    80001cbc:	e088                	sd	a0,0(s1)
}
    80001cbe:	60e2                	ld	ra,24(sp)
    80001cc0:	6442                	ld	s0,16(sp)
    80001cc2:	64a2                	ld	s1,8(sp)
    80001cc4:	6105                	addi	sp,sp,32
    80001cc6:	8082                	ret

0000000080001cc8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cc8:	1101                	addi	sp,sp,-32
    80001cca:	ec06                	sd	ra,24(sp)
    80001ccc:	e822                	sd	s0,16(sp)
    80001cce:	e426                	sd	s1,8(sp)
    80001cd0:	e04a                	sd	s2,0(sp)
    80001cd2:	1000                	addi	s0,sp,32
    80001cd4:	84ae                	mv	s1,a1
    80001cd6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001cd8:	ecfff0ef          	jal	80001ba6 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001cdc:	864a                	mv	a2,s2
    80001cde:	85a6                	mv	a1,s1
    80001ce0:	f71ff0ef          	jal	80001c50 <fetchstr>
}
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	64a2                	ld	s1,8(sp)
    80001cea:	6902                	ld	s2,0(sp)
    80001cec:	6105                	addi	sp,sp,32
    80001cee:	8082                	ret

0000000080001cf0 <syscall>:
};


void
syscall(void)
{
    80001cf0:	7179                	addi	sp,sp,-48
    80001cf2:	f406                	sd	ra,40(sp)
    80001cf4:	f022                	sd	s0,32(sp)
    80001cf6:	ec26                	sd	s1,24(sp)
    80001cf8:	e84a                	sd	s2,16(sp)
    80001cfa:	e44e                	sd	s3,8(sp)
    80001cfc:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001cfe:	8d4ff0ef          	jal	80000dd2 <myproc>
    80001d02:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d04:	05853903          	ld	s2,88(a0)
    80001d08:	0a893783          	ld	a5,168(s2)
    80001d0c:	0007899b          	sext.w	s3,a5
  // printf("%d: syscall %s -> %ld\n", p->pid, syscallNames[num], p->trapframe->a0);
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d10:	37fd                	addiw	a5,a5,-1
    80001d12:	4759                	li	a4,22
    80001d14:	04f76563          	bltu	a4,a5,80001d5e <syscall+0x6e>
    80001d18:	00399713          	slli	a4,s3,0x3
    80001d1c:	00006797          	auipc	a5,0x6
    80001d20:	b5c78793          	addi	a5,a5,-1188 # 80007878 <syscalls>
    80001d24:	97ba                	add	a5,a5,a4
    80001d26:	639c                	ld	a5,0(a5)
    80001d28:	cb9d                	beqz	a5,80001d5e <syscall+0x6e>
    // printf("After");
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d2a:	9782                	jalr	a5
    80001d2c:	06a93823          	sd	a0,112(s2)

    // Log the syscall if its number is in the process's syscall mask.
    if ((1 << num) & p->syscallMask)
    80001d30:	1684a783          	lw	a5,360(s1)
    80001d34:	4137d7bb          	sraw	a5,a5,s3
    80001d38:	8b85                	andi	a5,a5,1
    80001d3a:	cf9d                	beqz	a5,80001d78 <syscall+0x88>
      printf("%d: syscall %s -> %ld\n", p->pid, syscallNames[num], p->trapframe->a0);
    80001d3c:	6cb8                	ld	a4,88(s1)
    80001d3e:	098e                	slli	s3,s3,0x3
    80001d40:	00006797          	auipc	a5,0x6
    80001d44:	b3878793          	addi	a5,a5,-1224 # 80007878 <syscalls>
    80001d48:	97ce                	add	a5,a5,s3
    80001d4a:	7b34                	ld	a3,112(a4)
    80001d4c:	63f0                	ld	a2,192(a5)
    80001d4e:	588c                	lw	a1,48(s1)
    80001d50:	00005517          	auipc	a0,0x5
    80001d54:	66050513          	addi	a0,a0,1632 # 800073b0 <etext+0x3b0>
    80001d58:	4ee030ef          	jal	80005246 <printf>
    80001d5c:	a831                	j	80001d78 <syscall+0x88>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d5e:	86ce                	mv	a3,s3
    80001d60:	15848613          	addi	a2,s1,344
    80001d64:	588c                	lw	a1,48(s1)
    80001d66:	00005517          	auipc	a0,0x5
    80001d6a:	66250513          	addi	a0,a0,1634 # 800073c8 <etext+0x3c8>
    80001d6e:	4d8030ef          	jal	80005246 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d72:	6cbc                	ld	a5,88(s1)
    80001d74:	577d                	li	a4,-1
    80001d76:	fbb8                	sd	a4,112(a5)
  }
}
    80001d78:	70a2                	ld	ra,40(sp)
    80001d7a:	7402                	ld	s0,32(sp)
    80001d7c:	64e2                	ld	s1,24(sp)
    80001d7e:	6942                	ld	s2,16(sp)
    80001d80:	69a2                	ld	s3,8(sp)
    80001d82:	6145                	addi	sp,sp,48
    80001d84:	8082                	ret

0000000080001d86 <sys_exit>:
uint64 getFreeMem(void);
int getNProc();

uint64
sys_exit(void)
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d8e:	fec40593          	addi	a1,s0,-20
    80001d92:	4501                	li	a0,0
    80001d94:	efdff0ef          	jal	80001c90 <argint>
  exit(n);
    80001d98:	fec42503          	lw	a0,-20(s0)
    80001d9c:	f1cff0ef          	jal	800014b8 <exit>
  return 0;  // not reached
}
    80001da0:	4501                	li	a0,0
    80001da2:	60e2                	ld	ra,24(sp)
    80001da4:	6442                	ld	s0,16(sp)
    80001da6:	6105                	addi	sp,sp,32
    80001da8:	8082                	ret

0000000080001daa <sys_getpid>:

uint64
sys_getpid(void)
{
    80001daa:	1141                	addi	sp,sp,-16
    80001dac:	e406                	sd	ra,8(sp)
    80001dae:	e022                	sd	s0,0(sp)
    80001db0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001db2:	820ff0ef          	jal	80000dd2 <myproc>
}
    80001db6:	5908                	lw	a0,48(a0)
    80001db8:	60a2                	ld	ra,8(sp)
    80001dba:	6402                	ld	s0,0(sp)
    80001dbc:	0141                	addi	sp,sp,16
    80001dbe:	8082                	ret

0000000080001dc0 <sys_fork>:

uint64
sys_fork(void)
{
    80001dc0:	1141                	addi	sp,sp,-16
    80001dc2:	e406                	sd	ra,8(sp)
    80001dc4:	e022                	sd	s0,0(sp)
    80001dc6:	0800                	addi	s0,sp,16
  return fork();
    80001dc8:	b34ff0ef          	jal	800010fc <fork>
}
    80001dcc:	60a2                	ld	ra,8(sp)
    80001dce:	6402                	ld	s0,0(sp)
    80001dd0:	0141                	addi	sp,sp,16
    80001dd2:	8082                	ret

0000000080001dd4 <sys_wait>:

uint64
sys_wait(void)
{
    80001dd4:	1101                	addi	sp,sp,-32
    80001dd6:	ec06                	sd	ra,24(sp)
    80001dd8:	e822                	sd	s0,16(sp)
    80001dda:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001ddc:	fe840593          	addi	a1,s0,-24
    80001de0:	4501                	li	a0,0
    80001de2:	ecbff0ef          	jal	80001cac <argaddr>
  return wait(p);
    80001de6:	fe843503          	ld	a0,-24(s0)
    80001dea:	825ff0ef          	jal	8000160e <wait>
}
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	6105                	addi	sp,sp,32
    80001df4:	8082                	ret

0000000080001df6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001df6:	7179                	addi	sp,sp,-48
    80001df8:	f406                	sd	ra,40(sp)
    80001dfa:	f022                	sd	s0,32(sp)
    80001dfc:	ec26                	sd	s1,24(sp)
    80001dfe:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e00:	fdc40593          	addi	a1,s0,-36
    80001e04:	4501                	li	a0,0
    80001e06:	e8bff0ef          	jal	80001c90 <argint>
  addr = myproc()->sz;
    80001e0a:	fc9fe0ef          	jal	80000dd2 <myproc>
    80001e0e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e10:	fdc42503          	lw	a0,-36(s0)
    80001e14:	a98ff0ef          	jal	800010ac <growproc>
    80001e18:	00054863          	bltz	a0,80001e28 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e1c:	8526                	mv	a0,s1
    80001e1e:	70a2                	ld	ra,40(sp)
    80001e20:	7402                	ld	s0,32(sp)
    80001e22:	64e2                	ld	s1,24(sp)
    80001e24:	6145                	addi	sp,sp,48
    80001e26:	8082                	ret
    return -1;
    80001e28:	54fd                	li	s1,-1
    80001e2a:	bfcd                	j	80001e1c <sys_sbrk+0x26>

0000000080001e2c <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e2c:	7139                	addi	sp,sp,-64
    80001e2e:	fc06                	sd	ra,56(sp)
    80001e30:	f822                	sd	s0,48(sp)
    80001e32:	f04a                	sd	s2,32(sp)
    80001e34:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e36:	fcc40593          	addi	a1,s0,-52
    80001e3a:	4501                	li	a0,0
    80001e3c:	e55ff0ef          	jal	80001c90 <argint>
  if(n < 0)
    80001e40:	fcc42783          	lw	a5,-52(s0)
    80001e44:	0607c763          	bltz	a5,80001eb2 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e48:	0000e517          	auipc	a0,0xe
    80001e4c:	6f850513          	addi	a0,a0,1784 # 80010540 <tickslock>
    80001e50:	1f5030ef          	jal	80005844 <acquire>
  ticks0 = ticks;
    80001e54:	00008917          	auipc	s2,0x8
    80001e58:	68492903          	lw	s2,1668(s2) # 8000a4d8 <ticks>
  while(ticks - ticks0 < n){
    80001e5c:	fcc42783          	lw	a5,-52(s0)
    80001e60:	cf8d                	beqz	a5,80001e9a <sys_sleep+0x6e>
    80001e62:	f426                	sd	s1,40(sp)
    80001e64:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e66:	0000e997          	auipc	s3,0xe
    80001e6a:	6da98993          	addi	s3,s3,1754 # 80010540 <tickslock>
    80001e6e:	00008497          	auipc	s1,0x8
    80001e72:	66a48493          	addi	s1,s1,1642 # 8000a4d8 <ticks>
    if(killed(myproc())){
    80001e76:	f5dfe0ef          	jal	80000dd2 <myproc>
    80001e7a:	f6aff0ef          	jal	800015e4 <killed>
    80001e7e:	ed0d                	bnez	a0,80001eb8 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e80:	85ce                	mv	a1,s3
    80001e82:	8526                	mv	a0,s1
    80001e84:	d28ff0ef          	jal	800013ac <sleep>
  while(ticks - ticks0 < n){
    80001e88:	409c                	lw	a5,0(s1)
    80001e8a:	412787bb          	subw	a5,a5,s2
    80001e8e:	fcc42703          	lw	a4,-52(s0)
    80001e92:	fee7e2e3          	bltu	a5,a4,80001e76 <sys_sleep+0x4a>
    80001e96:	74a2                	ld	s1,40(sp)
    80001e98:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e9a:	0000e517          	auipc	a0,0xe
    80001e9e:	6a650513          	addi	a0,a0,1702 # 80010540 <tickslock>
    80001ea2:	237030ef          	jal	800058d8 <release>
  return 0;
    80001ea6:	4501                	li	a0,0
}
    80001ea8:	70e2                	ld	ra,56(sp)
    80001eaa:	7442                	ld	s0,48(sp)
    80001eac:	7902                	ld	s2,32(sp)
    80001eae:	6121                	addi	sp,sp,64
    80001eb0:	8082                	ret
    n = 0;
    80001eb2:	fc042623          	sw	zero,-52(s0)
    80001eb6:	bf49                	j	80001e48 <sys_sleep+0x1c>
      release(&tickslock);
    80001eb8:	0000e517          	auipc	a0,0xe
    80001ebc:	68850513          	addi	a0,a0,1672 # 80010540 <tickslock>
    80001ec0:	219030ef          	jal	800058d8 <release>
      return -1;
    80001ec4:	557d                	li	a0,-1
    80001ec6:	74a2                	ld	s1,40(sp)
    80001ec8:	69e2                	ld	s3,24(sp)
    80001eca:	bff9                	j	80001ea8 <sys_sleep+0x7c>

0000000080001ecc <sys_kill>:

uint64
sys_kill(void)
{
    80001ecc:	1101                	addi	sp,sp,-32
    80001ece:	ec06                	sd	ra,24(sp)
    80001ed0:	e822                	sd	s0,16(sp)
    80001ed2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ed4:	fec40593          	addi	a1,s0,-20
    80001ed8:	4501                	li	a0,0
    80001eda:	db7ff0ef          	jal	80001c90 <argint>
  return kill(pid);
    80001ede:	fec42503          	lw	a0,-20(s0)
    80001ee2:	e78ff0ef          	jal	8000155a <kill>
}
    80001ee6:	60e2                	ld	ra,24(sp)
    80001ee8:	6442                	ld	s0,16(sp)
    80001eea:	6105                	addi	sp,sp,32
    80001eec:	8082                	ret

0000000080001eee <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001ef8:	0000e517          	auipc	a0,0xe
    80001efc:	64850513          	addi	a0,a0,1608 # 80010540 <tickslock>
    80001f00:	145030ef          	jal	80005844 <acquire>
  xticks = ticks;
    80001f04:	00008497          	auipc	s1,0x8
    80001f08:	5d44a483          	lw	s1,1492(s1) # 8000a4d8 <ticks>
  release(&tickslock);
    80001f0c:	0000e517          	auipc	a0,0xe
    80001f10:	63450513          	addi	a0,a0,1588 # 80010540 <tickslock>
    80001f14:	1c5030ef          	jal	800058d8 <release>
  return xticks;
}
    80001f18:	02049513          	slli	a0,s1,0x20
    80001f1c:	9101                	srli	a0,a0,0x20
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6105                	addi	sp,sp,32
    80001f26:	8082                	ret

0000000080001f28 <sys_trace>:

uint64
sys_trace(void)
{
    80001f28:	1101                	addi	sp,sp,-32
    80001f2a:	ec06                	sd	ra,24(sp)
    80001f2c:	e822                	sd	s0,16(sp)
    80001f2e:	1000                	addi	s0,sp,32
  int syscallMask;
  argint(0, &syscallMask);
    80001f30:	fec40593          	addi	a1,s0,-20
    80001f34:	4501                	li	a0,0
    80001f36:	d5bff0ef          	jal	80001c90 <argint>
  myproc()->syscallMask = syscallMask;
    80001f3a:	e99fe0ef          	jal	80000dd2 <myproc>
    80001f3e:	fec42783          	lw	a5,-20(s0)
    80001f42:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80001f46:	4501                	li	a0,0
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	6105                	addi	sp,sp,32
    80001f4e:	8082                	ret

0000000080001f50 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80001f50:	7139                	addi	sp,sp,-64
    80001f52:	fc06                	sd	ra,56(sp)
    80001f54:	f822                	sd	s0,48(sp)
    80001f56:	f426                	sd	s1,40(sp)
    80001f58:	0080                	addi	s0,sp,64
  struct proc* p = myproc();
    80001f5a:	e79fe0ef          	jal	80000dd2 <myproc>
    80001f5e:	84aa                	mv	s1,a0

  uint64 addr;
  argaddr(0, &addr);
    80001f60:	fd840593          	addi	a1,s0,-40
    80001f64:	4501                	li	a0,0
    80001f66:	d47ff0ef          	jal	80001cac <argaddr>

  struct sysinfo si;
  si.freemem = getFreeMem();
    80001f6a:	9e4fe0ef          	jal	8000014e <getFreeMem>
    80001f6e:	fca43423          	sd	a0,-56(s0)
  si.nproc = getNProc();
    80001f72:	cabfe0ef          	jal	80000c1c <getNProc>
    80001f76:	fca43823          	sd	a0,-48(s0)

  if (copyout(p->pagetable, addr, (char*)&si, sizeof(si)) < 0)
    80001f7a:	46c1                	li	a3,16
    80001f7c:	fc840613          	addi	a2,s0,-56
    80001f80:	fd843583          	ld	a1,-40(s0)
    80001f84:	68a8                	ld	a0,80(s1)
    80001f86:	ac1fe0ef          	jal	80000a46 <copyout>
    return -1;
  return 0;
}
    80001f8a:	957d                	srai	a0,a0,0x3f
    80001f8c:	70e2                	ld	ra,56(sp)
    80001f8e:	7442                	ld	s0,48(sp)
    80001f90:	74a2                	ld	s1,40(sp)
    80001f92:	6121                	addi	sp,sp,64
    80001f94:	8082                	ret

0000000080001f96 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f96:	7179                	addi	sp,sp,-48
    80001f98:	f406                	sd	ra,40(sp)
    80001f9a:	f022                	sd	s0,32(sp)
    80001f9c:	ec26                	sd	s1,24(sp)
    80001f9e:	e84a                	sd	s2,16(sp)
    80001fa0:	e44e                	sd	s3,8(sp)
    80001fa2:	e052                	sd	s4,0(sp)
    80001fa4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fa6:	00005597          	auipc	a1,0x5
    80001faa:	4f258593          	addi	a1,a1,1266 # 80007498 <etext+0x498>
    80001fae:	0000e517          	auipc	a0,0xe
    80001fb2:	5aa50513          	addi	a0,a0,1450 # 80010558 <bcache>
    80001fb6:	00b030ef          	jal	800057c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fba:	00016797          	auipc	a5,0x16
    80001fbe:	59e78793          	addi	a5,a5,1438 # 80018558 <bcache+0x8000>
    80001fc2:	00016717          	auipc	a4,0x16
    80001fc6:	7fe70713          	addi	a4,a4,2046 # 800187c0 <bcache+0x8268>
    80001fca:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fce:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fd2:	0000e497          	auipc	s1,0xe
    80001fd6:	59e48493          	addi	s1,s1,1438 # 80010570 <bcache+0x18>
    b->next = bcache.head.next;
    80001fda:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fdc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fde:	00005a17          	auipc	s4,0x5
    80001fe2:	4c2a0a13          	addi	s4,s4,1218 # 800074a0 <etext+0x4a0>
    b->next = bcache.head.next;
    80001fe6:	2b893783          	ld	a5,696(s2)
    80001fea:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001fec:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ff0:	85d2                	mv	a1,s4
    80001ff2:	01048513          	addi	a0,s1,16
    80001ff6:	244010ef          	jal	8000323a <initsleeplock>
    bcache.head.next->prev = b;
    80001ffa:	2b893783          	ld	a5,696(s2)
    80001ffe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002000:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002004:	45848493          	addi	s1,s1,1112
    80002008:	fd349fe3          	bne	s1,s3,80001fe6 <binit+0x50>
  }
}
    8000200c:	70a2                	ld	ra,40(sp)
    8000200e:	7402                	ld	s0,32(sp)
    80002010:	64e2                	ld	s1,24(sp)
    80002012:	6942                	ld	s2,16(sp)
    80002014:	69a2                	ld	s3,8(sp)
    80002016:	6a02                	ld	s4,0(sp)
    80002018:	6145                	addi	sp,sp,48
    8000201a:	8082                	ret

000000008000201c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000201c:	7179                	addi	sp,sp,-48
    8000201e:	f406                	sd	ra,40(sp)
    80002020:	f022                	sd	s0,32(sp)
    80002022:	ec26                	sd	s1,24(sp)
    80002024:	e84a                	sd	s2,16(sp)
    80002026:	e44e                	sd	s3,8(sp)
    80002028:	1800                	addi	s0,sp,48
    8000202a:	892a                	mv	s2,a0
    8000202c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000202e:	0000e517          	auipc	a0,0xe
    80002032:	52a50513          	addi	a0,a0,1322 # 80010558 <bcache>
    80002036:	00f030ef          	jal	80005844 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000203a:	00016497          	auipc	s1,0x16
    8000203e:	7d64b483          	ld	s1,2006(s1) # 80018810 <bcache+0x82b8>
    80002042:	00016797          	auipc	a5,0x16
    80002046:	77e78793          	addi	a5,a5,1918 # 800187c0 <bcache+0x8268>
    8000204a:	02f48b63          	beq	s1,a5,80002080 <bread+0x64>
    8000204e:	873e                	mv	a4,a5
    80002050:	a021                	j	80002058 <bread+0x3c>
    80002052:	68a4                	ld	s1,80(s1)
    80002054:	02e48663          	beq	s1,a4,80002080 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002058:	449c                	lw	a5,8(s1)
    8000205a:	ff279ce3          	bne	a5,s2,80002052 <bread+0x36>
    8000205e:	44dc                	lw	a5,12(s1)
    80002060:	ff3799e3          	bne	a5,s3,80002052 <bread+0x36>
      b->refcnt++;
    80002064:	40bc                	lw	a5,64(s1)
    80002066:	2785                	addiw	a5,a5,1
    80002068:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000206a:	0000e517          	auipc	a0,0xe
    8000206e:	4ee50513          	addi	a0,a0,1262 # 80010558 <bcache>
    80002072:	067030ef          	jal	800058d8 <release>
      acquiresleep(&b->lock);
    80002076:	01048513          	addi	a0,s1,16
    8000207a:	1f6010ef          	jal	80003270 <acquiresleep>
      return b;
    8000207e:	a889                	j	800020d0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002080:	00016497          	auipc	s1,0x16
    80002084:	7884b483          	ld	s1,1928(s1) # 80018808 <bcache+0x82b0>
    80002088:	00016797          	auipc	a5,0x16
    8000208c:	73878793          	addi	a5,a5,1848 # 800187c0 <bcache+0x8268>
    80002090:	00f48863          	beq	s1,a5,800020a0 <bread+0x84>
    80002094:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002096:	40bc                	lw	a5,64(s1)
    80002098:	cb91                	beqz	a5,800020ac <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000209a:	64a4                	ld	s1,72(s1)
    8000209c:	fee49de3          	bne	s1,a4,80002096 <bread+0x7a>
  panic("bget: no buffers");
    800020a0:	00005517          	auipc	a0,0x5
    800020a4:	40850513          	addi	a0,a0,1032 # 800074a8 <etext+0x4a8>
    800020a8:	46e030ef          	jal	80005516 <panic>
      b->dev = dev;
    800020ac:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020b0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020b4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020b8:	4785                	li	a5,1
    800020ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020bc:	0000e517          	auipc	a0,0xe
    800020c0:	49c50513          	addi	a0,a0,1180 # 80010558 <bcache>
    800020c4:	015030ef          	jal	800058d8 <release>
      acquiresleep(&b->lock);
    800020c8:	01048513          	addi	a0,s1,16
    800020cc:	1a4010ef          	jal	80003270 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020d0:	409c                	lw	a5,0(s1)
    800020d2:	cb89                	beqz	a5,800020e4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020d4:	8526                	mv	a0,s1
    800020d6:	70a2                	ld	ra,40(sp)
    800020d8:	7402                	ld	s0,32(sp)
    800020da:	64e2                	ld	s1,24(sp)
    800020dc:	6942                	ld	s2,16(sp)
    800020de:	69a2                	ld	s3,8(sp)
    800020e0:	6145                	addi	sp,sp,48
    800020e2:	8082                	ret
    virtio_disk_rw(b, 0);
    800020e4:	4581                	li	a1,0
    800020e6:	8526                	mv	a0,s1
    800020e8:	1f9020ef          	jal	80004ae0 <virtio_disk_rw>
    b->valid = 1;
    800020ec:	4785                	li	a5,1
    800020ee:	c09c                	sw	a5,0(s1)
  return b;
    800020f0:	b7d5                	j	800020d4 <bread+0xb8>

00000000800020f2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	1000                	addi	s0,sp,32
    800020fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020fe:	0541                	addi	a0,a0,16
    80002100:	1ee010ef          	jal	800032ee <holdingsleep>
    80002104:	c911                	beqz	a0,80002118 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002106:	4585                	li	a1,1
    80002108:	8526                	mv	a0,s1
    8000210a:	1d7020ef          	jal	80004ae0 <virtio_disk_rw>
}
    8000210e:	60e2                	ld	ra,24(sp)
    80002110:	6442                	ld	s0,16(sp)
    80002112:	64a2                	ld	s1,8(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret
    panic("bwrite");
    80002118:	00005517          	auipc	a0,0x5
    8000211c:	3a850513          	addi	a0,a0,936 # 800074c0 <etext+0x4c0>
    80002120:	3f6030ef          	jal	80005516 <panic>

0000000080002124 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002124:	1101                	addi	sp,sp,-32
    80002126:	ec06                	sd	ra,24(sp)
    80002128:	e822                	sd	s0,16(sp)
    8000212a:	e426                	sd	s1,8(sp)
    8000212c:	e04a                	sd	s2,0(sp)
    8000212e:	1000                	addi	s0,sp,32
    80002130:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002132:	01050913          	addi	s2,a0,16
    80002136:	854a                	mv	a0,s2
    80002138:	1b6010ef          	jal	800032ee <holdingsleep>
    8000213c:	c125                	beqz	a0,8000219c <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000213e:	854a                	mv	a0,s2
    80002140:	176010ef          	jal	800032b6 <releasesleep>

  acquire(&bcache.lock);
    80002144:	0000e517          	auipc	a0,0xe
    80002148:	41450513          	addi	a0,a0,1044 # 80010558 <bcache>
    8000214c:	6f8030ef          	jal	80005844 <acquire>
  b->refcnt--;
    80002150:	40bc                	lw	a5,64(s1)
    80002152:	37fd                	addiw	a5,a5,-1
    80002154:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002156:	e79d                	bnez	a5,80002184 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002158:	68b8                	ld	a4,80(s1)
    8000215a:	64bc                	ld	a5,72(s1)
    8000215c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000215e:	68b8                	ld	a4,80(s1)
    80002160:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002162:	00016797          	auipc	a5,0x16
    80002166:	3f678793          	addi	a5,a5,1014 # 80018558 <bcache+0x8000>
    8000216a:	2b87b703          	ld	a4,696(a5)
    8000216e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002170:	00016717          	auipc	a4,0x16
    80002174:	65070713          	addi	a4,a4,1616 # 800187c0 <bcache+0x8268>
    80002178:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000217a:	2b87b703          	ld	a4,696(a5)
    8000217e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002180:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002184:	0000e517          	auipc	a0,0xe
    80002188:	3d450513          	addi	a0,a0,980 # 80010558 <bcache>
    8000218c:	74c030ef          	jal	800058d8 <release>
}
    80002190:	60e2                	ld	ra,24(sp)
    80002192:	6442                	ld	s0,16(sp)
    80002194:	64a2                	ld	s1,8(sp)
    80002196:	6902                	ld	s2,0(sp)
    80002198:	6105                	addi	sp,sp,32
    8000219a:	8082                	ret
    panic("brelse");
    8000219c:	00005517          	auipc	a0,0x5
    800021a0:	32c50513          	addi	a0,a0,812 # 800074c8 <etext+0x4c8>
    800021a4:	372030ef          	jal	80005516 <panic>

00000000800021a8 <bpin>:

void
bpin(struct buf *b) {
    800021a8:	1101                	addi	sp,sp,-32
    800021aa:	ec06                	sd	ra,24(sp)
    800021ac:	e822                	sd	s0,16(sp)
    800021ae:	e426                	sd	s1,8(sp)
    800021b0:	1000                	addi	s0,sp,32
    800021b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021b4:	0000e517          	auipc	a0,0xe
    800021b8:	3a450513          	addi	a0,a0,932 # 80010558 <bcache>
    800021bc:	688030ef          	jal	80005844 <acquire>
  b->refcnt++;
    800021c0:	40bc                	lw	a5,64(s1)
    800021c2:	2785                	addiw	a5,a5,1
    800021c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021c6:	0000e517          	auipc	a0,0xe
    800021ca:	39250513          	addi	a0,a0,914 # 80010558 <bcache>
    800021ce:	70a030ef          	jal	800058d8 <release>
}
    800021d2:	60e2                	ld	ra,24(sp)
    800021d4:	6442                	ld	s0,16(sp)
    800021d6:	64a2                	ld	s1,8(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret

00000000800021dc <bunpin>:

void
bunpin(struct buf *b) {
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	e426                	sd	s1,8(sp)
    800021e4:	1000                	addi	s0,sp,32
    800021e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021e8:	0000e517          	auipc	a0,0xe
    800021ec:	37050513          	addi	a0,a0,880 # 80010558 <bcache>
    800021f0:	654030ef          	jal	80005844 <acquire>
  b->refcnt--;
    800021f4:	40bc                	lw	a5,64(s1)
    800021f6:	37fd                	addiw	a5,a5,-1
    800021f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021fa:	0000e517          	auipc	a0,0xe
    800021fe:	35e50513          	addi	a0,a0,862 # 80010558 <bcache>
    80002202:	6d6030ef          	jal	800058d8 <release>
}
    80002206:	60e2                	ld	ra,24(sp)
    80002208:	6442                	ld	s0,16(sp)
    8000220a:	64a2                	ld	s1,8(sp)
    8000220c:	6105                	addi	sp,sp,32
    8000220e:	8082                	ret

0000000080002210 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002210:	1101                	addi	sp,sp,-32
    80002212:	ec06                	sd	ra,24(sp)
    80002214:	e822                	sd	s0,16(sp)
    80002216:	e426                	sd	s1,8(sp)
    80002218:	e04a                	sd	s2,0(sp)
    8000221a:	1000                	addi	s0,sp,32
    8000221c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000221e:	00d5d79b          	srliw	a5,a1,0xd
    80002222:	00017597          	auipc	a1,0x17
    80002226:	a125a583          	lw	a1,-1518(a1) # 80018c34 <sb+0x1c>
    8000222a:	9dbd                	addw	a1,a1,a5
    8000222c:	df1ff0ef          	jal	8000201c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002230:	0074f713          	andi	a4,s1,7
    80002234:	4785                	li	a5,1
    80002236:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000223a:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000223c:	90d9                	srli	s1,s1,0x36
    8000223e:	00950733          	add	a4,a0,s1
    80002242:	05874703          	lbu	a4,88(a4)
    80002246:	00e7f6b3          	and	a3,a5,a4
    8000224a:	c29d                	beqz	a3,80002270 <bfree+0x60>
    8000224c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000224e:	94aa                	add	s1,s1,a0
    80002250:	fff7c793          	not	a5,a5
    80002254:	8f7d                	and	a4,a4,a5
    80002256:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000225a:	711000ef          	jal	8000316a <log_write>
  brelse(bp);
    8000225e:	854a                	mv	a0,s2
    80002260:	ec5ff0ef          	jal	80002124 <brelse>
}
    80002264:	60e2                	ld	ra,24(sp)
    80002266:	6442                	ld	s0,16(sp)
    80002268:	64a2                	ld	s1,8(sp)
    8000226a:	6902                	ld	s2,0(sp)
    8000226c:	6105                	addi	sp,sp,32
    8000226e:	8082                	ret
    panic("freeing free block");
    80002270:	00005517          	auipc	a0,0x5
    80002274:	26050513          	addi	a0,a0,608 # 800074d0 <etext+0x4d0>
    80002278:	29e030ef          	jal	80005516 <panic>

000000008000227c <balloc>:
{
    8000227c:	715d                	addi	sp,sp,-80
    8000227e:	e486                	sd	ra,72(sp)
    80002280:	e0a2                	sd	s0,64(sp)
    80002282:	fc26                	sd	s1,56(sp)
    80002284:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002286:	00017797          	auipc	a5,0x17
    8000228a:	9967a783          	lw	a5,-1642(a5) # 80018c1c <sb+0x4>
    8000228e:	0e078863          	beqz	a5,8000237e <balloc+0x102>
    80002292:	f84a                	sd	s2,48(sp)
    80002294:	f44e                	sd	s3,40(sp)
    80002296:	f052                	sd	s4,32(sp)
    80002298:	ec56                	sd	s5,24(sp)
    8000229a:	e85a                	sd	s6,16(sp)
    8000229c:	e45e                	sd	s7,8(sp)
    8000229e:	e062                	sd	s8,0(sp)
    800022a0:	8baa                	mv	s7,a0
    800022a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022a4:	00017b17          	auipc	s6,0x17
    800022a8:	974b0b13          	addi	s6,s6,-1676 # 80018c18 <sb>
      m = 1 << (bi % 8);
    800022ac:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022ae:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022b0:	6c09                	lui	s8,0x2
    800022b2:	a09d                	j	80002318 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022b4:	97ca                	add	a5,a5,s2
    800022b6:	8e55                	or	a2,a2,a3
    800022b8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022bc:	854a                	mv	a0,s2
    800022be:	6ad000ef          	jal	8000316a <log_write>
        brelse(bp);
    800022c2:	854a                	mv	a0,s2
    800022c4:	e61ff0ef          	jal	80002124 <brelse>
  bp = bread(dev, bno);
    800022c8:	85a6                	mv	a1,s1
    800022ca:	855e                	mv	a0,s7
    800022cc:	d51ff0ef          	jal	8000201c <bread>
    800022d0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022d2:	40000613          	li	a2,1024
    800022d6:	4581                	li	a1,0
    800022d8:	05850513          	addi	a0,a0,88
    800022dc:	eb5fd0ef          	jal	80000190 <memset>
  log_write(bp);
    800022e0:	854a                	mv	a0,s2
    800022e2:	689000ef          	jal	8000316a <log_write>
  brelse(bp);
    800022e6:	854a                	mv	a0,s2
    800022e8:	e3dff0ef          	jal	80002124 <brelse>
}
    800022ec:	7942                	ld	s2,48(sp)
    800022ee:	79a2                	ld	s3,40(sp)
    800022f0:	7a02                	ld	s4,32(sp)
    800022f2:	6ae2                	ld	s5,24(sp)
    800022f4:	6b42                	ld	s6,16(sp)
    800022f6:	6ba2                	ld	s7,8(sp)
    800022f8:	6c02                	ld	s8,0(sp)
}
    800022fa:	8526                	mv	a0,s1
    800022fc:	60a6                	ld	ra,72(sp)
    800022fe:	6406                	ld	s0,64(sp)
    80002300:	74e2                	ld	s1,56(sp)
    80002302:	6161                	addi	sp,sp,80
    80002304:	8082                	ret
    brelse(bp);
    80002306:	854a                	mv	a0,s2
    80002308:	e1dff0ef          	jal	80002124 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000230c:	015c0abb          	addw	s5,s8,s5
    80002310:	004b2783          	lw	a5,4(s6)
    80002314:	04fafe63          	bgeu	s5,a5,80002370 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80002318:	41fad79b          	sraiw	a5,s5,0x1f
    8000231c:	0137d79b          	srliw	a5,a5,0x13
    80002320:	015787bb          	addw	a5,a5,s5
    80002324:	40d7d79b          	sraiw	a5,a5,0xd
    80002328:	01cb2583          	lw	a1,28(s6)
    8000232c:	9dbd                	addw	a1,a1,a5
    8000232e:	855e                	mv	a0,s7
    80002330:	cedff0ef          	jal	8000201c <bread>
    80002334:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002336:	004b2503          	lw	a0,4(s6)
    8000233a:	84d6                	mv	s1,s5
    8000233c:	4701                	li	a4,0
    8000233e:	fca4f4e3          	bgeu	s1,a0,80002306 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002342:	00777693          	andi	a3,a4,7
    80002346:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000234a:	41f7579b          	sraiw	a5,a4,0x1f
    8000234e:	01d7d79b          	srliw	a5,a5,0x1d
    80002352:	9fb9                	addw	a5,a5,a4
    80002354:	4037d79b          	sraiw	a5,a5,0x3
    80002358:	00f90633          	add	a2,s2,a5
    8000235c:	05864603          	lbu	a2,88(a2)
    80002360:	00c6f5b3          	and	a1,a3,a2
    80002364:	d9a1                	beqz	a1,800022b4 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002366:	2705                	addiw	a4,a4,1
    80002368:	2485                	addiw	s1,s1,1
    8000236a:	fd471ae3          	bne	a4,s4,8000233e <balloc+0xc2>
    8000236e:	bf61                	j	80002306 <balloc+0x8a>
    80002370:	7942                	ld	s2,48(sp)
    80002372:	79a2                	ld	s3,40(sp)
    80002374:	7a02                	ld	s4,32(sp)
    80002376:	6ae2                	ld	s5,24(sp)
    80002378:	6b42                	ld	s6,16(sp)
    8000237a:	6ba2                	ld	s7,8(sp)
    8000237c:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000237e:	00005517          	auipc	a0,0x5
    80002382:	16a50513          	addi	a0,a0,362 # 800074e8 <etext+0x4e8>
    80002386:	6c1020ef          	jal	80005246 <printf>
  return 0;
    8000238a:	4481                	li	s1,0
    8000238c:	b7bd                	j	800022fa <balloc+0x7e>

000000008000238e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000238e:	7179                	addi	sp,sp,-48
    80002390:	f406                	sd	ra,40(sp)
    80002392:	f022                	sd	s0,32(sp)
    80002394:	ec26                	sd	s1,24(sp)
    80002396:	e84a                	sd	s2,16(sp)
    80002398:	e44e                	sd	s3,8(sp)
    8000239a:	1800                	addi	s0,sp,48
    8000239c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000239e:	47ad                	li	a5,11
    800023a0:	02b7e363          	bltu	a5,a1,800023c6 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800023a4:	02059793          	slli	a5,a1,0x20
    800023a8:	01e7d593          	srli	a1,a5,0x1e
    800023ac:	00b504b3          	add	s1,a0,a1
    800023b0:	0504a903          	lw	s2,80(s1)
    800023b4:	06091363          	bnez	s2,8000241a <bmap+0x8c>
      addr = balloc(ip->dev);
    800023b8:	4108                	lw	a0,0(a0)
    800023ba:	ec3ff0ef          	jal	8000227c <balloc>
    800023be:	892a                	mv	s2,a0
      if(addr == 0)
    800023c0:	cd29                	beqz	a0,8000241a <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    800023c2:	c8a8                	sw	a0,80(s1)
    800023c4:	a899                	j	8000241a <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023c6:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800023ca:	0ff00793          	li	a5,255
    800023ce:	0697e963          	bltu	a5,s1,80002440 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023d2:	08052903          	lw	s2,128(a0)
    800023d6:	00091b63          	bnez	s2,800023ec <bmap+0x5e>
      addr = balloc(ip->dev);
    800023da:	4108                	lw	a0,0(a0)
    800023dc:	ea1ff0ef          	jal	8000227c <balloc>
    800023e0:	892a                	mv	s2,a0
      if(addr == 0)
    800023e2:	cd05                	beqz	a0,8000241a <bmap+0x8c>
    800023e4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023e6:	08a9a023          	sw	a0,128(s3)
    800023ea:	a011                	j	800023ee <bmap+0x60>
    800023ec:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023ee:	85ca                	mv	a1,s2
    800023f0:	0009a503          	lw	a0,0(s3)
    800023f4:	c29ff0ef          	jal	8000201c <bread>
    800023f8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023fa:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023fe:	02049713          	slli	a4,s1,0x20
    80002402:	01e75593          	srli	a1,a4,0x1e
    80002406:	00b784b3          	add	s1,a5,a1
    8000240a:	0004a903          	lw	s2,0(s1)
    8000240e:	00090e63          	beqz	s2,8000242a <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002412:	8552                	mv	a0,s4
    80002414:	d11ff0ef          	jal	80002124 <brelse>
    return addr;
    80002418:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000241a:	854a                	mv	a0,s2
    8000241c:	70a2                	ld	ra,40(sp)
    8000241e:	7402                	ld	s0,32(sp)
    80002420:	64e2                	ld	s1,24(sp)
    80002422:	6942                	ld	s2,16(sp)
    80002424:	69a2                	ld	s3,8(sp)
    80002426:	6145                	addi	sp,sp,48
    80002428:	8082                	ret
      addr = balloc(ip->dev);
    8000242a:	0009a503          	lw	a0,0(s3)
    8000242e:	e4fff0ef          	jal	8000227c <balloc>
    80002432:	892a                	mv	s2,a0
      if(addr){
    80002434:	dd79                	beqz	a0,80002412 <bmap+0x84>
        a[bn] = addr;
    80002436:	c088                	sw	a0,0(s1)
        log_write(bp);
    80002438:	8552                	mv	a0,s4
    8000243a:	531000ef          	jal	8000316a <log_write>
    8000243e:	bfd1                	j	80002412 <bmap+0x84>
    80002440:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002442:	00005517          	auipc	a0,0x5
    80002446:	0be50513          	addi	a0,a0,190 # 80007500 <etext+0x500>
    8000244a:	0cc030ef          	jal	80005516 <panic>

000000008000244e <iget>:
{
    8000244e:	7179                	addi	sp,sp,-48
    80002450:	f406                	sd	ra,40(sp)
    80002452:	f022                	sd	s0,32(sp)
    80002454:	ec26                	sd	s1,24(sp)
    80002456:	e84a                	sd	s2,16(sp)
    80002458:	e44e                	sd	s3,8(sp)
    8000245a:	e052                	sd	s4,0(sp)
    8000245c:	1800                	addi	s0,sp,48
    8000245e:	89aa                	mv	s3,a0
    80002460:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002462:	00016517          	auipc	a0,0x16
    80002466:	7d650513          	addi	a0,a0,2006 # 80018c38 <itable>
    8000246a:	3da030ef          	jal	80005844 <acquire>
  empty = 0;
    8000246e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002470:	00016497          	auipc	s1,0x16
    80002474:	7e048493          	addi	s1,s1,2016 # 80018c50 <itable+0x18>
    80002478:	00018697          	auipc	a3,0x18
    8000247c:	26868693          	addi	a3,a3,616 # 8001a6e0 <log>
    80002480:	a039                	j	8000248e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002482:	02090963          	beqz	s2,800024b4 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002486:	08848493          	addi	s1,s1,136
    8000248a:	02d48863          	beq	s1,a3,800024ba <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000248e:	449c                	lw	a5,8(s1)
    80002490:	fef059e3          	blez	a5,80002482 <iget+0x34>
    80002494:	4098                	lw	a4,0(s1)
    80002496:	ff3716e3          	bne	a4,s3,80002482 <iget+0x34>
    8000249a:	40d8                	lw	a4,4(s1)
    8000249c:	ff4713e3          	bne	a4,s4,80002482 <iget+0x34>
      ip->ref++;
    800024a0:	2785                	addiw	a5,a5,1
    800024a2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024a4:	00016517          	auipc	a0,0x16
    800024a8:	79450513          	addi	a0,a0,1940 # 80018c38 <itable>
    800024ac:	42c030ef          	jal	800058d8 <release>
      return ip;
    800024b0:	8926                	mv	s2,s1
    800024b2:	a02d                	j	800024dc <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024b4:	fbe9                	bnez	a5,80002486 <iget+0x38>
      empty = ip;
    800024b6:	8926                	mv	s2,s1
    800024b8:	b7f9                	j	80002486 <iget+0x38>
  if(empty == 0)
    800024ba:	02090a63          	beqz	s2,800024ee <iget+0xa0>
  ip->dev = dev;
    800024be:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024c2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024c6:	4785                	li	a5,1
    800024c8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024cc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024d0:	00016517          	auipc	a0,0x16
    800024d4:	76850513          	addi	a0,a0,1896 # 80018c38 <itable>
    800024d8:	400030ef          	jal	800058d8 <release>
}
    800024dc:	854a                	mv	a0,s2
    800024de:	70a2                	ld	ra,40(sp)
    800024e0:	7402                	ld	s0,32(sp)
    800024e2:	64e2                	ld	s1,24(sp)
    800024e4:	6942                	ld	s2,16(sp)
    800024e6:	69a2                	ld	s3,8(sp)
    800024e8:	6a02                	ld	s4,0(sp)
    800024ea:	6145                	addi	sp,sp,48
    800024ec:	8082                	ret
    panic("iget: no inodes");
    800024ee:	00005517          	auipc	a0,0x5
    800024f2:	02a50513          	addi	a0,a0,42 # 80007518 <etext+0x518>
    800024f6:	020030ef          	jal	80005516 <panic>

00000000800024fa <fsinit>:
fsinit(int dev) {
    800024fa:	7179                	addi	sp,sp,-48
    800024fc:	f406                	sd	ra,40(sp)
    800024fe:	f022                	sd	s0,32(sp)
    80002500:	ec26                	sd	s1,24(sp)
    80002502:	e84a                	sd	s2,16(sp)
    80002504:	e44e                	sd	s3,8(sp)
    80002506:	1800                	addi	s0,sp,48
    80002508:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000250a:	4585                	li	a1,1
    8000250c:	b11ff0ef          	jal	8000201c <bread>
    80002510:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002512:	00016997          	auipc	s3,0x16
    80002516:	70698993          	addi	s3,s3,1798 # 80018c18 <sb>
    8000251a:	02000613          	li	a2,32
    8000251e:	05850593          	addi	a1,a0,88
    80002522:	854e                	mv	a0,s3
    80002524:	cd1fd0ef          	jal	800001f4 <memmove>
  brelse(bp);
    80002528:	8526                	mv	a0,s1
    8000252a:	bfbff0ef          	jal	80002124 <brelse>
  if(sb.magic != FSMAGIC)
    8000252e:	0009a703          	lw	a4,0(s3)
    80002532:	102037b7          	lui	a5,0x10203
    80002536:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000253a:	02f71063          	bne	a4,a5,8000255a <fsinit+0x60>
  initlog(dev, &sb);
    8000253e:	00016597          	auipc	a1,0x16
    80002542:	6da58593          	addi	a1,a1,1754 # 80018c18 <sb>
    80002546:	854a                	mv	a0,s2
    80002548:	215000ef          	jal	80002f5c <initlog>
}
    8000254c:	70a2                	ld	ra,40(sp)
    8000254e:	7402                	ld	s0,32(sp)
    80002550:	64e2                	ld	s1,24(sp)
    80002552:	6942                	ld	s2,16(sp)
    80002554:	69a2                	ld	s3,8(sp)
    80002556:	6145                	addi	sp,sp,48
    80002558:	8082                	ret
    panic("invalid file system");
    8000255a:	00005517          	auipc	a0,0x5
    8000255e:	fce50513          	addi	a0,a0,-50 # 80007528 <etext+0x528>
    80002562:	7b5020ef          	jal	80005516 <panic>

0000000080002566 <iinit>:
{
    80002566:	7179                	addi	sp,sp,-48
    80002568:	f406                	sd	ra,40(sp)
    8000256a:	f022                	sd	s0,32(sp)
    8000256c:	ec26                	sd	s1,24(sp)
    8000256e:	e84a                	sd	s2,16(sp)
    80002570:	e44e                	sd	s3,8(sp)
    80002572:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002574:	00005597          	auipc	a1,0x5
    80002578:	fcc58593          	addi	a1,a1,-52 # 80007540 <etext+0x540>
    8000257c:	00016517          	auipc	a0,0x16
    80002580:	6bc50513          	addi	a0,a0,1724 # 80018c38 <itable>
    80002584:	23c030ef          	jal	800057c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002588:	00016497          	auipc	s1,0x16
    8000258c:	6d848493          	addi	s1,s1,1752 # 80018c60 <itable+0x28>
    80002590:	00018997          	auipc	s3,0x18
    80002594:	16098993          	addi	s3,s3,352 # 8001a6f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002598:	00005917          	auipc	s2,0x5
    8000259c:	fb090913          	addi	s2,s2,-80 # 80007548 <etext+0x548>
    800025a0:	85ca                	mv	a1,s2
    800025a2:	8526                	mv	a0,s1
    800025a4:	497000ef          	jal	8000323a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025a8:	08848493          	addi	s1,s1,136
    800025ac:	ff349ae3          	bne	s1,s3,800025a0 <iinit+0x3a>
}
    800025b0:	70a2                	ld	ra,40(sp)
    800025b2:	7402                	ld	s0,32(sp)
    800025b4:	64e2                	ld	s1,24(sp)
    800025b6:	6942                	ld	s2,16(sp)
    800025b8:	69a2                	ld	s3,8(sp)
    800025ba:	6145                	addi	sp,sp,48
    800025bc:	8082                	ret

00000000800025be <ialloc>:
{
    800025be:	7139                	addi	sp,sp,-64
    800025c0:	fc06                	sd	ra,56(sp)
    800025c2:	f822                	sd	s0,48(sp)
    800025c4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025c6:	00016717          	auipc	a4,0x16
    800025ca:	65e72703          	lw	a4,1630(a4) # 80018c24 <sb+0xc>
    800025ce:	4785                	li	a5,1
    800025d0:	06e7f063          	bgeu	a5,a4,80002630 <ialloc+0x72>
    800025d4:	f426                	sd	s1,40(sp)
    800025d6:	f04a                	sd	s2,32(sp)
    800025d8:	ec4e                	sd	s3,24(sp)
    800025da:	e852                	sd	s4,16(sp)
    800025dc:	e456                	sd	s5,8(sp)
    800025de:	e05a                	sd	s6,0(sp)
    800025e0:	8aaa                	mv	s5,a0
    800025e2:	8b2e                	mv	s6,a1
    800025e4:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800025e6:	00016a17          	auipc	s4,0x16
    800025ea:	632a0a13          	addi	s4,s4,1586 # 80018c18 <sb>
    800025ee:	00495593          	srli	a1,s2,0x4
    800025f2:	018a2783          	lw	a5,24(s4)
    800025f6:	9dbd                	addw	a1,a1,a5
    800025f8:	8556                	mv	a0,s5
    800025fa:	a23ff0ef          	jal	8000201c <bread>
    800025fe:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002600:	05850993          	addi	s3,a0,88
    80002604:	00f97793          	andi	a5,s2,15
    80002608:	079a                	slli	a5,a5,0x6
    8000260a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000260c:	00099783          	lh	a5,0(s3)
    80002610:	cb9d                	beqz	a5,80002646 <ialloc+0x88>
    brelse(bp);
    80002612:	b13ff0ef          	jal	80002124 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002616:	0905                	addi	s2,s2,1
    80002618:	00ca2703          	lw	a4,12(s4)
    8000261c:	0009079b          	sext.w	a5,s2
    80002620:	fce7e7e3          	bltu	a5,a4,800025ee <ialloc+0x30>
    80002624:	74a2                	ld	s1,40(sp)
    80002626:	7902                	ld	s2,32(sp)
    80002628:	69e2                	ld	s3,24(sp)
    8000262a:	6a42                	ld	s4,16(sp)
    8000262c:	6aa2                	ld	s5,8(sp)
    8000262e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002630:	00005517          	auipc	a0,0x5
    80002634:	f2050513          	addi	a0,a0,-224 # 80007550 <etext+0x550>
    80002638:	40f020ef          	jal	80005246 <printf>
  return 0;
    8000263c:	4501                	li	a0,0
}
    8000263e:	70e2                	ld	ra,56(sp)
    80002640:	7442                	ld	s0,48(sp)
    80002642:	6121                	addi	sp,sp,64
    80002644:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002646:	04000613          	li	a2,64
    8000264a:	4581                	li	a1,0
    8000264c:	854e                	mv	a0,s3
    8000264e:	b43fd0ef          	jal	80000190 <memset>
      dip->type = type;
    80002652:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002656:	8526                	mv	a0,s1
    80002658:	313000ef          	jal	8000316a <log_write>
      brelse(bp);
    8000265c:	8526                	mv	a0,s1
    8000265e:	ac7ff0ef          	jal	80002124 <brelse>
      return iget(dev, inum);
    80002662:	0009059b          	sext.w	a1,s2
    80002666:	8556                	mv	a0,s5
    80002668:	de7ff0ef          	jal	8000244e <iget>
    8000266c:	74a2                	ld	s1,40(sp)
    8000266e:	7902                	ld	s2,32(sp)
    80002670:	69e2                	ld	s3,24(sp)
    80002672:	6a42                	ld	s4,16(sp)
    80002674:	6aa2                	ld	s5,8(sp)
    80002676:	6b02                	ld	s6,0(sp)
    80002678:	b7d9                	j	8000263e <ialloc+0x80>

000000008000267a <iupdate>:
{
    8000267a:	1101                	addi	sp,sp,-32
    8000267c:	ec06                	sd	ra,24(sp)
    8000267e:	e822                	sd	s0,16(sp)
    80002680:	e426                	sd	s1,8(sp)
    80002682:	e04a                	sd	s2,0(sp)
    80002684:	1000                	addi	s0,sp,32
    80002686:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002688:	415c                	lw	a5,4(a0)
    8000268a:	0047d79b          	srliw	a5,a5,0x4
    8000268e:	00016597          	auipc	a1,0x16
    80002692:	5a25a583          	lw	a1,1442(a1) # 80018c30 <sb+0x18>
    80002696:	9dbd                	addw	a1,a1,a5
    80002698:	4108                	lw	a0,0(a0)
    8000269a:	983ff0ef          	jal	8000201c <bread>
    8000269e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026a0:	05850793          	addi	a5,a0,88
    800026a4:	40d8                	lw	a4,4(s1)
    800026a6:	8b3d                	andi	a4,a4,15
    800026a8:	071a                	slli	a4,a4,0x6
    800026aa:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026ac:	04449703          	lh	a4,68(s1)
    800026b0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026b4:	04649703          	lh	a4,70(s1)
    800026b8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026bc:	04849703          	lh	a4,72(s1)
    800026c0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026c4:	04a49703          	lh	a4,74(s1)
    800026c8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026cc:	44f8                	lw	a4,76(s1)
    800026ce:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026d0:	03400613          	li	a2,52
    800026d4:	05048593          	addi	a1,s1,80
    800026d8:	00c78513          	addi	a0,a5,12
    800026dc:	b19fd0ef          	jal	800001f4 <memmove>
  log_write(bp);
    800026e0:	854a                	mv	a0,s2
    800026e2:	289000ef          	jal	8000316a <log_write>
  brelse(bp);
    800026e6:	854a                	mv	a0,s2
    800026e8:	a3dff0ef          	jal	80002124 <brelse>
}
    800026ec:	60e2                	ld	ra,24(sp)
    800026ee:	6442                	ld	s0,16(sp)
    800026f0:	64a2                	ld	s1,8(sp)
    800026f2:	6902                	ld	s2,0(sp)
    800026f4:	6105                	addi	sp,sp,32
    800026f6:	8082                	ret

00000000800026f8 <idup>:
{
    800026f8:	1101                	addi	sp,sp,-32
    800026fa:	ec06                	sd	ra,24(sp)
    800026fc:	e822                	sd	s0,16(sp)
    800026fe:	e426                	sd	s1,8(sp)
    80002700:	1000                	addi	s0,sp,32
    80002702:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002704:	00016517          	auipc	a0,0x16
    80002708:	53450513          	addi	a0,a0,1332 # 80018c38 <itable>
    8000270c:	138030ef          	jal	80005844 <acquire>
  ip->ref++;
    80002710:	449c                	lw	a5,8(s1)
    80002712:	2785                	addiw	a5,a5,1
    80002714:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002716:	00016517          	auipc	a0,0x16
    8000271a:	52250513          	addi	a0,a0,1314 # 80018c38 <itable>
    8000271e:	1ba030ef          	jal	800058d8 <release>
}
    80002722:	8526                	mv	a0,s1
    80002724:	60e2                	ld	ra,24(sp)
    80002726:	6442                	ld	s0,16(sp)
    80002728:	64a2                	ld	s1,8(sp)
    8000272a:	6105                	addi	sp,sp,32
    8000272c:	8082                	ret

000000008000272e <ilock>:
{
    8000272e:	1101                	addi	sp,sp,-32
    80002730:	ec06                	sd	ra,24(sp)
    80002732:	e822                	sd	s0,16(sp)
    80002734:	e426                	sd	s1,8(sp)
    80002736:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002738:	cd19                	beqz	a0,80002756 <ilock+0x28>
    8000273a:	84aa                	mv	s1,a0
    8000273c:	451c                	lw	a5,8(a0)
    8000273e:	00f05c63          	blez	a5,80002756 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002742:	0541                	addi	a0,a0,16
    80002744:	32d000ef          	jal	80003270 <acquiresleep>
  if(ip->valid == 0){
    80002748:	40bc                	lw	a5,64(s1)
    8000274a:	cf89                	beqz	a5,80002764 <ilock+0x36>
}
    8000274c:	60e2                	ld	ra,24(sp)
    8000274e:	6442                	ld	s0,16(sp)
    80002750:	64a2                	ld	s1,8(sp)
    80002752:	6105                	addi	sp,sp,32
    80002754:	8082                	ret
    80002756:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002758:	00005517          	auipc	a0,0x5
    8000275c:	e1050513          	addi	a0,a0,-496 # 80007568 <etext+0x568>
    80002760:	5b7020ef          	jal	80005516 <panic>
    80002764:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002766:	40dc                	lw	a5,4(s1)
    80002768:	0047d79b          	srliw	a5,a5,0x4
    8000276c:	00016597          	auipc	a1,0x16
    80002770:	4c45a583          	lw	a1,1220(a1) # 80018c30 <sb+0x18>
    80002774:	9dbd                	addw	a1,a1,a5
    80002776:	4088                	lw	a0,0(s1)
    80002778:	8a5ff0ef          	jal	8000201c <bread>
    8000277c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000277e:	05850593          	addi	a1,a0,88
    80002782:	40dc                	lw	a5,4(s1)
    80002784:	8bbd                	andi	a5,a5,15
    80002786:	079a                	slli	a5,a5,0x6
    80002788:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000278a:	00059783          	lh	a5,0(a1)
    8000278e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002792:	00259783          	lh	a5,2(a1)
    80002796:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000279a:	00459783          	lh	a5,4(a1)
    8000279e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027a2:	00659783          	lh	a5,6(a1)
    800027a6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027aa:	459c                	lw	a5,8(a1)
    800027ac:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027ae:	03400613          	li	a2,52
    800027b2:	05b1                	addi	a1,a1,12
    800027b4:	05048513          	addi	a0,s1,80
    800027b8:	a3dfd0ef          	jal	800001f4 <memmove>
    brelse(bp);
    800027bc:	854a                	mv	a0,s2
    800027be:	967ff0ef          	jal	80002124 <brelse>
    ip->valid = 1;
    800027c2:	4785                	li	a5,1
    800027c4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027c6:	04449783          	lh	a5,68(s1)
    800027ca:	c399                	beqz	a5,800027d0 <ilock+0xa2>
    800027cc:	6902                	ld	s2,0(sp)
    800027ce:	bfbd                	j	8000274c <ilock+0x1e>
      panic("ilock: no type");
    800027d0:	00005517          	auipc	a0,0x5
    800027d4:	da050513          	addi	a0,a0,-608 # 80007570 <etext+0x570>
    800027d8:	53f020ef          	jal	80005516 <panic>

00000000800027dc <iunlock>:
{
    800027dc:	1101                	addi	sp,sp,-32
    800027de:	ec06                	sd	ra,24(sp)
    800027e0:	e822                	sd	s0,16(sp)
    800027e2:	e426                	sd	s1,8(sp)
    800027e4:	e04a                	sd	s2,0(sp)
    800027e6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027e8:	c505                	beqz	a0,80002810 <iunlock+0x34>
    800027ea:	84aa                	mv	s1,a0
    800027ec:	01050913          	addi	s2,a0,16
    800027f0:	854a                	mv	a0,s2
    800027f2:	2fd000ef          	jal	800032ee <holdingsleep>
    800027f6:	cd09                	beqz	a0,80002810 <iunlock+0x34>
    800027f8:	449c                	lw	a5,8(s1)
    800027fa:	00f05b63          	blez	a5,80002810 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027fe:	854a                	mv	a0,s2
    80002800:	2b7000ef          	jal	800032b6 <releasesleep>
}
    80002804:	60e2                	ld	ra,24(sp)
    80002806:	6442                	ld	s0,16(sp)
    80002808:	64a2                	ld	s1,8(sp)
    8000280a:	6902                	ld	s2,0(sp)
    8000280c:	6105                	addi	sp,sp,32
    8000280e:	8082                	ret
    panic("iunlock");
    80002810:	00005517          	auipc	a0,0x5
    80002814:	d7050513          	addi	a0,a0,-656 # 80007580 <etext+0x580>
    80002818:	4ff020ef          	jal	80005516 <panic>

000000008000281c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000281c:	7179                	addi	sp,sp,-48
    8000281e:	f406                	sd	ra,40(sp)
    80002820:	f022                	sd	s0,32(sp)
    80002822:	ec26                	sd	s1,24(sp)
    80002824:	e84a                	sd	s2,16(sp)
    80002826:	e44e                	sd	s3,8(sp)
    80002828:	1800                	addi	s0,sp,48
    8000282a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000282c:	05050493          	addi	s1,a0,80
    80002830:	08050913          	addi	s2,a0,128
    80002834:	a021                	j	8000283c <itrunc+0x20>
    80002836:	0491                	addi	s1,s1,4
    80002838:	01248b63          	beq	s1,s2,8000284e <itrunc+0x32>
    if(ip->addrs[i]){
    8000283c:	408c                	lw	a1,0(s1)
    8000283e:	dde5                	beqz	a1,80002836 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002840:	0009a503          	lw	a0,0(s3)
    80002844:	9cdff0ef          	jal	80002210 <bfree>
      ip->addrs[i] = 0;
    80002848:	0004a023          	sw	zero,0(s1)
    8000284c:	b7ed                	j	80002836 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000284e:	0809a583          	lw	a1,128(s3)
    80002852:	ed89                	bnez	a1,8000286c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002854:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002858:	854e                	mv	a0,s3
    8000285a:	e21ff0ef          	jal	8000267a <iupdate>
}
    8000285e:	70a2                	ld	ra,40(sp)
    80002860:	7402                	ld	s0,32(sp)
    80002862:	64e2                	ld	s1,24(sp)
    80002864:	6942                	ld	s2,16(sp)
    80002866:	69a2                	ld	s3,8(sp)
    80002868:	6145                	addi	sp,sp,48
    8000286a:	8082                	ret
    8000286c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000286e:	0009a503          	lw	a0,0(s3)
    80002872:	faaff0ef          	jal	8000201c <bread>
    80002876:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002878:	05850493          	addi	s1,a0,88
    8000287c:	45850913          	addi	s2,a0,1112
    80002880:	a021                	j	80002888 <itrunc+0x6c>
    80002882:	0491                	addi	s1,s1,4
    80002884:	01248963          	beq	s1,s2,80002896 <itrunc+0x7a>
      if(a[j])
    80002888:	408c                	lw	a1,0(s1)
    8000288a:	dde5                	beqz	a1,80002882 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000288c:	0009a503          	lw	a0,0(s3)
    80002890:	981ff0ef          	jal	80002210 <bfree>
    80002894:	b7fd                	j	80002882 <itrunc+0x66>
    brelse(bp);
    80002896:	8552                	mv	a0,s4
    80002898:	88dff0ef          	jal	80002124 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000289c:	0809a583          	lw	a1,128(s3)
    800028a0:	0009a503          	lw	a0,0(s3)
    800028a4:	96dff0ef          	jal	80002210 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028a8:	0809a023          	sw	zero,128(s3)
    800028ac:	6a02                	ld	s4,0(sp)
    800028ae:	b75d                	j	80002854 <itrunc+0x38>

00000000800028b0 <iput>:
{
    800028b0:	1101                	addi	sp,sp,-32
    800028b2:	ec06                	sd	ra,24(sp)
    800028b4:	e822                	sd	s0,16(sp)
    800028b6:	e426                	sd	s1,8(sp)
    800028b8:	1000                	addi	s0,sp,32
    800028ba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028bc:	00016517          	auipc	a0,0x16
    800028c0:	37c50513          	addi	a0,a0,892 # 80018c38 <itable>
    800028c4:	781020ef          	jal	80005844 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028c8:	4498                	lw	a4,8(s1)
    800028ca:	4785                	li	a5,1
    800028cc:	02f70063          	beq	a4,a5,800028ec <iput+0x3c>
  ip->ref--;
    800028d0:	449c                	lw	a5,8(s1)
    800028d2:	37fd                	addiw	a5,a5,-1
    800028d4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028d6:	00016517          	auipc	a0,0x16
    800028da:	36250513          	addi	a0,a0,866 # 80018c38 <itable>
    800028de:	7fb020ef          	jal	800058d8 <release>
}
    800028e2:	60e2                	ld	ra,24(sp)
    800028e4:	6442                	ld	s0,16(sp)
    800028e6:	64a2                	ld	s1,8(sp)
    800028e8:	6105                	addi	sp,sp,32
    800028ea:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028ec:	40bc                	lw	a5,64(s1)
    800028ee:	d3ed                	beqz	a5,800028d0 <iput+0x20>
    800028f0:	04a49783          	lh	a5,74(s1)
    800028f4:	fff1                	bnez	a5,800028d0 <iput+0x20>
    800028f6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028f8:	01048913          	addi	s2,s1,16
    800028fc:	854a                	mv	a0,s2
    800028fe:	173000ef          	jal	80003270 <acquiresleep>
    release(&itable.lock);
    80002902:	00016517          	auipc	a0,0x16
    80002906:	33650513          	addi	a0,a0,822 # 80018c38 <itable>
    8000290a:	7cf020ef          	jal	800058d8 <release>
    itrunc(ip);
    8000290e:	8526                	mv	a0,s1
    80002910:	f0dff0ef          	jal	8000281c <itrunc>
    ip->type = 0;
    80002914:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002918:	8526                	mv	a0,s1
    8000291a:	d61ff0ef          	jal	8000267a <iupdate>
    ip->valid = 0;
    8000291e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002922:	854a                	mv	a0,s2
    80002924:	193000ef          	jal	800032b6 <releasesleep>
    acquire(&itable.lock);
    80002928:	00016517          	auipc	a0,0x16
    8000292c:	31050513          	addi	a0,a0,784 # 80018c38 <itable>
    80002930:	715020ef          	jal	80005844 <acquire>
    80002934:	6902                	ld	s2,0(sp)
    80002936:	bf69                	j	800028d0 <iput+0x20>

0000000080002938 <iunlockput>:
{
    80002938:	1101                	addi	sp,sp,-32
    8000293a:	ec06                	sd	ra,24(sp)
    8000293c:	e822                	sd	s0,16(sp)
    8000293e:	e426                	sd	s1,8(sp)
    80002940:	1000                	addi	s0,sp,32
    80002942:	84aa                	mv	s1,a0
  iunlock(ip);
    80002944:	e99ff0ef          	jal	800027dc <iunlock>
  iput(ip);
    80002948:	8526                	mv	a0,s1
    8000294a:	f67ff0ef          	jal	800028b0 <iput>
}
    8000294e:	60e2                	ld	ra,24(sp)
    80002950:	6442                	ld	s0,16(sp)
    80002952:	64a2                	ld	s1,8(sp)
    80002954:	6105                	addi	sp,sp,32
    80002956:	8082                	ret

0000000080002958 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002958:	1141                	addi	sp,sp,-16
    8000295a:	e406                	sd	ra,8(sp)
    8000295c:	e022                	sd	s0,0(sp)
    8000295e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002960:	411c                	lw	a5,0(a0)
    80002962:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002964:	415c                	lw	a5,4(a0)
    80002966:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002968:	04451783          	lh	a5,68(a0)
    8000296c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002970:	04a51783          	lh	a5,74(a0)
    80002974:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002978:	04c56783          	lwu	a5,76(a0)
    8000297c:	e99c                	sd	a5,16(a1)
}
    8000297e:	60a2                	ld	ra,8(sp)
    80002980:	6402                	ld	s0,0(sp)
    80002982:	0141                	addi	sp,sp,16
    80002984:	8082                	ret

0000000080002986 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002986:	457c                	lw	a5,76(a0)
    80002988:	0ed7e663          	bltu	a5,a3,80002a74 <readi+0xee>
{
    8000298c:	7159                	addi	sp,sp,-112
    8000298e:	f486                	sd	ra,104(sp)
    80002990:	f0a2                	sd	s0,96(sp)
    80002992:	eca6                	sd	s1,88(sp)
    80002994:	e0d2                	sd	s4,64(sp)
    80002996:	fc56                	sd	s5,56(sp)
    80002998:	f85a                	sd	s6,48(sp)
    8000299a:	f45e                	sd	s7,40(sp)
    8000299c:	1880                	addi	s0,sp,112
    8000299e:	8b2a                	mv	s6,a0
    800029a0:	8bae                	mv	s7,a1
    800029a2:	8a32                	mv	s4,a2
    800029a4:	84b6                	mv	s1,a3
    800029a6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029a8:	9f35                	addw	a4,a4,a3
    return 0;
    800029aa:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029ac:	0ad76b63          	bltu	a4,a3,80002a62 <readi+0xdc>
    800029b0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029b2:	00e7f463          	bgeu	a5,a4,800029ba <readi+0x34>
    n = ip->size - off;
    800029b6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029ba:	080a8b63          	beqz	s5,80002a50 <readi+0xca>
    800029be:	e8ca                	sd	s2,80(sp)
    800029c0:	f062                	sd	s8,32(sp)
    800029c2:	ec66                	sd	s9,24(sp)
    800029c4:	e86a                	sd	s10,16(sp)
    800029c6:	e46e                	sd	s11,8(sp)
    800029c8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029ca:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029ce:	5c7d                	li	s8,-1
    800029d0:	a80d                	j	80002a02 <readi+0x7c>
    800029d2:	020d1d93          	slli	s11,s10,0x20
    800029d6:	020ddd93          	srli	s11,s11,0x20
    800029da:	05890613          	addi	a2,s2,88
    800029de:	86ee                	mv	a3,s11
    800029e0:	963e                	add	a2,a2,a5
    800029e2:	85d2                	mv	a1,s4
    800029e4:	855e                	mv	a0,s7
    800029e6:	d1dfe0ef          	jal	80001702 <either_copyout>
    800029ea:	05850363          	beq	a0,s8,80002a30 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800029ee:	854a                	mv	a0,s2
    800029f0:	f34ff0ef          	jal	80002124 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029f4:	013d09bb          	addw	s3,s10,s3
    800029f8:	009d04bb          	addw	s1,s10,s1
    800029fc:	9a6e                	add	s4,s4,s11
    800029fe:	0559f363          	bgeu	s3,s5,80002a44 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a02:	00a4d59b          	srliw	a1,s1,0xa
    80002a06:	855a                	mv	a0,s6
    80002a08:	987ff0ef          	jal	8000238e <bmap>
    80002a0c:	85aa                	mv	a1,a0
    if(addr == 0)
    80002a0e:	c139                	beqz	a0,80002a54 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002a10:	000b2503          	lw	a0,0(s6)
    80002a14:	e08ff0ef          	jal	8000201c <bread>
    80002a18:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a1a:	3ff4f793          	andi	a5,s1,1023
    80002a1e:	40fc873b          	subw	a4,s9,a5
    80002a22:	413a86bb          	subw	a3,s5,s3
    80002a26:	8d3a                	mv	s10,a4
    80002a28:	fae6f5e3          	bgeu	a3,a4,800029d2 <readi+0x4c>
    80002a2c:	8d36                	mv	s10,a3
    80002a2e:	b755                	j	800029d2 <readi+0x4c>
      brelse(bp);
    80002a30:	854a                	mv	a0,s2
    80002a32:	ef2ff0ef          	jal	80002124 <brelse>
      tot = -1;
    80002a36:	59fd                	li	s3,-1
      break;
    80002a38:	6946                	ld	s2,80(sp)
    80002a3a:	7c02                	ld	s8,32(sp)
    80002a3c:	6ce2                	ld	s9,24(sp)
    80002a3e:	6d42                	ld	s10,16(sp)
    80002a40:	6da2                	ld	s11,8(sp)
    80002a42:	a831                	j	80002a5e <readi+0xd8>
    80002a44:	6946                	ld	s2,80(sp)
    80002a46:	7c02                	ld	s8,32(sp)
    80002a48:	6ce2                	ld	s9,24(sp)
    80002a4a:	6d42                	ld	s10,16(sp)
    80002a4c:	6da2                	ld	s11,8(sp)
    80002a4e:	a801                	j	80002a5e <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a50:	89d6                	mv	s3,s5
    80002a52:	a031                	j	80002a5e <readi+0xd8>
    80002a54:	6946                	ld	s2,80(sp)
    80002a56:	7c02                	ld	s8,32(sp)
    80002a58:	6ce2                	ld	s9,24(sp)
    80002a5a:	6d42                	ld	s10,16(sp)
    80002a5c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a5e:	854e                	mv	a0,s3
    80002a60:	69a6                	ld	s3,72(sp)
}
    80002a62:	70a6                	ld	ra,104(sp)
    80002a64:	7406                	ld	s0,96(sp)
    80002a66:	64e6                	ld	s1,88(sp)
    80002a68:	6a06                	ld	s4,64(sp)
    80002a6a:	7ae2                	ld	s5,56(sp)
    80002a6c:	7b42                	ld	s6,48(sp)
    80002a6e:	7ba2                	ld	s7,40(sp)
    80002a70:	6165                	addi	sp,sp,112
    80002a72:	8082                	ret
    return 0;
    80002a74:	4501                	li	a0,0
}
    80002a76:	8082                	ret

0000000080002a78 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a78:	457c                	lw	a5,76(a0)
    80002a7a:	0ed7eb63          	bltu	a5,a3,80002b70 <writei+0xf8>
{
    80002a7e:	7159                	addi	sp,sp,-112
    80002a80:	f486                	sd	ra,104(sp)
    80002a82:	f0a2                	sd	s0,96(sp)
    80002a84:	e8ca                	sd	s2,80(sp)
    80002a86:	e0d2                	sd	s4,64(sp)
    80002a88:	fc56                	sd	s5,56(sp)
    80002a8a:	f85a                	sd	s6,48(sp)
    80002a8c:	f45e                	sd	s7,40(sp)
    80002a8e:	1880                	addi	s0,sp,112
    80002a90:	8aaa                	mv	s5,a0
    80002a92:	8bae                	mv	s7,a1
    80002a94:	8a32                	mv	s4,a2
    80002a96:	8936                	mv	s2,a3
    80002a98:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002a9a:	00e687bb          	addw	a5,a3,a4
    80002a9e:	0cd7eb63          	bltu	a5,a3,80002b74 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002aa2:	00043737          	lui	a4,0x43
    80002aa6:	0cf76963          	bltu	a4,a5,80002b78 <writei+0x100>
    80002aaa:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002aac:	0a0b0a63          	beqz	s6,80002b60 <writei+0xe8>
    80002ab0:	eca6                	sd	s1,88(sp)
    80002ab2:	f062                	sd	s8,32(sp)
    80002ab4:	ec66                	sd	s9,24(sp)
    80002ab6:	e86a                	sd	s10,16(sp)
    80002ab8:	e46e                	sd	s11,8(sp)
    80002aba:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002abc:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ac0:	5c7d                	li	s8,-1
    80002ac2:	a825                	j	80002afa <writei+0x82>
    80002ac4:	020d1d93          	slli	s11,s10,0x20
    80002ac8:	020ddd93          	srli	s11,s11,0x20
    80002acc:	05848513          	addi	a0,s1,88
    80002ad0:	86ee                	mv	a3,s11
    80002ad2:	8652                	mv	a2,s4
    80002ad4:	85de                	mv	a1,s7
    80002ad6:	953e                	add	a0,a0,a5
    80002ad8:	c75fe0ef          	jal	8000174c <either_copyin>
    80002adc:	05850663          	beq	a0,s8,80002b28 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ae0:	8526                	mv	a0,s1
    80002ae2:	688000ef          	jal	8000316a <log_write>
    brelse(bp);
    80002ae6:	8526                	mv	a0,s1
    80002ae8:	e3cff0ef          	jal	80002124 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002aec:	013d09bb          	addw	s3,s10,s3
    80002af0:	012d093b          	addw	s2,s10,s2
    80002af4:	9a6e                	add	s4,s4,s11
    80002af6:	0369fc63          	bgeu	s3,s6,80002b2e <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002afa:	00a9559b          	srliw	a1,s2,0xa
    80002afe:	8556                	mv	a0,s5
    80002b00:	88fff0ef          	jal	8000238e <bmap>
    80002b04:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b06:	c505                	beqz	a0,80002b2e <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002b08:	000aa503          	lw	a0,0(s5)
    80002b0c:	d10ff0ef          	jal	8000201c <bread>
    80002b10:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b12:	3ff97793          	andi	a5,s2,1023
    80002b16:	40fc873b          	subw	a4,s9,a5
    80002b1a:	413b06bb          	subw	a3,s6,s3
    80002b1e:	8d3a                	mv	s10,a4
    80002b20:	fae6f2e3          	bgeu	a3,a4,80002ac4 <writei+0x4c>
    80002b24:	8d36                	mv	s10,a3
    80002b26:	bf79                	j	80002ac4 <writei+0x4c>
      brelse(bp);
    80002b28:	8526                	mv	a0,s1
    80002b2a:	dfaff0ef          	jal	80002124 <brelse>
  }

  if(off > ip->size)
    80002b2e:	04caa783          	lw	a5,76(s5)
    80002b32:	0327f963          	bgeu	a5,s2,80002b64 <writei+0xec>
    ip->size = off;
    80002b36:	052aa623          	sw	s2,76(s5)
    80002b3a:	64e6                	ld	s1,88(sp)
    80002b3c:	7c02                	ld	s8,32(sp)
    80002b3e:	6ce2                	ld	s9,24(sp)
    80002b40:	6d42                	ld	s10,16(sp)
    80002b42:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b44:	8556                	mv	a0,s5
    80002b46:	b35ff0ef          	jal	8000267a <iupdate>

  return tot;
    80002b4a:	854e                	mv	a0,s3
    80002b4c:	69a6                	ld	s3,72(sp)
}
    80002b4e:	70a6                	ld	ra,104(sp)
    80002b50:	7406                	ld	s0,96(sp)
    80002b52:	6946                	ld	s2,80(sp)
    80002b54:	6a06                	ld	s4,64(sp)
    80002b56:	7ae2                	ld	s5,56(sp)
    80002b58:	7b42                	ld	s6,48(sp)
    80002b5a:	7ba2                	ld	s7,40(sp)
    80002b5c:	6165                	addi	sp,sp,112
    80002b5e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b60:	89da                	mv	s3,s6
    80002b62:	b7cd                	j	80002b44 <writei+0xcc>
    80002b64:	64e6                	ld	s1,88(sp)
    80002b66:	7c02                	ld	s8,32(sp)
    80002b68:	6ce2                	ld	s9,24(sp)
    80002b6a:	6d42                	ld	s10,16(sp)
    80002b6c:	6da2                	ld	s11,8(sp)
    80002b6e:	bfd9                	j	80002b44 <writei+0xcc>
    return -1;
    80002b70:	557d                	li	a0,-1
}
    80002b72:	8082                	ret
    return -1;
    80002b74:	557d                	li	a0,-1
    80002b76:	bfe1                	j	80002b4e <writei+0xd6>
    return -1;
    80002b78:	557d                	li	a0,-1
    80002b7a:	bfd1                	j	80002b4e <writei+0xd6>

0000000080002b7c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b7c:	1141                	addi	sp,sp,-16
    80002b7e:	e406                	sd	ra,8(sp)
    80002b80:	e022                	sd	s0,0(sp)
    80002b82:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b84:	4639                	li	a2,14
    80002b86:	ee2fd0ef          	jal	80000268 <strncmp>
}
    80002b8a:	60a2                	ld	ra,8(sp)
    80002b8c:	6402                	ld	s0,0(sp)
    80002b8e:	0141                	addi	sp,sp,16
    80002b90:	8082                	ret

0000000080002b92 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002b92:	711d                	addi	sp,sp,-96
    80002b94:	ec86                	sd	ra,88(sp)
    80002b96:	e8a2                	sd	s0,80(sp)
    80002b98:	e4a6                	sd	s1,72(sp)
    80002b9a:	e0ca                	sd	s2,64(sp)
    80002b9c:	fc4e                	sd	s3,56(sp)
    80002b9e:	f852                	sd	s4,48(sp)
    80002ba0:	f456                	sd	s5,40(sp)
    80002ba2:	f05a                	sd	s6,32(sp)
    80002ba4:	ec5e                	sd	s7,24(sp)
    80002ba6:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002ba8:	04451703          	lh	a4,68(a0)
    80002bac:	4785                	li	a5,1
    80002bae:	00f71f63          	bne	a4,a5,80002bcc <dirlookup+0x3a>
    80002bb2:	892a                	mv	s2,a0
    80002bb4:	8aae                	mv	s5,a1
    80002bb6:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bb8:	457c                	lw	a5,76(a0)
    80002bba:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bbc:	fa040a13          	addi	s4,s0,-96
    80002bc0:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002bc2:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bc6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bc8:	e39d                	bnez	a5,80002bee <dirlookup+0x5c>
    80002bca:	a8b9                	j	80002c28 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002bcc:	00005517          	auipc	a0,0x5
    80002bd0:	9bc50513          	addi	a0,a0,-1604 # 80007588 <etext+0x588>
    80002bd4:	143020ef          	jal	80005516 <panic>
      panic("dirlookup read");
    80002bd8:	00005517          	auipc	a0,0x5
    80002bdc:	9c850513          	addi	a0,a0,-1592 # 800075a0 <etext+0x5a0>
    80002be0:	137020ef          	jal	80005516 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002be4:	24c1                	addiw	s1,s1,16
    80002be6:	04c92783          	lw	a5,76(s2)
    80002bea:	02f4fe63          	bgeu	s1,a5,80002c26 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bee:	874e                	mv	a4,s3
    80002bf0:	86a6                	mv	a3,s1
    80002bf2:	8652                	mv	a2,s4
    80002bf4:	4581                	li	a1,0
    80002bf6:	854a                	mv	a0,s2
    80002bf8:	d8fff0ef          	jal	80002986 <readi>
    80002bfc:	fd351ee3          	bne	a0,s3,80002bd8 <dirlookup+0x46>
    if(de.inum == 0)
    80002c00:	fa045783          	lhu	a5,-96(s0)
    80002c04:	d3e5                	beqz	a5,80002be4 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002c06:	85da                	mv	a1,s6
    80002c08:	8556                	mv	a0,s5
    80002c0a:	f73ff0ef          	jal	80002b7c <namecmp>
    80002c0e:	f979                	bnez	a0,80002be4 <dirlookup+0x52>
      if(poff)
    80002c10:	000b8463          	beqz	s7,80002c18 <dirlookup+0x86>
        *poff = off;
    80002c14:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002c18:	fa045583          	lhu	a1,-96(s0)
    80002c1c:	00092503          	lw	a0,0(s2)
    80002c20:	82fff0ef          	jal	8000244e <iget>
    80002c24:	a011                	j	80002c28 <dirlookup+0x96>
  return 0;
    80002c26:	4501                	li	a0,0
}
    80002c28:	60e6                	ld	ra,88(sp)
    80002c2a:	6446                	ld	s0,80(sp)
    80002c2c:	64a6                	ld	s1,72(sp)
    80002c2e:	6906                	ld	s2,64(sp)
    80002c30:	79e2                	ld	s3,56(sp)
    80002c32:	7a42                	ld	s4,48(sp)
    80002c34:	7aa2                	ld	s5,40(sp)
    80002c36:	7b02                	ld	s6,32(sp)
    80002c38:	6be2                	ld	s7,24(sp)
    80002c3a:	6125                	addi	sp,sp,96
    80002c3c:	8082                	ret

0000000080002c3e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c3e:	711d                	addi	sp,sp,-96
    80002c40:	ec86                	sd	ra,88(sp)
    80002c42:	e8a2                	sd	s0,80(sp)
    80002c44:	e4a6                	sd	s1,72(sp)
    80002c46:	e0ca                	sd	s2,64(sp)
    80002c48:	fc4e                	sd	s3,56(sp)
    80002c4a:	f852                	sd	s4,48(sp)
    80002c4c:	f456                	sd	s5,40(sp)
    80002c4e:	f05a                	sd	s6,32(sp)
    80002c50:	ec5e                	sd	s7,24(sp)
    80002c52:	e862                	sd	s8,16(sp)
    80002c54:	e466                	sd	s9,8(sp)
    80002c56:	e06a                	sd	s10,0(sp)
    80002c58:	1080                	addi	s0,sp,96
    80002c5a:	84aa                	mv	s1,a0
    80002c5c:	8b2e                	mv	s6,a1
    80002c5e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c60:	00054703          	lbu	a4,0(a0)
    80002c64:	02f00793          	li	a5,47
    80002c68:	00f70f63          	beq	a4,a5,80002c86 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c6c:	966fe0ef          	jal	80000dd2 <myproc>
    80002c70:	15053503          	ld	a0,336(a0)
    80002c74:	a85ff0ef          	jal	800026f8 <idup>
    80002c78:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c7a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002c7e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002c80:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c82:	4b85                	li	s7,1
    80002c84:	a879                	j	80002d22 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002c86:	4585                	li	a1,1
    80002c88:	852e                	mv	a0,a1
    80002c8a:	fc4ff0ef          	jal	8000244e <iget>
    80002c8e:	8a2a                	mv	s4,a0
    80002c90:	b7ed                	j	80002c7a <namex+0x3c>
      iunlockput(ip);
    80002c92:	8552                	mv	a0,s4
    80002c94:	ca5ff0ef          	jal	80002938 <iunlockput>
      return 0;
    80002c98:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c9a:	8552                	mv	a0,s4
    80002c9c:	60e6                	ld	ra,88(sp)
    80002c9e:	6446                	ld	s0,80(sp)
    80002ca0:	64a6                	ld	s1,72(sp)
    80002ca2:	6906                	ld	s2,64(sp)
    80002ca4:	79e2                	ld	s3,56(sp)
    80002ca6:	7a42                	ld	s4,48(sp)
    80002ca8:	7aa2                	ld	s5,40(sp)
    80002caa:	7b02                	ld	s6,32(sp)
    80002cac:	6be2                	ld	s7,24(sp)
    80002cae:	6c42                	ld	s8,16(sp)
    80002cb0:	6ca2                	ld	s9,8(sp)
    80002cb2:	6d02                	ld	s10,0(sp)
    80002cb4:	6125                	addi	sp,sp,96
    80002cb6:	8082                	ret
      iunlock(ip);
    80002cb8:	8552                	mv	a0,s4
    80002cba:	b23ff0ef          	jal	800027dc <iunlock>
      return ip;
    80002cbe:	bff1                	j	80002c9a <namex+0x5c>
      iunlockput(ip);
    80002cc0:	8552                	mv	a0,s4
    80002cc2:	c77ff0ef          	jal	80002938 <iunlockput>
      return 0;
    80002cc6:	8a4e                	mv	s4,s3
    80002cc8:	bfc9                	j	80002c9a <namex+0x5c>
  len = path - s;
    80002cca:	40998633          	sub	a2,s3,s1
    80002cce:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002cd2:	09ac5063          	bge	s8,s10,80002d52 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002cd6:	8666                	mv	a2,s9
    80002cd8:	85a6                	mv	a1,s1
    80002cda:	8556                	mv	a0,s5
    80002cdc:	d18fd0ef          	jal	800001f4 <memmove>
    80002ce0:	84ce                	mv	s1,s3
  while(*path == '/')
    80002ce2:	0004c783          	lbu	a5,0(s1)
    80002ce6:	01279763          	bne	a5,s2,80002cf4 <namex+0xb6>
    path++;
    80002cea:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002cec:	0004c783          	lbu	a5,0(s1)
    80002cf0:	ff278de3          	beq	a5,s2,80002cea <namex+0xac>
    ilock(ip);
    80002cf4:	8552                	mv	a0,s4
    80002cf6:	a39ff0ef          	jal	8000272e <ilock>
    if(ip->type != T_DIR){
    80002cfa:	044a1783          	lh	a5,68(s4)
    80002cfe:	f9779ae3          	bne	a5,s7,80002c92 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002d02:	000b0563          	beqz	s6,80002d0c <namex+0xce>
    80002d06:	0004c783          	lbu	a5,0(s1)
    80002d0a:	d7dd                	beqz	a5,80002cb8 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d0c:	4601                	li	a2,0
    80002d0e:	85d6                	mv	a1,s5
    80002d10:	8552                	mv	a0,s4
    80002d12:	e81ff0ef          	jal	80002b92 <dirlookup>
    80002d16:	89aa                	mv	s3,a0
    80002d18:	d545                	beqz	a0,80002cc0 <namex+0x82>
    iunlockput(ip);
    80002d1a:	8552                	mv	a0,s4
    80002d1c:	c1dff0ef          	jal	80002938 <iunlockput>
    ip = next;
    80002d20:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d22:	0004c783          	lbu	a5,0(s1)
    80002d26:	01279763          	bne	a5,s2,80002d34 <namex+0xf6>
    path++;
    80002d2a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d2c:	0004c783          	lbu	a5,0(s1)
    80002d30:	ff278de3          	beq	a5,s2,80002d2a <namex+0xec>
  if(*path == 0)
    80002d34:	cb8d                	beqz	a5,80002d66 <namex+0x128>
  while(*path != '/' && *path != 0)
    80002d36:	0004c783          	lbu	a5,0(s1)
    80002d3a:	89a6                	mv	s3,s1
  len = path - s;
    80002d3c:	4d01                	li	s10,0
    80002d3e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d40:	01278963          	beq	a5,s2,80002d52 <namex+0x114>
    80002d44:	d3d9                	beqz	a5,80002cca <namex+0x8c>
    path++;
    80002d46:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d48:	0009c783          	lbu	a5,0(s3)
    80002d4c:	ff279ce3          	bne	a5,s2,80002d44 <namex+0x106>
    80002d50:	bfad                	j	80002cca <namex+0x8c>
    memmove(name, s, len);
    80002d52:	2601                	sext.w	a2,a2
    80002d54:	85a6                	mv	a1,s1
    80002d56:	8556                	mv	a0,s5
    80002d58:	c9cfd0ef          	jal	800001f4 <memmove>
    name[len] = 0;
    80002d5c:	9d56                	add	s10,s10,s5
    80002d5e:	000d0023          	sb	zero,0(s10)
    80002d62:	84ce                	mv	s1,s3
    80002d64:	bfbd                	j	80002ce2 <namex+0xa4>
  if(nameiparent){
    80002d66:	f20b0ae3          	beqz	s6,80002c9a <namex+0x5c>
    iput(ip);
    80002d6a:	8552                	mv	a0,s4
    80002d6c:	b45ff0ef          	jal	800028b0 <iput>
    return 0;
    80002d70:	4a01                	li	s4,0
    80002d72:	b725                	j	80002c9a <namex+0x5c>

0000000080002d74 <dirlink>:
{
    80002d74:	715d                	addi	sp,sp,-80
    80002d76:	e486                	sd	ra,72(sp)
    80002d78:	e0a2                	sd	s0,64(sp)
    80002d7a:	f84a                	sd	s2,48(sp)
    80002d7c:	ec56                	sd	s5,24(sp)
    80002d7e:	e85a                	sd	s6,16(sp)
    80002d80:	0880                	addi	s0,sp,80
    80002d82:	892a                	mv	s2,a0
    80002d84:	8aae                	mv	s5,a1
    80002d86:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d88:	4601                	li	a2,0
    80002d8a:	e09ff0ef          	jal	80002b92 <dirlookup>
    80002d8e:	ed1d                	bnez	a0,80002dcc <dirlink+0x58>
    80002d90:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d92:	04c92483          	lw	s1,76(s2)
    80002d96:	c4b9                	beqz	s1,80002de4 <dirlink+0x70>
    80002d98:	f44e                	sd	s3,40(sp)
    80002d9a:	f052                	sd	s4,32(sp)
    80002d9c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d9e:	fb040a13          	addi	s4,s0,-80
    80002da2:	49c1                	li	s3,16
    80002da4:	874e                	mv	a4,s3
    80002da6:	86a6                	mv	a3,s1
    80002da8:	8652                	mv	a2,s4
    80002daa:	4581                	li	a1,0
    80002dac:	854a                	mv	a0,s2
    80002dae:	bd9ff0ef          	jal	80002986 <readi>
    80002db2:	03351163          	bne	a0,s3,80002dd4 <dirlink+0x60>
    if(de.inum == 0)
    80002db6:	fb045783          	lhu	a5,-80(s0)
    80002dba:	c39d                	beqz	a5,80002de0 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dbc:	24c1                	addiw	s1,s1,16
    80002dbe:	04c92783          	lw	a5,76(s2)
    80002dc2:	fef4e1e3          	bltu	s1,a5,80002da4 <dirlink+0x30>
    80002dc6:	79a2                	ld	s3,40(sp)
    80002dc8:	7a02                	ld	s4,32(sp)
    80002dca:	a829                	j	80002de4 <dirlink+0x70>
    iput(ip);
    80002dcc:	ae5ff0ef          	jal	800028b0 <iput>
    return -1;
    80002dd0:	557d                	li	a0,-1
    80002dd2:	a83d                	j	80002e10 <dirlink+0x9c>
      panic("dirlink read");
    80002dd4:	00004517          	auipc	a0,0x4
    80002dd8:	7dc50513          	addi	a0,a0,2012 # 800075b0 <etext+0x5b0>
    80002ddc:	73a020ef          	jal	80005516 <panic>
    80002de0:	79a2                	ld	s3,40(sp)
    80002de2:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002de4:	4639                	li	a2,14
    80002de6:	85d6                	mv	a1,s5
    80002de8:	fb240513          	addi	a0,s0,-78
    80002dec:	cb6fd0ef          	jal	800002a2 <strncpy>
  de.inum = inum;
    80002df0:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002df4:	4741                	li	a4,16
    80002df6:	86a6                	mv	a3,s1
    80002df8:	fb040613          	addi	a2,s0,-80
    80002dfc:	4581                	li	a1,0
    80002dfe:	854a                	mv	a0,s2
    80002e00:	c79ff0ef          	jal	80002a78 <writei>
    80002e04:	1541                	addi	a0,a0,-16
    80002e06:	00a03533          	snez	a0,a0
    80002e0a:	40a0053b          	negw	a0,a0
    80002e0e:	74e2                	ld	s1,56(sp)
}
    80002e10:	60a6                	ld	ra,72(sp)
    80002e12:	6406                	ld	s0,64(sp)
    80002e14:	7942                	ld	s2,48(sp)
    80002e16:	6ae2                	ld	s5,24(sp)
    80002e18:	6b42                	ld	s6,16(sp)
    80002e1a:	6161                	addi	sp,sp,80
    80002e1c:	8082                	ret

0000000080002e1e <namei>:

struct inode*
namei(char *path)
{
    80002e1e:	1101                	addi	sp,sp,-32
    80002e20:	ec06                	sd	ra,24(sp)
    80002e22:	e822                	sd	s0,16(sp)
    80002e24:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e26:	fe040613          	addi	a2,s0,-32
    80002e2a:	4581                	li	a1,0
    80002e2c:	e13ff0ef          	jal	80002c3e <namex>
}
    80002e30:	60e2                	ld	ra,24(sp)
    80002e32:	6442                	ld	s0,16(sp)
    80002e34:	6105                	addi	sp,sp,32
    80002e36:	8082                	ret

0000000080002e38 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e38:	1141                	addi	sp,sp,-16
    80002e3a:	e406                	sd	ra,8(sp)
    80002e3c:	e022                	sd	s0,0(sp)
    80002e3e:	0800                	addi	s0,sp,16
    80002e40:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e42:	4585                	li	a1,1
    80002e44:	dfbff0ef          	jal	80002c3e <namex>
}
    80002e48:	60a2                	ld	ra,8(sp)
    80002e4a:	6402                	ld	s0,0(sp)
    80002e4c:	0141                	addi	sp,sp,16
    80002e4e:	8082                	ret

0000000080002e50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	e426                	sd	s1,8(sp)
    80002e58:	e04a                	sd	s2,0(sp)
    80002e5a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e5c:	00018917          	auipc	s2,0x18
    80002e60:	88490913          	addi	s2,s2,-1916 # 8001a6e0 <log>
    80002e64:	01892583          	lw	a1,24(s2)
    80002e68:	02892503          	lw	a0,40(s2)
    80002e6c:	9b0ff0ef          	jal	8000201c <bread>
    80002e70:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e72:	02c92603          	lw	a2,44(s2)
    80002e76:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e78:	00c05f63          	blez	a2,80002e96 <write_head+0x46>
    80002e7c:	00018717          	auipc	a4,0x18
    80002e80:	89470713          	addi	a4,a4,-1900 # 8001a710 <log+0x30>
    80002e84:	87aa                	mv	a5,a0
    80002e86:	060a                	slli	a2,a2,0x2
    80002e88:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e8a:	4314                	lw	a3,0(a4)
    80002e8c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e8e:	0711                	addi	a4,a4,4
    80002e90:	0791                	addi	a5,a5,4
    80002e92:	fec79ce3          	bne	a5,a2,80002e8a <write_head+0x3a>
  }
  bwrite(buf);
    80002e96:	8526                	mv	a0,s1
    80002e98:	a5aff0ef          	jal	800020f2 <bwrite>
  brelse(buf);
    80002e9c:	8526                	mv	a0,s1
    80002e9e:	a86ff0ef          	jal	80002124 <brelse>
}
    80002ea2:	60e2                	ld	ra,24(sp)
    80002ea4:	6442                	ld	s0,16(sp)
    80002ea6:	64a2                	ld	s1,8(sp)
    80002ea8:	6902                	ld	s2,0(sp)
    80002eaa:	6105                	addi	sp,sp,32
    80002eac:	8082                	ret

0000000080002eae <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002eae:	00018797          	auipc	a5,0x18
    80002eb2:	85e7a783          	lw	a5,-1954(a5) # 8001a70c <log+0x2c>
    80002eb6:	0af05263          	blez	a5,80002f5a <install_trans+0xac>
{
    80002eba:	715d                	addi	sp,sp,-80
    80002ebc:	e486                	sd	ra,72(sp)
    80002ebe:	e0a2                	sd	s0,64(sp)
    80002ec0:	fc26                	sd	s1,56(sp)
    80002ec2:	f84a                	sd	s2,48(sp)
    80002ec4:	f44e                	sd	s3,40(sp)
    80002ec6:	f052                	sd	s4,32(sp)
    80002ec8:	ec56                	sd	s5,24(sp)
    80002eca:	e85a                	sd	s6,16(sp)
    80002ecc:	e45e                	sd	s7,8(sp)
    80002ece:	0880                	addi	s0,sp,80
    80002ed0:	8b2a                	mv	s6,a0
    80002ed2:	00018a97          	auipc	s5,0x18
    80002ed6:	83ea8a93          	addi	s5,s5,-1986 # 8001a710 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002eda:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002edc:	00018997          	auipc	s3,0x18
    80002ee0:	80498993          	addi	s3,s3,-2044 # 8001a6e0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002ee4:	40000b93          	li	s7,1024
    80002ee8:	a829                	j	80002f02 <install_trans+0x54>
    brelse(lbuf);
    80002eea:	854a                	mv	a0,s2
    80002eec:	a38ff0ef          	jal	80002124 <brelse>
    brelse(dbuf);
    80002ef0:	8526                	mv	a0,s1
    80002ef2:	a32ff0ef          	jal	80002124 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ef6:	2a05                	addiw	s4,s4,1
    80002ef8:	0a91                	addi	s5,s5,4
    80002efa:	02c9a783          	lw	a5,44(s3)
    80002efe:	04fa5363          	bge	s4,a5,80002f44 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f02:	0189a583          	lw	a1,24(s3)
    80002f06:	014585bb          	addw	a1,a1,s4
    80002f0a:	2585                	addiw	a1,a1,1
    80002f0c:	0289a503          	lw	a0,40(s3)
    80002f10:	90cff0ef          	jal	8000201c <bread>
    80002f14:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f16:	000aa583          	lw	a1,0(s5)
    80002f1a:	0289a503          	lw	a0,40(s3)
    80002f1e:	8feff0ef          	jal	8000201c <bread>
    80002f22:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f24:	865e                	mv	a2,s7
    80002f26:	05890593          	addi	a1,s2,88
    80002f2a:	05850513          	addi	a0,a0,88
    80002f2e:	ac6fd0ef          	jal	800001f4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f32:	8526                	mv	a0,s1
    80002f34:	9beff0ef          	jal	800020f2 <bwrite>
    if(recovering == 0)
    80002f38:	fa0b19e3          	bnez	s6,80002eea <install_trans+0x3c>
      bunpin(dbuf);
    80002f3c:	8526                	mv	a0,s1
    80002f3e:	a9eff0ef          	jal	800021dc <bunpin>
    80002f42:	b765                	j	80002eea <install_trans+0x3c>
}
    80002f44:	60a6                	ld	ra,72(sp)
    80002f46:	6406                	ld	s0,64(sp)
    80002f48:	74e2                	ld	s1,56(sp)
    80002f4a:	7942                	ld	s2,48(sp)
    80002f4c:	79a2                	ld	s3,40(sp)
    80002f4e:	7a02                	ld	s4,32(sp)
    80002f50:	6ae2                	ld	s5,24(sp)
    80002f52:	6b42                	ld	s6,16(sp)
    80002f54:	6ba2                	ld	s7,8(sp)
    80002f56:	6161                	addi	sp,sp,80
    80002f58:	8082                	ret
    80002f5a:	8082                	ret

0000000080002f5c <initlog>:
{
    80002f5c:	7179                	addi	sp,sp,-48
    80002f5e:	f406                	sd	ra,40(sp)
    80002f60:	f022                	sd	s0,32(sp)
    80002f62:	ec26                	sd	s1,24(sp)
    80002f64:	e84a                	sd	s2,16(sp)
    80002f66:	e44e                	sd	s3,8(sp)
    80002f68:	1800                	addi	s0,sp,48
    80002f6a:	892a                	mv	s2,a0
    80002f6c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f6e:	00017497          	auipc	s1,0x17
    80002f72:	77248493          	addi	s1,s1,1906 # 8001a6e0 <log>
    80002f76:	00004597          	auipc	a1,0x4
    80002f7a:	64a58593          	addi	a1,a1,1610 # 800075c0 <etext+0x5c0>
    80002f7e:	8526                	mv	a0,s1
    80002f80:	041020ef          	jal	800057c0 <initlock>
  log.start = sb->logstart;
    80002f84:	0149a583          	lw	a1,20(s3)
    80002f88:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f8a:	0109a783          	lw	a5,16(s3)
    80002f8e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f90:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f94:	854a                	mv	a0,s2
    80002f96:	886ff0ef          	jal	8000201c <bread>
  log.lh.n = lh->n;
    80002f9a:	4d30                	lw	a2,88(a0)
    80002f9c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f9e:	00c05f63          	blez	a2,80002fbc <initlog+0x60>
    80002fa2:	87aa                	mv	a5,a0
    80002fa4:	00017717          	auipc	a4,0x17
    80002fa8:	76c70713          	addi	a4,a4,1900 # 8001a710 <log+0x30>
    80002fac:	060a                	slli	a2,a2,0x2
    80002fae:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fb0:	4ff4                	lw	a3,92(a5)
    80002fb2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fb4:	0791                	addi	a5,a5,4
    80002fb6:	0711                	addi	a4,a4,4
    80002fb8:	fec79ce3          	bne	a5,a2,80002fb0 <initlog+0x54>
  brelse(buf);
    80002fbc:	968ff0ef          	jal	80002124 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fc0:	4505                	li	a0,1
    80002fc2:	eedff0ef          	jal	80002eae <install_trans>
  log.lh.n = 0;
    80002fc6:	00017797          	auipc	a5,0x17
    80002fca:	7407a323          	sw	zero,1862(a5) # 8001a70c <log+0x2c>
  write_head(); // clear the log
    80002fce:	e83ff0ef          	jal	80002e50 <write_head>
}
    80002fd2:	70a2                	ld	ra,40(sp)
    80002fd4:	7402                	ld	s0,32(sp)
    80002fd6:	64e2                	ld	s1,24(sp)
    80002fd8:	6942                	ld	s2,16(sp)
    80002fda:	69a2                	ld	s3,8(sp)
    80002fdc:	6145                	addi	sp,sp,48
    80002fde:	8082                	ret

0000000080002fe0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002fe0:	1101                	addi	sp,sp,-32
    80002fe2:	ec06                	sd	ra,24(sp)
    80002fe4:	e822                	sd	s0,16(sp)
    80002fe6:	e426                	sd	s1,8(sp)
    80002fe8:	e04a                	sd	s2,0(sp)
    80002fea:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002fec:	00017517          	auipc	a0,0x17
    80002ff0:	6f450513          	addi	a0,a0,1780 # 8001a6e0 <log>
    80002ff4:	051020ef          	jal	80005844 <acquire>
  while(1){
    if(log.committing){
    80002ff8:	00017497          	auipc	s1,0x17
    80002ffc:	6e848493          	addi	s1,s1,1768 # 8001a6e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003000:	4979                	li	s2,30
    80003002:	a029                	j	8000300c <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003004:	85a6                	mv	a1,s1
    80003006:	8526                	mv	a0,s1
    80003008:	ba4fe0ef          	jal	800013ac <sleep>
    if(log.committing){
    8000300c:	50dc                	lw	a5,36(s1)
    8000300e:	fbfd                	bnez	a5,80003004 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003010:	5098                	lw	a4,32(s1)
    80003012:	2705                	addiw	a4,a4,1
    80003014:	0027179b          	slliw	a5,a4,0x2
    80003018:	9fb9                	addw	a5,a5,a4
    8000301a:	0017979b          	slliw	a5,a5,0x1
    8000301e:	54d4                	lw	a3,44(s1)
    80003020:	9fb5                	addw	a5,a5,a3
    80003022:	00f95763          	bge	s2,a5,80003030 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003026:	85a6                	mv	a1,s1
    80003028:	8526                	mv	a0,s1
    8000302a:	b82fe0ef          	jal	800013ac <sleep>
    8000302e:	bff9                	j	8000300c <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003030:	00017517          	auipc	a0,0x17
    80003034:	6b050513          	addi	a0,a0,1712 # 8001a6e0 <log>
    80003038:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000303a:	09f020ef          	jal	800058d8 <release>
      break;
    }
  }
}
    8000303e:	60e2                	ld	ra,24(sp)
    80003040:	6442                	ld	s0,16(sp)
    80003042:	64a2                	ld	s1,8(sp)
    80003044:	6902                	ld	s2,0(sp)
    80003046:	6105                	addi	sp,sp,32
    80003048:	8082                	ret

000000008000304a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000304a:	7139                	addi	sp,sp,-64
    8000304c:	fc06                	sd	ra,56(sp)
    8000304e:	f822                	sd	s0,48(sp)
    80003050:	f426                	sd	s1,40(sp)
    80003052:	f04a                	sd	s2,32(sp)
    80003054:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003056:	00017497          	auipc	s1,0x17
    8000305a:	68a48493          	addi	s1,s1,1674 # 8001a6e0 <log>
    8000305e:	8526                	mv	a0,s1
    80003060:	7e4020ef          	jal	80005844 <acquire>
  log.outstanding -= 1;
    80003064:	509c                	lw	a5,32(s1)
    80003066:	37fd                	addiw	a5,a5,-1
    80003068:	893e                	mv	s2,a5
    8000306a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000306c:	50dc                	lw	a5,36(s1)
    8000306e:	ef9d                	bnez	a5,800030ac <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003070:	04091863          	bnez	s2,800030c0 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003074:	00017497          	auipc	s1,0x17
    80003078:	66c48493          	addi	s1,s1,1644 # 8001a6e0 <log>
    8000307c:	4785                	li	a5,1
    8000307e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003080:	8526                	mv	a0,s1
    80003082:	057020ef          	jal	800058d8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003086:	54dc                	lw	a5,44(s1)
    80003088:	04f04c63          	bgtz	a5,800030e0 <end_op+0x96>
    acquire(&log.lock);
    8000308c:	00017497          	auipc	s1,0x17
    80003090:	65448493          	addi	s1,s1,1620 # 8001a6e0 <log>
    80003094:	8526                	mv	a0,s1
    80003096:	7ae020ef          	jal	80005844 <acquire>
    log.committing = 0;
    8000309a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000309e:	8526                	mv	a0,s1
    800030a0:	b58fe0ef          	jal	800013f8 <wakeup>
    release(&log.lock);
    800030a4:	8526                	mv	a0,s1
    800030a6:	033020ef          	jal	800058d8 <release>
}
    800030aa:	a02d                	j	800030d4 <end_op+0x8a>
    800030ac:	ec4e                	sd	s3,24(sp)
    800030ae:	e852                	sd	s4,16(sp)
    800030b0:	e456                	sd	s5,8(sp)
    800030b2:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800030b4:	00004517          	auipc	a0,0x4
    800030b8:	51450513          	addi	a0,a0,1300 # 800075c8 <etext+0x5c8>
    800030bc:	45a020ef          	jal	80005516 <panic>
    wakeup(&log);
    800030c0:	00017497          	auipc	s1,0x17
    800030c4:	62048493          	addi	s1,s1,1568 # 8001a6e0 <log>
    800030c8:	8526                	mv	a0,s1
    800030ca:	b2efe0ef          	jal	800013f8 <wakeup>
  release(&log.lock);
    800030ce:	8526                	mv	a0,s1
    800030d0:	009020ef          	jal	800058d8 <release>
}
    800030d4:	70e2                	ld	ra,56(sp)
    800030d6:	7442                	ld	s0,48(sp)
    800030d8:	74a2                	ld	s1,40(sp)
    800030da:	7902                	ld	s2,32(sp)
    800030dc:	6121                	addi	sp,sp,64
    800030de:	8082                	ret
    800030e0:	ec4e                	sd	s3,24(sp)
    800030e2:	e852                	sd	s4,16(sp)
    800030e4:	e456                	sd	s5,8(sp)
    800030e6:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800030e8:	00017a97          	auipc	s5,0x17
    800030ec:	628a8a93          	addi	s5,s5,1576 # 8001a710 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030f0:	00017a17          	auipc	s4,0x17
    800030f4:	5f0a0a13          	addi	s4,s4,1520 # 8001a6e0 <log>
    memmove(to->data, from->data, BSIZE);
    800030f8:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030fc:	018a2583          	lw	a1,24(s4)
    80003100:	012585bb          	addw	a1,a1,s2
    80003104:	2585                	addiw	a1,a1,1
    80003106:	028a2503          	lw	a0,40(s4)
    8000310a:	f13fe0ef          	jal	8000201c <bread>
    8000310e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003110:	000aa583          	lw	a1,0(s5)
    80003114:	028a2503          	lw	a0,40(s4)
    80003118:	f05fe0ef          	jal	8000201c <bread>
    8000311c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000311e:	865a                	mv	a2,s6
    80003120:	05850593          	addi	a1,a0,88
    80003124:	05848513          	addi	a0,s1,88
    80003128:	8ccfd0ef          	jal	800001f4 <memmove>
    bwrite(to);  // write the log
    8000312c:	8526                	mv	a0,s1
    8000312e:	fc5fe0ef          	jal	800020f2 <bwrite>
    brelse(from);
    80003132:	854e                	mv	a0,s3
    80003134:	ff1fe0ef          	jal	80002124 <brelse>
    brelse(to);
    80003138:	8526                	mv	a0,s1
    8000313a:	febfe0ef          	jal	80002124 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000313e:	2905                	addiw	s2,s2,1
    80003140:	0a91                	addi	s5,s5,4
    80003142:	02ca2783          	lw	a5,44(s4)
    80003146:	faf94be3          	blt	s2,a5,800030fc <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000314a:	d07ff0ef          	jal	80002e50 <write_head>
    install_trans(0); // Now install writes to home locations
    8000314e:	4501                	li	a0,0
    80003150:	d5fff0ef          	jal	80002eae <install_trans>
    log.lh.n = 0;
    80003154:	00017797          	auipc	a5,0x17
    80003158:	5a07ac23          	sw	zero,1464(a5) # 8001a70c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000315c:	cf5ff0ef          	jal	80002e50 <write_head>
    80003160:	69e2                	ld	s3,24(sp)
    80003162:	6a42                	ld	s4,16(sp)
    80003164:	6aa2                	ld	s5,8(sp)
    80003166:	6b02                	ld	s6,0(sp)
    80003168:	b715                	j	8000308c <end_op+0x42>

000000008000316a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	e04a                	sd	s2,0(sp)
    80003174:	1000                	addi	s0,sp,32
    80003176:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003178:	00017917          	auipc	s2,0x17
    8000317c:	56890913          	addi	s2,s2,1384 # 8001a6e0 <log>
    80003180:	854a                	mv	a0,s2
    80003182:	6c2020ef          	jal	80005844 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003186:	02c92603          	lw	a2,44(s2)
    8000318a:	47f5                	li	a5,29
    8000318c:	06c7c363          	blt	a5,a2,800031f2 <log_write+0x88>
    80003190:	00017797          	auipc	a5,0x17
    80003194:	56c7a783          	lw	a5,1388(a5) # 8001a6fc <log+0x1c>
    80003198:	37fd                	addiw	a5,a5,-1
    8000319a:	04f65c63          	bge	a2,a5,800031f2 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000319e:	00017797          	auipc	a5,0x17
    800031a2:	5627a783          	lw	a5,1378(a5) # 8001a700 <log+0x20>
    800031a6:	04f05c63          	blez	a5,800031fe <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031aa:	4781                	li	a5,0
    800031ac:	04c05f63          	blez	a2,8000320a <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031b0:	44cc                	lw	a1,12(s1)
    800031b2:	00017717          	auipc	a4,0x17
    800031b6:	55e70713          	addi	a4,a4,1374 # 8001a710 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031bc:	4314                	lw	a3,0(a4)
    800031be:	04b68663          	beq	a3,a1,8000320a <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031c2:	2785                	addiw	a5,a5,1
    800031c4:	0711                	addi	a4,a4,4
    800031c6:	fef61be3          	bne	a2,a5,800031bc <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031ca:	0621                	addi	a2,a2,8
    800031cc:	060a                	slli	a2,a2,0x2
    800031ce:	00017797          	auipc	a5,0x17
    800031d2:	51278793          	addi	a5,a5,1298 # 8001a6e0 <log>
    800031d6:	97b2                	add	a5,a5,a2
    800031d8:	44d8                	lw	a4,12(s1)
    800031da:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031dc:	8526                	mv	a0,s1
    800031de:	fcbfe0ef          	jal	800021a8 <bpin>
    log.lh.n++;
    800031e2:	00017717          	auipc	a4,0x17
    800031e6:	4fe70713          	addi	a4,a4,1278 # 8001a6e0 <log>
    800031ea:	575c                	lw	a5,44(a4)
    800031ec:	2785                	addiw	a5,a5,1
    800031ee:	d75c                	sw	a5,44(a4)
    800031f0:	a80d                	j	80003222 <log_write+0xb8>
    panic("too big a transaction");
    800031f2:	00004517          	auipc	a0,0x4
    800031f6:	3e650513          	addi	a0,a0,998 # 800075d8 <etext+0x5d8>
    800031fa:	31c020ef          	jal	80005516 <panic>
    panic("log_write outside of trans");
    800031fe:	00004517          	auipc	a0,0x4
    80003202:	3f250513          	addi	a0,a0,1010 # 800075f0 <etext+0x5f0>
    80003206:	310020ef          	jal	80005516 <panic>
  log.lh.block[i] = b->blockno;
    8000320a:	00878693          	addi	a3,a5,8
    8000320e:	068a                	slli	a3,a3,0x2
    80003210:	00017717          	auipc	a4,0x17
    80003214:	4d070713          	addi	a4,a4,1232 # 8001a6e0 <log>
    80003218:	9736                	add	a4,a4,a3
    8000321a:	44d4                	lw	a3,12(s1)
    8000321c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000321e:	faf60fe3          	beq	a2,a5,800031dc <log_write+0x72>
  }
  release(&log.lock);
    80003222:	00017517          	auipc	a0,0x17
    80003226:	4be50513          	addi	a0,a0,1214 # 8001a6e0 <log>
    8000322a:	6ae020ef          	jal	800058d8 <release>
}
    8000322e:	60e2                	ld	ra,24(sp)
    80003230:	6442                	ld	s0,16(sp)
    80003232:	64a2                	ld	s1,8(sp)
    80003234:	6902                	ld	s2,0(sp)
    80003236:	6105                	addi	sp,sp,32
    80003238:	8082                	ret

000000008000323a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000323a:	1101                	addi	sp,sp,-32
    8000323c:	ec06                	sd	ra,24(sp)
    8000323e:	e822                	sd	s0,16(sp)
    80003240:	e426                	sd	s1,8(sp)
    80003242:	e04a                	sd	s2,0(sp)
    80003244:	1000                	addi	s0,sp,32
    80003246:	84aa                	mv	s1,a0
    80003248:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000324a:	00004597          	auipc	a1,0x4
    8000324e:	3c658593          	addi	a1,a1,966 # 80007610 <etext+0x610>
    80003252:	0521                	addi	a0,a0,8
    80003254:	56c020ef          	jal	800057c0 <initlock>
  lk->name = name;
    80003258:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000325c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003260:	0204a423          	sw	zero,40(s1)
}
    80003264:	60e2                	ld	ra,24(sp)
    80003266:	6442                	ld	s0,16(sp)
    80003268:	64a2                	ld	s1,8(sp)
    8000326a:	6902                	ld	s2,0(sp)
    8000326c:	6105                	addi	sp,sp,32
    8000326e:	8082                	ret

0000000080003270 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003270:	1101                	addi	sp,sp,-32
    80003272:	ec06                	sd	ra,24(sp)
    80003274:	e822                	sd	s0,16(sp)
    80003276:	e426                	sd	s1,8(sp)
    80003278:	e04a                	sd	s2,0(sp)
    8000327a:	1000                	addi	s0,sp,32
    8000327c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000327e:	00850913          	addi	s2,a0,8
    80003282:	854a                	mv	a0,s2
    80003284:	5c0020ef          	jal	80005844 <acquire>
  while (lk->locked) {
    80003288:	409c                	lw	a5,0(s1)
    8000328a:	c799                	beqz	a5,80003298 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000328c:	85ca                	mv	a1,s2
    8000328e:	8526                	mv	a0,s1
    80003290:	91cfe0ef          	jal	800013ac <sleep>
  while (lk->locked) {
    80003294:	409c                	lw	a5,0(s1)
    80003296:	fbfd                	bnez	a5,8000328c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003298:	4785                	li	a5,1
    8000329a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000329c:	b37fd0ef          	jal	80000dd2 <myproc>
    800032a0:	591c                	lw	a5,48(a0)
    800032a2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032a4:	854a                	mv	a0,s2
    800032a6:	632020ef          	jal	800058d8 <release>
}
    800032aa:	60e2                	ld	ra,24(sp)
    800032ac:	6442                	ld	s0,16(sp)
    800032ae:	64a2                	ld	s1,8(sp)
    800032b0:	6902                	ld	s2,0(sp)
    800032b2:	6105                	addi	sp,sp,32
    800032b4:	8082                	ret

00000000800032b6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032b6:	1101                	addi	sp,sp,-32
    800032b8:	ec06                	sd	ra,24(sp)
    800032ba:	e822                	sd	s0,16(sp)
    800032bc:	e426                	sd	s1,8(sp)
    800032be:	e04a                	sd	s2,0(sp)
    800032c0:	1000                	addi	s0,sp,32
    800032c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032c4:	00850913          	addi	s2,a0,8
    800032c8:	854a                	mv	a0,s2
    800032ca:	57a020ef          	jal	80005844 <acquire>
  lk->locked = 0;
    800032ce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032d2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032d6:	8526                	mv	a0,s1
    800032d8:	920fe0ef          	jal	800013f8 <wakeup>
  release(&lk->lk);
    800032dc:	854a                	mv	a0,s2
    800032de:	5fa020ef          	jal	800058d8 <release>
}
    800032e2:	60e2                	ld	ra,24(sp)
    800032e4:	6442                	ld	s0,16(sp)
    800032e6:	64a2                	ld	s1,8(sp)
    800032e8:	6902                	ld	s2,0(sp)
    800032ea:	6105                	addi	sp,sp,32
    800032ec:	8082                	ret

00000000800032ee <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032ee:	7179                	addi	sp,sp,-48
    800032f0:	f406                	sd	ra,40(sp)
    800032f2:	f022                	sd	s0,32(sp)
    800032f4:	ec26                	sd	s1,24(sp)
    800032f6:	e84a                	sd	s2,16(sp)
    800032f8:	1800                	addi	s0,sp,48
    800032fa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800032fc:	00850913          	addi	s2,a0,8
    80003300:	854a                	mv	a0,s2
    80003302:	542020ef          	jal	80005844 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003306:	409c                	lw	a5,0(s1)
    80003308:	ef81                	bnez	a5,80003320 <holdingsleep+0x32>
    8000330a:	4481                	li	s1,0
  release(&lk->lk);
    8000330c:	854a                	mv	a0,s2
    8000330e:	5ca020ef          	jal	800058d8 <release>
  return r;
}
    80003312:	8526                	mv	a0,s1
    80003314:	70a2                	ld	ra,40(sp)
    80003316:	7402                	ld	s0,32(sp)
    80003318:	64e2                	ld	s1,24(sp)
    8000331a:	6942                	ld	s2,16(sp)
    8000331c:	6145                	addi	sp,sp,48
    8000331e:	8082                	ret
    80003320:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003322:	0284a983          	lw	s3,40(s1)
    80003326:	aadfd0ef          	jal	80000dd2 <myproc>
    8000332a:	5904                	lw	s1,48(a0)
    8000332c:	413484b3          	sub	s1,s1,s3
    80003330:	0014b493          	seqz	s1,s1
    80003334:	69a2                	ld	s3,8(sp)
    80003336:	bfd9                	j	8000330c <holdingsleep+0x1e>

0000000080003338 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003338:	1141                	addi	sp,sp,-16
    8000333a:	e406                	sd	ra,8(sp)
    8000333c:	e022                	sd	s0,0(sp)
    8000333e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003340:	00004597          	auipc	a1,0x4
    80003344:	2e058593          	addi	a1,a1,736 # 80007620 <etext+0x620>
    80003348:	00017517          	auipc	a0,0x17
    8000334c:	4e050513          	addi	a0,a0,1248 # 8001a828 <ftable>
    80003350:	470020ef          	jal	800057c0 <initlock>
}
    80003354:	60a2                	ld	ra,8(sp)
    80003356:	6402                	ld	s0,0(sp)
    80003358:	0141                	addi	sp,sp,16
    8000335a:	8082                	ret

000000008000335c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000335c:	1101                	addi	sp,sp,-32
    8000335e:	ec06                	sd	ra,24(sp)
    80003360:	e822                	sd	s0,16(sp)
    80003362:	e426                	sd	s1,8(sp)
    80003364:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003366:	00017517          	auipc	a0,0x17
    8000336a:	4c250513          	addi	a0,a0,1218 # 8001a828 <ftable>
    8000336e:	4d6020ef          	jal	80005844 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003372:	00017497          	auipc	s1,0x17
    80003376:	4ce48493          	addi	s1,s1,1230 # 8001a840 <ftable+0x18>
    8000337a:	00018717          	auipc	a4,0x18
    8000337e:	46670713          	addi	a4,a4,1126 # 8001b7e0 <disk>
    if(f->ref == 0){
    80003382:	40dc                	lw	a5,4(s1)
    80003384:	cf89                	beqz	a5,8000339e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003386:	02848493          	addi	s1,s1,40
    8000338a:	fee49ce3          	bne	s1,a4,80003382 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000338e:	00017517          	auipc	a0,0x17
    80003392:	49a50513          	addi	a0,a0,1178 # 8001a828 <ftable>
    80003396:	542020ef          	jal	800058d8 <release>
  return 0;
    8000339a:	4481                	li	s1,0
    8000339c:	a809                	j	800033ae <filealloc+0x52>
      f->ref = 1;
    8000339e:	4785                	li	a5,1
    800033a0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033a2:	00017517          	auipc	a0,0x17
    800033a6:	48650513          	addi	a0,a0,1158 # 8001a828 <ftable>
    800033aa:	52e020ef          	jal	800058d8 <release>
}
    800033ae:	8526                	mv	a0,s1
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6105                	addi	sp,sp,32
    800033b8:	8082                	ret

00000000800033ba <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033ba:	1101                	addi	sp,sp,-32
    800033bc:	ec06                	sd	ra,24(sp)
    800033be:	e822                	sd	s0,16(sp)
    800033c0:	e426                	sd	s1,8(sp)
    800033c2:	1000                	addi	s0,sp,32
    800033c4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033c6:	00017517          	auipc	a0,0x17
    800033ca:	46250513          	addi	a0,a0,1122 # 8001a828 <ftable>
    800033ce:	476020ef          	jal	80005844 <acquire>
  if(f->ref < 1)
    800033d2:	40dc                	lw	a5,4(s1)
    800033d4:	02f05063          	blez	a5,800033f4 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033d8:	2785                	addiw	a5,a5,1
    800033da:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033dc:	00017517          	auipc	a0,0x17
    800033e0:	44c50513          	addi	a0,a0,1100 # 8001a828 <ftable>
    800033e4:	4f4020ef          	jal	800058d8 <release>
  return f;
}
    800033e8:	8526                	mv	a0,s1
    800033ea:	60e2                	ld	ra,24(sp)
    800033ec:	6442                	ld	s0,16(sp)
    800033ee:	64a2                	ld	s1,8(sp)
    800033f0:	6105                	addi	sp,sp,32
    800033f2:	8082                	ret
    panic("filedup");
    800033f4:	00004517          	auipc	a0,0x4
    800033f8:	23450513          	addi	a0,a0,564 # 80007628 <etext+0x628>
    800033fc:	11a020ef          	jal	80005516 <panic>

0000000080003400 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003400:	7139                	addi	sp,sp,-64
    80003402:	fc06                	sd	ra,56(sp)
    80003404:	f822                	sd	s0,48(sp)
    80003406:	f426                	sd	s1,40(sp)
    80003408:	0080                	addi	s0,sp,64
    8000340a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000340c:	00017517          	auipc	a0,0x17
    80003410:	41c50513          	addi	a0,a0,1052 # 8001a828 <ftable>
    80003414:	430020ef          	jal	80005844 <acquire>
  if(f->ref < 1)
    80003418:	40dc                	lw	a5,4(s1)
    8000341a:	04f05863          	blez	a5,8000346a <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    8000341e:	37fd                	addiw	a5,a5,-1
    80003420:	c0dc                	sw	a5,4(s1)
    80003422:	04f04e63          	bgtz	a5,8000347e <fileclose+0x7e>
    80003426:	f04a                	sd	s2,32(sp)
    80003428:	ec4e                	sd	s3,24(sp)
    8000342a:	e852                	sd	s4,16(sp)
    8000342c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000342e:	0004a903          	lw	s2,0(s1)
    80003432:	0094ca83          	lbu	s5,9(s1)
    80003436:	0104ba03          	ld	s4,16(s1)
    8000343a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000343e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003442:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003446:	00017517          	auipc	a0,0x17
    8000344a:	3e250513          	addi	a0,a0,994 # 8001a828 <ftable>
    8000344e:	48a020ef          	jal	800058d8 <release>

  if(ff.type == FD_PIPE){
    80003452:	4785                	li	a5,1
    80003454:	04f90063          	beq	s2,a5,80003494 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003458:	3979                	addiw	s2,s2,-2
    8000345a:	4785                	li	a5,1
    8000345c:	0527f563          	bgeu	a5,s2,800034a6 <fileclose+0xa6>
    80003460:	7902                	ld	s2,32(sp)
    80003462:	69e2                	ld	s3,24(sp)
    80003464:	6a42                	ld	s4,16(sp)
    80003466:	6aa2                	ld	s5,8(sp)
    80003468:	a00d                	j	8000348a <fileclose+0x8a>
    8000346a:	f04a                	sd	s2,32(sp)
    8000346c:	ec4e                	sd	s3,24(sp)
    8000346e:	e852                	sd	s4,16(sp)
    80003470:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003472:	00004517          	auipc	a0,0x4
    80003476:	1be50513          	addi	a0,a0,446 # 80007630 <etext+0x630>
    8000347a:	09c020ef          	jal	80005516 <panic>
    release(&ftable.lock);
    8000347e:	00017517          	auipc	a0,0x17
    80003482:	3aa50513          	addi	a0,a0,938 # 8001a828 <ftable>
    80003486:	452020ef          	jal	800058d8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000348a:	70e2                	ld	ra,56(sp)
    8000348c:	7442                	ld	s0,48(sp)
    8000348e:	74a2                	ld	s1,40(sp)
    80003490:	6121                	addi	sp,sp,64
    80003492:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003494:	85d6                	mv	a1,s5
    80003496:	8552                	mv	a0,s4
    80003498:	340000ef          	jal	800037d8 <pipeclose>
    8000349c:	7902                	ld	s2,32(sp)
    8000349e:	69e2                	ld	s3,24(sp)
    800034a0:	6a42                	ld	s4,16(sp)
    800034a2:	6aa2                	ld	s5,8(sp)
    800034a4:	b7dd                	j	8000348a <fileclose+0x8a>
    begin_op();
    800034a6:	b3bff0ef          	jal	80002fe0 <begin_op>
    iput(ff.ip);
    800034aa:	854e                	mv	a0,s3
    800034ac:	c04ff0ef          	jal	800028b0 <iput>
    end_op();
    800034b0:	b9bff0ef          	jal	8000304a <end_op>
    800034b4:	7902                	ld	s2,32(sp)
    800034b6:	69e2                	ld	s3,24(sp)
    800034b8:	6a42                	ld	s4,16(sp)
    800034ba:	6aa2                	ld	s5,8(sp)
    800034bc:	b7f9                	j	8000348a <fileclose+0x8a>

00000000800034be <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034be:	715d                	addi	sp,sp,-80
    800034c0:	e486                	sd	ra,72(sp)
    800034c2:	e0a2                	sd	s0,64(sp)
    800034c4:	fc26                	sd	s1,56(sp)
    800034c6:	f44e                	sd	s3,40(sp)
    800034c8:	0880                	addi	s0,sp,80
    800034ca:	84aa                	mv	s1,a0
    800034cc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034ce:	905fd0ef          	jal	80000dd2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034d2:	409c                	lw	a5,0(s1)
    800034d4:	37f9                	addiw	a5,a5,-2
    800034d6:	4705                	li	a4,1
    800034d8:	04f76263          	bltu	a4,a5,8000351c <filestat+0x5e>
    800034dc:	f84a                	sd	s2,48(sp)
    800034de:	f052                	sd	s4,32(sp)
    800034e0:	892a                	mv	s2,a0
    ilock(f->ip);
    800034e2:	6c88                	ld	a0,24(s1)
    800034e4:	a4aff0ef          	jal	8000272e <ilock>
    stati(f->ip, &st);
    800034e8:	fb840a13          	addi	s4,s0,-72
    800034ec:	85d2                	mv	a1,s4
    800034ee:	6c88                	ld	a0,24(s1)
    800034f0:	c68ff0ef          	jal	80002958 <stati>
    iunlock(f->ip);
    800034f4:	6c88                	ld	a0,24(s1)
    800034f6:	ae6ff0ef          	jal	800027dc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800034fa:	46e1                	li	a3,24
    800034fc:	8652                	mv	a2,s4
    800034fe:	85ce                	mv	a1,s3
    80003500:	05093503          	ld	a0,80(s2)
    80003504:	d42fd0ef          	jal	80000a46 <copyout>
    80003508:	41f5551b          	sraiw	a0,a0,0x1f
    8000350c:	7942                	ld	s2,48(sp)
    8000350e:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003510:	60a6                	ld	ra,72(sp)
    80003512:	6406                	ld	s0,64(sp)
    80003514:	74e2                	ld	s1,56(sp)
    80003516:	79a2                	ld	s3,40(sp)
    80003518:	6161                	addi	sp,sp,80
    8000351a:	8082                	ret
  return -1;
    8000351c:	557d                	li	a0,-1
    8000351e:	bfcd                	j	80003510 <filestat+0x52>

0000000080003520 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003520:	7179                	addi	sp,sp,-48
    80003522:	f406                	sd	ra,40(sp)
    80003524:	f022                	sd	s0,32(sp)
    80003526:	e84a                	sd	s2,16(sp)
    80003528:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000352a:	00854783          	lbu	a5,8(a0)
    8000352e:	cfd1                	beqz	a5,800035ca <fileread+0xaa>
    80003530:	ec26                	sd	s1,24(sp)
    80003532:	e44e                	sd	s3,8(sp)
    80003534:	84aa                	mv	s1,a0
    80003536:	89ae                	mv	s3,a1
    80003538:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000353a:	411c                	lw	a5,0(a0)
    8000353c:	4705                	li	a4,1
    8000353e:	04e78363          	beq	a5,a4,80003584 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003542:	470d                	li	a4,3
    80003544:	04e78763          	beq	a5,a4,80003592 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003548:	4709                	li	a4,2
    8000354a:	06e79a63          	bne	a5,a4,800035be <fileread+0x9e>
    ilock(f->ip);
    8000354e:	6d08                	ld	a0,24(a0)
    80003550:	9deff0ef          	jal	8000272e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003554:	874a                	mv	a4,s2
    80003556:	5094                	lw	a3,32(s1)
    80003558:	864e                	mv	a2,s3
    8000355a:	4585                	li	a1,1
    8000355c:	6c88                	ld	a0,24(s1)
    8000355e:	c28ff0ef          	jal	80002986 <readi>
    80003562:	892a                	mv	s2,a0
    80003564:	00a05563          	blez	a0,8000356e <fileread+0x4e>
      f->off += r;
    80003568:	509c                	lw	a5,32(s1)
    8000356a:	9fa9                	addw	a5,a5,a0
    8000356c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000356e:	6c88                	ld	a0,24(s1)
    80003570:	a6cff0ef          	jal	800027dc <iunlock>
    80003574:	64e2                	ld	s1,24(sp)
    80003576:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003578:	854a                	mv	a0,s2
    8000357a:	70a2                	ld	ra,40(sp)
    8000357c:	7402                	ld	s0,32(sp)
    8000357e:	6942                	ld	s2,16(sp)
    80003580:	6145                	addi	sp,sp,48
    80003582:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003584:	6908                	ld	a0,16(a0)
    80003586:	3a2000ef          	jal	80003928 <piperead>
    8000358a:	892a                	mv	s2,a0
    8000358c:	64e2                	ld	s1,24(sp)
    8000358e:	69a2                	ld	s3,8(sp)
    80003590:	b7e5                	j	80003578 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003592:	02451783          	lh	a5,36(a0)
    80003596:	03079693          	slli	a3,a5,0x30
    8000359a:	92c1                	srli	a3,a3,0x30
    8000359c:	4725                	li	a4,9
    8000359e:	02d76863          	bltu	a4,a3,800035ce <fileread+0xae>
    800035a2:	0792                	slli	a5,a5,0x4
    800035a4:	00017717          	auipc	a4,0x17
    800035a8:	1e470713          	addi	a4,a4,484 # 8001a788 <devsw>
    800035ac:	97ba                	add	a5,a5,a4
    800035ae:	639c                	ld	a5,0(a5)
    800035b0:	c39d                	beqz	a5,800035d6 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035b2:	4505                	li	a0,1
    800035b4:	9782                	jalr	a5
    800035b6:	892a                	mv	s2,a0
    800035b8:	64e2                	ld	s1,24(sp)
    800035ba:	69a2                	ld	s3,8(sp)
    800035bc:	bf75                	j	80003578 <fileread+0x58>
    panic("fileread");
    800035be:	00004517          	auipc	a0,0x4
    800035c2:	08250513          	addi	a0,a0,130 # 80007640 <etext+0x640>
    800035c6:	751010ef          	jal	80005516 <panic>
    return -1;
    800035ca:	597d                	li	s2,-1
    800035cc:	b775                	j	80003578 <fileread+0x58>
      return -1;
    800035ce:	597d                	li	s2,-1
    800035d0:	64e2                	ld	s1,24(sp)
    800035d2:	69a2                	ld	s3,8(sp)
    800035d4:	b755                	j	80003578 <fileread+0x58>
    800035d6:	597d                	li	s2,-1
    800035d8:	64e2                	ld	s1,24(sp)
    800035da:	69a2                	ld	s3,8(sp)
    800035dc:	bf71                	j	80003578 <fileread+0x58>

00000000800035de <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035de:	00954783          	lbu	a5,9(a0)
    800035e2:	10078e63          	beqz	a5,800036fe <filewrite+0x120>
{
    800035e6:	711d                	addi	sp,sp,-96
    800035e8:	ec86                	sd	ra,88(sp)
    800035ea:	e8a2                	sd	s0,80(sp)
    800035ec:	e0ca                	sd	s2,64(sp)
    800035ee:	f456                	sd	s5,40(sp)
    800035f0:	f05a                	sd	s6,32(sp)
    800035f2:	1080                	addi	s0,sp,96
    800035f4:	892a                	mv	s2,a0
    800035f6:	8b2e                	mv	s6,a1
    800035f8:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800035fa:	411c                	lw	a5,0(a0)
    800035fc:	4705                	li	a4,1
    800035fe:	02e78963          	beq	a5,a4,80003630 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003602:	470d                	li	a4,3
    80003604:	02e78a63          	beq	a5,a4,80003638 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003608:	4709                	li	a4,2
    8000360a:	0ce79e63          	bne	a5,a4,800036e6 <filewrite+0x108>
    8000360e:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003610:	0ac05963          	blez	a2,800036c2 <filewrite+0xe4>
    80003614:	e4a6                	sd	s1,72(sp)
    80003616:	fc4e                	sd	s3,56(sp)
    80003618:	ec5e                	sd	s7,24(sp)
    8000361a:	e862                	sd	s8,16(sp)
    8000361c:	e466                	sd	s9,8(sp)
    int i = 0;
    8000361e:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003620:	6b85                	lui	s7,0x1
    80003622:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003626:	6c85                	lui	s9,0x1
    80003628:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000362c:	4c05                	li	s8,1
    8000362e:	a8ad                	j	800036a8 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003630:	6908                	ld	a0,16(a0)
    80003632:	1fe000ef          	jal	80003830 <pipewrite>
    80003636:	a04d                	j	800036d8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003638:	02451783          	lh	a5,36(a0)
    8000363c:	03079693          	slli	a3,a5,0x30
    80003640:	92c1                	srli	a3,a3,0x30
    80003642:	4725                	li	a4,9
    80003644:	0ad76f63          	bltu	a4,a3,80003702 <filewrite+0x124>
    80003648:	0792                	slli	a5,a5,0x4
    8000364a:	00017717          	auipc	a4,0x17
    8000364e:	13e70713          	addi	a4,a4,318 # 8001a788 <devsw>
    80003652:	97ba                	add	a5,a5,a4
    80003654:	679c                	ld	a5,8(a5)
    80003656:	cbc5                	beqz	a5,80003706 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003658:	4505                	li	a0,1
    8000365a:	9782                	jalr	a5
    8000365c:	a8b5                	j	800036d8 <filewrite+0xfa>
      if(n1 > max)
    8000365e:	2981                	sext.w	s3,s3
      begin_op();
    80003660:	981ff0ef          	jal	80002fe0 <begin_op>
      ilock(f->ip);
    80003664:	01893503          	ld	a0,24(s2)
    80003668:	8c6ff0ef          	jal	8000272e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000366c:	874e                	mv	a4,s3
    8000366e:	02092683          	lw	a3,32(s2)
    80003672:	016a0633          	add	a2,s4,s6
    80003676:	85e2                	mv	a1,s8
    80003678:	01893503          	ld	a0,24(s2)
    8000367c:	bfcff0ef          	jal	80002a78 <writei>
    80003680:	84aa                	mv	s1,a0
    80003682:	00a05763          	blez	a0,80003690 <filewrite+0xb2>
        f->off += r;
    80003686:	02092783          	lw	a5,32(s2)
    8000368a:	9fa9                	addw	a5,a5,a0
    8000368c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003690:	01893503          	ld	a0,24(s2)
    80003694:	948ff0ef          	jal	800027dc <iunlock>
      end_op();
    80003698:	9b3ff0ef          	jal	8000304a <end_op>

      if(r != n1){
    8000369c:	02999563          	bne	s3,s1,800036c6 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    800036a0:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800036a4:	015a5963          	bge	s4,s5,800036b6 <filewrite+0xd8>
      int n1 = n - i;
    800036a8:	414a87bb          	subw	a5,s5,s4
    800036ac:	89be                	mv	s3,a5
      if(n1 > max)
    800036ae:	fafbd8e3          	bge	s7,a5,8000365e <filewrite+0x80>
    800036b2:	89e6                	mv	s3,s9
    800036b4:	b76d                	j	8000365e <filewrite+0x80>
    800036b6:	64a6                	ld	s1,72(sp)
    800036b8:	79e2                	ld	s3,56(sp)
    800036ba:	6be2                	ld	s7,24(sp)
    800036bc:	6c42                	ld	s8,16(sp)
    800036be:	6ca2                	ld	s9,8(sp)
    800036c0:	a801                	j	800036d0 <filewrite+0xf2>
    int i = 0;
    800036c2:	4a01                	li	s4,0
    800036c4:	a031                	j	800036d0 <filewrite+0xf2>
    800036c6:	64a6                	ld	s1,72(sp)
    800036c8:	79e2                	ld	s3,56(sp)
    800036ca:	6be2                	ld	s7,24(sp)
    800036cc:	6c42                	ld	s8,16(sp)
    800036ce:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800036d0:	034a9d63          	bne	s5,s4,8000370a <filewrite+0x12c>
    800036d4:	8556                	mv	a0,s5
    800036d6:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036d8:	60e6                	ld	ra,88(sp)
    800036da:	6446                	ld	s0,80(sp)
    800036dc:	6906                	ld	s2,64(sp)
    800036de:	7aa2                	ld	s5,40(sp)
    800036e0:	7b02                	ld	s6,32(sp)
    800036e2:	6125                	addi	sp,sp,96
    800036e4:	8082                	ret
    800036e6:	e4a6                	sd	s1,72(sp)
    800036e8:	fc4e                	sd	s3,56(sp)
    800036ea:	f852                	sd	s4,48(sp)
    800036ec:	ec5e                	sd	s7,24(sp)
    800036ee:	e862                	sd	s8,16(sp)
    800036f0:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800036f2:	00004517          	auipc	a0,0x4
    800036f6:	f5e50513          	addi	a0,a0,-162 # 80007650 <etext+0x650>
    800036fa:	61d010ef          	jal	80005516 <panic>
    return -1;
    800036fe:	557d                	li	a0,-1
}
    80003700:	8082                	ret
      return -1;
    80003702:	557d                	li	a0,-1
    80003704:	bfd1                	j	800036d8 <filewrite+0xfa>
    80003706:	557d                	li	a0,-1
    80003708:	bfc1                	j	800036d8 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    8000370a:	557d                	li	a0,-1
    8000370c:	7a42                	ld	s4,48(sp)
    8000370e:	b7e9                	j	800036d8 <filewrite+0xfa>

0000000080003710 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003710:	7179                	addi	sp,sp,-48
    80003712:	f406                	sd	ra,40(sp)
    80003714:	f022                	sd	s0,32(sp)
    80003716:	ec26                	sd	s1,24(sp)
    80003718:	e052                	sd	s4,0(sp)
    8000371a:	1800                	addi	s0,sp,48
    8000371c:	84aa                	mv	s1,a0
    8000371e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003720:	0005b023          	sd	zero,0(a1)
    80003724:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003728:	c35ff0ef          	jal	8000335c <filealloc>
    8000372c:	e088                	sd	a0,0(s1)
    8000372e:	c549                	beqz	a0,800037b8 <pipealloc+0xa8>
    80003730:	c2dff0ef          	jal	8000335c <filealloc>
    80003734:	00aa3023          	sd	a0,0(s4)
    80003738:	cd25                	beqz	a0,800037b0 <pipealloc+0xa0>
    8000373a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000373c:	9c3fc0ef          	jal	800000fe <kalloc>
    80003740:	892a                	mv	s2,a0
    80003742:	c12d                	beqz	a0,800037a4 <pipealloc+0x94>
    80003744:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003746:	4985                	li	s3,1
    80003748:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000374c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003750:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003754:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003758:	00004597          	auipc	a1,0x4
    8000375c:	ca858593          	addi	a1,a1,-856 # 80007400 <etext+0x400>
    80003760:	060020ef          	jal	800057c0 <initlock>
  (*f0)->type = FD_PIPE;
    80003764:	609c                	ld	a5,0(s1)
    80003766:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000376a:	609c                	ld	a5,0(s1)
    8000376c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003770:	609c                	ld	a5,0(s1)
    80003772:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003776:	609c                	ld	a5,0(s1)
    80003778:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000377c:	000a3783          	ld	a5,0(s4)
    80003780:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003784:	000a3783          	ld	a5,0(s4)
    80003788:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000378c:	000a3783          	ld	a5,0(s4)
    80003790:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003794:	000a3783          	ld	a5,0(s4)
    80003798:	0127b823          	sd	s2,16(a5)
  return 0;
    8000379c:	4501                	li	a0,0
    8000379e:	6942                	ld	s2,16(sp)
    800037a0:	69a2                	ld	s3,8(sp)
    800037a2:	a01d                	j	800037c8 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037a4:	6088                	ld	a0,0(s1)
    800037a6:	c119                	beqz	a0,800037ac <pipealloc+0x9c>
    800037a8:	6942                	ld	s2,16(sp)
    800037aa:	a029                	j	800037b4 <pipealloc+0xa4>
    800037ac:	6942                	ld	s2,16(sp)
    800037ae:	a029                	j	800037b8 <pipealloc+0xa8>
    800037b0:	6088                	ld	a0,0(s1)
    800037b2:	c10d                	beqz	a0,800037d4 <pipealloc+0xc4>
    fileclose(*f0);
    800037b4:	c4dff0ef          	jal	80003400 <fileclose>
  if(*f1)
    800037b8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037bc:	557d                	li	a0,-1
  if(*f1)
    800037be:	c789                	beqz	a5,800037c8 <pipealloc+0xb8>
    fileclose(*f1);
    800037c0:	853e                	mv	a0,a5
    800037c2:	c3fff0ef          	jal	80003400 <fileclose>
  return -1;
    800037c6:	557d                	li	a0,-1
}
    800037c8:	70a2                	ld	ra,40(sp)
    800037ca:	7402                	ld	s0,32(sp)
    800037cc:	64e2                	ld	s1,24(sp)
    800037ce:	6a02                	ld	s4,0(sp)
    800037d0:	6145                	addi	sp,sp,48
    800037d2:	8082                	ret
  return -1;
    800037d4:	557d                	li	a0,-1
    800037d6:	bfcd                	j	800037c8 <pipealloc+0xb8>

00000000800037d8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800037d8:	1101                	addi	sp,sp,-32
    800037da:	ec06                	sd	ra,24(sp)
    800037dc:	e822                	sd	s0,16(sp)
    800037de:	e426                	sd	s1,8(sp)
    800037e0:	e04a                	sd	s2,0(sp)
    800037e2:	1000                	addi	s0,sp,32
    800037e4:	84aa                	mv	s1,a0
    800037e6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037e8:	05c020ef          	jal	80005844 <acquire>
  if(writable){
    800037ec:	02090763          	beqz	s2,8000381a <pipeclose+0x42>
    pi->writeopen = 0;
    800037f0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800037f4:	21848513          	addi	a0,s1,536
    800037f8:	c01fd0ef          	jal	800013f8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800037fc:	2204b783          	ld	a5,544(s1)
    80003800:	e785                	bnez	a5,80003828 <pipeclose+0x50>
    release(&pi->lock);
    80003802:	8526                	mv	a0,s1
    80003804:	0d4020ef          	jal	800058d8 <release>
    kfree((char*)pi);
    80003808:	8526                	mv	a0,s1
    8000380a:	813fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000380e:	60e2                	ld	ra,24(sp)
    80003810:	6442                	ld	s0,16(sp)
    80003812:	64a2                	ld	s1,8(sp)
    80003814:	6902                	ld	s2,0(sp)
    80003816:	6105                	addi	sp,sp,32
    80003818:	8082                	ret
    pi->readopen = 0;
    8000381a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000381e:	21c48513          	addi	a0,s1,540
    80003822:	bd7fd0ef          	jal	800013f8 <wakeup>
    80003826:	bfd9                	j	800037fc <pipeclose+0x24>
    release(&pi->lock);
    80003828:	8526                	mv	a0,s1
    8000382a:	0ae020ef          	jal	800058d8 <release>
}
    8000382e:	b7c5                	j	8000380e <pipeclose+0x36>

0000000080003830 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003830:	7159                	addi	sp,sp,-112
    80003832:	f486                	sd	ra,104(sp)
    80003834:	f0a2                	sd	s0,96(sp)
    80003836:	eca6                	sd	s1,88(sp)
    80003838:	e8ca                	sd	s2,80(sp)
    8000383a:	e4ce                	sd	s3,72(sp)
    8000383c:	e0d2                	sd	s4,64(sp)
    8000383e:	fc56                	sd	s5,56(sp)
    80003840:	1880                	addi	s0,sp,112
    80003842:	84aa                	mv	s1,a0
    80003844:	8aae                	mv	s5,a1
    80003846:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003848:	d8afd0ef          	jal	80000dd2 <myproc>
    8000384c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000384e:	8526                	mv	a0,s1
    80003850:	7f5010ef          	jal	80005844 <acquire>
  while(i < n){
    80003854:	0d405263          	blez	s4,80003918 <pipewrite+0xe8>
    80003858:	f85a                	sd	s6,48(sp)
    8000385a:	f45e                	sd	s7,40(sp)
    8000385c:	f062                	sd	s8,32(sp)
    8000385e:	ec66                	sd	s9,24(sp)
    80003860:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003862:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003864:	f9f40c13          	addi	s8,s0,-97
    80003868:	4b85                	li	s7,1
    8000386a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000386c:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003870:	21c48c93          	addi	s9,s1,540
    80003874:	a82d                	j	800038ae <pipewrite+0x7e>
      release(&pi->lock);
    80003876:	8526                	mv	a0,s1
    80003878:	060020ef          	jal	800058d8 <release>
      return -1;
    8000387c:	597d                	li	s2,-1
    8000387e:	7b42                	ld	s6,48(sp)
    80003880:	7ba2                	ld	s7,40(sp)
    80003882:	7c02                	ld	s8,32(sp)
    80003884:	6ce2                	ld	s9,24(sp)
    80003886:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003888:	854a                	mv	a0,s2
    8000388a:	70a6                	ld	ra,104(sp)
    8000388c:	7406                	ld	s0,96(sp)
    8000388e:	64e6                	ld	s1,88(sp)
    80003890:	6946                	ld	s2,80(sp)
    80003892:	69a6                	ld	s3,72(sp)
    80003894:	6a06                	ld	s4,64(sp)
    80003896:	7ae2                	ld	s5,56(sp)
    80003898:	6165                	addi	sp,sp,112
    8000389a:	8082                	ret
      wakeup(&pi->nread);
    8000389c:	856a                	mv	a0,s10
    8000389e:	b5bfd0ef          	jal	800013f8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038a2:	85a6                	mv	a1,s1
    800038a4:	8566                	mv	a0,s9
    800038a6:	b07fd0ef          	jal	800013ac <sleep>
  while(i < n){
    800038aa:	05495a63          	bge	s2,s4,800038fe <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800038ae:	2204a783          	lw	a5,544(s1)
    800038b2:	d3f1                	beqz	a5,80003876 <pipewrite+0x46>
    800038b4:	854e                	mv	a0,s3
    800038b6:	d2ffd0ef          	jal	800015e4 <killed>
    800038ba:	fd55                	bnez	a0,80003876 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038bc:	2184a783          	lw	a5,536(s1)
    800038c0:	21c4a703          	lw	a4,540(s1)
    800038c4:	2007879b          	addiw	a5,a5,512
    800038c8:	fcf70ae3          	beq	a4,a5,8000389c <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038cc:	86de                	mv	a3,s7
    800038ce:	01590633          	add	a2,s2,s5
    800038d2:	85e2                	mv	a1,s8
    800038d4:	0509b503          	ld	a0,80(s3)
    800038d8:	a1efd0ef          	jal	80000af6 <copyin>
    800038dc:	05650063          	beq	a0,s6,8000391c <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800038e0:	21c4a783          	lw	a5,540(s1)
    800038e4:	0017871b          	addiw	a4,a5,1
    800038e8:	20e4ae23          	sw	a4,540(s1)
    800038ec:	1ff7f793          	andi	a5,a5,511
    800038f0:	97a6                	add	a5,a5,s1
    800038f2:	f9f44703          	lbu	a4,-97(s0)
    800038f6:	00e78c23          	sb	a4,24(a5)
      i++;
    800038fa:	2905                	addiw	s2,s2,1
    800038fc:	b77d                	j	800038aa <pipewrite+0x7a>
    800038fe:	7b42                	ld	s6,48(sp)
    80003900:	7ba2                	ld	s7,40(sp)
    80003902:	7c02                	ld	s8,32(sp)
    80003904:	6ce2                	ld	s9,24(sp)
    80003906:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003908:	21848513          	addi	a0,s1,536
    8000390c:	aedfd0ef          	jal	800013f8 <wakeup>
  release(&pi->lock);
    80003910:	8526                	mv	a0,s1
    80003912:	7c7010ef          	jal	800058d8 <release>
  return i;
    80003916:	bf8d                	j	80003888 <pipewrite+0x58>
  int i = 0;
    80003918:	4901                	li	s2,0
    8000391a:	b7fd                	j	80003908 <pipewrite+0xd8>
    8000391c:	7b42                	ld	s6,48(sp)
    8000391e:	7ba2                	ld	s7,40(sp)
    80003920:	7c02                	ld	s8,32(sp)
    80003922:	6ce2                	ld	s9,24(sp)
    80003924:	6d42                	ld	s10,16(sp)
    80003926:	b7cd                	j	80003908 <pipewrite+0xd8>

0000000080003928 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003928:	711d                	addi	sp,sp,-96
    8000392a:	ec86                	sd	ra,88(sp)
    8000392c:	e8a2                	sd	s0,80(sp)
    8000392e:	e4a6                	sd	s1,72(sp)
    80003930:	e0ca                	sd	s2,64(sp)
    80003932:	fc4e                	sd	s3,56(sp)
    80003934:	f852                	sd	s4,48(sp)
    80003936:	f456                	sd	s5,40(sp)
    80003938:	1080                	addi	s0,sp,96
    8000393a:	84aa                	mv	s1,a0
    8000393c:	892e                	mv	s2,a1
    8000393e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003940:	c92fd0ef          	jal	80000dd2 <myproc>
    80003944:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003946:	8526                	mv	a0,s1
    80003948:	6fd010ef          	jal	80005844 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000394c:	2184a703          	lw	a4,536(s1)
    80003950:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003954:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003958:	02f71763          	bne	a4,a5,80003986 <piperead+0x5e>
    8000395c:	2244a783          	lw	a5,548(s1)
    80003960:	cf85                	beqz	a5,80003998 <piperead+0x70>
    if(killed(pr)){
    80003962:	8552                	mv	a0,s4
    80003964:	c81fd0ef          	jal	800015e4 <killed>
    80003968:	e11d                	bnez	a0,8000398e <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000396a:	85a6                	mv	a1,s1
    8000396c:	854e                	mv	a0,s3
    8000396e:	a3ffd0ef          	jal	800013ac <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003972:	2184a703          	lw	a4,536(s1)
    80003976:	21c4a783          	lw	a5,540(s1)
    8000397a:	fef701e3          	beq	a4,a5,8000395c <piperead+0x34>
    8000397e:	f05a                	sd	s6,32(sp)
    80003980:	ec5e                	sd	s7,24(sp)
    80003982:	e862                	sd	s8,16(sp)
    80003984:	a829                	j	8000399e <piperead+0x76>
    80003986:	f05a                	sd	s6,32(sp)
    80003988:	ec5e                	sd	s7,24(sp)
    8000398a:	e862                	sd	s8,16(sp)
    8000398c:	a809                	j	8000399e <piperead+0x76>
      release(&pi->lock);
    8000398e:	8526                	mv	a0,s1
    80003990:	749010ef          	jal	800058d8 <release>
      return -1;
    80003994:	59fd                	li	s3,-1
    80003996:	a0a5                	j	800039fe <piperead+0xd6>
    80003998:	f05a                	sd	s6,32(sp)
    8000399a:	ec5e                	sd	s7,24(sp)
    8000399c:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000399e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039a0:	faf40c13          	addi	s8,s0,-81
    800039a4:	4b85                	li	s7,1
    800039a6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039a8:	05505163          	blez	s5,800039ea <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    800039ac:	2184a783          	lw	a5,536(s1)
    800039b0:	21c4a703          	lw	a4,540(s1)
    800039b4:	02f70b63          	beq	a4,a5,800039ea <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039b8:	0017871b          	addiw	a4,a5,1
    800039bc:	20e4ac23          	sw	a4,536(s1)
    800039c0:	1ff7f793          	andi	a5,a5,511
    800039c4:	97a6                	add	a5,a5,s1
    800039c6:	0187c783          	lbu	a5,24(a5)
    800039ca:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039ce:	86de                	mv	a3,s7
    800039d0:	8662                	mv	a2,s8
    800039d2:	85ca                	mv	a1,s2
    800039d4:	050a3503          	ld	a0,80(s4)
    800039d8:	86efd0ef          	jal	80000a46 <copyout>
    800039dc:	01650763          	beq	a0,s6,800039ea <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039e0:	2985                	addiw	s3,s3,1
    800039e2:	0905                	addi	s2,s2,1
    800039e4:	fd3a94e3          	bne	s5,s3,800039ac <piperead+0x84>
    800039e8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039ea:	21c48513          	addi	a0,s1,540
    800039ee:	a0bfd0ef          	jal	800013f8 <wakeup>
  release(&pi->lock);
    800039f2:	8526                	mv	a0,s1
    800039f4:	6e5010ef          	jal	800058d8 <release>
    800039f8:	7b02                	ld	s6,32(sp)
    800039fa:	6be2                	ld	s7,24(sp)
    800039fc:	6c42                	ld	s8,16(sp)
  return i;
}
    800039fe:	854e                	mv	a0,s3
    80003a00:	60e6                	ld	ra,88(sp)
    80003a02:	6446                	ld	s0,80(sp)
    80003a04:	64a6                	ld	s1,72(sp)
    80003a06:	6906                	ld	s2,64(sp)
    80003a08:	79e2                	ld	s3,56(sp)
    80003a0a:	7a42                	ld	s4,48(sp)
    80003a0c:	7aa2                	ld	s5,40(sp)
    80003a0e:	6125                	addi	sp,sp,96
    80003a10:	8082                	ret

0000000080003a12 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a12:	1141                	addi	sp,sp,-16
    80003a14:	e406                	sd	ra,8(sp)
    80003a16:	e022                	sd	s0,0(sp)
    80003a18:	0800                	addi	s0,sp,16
    80003a1a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a1c:	0035151b          	slliw	a0,a0,0x3
    80003a20:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003a22:	8b89                	andi	a5,a5,2
    80003a24:	c399                	beqz	a5,80003a2a <flags2perm+0x18>
      perm |= PTE_W;
    80003a26:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a2a:	60a2                	ld	ra,8(sp)
    80003a2c:	6402                	ld	s0,0(sp)
    80003a2e:	0141                	addi	sp,sp,16
    80003a30:	8082                	ret

0000000080003a32 <exec>:

int
exec(char *path, char **argv)
{
    80003a32:	de010113          	addi	sp,sp,-544
    80003a36:	20113c23          	sd	ra,536(sp)
    80003a3a:	20813823          	sd	s0,528(sp)
    80003a3e:	20913423          	sd	s1,520(sp)
    80003a42:	21213023          	sd	s2,512(sp)
    80003a46:	1400                	addi	s0,sp,544
    80003a48:	892a                	mv	s2,a0
    80003a4a:	dea43823          	sd	a0,-528(s0)
    80003a4e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a52:	b80fd0ef          	jal	80000dd2 <myproc>
    80003a56:	84aa                	mv	s1,a0

  begin_op();
    80003a58:	d88ff0ef          	jal	80002fe0 <begin_op>

  if((ip = namei(path)) == 0){
    80003a5c:	854a                	mv	a0,s2
    80003a5e:	bc0ff0ef          	jal	80002e1e <namei>
    80003a62:	cd21                	beqz	a0,80003aba <exec+0x88>
    80003a64:	fbd2                	sd	s4,496(sp)
    80003a66:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a68:	cc7fe0ef          	jal	8000272e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a6c:	04000713          	li	a4,64
    80003a70:	4681                	li	a3,0
    80003a72:	e5040613          	addi	a2,s0,-432
    80003a76:	4581                	li	a1,0
    80003a78:	8552                	mv	a0,s4
    80003a7a:	f0dfe0ef          	jal	80002986 <readi>
    80003a7e:	04000793          	li	a5,64
    80003a82:	00f51a63          	bne	a0,a5,80003a96 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a86:	e5042703          	lw	a4,-432(s0)
    80003a8a:	464c47b7          	lui	a5,0x464c4
    80003a8e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a92:	02f70863          	beq	a4,a5,80003ac2 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a96:	8552                	mv	a0,s4
    80003a98:	ea1fe0ef          	jal	80002938 <iunlockput>
    end_op();
    80003a9c:	daeff0ef          	jal	8000304a <end_op>
  }
  return -1;
    80003aa0:	557d                	li	a0,-1
    80003aa2:	7a5e                	ld	s4,496(sp)
}
    80003aa4:	21813083          	ld	ra,536(sp)
    80003aa8:	21013403          	ld	s0,528(sp)
    80003aac:	20813483          	ld	s1,520(sp)
    80003ab0:	20013903          	ld	s2,512(sp)
    80003ab4:	22010113          	addi	sp,sp,544
    80003ab8:	8082                	ret
    end_op();
    80003aba:	d90ff0ef          	jal	8000304a <end_op>
    return -1;
    80003abe:	557d                	li	a0,-1
    80003ac0:	b7d5                	j	80003aa4 <exec+0x72>
    80003ac2:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	bb4fd0ef          	jal	80000e7a <proc_pagetable>
    80003aca:	8b2a                	mv	s6,a0
    80003acc:	26050d63          	beqz	a0,80003d46 <exec+0x314>
    80003ad0:	ffce                	sd	s3,504(sp)
    80003ad2:	f7d6                	sd	s5,488(sp)
    80003ad4:	efde                	sd	s7,472(sp)
    80003ad6:	ebe2                	sd	s8,464(sp)
    80003ad8:	e7e6                	sd	s9,456(sp)
    80003ada:	e3ea                	sd	s10,448(sp)
    80003adc:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ade:	e7042683          	lw	a3,-400(s0)
    80003ae2:	e8845783          	lhu	a5,-376(s0)
    80003ae6:	0e078763          	beqz	a5,80003bd4 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003aea:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003aec:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003aee:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003af2:	6c85                	lui	s9,0x1
    80003af4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003af8:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003afc:	6a85                	lui	s5,0x1
    80003afe:	a085                	j	80003b5e <exec+0x12c>
      panic("loadseg: address should exist");
    80003b00:	00004517          	auipc	a0,0x4
    80003b04:	b6050513          	addi	a0,a0,-1184 # 80007660 <etext+0x660>
    80003b08:	20f010ef          	jal	80005516 <panic>
    if(sz - i < PGSIZE)
    80003b0c:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b0e:	874a                	mv	a4,s2
    80003b10:	009c06bb          	addw	a3,s8,s1
    80003b14:	4581                	li	a1,0
    80003b16:	8552                	mv	a0,s4
    80003b18:	e6ffe0ef          	jal	80002986 <readi>
    80003b1c:	22a91963          	bne	s2,a0,80003d4e <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003b20:	009a84bb          	addw	s1,s5,s1
    80003b24:	0334f263          	bgeu	s1,s3,80003b48 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003b28:	02049593          	slli	a1,s1,0x20
    80003b2c:	9181                	srli	a1,a1,0x20
    80003b2e:	95de                	add	a1,a1,s7
    80003b30:	855a                	mv	a0,s6
    80003b32:	98dfc0ef          	jal	800004be <walkaddr>
    80003b36:	862a                	mv	a2,a0
    if(pa == 0)
    80003b38:	d561                	beqz	a0,80003b00 <exec+0xce>
    if(sz - i < PGSIZE)
    80003b3a:	409987bb          	subw	a5,s3,s1
    80003b3e:	893e                	mv	s2,a5
    80003b40:	fcfcf6e3          	bgeu	s9,a5,80003b0c <exec+0xda>
    80003b44:	8956                	mv	s2,s5
    80003b46:	b7d9                	j	80003b0c <exec+0xda>
    sz = sz1;
    80003b48:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b4c:	2d05                	addiw	s10,s10,1
    80003b4e:	e0843783          	ld	a5,-504(s0)
    80003b52:	0387869b          	addiw	a3,a5,56
    80003b56:	e8845783          	lhu	a5,-376(s0)
    80003b5a:	06fd5e63          	bge	s10,a5,80003bd6 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b5e:	e0d43423          	sd	a3,-504(s0)
    80003b62:	876e                	mv	a4,s11
    80003b64:	e1840613          	addi	a2,s0,-488
    80003b68:	4581                	li	a1,0
    80003b6a:	8552                	mv	a0,s4
    80003b6c:	e1bfe0ef          	jal	80002986 <readi>
    80003b70:	1db51d63          	bne	a0,s11,80003d4a <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003b74:	e1842783          	lw	a5,-488(s0)
    80003b78:	4705                	li	a4,1
    80003b7a:	fce799e3          	bne	a5,a4,80003b4c <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003b7e:	e4043483          	ld	s1,-448(s0)
    80003b82:	e3843783          	ld	a5,-456(s0)
    80003b86:	1ef4e263          	bltu	s1,a5,80003d6a <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b8a:	e2843783          	ld	a5,-472(s0)
    80003b8e:	94be                	add	s1,s1,a5
    80003b90:	1ef4e063          	bltu	s1,a5,80003d70 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003b94:	de843703          	ld	a4,-536(s0)
    80003b98:	8ff9                	and	a5,a5,a4
    80003b9a:	1c079e63          	bnez	a5,80003d76 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b9e:	e1c42503          	lw	a0,-484(s0)
    80003ba2:	e71ff0ef          	jal	80003a12 <flags2perm>
    80003ba6:	86aa                	mv	a3,a0
    80003ba8:	8626                	mv	a2,s1
    80003baa:	85ca                	mv	a1,s2
    80003bac:	855a                	mv	a0,s6
    80003bae:	c79fc0ef          	jal	80000826 <uvmalloc>
    80003bb2:	dea43c23          	sd	a0,-520(s0)
    80003bb6:	1c050363          	beqz	a0,80003d7c <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003bba:	e2843b83          	ld	s7,-472(s0)
    80003bbe:	e2042c03          	lw	s8,-480(s0)
    80003bc2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003bc6:	00098463          	beqz	s3,80003bce <exec+0x19c>
    80003bca:	4481                	li	s1,0
    80003bcc:	bfb1                	j	80003b28 <exec+0xf6>
    sz = sz1;
    80003bce:	df843903          	ld	s2,-520(s0)
    80003bd2:	bfad                	j	80003b4c <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003bd4:	4901                	li	s2,0
  iunlockput(ip);
    80003bd6:	8552                	mv	a0,s4
    80003bd8:	d61fe0ef          	jal	80002938 <iunlockput>
  end_op();
    80003bdc:	c6eff0ef          	jal	8000304a <end_op>
  p = myproc();
    80003be0:	9f2fd0ef          	jal	80000dd2 <myproc>
    80003be4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003be6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003bea:	6985                	lui	s3,0x1
    80003bec:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bee:	99ca                	add	s3,s3,s2
    80003bf0:	77fd                	lui	a5,0xfffff
    80003bf2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bf6:	4691                	li	a3,4
    80003bf8:	660d                	lui	a2,0x3
    80003bfa:	964e                	add	a2,a2,s3
    80003bfc:	85ce                	mv	a1,s3
    80003bfe:	855a                	mv	a0,s6
    80003c00:	c27fc0ef          	jal	80000826 <uvmalloc>
    80003c04:	8a2a                	mv	s4,a0
    80003c06:	e105                	bnez	a0,80003c26 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003c08:	85ce                	mv	a1,s3
    80003c0a:	855a                	mv	a0,s6
    80003c0c:	af2fd0ef          	jal	80000efe <proc_freepagetable>
  return -1;
    80003c10:	557d                	li	a0,-1
    80003c12:	79fe                	ld	s3,504(sp)
    80003c14:	7a5e                	ld	s4,496(sp)
    80003c16:	7abe                	ld	s5,488(sp)
    80003c18:	7b1e                	ld	s6,480(sp)
    80003c1a:	6bfe                	ld	s7,472(sp)
    80003c1c:	6c5e                	ld	s8,464(sp)
    80003c1e:	6cbe                	ld	s9,456(sp)
    80003c20:	6d1e                	ld	s10,448(sp)
    80003c22:	7dfa                	ld	s11,440(sp)
    80003c24:	b541                	j	80003aa4 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c26:	75f5                	lui	a1,0xffffd
    80003c28:	95aa                	add	a1,a1,a0
    80003c2a:	855a                	mv	a0,s6
    80003c2c:	df1fc0ef          	jal	80000a1c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c30:	7bf9                	lui	s7,0xffffe
    80003c32:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c34:	e0043783          	ld	a5,-512(s0)
    80003c38:	6388                	ld	a0,0(a5)
  sp = sz;
    80003c3a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c3c:	4481                	li	s1,0
    ustack[argc] = sp;
    80003c3e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003c42:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003c46:	cd21                	beqz	a0,80003c9e <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003c48:	ed0fc0ef          	jal	80000318 <strlen>
    80003c4c:	0015079b          	addiw	a5,a0,1
    80003c50:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c54:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c58:	13796563          	bltu	s2,s7,80003d82 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c5c:	e0043d83          	ld	s11,-512(s0)
    80003c60:	000db983          	ld	s3,0(s11)
    80003c64:	854e                	mv	a0,s3
    80003c66:	eb2fc0ef          	jal	80000318 <strlen>
    80003c6a:	0015069b          	addiw	a3,a0,1
    80003c6e:	864e                	mv	a2,s3
    80003c70:	85ca                	mv	a1,s2
    80003c72:	855a                	mv	a0,s6
    80003c74:	dd3fc0ef          	jal	80000a46 <copyout>
    80003c78:	10054763          	bltz	a0,80003d86 <exec+0x354>
    ustack[argc] = sp;
    80003c7c:	00349793          	slli	a5,s1,0x3
    80003c80:	97e6                	add	a5,a5,s9
    80003c82:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb5e0>
  for(argc = 0; argv[argc]; argc++) {
    80003c86:	0485                	addi	s1,s1,1
    80003c88:	008d8793          	addi	a5,s11,8
    80003c8c:	e0f43023          	sd	a5,-512(s0)
    80003c90:	008db503          	ld	a0,8(s11)
    80003c94:	c509                	beqz	a0,80003c9e <exec+0x26c>
    if(argc >= MAXARG)
    80003c96:	fb8499e3          	bne	s1,s8,80003c48 <exec+0x216>
  sz = sz1;
    80003c9a:	89d2                	mv	s3,s4
    80003c9c:	b7b5                	j	80003c08 <exec+0x1d6>
  ustack[argc] = 0;
    80003c9e:	00349793          	slli	a5,s1,0x3
    80003ca2:	f9078793          	addi	a5,a5,-112
    80003ca6:	97a2                	add	a5,a5,s0
    80003ca8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cac:	00148693          	addi	a3,s1,1
    80003cb0:	068e                	slli	a3,a3,0x3
    80003cb2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cb6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003cba:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003cbc:	f57966e3          	bltu	s2,s7,80003c08 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003cc0:	e9040613          	addi	a2,s0,-368
    80003cc4:	85ca                	mv	a1,s2
    80003cc6:	855a                	mv	a0,s6
    80003cc8:	d7ffc0ef          	jal	80000a46 <copyout>
    80003ccc:	f2054ee3          	bltz	a0,80003c08 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003cd0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003cd4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003cd8:	df043783          	ld	a5,-528(s0)
    80003cdc:	0007c703          	lbu	a4,0(a5)
    80003ce0:	cf11                	beqz	a4,80003cfc <exec+0x2ca>
    80003ce2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ce4:	02f00693          	li	a3,47
    80003ce8:	a029                	j	80003cf2 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003cea:	0785                	addi	a5,a5,1
    80003cec:	fff7c703          	lbu	a4,-1(a5)
    80003cf0:	c711                	beqz	a4,80003cfc <exec+0x2ca>
    if(*s == '/')
    80003cf2:	fed71ce3          	bne	a4,a3,80003cea <exec+0x2b8>
      last = s+1;
    80003cf6:	def43823          	sd	a5,-528(s0)
    80003cfa:	bfc5                	j	80003cea <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cfc:	4641                	li	a2,16
    80003cfe:	df043583          	ld	a1,-528(s0)
    80003d02:	158a8513          	addi	a0,s5,344
    80003d06:	ddcfc0ef          	jal	800002e2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003d0a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d0e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d12:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d16:	058ab783          	ld	a5,88(s5)
    80003d1a:	e6843703          	ld	a4,-408(s0)
    80003d1e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d20:	058ab783          	ld	a5,88(s5)
    80003d24:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d28:	85ea                	mv	a1,s10
    80003d2a:	9d4fd0ef          	jal	80000efe <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d2e:	0004851b          	sext.w	a0,s1
    80003d32:	79fe                	ld	s3,504(sp)
    80003d34:	7a5e                	ld	s4,496(sp)
    80003d36:	7abe                	ld	s5,488(sp)
    80003d38:	7b1e                	ld	s6,480(sp)
    80003d3a:	6bfe                	ld	s7,472(sp)
    80003d3c:	6c5e                	ld	s8,464(sp)
    80003d3e:	6cbe                	ld	s9,456(sp)
    80003d40:	6d1e                	ld	s10,448(sp)
    80003d42:	7dfa                	ld	s11,440(sp)
    80003d44:	b385                	j	80003aa4 <exec+0x72>
    80003d46:	7b1e                	ld	s6,480(sp)
    80003d48:	b3b9                	j	80003a96 <exec+0x64>
    80003d4a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003d4e:	df843583          	ld	a1,-520(s0)
    80003d52:	855a                	mv	a0,s6
    80003d54:	9aafd0ef          	jal	80000efe <proc_freepagetable>
  if(ip){
    80003d58:	79fe                	ld	s3,504(sp)
    80003d5a:	7abe                	ld	s5,488(sp)
    80003d5c:	7b1e                	ld	s6,480(sp)
    80003d5e:	6bfe                	ld	s7,472(sp)
    80003d60:	6c5e                	ld	s8,464(sp)
    80003d62:	6cbe                	ld	s9,456(sp)
    80003d64:	6d1e                	ld	s10,448(sp)
    80003d66:	7dfa                	ld	s11,440(sp)
    80003d68:	b33d                	j	80003a96 <exec+0x64>
    80003d6a:	df243c23          	sd	s2,-520(s0)
    80003d6e:	b7c5                	j	80003d4e <exec+0x31c>
    80003d70:	df243c23          	sd	s2,-520(s0)
    80003d74:	bfe9                	j	80003d4e <exec+0x31c>
    80003d76:	df243c23          	sd	s2,-520(s0)
    80003d7a:	bfd1                	j	80003d4e <exec+0x31c>
    80003d7c:	df243c23          	sd	s2,-520(s0)
    80003d80:	b7f9                	j	80003d4e <exec+0x31c>
  sz = sz1;
    80003d82:	89d2                	mv	s3,s4
    80003d84:	b551                	j	80003c08 <exec+0x1d6>
    80003d86:	89d2                	mv	s3,s4
    80003d88:	b541                	j	80003c08 <exec+0x1d6>

0000000080003d8a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d8a:	7179                	addi	sp,sp,-48
    80003d8c:	f406                	sd	ra,40(sp)
    80003d8e:	f022                	sd	s0,32(sp)
    80003d90:	ec26                	sd	s1,24(sp)
    80003d92:	e84a                	sd	s2,16(sp)
    80003d94:	1800                	addi	s0,sp,48
    80003d96:	892e                	mv	s2,a1
    80003d98:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d9a:	fdc40593          	addi	a1,s0,-36
    80003d9e:	ef3fd0ef          	jal	80001c90 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003da2:	fdc42703          	lw	a4,-36(s0)
    80003da6:	47bd                	li	a5,15
    80003da8:	02e7e963          	bltu	a5,a4,80003dda <argfd+0x50>
    80003dac:	826fd0ef          	jal	80000dd2 <myproc>
    80003db0:	fdc42703          	lw	a4,-36(s0)
    80003db4:	01a70793          	addi	a5,a4,26
    80003db8:	078e                	slli	a5,a5,0x3
    80003dba:	953e                	add	a0,a0,a5
    80003dbc:	611c                	ld	a5,0(a0)
    80003dbe:	c385                	beqz	a5,80003dde <argfd+0x54>
    return -1;
  if(pfd)
    80003dc0:	00090463          	beqz	s2,80003dc8 <argfd+0x3e>
    *pfd = fd;
    80003dc4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003dc8:	4501                	li	a0,0
  if(pf)
    80003dca:	c091                	beqz	s1,80003dce <argfd+0x44>
    *pf = f;
    80003dcc:	e09c                	sd	a5,0(s1)
}
    80003dce:	70a2                	ld	ra,40(sp)
    80003dd0:	7402                	ld	s0,32(sp)
    80003dd2:	64e2                	ld	s1,24(sp)
    80003dd4:	6942                	ld	s2,16(sp)
    80003dd6:	6145                	addi	sp,sp,48
    80003dd8:	8082                	ret
    return -1;
    80003dda:	557d                	li	a0,-1
    80003ddc:	bfcd                	j	80003dce <argfd+0x44>
    80003dde:	557d                	li	a0,-1
    80003de0:	b7fd                	j	80003dce <argfd+0x44>

0000000080003de2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003de2:	1101                	addi	sp,sp,-32
    80003de4:	ec06                	sd	ra,24(sp)
    80003de6:	e822                	sd	s0,16(sp)
    80003de8:	e426                	sd	s1,8(sp)
    80003dea:	1000                	addi	s0,sp,32
    80003dec:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003dee:	fe5fc0ef          	jal	80000dd2 <myproc>
    80003df2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003df4:	0d050793          	addi	a5,a0,208
    80003df8:	4501                	li	a0,0
    80003dfa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003dfc:	6398                	ld	a4,0(a5)
    80003dfe:	cb19                	beqz	a4,80003e14 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e00:	2505                	addiw	a0,a0,1
    80003e02:	07a1                	addi	a5,a5,8
    80003e04:	fed51ce3          	bne	a0,a3,80003dfc <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e08:	557d                	li	a0,-1
}
    80003e0a:	60e2                	ld	ra,24(sp)
    80003e0c:	6442                	ld	s0,16(sp)
    80003e0e:	64a2                	ld	s1,8(sp)
    80003e10:	6105                	addi	sp,sp,32
    80003e12:	8082                	ret
      p->ofile[fd] = f;
    80003e14:	01a50793          	addi	a5,a0,26
    80003e18:	078e                	slli	a5,a5,0x3
    80003e1a:	963e                	add	a2,a2,a5
    80003e1c:	e204                	sd	s1,0(a2)
      return fd;
    80003e1e:	b7f5                	j	80003e0a <fdalloc+0x28>

0000000080003e20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e20:	715d                	addi	sp,sp,-80
    80003e22:	e486                	sd	ra,72(sp)
    80003e24:	e0a2                	sd	s0,64(sp)
    80003e26:	fc26                	sd	s1,56(sp)
    80003e28:	f84a                	sd	s2,48(sp)
    80003e2a:	f44e                	sd	s3,40(sp)
    80003e2c:	ec56                	sd	s5,24(sp)
    80003e2e:	e85a                	sd	s6,16(sp)
    80003e30:	0880                	addi	s0,sp,80
    80003e32:	8b2e                	mv	s6,a1
    80003e34:	89b2                	mv	s3,a2
    80003e36:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e38:	fb040593          	addi	a1,s0,-80
    80003e3c:	ffdfe0ef          	jal	80002e38 <nameiparent>
    80003e40:	84aa                	mv	s1,a0
    80003e42:	10050a63          	beqz	a0,80003f56 <create+0x136>
    return 0;

  ilock(dp);
    80003e46:	8e9fe0ef          	jal	8000272e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e4a:	4601                	li	a2,0
    80003e4c:	fb040593          	addi	a1,s0,-80
    80003e50:	8526                	mv	a0,s1
    80003e52:	d41fe0ef          	jal	80002b92 <dirlookup>
    80003e56:	8aaa                	mv	s5,a0
    80003e58:	c129                	beqz	a0,80003e9a <create+0x7a>
    iunlockput(dp);
    80003e5a:	8526                	mv	a0,s1
    80003e5c:	addfe0ef          	jal	80002938 <iunlockput>
    ilock(ip);
    80003e60:	8556                	mv	a0,s5
    80003e62:	8cdfe0ef          	jal	8000272e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e66:	4789                	li	a5,2
    80003e68:	02fb1463          	bne	s6,a5,80003e90 <create+0x70>
    80003e6c:	044ad783          	lhu	a5,68(s5)
    80003e70:	37f9                	addiw	a5,a5,-2
    80003e72:	17c2                	slli	a5,a5,0x30
    80003e74:	93c1                	srli	a5,a5,0x30
    80003e76:	4705                	li	a4,1
    80003e78:	00f76c63          	bltu	a4,a5,80003e90 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e7c:	8556                	mv	a0,s5
    80003e7e:	60a6                	ld	ra,72(sp)
    80003e80:	6406                	ld	s0,64(sp)
    80003e82:	74e2                	ld	s1,56(sp)
    80003e84:	7942                	ld	s2,48(sp)
    80003e86:	79a2                	ld	s3,40(sp)
    80003e88:	6ae2                	ld	s5,24(sp)
    80003e8a:	6b42                	ld	s6,16(sp)
    80003e8c:	6161                	addi	sp,sp,80
    80003e8e:	8082                	ret
    iunlockput(ip);
    80003e90:	8556                	mv	a0,s5
    80003e92:	aa7fe0ef          	jal	80002938 <iunlockput>
    return 0;
    80003e96:	4a81                	li	s5,0
    80003e98:	b7d5                	j	80003e7c <create+0x5c>
    80003e9a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e9c:	85da                	mv	a1,s6
    80003e9e:	4088                	lw	a0,0(s1)
    80003ea0:	f1efe0ef          	jal	800025be <ialloc>
    80003ea4:	8a2a                	mv	s4,a0
    80003ea6:	cd15                	beqz	a0,80003ee2 <create+0xc2>
  ilock(ip);
    80003ea8:	887fe0ef          	jal	8000272e <ilock>
  ip->major = major;
    80003eac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003eb0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003eb4:	4905                	li	s2,1
    80003eb6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003eba:	8552                	mv	a0,s4
    80003ebc:	fbefe0ef          	jal	8000267a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003ec0:	032b0763          	beq	s6,s2,80003eee <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003ec4:	004a2603          	lw	a2,4(s4)
    80003ec8:	fb040593          	addi	a1,s0,-80
    80003ecc:	8526                	mv	a0,s1
    80003ece:	ea7fe0ef          	jal	80002d74 <dirlink>
    80003ed2:	06054563          	bltz	a0,80003f3c <create+0x11c>
  iunlockput(dp);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	a61fe0ef          	jal	80002938 <iunlockput>
  return ip;
    80003edc:	8ad2                	mv	s5,s4
    80003ede:	7a02                	ld	s4,32(sp)
    80003ee0:	bf71                	j	80003e7c <create+0x5c>
    iunlockput(dp);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	a55fe0ef          	jal	80002938 <iunlockput>
    return 0;
    80003ee8:	8ad2                	mv	s5,s4
    80003eea:	7a02                	ld	s4,32(sp)
    80003eec:	bf41                	j	80003e7c <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003eee:	004a2603          	lw	a2,4(s4)
    80003ef2:	00003597          	auipc	a1,0x3
    80003ef6:	78e58593          	addi	a1,a1,1934 # 80007680 <etext+0x680>
    80003efa:	8552                	mv	a0,s4
    80003efc:	e79fe0ef          	jal	80002d74 <dirlink>
    80003f00:	02054e63          	bltz	a0,80003f3c <create+0x11c>
    80003f04:	40d0                	lw	a2,4(s1)
    80003f06:	00003597          	auipc	a1,0x3
    80003f0a:	78258593          	addi	a1,a1,1922 # 80007688 <etext+0x688>
    80003f0e:	8552                	mv	a0,s4
    80003f10:	e65fe0ef          	jal	80002d74 <dirlink>
    80003f14:	02054463          	bltz	a0,80003f3c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f18:	004a2603          	lw	a2,4(s4)
    80003f1c:	fb040593          	addi	a1,s0,-80
    80003f20:	8526                	mv	a0,s1
    80003f22:	e53fe0ef          	jal	80002d74 <dirlink>
    80003f26:	00054b63          	bltz	a0,80003f3c <create+0x11c>
    dp->nlink++;  // for ".."
    80003f2a:	04a4d783          	lhu	a5,74(s1)
    80003f2e:	2785                	addiw	a5,a5,1
    80003f30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f34:	8526                	mv	a0,s1
    80003f36:	f44fe0ef          	jal	8000267a <iupdate>
    80003f3a:	bf71                	j	80003ed6 <create+0xb6>
  ip->nlink = 0;
    80003f3c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f40:	8552                	mv	a0,s4
    80003f42:	f38fe0ef          	jal	8000267a <iupdate>
  iunlockput(ip);
    80003f46:	8552                	mv	a0,s4
    80003f48:	9f1fe0ef          	jal	80002938 <iunlockput>
  iunlockput(dp);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	9ebfe0ef          	jal	80002938 <iunlockput>
  return 0;
    80003f52:	7a02                	ld	s4,32(sp)
    80003f54:	b725                	j	80003e7c <create+0x5c>
    return 0;
    80003f56:	8aaa                	mv	s5,a0
    80003f58:	b715                	j	80003e7c <create+0x5c>

0000000080003f5a <sys_dup>:
{
    80003f5a:	7179                	addi	sp,sp,-48
    80003f5c:	f406                	sd	ra,40(sp)
    80003f5e:	f022                	sd	s0,32(sp)
    80003f60:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f62:	fd840613          	addi	a2,s0,-40
    80003f66:	4581                	li	a1,0
    80003f68:	4501                	li	a0,0
    80003f6a:	e21ff0ef          	jal	80003d8a <argfd>
    return -1;
    80003f6e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f70:	02054363          	bltz	a0,80003f96 <sys_dup+0x3c>
    80003f74:	ec26                	sd	s1,24(sp)
    80003f76:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f78:	fd843903          	ld	s2,-40(s0)
    80003f7c:	854a                	mv	a0,s2
    80003f7e:	e65ff0ef          	jal	80003de2 <fdalloc>
    80003f82:	84aa                	mv	s1,a0
    return -1;
    80003f84:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f86:	00054d63          	bltz	a0,80003fa0 <sys_dup+0x46>
  filedup(f);
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	c2eff0ef          	jal	800033ba <filedup>
  return fd;
    80003f90:	87a6                	mv	a5,s1
    80003f92:	64e2                	ld	s1,24(sp)
    80003f94:	6942                	ld	s2,16(sp)
}
    80003f96:	853e                	mv	a0,a5
    80003f98:	70a2                	ld	ra,40(sp)
    80003f9a:	7402                	ld	s0,32(sp)
    80003f9c:	6145                	addi	sp,sp,48
    80003f9e:	8082                	ret
    80003fa0:	64e2                	ld	s1,24(sp)
    80003fa2:	6942                	ld	s2,16(sp)
    80003fa4:	bfcd                	j	80003f96 <sys_dup+0x3c>

0000000080003fa6 <sys_read>:
{
    80003fa6:	7179                	addi	sp,sp,-48
    80003fa8:	f406                	sd	ra,40(sp)
    80003faa:	f022                	sd	s0,32(sp)
    80003fac:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fae:	fd840593          	addi	a1,s0,-40
    80003fb2:	4505                	li	a0,1
    80003fb4:	cf9fd0ef          	jal	80001cac <argaddr>
  argint(2, &n);
    80003fb8:	fe440593          	addi	a1,s0,-28
    80003fbc:	4509                	li	a0,2
    80003fbe:	cd3fd0ef          	jal	80001c90 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fc2:	fe840613          	addi	a2,s0,-24
    80003fc6:	4581                	li	a1,0
    80003fc8:	4501                	li	a0,0
    80003fca:	dc1ff0ef          	jal	80003d8a <argfd>
    80003fce:	87aa                	mv	a5,a0
    return -1;
    80003fd0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fd2:	0007ca63          	bltz	a5,80003fe6 <sys_read+0x40>
  return fileread(f, p, n);
    80003fd6:	fe442603          	lw	a2,-28(s0)
    80003fda:	fd843583          	ld	a1,-40(s0)
    80003fde:	fe843503          	ld	a0,-24(s0)
    80003fe2:	d3eff0ef          	jal	80003520 <fileread>
}
    80003fe6:	70a2                	ld	ra,40(sp)
    80003fe8:	7402                	ld	s0,32(sp)
    80003fea:	6145                	addi	sp,sp,48
    80003fec:	8082                	ret

0000000080003fee <sys_write>:
{
    80003fee:	7179                	addi	sp,sp,-48
    80003ff0:	f406                	sd	ra,40(sp)
    80003ff2:	f022                	sd	s0,32(sp)
    80003ff4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ff6:	fd840593          	addi	a1,s0,-40
    80003ffa:	4505                	li	a0,1
    80003ffc:	cb1fd0ef          	jal	80001cac <argaddr>
  argint(2, &n);
    80004000:	fe440593          	addi	a1,s0,-28
    80004004:	4509                	li	a0,2
    80004006:	c8bfd0ef          	jal	80001c90 <argint>
  if(argfd(0, 0, &f) < 0)
    8000400a:	fe840613          	addi	a2,s0,-24
    8000400e:	4581                	li	a1,0
    80004010:	4501                	li	a0,0
    80004012:	d79ff0ef          	jal	80003d8a <argfd>
    80004016:	87aa                	mv	a5,a0
    return -1;
    80004018:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000401a:	0007ca63          	bltz	a5,8000402e <sys_write+0x40>
  return filewrite(f, p, n);
    8000401e:	fe442603          	lw	a2,-28(s0)
    80004022:	fd843583          	ld	a1,-40(s0)
    80004026:	fe843503          	ld	a0,-24(s0)
    8000402a:	db4ff0ef          	jal	800035de <filewrite>
}
    8000402e:	70a2                	ld	ra,40(sp)
    80004030:	7402                	ld	s0,32(sp)
    80004032:	6145                	addi	sp,sp,48
    80004034:	8082                	ret

0000000080004036 <sys_close>:
{
    80004036:	1101                	addi	sp,sp,-32
    80004038:	ec06                	sd	ra,24(sp)
    8000403a:	e822                	sd	s0,16(sp)
    8000403c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000403e:	fe040613          	addi	a2,s0,-32
    80004042:	fec40593          	addi	a1,s0,-20
    80004046:	4501                	li	a0,0
    80004048:	d43ff0ef          	jal	80003d8a <argfd>
    return -1;
    8000404c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000404e:	02054063          	bltz	a0,8000406e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004052:	d81fc0ef          	jal	80000dd2 <myproc>
    80004056:	fec42783          	lw	a5,-20(s0)
    8000405a:	07e9                	addi	a5,a5,26
    8000405c:	078e                	slli	a5,a5,0x3
    8000405e:	953e                	add	a0,a0,a5
    80004060:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004064:	fe043503          	ld	a0,-32(s0)
    80004068:	b98ff0ef          	jal	80003400 <fileclose>
  return 0;
    8000406c:	4781                	li	a5,0
}
    8000406e:	853e                	mv	a0,a5
    80004070:	60e2                	ld	ra,24(sp)
    80004072:	6442                	ld	s0,16(sp)
    80004074:	6105                	addi	sp,sp,32
    80004076:	8082                	ret

0000000080004078 <sys_fstat>:
{
    80004078:	1101                	addi	sp,sp,-32
    8000407a:	ec06                	sd	ra,24(sp)
    8000407c:	e822                	sd	s0,16(sp)
    8000407e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004080:	fe040593          	addi	a1,s0,-32
    80004084:	4505                	li	a0,1
    80004086:	c27fd0ef          	jal	80001cac <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000408a:	fe840613          	addi	a2,s0,-24
    8000408e:	4581                	li	a1,0
    80004090:	4501                	li	a0,0
    80004092:	cf9ff0ef          	jal	80003d8a <argfd>
    80004096:	87aa                	mv	a5,a0
    return -1;
    80004098:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000409a:	0007c863          	bltz	a5,800040aa <sys_fstat+0x32>
  return filestat(f, st);
    8000409e:	fe043583          	ld	a1,-32(s0)
    800040a2:	fe843503          	ld	a0,-24(s0)
    800040a6:	c18ff0ef          	jal	800034be <filestat>
}
    800040aa:	60e2                	ld	ra,24(sp)
    800040ac:	6442                	ld	s0,16(sp)
    800040ae:	6105                	addi	sp,sp,32
    800040b0:	8082                	ret

00000000800040b2 <sys_link>:
{
    800040b2:	7169                	addi	sp,sp,-304
    800040b4:	f606                	sd	ra,296(sp)
    800040b6:	f222                	sd	s0,288(sp)
    800040b8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040ba:	08000613          	li	a2,128
    800040be:	ed040593          	addi	a1,s0,-304
    800040c2:	4501                	li	a0,0
    800040c4:	c05fd0ef          	jal	80001cc8 <argstr>
    return -1;
    800040c8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040ca:	0c054e63          	bltz	a0,800041a6 <sys_link+0xf4>
    800040ce:	08000613          	li	a2,128
    800040d2:	f5040593          	addi	a1,s0,-176
    800040d6:	4505                	li	a0,1
    800040d8:	bf1fd0ef          	jal	80001cc8 <argstr>
    return -1;
    800040dc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040de:	0c054463          	bltz	a0,800041a6 <sys_link+0xf4>
    800040e2:	ee26                	sd	s1,280(sp)
  begin_op();
    800040e4:	efdfe0ef          	jal	80002fe0 <begin_op>
  if((ip = namei(old)) == 0){
    800040e8:	ed040513          	addi	a0,s0,-304
    800040ec:	d33fe0ef          	jal	80002e1e <namei>
    800040f0:	84aa                	mv	s1,a0
    800040f2:	c53d                	beqz	a0,80004160 <sys_link+0xae>
  ilock(ip);
    800040f4:	e3afe0ef          	jal	8000272e <ilock>
  if(ip->type == T_DIR){
    800040f8:	04449703          	lh	a4,68(s1)
    800040fc:	4785                	li	a5,1
    800040fe:	06f70663          	beq	a4,a5,8000416a <sys_link+0xb8>
    80004102:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004104:	04a4d783          	lhu	a5,74(s1)
    80004108:	2785                	addiw	a5,a5,1
    8000410a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000410e:	8526                	mv	a0,s1
    80004110:	d6afe0ef          	jal	8000267a <iupdate>
  iunlock(ip);
    80004114:	8526                	mv	a0,s1
    80004116:	ec6fe0ef          	jal	800027dc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000411a:	fd040593          	addi	a1,s0,-48
    8000411e:	f5040513          	addi	a0,s0,-176
    80004122:	d17fe0ef          	jal	80002e38 <nameiparent>
    80004126:	892a                	mv	s2,a0
    80004128:	cd21                	beqz	a0,80004180 <sys_link+0xce>
  ilock(dp);
    8000412a:	e04fe0ef          	jal	8000272e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000412e:	00092703          	lw	a4,0(s2)
    80004132:	409c                	lw	a5,0(s1)
    80004134:	04f71363          	bne	a4,a5,8000417a <sys_link+0xc8>
    80004138:	40d0                	lw	a2,4(s1)
    8000413a:	fd040593          	addi	a1,s0,-48
    8000413e:	854a                	mv	a0,s2
    80004140:	c35fe0ef          	jal	80002d74 <dirlink>
    80004144:	02054b63          	bltz	a0,8000417a <sys_link+0xc8>
  iunlockput(dp);
    80004148:	854a                	mv	a0,s2
    8000414a:	feefe0ef          	jal	80002938 <iunlockput>
  iput(ip);
    8000414e:	8526                	mv	a0,s1
    80004150:	f60fe0ef          	jal	800028b0 <iput>
  end_op();
    80004154:	ef7fe0ef          	jal	8000304a <end_op>
  return 0;
    80004158:	4781                	li	a5,0
    8000415a:	64f2                	ld	s1,280(sp)
    8000415c:	6952                	ld	s2,272(sp)
    8000415e:	a0a1                	j	800041a6 <sys_link+0xf4>
    end_op();
    80004160:	eebfe0ef          	jal	8000304a <end_op>
    return -1;
    80004164:	57fd                	li	a5,-1
    80004166:	64f2                	ld	s1,280(sp)
    80004168:	a83d                	j	800041a6 <sys_link+0xf4>
    iunlockput(ip);
    8000416a:	8526                	mv	a0,s1
    8000416c:	fccfe0ef          	jal	80002938 <iunlockput>
    end_op();
    80004170:	edbfe0ef          	jal	8000304a <end_op>
    return -1;
    80004174:	57fd                	li	a5,-1
    80004176:	64f2                	ld	s1,280(sp)
    80004178:	a03d                	j	800041a6 <sys_link+0xf4>
    iunlockput(dp);
    8000417a:	854a                	mv	a0,s2
    8000417c:	fbcfe0ef          	jal	80002938 <iunlockput>
  ilock(ip);
    80004180:	8526                	mv	a0,s1
    80004182:	dacfe0ef          	jal	8000272e <ilock>
  ip->nlink--;
    80004186:	04a4d783          	lhu	a5,74(s1)
    8000418a:	37fd                	addiw	a5,a5,-1
    8000418c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004190:	8526                	mv	a0,s1
    80004192:	ce8fe0ef          	jal	8000267a <iupdate>
  iunlockput(ip);
    80004196:	8526                	mv	a0,s1
    80004198:	fa0fe0ef          	jal	80002938 <iunlockput>
  end_op();
    8000419c:	eaffe0ef          	jal	8000304a <end_op>
  return -1;
    800041a0:	57fd                	li	a5,-1
    800041a2:	64f2                	ld	s1,280(sp)
    800041a4:	6952                	ld	s2,272(sp)
}
    800041a6:	853e                	mv	a0,a5
    800041a8:	70b2                	ld	ra,296(sp)
    800041aa:	7412                	ld	s0,288(sp)
    800041ac:	6155                	addi	sp,sp,304
    800041ae:	8082                	ret

00000000800041b0 <sys_unlink>:
{
    800041b0:	7111                	addi	sp,sp,-256
    800041b2:	fd86                	sd	ra,248(sp)
    800041b4:	f9a2                	sd	s0,240(sp)
    800041b6:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800041b8:	08000613          	li	a2,128
    800041bc:	f2040593          	addi	a1,s0,-224
    800041c0:	4501                	li	a0,0
    800041c2:	b07fd0ef          	jal	80001cc8 <argstr>
    800041c6:	16054663          	bltz	a0,80004332 <sys_unlink+0x182>
    800041ca:	f5a6                	sd	s1,232(sp)
  begin_op();
    800041cc:	e15fe0ef          	jal	80002fe0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041d0:	fa040593          	addi	a1,s0,-96
    800041d4:	f2040513          	addi	a0,s0,-224
    800041d8:	c61fe0ef          	jal	80002e38 <nameiparent>
    800041dc:	84aa                	mv	s1,a0
    800041de:	c955                	beqz	a0,80004292 <sys_unlink+0xe2>
  ilock(dp);
    800041e0:	d4efe0ef          	jal	8000272e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800041e4:	00003597          	auipc	a1,0x3
    800041e8:	49c58593          	addi	a1,a1,1180 # 80007680 <etext+0x680>
    800041ec:	fa040513          	addi	a0,s0,-96
    800041f0:	98dfe0ef          	jal	80002b7c <namecmp>
    800041f4:	12050463          	beqz	a0,8000431c <sys_unlink+0x16c>
    800041f8:	00003597          	auipc	a1,0x3
    800041fc:	49058593          	addi	a1,a1,1168 # 80007688 <etext+0x688>
    80004200:	fa040513          	addi	a0,s0,-96
    80004204:	979fe0ef          	jal	80002b7c <namecmp>
    80004208:	10050a63          	beqz	a0,8000431c <sys_unlink+0x16c>
    8000420c:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000420e:	f1c40613          	addi	a2,s0,-228
    80004212:	fa040593          	addi	a1,s0,-96
    80004216:	8526                	mv	a0,s1
    80004218:	97bfe0ef          	jal	80002b92 <dirlookup>
    8000421c:	892a                	mv	s2,a0
    8000421e:	0e050e63          	beqz	a0,8000431a <sys_unlink+0x16a>
    80004222:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004224:	d0afe0ef          	jal	8000272e <ilock>
  if(ip->nlink < 1)
    80004228:	04a91783          	lh	a5,74(s2)
    8000422c:	06f05863          	blez	a5,8000429c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004230:	04491703          	lh	a4,68(s2)
    80004234:	4785                	li	a5,1
    80004236:	06f70b63          	beq	a4,a5,800042ac <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    8000423a:	fb040993          	addi	s3,s0,-80
    8000423e:	4641                	li	a2,16
    80004240:	4581                	li	a1,0
    80004242:	854e                	mv	a0,s3
    80004244:	f4dfb0ef          	jal	80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004248:	4741                	li	a4,16
    8000424a:	f1c42683          	lw	a3,-228(s0)
    8000424e:	864e                	mv	a2,s3
    80004250:	4581                	li	a1,0
    80004252:	8526                	mv	a0,s1
    80004254:	825fe0ef          	jal	80002a78 <writei>
    80004258:	47c1                	li	a5,16
    8000425a:	08f51f63          	bne	a0,a5,800042f8 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000425e:	04491703          	lh	a4,68(s2)
    80004262:	4785                	li	a5,1
    80004264:	0af70263          	beq	a4,a5,80004308 <sys_unlink+0x158>
  iunlockput(dp);
    80004268:	8526                	mv	a0,s1
    8000426a:	ecefe0ef          	jal	80002938 <iunlockput>
  ip->nlink--;
    8000426e:	04a95783          	lhu	a5,74(s2)
    80004272:	37fd                	addiw	a5,a5,-1
    80004274:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004278:	854a                	mv	a0,s2
    8000427a:	c00fe0ef          	jal	8000267a <iupdate>
  iunlockput(ip);
    8000427e:	854a                	mv	a0,s2
    80004280:	eb8fe0ef          	jal	80002938 <iunlockput>
  end_op();
    80004284:	dc7fe0ef          	jal	8000304a <end_op>
  return 0;
    80004288:	4501                	li	a0,0
    8000428a:	74ae                	ld	s1,232(sp)
    8000428c:	790e                	ld	s2,224(sp)
    8000428e:	69ee                	ld	s3,216(sp)
    80004290:	a869                	j	8000432a <sys_unlink+0x17a>
    end_op();
    80004292:	db9fe0ef          	jal	8000304a <end_op>
    return -1;
    80004296:	557d                	li	a0,-1
    80004298:	74ae                	ld	s1,232(sp)
    8000429a:	a841                	j	8000432a <sys_unlink+0x17a>
    8000429c:	e9d2                	sd	s4,208(sp)
    8000429e:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    800042a0:	00003517          	auipc	a0,0x3
    800042a4:	3f050513          	addi	a0,a0,1008 # 80007690 <etext+0x690>
    800042a8:	26e010ef          	jal	80005516 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042ac:	04c92703          	lw	a4,76(s2)
    800042b0:	02000793          	li	a5,32
    800042b4:	f8e7f3e3          	bgeu	a5,a4,8000423a <sys_unlink+0x8a>
    800042b8:	e9d2                	sd	s4,208(sp)
    800042ba:	e5d6                	sd	s5,200(sp)
    800042bc:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042be:	f0840a93          	addi	s5,s0,-248
    800042c2:	4a41                	li	s4,16
    800042c4:	8752                	mv	a4,s4
    800042c6:	86ce                	mv	a3,s3
    800042c8:	8656                	mv	a2,s5
    800042ca:	4581                	li	a1,0
    800042cc:	854a                	mv	a0,s2
    800042ce:	eb8fe0ef          	jal	80002986 <readi>
    800042d2:	01451d63          	bne	a0,s4,800042ec <sys_unlink+0x13c>
    if(de.inum != 0)
    800042d6:	f0845783          	lhu	a5,-248(s0)
    800042da:	efb1                	bnez	a5,80004336 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042dc:	29c1                	addiw	s3,s3,16
    800042de:	04c92783          	lw	a5,76(s2)
    800042e2:	fef9e1e3          	bltu	s3,a5,800042c4 <sys_unlink+0x114>
    800042e6:	6a4e                	ld	s4,208(sp)
    800042e8:	6aae                	ld	s5,200(sp)
    800042ea:	bf81                	j	8000423a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800042ec:	00003517          	auipc	a0,0x3
    800042f0:	3bc50513          	addi	a0,a0,956 # 800076a8 <etext+0x6a8>
    800042f4:	222010ef          	jal	80005516 <panic>
    800042f8:	e9d2                	sd	s4,208(sp)
    800042fa:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800042fc:	00003517          	auipc	a0,0x3
    80004300:	3c450513          	addi	a0,a0,964 # 800076c0 <etext+0x6c0>
    80004304:	212010ef          	jal	80005516 <panic>
    dp->nlink--;
    80004308:	04a4d783          	lhu	a5,74(s1)
    8000430c:	37fd                	addiw	a5,a5,-1
    8000430e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004312:	8526                	mv	a0,s1
    80004314:	b66fe0ef          	jal	8000267a <iupdate>
    80004318:	bf81                	j	80004268 <sys_unlink+0xb8>
    8000431a:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    8000431c:	8526                	mv	a0,s1
    8000431e:	e1afe0ef          	jal	80002938 <iunlockput>
  end_op();
    80004322:	d29fe0ef          	jal	8000304a <end_op>
  return -1;
    80004326:	557d                	li	a0,-1
    80004328:	74ae                	ld	s1,232(sp)
}
    8000432a:	70ee                	ld	ra,248(sp)
    8000432c:	744e                	ld	s0,240(sp)
    8000432e:	6111                	addi	sp,sp,256
    80004330:	8082                	ret
    return -1;
    80004332:	557d                	li	a0,-1
    80004334:	bfdd                	j	8000432a <sys_unlink+0x17a>
    iunlockput(ip);
    80004336:	854a                	mv	a0,s2
    80004338:	e00fe0ef          	jal	80002938 <iunlockput>
    goto bad;
    8000433c:	790e                	ld	s2,224(sp)
    8000433e:	69ee                	ld	s3,216(sp)
    80004340:	6a4e                	ld	s4,208(sp)
    80004342:	6aae                	ld	s5,200(sp)
    80004344:	bfe1                	j	8000431c <sys_unlink+0x16c>

0000000080004346 <sys_open>:

uint64
sys_open(void)
{
    80004346:	7131                	addi	sp,sp,-192
    80004348:	fd06                	sd	ra,184(sp)
    8000434a:	f922                	sd	s0,176(sp)
    8000434c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000434e:	f4c40593          	addi	a1,s0,-180
    80004352:	4505                	li	a0,1
    80004354:	93dfd0ef          	jal	80001c90 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004358:	08000613          	li	a2,128
    8000435c:	f5040593          	addi	a1,s0,-176
    80004360:	4501                	li	a0,0
    80004362:	967fd0ef          	jal	80001cc8 <argstr>
    80004366:	87aa                	mv	a5,a0
    return -1;
    80004368:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000436a:	0a07c363          	bltz	a5,80004410 <sys_open+0xca>
    8000436e:	f526                	sd	s1,168(sp)

  begin_op();
    80004370:	c71fe0ef          	jal	80002fe0 <begin_op>

  if(omode & O_CREATE){
    80004374:	f4c42783          	lw	a5,-180(s0)
    80004378:	2007f793          	andi	a5,a5,512
    8000437c:	c3dd                	beqz	a5,80004422 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000437e:	4681                	li	a3,0
    80004380:	4601                	li	a2,0
    80004382:	4589                	li	a1,2
    80004384:	f5040513          	addi	a0,s0,-176
    80004388:	a99ff0ef          	jal	80003e20 <create>
    8000438c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000438e:	c549                	beqz	a0,80004418 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004390:	04449703          	lh	a4,68(s1)
    80004394:	478d                	li	a5,3
    80004396:	00f71763          	bne	a4,a5,800043a4 <sys_open+0x5e>
    8000439a:	0464d703          	lhu	a4,70(s1)
    8000439e:	47a5                	li	a5,9
    800043a0:	0ae7ee63          	bltu	a5,a4,8000445c <sys_open+0x116>
    800043a4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800043a6:	fb7fe0ef          	jal	8000335c <filealloc>
    800043aa:	892a                	mv	s2,a0
    800043ac:	c561                	beqz	a0,80004474 <sys_open+0x12e>
    800043ae:	ed4e                	sd	s3,152(sp)
    800043b0:	a33ff0ef          	jal	80003de2 <fdalloc>
    800043b4:	89aa                	mv	s3,a0
    800043b6:	0a054b63          	bltz	a0,8000446c <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800043ba:	04449703          	lh	a4,68(s1)
    800043be:	478d                	li	a5,3
    800043c0:	0cf70363          	beq	a4,a5,80004486 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043c4:	4789                	li	a5,2
    800043c6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800043ca:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800043ce:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800043d2:	f4c42783          	lw	a5,-180(s0)
    800043d6:	0017f713          	andi	a4,a5,1
    800043da:	00174713          	xori	a4,a4,1
    800043de:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800043e2:	0037f713          	andi	a4,a5,3
    800043e6:	00e03733          	snez	a4,a4
    800043ea:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800043ee:	4007f793          	andi	a5,a5,1024
    800043f2:	c791                	beqz	a5,800043fe <sys_open+0xb8>
    800043f4:	04449703          	lh	a4,68(s1)
    800043f8:	4789                	li	a5,2
    800043fa:	08f70d63          	beq	a4,a5,80004494 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800043fe:	8526                	mv	a0,s1
    80004400:	bdcfe0ef          	jal	800027dc <iunlock>
  end_op();
    80004404:	c47fe0ef          	jal	8000304a <end_op>

  return fd;
    80004408:	854e                	mv	a0,s3
    8000440a:	74aa                	ld	s1,168(sp)
    8000440c:	790a                	ld	s2,160(sp)
    8000440e:	69ea                	ld	s3,152(sp)
}
    80004410:	70ea                	ld	ra,184(sp)
    80004412:	744a                	ld	s0,176(sp)
    80004414:	6129                	addi	sp,sp,192
    80004416:	8082                	ret
      end_op();
    80004418:	c33fe0ef          	jal	8000304a <end_op>
      return -1;
    8000441c:	557d                	li	a0,-1
    8000441e:	74aa                	ld	s1,168(sp)
    80004420:	bfc5                	j	80004410 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004422:	f5040513          	addi	a0,s0,-176
    80004426:	9f9fe0ef          	jal	80002e1e <namei>
    8000442a:	84aa                	mv	s1,a0
    8000442c:	c11d                	beqz	a0,80004452 <sys_open+0x10c>
    ilock(ip);
    8000442e:	b00fe0ef          	jal	8000272e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004432:	04449703          	lh	a4,68(s1)
    80004436:	4785                	li	a5,1
    80004438:	f4f71ce3          	bne	a4,a5,80004390 <sys_open+0x4a>
    8000443c:	f4c42783          	lw	a5,-180(s0)
    80004440:	d3b5                	beqz	a5,800043a4 <sys_open+0x5e>
      iunlockput(ip);
    80004442:	8526                	mv	a0,s1
    80004444:	cf4fe0ef          	jal	80002938 <iunlockput>
      end_op();
    80004448:	c03fe0ef          	jal	8000304a <end_op>
      return -1;
    8000444c:	557d                	li	a0,-1
    8000444e:	74aa                	ld	s1,168(sp)
    80004450:	b7c1                	j	80004410 <sys_open+0xca>
      end_op();
    80004452:	bf9fe0ef          	jal	8000304a <end_op>
      return -1;
    80004456:	557d                	li	a0,-1
    80004458:	74aa                	ld	s1,168(sp)
    8000445a:	bf5d                	j	80004410 <sys_open+0xca>
    iunlockput(ip);
    8000445c:	8526                	mv	a0,s1
    8000445e:	cdafe0ef          	jal	80002938 <iunlockput>
    end_op();
    80004462:	be9fe0ef          	jal	8000304a <end_op>
    return -1;
    80004466:	557d                	li	a0,-1
    80004468:	74aa                	ld	s1,168(sp)
    8000446a:	b75d                	j	80004410 <sys_open+0xca>
      fileclose(f);
    8000446c:	854a                	mv	a0,s2
    8000446e:	f93fe0ef          	jal	80003400 <fileclose>
    80004472:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004474:	8526                	mv	a0,s1
    80004476:	cc2fe0ef          	jal	80002938 <iunlockput>
    end_op();
    8000447a:	bd1fe0ef          	jal	8000304a <end_op>
    return -1;
    8000447e:	557d                	li	a0,-1
    80004480:	74aa                	ld	s1,168(sp)
    80004482:	790a                	ld	s2,160(sp)
    80004484:	b771                	j	80004410 <sys_open+0xca>
    f->type = FD_DEVICE;
    80004486:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000448a:	04649783          	lh	a5,70(s1)
    8000448e:	02f91223          	sh	a5,36(s2)
    80004492:	bf35                	j	800043ce <sys_open+0x88>
    itrunc(ip);
    80004494:	8526                	mv	a0,s1
    80004496:	b86fe0ef          	jal	8000281c <itrunc>
    8000449a:	b795                	j	800043fe <sys_open+0xb8>

000000008000449c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000449c:	7175                	addi	sp,sp,-144
    8000449e:	e506                	sd	ra,136(sp)
    800044a0:	e122                	sd	s0,128(sp)
    800044a2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800044a4:	b3dfe0ef          	jal	80002fe0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800044a8:	08000613          	li	a2,128
    800044ac:	f7040593          	addi	a1,s0,-144
    800044b0:	4501                	li	a0,0
    800044b2:	817fd0ef          	jal	80001cc8 <argstr>
    800044b6:	02054363          	bltz	a0,800044dc <sys_mkdir+0x40>
    800044ba:	4681                	li	a3,0
    800044bc:	4601                	li	a2,0
    800044be:	4585                	li	a1,1
    800044c0:	f7040513          	addi	a0,s0,-144
    800044c4:	95dff0ef          	jal	80003e20 <create>
    800044c8:	c911                	beqz	a0,800044dc <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044ca:	c6efe0ef          	jal	80002938 <iunlockput>
  end_op();
    800044ce:	b7dfe0ef          	jal	8000304a <end_op>
  return 0;
    800044d2:	4501                	li	a0,0
}
    800044d4:	60aa                	ld	ra,136(sp)
    800044d6:	640a                	ld	s0,128(sp)
    800044d8:	6149                	addi	sp,sp,144
    800044da:	8082                	ret
    end_op();
    800044dc:	b6ffe0ef          	jal	8000304a <end_op>
    return -1;
    800044e0:	557d                	li	a0,-1
    800044e2:	bfcd                	j	800044d4 <sys_mkdir+0x38>

00000000800044e4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800044e4:	7135                	addi	sp,sp,-160
    800044e6:	ed06                	sd	ra,152(sp)
    800044e8:	e922                	sd	s0,144(sp)
    800044ea:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800044ec:	af5fe0ef          	jal	80002fe0 <begin_op>
  argint(1, &major);
    800044f0:	f6c40593          	addi	a1,s0,-148
    800044f4:	4505                	li	a0,1
    800044f6:	f9afd0ef          	jal	80001c90 <argint>
  argint(2, &minor);
    800044fa:	f6840593          	addi	a1,s0,-152
    800044fe:	4509                	li	a0,2
    80004500:	f90fd0ef          	jal	80001c90 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004504:	08000613          	li	a2,128
    80004508:	f7040593          	addi	a1,s0,-144
    8000450c:	4501                	li	a0,0
    8000450e:	fbafd0ef          	jal	80001cc8 <argstr>
    80004512:	02054563          	bltz	a0,8000453c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004516:	f6841683          	lh	a3,-152(s0)
    8000451a:	f6c41603          	lh	a2,-148(s0)
    8000451e:	458d                	li	a1,3
    80004520:	f7040513          	addi	a0,s0,-144
    80004524:	8fdff0ef          	jal	80003e20 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004528:	c911                	beqz	a0,8000453c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000452a:	c0efe0ef          	jal	80002938 <iunlockput>
  end_op();
    8000452e:	b1dfe0ef          	jal	8000304a <end_op>
  return 0;
    80004532:	4501                	li	a0,0
}
    80004534:	60ea                	ld	ra,152(sp)
    80004536:	644a                	ld	s0,144(sp)
    80004538:	610d                	addi	sp,sp,160
    8000453a:	8082                	ret
    end_op();
    8000453c:	b0ffe0ef          	jal	8000304a <end_op>
    return -1;
    80004540:	557d                	li	a0,-1
    80004542:	bfcd                	j	80004534 <sys_mknod+0x50>

0000000080004544 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004544:	7135                	addi	sp,sp,-160
    80004546:	ed06                	sd	ra,152(sp)
    80004548:	e922                	sd	s0,144(sp)
    8000454a:	e14a                	sd	s2,128(sp)
    8000454c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000454e:	885fc0ef          	jal	80000dd2 <myproc>
    80004552:	892a                	mv	s2,a0
  
  begin_op();
    80004554:	a8dfe0ef          	jal	80002fe0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004558:	08000613          	li	a2,128
    8000455c:	f6040593          	addi	a1,s0,-160
    80004560:	4501                	li	a0,0
    80004562:	f66fd0ef          	jal	80001cc8 <argstr>
    80004566:	04054363          	bltz	a0,800045ac <sys_chdir+0x68>
    8000456a:	e526                	sd	s1,136(sp)
    8000456c:	f6040513          	addi	a0,s0,-160
    80004570:	8affe0ef          	jal	80002e1e <namei>
    80004574:	84aa                	mv	s1,a0
    80004576:	c915                	beqz	a0,800045aa <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004578:	9b6fe0ef          	jal	8000272e <ilock>
  if(ip->type != T_DIR){
    8000457c:	04449703          	lh	a4,68(s1)
    80004580:	4785                	li	a5,1
    80004582:	02f71963          	bne	a4,a5,800045b4 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004586:	8526                	mv	a0,s1
    80004588:	a54fe0ef          	jal	800027dc <iunlock>
  iput(p->cwd);
    8000458c:	15093503          	ld	a0,336(s2)
    80004590:	b20fe0ef          	jal	800028b0 <iput>
  end_op();
    80004594:	ab7fe0ef          	jal	8000304a <end_op>
  p->cwd = ip;
    80004598:	14993823          	sd	s1,336(s2)
  return 0;
    8000459c:	4501                	li	a0,0
    8000459e:	64aa                	ld	s1,136(sp)
}
    800045a0:	60ea                	ld	ra,152(sp)
    800045a2:	644a                	ld	s0,144(sp)
    800045a4:	690a                	ld	s2,128(sp)
    800045a6:	610d                	addi	sp,sp,160
    800045a8:	8082                	ret
    800045aa:	64aa                	ld	s1,136(sp)
    end_op();
    800045ac:	a9ffe0ef          	jal	8000304a <end_op>
    return -1;
    800045b0:	557d                	li	a0,-1
    800045b2:	b7fd                	j	800045a0 <sys_chdir+0x5c>
    iunlockput(ip);
    800045b4:	8526                	mv	a0,s1
    800045b6:	b82fe0ef          	jal	80002938 <iunlockput>
    end_op();
    800045ba:	a91fe0ef          	jal	8000304a <end_op>
    return -1;
    800045be:	557d                	li	a0,-1
    800045c0:	64aa                	ld	s1,136(sp)
    800045c2:	bff9                	j	800045a0 <sys_chdir+0x5c>

00000000800045c4 <sys_exec>:

uint64
sys_exec(void)
{
    800045c4:	7105                	addi	sp,sp,-480
    800045c6:	ef86                	sd	ra,472(sp)
    800045c8:	eba2                	sd	s0,464(sp)
    800045ca:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045cc:	e2840593          	addi	a1,s0,-472
    800045d0:	4505                	li	a0,1
    800045d2:	edafd0ef          	jal	80001cac <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045d6:	08000613          	li	a2,128
    800045da:	f3040593          	addi	a1,s0,-208
    800045de:	4501                	li	a0,0
    800045e0:	ee8fd0ef          	jal	80001cc8 <argstr>
    800045e4:	87aa                	mv	a5,a0
    return -1;
    800045e6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800045e8:	0e07c063          	bltz	a5,800046c8 <sys_exec+0x104>
    800045ec:	e7a6                	sd	s1,456(sp)
    800045ee:	e3ca                	sd	s2,448(sp)
    800045f0:	ff4e                	sd	s3,440(sp)
    800045f2:	fb52                	sd	s4,432(sp)
    800045f4:	f756                	sd	s5,424(sp)
    800045f6:	f35a                	sd	s6,416(sp)
    800045f8:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800045fa:	e3040a13          	addi	s4,s0,-464
    800045fe:	10000613          	li	a2,256
    80004602:	4581                	li	a1,0
    80004604:	8552                	mv	a0,s4
    80004606:	b8bfb0ef          	jal	80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000460a:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000460c:	89d2                	mv	s3,s4
    8000460e:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004610:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004614:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004616:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000461a:	00391513          	slli	a0,s2,0x3
    8000461e:	85d6                	mv	a1,s5
    80004620:	e2843783          	ld	a5,-472(s0)
    80004624:	953e                	add	a0,a0,a5
    80004626:	de0fd0ef          	jal	80001c06 <fetchaddr>
    8000462a:	02054663          	bltz	a0,80004656 <sys_exec+0x92>
    if(uarg == 0){
    8000462e:	e2043783          	ld	a5,-480(s0)
    80004632:	c7a1                	beqz	a5,8000467a <sys_exec+0xb6>
    argv[i] = kalloc();
    80004634:	acbfb0ef          	jal	800000fe <kalloc>
    80004638:	85aa                	mv	a1,a0
    8000463a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000463e:	cd01                	beqz	a0,80004656 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004640:	865a                	mv	a2,s6
    80004642:	e2043503          	ld	a0,-480(s0)
    80004646:	e0afd0ef          	jal	80001c50 <fetchstr>
    8000464a:	00054663          	bltz	a0,80004656 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000464e:	0905                	addi	s2,s2,1
    80004650:	09a1                	addi	s3,s3,8
    80004652:	fd7914e3          	bne	s2,s7,8000461a <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004656:	100a0a13          	addi	s4,s4,256
    8000465a:	6088                	ld	a0,0(s1)
    8000465c:	cd31                	beqz	a0,800046b8 <sys_exec+0xf4>
    kfree(argv[i]);
    8000465e:	9bffb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004662:	04a1                	addi	s1,s1,8
    80004664:	ff449be3          	bne	s1,s4,8000465a <sys_exec+0x96>
  return -1;
    80004668:	557d                	li	a0,-1
    8000466a:	64be                	ld	s1,456(sp)
    8000466c:	691e                	ld	s2,448(sp)
    8000466e:	79fa                	ld	s3,440(sp)
    80004670:	7a5a                	ld	s4,432(sp)
    80004672:	7aba                	ld	s5,424(sp)
    80004674:	7b1a                	ld	s6,416(sp)
    80004676:	6bfa                	ld	s7,408(sp)
    80004678:	a881                	j	800046c8 <sys_exec+0x104>
      argv[i] = 0;
    8000467a:	0009079b          	sext.w	a5,s2
    8000467e:	e3040593          	addi	a1,s0,-464
    80004682:	078e                	slli	a5,a5,0x3
    80004684:	97ae                	add	a5,a5,a1
    80004686:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    8000468a:	f3040513          	addi	a0,s0,-208
    8000468e:	ba4ff0ef          	jal	80003a32 <exec>
    80004692:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004694:	100a0a13          	addi	s4,s4,256
    80004698:	6088                	ld	a0,0(s1)
    8000469a:	c511                	beqz	a0,800046a6 <sys_exec+0xe2>
    kfree(argv[i]);
    8000469c:	981fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046a0:	04a1                	addi	s1,s1,8
    800046a2:	ff449be3          	bne	s1,s4,80004698 <sys_exec+0xd4>
  return ret;
    800046a6:	854a                	mv	a0,s2
    800046a8:	64be                	ld	s1,456(sp)
    800046aa:	691e                	ld	s2,448(sp)
    800046ac:	79fa                	ld	s3,440(sp)
    800046ae:	7a5a                	ld	s4,432(sp)
    800046b0:	7aba                	ld	s5,424(sp)
    800046b2:	7b1a                	ld	s6,416(sp)
    800046b4:	6bfa                	ld	s7,408(sp)
    800046b6:	a809                	j	800046c8 <sys_exec+0x104>
  return -1;
    800046b8:	557d                	li	a0,-1
    800046ba:	64be                	ld	s1,456(sp)
    800046bc:	691e                	ld	s2,448(sp)
    800046be:	79fa                	ld	s3,440(sp)
    800046c0:	7a5a                	ld	s4,432(sp)
    800046c2:	7aba                	ld	s5,424(sp)
    800046c4:	7b1a                	ld	s6,416(sp)
    800046c6:	6bfa                	ld	s7,408(sp)
}
    800046c8:	60fe                	ld	ra,472(sp)
    800046ca:	645e                	ld	s0,464(sp)
    800046cc:	613d                	addi	sp,sp,480
    800046ce:	8082                	ret

00000000800046d0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800046d0:	7139                	addi	sp,sp,-64
    800046d2:	fc06                	sd	ra,56(sp)
    800046d4:	f822                	sd	s0,48(sp)
    800046d6:	f426                	sd	s1,40(sp)
    800046d8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046da:	ef8fc0ef          	jal	80000dd2 <myproc>
    800046de:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046e0:	fd840593          	addi	a1,s0,-40
    800046e4:	4501                	li	a0,0
    800046e6:	dc6fd0ef          	jal	80001cac <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046ea:	fc840593          	addi	a1,s0,-56
    800046ee:	fd040513          	addi	a0,s0,-48
    800046f2:	81eff0ef          	jal	80003710 <pipealloc>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046f8:	0a054463          	bltz	a0,800047a0 <sys_pipe+0xd0>
  fd0 = -1;
    800046fc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004700:	fd043503          	ld	a0,-48(s0)
    80004704:	edeff0ef          	jal	80003de2 <fdalloc>
    80004708:	fca42223          	sw	a0,-60(s0)
    8000470c:	08054163          	bltz	a0,8000478e <sys_pipe+0xbe>
    80004710:	fc843503          	ld	a0,-56(s0)
    80004714:	eceff0ef          	jal	80003de2 <fdalloc>
    80004718:	fca42023          	sw	a0,-64(s0)
    8000471c:	06054063          	bltz	a0,8000477c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004720:	4691                	li	a3,4
    80004722:	fc440613          	addi	a2,s0,-60
    80004726:	fd843583          	ld	a1,-40(s0)
    8000472a:	68a8                	ld	a0,80(s1)
    8000472c:	b1afc0ef          	jal	80000a46 <copyout>
    80004730:	00054e63          	bltz	a0,8000474c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004734:	4691                	li	a3,4
    80004736:	fc040613          	addi	a2,s0,-64
    8000473a:	fd843583          	ld	a1,-40(s0)
    8000473e:	95b6                	add	a1,a1,a3
    80004740:	68a8                	ld	a0,80(s1)
    80004742:	b04fc0ef          	jal	80000a46 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004746:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004748:	04055c63          	bgez	a0,800047a0 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000474c:	fc442783          	lw	a5,-60(s0)
    80004750:	07e9                	addi	a5,a5,26
    80004752:	078e                	slli	a5,a5,0x3
    80004754:	97a6                	add	a5,a5,s1
    80004756:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000475a:	fc042783          	lw	a5,-64(s0)
    8000475e:	07e9                	addi	a5,a5,26
    80004760:	078e                	slli	a5,a5,0x3
    80004762:	94be                	add	s1,s1,a5
    80004764:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004768:	fd043503          	ld	a0,-48(s0)
    8000476c:	c95fe0ef          	jal	80003400 <fileclose>
    fileclose(wf);
    80004770:	fc843503          	ld	a0,-56(s0)
    80004774:	c8dfe0ef          	jal	80003400 <fileclose>
    return -1;
    80004778:	57fd                	li	a5,-1
    8000477a:	a01d                	j	800047a0 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000477c:	fc442783          	lw	a5,-60(s0)
    80004780:	0007c763          	bltz	a5,8000478e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004784:	07e9                	addi	a5,a5,26
    80004786:	078e                	slli	a5,a5,0x3
    80004788:	97a6                	add	a5,a5,s1
    8000478a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000478e:	fd043503          	ld	a0,-48(s0)
    80004792:	c6ffe0ef          	jal	80003400 <fileclose>
    fileclose(wf);
    80004796:	fc843503          	ld	a0,-56(s0)
    8000479a:	c67fe0ef          	jal	80003400 <fileclose>
    return -1;
    8000479e:	57fd                	li	a5,-1
}
    800047a0:	853e                	mv	a0,a5
    800047a2:	70e2                	ld	ra,56(sp)
    800047a4:	7442                	ld	s0,48(sp)
    800047a6:	74a2                	ld	s1,40(sp)
    800047a8:	6121                	addi	sp,sp,64
    800047aa:	8082                	ret
    800047ac:	0000                	unimp
	...

00000000800047b0 <kernelvec>:
    800047b0:	7111                	addi	sp,sp,-256
    800047b2:	e006                	sd	ra,0(sp)
    800047b4:	e40a                	sd	sp,8(sp)
    800047b6:	e80e                	sd	gp,16(sp)
    800047b8:	ec12                	sd	tp,24(sp)
    800047ba:	f016                	sd	t0,32(sp)
    800047bc:	f41a                	sd	t1,40(sp)
    800047be:	f81e                	sd	t2,48(sp)
    800047c0:	e4aa                	sd	a0,72(sp)
    800047c2:	e8ae                	sd	a1,80(sp)
    800047c4:	ecb2                	sd	a2,88(sp)
    800047c6:	f0b6                	sd	a3,96(sp)
    800047c8:	f4ba                	sd	a4,104(sp)
    800047ca:	f8be                	sd	a5,112(sp)
    800047cc:	fcc2                	sd	a6,120(sp)
    800047ce:	e146                	sd	a7,128(sp)
    800047d0:	edf2                	sd	t3,216(sp)
    800047d2:	f1f6                	sd	t4,224(sp)
    800047d4:	f5fa                	sd	t5,232(sp)
    800047d6:	f9fe                	sd	t6,240(sp)
    800047d8:	b3efd0ef          	jal	80001b16 <kerneltrap>
    800047dc:	6082                	ld	ra,0(sp)
    800047de:	6122                	ld	sp,8(sp)
    800047e0:	61c2                	ld	gp,16(sp)
    800047e2:	7282                	ld	t0,32(sp)
    800047e4:	7322                	ld	t1,40(sp)
    800047e6:	73c2                	ld	t2,48(sp)
    800047e8:	6526                	ld	a0,72(sp)
    800047ea:	65c6                	ld	a1,80(sp)
    800047ec:	6666                	ld	a2,88(sp)
    800047ee:	7686                	ld	a3,96(sp)
    800047f0:	7726                	ld	a4,104(sp)
    800047f2:	77c6                	ld	a5,112(sp)
    800047f4:	7866                	ld	a6,120(sp)
    800047f6:	688a                	ld	a7,128(sp)
    800047f8:	6e6e                	ld	t3,216(sp)
    800047fa:	7e8e                	ld	t4,224(sp)
    800047fc:	7f2e                	ld	t5,232(sp)
    800047fe:	7fce                	ld	t6,240(sp)
    80004800:	6111                	addi	sp,sp,256
    80004802:	10200073          	sret
	...

000000008000480e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000480e:	1141                	addi	sp,sp,-16
    80004810:	e406                	sd	ra,8(sp)
    80004812:	e022                	sd	s0,0(sp)
    80004814:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004816:	0c000737          	lui	a4,0xc000
    8000481a:	4785                	li	a5,1
    8000481c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000481e:	c35c                	sw	a5,4(a4)
}
    80004820:	60a2                	ld	ra,8(sp)
    80004822:	6402                	ld	s0,0(sp)
    80004824:	0141                	addi	sp,sp,16
    80004826:	8082                	ret

0000000080004828 <plicinithart>:

void
plicinithart(void)
{
    80004828:	1141                	addi	sp,sp,-16
    8000482a:	e406                	sd	ra,8(sp)
    8000482c:	e022                	sd	s0,0(sp)
    8000482e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004830:	d6efc0ef          	jal	80000d9e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004834:	0085171b          	slliw	a4,a0,0x8
    80004838:	0c0027b7          	lui	a5,0xc002
    8000483c:	97ba                	add	a5,a5,a4
    8000483e:	40200713          	li	a4,1026
    80004842:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004846:	00d5151b          	slliw	a0,a0,0xd
    8000484a:	0c2017b7          	lui	a5,0xc201
    8000484e:	97aa                	add	a5,a5,a0
    80004850:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004854:	60a2                	ld	ra,8(sp)
    80004856:	6402                	ld	s0,0(sp)
    80004858:	0141                	addi	sp,sp,16
    8000485a:	8082                	ret

000000008000485c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000485c:	1141                	addi	sp,sp,-16
    8000485e:	e406                	sd	ra,8(sp)
    80004860:	e022                	sd	s0,0(sp)
    80004862:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004864:	d3afc0ef          	jal	80000d9e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004868:	00d5151b          	slliw	a0,a0,0xd
    8000486c:	0c2017b7          	lui	a5,0xc201
    80004870:	97aa                	add	a5,a5,a0
  return irq;
}
    80004872:	43c8                	lw	a0,4(a5)
    80004874:	60a2                	ld	ra,8(sp)
    80004876:	6402                	ld	s0,0(sp)
    80004878:	0141                	addi	sp,sp,16
    8000487a:	8082                	ret

000000008000487c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000487c:	1101                	addi	sp,sp,-32
    8000487e:	ec06                	sd	ra,24(sp)
    80004880:	e822                	sd	s0,16(sp)
    80004882:	e426                	sd	s1,8(sp)
    80004884:	1000                	addi	s0,sp,32
    80004886:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004888:	d16fc0ef          	jal	80000d9e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000488c:	00d5179b          	slliw	a5,a0,0xd
    80004890:	0c201737          	lui	a4,0xc201
    80004894:	97ba                	add	a5,a5,a4
    80004896:	c3c4                	sw	s1,4(a5)
}
    80004898:	60e2                	ld	ra,24(sp)
    8000489a:	6442                	ld	s0,16(sp)
    8000489c:	64a2                	ld	s1,8(sp)
    8000489e:	6105                	addi	sp,sp,32
    800048a0:	8082                	ret

00000000800048a2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800048a2:	1141                	addi	sp,sp,-16
    800048a4:	e406                	sd	ra,8(sp)
    800048a6:	e022                	sd	s0,0(sp)
    800048a8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800048aa:	479d                	li	a5,7
    800048ac:	04a7ca63          	blt	a5,a0,80004900 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800048b0:	00017797          	auipc	a5,0x17
    800048b4:	f3078793          	addi	a5,a5,-208 # 8001b7e0 <disk>
    800048b8:	97aa                	add	a5,a5,a0
    800048ba:	0187c783          	lbu	a5,24(a5)
    800048be:	e7b9                	bnez	a5,8000490c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800048c0:	00451693          	slli	a3,a0,0x4
    800048c4:	00017797          	auipc	a5,0x17
    800048c8:	f1c78793          	addi	a5,a5,-228 # 8001b7e0 <disk>
    800048cc:	6398                	ld	a4,0(a5)
    800048ce:	9736                	add	a4,a4,a3
    800048d0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800048d4:	6398                	ld	a4,0(a5)
    800048d6:	9736                	add	a4,a4,a3
    800048d8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048dc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800048e0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800048e4:	97aa                	add	a5,a5,a0
    800048e6:	4705                	li	a4,1
    800048e8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800048ec:	00017517          	auipc	a0,0x17
    800048f0:	f0c50513          	addi	a0,a0,-244 # 8001b7f8 <disk+0x18>
    800048f4:	b05fc0ef          	jal	800013f8 <wakeup>
}
    800048f8:	60a2                	ld	ra,8(sp)
    800048fa:	6402                	ld	s0,0(sp)
    800048fc:	0141                	addi	sp,sp,16
    800048fe:	8082                	ret
    panic("free_desc 1");
    80004900:	00003517          	auipc	a0,0x3
    80004904:	dd050513          	addi	a0,a0,-560 # 800076d0 <etext+0x6d0>
    80004908:	40f000ef          	jal	80005516 <panic>
    panic("free_desc 2");
    8000490c:	00003517          	auipc	a0,0x3
    80004910:	dd450513          	addi	a0,a0,-556 # 800076e0 <etext+0x6e0>
    80004914:	403000ef          	jal	80005516 <panic>

0000000080004918 <virtio_disk_init>:
{
    80004918:	1101                	addi	sp,sp,-32
    8000491a:	ec06                	sd	ra,24(sp)
    8000491c:	e822                	sd	s0,16(sp)
    8000491e:	e426                	sd	s1,8(sp)
    80004920:	e04a                	sd	s2,0(sp)
    80004922:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004924:	00003597          	auipc	a1,0x3
    80004928:	dcc58593          	addi	a1,a1,-564 # 800076f0 <etext+0x6f0>
    8000492c:	00017517          	auipc	a0,0x17
    80004930:	fdc50513          	addi	a0,a0,-36 # 8001b908 <disk+0x128>
    80004934:	68d000ef          	jal	800057c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004938:	100017b7          	lui	a5,0x10001
    8000493c:	4398                	lw	a4,0(a5)
    8000493e:	2701                	sext.w	a4,a4
    80004940:	747277b7          	lui	a5,0x74727
    80004944:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004948:	14f71863          	bne	a4,a5,80004a98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000494c:	100017b7          	lui	a5,0x10001
    80004950:	43dc                	lw	a5,4(a5)
    80004952:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004954:	4709                	li	a4,2
    80004956:	14e79163          	bne	a5,a4,80004a98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000495a:	100017b7          	lui	a5,0x10001
    8000495e:	479c                	lw	a5,8(a5)
    80004960:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004962:	12e79b63          	bne	a5,a4,80004a98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004966:	100017b7          	lui	a5,0x10001
    8000496a:	47d8                	lw	a4,12(a5)
    8000496c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000496e:	554d47b7          	lui	a5,0x554d4
    80004972:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004976:	12f71163          	bne	a4,a5,80004a98 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000497a:	100017b7          	lui	a5,0x10001
    8000497e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004982:	4705                	li	a4,1
    80004984:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004986:	470d                	li	a4,3
    80004988:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000498a:	10001737          	lui	a4,0x10001
    8000498e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004990:	c7ffe6b7          	lui	a3,0xc7ffe
    80004994:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdad3f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004998:	8f75                	and	a4,a4,a3
    8000499a:	100016b7          	lui	a3,0x10001
    8000499e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049a0:	472d                	li	a4,11
    800049a2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049a4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800049a8:	439c                	lw	a5,0(a5)
    800049aa:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800049ae:	8ba1                	andi	a5,a5,8
    800049b0:	0e078a63          	beqz	a5,80004aa4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800049b4:	100017b7          	lui	a5,0x10001
    800049b8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800049bc:	43fc                	lw	a5,68(a5)
    800049be:	2781                	sext.w	a5,a5
    800049c0:	0e079863          	bnez	a5,80004ab0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800049c4:	100017b7          	lui	a5,0x10001
    800049c8:	5bdc                	lw	a5,52(a5)
    800049ca:	2781                	sext.w	a5,a5
  if(max == 0)
    800049cc:	0e078863          	beqz	a5,80004abc <virtio_disk_init+0x1a4>
  if(max < NUM)
    800049d0:	471d                	li	a4,7
    800049d2:	0ef77b63          	bgeu	a4,a5,80004ac8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800049d6:	f28fb0ef          	jal	800000fe <kalloc>
    800049da:	00017497          	auipc	s1,0x17
    800049de:	e0648493          	addi	s1,s1,-506 # 8001b7e0 <disk>
    800049e2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800049e4:	f1afb0ef          	jal	800000fe <kalloc>
    800049e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800049ea:	f14fb0ef          	jal	800000fe <kalloc>
    800049ee:	87aa                	mv	a5,a0
    800049f0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800049f2:	6088                	ld	a0,0(s1)
    800049f4:	0e050063          	beqz	a0,80004ad4 <virtio_disk_init+0x1bc>
    800049f8:	00017717          	auipc	a4,0x17
    800049fc:	df073703          	ld	a4,-528(a4) # 8001b7e8 <disk+0x8>
    80004a00:	cb71                	beqz	a4,80004ad4 <virtio_disk_init+0x1bc>
    80004a02:	cbe9                	beqz	a5,80004ad4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004a04:	6605                	lui	a2,0x1
    80004a06:	4581                	li	a1,0
    80004a08:	f88fb0ef          	jal	80000190 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a0c:	00017497          	auipc	s1,0x17
    80004a10:	dd448493          	addi	s1,s1,-556 # 8001b7e0 <disk>
    80004a14:	6605                	lui	a2,0x1
    80004a16:	4581                	li	a1,0
    80004a18:	6488                	ld	a0,8(s1)
    80004a1a:	f76fb0ef          	jal	80000190 <memset>
  memset(disk.used, 0, PGSIZE);
    80004a1e:	6605                	lui	a2,0x1
    80004a20:	4581                	li	a1,0
    80004a22:	6888                	ld	a0,16(s1)
    80004a24:	f6cfb0ef          	jal	80000190 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a28:	100017b7          	lui	a5,0x10001
    80004a2c:	4721                	li	a4,8
    80004a2e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a30:	4098                	lw	a4,0(s1)
    80004a32:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a36:	40d8                	lw	a4,4(s1)
    80004a38:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a3c:	649c                	ld	a5,8(s1)
    80004a3e:	0007869b          	sext.w	a3,a5
    80004a42:	10001737          	lui	a4,0x10001
    80004a46:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a4a:	9781                	srai	a5,a5,0x20
    80004a4c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a50:	689c                	ld	a5,16(s1)
    80004a52:	0007869b          	sext.w	a3,a5
    80004a56:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a5a:	9781                	srai	a5,a5,0x20
    80004a5c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a60:	4785                	li	a5,1
    80004a62:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004a64:	00f48c23          	sb	a5,24(s1)
    80004a68:	00f48ca3          	sb	a5,25(s1)
    80004a6c:	00f48d23          	sb	a5,26(s1)
    80004a70:	00f48da3          	sb	a5,27(s1)
    80004a74:	00f48e23          	sb	a5,28(s1)
    80004a78:	00f48ea3          	sb	a5,29(s1)
    80004a7c:	00f48f23          	sb	a5,30(s1)
    80004a80:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a84:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a88:	07272823          	sw	s2,112(a4)
}
    80004a8c:	60e2                	ld	ra,24(sp)
    80004a8e:	6442                	ld	s0,16(sp)
    80004a90:	64a2                	ld	s1,8(sp)
    80004a92:	6902                	ld	s2,0(sp)
    80004a94:	6105                	addi	sp,sp,32
    80004a96:	8082                	ret
    panic("could not find virtio disk");
    80004a98:	00003517          	auipc	a0,0x3
    80004a9c:	c6850513          	addi	a0,a0,-920 # 80007700 <etext+0x700>
    80004aa0:	277000ef          	jal	80005516 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004aa4:	00003517          	auipc	a0,0x3
    80004aa8:	c7c50513          	addi	a0,a0,-900 # 80007720 <etext+0x720>
    80004aac:	26b000ef          	jal	80005516 <panic>
    panic("virtio disk should not be ready");
    80004ab0:	00003517          	auipc	a0,0x3
    80004ab4:	c9050513          	addi	a0,a0,-880 # 80007740 <etext+0x740>
    80004ab8:	25f000ef          	jal	80005516 <panic>
    panic("virtio disk has no queue 0");
    80004abc:	00003517          	auipc	a0,0x3
    80004ac0:	ca450513          	addi	a0,a0,-860 # 80007760 <etext+0x760>
    80004ac4:	253000ef          	jal	80005516 <panic>
    panic("virtio disk max queue too short");
    80004ac8:	00003517          	auipc	a0,0x3
    80004acc:	cb850513          	addi	a0,a0,-840 # 80007780 <etext+0x780>
    80004ad0:	247000ef          	jal	80005516 <panic>
    panic("virtio disk kalloc");
    80004ad4:	00003517          	auipc	a0,0x3
    80004ad8:	ccc50513          	addi	a0,a0,-820 # 800077a0 <etext+0x7a0>
    80004adc:	23b000ef          	jal	80005516 <panic>

0000000080004ae0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ae0:	711d                	addi	sp,sp,-96
    80004ae2:	ec86                	sd	ra,88(sp)
    80004ae4:	e8a2                	sd	s0,80(sp)
    80004ae6:	e4a6                	sd	s1,72(sp)
    80004ae8:	e0ca                	sd	s2,64(sp)
    80004aea:	fc4e                	sd	s3,56(sp)
    80004aec:	f852                	sd	s4,48(sp)
    80004aee:	f456                	sd	s5,40(sp)
    80004af0:	f05a                	sd	s6,32(sp)
    80004af2:	ec5e                	sd	s7,24(sp)
    80004af4:	e862                	sd	s8,16(sp)
    80004af6:	1080                	addi	s0,sp,96
    80004af8:	89aa                	mv	s3,a0
    80004afa:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004afc:	00c52b83          	lw	s7,12(a0)
    80004b00:	001b9b9b          	slliw	s7,s7,0x1
    80004b04:	1b82                	slli	s7,s7,0x20
    80004b06:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004b0a:	00017517          	auipc	a0,0x17
    80004b0e:	dfe50513          	addi	a0,a0,-514 # 8001b908 <disk+0x128>
    80004b12:	533000ef          	jal	80005844 <acquire>
  for(int i = 0; i < NUM; i++){
    80004b16:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b18:	00017a97          	auipc	s5,0x17
    80004b1c:	cc8a8a93          	addi	s5,s5,-824 # 8001b7e0 <disk>
  for(int i = 0; i < 3; i++){
    80004b20:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004b22:	5c7d                	li	s8,-1
    80004b24:	a095                	j	80004b88 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004b26:	00fa8733          	add	a4,s5,a5
    80004b2a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004b2e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b30:	0207c563          	bltz	a5,80004b5a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004b34:	2905                	addiw	s2,s2,1
    80004b36:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b38:	05490c63          	beq	s2,s4,80004b90 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004b3c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b3e:	00017717          	auipc	a4,0x17
    80004b42:	ca270713          	addi	a4,a4,-862 # 8001b7e0 <disk>
    80004b46:	4781                	li	a5,0
    if(disk.free[i]){
    80004b48:	01874683          	lbu	a3,24(a4)
    80004b4c:	fee9                	bnez	a3,80004b26 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004b4e:	2785                	addiw	a5,a5,1
    80004b50:	0705                	addi	a4,a4,1
    80004b52:	fe979be3          	bne	a5,s1,80004b48 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004b56:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004b5a:	01205d63          	blez	s2,80004b74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004b5e:	fa042503          	lw	a0,-96(s0)
    80004b62:	d41ff0ef          	jal	800048a2 <free_desc>
      for(int j = 0; j < i; j++)
    80004b66:	4785                	li	a5,1
    80004b68:	0127d663          	bge	a5,s2,80004b74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004b6c:	fa442503          	lw	a0,-92(s0)
    80004b70:	d33ff0ef          	jal	800048a2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b74:	00017597          	auipc	a1,0x17
    80004b78:	d9458593          	addi	a1,a1,-620 # 8001b908 <disk+0x128>
    80004b7c:	00017517          	auipc	a0,0x17
    80004b80:	c7c50513          	addi	a0,a0,-900 # 8001b7f8 <disk+0x18>
    80004b84:	829fc0ef          	jal	800013ac <sleep>
  for(int i = 0; i < 3; i++){
    80004b88:	fa040613          	addi	a2,s0,-96
    80004b8c:	4901                	li	s2,0
    80004b8e:	b77d                	j	80004b3c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b90:	fa042503          	lw	a0,-96(s0)
    80004b94:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b98:	00017797          	auipc	a5,0x17
    80004b9c:	c4878793          	addi	a5,a5,-952 # 8001b7e0 <disk>
    80004ba0:	00a50713          	addi	a4,a0,10
    80004ba4:	0712                	slli	a4,a4,0x4
    80004ba6:	973e                	add	a4,a4,a5
    80004ba8:	01603633          	snez	a2,s6
    80004bac:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004bae:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004bb2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004bb6:	6398                	ld	a4,0(a5)
    80004bb8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004bba:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004bbe:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004bc0:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004bc2:	6390                	ld	a2,0(a5)
    80004bc4:	00d605b3          	add	a1,a2,a3
    80004bc8:	4741                	li	a4,16
    80004bca:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004bcc:	4805                	li	a6,1
    80004bce:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004bd2:	fa442703          	lw	a4,-92(s0)
    80004bd6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004bda:	0712                	slli	a4,a4,0x4
    80004bdc:	963a                	add	a2,a2,a4
    80004bde:	05898593          	addi	a1,s3,88
    80004be2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004be4:	0007b883          	ld	a7,0(a5)
    80004be8:	9746                	add	a4,a4,a7
    80004bea:	40000613          	li	a2,1024
    80004bee:	c710                	sw	a2,8(a4)
  if(write)
    80004bf0:	001b3613          	seqz	a2,s6
    80004bf4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004bf8:	01066633          	or	a2,a2,a6
    80004bfc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c00:	fa842583          	lw	a1,-88(s0)
    80004c04:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c08:	00250613          	addi	a2,a0,2
    80004c0c:	0612                	slli	a2,a2,0x4
    80004c0e:	963e                	add	a2,a2,a5
    80004c10:	577d                	li	a4,-1
    80004c12:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004c16:	0592                	slli	a1,a1,0x4
    80004c18:	98ae                	add	a7,a7,a1
    80004c1a:	03068713          	addi	a4,a3,48
    80004c1e:	973e                	add	a4,a4,a5
    80004c20:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004c24:	6398                	ld	a4,0(a5)
    80004c26:	972e                	add	a4,a4,a1
    80004c28:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c2c:	4689                	li	a3,2
    80004c2e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c32:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c36:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004c3a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c3e:	6794                	ld	a3,8(a5)
    80004c40:	0026d703          	lhu	a4,2(a3)
    80004c44:	8b1d                	andi	a4,a4,7
    80004c46:	0706                	slli	a4,a4,0x1
    80004c48:	96ba                	add	a3,a3,a4
    80004c4a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004c4e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c52:	6798                	ld	a4,8(a5)
    80004c54:	00275783          	lhu	a5,2(a4)
    80004c58:	2785                	addiw	a5,a5,1
    80004c5a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c5e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c62:	100017b7          	lui	a5,0x10001
    80004c66:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c6a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004c6e:	00017917          	auipc	s2,0x17
    80004c72:	c9a90913          	addi	s2,s2,-870 # 8001b908 <disk+0x128>
  while(b->disk == 1) {
    80004c76:	84c2                	mv	s1,a6
    80004c78:	01079a63          	bne	a5,a6,80004c8c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004c7c:	85ca                	mv	a1,s2
    80004c7e:	854e                	mv	a0,s3
    80004c80:	f2cfc0ef          	jal	800013ac <sleep>
  while(b->disk == 1) {
    80004c84:	0049a783          	lw	a5,4(s3)
    80004c88:	fe978ae3          	beq	a5,s1,80004c7c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004c8c:	fa042903          	lw	s2,-96(s0)
    80004c90:	00290713          	addi	a4,s2,2
    80004c94:	0712                	slli	a4,a4,0x4
    80004c96:	00017797          	auipc	a5,0x17
    80004c9a:	b4a78793          	addi	a5,a5,-1206 # 8001b7e0 <disk>
    80004c9e:	97ba                	add	a5,a5,a4
    80004ca0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004ca4:	00017997          	auipc	s3,0x17
    80004ca8:	b3c98993          	addi	s3,s3,-1220 # 8001b7e0 <disk>
    80004cac:	00491713          	slli	a4,s2,0x4
    80004cb0:	0009b783          	ld	a5,0(s3)
    80004cb4:	97ba                	add	a5,a5,a4
    80004cb6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004cba:	854a                	mv	a0,s2
    80004cbc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004cc0:	be3ff0ef          	jal	800048a2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004cc4:	8885                	andi	s1,s1,1
    80004cc6:	f0fd                	bnez	s1,80004cac <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004cc8:	00017517          	auipc	a0,0x17
    80004ccc:	c4050513          	addi	a0,a0,-960 # 8001b908 <disk+0x128>
    80004cd0:	409000ef          	jal	800058d8 <release>
}
    80004cd4:	60e6                	ld	ra,88(sp)
    80004cd6:	6446                	ld	s0,80(sp)
    80004cd8:	64a6                	ld	s1,72(sp)
    80004cda:	6906                	ld	s2,64(sp)
    80004cdc:	79e2                	ld	s3,56(sp)
    80004cde:	7a42                	ld	s4,48(sp)
    80004ce0:	7aa2                	ld	s5,40(sp)
    80004ce2:	7b02                	ld	s6,32(sp)
    80004ce4:	6be2                	ld	s7,24(sp)
    80004ce6:	6c42                	ld	s8,16(sp)
    80004ce8:	6125                	addi	sp,sp,96
    80004cea:	8082                	ret

0000000080004cec <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004cec:	1101                	addi	sp,sp,-32
    80004cee:	ec06                	sd	ra,24(sp)
    80004cf0:	e822                	sd	s0,16(sp)
    80004cf2:	e426                	sd	s1,8(sp)
    80004cf4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004cf6:	00017497          	auipc	s1,0x17
    80004cfa:	aea48493          	addi	s1,s1,-1302 # 8001b7e0 <disk>
    80004cfe:	00017517          	auipc	a0,0x17
    80004d02:	c0a50513          	addi	a0,a0,-1014 # 8001b908 <disk+0x128>
    80004d06:	33f000ef          	jal	80005844 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d0a:	100017b7          	lui	a5,0x10001
    80004d0e:	53bc                	lw	a5,96(a5)
    80004d10:	8b8d                	andi	a5,a5,3
    80004d12:	10001737          	lui	a4,0x10001
    80004d16:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004d18:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d1c:	689c                	ld	a5,16(s1)
    80004d1e:	0204d703          	lhu	a4,32(s1)
    80004d22:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d26:	04f70663          	beq	a4,a5,80004d72 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004d2a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d2e:	6898                	ld	a4,16(s1)
    80004d30:	0204d783          	lhu	a5,32(s1)
    80004d34:	8b9d                	andi	a5,a5,7
    80004d36:	078e                	slli	a5,a5,0x3
    80004d38:	97ba                	add	a5,a5,a4
    80004d3a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d3c:	00278713          	addi	a4,a5,2
    80004d40:	0712                	slli	a4,a4,0x4
    80004d42:	9726                	add	a4,a4,s1
    80004d44:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004d48:	e321                	bnez	a4,80004d88 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d4a:	0789                	addi	a5,a5,2
    80004d4c:	0792                	slli	a5,a5,0x4
    80004d4e:	97a6                	add	a5,a5,s1
    80004d50:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d52:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d56:	ea2fc0ef          	jal	800013f8 <wakeup>

    disk.used_idx += 1;
    80004d5a:	0204d783          	lhu	a5,32(s1)
    80004d5e:	2785                	addiw	a5,a5,1
    80004d60:	17c2                	slli	a5,a5,0x30
    80004d62:	93c1                	srli	a5,a5,0x30
    80004d64:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d68:	6898                	ld	a4,16(s1)
    80004d6a:	00275703          	lhu	a4,2(a4)
    80004d6e:	faf71ee3          	bne	a4,a5,80004d2a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d72:	00017517          	auipc	a0,0x17
    80004d76:	b9650513          	addi	a0,a0,-1130 # 8001b908 <disk+0x128>
    80004d7a:	35f000ef          	jal	800058d8 <release>
}
    80004d7e:	60e2                	ld	ra,24(sp)
    80004d80:	6442                	ld	s0,16(sp)
    80004d82:	64a2                	ld	s1,8(sp)
    80004d84:	6105                	addi	sp,sp,32
    80004d86:	8082                	ret
      panic("virtio_disk_intr status");
    80004d88:	00003517          	auipc	a0,0x3
    80004d8c:	a3050513          	addi	a0,a0,-1488 # 800077b8 <etext+0x7b8>
    80004d90:	786000ef          	jal	80005516 <panic>

0000000080004d94 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d94:	1141                	addi	sp,sp,-16
    80004d96:	e406                	sd	ra,8(sp)
    80004d98:	e022                	sd	s0,0(sp)
    80004d9a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d9c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004da0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004da4:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004da8:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004dac:	577d                	li	a4,-1
    80004dae:	177e                	slli	a4,a4,0x3f
    80004db0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004db2:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004db6:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004dba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004dbe:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004dc2:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004dc6:	000f4737          	lui	a4,0xf4
    80004dca:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004dce:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004dd0:	14d79073          	csrw	stimecmp,a5
}
    80004dd4:	60a2                	ld	ra,8(sp)
    80004dd6:	6402                	ld	s0,0(sp)
    80004dd8:	0141                	addi	sp,sp,16
    80004dda:	8082                	ret

0000000080004ddc <start>:
{
    80004ddc:	1141                	addi	sp,sp,-16
    80004dde:	e406                	sd	ra,8(sp)
    80004de0:	e022                	sd	s0,0(sp)
    80004de2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004de4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004de8:	7779                	lui	a4,0xffffe
    80004dea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaddf>
    80004dee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004df0:	6705                	lui	a4,0x1
    80004df2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004df6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004df8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004dfc:	ffffb797          	auipc	a5,0xffffb
    80004e00:	54a78793          	addi	a5,a5,1354 # 80000346 <main>
    80004e04:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e08:	4781                	li	a5,0
    80004e0a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e0e:	67c1                	lui	a5,0x10
    80004e10:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e12:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e16:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e1a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004e1e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e22:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e26:	57fd                	li	a5,-1
    80004e28:	83a9                	srli	a5,a5,0xa
    80004e2a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e2e:	47bd                	li	a5,15
    80004e30:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e34:	f61ff0ef          	jal	80004d94 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e38:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e3c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e3e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e40:	30200073          	mret
}
    80004e44:	60a2                	ld	ra,8(sp)
    80004e46:	6402                	ld	s0,0(sp)
    80004e48:	0141                	addi	sp,sp,16
    80004e4a:	8082                	ret

0000000080004e4c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e4c:	711d                	addi	sp,sp,-96
    80004e4e:	ec86                	sd	ra,88(sp)
    80004e50:	e8a2                	sd	s0,80(sp)
    80004e52:	e0ca                	sd	s2,64(sp)
    80004e54:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004e56:	04c05863          	blez	a2,80004ea6 <consolewrite+0x5a>
    80004e5a:	e4a6                	sd	s1,72(sp)
    80004e5c:	fc4e                	sd	s3,56(sp)
    80004e5e:	f852                	sd	s4,48(sp)
    80004e60:	f456                	sd	s5,40(sp)
    80004e62:	f05a                	sd	s6,32(sp)
    80004e64:	ec5e                	sd	s7,24(sp)
    80004e66:	8a2a                	mv	s4,a0
    80004e68:	84ae                	mv	s1,a1
    80004e6a:	89b2                	mv	s3,a2
    80004e6c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004e6e:	faf40b93          	addi	s7,s0,-81
    80004e72:	4b05                	li	s6,1
    80004e74:	5afd                	li	s5,-1
    80004e76:	86da                	mv	a3,s6
    80004e78:	8626                	mv	a2,s1
    80004e7a:	85d2                	mv	a1,s4
    80004e7c:	855e                	mv	a0,s7
    80004e7e:	8cffc0ef          	jal	8000174c <either_copyin>
    80004e82:	03550463          	beq	a0,s5,80004eaa <consolewrite+0x5e>
      break;
    uartputc(c);
    80004e86:	faf44503          	lbu	a0,-81(s0)
    80004e8a:	02d000ef          	jal	800056b6 <uartputc>
  for(i = 0; i < n; i++){
    80004e8e:	2905                	addiw	s2,s2,1
    80004e90:	0485                	addi	s1,s1,1
    80004e92:	ff2992e3          	bne	s3,s2,80004e76 <consolewrite+0x2a>
    80004e96:	894e                	mv	s2,s3
    80004e98:	64a6                	ld	s1,72(sp)
    80004e9a:	79e2                	ld	s3,56(sp)
    80004e9c:	7a42                	ld	s4,48(sp)
    80004e9e:	7aa2                	ld	s5,40(sp)
    80004ea0:	7b02                	ld	s6,32(sp)
    80004ea2:	6be2                	ld	s7,24(sp)
    80004ea4:	a809                	j	80004eb6 <consolewrite+0x6a>
    80004ea6:	4901                	li	s2,0
    80004ea8:	a039                	j	80004eb6 <consolewrite+0x6a>
    80004eaa:	64a6                	ld	s1,72(sp)
    80004eac:	79e2                	ld	s3,56(sp)
    80004eae:	7a42                	ld	s4,48(sp)
    80004eb0:	7aa2                	ld	s5,40(sp)
    80004eb2:	7b02                	ld	s6,32(sp)
    80004eb4:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004eb6:	854a                	mv	a0,s2
    80004eb8:	60e6                	ld	ra,88(sp)
    80004eba:	6446                	ld	s0,80(sp)
    80004ebc:	6906                	ld	s2,64(sp)
    80004ebe:	6125                	addi	sp,sp,96
    80004ec0:	8082                	ret

0000000080004ec2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004ec2:	711d                	addi	sp,sp,-96
    80004ec4:	ec86                	sd	ra,88(sp)
    80004ec6:	e8a2                	sd	s0,80(sp)
    80004ec8:	e4a6                	sd	s1,72(sp)
    80004eca:	e0ca                	sd	s2,64(sp)
    80004ecc:	fc4e                	sd	s3,56(sp)
    80004ece:	f852                	sd	s4,48(sp)
    80004ed0:	f456                	sd	s5,40(sp)
    80004ed2:	f05a                	sd	s6,32(sp)
    80004ed4:	1080                	addi	s0,sp,96
    80004ed6:	8aaa                	mv	s5,a0
    80004ed8:	8a2e                	mv	s4,a1
    80004eda:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004edc:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004ede:	0001f517          	auipc	a0,0x1f
    80004ee2:	a4250513          	addi	a0,a0,-1470 # 80023920 <cons>
    80004ee6:	15f000ef          	jal	80005844 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004eea:	0001f497          	auipc	s1,0x1f
    80004eee:	a3648493          	addi	s1,s1,-1482 # 80023920 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ef2:	0001f917          	auipc	s2,0x1f
    80004ef6:	ac690913          	addi	s2,s2,-1338 # 800239b8 <cons+0x98>
  while(n > 0){
    80004efa:	0b305b63          	blez	s3,80004fb0 <consoleread+0xee>
    while(cons.r == cons.w){
    80004efe:	0984a783          	lw	a5,152(s1)
    80004f02:	09c4a703          	lw	a4,156(s1)
    80004f06:	0af71063          	bne	a4,a5,80004fa6 <consoleread+0xe4>
      if(killed(myproc())){
    80004f0a:	ec9fb0ef          	jal	80000dd2 <myproc>
    80004f0e:	ed6fc0ef          	jal	800015e4 <killed>
    80004f12:	e12d                	bnez	a0,80004f74 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004f14:	85a6                	mv	a1,s1
    80004f16:	854a                	mv	a0,s2
    80004f18:	c94fc0ef          	jal	800013ac <sleep>
    while(cons.r == cons.w){
    80004f1c:	0984a783          	lw	a5,152(s1)
    80004f20:	09c4a703          	lw	a4,156(s1)
    80004f24:	fef703e3          	beq	a4,a5,80004f0a <consoleread+0x48>
    80004f28:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f2a:	0001f717          	auipc	a4,0x1f
    80004f2e:	9f670713          	addi	a4,a4,-1546 # 80023920 <cons>
    80004f32:	0017869b          	addiw	a3,a5,1
    80004f36:	08d72c23          	sw	a3,152(a4)
    80004f3a:	07f7f693          	andi	a3,a5,127
    80004f3e:	9736                	add	a4,a4,a3
    80004f40:	01874703          	lbu	a4,24(a4)
    80004f44:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004f48:	4691                	li	a3,4
    80004f4a:	04db8663          	beq	s7,a3,80004f96 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004f4e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f52:	4685                	li	a3,1
    80004f54:	faf40613          	addi	a2,s0,-81
    80004f58:	85d2                	mv	a1,s4
    80004f5a:	8556                	mv	a0,s5
    80004f5c:	fa6fc0ef          	jal	80001702 <either_copyout>
    80004f60:	57fd                	li	a5,-1
    80004f62:	04f50663          	beq	a0,a5,80004fae <consoleread+0xec>
      break;

    dst++;
    80004f66:	0a05                	addi	s4,s4,1
    --n;
    80004f68:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004f6a:	47a9                	li	a5,10
    80004f6c:	04fb8b63          	beq	s7,a5,80004fc2 <consoleread+0x100>
    80004f70:	6be2                	ld	s7,24(sp)
    80004f72:	b761                	j	80004efa <consoleread+0x38>
        release(&cons.lock);
    80004f74:	0001f517          	auipc	a0,0x1f
    80004f78:	9ac50513          	addi	a0,a0,-1620 # 80023920 <cons>
    80004f7c:	15d000ef          	jal	800058d8 <release>
        return -1;
    80004f80:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f82:	60e6                	ld	ra,88(sp)
    80004f84:	6446                	ld	s0,80(sp)
    80004f86:	64a6                	ld	s1,72(sp)
    80004f88:	6906                	ld	s2,64(sp)
    80004f8a:	79e2                	ld	s3,56(sp)
    80004f8c:	7a42                	ld	s4,48(sp)
    80004f8e:	7aa2                	ld	s5,40(sp)
    80004f90:	7b02                	ld	s6,32(sp)
    80004f92:	6125                	addi	sp,sp,96
    80004f94:	8082                	ret
      if(n < target){
    80004f96:	0169fa63          	bgeu	s3,s6,80004faa <consoleread+0xe8>
        cons.r--;
    80004f9a:	0001f717          	auipc	a4,0x1f
    80004f9e:	a0f72f23          	sw	a5,-1506(a4) # 800239b8 <cons+0x98>
    80004fa2:	6be2                	ld	s7,24(sp)
    80004fa4:	a031                	j	80004fb0 <consoleread+0xee>
    80004fa6:	ec5e                	sd	s7,24(sp)
    80004fa8:	b749                	j	80004f2a <consoleread+0x68>
    80004faa:	6be2                	ld	s7,24(sp)
    80004fac:	a011                	j	80004fb0 <consoleread+0xee>
    80004fae:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004fb0:	0001f517          	auipc	a0,0x1f
    80004fb4:	97050513          	addi	a0,a0,-1680 # 80023920 <cons>
    80004fb8:	121000ef          	jal	800058d8 <release>
  return target - n;
    80004fbc:	413b053b          	subw	a0,s6,s3
    80004fc0:	b7c9                	j	80004f82 <consoleread+0xc0>
    80004fc2:	6be2                	ld	s7,24(sp)
    80004fc4:	b7f5                	j	80004fb0 <consoleread+0xee>

0000000080004fc6 <consputc>:
{
    80004fc6:	1141                	addi	sp,sp,-16
    80004fc8:	e406                	sd	ra,8(sp)
    80004fca:	e022                	sd	s0,0(sp)
    80004fcc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004fce:	10000793          	li	a5,256
    80004fd2:	00f50863          	beq	a0,a5,80004fe2 <consputc+0x1c>
    uartputc_sync(c);
    80004fd6:	5fe000ef          	jal	800055d4 <uartputc_sync>
}
    80004fda:	60a2                	ld	ra,8(sp)
    80004fdc:	6402                	ld	s0,0(sp)
    80004fde:	0141                	addi	sp,sp,16
    80004fe0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004fe2:	4521                	li	a0,8
    80004fe4:	5f0000ef          	jal	800055d4 <uartputc_sync>
    80004fe8:	02000513          	li	a0,32
    80004fec:	5e8000ef          	jal	800055d4 <uartputc_sync>
    80004ff0:	4521                	li	a0,8
    80004ff2:	5e2000ef          	jal	800055d4 <uartputc_sync>
    80004ff6:	b7d5                	j	80004fda <consputc+0x14>

0000000080004ff8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ff8:	7179                	addi	sp,sp,-48
    80004ffa:	f406                	sd	ra,40(sp)
    80004ffc:	f022                	sd	s0,32(sp)
    80004ffe:	ec26                	sd	s1,24(sp)
    80005000:	1800                	addi	s0,sp,48
    80005002:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005004:	0001f517          	auipc	a0,0x1f
    80005008:	91c50513          	addi	a0,a0,-1764 # 80023920 <cons>
    8000500c:	039000ef          	jal	80005844 <acquire>

  switch(c){
    80005010:	47d5                	li	a5,21
    80005012:	08f48e63          	beq	s1,a5,800050ae <consoleintr+0xb6>
    80005016:	0297c563          	blt	a5,s1,80005040 <consoleintr+0x48>
    8000501a:	47a1                	li	a5,8
    8000501c:	0ef48863          	beq	s1,a5,8000510c <consoleintr+0x114>
    80005020:	47c1                	li	a5,16
    80005022:	10f49963          	bne	s1,a5,80005134 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80005026:	f70fc0ef          	jal	80001796 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000502a:	0001f517          	auipc	a0,0x1f
    8000502e:	8f650513          	addi	a0,a0,-1802 # 80023920 <cons>
    80005032:	0a7000ef          	jal	800058d8 <release>
}
    80005036:	70a2                	ld	ra,40(sp)
    80005038:	7402                	ld	s0,32(sp)
    8000503a:	64e2                	ld	s1,24(sp)
    8000503c:	6145                	addi	sp,sp,48
    8000503e:	8082                	ret
  switch(c){
    80005040:	07f00793          	li	a5,127
    80005044:	0cf48463          	beq	s1,a5,8000510c <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005048:	0001f717          	auipc	a4,0x1f
    8000504c:	8d870713          	addi	a4,a4,-1832 # 80023920 <cons>
    80005050:	0a072783          	lw	a5,160(a4)
    80005054:	09872703          	lw	a4,152(a4)
    80005058:	9f99                	subw	a5,a5,a4
    8000505a:	07f00713          	li	a4,127
    8000505e:	fcf766e3          	bltu	a4,a5,8000502a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005062:	47b5                	li	a5,13
    80005064:	0cf48b63          	beq	s1,a5,8000513a <consoleintr+0x142>
      consputc(c);
    80005068:	8526                	mv	a0,s1
    8000506a:	f5dff0ef          	jal	80004fc6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000506e:	0001f797          	auipc	a5,0x1f
    80005072:	8b278793          	addi	a5,a5,-1870 # 80023920 <cons>
    80005076:	0a07a683          	lw	a3,160(a5)
    8000507a:	0016871b          	addiw	a4,a3,1
    8000507e:	863a                	mv	a2,a4
    80005080:	0ae7a023          	sw	a4,160(a5)
    80005084:	07f6f693          	andi	a3,a3,127
    80005088:	97b6                	add	a5,a5,a3
    8000508a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000508e:	47a9                	li	a5,10
    80005090:	0cf48963          	beq	s1,a5,80005162 <consoleintr+0x16a>
    80005094:	4791                	li	a5,4
    80005096:	0cf48663          	beq	s1,a5,80005162 <consoleintr+0x16a>
    8000509a:	0001f797          	auipc	a5,0x1f
    8000509e:	91e7a783          	lw	a5,-1762(a5) # 800239b8 <cons+0x98>
    800050a2:	9f1d                	subw	a4,a4,a5
    800050a4:	08000793          	li	a5,128
    800050a8:	f8f711e3          	bne	a4,a5,8000502a <consoleintr+0x32>
    800050ac:	a85d                	j	80005162 <consoleintr+0x16a>
    800050ae:	e84a                	sd	s2,16(sp)
    800050b0:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800050b2:	0001f717          	auipc	a4,0x1f
    800050b6:	86e70713          	addi	a4,a4,-1938 # 80023920 <cons>
    800050ba:	0a072783          	lw	a5,160(a4)
    800050be:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050c2:	0001f497          	auipc	s1,0x1f
    800050c6:	85e48493          	addi	s1,s1,-1954 # 80023920 <cons>
    while(cons.e != cons.w &&
    800050ca:	4929                	li	s2,10
      consputc(BACKSPACE);
    800050cc:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    800050d0:	02f70863          	beq	a4,a5,80005100 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050d4:	37fd                	addiw	a5,a5,-1
    800050d6:	07f7f713          	andi	a4,a5,127
    800050da:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800050dc:	01874703          	lbu	a4,24(a4)
    800050e0:	03270363          	beq	a4,s2,80005106 <consoleintr+0x10e>
      cons.e--;
    800050e4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800050e8:	854e                	mv	a0,s3
    800050ea:	eddff0ef          	jal	80004fc6 <consputc>
    while(cons.e != cons.w &&
    800050ee:	0a04a783          	lw	a5,160(s1)
    800050f2:	09c4a703          	lw	a4,156(s1)
    800050f6:	fcf71fe3          	bne	a4,a5,800050d4 <consoleintr+0xdc>
    800050fa:	6942                	ld	s2,16(sp)
    800050fc:	69a2                	ld	s3,8(sp)
    800050fe:	b735                	j	8000502a <consoleintr+0x32>
    80005100:	6942                	ld	s2,16(sp)
    80005102:	69a2                	ld	s3,8(sp)
    80005104:	b71d                	j	8000502a <consoleintr+0x32>
    80005106:	6942                	ld	s2,16(sp)
    80005108:	69a2                	ld	s3,8(sp)
    8000510a:	b705                	j	8000502a <consoleintr+0x32>
    if(cons.e != cons.w){
    8000510c:	0001f717          	auipc	a4,0x1f
    80005110:	81470713          	addi	a4,a4,-2028 # 80023920 <cons>
    80005114:	0a072783          	lw	a5,160(a4)
    80005118:	09c72703          	lw	a4,156(a4)
    8000511c:	f0f707e3          	beq	a4,a5,8000502a <consoleintr+0x32>
      cons.e--;
    80005120:	37fd                	addiw	a5,a5,-1
    80005122:	0001f717          	auipc	a4,0x1f
    80005126:	88f72f23          	sw	a5,-1890(a4) # 800239c0 <cons+0xa0>
      consputc(BACKSPACE);
    8000512a:	10000513          	li	a0,256
    8000512e:	e99ff0ef          	jal	80004fc6 <consputc>
    80005132:	bde5                	j	8000502a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005134:	ee048be3          	beqz	s1,8000502a <consoleintr+0x32>
    80005138:	bf01                	j	80005048 <consoleintr+0x50>
      consputc(c);
    8000513a:	4529                	li	a0,10
    8000513c:	e8bff0ef          	jal	80004fc6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005140:	0001e797          	auipc	a5,0x1e
    80005144:	7e078793          	addi	a5,a5,2016 # 80023920 <cons>
    80005148:	0a07a703          	lw	a4,160(a5)
    8000514c:	0017069b          	addiw	a3,a4,1
    80005150:	8636                	mv	a2,a3
    80005152:	0ad7a023          	sw	a3,160(a5)
    80005156:	07f77713          	andi	a4,a4,127
    8000515a:	97ba                	add	a5,a5,a4
    8000515c:	4729                	li	a4,10
    8000515e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005162:	0001f797          	auipc	a5,0x1f
    80005166:	84c7ad23          	sw	a2,-1958(a5) # 800239bc <cons+0x9c>
        wakeup(&cons.r);
    8000516a:	0001f517          	auipc	a0,0x1f
    8000516e:	84e50513          	addi	a0,a0,-1970 # 800239b8 <cons+0x98>
    80005172:	a86fc0ef          	jal	800013f8 <wakeup>
    80005176:	bd55                	j	8000502a <consoleintr+0x32>

0000000080005178 <consoleinit>:

void
consoleinit(void)
{
    80005178:	1141                	addi	sp,sp,-16
    8000517a:	e406                	sd	ra,8(sp)
    8000517c:	e022                	sd	s0,0(sp)
    8000517e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005180:	00002597          	auipc	a1,0x2
    80005184:	65058593          	addi	a1,a1,1616 # 800077d0 <etext+0x7d0>
    80005188:	0001e517          	auipc	a0,0x1e
    8000518c:	79850513          	addi	a0,a0,1944 # 80023920 <cons>
    80005190:	630000ef          	jal	800057c0 <initlock>

  uartinit();
    80005194:	3ea000ef          	jal	8000557e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005198:	00015797          	auipc	a5,0x15
    8000519c:	5f078793          	addi	a5,a5,1520 # 8001a788 <devsw>
    800051a0:	00000717          	auipc	a4,0x0
    800051a4:	d2270713          	addi	a4,a4,-734 # 80004ec2 <consoleread>
    800051a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800051aa:	00000717          	auipc	a4,0x0
    800051ae:	ca270713          	addi	a4,a4,-862 # 80004e4c <consolewrite>
    800051b2:	ef98                	sd	a4,24(a5)
}
    800051b4:	60a2                	ld	ra,8(sp)
    800051b6:	6402                	ld	s0,0(sp)
    800051b8:	0141                	addi	sp,sp,16
    800051ba:	8082                	ret

00000000800051bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800051bc:	7179                	addi	sp,sp,-48
    800051be:	f406                	sd	ra,40(sp)
    800051c0:	f022                	sd	s0,32(sp)
    800051c2:	ec26                	sd	s1,24(sp)
    800051c4:	e84a                	sd	s2,16(sp)
    800051c6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800051c8:	c219                	beqz	a2,800051ce <printint+0x12>
    800051ca:	06054a63          	bltz	a0,8000523e <printint+0x82>
    x = -xx;
  else
    x = xx;
    800051ce:	4e01                	li	t3,0

  i = 0;
    800051d0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800051d4:	869a                	mv	a3,t1
  i = 0;
    800051d6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800051d8:	00003817          	auipc	a6,0x3
    800051dc:	82080813          	addi	a6,a6,-2016 # 800079f8 <digits>
    800051e0:	88be                	mv	a7,a5
    800051e2:	0017861b          	addiw	a2,a5,1
    800051e6:	87b2                	mv	a5,a2
    800051e8:	02b57733          	remu	a4,a0,a1
    800051ec:	9742                	add	a4,a4,a6
    800051ee:	00074703          	lbu	a4,0(a4)
    800051f2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800051f6:	872a                	mv	a4,a0
    800051f8:	02b55533          	divu	a0,a0,a1
    800051fc:	0685                	addi	a3,a3,1
    800051fe:	feb771e3          	bgeu	a4,a1,800051e0 <printint+0x24>

  if(sign)
    80005202:	000e0c63          	beqz	t3,8000521a <printint+0x5e>
    buf[i++] = '-';
    80005206:	fe060793          	addi	a5,a2,-32
    8000520a:	00878633          	add	a2,a5,s0
    8000520e:	02d00793          	li	a5,45
    80005212:	fef60823          	sb	a5,-16(a2)
    80005216:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    8000521a:	fff7891b          	addiw	s2,a5,-1
    8000521e:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005222:	fff4c503          	lbu	a0,-1(s1)
    80005226:	da1ff0ef          	jal	80004fc6 <consputc>
  while(--i >= 0)
    8000522a:	397d                	addiw	s2,s2,-1
    8000522c:	14fd                	addi	s1,s1,-1
    8000522e:	fe095ae3          	bgez	s2,80005222 <printint+0x66>
}
    80005232:	70a2                	ld	ra,40(sp)
    80005234:	7402                	ld	s0,32(sp)
    80005236:	64e2                	ld	s1,24(sp)
    80005238:	6942                	ld	s2,16(sp)
    8000523a:	6145                	addi	sp,sp,48
    8000523c:	8082                	ret
    x = -xx;
    8000523e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005242:	4e05                	li	t3,1
    x = -xx;
    80005244:	b771                	j	800051d0 <printint+0x14>

0000000080005246 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005246:	7155                	addi	sp,sp,-208
    80005248:	e506                	sd	ra,136(sp)
    8000524a:	e122                	sd	s0,128(sp)
    8000524c:	f0d2                	sd	s4,96(sp)
    8000524e:	0900                	addi	s0,sp,144
    80005250:	8a2a                	mv	s4,a0
    80005252:	e40c                	sd	a1,8(s0)
    80005254:	e810                	sd	a2,16(s0)
    80005256:	ec14                	sd	a3,24(s0)
    80005258:	f018                	sd	a4,32(s0)
    8000525a:	f41c                	sd	a5,40(s0)
    8000525c:	03043823          	sd	a6,48(s0)
    80005260:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005264:	0001e797          	auipc	a5,0x1e
    80005268:	77c7a783          	lw	a5,1916(a5) # 800239e0 <pr+0x18>
    8000526c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005270:	e3a1                	bnez	a5,800052b0 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005272:	00840793          	addi	a5,s0,8
    80005276:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000527a:	00054503          	lbu	a0,0(a0)
    8000527e:	26050663          	beqz	a0,800054ea <printf+0x2a4>
    80005282:	fca6                	sd	s1,120(sp)
    80005284:	f8ca                	sd	s2,112(sp)
    80005286:	f4ce                	sd	s3,104(sp)
    80005288:	ecd6                	sd	s5,88(sp)
    8000528a:	e8da                	sd	s6,80(sp)
    8000528c:	e0e2                	sd	s8,64(sp)
    8000528e:	fc66                	sd	s9,56(sp)
    80005290:	f86a                	sd	s10,48(sp)
    80005292:	f46e                	sd	s11,40(sp)
    80005294:	4981                	li	s3,0
    if(cx != '%'){
    80005296:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000529a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000529e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800052a2:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800052a6:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800052aa:	07000d93          	li	s11,112
    800052ae:	a80d                	j	800052e0 <printf+0x9a>
    acquire(&pr.lock);
    800052b0:	0001e517          	auipc	a0,0x1e
    800052b4:	71850513          	addi	a0,a0,1816 # 800239c8 <pr>
    800052b8:	58c000ef          	jal	80005844 <acquire>
  va_start(ap, fmt);
    800052bc:	00840793          	addi	a5,s0,8
    800052c0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052c4:	000a4503          	lbu	a0,0(s4)
    800052c8:	fd4d                	bnez	a0,80005282 <printf+0x3c>
    800052ca:	ac3d                	j	80005508 <printf+0x2c2>
      consputc(cx);
    800052cc:	cfbff0ef          	jal	80004fc6 <consputc>
      continue;
    800052d0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052d2:	2485                	addiw	s1,s1,1
    800052d4:	89a6                	mv	s3,s1
    800052d6:	94d2                	add	s1,s1,s4
    800052d8:	0004c503          	lbu	a0,0(s1)
    800052dc:	1e050b63          	beqz	a0,800054d2 <printf+0x28c>
    if(cx != '%'){
    800052e0:	ff5516e3          	bne	a0,s5,800052cc <printf+0x86>
    i++;
    800052e4:	0019879b          	addiw	a5,s3,1
    800052e8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800052ea:	00fa0733          	add	a4,s4,a5
    800052ee:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800052f2:	1e090063          	beqz	s2,800054d2 <printf+0x28c>
    800052f6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800052fa:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800052fc:	c701                	beqz	a4,80005304 <printf+0xbe>
    800052fe:	97d2                	add	a5,a5,s4
    80005300:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005304:	03690763          	beq	s2,s6,80005332 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80005308:	05890163          	beq	s2,s8,8000534a <printf+0x104>
    } else if(c0 == 'u'){
    8000530c:	0d990b63          	beq	s2,s9,800053e2 <printf+0x19c>
    } else if(c0 == 'x'){
    80005310:	13a90163          	beq	s2,s10,80005432 <printf+0x1ec>
    } else if(c0 == 'p'){
    80005314:	13b90b63          	beq	s2,s11,8000544a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005318:	07300793          	li	a5,115
    8000531c:	16f90a63          	beq	s2,a5,80005490 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005320:	1b590463          	beq	s2,s5,800054c8 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005324:	8556                	mv	a0,s5
    80005326:	ca1ff0ef          	jal	80004fc6 <consputc>
      consputc(c0);
    8000532a:	854a                	mv	a0,s2
    8000532c:	c9bff0ef          	jal	80004fc6 <consputc>
    80005330:	b74d                	j	800052d2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005332:	f8843783          	ld	a5,-120(s0)
    80005336:	00878713          	addi	a4,a5,8
    8000533a:	f8e43423          	sd	a4,-120(s0)
    8000533e:	4605                	li	a2,1
    80005340:	45a9                	li	a1,10
    80005342:	4388                	lw	a0,0(a5)
    80005344:	e79ff0ef          	jal	800051bc <printint>
    80005348:	b769                	j	800052d2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000534a:	03670663          	beq	a4,s6,80005376 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000534e:	05870263          	beq	a4,s8,80005392 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005352:	0b970463          	beq	a4,s9,800053fa <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005356:	fda717e3          	bne	a4,s10,80005324 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000535a:	f8843783          	ld	a5,-120(s0)
    8000535e:	00878713          	addi	a4,a5,8
    80005362:	f8e43423          	sd	a4,-120(s0)
    80005366:	4601                	li	a2,0
    80005368:	45c1                	li	a1,16
    8000536a:	6388                	ld	a0,0(a5)
    8000536c:	e51ff0ef          	jal	800051bc <printint>
      i += 1;
    80005370:	0029849b          	addiw	s1,s3,2
    80005374:	bfb9                	j	800052d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005376:	f8843783          	ld	a5,-120(s0)
    8000537a:	00878713          	addi	a4,a5,8
    8000537e:	f8e43423          	sd	a4,-120(s0)
    80005382:	4605                	li	a2,1
    80005384:	45a9                	li	a1,10
    80005386:	6388                	ld	a0,0(a5)
    80005388:	e35ff0ef          	jal	800051bc <printint>
      i += 1;
    8000538c:	0029849b          	addiw	s1,s3,2
    80005390:	b789                	j	800052d2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005392:	06400793          	li	a5,100
    80005396:	02f68863          	beq	a3,a5,800053c6 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000539a:	07500793          	li	a5,117
    8000539e:	06f68c63          	beq	a3,a5,80005416 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800053a2:	07800793          	li	a5,120
    800053a6:	f6f69fe3          	bne	a3,a5,80005324 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800053aa:	f8843783          	ld	a5,-120(s0)
    800053ae:	00878713          	addi	a4,a5,8
    800053b2:	f8e43423          	sd	a4,-120(s0)
    800053b6:	4601                	li	a2,0
    800053b8:	45c1                	li	a1,16
    800053ba:	6388                	ld	a0,0(a5)
    800053bc:	e01ff0ef          	jal	800051bc <printint>
      i += 2;
    800053c0:	0039849b          	addiw	s1,s3,3
    800053c4:	b739                	j	800052d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800053c6:	f8843783          	ld	a5,-120(s0)
    800053ca:	00878713          	addi	a4,a5,8
    800053ce:	f8e43423          	sd	a4,-120(s0)
    800053d2:	4605                	li	a2,1
    800053d4:	45a9                	li	a1,10
    800053d6:	6388                	ld	a0,0(a5)
    800053d8:	de5ff0ef          	jal	800051bc <printint>
      i += 2;
    800053dc:	0039849b          	addiw	s1,s3,3
    800053e0:	bdcd                	j	800052d2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800053e2:	f8843783          	ld	a5,-120(s0)
    800053e6:	00878713          	addi	a4,a5,8
    800053ea:	f8e43423          	sd	a4,-120(s0)
    800053ee:	4601                	li	a2,0
    800053f0:	45a9                	li	a1,10
    800053f2:	4388                	lw	a0,0(a5)
    800053f4:	dc9ff0ef          	jal	800051bc <printint>
    800053f8:	bde9                	j	800052d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053fa:	f8843783          	ld	a5,-120(s0)
    800053fe:	00878713          	addi	a4,a5,8
    80005402:	f8e43423          	sd	a4,-120(s0)
    80005406:	4601                	li	a2,0
    80005408:	45a9                	li	a1,10
    8000540a:	6388                	ld	a0,0(a5)
    8000540c:	db1ff0ef          	jal	800051bc <printint>
      i += 1;
    80005410:	0029849b          	addiw	s1,s3,2
    80005414:	bd7d                	j	800052d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005416:	f8843783          	ld	a5,-120(s0)
    8000541a:	00878713          	addi	a4,a5,8
    8000541e:	f8e43423          	sd	a4,-120(s0)
    80005422:	4601                	li	a2,0
    80005424:	45a9                	li	a1,10
    80005426:	6388                	ld	a0,0(a5)
    80005428:	d95ff0ef          	jal	800051bc <printint>
      i += 2;
    8000542c:	0039849b          	addiw	s1,s3,3
    80005430:	b54d                	j	800052d2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005432:	f8843783          	ld	a5,-120(s0)
    80005436:	00878713          	addi	a4,a5,8
    8000543a:	f8e43423          	sd	a4,-120(s0)
    8000543e:	4601                	li	a2,0
    80005440:	45c1                	li	a1,16
    80005442:	4388                	lw	a0,0(a5)
    80005444:	d79ff0ef          	jal	800051bc <printint>
    80005448:	b569                	j	800052d2 <printf+0x8c>
    8000544a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000544c:	f8843783          	ld	a5,-120(s0)
    80005450:	00878713          	addi	a4,a5,8
    80005454:	f8e43423          	sd	a4,-120(s0)
    80005458:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000545c:	03000513          	li	a0,48
    80005460:	b67ff0ef          	jal	80004fc6 <consputc>
  consputc('x');
    80005464:	07800513          	li	a0,120
    80005468:	b5fff0ef          	jal	80004fc6 <consputc>
    8000546c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000546e:	00002b97          	auipc	s7,0x2
    80005472:	58ab8b93          	addi	s7,s7,1418 # 800079f8 <digits>
    80005476:	03c9d793          	srli	a5,s3,0x3c
    8000547a:	97de                	add	a5,a5,s7
    8000547c:	0007c503          	lbu	a0,0(a5)
    80005480:	b47ff0ef          	jal	80004fc6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005484:	0992                	slli	s3,s3,0x4
    80005486:	397d                	addiw	s2,s2,-1
    80005488:	fe0917e3          	bnez	s2,80005476 <printf+0x230>
    8000548c:	6ba6                	ld	s7,72(sp)
    8000548e:	b591                	j	800052d2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005490:	f8843783          	ld	a5,-120(s0)
    80005494:	00878713          	addi	a4,a5,8
    80005498:	f8e43423          	sd	a4,-120(s0)
    8000549c:	0007b903          	ld	s2,0(a5)
    800054a0:	00090d63          	beqz	s2,800054ba <printf+0x274>
      for(; *s; s++)
    800054a4:	00094503          	lbu	a0,0(s2)
    800054a8:	e20505e3          	beqz	a0,800052d2 <printf+0x8c>
        consputc(*s);
    800054ac:	b1bff0ef          	jal	80004fc6 <consputc>
      for(; *s; s++)
    800054b0:	0905                	addi	s2,s2,1
    800054b2:	00094503          	lbu	a0,0(s2)
    800054b6:	f97d                	bnez	a0,800054ac <printf+0x266>
    800054b8:	bd29                	j	800052d2 <printf+0x8c>
        s = "(null)";
    800054ba:	00002917          	auipc	s2,0x2
    800054be:	31e90913          	addi	s2,s2,798 # 800077d8 <etext+0x7d8>
      for(; *s; s++)
    800054c2:	02800513          	li	a0,40
    800054c6:	b7dd                	j	800054ac <printf+0x266>
      consputc('%');
    800054c8:	02500513          	li	a0,37
    800054cc:	afbff0ef          	jal	80004fc6 <consputc>
    800054d0:	b509                	j	800052d2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800054d2:	f7843783          	ld	a5,-136(s0)
    800054d6:	e385                	bnez	a5,800054f6 <printf+0x2b0>
    800054d8:	74e6                	ld	s1,120(sp)
    800054da:	7946                	ld	s2,112(sp)
    800054dc:	79a6                	ld	s3,104(sp)
    800054de:	6ae6                	ld	s5,88(sp)
    800054e0:	6b46                	ld	s6,80(sp)
    800054e2:	6c06                	ld	s8,64(sp)
    800054e4:	7ce2                	ld	s9,56(sp)
    800054e6:	7d42                	ld	s10,48(sp)
    800054e8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800054ea:	4501                	li	a0,0
    800054ec:	60aa                	ld	ra,136(sp)
    800054ee:	640a                	ld	s0,128(sp)
    800054f0:	7a06                	ld	s4,96(sp)
    800054f2:	6169                	addi	sp,sp,208
    800054f4:	8082                	ret
    800054f6:	74e6                	ld	s1,120(sp)
    800054f8:	7946                	ld	s2,112(sp)
    800054fa:	79a6                	ld	s3,104(sp)
    800054fc:	6ae6                	ld	s5,88(sp)
    800054fe:	6b46                	ld	s6,80(sp)
    80005500:	6c06                	ld	s8,64(sp)
    80005502:	7ce2                	ld	s9,56(sp)
    80005504:	7d42                	ld	s10,48(sp)
    80005506:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005508:	0001e517          	auipc	a0,0x1e
    8000550c:	4c050513          	addi	a0,a0,1216 # 800239c8 <pr>
    80005510:	3c8000ef          	jal	800058d8 <release>
    80005514:	bfd9                	j	800054ea <printf+0x2a4>

0000000080005516 <panic>:

void
panic(char *s)
{
    80005516:	1101                	addi	sp,sp,-32
    80005518:	ec06                	sd	ra,24(sp)
    8000551a:	e822                	sd	s0,16(sp)
    8000551c:	e426                	sd	s1,8(sp)
    8000551e:	1000                	addi	s0,sp,32
    80005520:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005522:	0001e797          	auipc	a5,0x1e
    80005526:	4a07af23          	sw	zero,1214(a5) # 800239e0 <pr+0x18>
  printf("panic: ");
    8000552a:	00002517          	auipc	a0,0x2
    8000552e:	2b650513          	addi	a0,a0,694 # 800077e0 <etext+0x7e0>
    80005532:	d15ff0ef          	jal	80005246 <printf>
  printf("%s\n", s);
    80005536:	85a6                	mv	a1,s1
    80005538:	00002517          	auipc	a0,0x2
    8000553c:	2b050513          	addi	a0,a0,688 # 800077e8 <etext+0x7e8>
    80005540:	d07ff0ef          	jal	80005246 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005544:	4785                	li	a5,1
    80005546:	00005717          	auipc	a4,0x5
    8000554a:	f8f72b23          	sw	a5,-106(a4) # 8000a4dc <panicked>
  for(;;)
    8000554e:	a001                	j	8000554e <panic+0x38>

0000000080005550 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005550:	1101                	addi	sp,sp,-32
    80005552:	ec06                	sd	ra,24(sp)
    80005554:	e822                	sd	s0,16(sp)
    80005556:	e426                	sd	s1,8(sp)
    80005558:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000555a:	0001e497          	auipc	s1,0x1e
    8000555e:	46e48493          	addi	s1,s1,1134 # 800239c8 <pr>
    80005562:	00002597          	auipc	a1,0x2
    80005566:	28e58593          	addi	a1,a1,654 # 800077f0 <etext+0x7f0>
    8000556a:	8526                	mv	a0,s1
    8000556c:	254000ef          	jal	800057c0 <initlock>
  pr.locking = 1;
    80005570:	4785                	li	a5,1
    80005572:	cc9c                	sw	a5,24(s1)
}
    80005574:	60e2                	ld	ra,24(sp)
    80005576:	6442                	ld	s0,16(sp)
    80005578:	64a2                	ld	s1,8(sp)
    8000557a:	6105                	addi	sp,sp,32
    8000557c:	8082                	ret

000000008000557e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000557e:	1141                	addi	sp,sp,-16
    80005580:	e406                	sd	ra,8(sp)
    80005582:	e022                	sd	s0,0(sp)
    80005584:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005586:	100007b7          	lui	a5,0x10000
    8000558a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000558e:	10000737          	lui	a4,0x10000
    80005592:	f8000693          	li	a3,-128
    80005596:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000559a:	468d                	li	a3,3
    8000559c:	10000637          	lui	a2,0x10000
    800055a0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800055a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800055a8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800055ac:	8732                	mv	a4,a2
    800055ae:	461d                	li	a2,7
    800055b0:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800055b4:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800055b8:	00002597          	auipc	a1,0x2
    800055bc:	24058593          	addi	a1,a1,576 # 800077f8 <etext+0x7f8>
    800055c0:	0001e517          	auipc	a0,0x1e
    800055c4:	42850513          	addi	a0,a0,1064 # 800239e8 <uart_tx_lock>
    800055c8:	1f8000ef          	jal	800057c0 <initlock>
}
    800055cc:	60a2                	ld	ra,8(sp)
    800055ce:	6402                	ld	s0,0(sp)
    800055d0:	0141                	addi	sp,sp,16
    800055d2:	8082                	ret

00000000800055d4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800055d4:	1101                	addi	sp,sp,-32
    800055d6:	ec06                	sd	ra,24(sp)
    800055d8:	e822                	sd	s0,16(sp)
    800055da:	e426                	sd	s1,8(sp)
    800055dc:	1000                	addi	s0,sp,32
    800055de:	84aa                	mv	s1,a0
  push_off();
    800055e0:	224000ef          	jal	80005804 <push_off>

  if(panicked){
    800055e4:	00005797          	auipc	a5,0x5
    800055e8:	ef87a783          	lw	a5,-264(a5) # 8000a4dc <panicked>
    800055ec:	e795                	bnez	a5,80005618 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800055ee:	10000737          	lui	a4,0x10000
    800055f2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800055f4:	00074783          	lbu	a5,0(a4)
    800055f8:	0207f793          	andi	a5,a5,32
    800055fc:	dfe5                	beqz	a5,800055f4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800055fe:	0ff4f513          	zext.b	a0,s1
    80005602:	100007b7          	lui	a5,0x10000
    80005606:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000560a:	27e000ef          	jal	80005888 <pop_off>
}
    8000560e:	60e2                	ld	ra,24(sp)
    80005610:	6442                	ld	s0,16(sp)
    80005612:	64a2                	ld	s1,8(sp)
    80005614:	6105                	addi	sp,sp,32
    80005616:	8082                	ret
    for(;;)
    80005618:	a001                	j	80005618 <uartputc_sync+0x44>

000000008000561a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000561a:	00005797          	auipc	a5,0x5
    8000561e:	ec67b783          	ld	a5,-314(a5) # 8000a4e0 <uart_tx_r>
    80005622:	00005717          	auipc	a4,0x5
    80005626:	ec673703          	ld	a4,-314(a4) # 8000a4e8 <uart_tx_w>
    8000562a:	08f70163          	beq	a4,a5,800056ac <uartstart+0x92>
{
    8000562e:	7139                	addi	sp,sp,-64
    80005630:	fc06                	sd	ra,56(sp)
    80005632:	f822                	sd	s0,48(sp)
    80005634:	f426                	sd	s1,40(sp)
    80005636:	f04a                	sd	s2,32(sp)
    80005638:	ec4e                	sd	s3,24(sp)
    8000563a:	e852                	sd	s4,16(sp)
    8000563c:	e456                	sd	s5,8(sp)
    8000563e:	e05a                	sd	s6,0(sp)
    80005640:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005642:	10000937          	lui	s2,0x10000
    80005646:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005648:	0001ea97          	auipc	s5,0x1e
    8000564c:	3a0a8a93          	addi	s5,s5,928 # 800239e8 <uart_tx_lock>
    uart_tx_r += 1;
    80005650:	00005497          	auipc	s1,0x5
    80005654:	e9048493          	addi	s1,s1,-368 # 8000a4e0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005658:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000565c:	00005997          	auipc	s3,0x5
    80005660:	e8c98993          	addi	s3,s3,-372 # 8000a4e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005664:	00094703          	lbu	a4,0(s2)
    80005668:	02077713          	andi	a4,a4,32
    8000566c:	c715                	beqz	a4,80005698 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000566e:	01f7f713          	andi	a4,a5,31
    80005672:	9756                	add	a4,a4,s5
    80005674:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005678:	0785                	addi	a5,a5,1
    8000567a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000567c:	8526                	mv	a0,s1
    8000567e:	d7bfb0ef          	jal	800013f8 <wakeup>
    WriteReg(THR, c);
    80005682:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005686:	609c                	ld	a5,0(s1)
    80005688:	0009b703          	ld	a4,0(s3)
    8000568c:	fcf71ce3          	bne	a4,a5,80005664 <uartstart+0x4a>
      ReadReg(ISR);
    80005690:	100007b7          	lui	a5,0x10000
    80005694:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005698:	70e2                	ld	ra,56(sp)
    8000569a:	7442                	ld	s0,48(sp)
    8000569c:	74a2                	ld	s1,40(sp)
    8000569e:	7902                	ld	s2,32(sp)
    800056a0:	69e2                	ld	s3,24(sp)
    800056a2:	6a42                	ld	s4,16(sp)
    800056a4:	6aa2                	ld	s5,8(sp)
    800056a6:	6b02                	ld	s6,0(sp)
    800056a8:	6121                	addi	sp,sp,64
    800056aa:	8082                	ret
      ReadReg(ISR);
    800056ac:	100007b7          	lui	a5,0x10000
    800056b0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800056b4:	8082                	ret

00000000800056b6 <uartputc>:
{
    800056b6:	7179                	addi	sp,sp,-48
    800056b8:	f406                	sd	ra,40(sp)
    800056ba:	f022                	sd	s0,32(sp)
    800056bc:	ec26                	sd	s1,24(sp)
    800056be:	e84a                	sd	s2,16(sp)
    800056c0:	e44e                	sd	s3,8(sp)
    800056c2:	e052                	sd	s4,0(sp)
    800056c4:	1800                	addi	s0,sp,48
    800056c6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800056c8:	0001e517          	auipc	a0,0x1e
    800056cc:	32050513          	addi	a0,a0,800 # 800239e8 <uart_tx_lock>
    800056d0:	174000ef          	jal	80005844 <acquire>
  if(panicked){
    800056d4:	00005797          	auipc	a5,0x5
    800056d8:	e087a783          	lw	a5,-504(a5) # 8000a4dc <panicked>
    800056dc:	efbd                	bnez	a5,8000575a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056de:	00005717          	auipc	a4,0x5
    800056e2:	e0a73703          	ld	a4,-502(a4) # 8000a4e8 <uart_tx_w>
    800056e6:	00005797          	auipc	a5,0x5
    800056ea:	dfa7b783          	ld	a5,-518(a5) # 8000a4e0 <uart_tx_r>
    800056ee:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800056f2:	0001e997          	auipc	s3,0x1e
    800056f6:	2f698993          	addi	s3,s3,758 # 800239e8 <uart_tx_lock>
    800056fa:	00005497          	auipc	s1,0x5
    800056fe:	de648493          	addi	s1,s1,-538 # 8000a4e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005702:	00005917          	auipc	s2,0x5
    80005706:	de690913          	addi	s2,s2,-538 # 8000a4e8 <uart_tx_w>
    8000570a:	00e79d63          	bne	a5,a4,80005724 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000570e:	85ce                	mv	a1,s3
    80005710:	8526                	mv	a0,s1
    80005712:	c9bfb0ef          	jal	800013ac <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005716:	00093703          	ld	a4,0(s2)
    8000571a:	609c                	ld	a5,0(s1)
    8000571c:	02078793          	addi	a5,a5,32
    80005720:	fee787e3          	beq	a5,a4,8000570e <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005724:	0001e497          	auipc	s1,0x1e
    80005728:	2c448493          	addi	s1,s1,708 # 800239e8 <uart_tx_lock>
    8000572c:	01f77793          	andi	a5,a4,31
    80005730:	97a6                	add	a5,a5,s1
    80005732:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005736:	0705                	addi	a4,a4,1
    80005738:	00005797          	auipc	a5,0x5
    8000573c:	dae7b823          	sd	a4,-592(a5) # 8000a4e8 <uart_tx_w>
  uartstart();
    80005740:	edbff0ef          	jal	8000561a <uartstart>
  release(&uart_tx_lock);
    80005744:	8526                	mv	a0,s1
    80005746:	192000ef          	jal	800058d8 <release>
}
    8000574a:	70a2                	ld	ra,40(sp)
    8000574c:	7402                	ld	s0,32(sp)
    8000574e:	64e2                	ld	s1,24(sp)
    80005750:	6942                	ld	s2,16(sp)
    80005752:	69a2                	ld	s3,8(sp)
    80005754:	6a02                	ld	s4,0(sp)
    80005756:	6145                	addi	sp,sp,48
    80005758:	8082                	ret
    for(;;)
    8000575a:	a001                	j	8000575a <uartputc+0xa4>

000000008000575c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000575c:	1141                	addi	sp,sp,-16
    8000575e:	e406                	sd	ra,8(sp)
    80005760:	e022                	sd	s0,0(sp)
    80005762:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005764:	100007b7          	lui	a5,0x10000
    80005768:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000576c:	8b85                	andi	a5,a5,1
    8000576e:	cb89                	beqz	a5,80005780 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005770:	100007b7          	lui	a5,0x10000
    80005774:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005778:	60a2                	ld	ra,8(sp)
    8000577a:	6402                	ld	s0,0(sp)
    8000577c:	0141                	addi	sp,sp,16
    8000577e:	8082                	ret
    return -1;
    80005780:	557d                	li	a0,-1
    80005782:	bfdd                	j	80005778 <uartgetc+0x1c>

0000000080005784 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005784:	1101                	addi	sp,sp,-32
    80005786:	ec06                	sd	ra,24(sp)
    80005788:	e822                	sd	s0,16(sp)
    8000578a:	e426                	sd	s1,8(sp)
    8000578c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000578e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005790:	fcdff0ef          	jal	8000575c <uartgetc>
    if(c == -1)
    80005794:	00950563          	beq	a0,s1,8000579e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005798:	861ff0ef          	jal	80004ff8 <consoleintr>
  while(1){
    8000579c:	bfd5                	j	80005790 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000579e:	0001e497          	auipc	s1,0x1e
    800057a2:	24a48493          	addi	s1,s1,586 # 800239e8 <uart_tx_lock>
    800057a6:	8526                	mv	a0,s1
    800057a8:	09c000ef          	jal	80005844 <acquire>
  uartstart();
    800057ac:	e6fff0ef          	jal	8000561a <uartstart>
  release(&uart_tx_lock);
    800057b0:	8526                	mv	a0,s1
    800057b2:	126000ef          	jal	800058d8 <release>
}
    800057b6:	60e2                	ld	ra,24(sp)
    800057b8:	6442                	ld	s0,16(sp)
    800057ba:	64a2                	ld	s1,8(sp)
    800057bc:	6105                	addi	sp,sp,32
    800057be:	8082                	ret

00000000800057c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800057c0:	1141                	addi	sp,sp,-16
    800057c2:	e406                	sd	ra,8(sp)
    800057c4:	e022                	sd	s0,0(sp)
    800057c6:	0800                	addi	s0,sp,16
  lk->name = name;
    800057c8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800057ca:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800057ce:	00053823          	sd	zero,16(a0)
}
    800057d2:	60a2                	ld	ra,8(sp)
    800057d4:	6402                	ld	s0,0(sp)
    800057d6:	0141                	addi	sp,sp,16
    800057d8:	8082                	ret

00000000800057da <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800057da:	411c                	lw	a5,0(a0)
    800057dc:	e399                	bnez	a5,800057e2 <holding+0x8>
    800057de:	4501                	li	a0,0
  return r;
}
    800057e0:	8082                	ret
{
    800057e2:	1101                	addi	sp,sp,-32
    800057e4:	ec06                	sd	ra,24(sp)
    800057e6:	e822                	sd	s0,16(sp)
    800057e8:	e426                	sd	s1,8(sp)
    800057ea:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800057ec:	6904                	ld	s1,16(a0)
    800057ee:	dc4fb0ef          	jal	80000db2 <mycpu>
    800057f2:	40a48533          	sub	a0,s1,a0
    800057f6:	00153513          	seqz	a0,a0
}
    800057fa:	60e2                	ld	ra,24(sp)
    800057fc:	6442                	ld	s0,16(sp)
    800057fe:	64a2                	ld	s1,8(sp)
    80005800:	6105                	addi	sp,sp,32
    80005802:	8082                	ret

0000000080005804 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005804:	1101                	addi	sp,sp,-32
    80005806:	ec06                	sd	ra,24(sp)
    80005808:	e822                	sd	s0,16(sp)
    8000580a:	e426                	sd	s1,8(sp)
    8000580c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000580e:	100024f3          	csrr	s1,sstatus
    80005812:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005816:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005818:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000581c:	d96fb0ef          	jal	80000db2 <mycpu>
    80005820:	5d3c                	lw	a5,120(a0)
    80005822:	cb99                	beqz	a5,80005838 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005824:	d8efb0ef          	jal	80000db2 <mycpu>
    80005828:	5d3c                	lw	a5,120(a0)
    8000582a:	2785                	addiw	a5,a5,1
    8000582c:	dd3c                	sw	a5,120(a0)
}
    8000582e:	60e2                	ld	ra,24(sp)
    80005830:	6442                	ld	s0,16(sp)
    80005832:	64a2                	ld	s1,8(sp)
    80005834:	6105                	addi	sp,sp,32
    80005836:	8082                	ret
    mycpu()->intena = old;
    80005838:	d7afb0ef          	jal	80000db2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000583c:	8085                	srli	s1,s1,0x1
    8000583e:	8885                	andi	s1,s1,1
    80005840:	dd64                	sw	s1,124(a0)
    80005842:	b7cd                	j	80005824 <push_off+0x20>

0000000080005844 <acquire>:
{
    80005844:	1101                	addi	sp,sp,-32
    80005846:	ec06                	sd	ra,24(sp)
    80005848:	e822                	sd	s0,16(sp)
    8000584a:	e426                	sd	s1,8(sp)
    8000584c:	1000                	addi	s0,sp,32
    8000584e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005850:	fb5ff0ef          	jal	80005804 <push_off>
  if(holding(lk))
    80005854:	8526                	mv	a0,s1
    80005856:	f85ff0ef          	jal	800057da <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000585a:	4705                	li	a4,1
  if(holding(lk))
    8000585c:	e105                	bnez	a0,8000587c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000585e:	87ba                	mv	a5,a4
    80005860:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005864:	2781                	sext.w	a5,a5
    80005866:	ffe5                	bnez	a5,8000585e <acquire+0x1a>
  __sync_synchronize();
    80005868:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000586c:	d46fb0ef          	jal	80000db2 <mycpu>
    80005870:	e888                	sd	a0,16(s1)
}
    80005872:	60e2                	ld	ra,24(sp)
    80005874:	6442                	ld	s0,16(sp)
    80005876:	64a2                	ld	s1,8(sp)
    80005878:	6105                	addi	sp,sp,32
    8000587a:	8082                	ret
    panic("acquire");
    8000587c:	00002517          	auipc	a0,0x2
    80005880:	f8450513          	addi	a0,a0,-124 # 80007800 <etext+0x800>
    80005884:	c93ff0ef          	jal	80005516 <panic>

0000000080005888 <pop_off>:

void
pop_off(void)
{
    80005888:	1141                	addi	sp,sp,-16
    8000588a:	e406                	sd	ra,8(sp)
    8000588c:	e022                	sd	s0,0(sp)
    8000588e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005890:	d22fb0ef          	jal	80000db2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005894:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005898:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000589a:	e39d                	bnez	a5,800058c0 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000589c:	5d3c                	lw	a5,120(a0)
    8000589e:	02f05763          	blez	a5,800058cc <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    800058a2:	37fd                	addiw	a5,a5,-1
    800058a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800058a6:	eb89                	bnez	a5,800058b8 <pop_off+0x30>
    800058a8:	5d7c                	lw	a5,124(a0)
    800058aa:	c799                	beqz	a5,800058b8 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800058b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800058b8:	60a2                	ld	ra,8(sp)
    800058ba:	6402                	ld	s0,0(sp)
    800058bc:	0141                	addi	sp,sp,16
    800058be:	8082                	ret
    panic("pop_off - interruptible");
    800058c0:	00002517          	auipc	a0,0x2
    800058c4:	f4850513          	addi	a0,a0,-184 # 80007808 <etext+0x808>
    800058c8:	c4fff0ef          	jal	80005516 <panic>
    panic("pop_off");
    800058cc:	00002517          	auipc	a0,0x2
    800058d0:	f5450513          	addi	a0,a0,-172 # 80007820 <etext+0x820>
    800058d4:	c43ff0ef          	jal	80005516 <panic>

00000000800058d8 <release>:
{
    800058d8:	1101                	addi	sp,sp,-32
    800058da:	ec06                	sd	ra,24(sp)
    800058dc:	e822                	sd	s0,16(sp)
    800058de:	e426                	sd	s1,8(sp)
    800058e0:	1000                	addi	s0,sp,32
    800058e2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800058e4:	ef7ff0ef          	jal	800057da <holding>
    800058e8:	c105                	beqz	a0,80005908 <release+0x30>
  lk->cpu = 0;
    800058ea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800058ee:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800058f2:	0310000f          	fence	rw,w
    800058f6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800058fa:	f8fff0ef          	jal	80005888 <pop_off>
}
    800058fe:	60e2                	ld	ra,24(sp)
    80005900:	6442                	ld	s0,16(sp)
    80005902:	64a2                	ld	s1,8(sp)
    80005904:	6105                	addi	sp,sp,32
    80005906:	8082                	ret
    panic("release");
    80005908:	00002517          	auipc	a0,0x2
    8000590c:	f2050513          	addi	a0,a0,-224 # 80007828 <etext+0x828>
    80005910:	c07ff0ef          	jal	80005516 <panic>
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
