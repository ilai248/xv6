
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	4a013103          	ld	sp,1184(sp) # 8000b4a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	15f050ef          	jal	80005974 <start>

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
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00025797          	auipc	a5,0x25
    80000034:	9f078793          	addi	a5,a5,-1552 # 80024a20 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000b917          	auipc	s2,0xb
    80000054:	4a090913          	addi	s2,s2,1184 # 8000b4f0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	482080e7          	jalr	1154(ra) # 800064dc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	51e080e7          	jalr	1310(ra) # 8000658c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	0d4080e7          	jalr	212(ra) # 8000615e <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	89be                	mv	s3,a5
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000b517          	auipc	a0,0xb
    800000f2:	40250513          	addi	a0,a0,1026 # 8000b4f0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	352080e7          	jalr	850(ra) # 80006448 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00025517          	auipc	a0,0x25
    80000106:	91e50513          	addi	a0,a0,-1762 # 80024a20 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000b497          	auipc	s1,0xb
    80000128:	3cc48493          	addi	s1,s1,972 # 8000b4f0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	3ae080e7          	jalr	942(ra) # 800064dc <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000b517          	auipc	a0,0xb
    80000140:	3b450513          	addi	a0,a0,948 # 8000b4f0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	446080e7          	jalr	1094(ra) # 8000658c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>

  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000b517          	auipc	a0,0xb
    8000016c:	38850513          	addi	a0,a0,904 # 8000b4f0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	41c080e7          	jalr	1052(ra) # 8000658c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <getFreeMem>:

uint64 getFreeMem(void)
{
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 freePages = 0;

  acquire(&kmem.lock);
    80000184:	0000b497          	auipc	s1,0xb
    80000188:	36c48493          	addi	s1,s1,876 # 8000b4f0 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	34e080e7          	jalr	846(ra) # 800064dc <acquire>
  r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  while (r) {
    80000198:	c785                	beqz	a5,800001c0 <getFreeMem+0x46>
  uint64 freePages = 0;
    8000019a:	4481                	li	s1,0
    r = r->next;
    8000019c:	639c                	ld	a5,0(a5)
    ++freePages;
    8000019e:	0485                	addi	s1,s1,1
  while (r) {
    800001a0:	fff5                	bnez	a5,8000019c <getFreeMem+0x22>
  }
  release(&kmem.lock);
    800001a2:	0000b517          	auipc	a0,0xb
    800001a6:	34e50513          	addi	a0,a0,846 # 8000b4f0 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	3e2080e7          	jalr	994(ra) # 8000658c <release>
  return freePages * PGSIZE;
}
    800001b2:	00c49513          	slli	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
  uint64 freePages = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <getFreeMem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e406                	sd	ra,8(sp)
    800001c8:	e022                	sd	s0,0(sp)
    800001ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001cc:	ca19                	beqz	a2,800001e2 <memset+0x1e>
    800001ce:	87aa                	mv	a5,a0
    800001d0:	1602                	slli	a2,a2,0x20
    800001d2:	9201                	srli	a2,a2,0x20
    800001d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x14>
  }
  return dst;
}
    800001e2:	60a2                	ld	ra,8(sp)
    800001e4:	6402                	ld	s0,0(sp)
    800001e6:	0141                	addi	sp,sp,16
    800001e8:	8082                	ret

00000000800001ea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001ea:	1141                	addi	sp,sp,-16
    800001ec:	e406                	sd	ra,8(sp)
    800001ee:	e022                	sd	s0,0(sp)
    800001f0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001f2:	ca0d                	beqz	a2,80000224 <memcmp+0x3a>
    800001f4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f8:	1682                	slli	a3,a3,0x20
    800001fa:	9281                	srli	a3,a3,0x20
    800001fc:	0685                	addi	a3,a3,1
    800001fe:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000200:	00054783          	lbu	a5,0(a0)
    80000204:	0005c703          	lbu	a4,0(a1)
    80000208:	00e79863          	bne	a5,a4,80000218 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    8000020c:	0505                	addi	a0,a0,1
    8000020e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000210:	fed518e3          	bne	a0,a3,80000200 <memcmp+0x16>
  }

  return 0;
    80000214:	4501                	li	a0,0
    80000216:	a019                	j	8000021c <memcmp+0x32>
      return *s1 - *s2;
    80000218:	40e7853b          	subw	a0,a5,a4
}
    8000021c:	60a2                	ld	ra,8(sp)
    8000021e:	6402                	ld	s0,0(sp)
    80000220:	0141                	addi	sp,sp,16
    80000222:	8082                	ret
  return 0;
    80000224:	4501                	li	a0,0
    80000226:	bfdd                	j	8000021c <memcmp+0x32>

0000000080000228 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000228:	1141                	addi	sp,sp,-16
    8000022a:	e406                	sd	ra,8(sp)
    8000022c:	e022                	sd	s0,0(sp)
    8000022e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000230:	c205                	beqz	a2,80000250 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000232:	02a5e363          	bltu	a1,a0,80000258 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000236:	1602                	slli	a2,a2,0x20
    80000238:	9201                	srli	a2,a2,0x20
    8000023a:	00c587b3          	add	a5,a1,a2
{
    8000023e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000240:	0585                	addi	a1,a1,1
    80000242:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda5e1>
    80000244:	fff5c683          	lbu	a3,-1(a1)
    80000248:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000024c:	feb79ae3          	bne	a5,a1,80000240 <memmove+0x18>

  return dst;
}
    80000250:	60a2                	ld	ra,8(sp)
    80000252:	6402                	ld	s0,0(sp)
    80000254:	0141                	addi	sp,sp,16
    80000256:	8082                	ret
  if(s < d && s + n > d){
    80000258:	02061693          	slli	a3,a2,0x20
    8000025c:	9281                	srli	a3,a3,0x20
    8000025e:	00d58733          	add	a4,a1,a3
    80000262:	fce57ae3          	bgeu	a0,a4,80000236 <memmove+0xe>
    d += n;
    80000266:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000268:	fff6079b          	addiw	a5,a2,-1
    8000026c:	1782                	slli	a5,a5,0x20
    8000026e:	9381                	srli	a5,a5,0x20
    80000270:	fff7c793          	not	a5,a5
    80000274:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000276:	177d                	addi	a4,a4,-1
    80000278:	16fd                	addi	a3,a3,-1
    8000027a:	00074603          	lbu	a2,0(a4)
    8000027e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000282:	fee79ae3          	bne	a5,a4,80000276 <memmove+0x4e>
    80000286:	b7e9                	j	80000250 <memmove+0x28>

0000000080000288 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000288:	1141                	addi	sp,sp,-16
    8000028a:	e406                	sd	ra,8(sp)
    8000028c:	e022                	sd	s0,0(sp)
    8000028e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000290:	00000097          	auipc	ra,0x0
    80000294:	f98080e7          	jalr	-104(ra) # 80000228 <memmove>
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a8:	ce11                	beqz	a2,800002c4 <strncmp+0x24>
    800002aa:	00054783          	lbu	a5,0(a0)
    800002ae:	cf89                	beqz	a5,800002c8 <strncmp+0x28>
    800002b0:	0005c703          	lbu	a4,0(a1)
    800002b4:	00f71a63          	bne	a4,a5,800002c8 <strncmp+0x28>
    n--, p++, q++;
    800002b8:	367d                	addiw	a2,a2,-1
    800002ba:	0505                	addi	a0,a0,1
    800002bc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002be:	f675                	bnez	a2,800002aa <strncmp+0xa>
  if(n == 0)
    return 0;
    800002c0:	4501                	li	a0,0
    800002c2:	a801                	j	800002d2 <strncmp+0x32>
    800002c4:	4501                	li	a0,0
    800002c6:	a031                	j	800002d2 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    800002c8:	00054503          	lbu	a0,0(a0)
    800002cc:	0005c783          	lbu	a5,0(a1)
    800002d0:	9d1d                	subw	a0,a0,a5
}
    800002d2:	60a2                	ld	ra,8(sp)
    800002d4:	6402                	ld	s0,0(sp)
    800002d6:	0141                	addi	sp,sp,16
    800002d8:	8082                	ret

00000000800002da <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002da:	1141                	addi	sp,sp,-16
    800002dc:	e406                	sd	ra,8(sp)
    800002de:	e022                	sd	s0,0(sp)
    800002e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002e2:	87aa                	mv	a5,a0
    800002e4:	86b2                	mv	a3,a2
    800002e6:	367d                	addiw	a2,a2,-1
    800002e8:	02d05563          	blez	a3,80000312 <strncpy+0x38>
    800002ec:	0785                	addi	a5,a5,1
    800002ee:	0005c703          	lbu	a4,0(a1)
    800002f2:	fee78fa3          	sb	a4,-1(a5)
    800002f6:	0585                	addi	a1,a1,1
    800002f8:	f775                	bnez	a4,800002e4 <strncpy+0xa>
    ;
  while(n-- > 0)
    800002fa:	873e                	mv	a4,a5
    800002fc:	00c05b63          	blez	a2,80000312 <strncpy+0x38>
    80000300:	9fb5                	addw	a5,a5,a3
    80000302:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000304:	0705                	addi	a4,a4,1
    80000306:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000030a:	40e786bb          	subw	a3,a5,a4
    8000030e:	fed04be3          	bgtz	a3,80000304 <strncpy+0x2a>
  return os;
}
    80000312:	60a2                	ld	ra,8(sp)
    80000314:	6402                	ld	s0,0(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret

000000008000031a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e406                	sd	ra,8(sp)
    8000031e:	e022                	sd	s0,0(sp)
    80000320:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000322:	02c05363          	blez	a2,80000348 <safestrcpy+0x2e>
    80000326:	fff6069b          	addiw	a3,a2,-1
    8000032a:	1682                	slli	a3,a3,0x20
    8000032c:	9281                	srli	a3,a3,0x20
    8000032e:	96ae                	add	a3,a3,a1
    80000330:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000332:	00d58963          	beq	a1,a3,80000344 <safestrcpy+0x2a>
    80000336:	0585                	addi	a1,a1,1
    80000338:	0785                	addi	a5,a5,1
    8000033a:	fff5c703          	lbu	a4,-1(a1)
    8000033e:	fee78fa3          	sb	a4,-1(a5)
    80000342:	fb65                	bnez	a4,80000332 <safestrcpy+0x18>
    ;
  *s = 0;
    80000344:	00078023          	sb	zero,0(a5)
  return os;
}
    80000348:	60a2                	ld	ra,8(sp)
    8000034a:	6402                	ld	s0,0(sp)
    8000034c:	0141                	addi	sp,sp,16
    8000034e:	8082                	ret

0000000080000350 <strlen>:

int
strlen(const char *s)
{
    80000350:	1141                	addi	sp,sp,-16
    80000352:	e406                	sd	ra,8(sp)
    80000354:	e022                	sd	s0,0(sp)
    80000356:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000358:	00054783          	lbu	a5,0(a0)
    8000035c:	cf99                	beqz	a5,8000037a <strlen+0x2a>
    8000035e:	0505                	addi	a0,a0,1
    80000360:	87aa                	mv	a5,a0
    80000362:	86be                	mv	a3,a5
    80000364:	0785                	addi	a5,a5,1
    80000366:	fff7c703          	lbu	a4,-1(a5)
    8000036a:	ff65                	bnez	a4,80000362 <strlen+0x12>
    8000036c:	40a6853b          	subw	a0,a3,a0
    80000370:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000372:	60a2                	ld	ra,8(sp)
    80000374:	6402                	ld	s0,0(sp)
    80000376:	0141                	addi	sp,sp,16
    80000378:	8082                	ret
  for(n = 0; s[n]; n++)
    8000037a:	4501                	li	a0,0
    8000037c:	bfdd                	j	80000372 <strlen+0x22>

000000008000037e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000037e:	1141                	addi	sp,sp,-16
    80000380:	e406                	sd	ra,8(sp)
    80000382:	e022                	sd	s0,0(sp)
    80000384:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000386:	00001097          	auipc	ra,0x1
    8000038a:	bc0080e7          	jalr	-1088(ra) # 80000f46 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000038e:	0000b717          	auipc	a4,0xb
    80000392:	13270713          	addi	a4,a4,306 # 8000b4c0 <started>
  if(cpuid() == 0){
    80000396:	c139                	beqz	a0,800003dc <main+0x5e>
    while(started == 0)
    80000398:	431c                	lw	a5,0(a4)
    8000039a:	2781                	sext.w	a5,a5
    8000039c:	dff5                	beqz	a5,80000398 <main+0x1a>
      ;
    __sync_synchronize();
    8000039e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800003a2:	00001097          	auipc	ra,0x1
    800003a6:	ba4080e7          	jalr	-1116(ra) # 80000f46 <cpuid>
    800003aa:	85aa                	mv	a1,a0
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c8c50513          	addi	a0,a0,-884 # 80008038 <etext+0x38>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	a8e080e7          	jalr	-1394(ra) # 80005e42 <printf>
    kvminithart();    // turn on paging
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	0d8080e7          	jalr	216(ra) # 80000494 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003c4:	00002097          	auipc	ra,0x2
    800003c8:	880080e7          	jalr	-1920(ra) # 80001c44 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003cc:	00005097          	auipc	ra,0x5
    800003d0:	f7c080e7          	jalr	-132(ra) # 80005348 <plicinithart>
  }

  scheduler();        
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	0ae080e7          	jalr	174(ra) # 80001482 <scheduler>
    consoleinit();
    800003dc:	00006097          	auipc	ra,0x6
    800003e0:	98c080e7          	jalr	-1652(ra) # 80005d68 <consoleinit>
    printfinit();
    800003e4:	00006097          	auipc	ra,0x6
    800003e8:	dbc080e7          	jalr	-580(ra) # 800061a0 <printfinit>
    printf("\n");
    800003ec:	00008517          	auipc	a0,0x8
    800003f0:	c2c50513          	addi	a0,a0,-980 # 80008018 <etext+0x18>
    800003f4:	00006097          	auipc	ra,0x6
    800003f8:	a4e080e7          	jalr	-1458(ra) # 80005e42 <printf>
    printf("xv6 kernel is booting\n");
    800003fc:	00008517          	auipc	a0,0x8
    80000400:	c2450513          	addi	a0,a0,-988 # 80008020 <etext+0x20>
    80000404:	00006097          	auipc	ra,0x6
    80000408:	a3e080e7          	jalr	-1474(ra) # 80005e42 <printf>
    printf("\n");
    8000040c:	00008517          	auipc	a0,0x8
    80000410:	c0c50513          	addi	a0,a0,-1012 # 80008018 <etext+0x18>
    80000414:	00006097          	auipc	ra,0x6
    80000418:	a2e080e7          	jalr	-1490(ra) # 80005e42 <printf>
    kinit();         // physical page allocator
    8000041c:	00000097          	auipc	ra,0x0
    80000420:	cc2080e7          	jalr	-830(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000424:	00000097          	auipc	ra,0x0
    80000428:	34e080e7          	jalr	846(ra) # 80000772 <kvminit>
    kvminithart();   // turn on paging
    8000042c:	00000097          	auipc	ra,0x0
    80000430:	068080e7          	jalr	104(ra) # 80000494 <kvminithart>
    procinit();      // process table
    80000434:	00001097          	auipc	ra,0x1
    80000438:	a56080e7          	jalr	-1450(ra) # 80000e8a <procinit>
    trapinit();      // trap vectors
    8000043c:	00001097          	auipc	ra,0x1
    80000440:	7e0080e7          	jalr	2016(ra) # 80001c1c <trapinit>
    trapinithart();  // install kernel trap vector
    80000444:	00002097          	auipc	ra,0x2
    80000448:	800080e7          	jalr	-2048(ra) # 80001c44 <trapinithart>
    plicinit();      // set up interrupt controller
    8000044c:	00005097          	auipc	ra,0x5
    80000450:	ee2080e7          	jalr	-286(ra) # 8000532e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000454:	00005097          	auipc	ra,0x5
    80000458:	ef4080e7          	jalr	-268(ra) # 80005348 <plicinithart>
    binit();         // buffer cache
    8000045c:	00002097          	auipc	ra,0x2
    80000460:	fda080e7          	jalr	-38(ra) # 80002436 <binit>
    iinit();         // inode table
    80000464:	00002097          	auipc	ra,0x2
    80000468:	66a080e7          	jalr	1642(ra) # 80002ace <iinit>
    fileinit();      // file table
    8000046c:	00003097          	auipc	ra,0x3
    80000470:	63c080e7          	jalr	1596(ra) # 80003aa8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000474:	00005097          	auipc	ra,0x5
    80000478:	fdc080e7          	jalr	-36(ra) # 80005450 <virtio_disk_init>
    userinit();      // first user process
    8000047c:	00001097          	auipc	ra,0x1
    80000480:	dde080e7          	jalr	-546(ra) # 8000125a <userinit>
    __sync_synchronize();
    80000484:	0330000f          	fence	rw,rw
    started = 1;
    80000488:	4785                	li	a5,1
    8000048a:	0000b717          	auipc	a4,0xb
    8000048e:	02f72b23          	sw	a5,54(a4) # 8000b4c0 <started>
    80000492:	b789                	j	800003d4 <main+0x56>

0000000080000494 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000494:	1141                	addi	sp,sp,-16
    80000496:	e406                	sd	ra,8(sp)
    80000498:	e022                	sd	s0,0(sp)
    8000049a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000049c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800004a0:	0000b797          	auipc	a5,0xb
    800004a4:	0287b783          	ld	a5,40(a5) # 8000b4c8 <kernel_pagetable>
    800004a8:	83b1                	srli	a5,a5,0xc
    800004aa:	577d                	li	a4,-1
    800004ac:	177e                	slli	a4,a4,0x3f
    800004ae:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800004b0:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004b4:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004b8:	60a2                	ld	ra,8(sp)
    800004ba:	6402                	ld	s0,0(sp)
    800004bc:	0141                	addi	sp,sp,16
    800004be:	8082                	ret

00000000800004c0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004c0:	7139                	addi	sp,sp,-64
    800004c2:	fc06                	sd	ra,56(sp)
    800004c4:	f822                	sd	s0,48(sp)
    800004c6:	f426                	sd	s1,40(sp)
    800004c8:	f04a                	sd	s2,32(sp)
    800004ca:	ec4e                	sd	s3,24(sp)
    800004cc:	e852                	sd	s4,16(sp)
    800004ce:	e456                	sd	s5,8(sp)
    800004d0:	e05a                	sd	s6,0(sp)
    800004d2:	0080                	addi	s0,sp,64
    800004d4:	84aa                	mv	s1,a0
    800004d6:	89ae                	mv	s3,a1
    800004d8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004da:	57fd                	li	a5,-1
    800004dc:	83e9                	srli	a5,a5,0x1a
    800004de:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004e0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004e2:	04b7e263          	bltu	a5,a1,80000526 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e6:	0149d933          	srl	s2,s3,s4
    800004ea:	1ff97913          	andi	s2,s2,511
    800004ee:	090e                	slli	s2,s2,0x3
    800004f0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f2:	00093483          	ld	s1,0(s2)
    800004f6:	0014f793          	andi	a5,s1,1
    800004fa:	cf95                	beqz	a5,80000536 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004fc:	80a9                	srli	s1,s1,0xa
    800004fe:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000500:	3a5d                	addiw	s4,s4,-9
    80000502:	ff6a12e3          	bne	s4,s6,800004e6 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000506:	00c9d513          	srli	a0,s3,0xc
    8000050a:	1ff57513          	andi	a0,a0,511
    8000050e:	050e                	slli	a0,a0,0x3
    80000510:	9526                	add	a0,a0,s1
}
    80000512:	70e2                	ld	ra,56(sp)
    80000514:	7442                	ld	s0,48(sp)
    80000516:	74a2                	ld	s1,40(sp)
    80000518:	7902                	ld	s2,32(sp)
    8000051a:	69e2                	ld	s3,24(sp)
    8000051c:	6a42                	ld	s4,16(sp)
    8000051e:	6aa2                	ld	s5,8(sp)
    80000520:	6b02                	ld	s6,0(sp)
    80000522:	6121                	addi	sp,sp,64
    80000524:	8082                	ret
    panic("walk");
    80000526:	00008517          	auipc	a0,0x8
    8000052a:	b2a50513          	addi	a0,a0,-1238 # 80008050 <etext+0x50>
    8000052e:	00006097          	auipc	ra,0x6
    80000532:	c30080e7          	jalr	-976(ra) # 8000615e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000536:	020a8663          	beqz	s5,80000562 <walk+0xa2>
    8000053a:	00000097          	auipc	ra,0x0
    8000053e:	be0080e7          	jalr	-1056(ra) # 8000011a <kalloc>
    80000542:	84aa                	mv	s1,a0
    80000544:	d579                	beqz	a0,80000512 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000546:	6605                	lui	a2,0x1
    80000548:	4581                	li	a1,0
    8000054a:	00000097          	auipc	ra,0x0
    8000054e:	c7a080e7          	jalr	-902(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000552:	00c4d793          	srli	a5,s1,0xc
    80000556:	07aa                	slli	a5,a5,0xa
    80000558:	0017e793          	ori	a5,a5,1
    8000055c:	00f93023          	sd	a5,0(s2)
    80000560:	b745                	j	80000500 <walk+0x40>
        return 0;
    80000562:	4501                	li	a0,0
    80000564:	b77d                	j	80000512 <walk+0x52>

0000000080000566 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000566:	57fd                	li	a5,-1
    80000568:	83e9                	srli	a5,a5,0x1a
    8000056a:	00b7f463          	bgeu	a5,a1,80000572 <walkaddr+0xc>
    return 0;
    8000056e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000570:	8082                	ret
{
    80000572:	1141                	addi	sp,sp,-16
    80000574:	e406                	sd	ra,8(sp)
    80000576:	e022                	sd	s0,0(sp)
    80000578:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000057a:	4601                	li	a2,0
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	f44080e7          	jalr	-188(ra) # 800004c0 <walk>
  if(pte == 0)
    80000584:	c105                	beqz	a0,800005a4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000586:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000588:	0117f693          	andi	a3,a5,17
    8000058c:	4745                	li	a4,17
    return 0;
    8000058e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000590:	00e68663          	beq	a3,a4,8000059c <walkaddr+0x36>
}
    80000594:	60a2                	ld	ra,8(sp)
    80000596:	6402                	ld	s0,0(sp)
    80000598:	0141                	addi	sp,sp,16
    8000059a:	8082                	ret
  pa = PTE2PA(*pte);
    8000059c:	83a9                	srli	a5,a5,0xa
    8000059e:	00c79513          	slli	a0,a5,0xc
  return pa;
    800005a2:	bfcd                	j	80000594 <walkaddr+0x2e>
    return 0;
    800005a4:	4501                	li	a0,0
    800005a6:	b7fd                	j	80000594 <walkaddr+0x2e>

00000000800005a8 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005a8:	715d                	addi	sp,sp,-80
    800005aa:	e486                	sd	ra,72(sp)
    800005ac:	e0a2                	sd	s0,64(sp)
    800005ae:	fc26                	sd	s1,56(sp)
    800005b0:	f84a                	sd	s2,48(sp)
    800005b2:	f44e                	sd	s3,40(sp)
    800005b4:	f052                	sd	s4,32(sp)
    800005b6:	ec56                	sd	s5,24(sp)
    800005b8:	e85a                	sd	s6,16(sp)
    800005ba:	e45e                	sd	s7,8(sp)
    800005bc:	e062                	sd	s8,0(sp)
    800005be:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800005c0:	03459793          	slli	a5,a1,0x34
    800005c4:	eba1                	bnez	a5,80000614 <mappages+0x6c>
    800005c6:	8aaa                	mv	s5,a0
    800005c8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800005ca:	03461793          	slli	a5,a2,0x34
    800005ce:	ebb9                	bnez	a5,80000624 <mappages+0x7c>
    panic("mappages: size not aligned");

  if(size == 0)
    800005d0:	c235                	beqz	a2,80000634 <mappages+0x8c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800005d2:	77fd                	lui	a5,0xfffff
    800005d4:	963e                	add	a2,a2,a5
    800005d6:	00b609b3          	add	s3,a2,a1
  a = va;
    800005da:	892e                	mv	s2,a1
    800005dc:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e0:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005e2:	6c05                	lui	s8,0x1
    800005e4:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e8:	865e                	mv	a2,s7
    800005ea:	85ca                	mv	a1,s2
    800005ec:	8556                	mv	a0,s5
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	ed2080e7          	jalr	-302(ra) # 800004c0 <walk>
    800005f6:	cd39                	beqz	a0,80000654 <mappages+0xac>
    if(*pte & PTE_V)
    800005f8:	611c                	ld	a5,0(a0)
    800005fa:	8b85                	andi	a5,a5,1
    800005fc:	e7a1                	bnez	a5,80000644 <mappages+0x9c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005fe:	80b1                	srli	s1,s1,0xc
    80000600:	04aa                	slli	s1,s1,0xa
    80000602:	0164e4b3          	or	s1,s1,s6
    80000606:	0014e493          	ori	s1,s1,1
    8000060a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000060c:	07390163          	beq	s2,s3,8000066e <mappages+0xc6>
    a += PGSIZE;
    80000610:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000612:	bfc9                	j	800005e4 <mappages+0x3c>
    panic("mappages: va not aligned");
    80000614:	00008517          	auipc	a0,0x8
    80000618:	a4450513          	addi	a0,a0,-1468 # 80008058 <etext+0x58>
    8000061c:	00006097          	auipc	ra,0x6
    80000620:	b42080e7          	jalr	-1214(ra) # 8000615e <panic>
    panic("mappages: size not aligned");
    80000624:	00008517          	auipc	a0,0x8
    80000628:	a5450513          	addi	a0,a0,-1452 # 80008078 <etext+0x78>
    8000062c:	00006097          	auipc	ra,0x6
    80000630:	b32080e7          	jalr	-1230(ra) # 8000615e <panic>
    panic("mappages: size");
    80000634:	00008517          	auipc	a0,0x8
    80000638:	a6450513          	addi	a0,a0,-1436 # 80008098 <etext+0x98>
    8000063c:	00006097          	auipc	ra,0x6
    80000640:	b22080e7          	jalr	-1246(ra) # 8000615e <panic>
      panic("mappages: remap");
    80000644:	00008517          	auipc	a0,0x8
    80000648:	a6450513          	addi	a0,a0,-1436 # 800080a8 <etext+0xa8>
    8000064c:	00006097          	auipc	ra,0x6
    80000650:	b12080e7          	jalr	-1262(ra) # 8000615e <panic>
      return -1;
    80000654:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000656:	60a6                	ld	ra,72(sp)
    80000658:	6406                	ld	s0,64(sp)
    8000065a:	74e2                	ld	s1,56(sp)
    8000065c:	7942                	ld	s2,48(sp)
    8000065e:	79a2                	ld	s3,40(sp)
    80000660:	7a02                	ld	s4,32(sp)
    80000662:	6ae2                	ld	s5,24(sp)
    80000664:	6b42                	ld	s6,16(sp)
    80000666:	6ba2                	ld	s7,8(sp)
    80000668:	6c02                	ld	s8,0(sp)
    8000066a:	6161                	addi	sp,sp,80
    8000066c:	8082                	ret
  return 0;
    8000066e:	4501                	li	a0,0
    80000670:	b7dd                	j	80000656 <mappages+0xae>

0000000080000672 <kvmmap>:
{
    80000672:	1141                	addi	sp,sp,-16
    80000674:	e406                	sd	ra,8(sp)
    80000676:	e022                	sd	s0,0(sp)
    80000678:	0800                	addi	s0,sp,16
    8000067a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000067c:	86b2                	mv	a3,a2
    8000067e:	863e                	mv	a2,a5
    80000680:	00000097          	auipc	ra,0x0
    80000684:	f28080e7          	jalr	-216(ra) # 800005a8 <mappages>
    80000688:	e509                	bnez	a0,80000692 <kvmmap+0x20>
}
    8000068a:	60a2                	ld	ra,8(sp)
    8000068c:	6402                	ld	s0,0(sp)
    8000068e:	0141                	addi	sp,sp,16
    80000690:	8082                	ret
    panic("kvmmap");
    80000692:	00008517          	auipc	a0,0x8
    80000696:	a2650513          	addi	a0,a0,-1498 # 800080b8 <etext+0xb8>
    8000069a:	00006097          	auipc	ra,0x6
    8000069e:	ac4080e7          	jalr	-1340(ra) # 8000615e <panic>

00000000800006a2 <kvmmake>:
{
    800006a2:	1101                	addi	sp,sp,-32
    800006a4:	ec06                	sd	ra,24(sp)
    800006a6:	e822                	sd	s0,16(sp)
    800006a8:	e426                	sd	s1,8(sp)
    800006aa:	e04a                	sd	s2,0(sp)
    800006ac:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	a6c080e7          	jalr	-1428(ra) # 8000011a <kalloc>
    800006b6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006b8:	6605                	lui	a2,0x1
    800006ba:	4581                	li	a1,0
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	b08080e7          	jalr	-1272(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006c4:	4719                	li	a4,6
    800006c6:	6685                	lui	a3,0x1
    800006c8:	10000637          	lui	a2,0x10000
    800006cc:	85b2                	mv	a1,a2
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	fa2080e7          	jalr	-94(ra) # 80000672 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006d8:	4719                	li	a4,6
    800006da:	6685                	lui	a3,0x1
    800006dc:	10001637          	lui	a2,0x10001
    800006e0:	85b2                	mv	a1,a2
    800006e2:	8526                	mv	a0,s1
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	f8e080e7          	jalr	-114(ra) # 80000672 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800006ec:	4719                	li	a4,6
    800006ee:	040006b7          	lui	a3,0x4000
    800006f2:	0c000637          	lui	a2,0xc000
    800006f6:	85b2                	mv	a1,a2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f78080e7          	jalr	-136(ra) # 80000672 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000702:	00008917          	auipc	s2,0x8
    80000706:	8fe90913          	addi	s2,s2,-1794 # 80008000 <etext>
    8000070a:	4729                	li	a4,10
    8000070c:	80008697          	auipc	a3,0x80008
    80000710:	8f468693          	addi	a3,a3,-1804 # 8000 <_entry-0x7fff8000>
    80000714:	4605                	li	a2,1
    80000716:	067e                	slli	a2,a2,0x1f
    80000718:	85b2                	mv	a1,a2
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	f56080e7          	jalr	-170(ra) # 80000672 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000724:	4719                	li	a4,6
    80000726:	46c5                	li	a3,17
    80000728:	06ee                	slli	a3,a3,0x1b
    8000072a:	412686b3          	sub	a3,a3,s2
    8000072e:	864a                	mv	a2,s2
    80000730:	85ca                	mv	a1,s2
    80000732:	8526                	mv	a0,s1
    80000734:	00000097          	auipc	ra,0x0
    80000738:	f3e080e7          	jalr	-194(ra) # 80000672 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000073c:	4729                	li	a4,10
    8000073e:	6685                	lui	a3,0x1
    80000740:	00007617          	auipc	a2,0x7
    80000744:	8c060613          	addi	a2,a2,-1856 # 80007000 <_trampoline>
    80000748:	040005b7          	lui	a1,0x4000
    8000074c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000074e:	05b2                	slli	a1,a1,0xc
    80000750:	8526                	mv	a0,s1
    80000752:	00000097          	auipc	ra,0x0
    80000756:	f20080e7          	jalr	-224(ra) # 80000672 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000075a:	8526                	mv	a0,s1
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	684080e7          	jalr	1668(ra) # 80000de0 <proc_mapstacks>
}
    80000764:	8526                	mv	a0,s1
    80000766:	60e2                	ld	ra,24(sp)
    80000768:	6442                	ld	s0,16(sp)
    8000076a:	64a2                	ld	s1,8(sp)
    8000076c:	6902                	ld	s2,0(sp)
    8000076e:	6105                	addi	sp,sp,32
    80000770:	8082                	ret

0000000080000772 <kvminit>:
{
    80000772:	1141                	addi	sp,sp,-16
    80000774:	e406                	sd	ra,8(sp)
    80000776:	e022                	sd	s0,0(sp)
    80000778:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	f28080e7          	jalr	-216(ra) # 800006a2 <kvmmake>
    80000782:	0000b797          	auipc	a5,0xb
    80000786:	d4a7b323          	sd	a0,-698(a5) # 8000b4c8 <kernel_pagetable>
}
    8000078a:	60a2                	ld	ra,8(sp)
    8000078c:	6402                	ld	s0,0(sp)
    8000078e:	0141                	addi	sp,sp,16
    80000790:	8082                	ret

0000000080000792 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000792:	715d                	addi	sp,sp,-80
    80000794:	e486                	sd	ra,72(sp)
    80000796:	e0a2                	sd	s0,64(sp)
    80000798:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000079a:	03459793          	slli	a5,a1,0x34
    8000079e:	e39d                	bnez	a5,800007c4 <uvmunmap+0x32>
    800007a0:	f84a                	sd	s2,48(sp)
    800007a2:	f44e                	sd	s3,40(sp)
    800007a4:	f052                	sd	s4,32(sp)
    800007a6:	ec56                	sd	s5,24(sp)
    800007a8:	e85a                	sd	s6,16(sp)
    800007aa:	e45e                	sd	s7,8(sp)
    800007ac:	8a2a                	mv	s4,a0
    800007ae:	892e                	mv	s2,a1
    800007b0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b2:	0632                	slli	a2,a2,0xc
    800007b4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ba:	6b05                	lui	s6,0x1
    800007bc:	0935fb63          	bgeu	a1,s3,80000852 <uvmunmap+0xc0>
    800007c0:	fc26                	sd	s1,56(sp)
    800007c2:	a8a9                	j	8000081c <uvmunmap+0x8a>
    800007c4:	fc26                	sd	s1,56(sp)
    800007c6:	f84a                	sd	s2,48(sp)
    800007c8:	f44e                	sd	s3,40(sp)
    800007ca:	f052                	sd	s4,32(sp)
    800007cc:	ec56                	sd	s5,24(sp)
    800007ce:	e85a                	sd	s6,16(sp)
    800007d0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800007d2:	00008517          	auipc	a0,0x8
    800007d6:	8ee50513          	addi	a0,a0,-1810 # 800080c0 <etext+0xc0>
    800007da:	00006097          	auipc	ra,0x6
    800007de:	984080e7          	jalr	-1660(ra) # 8000615e <panic>
      panic("uvmunmap: walk");
    800007e2:	00008517          	auipc	a0,0x8
    800007e6:	8f650513          	addi	a0,a0,-1802 # 800080d8 <etext+0xd8>
    800007ea:	00006097          	auipc	ra,0x6
    800007ee:	974080e7          	jalr	-1676(ra) # 8000615e <panic>
      panic("uvmunmap: not mapped");
    800007f2:	00008517          	auipc	a0,0x8
    800007f6:	8f650513          	addi	a0,a0,-1802 # 800080e8 <etext+0xe8>
    800007fa:	00006097          	auipc	ra,0x6
    800007fe:	964080e7          	jalr	-1692(ra) # 8000615e <panic>
      panic("uvmunmap: not a leaf");
    80000802:	00008517          	auipc	a0,0x8
    80000806:	8fe50513          	addi	a0,a0,-1794 # 80008100 <etext+0x100>
    8000080a:	00006097          	auipc	ra,0x6
    8000080e:	954080e7          	jalr	-1708(ra) # 8000615e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000812:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000816:	995a                	add	s2,s2,s6
    80000818:	03397c63          	bgeu	s2,s3,80000850 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000081c:	4601                	li	a2,0
    8000081e:	85ca                	mv	a1,s2
    80000820:	8552                	mv	a0,s4
    80000822:	00000097          	auipc	ra,0x0
    80000826:	c9e080e7          	jalr	-866(ra) # 800004c0 <walk>
    8000082a:	84aa                	mv	s1,a0
    8000082c:	d95d                	beqz	a0,800007e2 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000082e:	6108                	ld	a0,0(a0)
    80000830:	00157793          	andi	a5,a0,1
    80000834:	dfdd                	beqz	a5,800007f2 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000836:	3ff57793          	andi	a5,a0,1023
    8000083a:	fd7784e3          	beq	a5,s7,80000802 <uvmunmap+0x70>
    if(do_free){
    8000083e:	fc0a8ae3          	beqz	s5,80000812 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000842:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000844:	0532                	slli	a0,a0,0xc
    80000846:	fffff097          	auipc	ra,0xfffff
    8000084a:	7d6080e7          	jalr	2006(ra) # 8000001c <kfree>
    8000084e:	b7d1                	j	80000812 <uvmunmap+0x80>
    80000850:	74e2                	ld	s1,56(sp)
    80000852:	7942                	ld	s2,48(sp)
    80000854:	79a2                	ld	s3,40(sp)
    80000856:	7a02                	ld	s4,32(sp)
    80000858:	6ae2                	ld	s5,24(sp)
    8000085a:	6b42                	ld	s6,16(sp)
    8000085c:	6ba2                	ld	s7,8(sp)
  }
}
    8000085e:	60a6                	ld	ra,72(sp)
    80000860:	6406                	ld	s0,64(sp)
    80000862:	6161                	addi	sp,sp,80
    80000864:	8082                	ret

0000000080000866 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000866:	1101                	addi	sp,sp,-32
    80000868:	ec06                	sd	ra,24(sp)
    8000086a:	e822                	sd	s0,16(sp)
    8000086c:	e426                	sd	s1,8(sp)
    8000086e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000870:	00000097          	auipc	ra,0x0
    80000874:	8aa080e7          	jalr	-1878(ra) # 8000011a <kalloc>
    80000878:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000087a:	c519                	beqz	a0,80000888 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000087c:	6605                	lui	a2,0x1
    8000087e:	4581                	li	a1,0
    80000880:	00000097          	auipc	ra,0x0
    80000884:	944080e7          	jalr	-1724(ra) # 800001c4 <memset>
  return pagetable;
}
    80000888:	8526                	mv	a0,s1
    8000088a:	60e2                	ld	ra,24(sp)
    8000088c:	6442                	ld	s0,16(sp)
    8000088e:	64a2                	ld	s1,8(sp)
    80000890:	6105                	addi	sp,sp,32
    80000892:	8082                	ret

0000000080000894 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000894:	7179                	addi	sp,sp,-48
    80000896:	f406                	sd	ra,40(sp)
    80000898:	f022                	sd	s0,32(sp)
    8000089a:	ec26                	sd	s1,24(sp)
    8000089c:	e84a                	sd	s2,16(sp)
    8000089e:	e44e                	sd	s3,8(sp)
    800008a0:	e052                	sd	s4,0(sp)
    800008a2:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800008a4:	6785                	lui	a5,0x1
    800008a6:	04f67863          	bgeu	a2,a5,800008f6 <uvmfirst+0x62>
    800008aa:	8a2a                	mv	s4,a0
    800008ac:	89ae                	mv	s3,a1
    800008ae:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	86a080e7          	jalr	-1942(ra) # 8000011a <kalloc>
    800008b8:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008ba:	6605                	lui	a2,0x1
    800008bc:	4581                	li	a1,0
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	906080e7          	jalr	-1786(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008c6:	4779                	li	a4,30
    800008c8:	86ca                	mv	a3,s2
    800008ca:	6605                	lui	a2,0x1
    800008cc:	4581                	li	a1,0
    800008ce:	8552                	mv	a0,s4
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	cd8080e7          	jalr	-808(ra) # 800005a8 <mappages>
  memmove(mem, src, sz);
    800008d8:	8626                	mv	a2,s1
    800008da:	85ce                	mv	a1,s3
    800008dc:	854a                	mv	a0,s2
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	94a080e7          	jalr	-1718(ra) # 80000228 <memmove>
}
    800008e6:	70a2                	ld	ra,40(sp)
    800008e8:	7402                	ld	s0,32(sp)
    800008ea:	64e2                	ld	s1,24(sp)
    800008ec:	6942                	ld	s2,16(sp)
    800008ee:	69a2                	ld	s3,8(sp)
    800008f0:	6a02                	ld	s4,0(sp)
    800008f2:	6145                	addi	sp,sp,48
    800008f4:	8082                	ret
    panic("uvmfirst: more than a page");
    800008f6:	00008517          	auipc	a0,0x8
    800008fa:	82250513          	addi	a0,a0,-2014 # 80008118 <etext+0x118>
    800008fe:	00006097          	auipc	ra,0x6
    80000902:	860080e7          	jalr	-1952(ra) # 8000615e <panic>

0000000080000906 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000906:	1101                	addi	sp,sp,-32
    80000908:	ec06                	sd	ra,24(sp)
    8000090a:	e822                	sd	s0,16(sp)
    8000090c:	e426                	sd	s1,8(sp)
    8000090e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000910:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000912:	00b67d63          	bgeu	a2,a1,8000092c <uvmdealloc+0x26>
    80000916:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000918:	6785                	lui	a5,0x1
    8000091a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091c:	00f60733          	add	a4,a2,a5
    80000920:	76fd                	lui	a3,0xfffff
    80000922:	8f75                	and	a4,a4,a3
    80000924:	97ae                	add	a5,a5,a1
    80000926:	8ff5                	and	a5,a5,a3
    80000928:	00f76863          	bltu	a4,a5,80000938 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000092c:	8526                	mv	a0,s1
    8000092e:	60e2                	ld	ra,24(sp)
    80000930:	6442                	ld	s0,16(sp)
    80000932:	64a2                	ld	s1,8(sp)
    80000934:	6105                	addi	sp,sp,32
    80000936:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000938:	8f99                	sub	a5,a5,a4
    8000093a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000093c:	4685                	li	a3,1
    8000093e:	0007861b          	sext.w	a2,a5
    80000942:	85ba                	mv	a1,a4
    80000944:	00000097          	auipc	ra,0x0
    80000948:	e4e080e7          	jalr	-434(ra) # 80000792 <uvmunmap>
    8000094c:	b7c5                	j	8000092c <uvmdealloc+0x26>

000000008000094e <uvmalloc>:
  if(newsz < oldsz)
    8000094e:	0ab66f63          	bltu	a2,a1,80000a0c <uvmalloc+0xbe>
{
    80000952:	715d                	addi	sp,sp,-80
    80000954:	e486                	sd	ra,72(sp)
    80000956:	e0a2                	sd	s0,64(sp)
    80000958:	f052                	sd	s4,32(sp)
    8000095a:	ec56                	sd	s5,24(sp)
    8000095c:	e85a                	sd	s6,16(sp)
    8000095e:	0880                	addi	s0,sp,80
    80000960:	8b2a                	mv	s6,a0
    80000962:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    80000964:	6785                	lui	a5,0x1
    80000966:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000968:	95be                	add	a1,a1,a5
    8000096a:	77fd                	lui	a5,0xfffff
    8000096c:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000970:	0aca7063          	bgeu	s4,a2,80000a10 <uvmalloc+0xc2>
    80000974:	fc26                	sd	s1,56(sp)
    80000976:	f84a                	sd	s2,48(sp)
    80000978:	f44e                	sd	s3,40(sp)
    8000097a:	e45e                	sd	s7,8(sp)
    8000097c:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    8000097e:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000980:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    80000984:	fffff097          	auipc	ra,0xfffff
    80000988:	796080e7          	jalr	1942(ra) # 8000011a <kalloc>
    8000098c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000098e:	c915                	beqz	a0,800009c2 <uvmalloc+0x74>
    memset(mem, 0, PGSIZE);
    80000990:	864e                	mv	a2,s3
    80000992:	4581                	li	a1,0
    80000994:	00000097          	auipc	ra,0x0
    80000998:	830080e7          	jalr	-2000(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000099c:	875e                	mv	a4,s7
    8000099e:	86a6                	mv	a3,s1
    800009a0:	864e                	mv	a2,s3
    800009a2:	85ca                	mv	a1,s2
    800009a4:	855a                	mv	a0,s6
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	c02080e7          	jalr	-1022(ra) # 800005a8 <mappages>
    800009ae:	ed0d                	bnez	a0,800009e8 <uvmalloc+0x9a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009b0:	994e                	add	s2,s2,s3
    800009b2:	fd5969e3          	bltu	s2,s5,80000984 <uvmalloc+0x36>
  return newsz;
    800009b6:	8556                	mv	a0,s5
    800009b8:	74e2                	ld	s1,56(sp)
    800009ba:	7942                	ld	s2,48(sp)
    800009bc:	79a2                	ld	s3,40(sp)
    800009be:	6ba2                	ld	s7,8(sp)
    800009c0:	a829                	j	800009da <uvmalloc+0x8c>
      uvmdealloc(pagetable, a, oldsz);
    800009c2:	8652                	mv	a2,s4
    800009c4:	85ca                	mv	a1,s2
    800009c6:	855a                	mv	a0,s6
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	f3e080e7          	jalr	-194(ra) # 80000906 <uvmdealloc>
      return 0;
    800009d0:	4501                	li	a0,0
    800009d2:	74e2                	ld	s1,56(sp)
    800009d4:	7942                	ld	s2,48(sp)
    800009d6:	79a2                	ld	s3,40(sp)
    800009d8:	6ba2                	ld	s7,8(sp)
}
    800009da:	60a6                	ld	ra,72(sp)
    800009dc:	6406                	ld	s0,64(sp)
    800009de:	7a02                	ld	s4,32(sp)
    800009e0:	6ae2                	ld	s5,24(sp)
    800009e2:	6b42                	ld	s6,16(sp)
    800009e4:	6161                	addi	sp,sp,80
    800009e6:	8082                	ret
      kfree(mem);
    800009e8:	8526                	mv	a0,s1
    800009ea:	fffff097          	auipc	ra,0xfffff
    800009ee:	632080e7          	jalr	1586(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009f2:	8652                	mv	a2,s4
    800009f4:	85ca                	mv	a1,s2
    800009f6:	855a                	mv	a0,s6
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	f0e080e7          	jalr	-242(ra) # 80000906 <uvmdealloc>
      return 0;
    80000a00:	4501                	li	a0,0
    80000a02:	74e2                	ld	s1,56(sp)
    80000a04:	7942                	ld	s2,48(sp)
    80000a06:	79a2                	ld	s3,40(sp)
    80000a08:	6ba2                	ld	s7,8(sp)
    80000a0a:	bfc1                	j	800009da <uvmalloc+0x8c>
    return oldsz;
    80000a0c:	852e                	mv	a0,a1
}
    80000a0e:	8082                	ret
  return newsz;
    80000a10:	8532                	mv	a0,a2
    80000a12:	b7e1                	j	800009da <uvmalloc+0x8c>

0000000080000a14 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a14:	7179                	addi	sp,sp,-48
    80000a16:	f406                	sd	ra,40(sp)
    80000a18:	f022                	sd	s0,32(sp)
    80000a1a:	ec26                	sd	s1,24(sp)
    80000a1c:	e84a                	sd	s2,16(sp)
    80000a1e:	e44e                	sd	s3,8(sp)
    80000a20:	e052                	sd	s4,0(sp)
    80000a22:	1800                	addi	s0,sp,48
    80000a24:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a26:	84aa                	mv	s1,a0
    80000a28:	6905                	lui	s2,0x1
    80000a2a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a2c:	4985                	li	s3,1
    80000a2e:	a829                	j	80000a48 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a30:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a32:	00c79513          	slli	a0,a5,0xc
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	fde080e7          	jalr	-34(ra) # 80000a14 <freewalk>
      pagetable[i] = 0;
    80000a3e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a42:	04a1                	addi	s1,s1,8
    80000a44:	03248163          	beq	s1,s2,80000a66 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a48:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a4a:	00f7f713          	andi	a4,a5,15
    80000a4e:	ff3701e3          	beq	a4,s3,80000a30 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a52:	8b85                	andi	a5,a5,1
    80000a54:	d7fd                	beqz	a5,80000a42 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a56:	00007517          	auipc	a0,0x7
    80000a5a:	6e250513          	addi	a0,a0,1762 # 80008138 <etext+0x138>
    80000a5e:	00005097          	auipc	ra,0x5
    80000a62:	700080e7          	jalr	1792(ra) # 8000615e <panic>
    }
  }
  kfree((void*)pagetable);
    80000a66:	8552                	mv	a0,s4
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	5b4080e7          	jalr	1460(ra) # 8000001c <kfree>
}
    80000a70:	70a2                	ld	ra,40(sp)
    80000a72:	7402                	ld	s0,32(sp)
    80000a74:	64e2                	ld	s1,24(sp)
    80000a76:	6942                	ld	s2,16(sp)
    80000a78:	69a2                	ld	s3,8(sp)
    80000a7a:	6a02                	ld	s4,0(sp)
    80000a7c:	6145                	addi	sp,sp,48
    80000a7e:	8082                	ret

0000000080000a80 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a80:	1101                	addi	sp,sp,-32
    80000a82:	ec06                	sd	ra,24(sp)
    80000a84:	e822                	sd	s0,16(sp)
    80000a86:	e426                	sd	s1,8(sp)
    80000a88:	1000                	addi	s0,sp,32
    80000a8a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a8c:	e999                	bnez	a1,80000aa2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a8e:	8526                	mv	a0,s1
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	f84080e7          	jalr	-124(ra) # 80000a14 <freewalk>
}
    80000a98:	60e2                	ld	ra,24(sp)
    80000a9a:	6442                	ld	s0,16(sp)
    80000a9c:	64a2                	ld	s1,8(sp)
    80000a9e:	6105                	addi	sp,sp,32
    80000aa0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000aa2:	6785                	lui	a5,0x1
    80000aa4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000aa6:	95be                	add	a1,a1,a5
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c5d613          	srli	a2,a1,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	ce2080e7          	jalr	-798(ra) # 80000792 <uvmunmap>
    80000ab8:	bfd9                	j	80000a8e <uvmfree+0xe>

0000000080000aba <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000aba:	ca69                	beqz	a2,80000b8c <uvmcopy+0xd2>
{
    80000abc:	715d                	addi	sp,sp,-80
    80000abe:	e486                	sd	ra,72(sp)
    80000ac0:	e0a2                	sd	s0,64(sp)
    80000ac2:	fc26                	sd	s1,56(sp)
    80000ac4:	f84a                	sd	s2,48(sp)
    80000ac6:	f44e                	sd	s3,40(sp)
    80000ac8:	f052                	sd	s4,32(sp)
    80000aca:	ec56                	sd	s5,24(sp)
    80000acc:	e85a                	sd	s6,16(sp)
    80000ace:	e45e                	sd	s7,8(sp)
    80000ad0:	e062                	sd	s8,0(sp)
    80000ad2:	0880                	addi	s0,sp,80
    80000ad4:	8baa                	mv	s7,a0
    80000ad6:	8b2e                	mv	s6,a1
    80000ad8:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000ada:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000adc:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000ade:	4601                	li	a2,0
    80000ae0:	85ce                	mv	a1,s3
    80000ae2:	855e                	mv	a0,s7
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	9dc080e7          	jalr	-1572(ra) # 800004c0 <walk>
    80000aec:	c529                	beqz	a0,80000b36 <uvmcopy+0x7c>
    if((*pte & PTE_V) == 0)
    80000aee:	6118                	ld	a4,0(a0)
    80000af0:	00177793          	andi	a5,a4,1
    80000af4:	cba9                	beqz	a5,80000b46 <uvmcopy+0x8c>
    pa = PTE2PA(*pte);
    80000af6:	00a75593          	srli	a1,a4,0xa
    80000afa:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000afe:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b02:	fffff097          	auipc	ra,0xfffff
    80000b06:	618080e7          	jalr	1560(ra) # 8000011a <kalloc>
    80000b0a:	892a                	mv	s2,a0
    80000b0c:	c931                	beqz	a0,80000b60 <uvmcopy+0xa6>
    memmove(mem, (char*)pa, PGSIZE);
    80000b0e:	8652                	mv	a2,s4
    80000b10:	85e2                	mv	a1,s8
    80000b12:	fffff097          	auipc	ra,0xfffff
    80000b16:	716080e7          	jalr	1814(ra) # 80000228 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b1a:	8726                	mv	a4,s1
    80000b1c:	86ca                	mv	a3,s2
    80000b1e:	8652                	mv	a2,s4
    80000b20:	85ce                	mv	a1,s3
    80000b22:	855a                	mv	a0,s6
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	a84080e7          	jalr	-1404(ra) # 800005a8 <mappages>
    80000b2c:	e50d                	bnez	a0,80000b56 <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    80000b2e:	99d2                	add	s3,s3,s4
    80000b30:	fb59e7e3          	bltu	s3,s5,80000ade <uvmcopy+0x24>
    80000b34:	a081                	j	80000b74 <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    80000b36:	00007517          	auipc	a0,0x7
    80000b3a:	61250513          	addi	a0,a0,1554 # 80008148 <etext+0x148>
    80000b3e:	00005097          	auipc	ra,0x5
    80000b42:	620080e7          	jalr	1568(ra) # 8000615e <panic>
      panic("uvmcopy: page not present");
    80000b46:	00007517          	auipc	a0,0x7
    80000b4a:	62250513          	addi	a0,a0,1570 # 80008168 <etext+0x168>
    80000b4e:	00005097          	auipc	ra,0x5
    80000b52:	610080e7          	jalr	1552(ra) # 8000615e <panic>
      kfree(mem);
    80000b56:	854a                	mv	a0,s2
    80000b58:	fffff097          	auipc	ra,0xfffff
    80000b5c:	4c4080e7          	jalr	1220(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b60:	4685                	li	a3,1
    80000b62:	00c9d613          	srli	a2,s3,0xc
    80000b66:	4581                	li	a1,0
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	c28080e7          	jalr	-984(ra) # 80000792 <uvmunmap>
  return -1;
    80000b72:	557d                	li	a0,-1
}
    80000b74:	60a6                	ld	ra,72(sp)
    80000b76:	6406                	ld	s0,64(sp)
    80000b78:	74e2                	ld	s1,56(sp)
    80000b7a:	7942                	ld	s2,48(sp)
    80000b7c:	79a2                	ld	s3,40(sp)
    80000b7e:	7a02                	ld	s4,32(sp)
    80000b80:	6ae2                	ld	s5,24(sp)
    80000b82:	6b42                	ld	s6,16(sp)
    80000b84:	6ba2                	ld	s7,8(sp)
    80000b86:	6c02                	ld	s8,0(sp)
    80000b88:	6161                	addi	sp,sp,80
    80000b8a:	8082                	ret
  return 0;
    80000b8c:	4501                	li	a0,0
}
    80000b8e:	8082                	ret

0000000080000b90 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b90:	1141                	addi	sp,sp,-16
    80000b92:	e406                	sd	ra,8(sp)
    80000b94:	e022                	sd	s0,0(sp)
    80000b96:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b98:	4601                	li	a2,0
    80000b9a:	00000097          	auipc	ra,0x0
    80000b9e:	926080e7          	jalr	-1754(ra) # 800004c0 <walk>
  if(pte == 0)
    80000ba2:	c901                	beqz	a0,80000bb2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ba4:	611c                	ld	a5,0(a0)
    80000ba6:	9bbd                	andi	a5,a5,-17
    80000ba8:	e11c                	sd	a5,0(a0)
}
    80000baa:	60a2                	ld	ra,8(sp)
    80000bac:	6402                	ld	s0,0(sp)
    80000bae:	0141                	addi	sp,sp,16
    80000bb0:	8082                	ret
    panic("uvmclear");
    80000bb2:	00007517          	auipc	a0,0x7
    80000bb6:	5d650513          	addi	a0,a0,1494 # 80008188 <etext+0x188>
    80000bba:	00005097          	auipc	ra,0x5
    80000bbe:	5a4080e7          	jalr	1444(ra) # 8000615e <panic>

0000000080000bc2 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000bc2:	c6d9                	beqz	a3,80000c50 <copyout+0x8e>
{
    80000bc4:	711d                	addi	sp,sp,-96
    80000bc6:	ec86                	sd	ra,88(sp)
    80000bc8:	e8a2                	sd	s0,80(sp)
    80000bca:	e4a6                	sd	s1,72(sp)
    80000bcc:	e0ca                	sd	s2,64(sp)
    80000bce:	fc4e                	sd	s3,56(sp)
    80000bd0:	f852                	sd	s4,48(sp)
    80000bd2:	f456                	sd	s5,40(sp)
    80000bd4:	f05a                	sd	s6,32(sp)
    80000bd6:	ec5e                	sd	s7,24(sp)
    80000bd8:	e862                	sd	s8,16(sp)
    80000bda:	e466                	sd	s9,8(sp)
    80000bdc:	e06a                	sd	s10,0(sp)
    80000bde:	1080                	addi	s0,sp,96
    80000be0:	8c2a                	mv	s8,a0
    80000be2:	892e                	mv	s2,a1
    80000be4:	8ab2                	mv	s5,a2
    80000be6:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000be8:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    80000bea:	5bfd                	li	s7,-1
    80000bec:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bf0:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000bf2:	6b05                	lui	s6,0x1
    80000bf4:	a025                	j	80000c1c <copyout+0x5a>
    pa0 = PTE2PA(*pte);
    80000bf6:	83a9                	srli	a5,a5,0xa
    80000bf8:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bfa:	41390533          	sub	a0,s2,s3
    80000bfe:	0004861b          	sext.w	a2,s1
    80000c02:	85d6                	mv	a1,s5
    80000c04:	953e                	add	a0,a0,a5
    80000c06:	fffff097          	auipc	ra,0xfffff
    80000c0a:	622080e7          	jalr	1570(ra) # 80000228 <memmove>

    len -= n;
    80000c0e:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000c12:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000c14:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000c18:	020a0a63          	beqz	s4,80000c4c <copyout+0x8a>
    va0 = PGROUNDDOWN(dstva);
    80000c1c:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    80000c20:	033bea63          	bltu	s7,s3,80000c54 <copyout+0x92>
    pte = walk(pagetable, va0, 0);
    80000c24:	4601                	li	a2,0
    80000c26:	85ce                	mv	a1,s3
    80000c28:	8562                	mv	a0,s8
    80000c2a:	00000097          	auipc	ra,0x0
    80000c2e:	896080e7          	jalr	-1898(ra) # 800004c0 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000c32:	c121                	beqz	a0,80000c72 <copyout+0xb0>
    80000c34:	611c                	ld	a5,0(a0)
    80000c36:	0157f713          	andi	a4,a5,21
    80000c3a:	03a71e63          	bne	a4,s10,80000c76 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80000c3e:	412984b3          	sub	s1,s3,s2
    80000c42:	94da                	add	s1,s1,s6
    if(n > len)
    80000c44:	fa9a79e3          	bgeu	s4,s1,80000bf6 <copyout+0x34>
    80000c48:	84d2                	mv	s1,s4
    80000c4a:	b775                	j	80000bf6 <copyout+0x34>
  }
  return 0;
    80000c4c:	4501                	li	a0,0
    80000c4e:	a021                	j	80000c56 <copyout+0x94>
    80000c50:	4501                	li	a0,0
}
    80000c52:	8082                	ret
      return -1;
    80000c54:	557d                	li	a0,-1
}
    80000c56:	60e6                	ld	ra,88(sp)
    80000c58:	6446                	ld	s0,80(sp)
    80000c5a:	64a6                	ld	s1,72(sp)
    80000c5c:	6906                	ld	s2,64(sp)
    80000c5e:	79e2                	ld	s3,56(sp)
    80000c60:	7a42                	ld	s4,48(sp)
    80000c62:	7aa2                	ld	s5,40(sp)
    80000c64:	7b02                	ld	s6,32(sp)
    80000c66:	6be2                	ld	s7,24(sp)
    80000c68:	6c42                	ld	s8,16(sp)
    80000c6a:	6ca2                	ld	s9,8(sp)
    80000c6c:	6d02                	ld	s10,0(sp)
    80000c6e:	6125                	addi	sp,sp,96
    80000c70:	8082                	ret
      return -1;
    80000c72:	557d                	li	a0,-1
    80000c74:	b7cd                	j	80000c56 <copyout+0x94>
    80000c76:	557d                	li	a0,-1
    80000c78:	bff9                	j	80000c56 <copyout+0x94>

0000000080000c7a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c7a:	caa5                	beqz	a3,80000cea <copyin+0x70>
{
    80000c7c:	715d                	addi	sp,sp,-80
    80000c7e:	e486                	sd	ra,72(sp)
    80000c80:	e0a2                	sd	s0,64(sp)
    80000c82:	fc26                	sd	s1,56(sp)
    80000c84:	f84a                	sd	s2,48(sp)
    80000c86:	f44e                	sd	s3,40(sp)
    80000c88:	f052                	sd	s4,32(sp)
    80000c8a:	ec56                	sd	s5,24(sp)
    80000c8c:	e85a                	sd	s6,16(sp)
    80000c8e:	e45e                	sd	s7,8(sp)
    80000c90:	e062                	sd	s8,0(sp)
    80000c92:	0880                	addi	s0,sp,80
    80000c94:	8b2a                	mv	s6,a0
    80000c96:	8a2e                	mv	s4,a1
    80000c98:	8c32                	mv	s8,a2
    80000c9a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9e:	6a85                	lui	s5,0x1
    80000ca0:	a01d                	j	80000cc6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ca2:	018505b3          	add	a1,a0,s8
    80000ca6:	0004861b          	sext.w	a2,s1
    80000caa:	412585b3          	sub	a1,a1,s2
    80000cae:	8552                	mv	a0,s4
    80000cb0:	fffff097          	auipc	ra,0xfffff
    80000cb4:	578080e7          	jalr	1400(ra) # 80000228 <memmove>

    len -= n;
    80000cb8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cbc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cbe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cc2:	02098263          	beqz	s3,80000ce6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cc6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cca:	85ca                	mv	a1,s2
    80000ccc:	855a                	mv	a0,s6
    80000cce:	00000097          	auipc	ra,0x0
    80000cd2:	898080e7          	jalr	-1896(ra) # 80000566 <walkaddr>
    if(pa0 == 0)
    80000cd6:	cd01                	beqz	a0,80000cee <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cd8:	418904b3          	sub	s1,s2,s8
    80000cdc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cde:	fc99f2e3          	bgeu	s3,s1,80000ca2 <copyin+0x28>
    80000ce2:	84ce                	mv	s1,s3
    80000ce4:	bf7d                	j	80000ca2 <copyin+0x28>
  }
  return 0;
    80000ce6:	4501                	li	a0,0
    80000ce8:	a021                	j	80000cf0 <copyin+0x76>
    80000cea:	4501                	li	a0,0
}
    80000cec:	8082                	ret
      return -1;
    80000cee:	557d                	li	a0,-1
}
    80000cf0:	60a6                	ld	ra,72(sp)
    80000cf2:	6406                	ld	s0,64(sp)
    80000cf4:	74e2                	ld	s1,56(sp)
    80000cf6:	7942                	ld	s2,48(sp)
    80000cf8:	79a2                	ld	s3,40(sp)
    80000cfa:	7a02                	ld	s4,32(sp)
    80000cfc:	6ae2                	ld	s5,24(sp)
    80000cfe:	6b42                	ld	s6,16(sp)
    80000d00:	6ba2                	ld	s7,8(sp)
    80000d02:	6c02                	ld	s8,0(sp)
    80000d04:	6161                	addi	sp,sp,80
    80000d06:	8082                	ret

0000000080000d08 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000d08:	715d                	addi	sp,sp,-80
    80000d0a:	e486                	sd	ra,72(sp)
    80000d0c:	e0a2                	sd	s0,64(sp)
    80000d0e:	fc26                	sd	s1,56(sp)
    80000d10:	f84a                	sd	s2,48(sp)
    80000d12:	f44e                	sd	s3,40(sp)
    80000d14:	f052                	sd	s4,32(sp)
    80000d16:	ec56                	sd	s5,24(sp)
    80000d18:	e85a                	sd	s6,16(sp)
    80000d1a:	e45e                	sd	s7,8(sp)
    80000d1c:	0880                	addi	s0,sp,80
    80000d1e:	8aaa                	mv	s5,a0
    80000d20:	89ae                	mv	s3,a1
    80000d22:	8bb2                	mv	s7,a2
    80000d24:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000d26:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d28:	6a05                	lui	s4,0x1
    80000d2a:	a02d                	j	80000d54 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d2c:	00078023          	sb	zero,0(a5)
    80000d30:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d32:	0017c793          	xori	a5,a5,1
    80000d36:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d3a:	60a6                	ld	ra,72(sp)
    80000d3c:	6406                	ld	s0,64(sp)
    80000d3e:	74e2                	ld	s1,56(sp)
    80000d40:	7942                	ld	s2,48(sp)
    80000d42:	79a2                	ld	s3,40(sp)
    80000d44:	7a02                	ld	s4,32(sp)
    80000d46:	6ae2                	ld	s5,24(sp)
    80000d48:	6b42                	ld	s6,16(sp)
    80000d4a:	6ba2                	ld	s7,8(sp)
    80000d4c:	6161                	addi	sp,sp,80
    80000d4e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d50:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000d54:	c8a1                	beqz	s1,80000da4 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000d56:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000d5a:	85ca                	mv	a1,s2
    80000d5c:	8556                	mv	a0,s5
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	808080e7          	jalr	-2040(ra) # 80000566 <walkaddr>
    if(pa0 == 0)
    80000d66:	c129                	beqz	a0,80000da8 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000d68:	41790633          	sub	a2,s2,s7
    80000d6c:	9652                	add	a2,a2,s4
    if(n > max)
    80000d6e:	00c4f363          	bgeu	s1,a2,80000d74 <copyinstr+0x6c>
    80000d72:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d74:	412b8bb3          	sub	s7,s7,s2
    80000d78:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000d7a:	da79                	beqz	a2,80000d50 <copyinstr+0x48>
    80000d7c:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000d7e:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000d82:	964e                	add	a2,a2,s3
    80000d84:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d86:	00f68733          	add	a4,a3,a5
    80000d8a:	00074703          	lbu	a4,0(a4)
    80000d8e:	df59                	beqz	a4,80000d2c <copyinstr+0x24>
        *dst = *p;
    80000d90:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d94:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d96:	fec797e3          	bne	a5,a2,80000d84 <copyinstr+0x7c>
    80000d9a:	14fd                	addi	s1,s1,-1
    80000d9c:	94ce                	add	s1,s1,s3
      --max;
    80000d9e:	8c8d                	sub	s1,s1,a1
    80000da0:	89be                	mv	s3,a5
    80000da2:	b77d                	j	80000d50 <copyinstr+0x48>
    80000da4:	4781                	li	a5,0
    80000da6:	b771                	j	80000d32 <copyinstr+0x2a>
      return -1;
    80000da8:	557d                	li	a0,-1
    80000daa:	bf41                	j	80000d3a <copyinstr+0x32>

0000000080000dac <getNProc>:
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Get the number of currently running processes.
int getNProc() {
    80000dac:	1141                	addi	sp,sp,-16
    80000dae:	e406                	sd	ra,8(sp)
    80000db0:	e022                	sd	s0,0(sp)
    80000db2:	0800                	addi	s0,sp,16
  int nproc = 0;
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++)
    80000db4:	0000b797          	auipc	a5,0xb
    80000db8:	b8c78793          	addi	a5,a5,-1140 # 8000b940 <proc>
  int nproc = 0;
    80000dbc:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++)
    80000dbe:	00010697          	auipc	a3,0x10
    80000dc2:	78268693          	addi	a3,a3,1922 # 80011540 <tickslock>
    80000dc6:	a029                	j	80000dd0 <getNProc+0x24>
    80000dc8:	17078793          	addi	a5,a5,368
    80000dcc:	00d78663          	beq	a5,a3,80000dd8 <getNProc+0x2c>
    if(p->state != UNUSED) ++nproc;
    80000dd0:	4f98                	lw	a4,24(a5)
    80000dd2:	db7d                	beqz	a4,80000dc8 <getNProc+0x1c>
    80000dd4:	2505                	addiw	a0,a0,1
    80000dd6:	bfcd                	j	80000dc8 <getNProc+0x1c>
  return nproc;
}
    80000dd8:	60a2                	ld	ra,8(sp)
    80000dda:	6402                	ld	s0,0(sp)
    80000ddc:	0141                	addi	sp,sp,16
    80000dde:	8082                	ret

0000000080000de0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000de0:	715d                	addi	sp,sp,-80
    80000de2:	e486                	sd	ra,72(sp)
    80000de4:	e0a2                	sd	s0,64(sp)
    80000de6:	fc26                	sd	s1,56(sp)
    80000de8:	f84a                	sd	s2,48(sp)
    80000dea:	f44e                	sd	s3,40(sp)
    80000dec:	f052                	sd	s4,32(sp)
    80000dee:	ec56                	sd	s5,24(sp)
    80000df0:	e85a                	sd	s6,16(sp)
    80000df2:	e45e                	sd	s7,8(sp)
    80000df4:	e062                	sd	s8,0(sp)
    80000df6:	0880                	addi	s0,sp,80
    80000df8:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	0000b497          	auipc	s1,0xb
    80000dfe:	b4648493          	addi	s1,s1,-1210 # 8000b940 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e02:	8c26                	mv	s8,s1
    80000e04:	e9bd37b7          	lui	a5,0xe9bd3
    80000e08:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69baed87>
    80000e0c:	d37a7937          	lui	s2,0xd37a7
    80000e10:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff5378252e>
    80000e14:	1902                	slli	s2,s2,0x20
    80000e16:	993e                	add	s2,s2,a5
    80000e18:	040009b7          	lui	s3,0x4000
    80000e1c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e1e:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e20:	4b99                	li	s7,6
    80000e22:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	00010a97          	auipc	s5,0x10
    80000e28:	71ca8a93          	addi	s5,s5,1820 # 80011540 <tickslock>
    char *pa = kalloc();
    80000e2c:	fffff097          	auipc	ra,0xfffff
    80000e30:	2ee080e7          	jalr	750(ra) # 8000011a <kalloc>
    80000e34:	862a                	mv	a2,a0
    if(pa == 0)
    80000e36:	c131                	beqz	a0,80000e7a <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80000e38:	418485b3          	sub	a1,s1,s8
    80000e3c:	8591                	srai	a1,a1,0x4
    80000e3e:	032585b3          	mul	a1,a1,s2
    80000e42:	2585                	addiw	a1,a1,1
    80000e44:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e48:	875e                	mv	a4,s7
    80000e4a:	86da                	mv	a3,s6
    80000e4c:	40b985b3          	sub	a1,s3,a1
    80000e50:	8552                	mv	a0,s4
    80000e52:	00000097          	auipc	ra,0x0
    80000e56:	820080e7          	jalr	-2016(ra) # 80000672 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5a:	17048493          	addi	s1,s1,368
    80000e5e:	fd5497e3          	bne	s1,s5,80000e2c <proc_mapstacks+0x4c>
  }
}
    80000e62:	60a6                	ld	ra,72(sp)
    80000e64:	6406                	ld	s0,64(sp)
    80000e66:	74e2                	ld	s1,56(sp)
    80000e68:	7942                	ld	s2,48(sp)
    80000e6a:	79a2                	ld	s3,40(sp)
    80000e6c:	7a02                	ld	s4,32(sp)
    80000e6e:	6ae2                	ld	s5,24(sp)
    80000e70:	6b42                	ld	s6,16(sp)
    80000e72:	6ba2                	ld	s7,8(sp)
    80000e74:	6c02                	ld	s8,0(sp)
    80000e76:	6161                	addi	sp,sp,80
    80000e78:	8082                	ret
      panic("kalloc");
    80000e7a:	00007517          	auipc	a0,0x7
    80000e7e:	31e50513          	addi	a0,a0,798 # 80008198 <etext+0x198>
    80000e82:	00005097          	auipc	ra,0x5
    80000e86:	2dc080e7          	jalr	732(ra) # 8000615e <panic>

0000000080000e8a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e8a:	7139                	addi	sp,sp,-64
    80000e8c:	fc06                	sd	ra,56(sp)
    80000e8e:	f822                	sd	s0,48(sp)
    80000e90:	f426                	sd	s1,40(sp)
    80000e92:	f04a                	sd	s2,32(sp)
    80000e94:	ec4e                	sd	s3,24(sp)
    80000e96:	e852                	sd	s4,16(sp)
    80000e98:	e456                	sd	s5,8(sp)
    80000e9a:	e05a                	sd	s6,0(sp)
    80000e9c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e9e:	00007597          	auipc	a1,0x7
    80000ea2:	30258593          	addi	a1,a1,770 # 800081a0 <etext+0x1a0>
    80000ea6:	0000a517          	auipc	a0,0xa
    80000eaa:	66a50513          	addi	a0,a0,1642 # 8000b510 <pid_lock>
    80000eae:	00005097          	auipc	ra,0x5
    80000eb2:	59a080e7          	jalr	1434(ra) # 80006448 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000eb6:	00007597          	auipc	a1,0x7
    80000eba:	2f258593          	addi	a1,a1,754 # 800081a8 <etext+0x1a8>
    80000ebe:	0000a517          	auipc	a0,0xa
    80000ec2:	66a50513          	addi	a0,a0,1642 # 8000b528 <wait_lock>
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	582080e7          	jalr	1410(ra) # 80006448 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ece:	0000b497          	auipc	s1,0xb
    80000ed2:	a7248493          	addi	s1,s1,-1422 # 8000b940 <proc>
      initlock(&p->lock, "proc");
    80000ed6:	00007b17          	auipc	s6,0x7
    80000eda:	2e2b0b13          	addi	s6,s6,738 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ede:	8aa6                	mv	s5,s1
    80000ee0:	e9bd37b7          	lui	a5,0xe9bd3
    80000ee4:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69baed87>
    80000ee8:	d37a7937          	lui	s2,0xd37a7
    80000eec:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff5378252e>
    80000ef0:	1902                	slli	s2,s2,0x20
    80000ef2:	993e                	add	s2,s2,a5
    80000ef4:	040009b7          	lui	s3,0x4000
    80000ef8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000efa:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efc:	00010a17          	auipc	s4,0x10
    80000f00:	644a0a13          	addi	s4,s4,1604 # 80011540 <tickslock>
      initlock(&p->lock, "proc");
    80000f04:	85da                	mv	a1,s6
    80000f06:	8526                	mv	a0,s1
    80000f08:	00005097          	auipc	ra,0x5
    80000f0c:	540080e7          	jalr	1344(ra) # 80006448 <initlock>
      p->state = UNUSED;
    80000f10:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f14:	415487b3          	sub	a5,s1,s5
    80000f18:	8791                	srai	a5,a5,0x4
    80000f1a:	032787b3          	mul	a5,a5,s2
    80000f1e:	2785                	addiw	a5,a5,1
    80000f20:	00d7979b          	slliw	a5,a5,0xd
    80000f24:	40f987b3          	sub	a5,s3,a5
    80000f28:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2a:	17048493          	addi	s1,s1,368
    80000f2e:	fd449be3          	bne	s1,s4,80000f04 <procinit+0x7a>
  }
}
    80000f32:	70e2                	ld	ra,56(sp)
    80000f34:	7442                	ld	s0,48(sp)
    80000f36:	74a2                	ld	s1,40(sp)
    80000f38:	7902                	ld	s2,32(sp)
    80000f3a:	69e2                	ld	s3,24(sp)
    80000f3c:	6a42                	ld	s4,16(sp)
    80000f3e:	6aa2                	ld	s5,8(sp)
    80000f40:	6b02                	ld	s6,0(sp)
    80000f42:	6121                	addi	sp,sp,64
    80000f44:	8082                	ret

0000000080000f46 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f46:	1141                	addi	sp,sp,-16
    80000f48:	e406                	sd	ra,8(sp)
    80000f4a:	e022                	sd	s0,0(sp)
    80000f4c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f4e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f50:	2501                	sext.w	a0,a0
    80000f52:	60a2                	ld	ra,8(sp)
    80000f54:	6402                	ld	s0,0(sp)
    80000f56:	0141                	addi	sp,sp,16
    80000f58:	8082                	ret

0000000080000f5a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e406                	sd	ra,8(sp)
    80000f5e:	e022                	sd	s0,0(sp)
    80000f60:	0800                	addi	s0,sp,16
    80000f62:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f64:	2781                	sext.w	a5,a5
    80000f66:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f68:	0000a517          	auipc	a0,0xa
    80000f6c:	5d850513          	addi	a0,a0,1496 # 8000b540 <cpus>
    80000f70:	953e                	add	a0,a0,a5
    80000f72:	60a2                	ld	ra,8(sp)
    80000f74:	6402                	ld	s0,0(sp)
    80000f76:	0141                	addi	sp,sp,16
    80000f78:	8082                	ret

0000000080000f7a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f7a:	1101                	addi	sp,sp,-32
    80000f7c:	ec06                	sd	ra,24(sp)
    80000f7e:	e822                	sd	s0,16(sp)
    80000f80:	e426                	sd	s1,8(sp)
    80000f82:	1000                	addi	s0,sp,32
  push_off();
    80000f84:	00005097          	auipc	ra,0x5
    80000f88:	50c080e7          	jalr	1292(ra) # 80006490 <push_off>
    80000f8c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f8e:	2781                	sext.w	a5,a5
    80000f90:	079e                	slli	a5,a5,0x7
    80000f92:	0000a717          	auipc	a4,0xa
    80000f96:	57e70713          	addi	a4,a4,1406 # 8000b510 <pid_lock>
    80000f9a:	97ba                	add	a5,a5,a4
    80000f9c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f9e:	00005097          	auipc	ra,0x5
    80000fa2:	592080e7          	jalr	1426(ra) # 80006530 <pop_off>
  return p;
}
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	60e2                	ld	ra,24(sp)
    80000faa:	6442                	ld	s0,16(sp)
    80000fac:	64a2                	ld	s1,8(sp)
    80000fae:	6105                	addi	sp,sp,32
    80000fb0:	8082                	ret

0000000080000fb2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fb2:	1141                	addi	sp,sp,-16
    80000fb4:	e406                	sd	ra,8(sp)
    80000fb6:	e022                	sd	s0,0(sp)
    80000fb8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fba:	00000097          	auipc	ra,0x0
    80000fbe:	fc0080e7          	jalr	-64(ra) # 80000f7a <myproc>
    80000fc2:	00005097          	auipc	ra,0x5
    80000fc6:	5ca080e7          	jalr	1482(ra) # 8000658c <release>

  if (first) {
    80000fca:	0000a797          	auipc	a5,0xa
    80000fce:	4867a783          	lw	a5,1158(a5) # 8000b450 <first.1>
    80000fd2:	eb89                	bnez	a5,80000fe4 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000fd4:	00001097          	auipc	ra,0x1
    80000fd8:	c8c080e7          	jalr	-884(ra) # 80001c60 <usertrapret>
}
    80000fdc:	60a2                	ld	ra,8(sp)
    80000fde:	6402                	ld	s0,0(sp)
    80000fe0:	0141                	addi	sp,sp,16
    80000fe2:	8082                	ret
    fsinit(ROOTDEV);
    80000fe4:	4505                	li	a0,1
    80000fe6:	00002097          	auipc	ra,0x2
    80000fea:	a68080e7          	jalr	-1432(ra) # 80002a4e <fsinit>
    first = 0;
    80000fee:	0000a797          	auipc	a5,0xa
    80000ff2:	4607a123          	sw	zero,1122(a5) # 8000b450 <first.1>
    __sync_synchronize();
    80000ff6:	0330000f          	fence	rw,rw
    80000ffa:	bfe9                	j	80000fd4 <forkret+0x22>

0000000080000ffc <allocpid>:
{
    80000ffc:	1101                	addi	sp,sp,-32
    80000ffe:	ec06                	sd	ra,24(sp)
    80001000:	e822                	sd	s0,16(sp)
    80001002:	e426                	sd	s1,8(sp)
    80001004:	e04a                	sd	s2,0(sp)
    80001006:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001008:	0000a917          	auipc	s2,0xa
    8000100c:	50890913          	addi	s2,s2,1288 # 8000b510 <pid_lock>
    80001010:	854a                	mv	a0,s2
    80001012:	00005097          	auipc	ra,0x5
    80001016:	4ca080e7          	jalr	1226(ra) # 800064dc <acquire>
  pid = nextpid;
    8000101a:	0000a797          	auipc	a5,0xa
    8000101e:	43a78793          	addi	a5,a5,1082 # 8000b454 <nextpid>
    80001022:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001024:	0014871b          	addiw	a4,s1,1
    80001028:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000102a:	854a                	mv	a0,s2
    8000102c:	00005097          	auipc	ra,0x5
    80001030:	560080e7          	jalr	1376(ra) # 8000658c <release>
}
    80001034:	8526                	mv	a0,s1
    80001036:	60e2                	ld	ra,24(sp)
    80001038:	6442                	ld	s0,16(sp)
    8000103a:	64a2                	ld	s1,8(sp)
    8000103c:	6902                	ld	s2,0(sp)
    8000103e:	6105                	addi	sp,sp,32
    80001040:	8082                	ret

0000000080001042 <proc_pagetable>:
{
    80001042:	1101                	addi	sp,sp,-32
    80001044:	ec06                	sd	ra,24(sp)
    80001046:	e822                	sd	s0,16(sp)
    80001048:	e426                	sd	s1,8(sp)
    8000104a:	e04a                	sd	s2,0(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001050:	00000097          	auipc	ra,0x0
    80001054:	816080e7          	jalr	-2026(ra) # 80000866 <uvmcreate>
    80001058:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000105a:	c121                	beqz	a0,8000109a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000105c:	4729                	li	a4,10
    8000105e:	00006697          	auipc	a3,0x6
    80001062:	fa268693          	addi	a3,a3,-94 # 80007000 <_trampoline>
    80001066:	6605                	lui	a2,0x1
    80001068:	040005b7          	lui	a1,0x4000
    8000106c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000106e:	05b2                	slli	a1,a1,0xc
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	538080e7          	jalr	1336(ra) # 800005a8 <mappages>
    80001078:	02054863          	bltz	a0,800010a8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000107c:	4719                	li	a4,6
    8000107e:	05893683          	ld	a3,88(s2)
    80001082:	6605                	lui	a2,0x1
    80001084:	020005b7          	lui	a1,0x2000
    80001088:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000108a:	05b6                	slli	a1,a1,0xd
    8000108c:	8526                	mv	a0,s1
    8000108e:	fffff097          	auipc	ra,0xfffff
    80001092:	51a080e7          	jalr	1306(ra) # 800005a8 <mappages>
    80001096:	02054163          	bltz	a0,800010b8 <proc_pagetable+0x76>
}
    8000109a:	8526                	mv	a0,s1
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6902                	ld	s2,0(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret
    uvmfree(pagetable, 0);
    800010a8:	4581                	li	a1,0
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	9d4080e7          	jalr	-1580(ra) # 80000a80 <uvmfree>
    return 0;
    800010b4:	4481                	li	s1,0
    800010b6:	b7d5                	j	8000109a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b8:	4681                	li	a3,0
    800010ba:	4605                	li	a2,1
    800010bc:	040005b7          	lui	a1,0x4000
    800010c0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c2:	05b2                	slli	a1,a1,0xc
    800010c4:	8526                	mv	a0,s1
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	6cc080e7          	jalr	1740(ra) # 80000792 <uvmunmap>
    uvmfree(pagetable, 0);
    800010ce:	4581                	li	a1,0
    800010d0:	8526                	mv	a0,s1
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	9ae080e7          	jalr	-1618(ra) # 80000a80 <uvmfree>
    return 0;
    800010da:	4481                	li	s1,0
    800010dc:	bf7d                	j	8000109a <proc_pagetable+0x58>

00000000800010de <proc_freepagetable>:
{
    800010de:	1101                	addi	sp,sp,-32
    800010e0:	ec06                	sd	ra,24(sp)
    800010e2:	e822                	sd	s0,16(sp)
    800010e4:	e426                	sd	s1,8(sp)
    800010e6:	e04a                	sd	s2,0(sp)
    800010e8:	1000                	addi	s0,sp,32
    800010ea:	84aa                	mv	s1,a0
    800010ec:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ee:	4681                	li	a3,0
    800010f0:	4605                	li	a2,1
    800010f2:	040005b7          	lui	a1,0x4000
    800010f6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010f8:	05b2                	slli	a1,a1,0xc
    800010fa:	fffff097          	auipc	ra,0xfffff
    800010fe:	698080e7          	jalr	1688(ra) # 80000792 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001102:	4681                	li	a3,0
    80001104:	4605                	li	a2,1
    80001106:	020005b7          	lui	a1,0x2000
    8000110a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000110c:	05b6                	slli	a1,a1,0xd
    8000110e:	8526                	mv	a0,s1
    80001110:	fffff097          	auipc	ra,0xfffff
    80001114:	682080e7          	jalr	1666(ra) # 80000792 <uvmunmap>
  uvmfree(pagetable, sz);
    80001118:	85ca                	mv	a1,s2
    8000111a:	8526                	mv	a0,s1
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	964080e7          	jalr	-1692(ra) # 80000a80 <uvmfree>
}
    80001124:	60e2                	ld	ra,24(sp)
    80001126:	6442                	ld	s0,16(sp)
    80001128:	64a2                	ld	s1,8(sp)
    8000112a:	6902                	ld	s2,0(sp)
    8000112c:	6105                	addi	sp,sp,32
    8000112e:	8082                	ret

0000000080001130 <freeproc>:
{
    80001130:	1101                	addi	sp,sp,-32
    80001132:	ec06                	sd	ra,24(sp)
    80001134:	e822                	sd	s0,16(sp)
    80001136:	e426                	sd	s1,8(sp)
    80001138:	1000                	addi	s0,sp,32
    8000113a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000113c:	6d28                	ld	a0,88(a0)
    8000113e:	c509                	beqz	a0,80001148 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	edc080e7          	jalr	-292(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001148:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000114c:	68a8                	ld	a0,80(s1)
    8000114e:	c511                	beqz	a0,8000115a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001150:	64ac                	ld	a1,72(s1)
    80001152:	00000097          	auipc	ra,0x0
    80001156:	f8c080e7          	jalr	-116(ra) # 800010de <proc_freepagetable>
  p->pagetable = 0;
    8000115a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000115e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001162:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001166:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000116a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000116e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001172:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001176:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000117a:	0004ac23          	sw	zero,24(s1)
}
    8000117e:	60e2                	ld	ra,24(sp)
    80001180:	6442                	ld	s0,16(sp)
    80001182:	64a2                	ld	s1,8(sp)
    80001184:	6105                	addi	sp,sp,32
    80001186:	8082                	ret

0000000080001188 <allocproc>:
{
    80001188:	1101                	addi	sp,sp,-32
    8000118a:	ec06                	sd	ra,24(sp)
    8000118c:	e822                	sd	s0,16(sp)
    8000118e:	e426                	sd	s1,8(sp)
    80001190:	e04a                	sd	s2,0(sp)
    80001192:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001194:	0000a497          	auipc	s1,0xa
    80001198:	7ac48493          	addi	s1,s1,1964 # 8000b940 <proc>
    8000119c:	00010917          	auipc	s2,0x10
    800011a0:	3a490913          	addi	s2,s2,932 # 80011540 <tickslock>
    acquire(&p->lock);
    800011a4:	8526                	mv	a0,s1
    800011a6:	00005097          	auipc	ra,0x5
    800011aa:	336080e7          	jalr	822(ra) # 800064dc <acquire>
    if(p->state == UNUSED) {
    800011ae:	4c9c                	lw	a5,24(s1)
    800011b0:	cf81                	beqz	a5,800011c8 <allocproc+0x40>
      release(&p->lock);
    800011b2:	8526                	mv	a0,s1
    800011b4:	00005097          	auipc	ra,0x5
    800011b8:	3d8080e7          	jalr	984(ra) # 8000658c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011bc:	17048493          	addi	s1,s1,368
    800011c0:	ff2492e3          	bne	s1,s2,800011a4 <allocproc+0x1c>
  return 0;
    800011c4:	4481                	li	s1,0
    800011c6:	a899                	j	8000121c <allocproc+0x94>
  p->pid = allocpid();
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	e34080e7          	jalr	-460(ra) # 80000ffc <allocpid>
    800011d0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011d2:	4785                	li	a5,1
    800011d4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011d6:	fffff097          	auipc	ra,0xfffff
    800011da:	f44080e7          	jalr	-188(ra) # 8000011a <kalloc>
    800011de:	892a                	mv	s2,a0
    800011e0:	eca8                	sd	a0,88(s1)
    800011e2:	c521                	beqz	a0,8000122a <allocproc+0xa2>
  p->pagetable = proc_pagetable(p);
    800011e4:	8526                	mv	a0,s1
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	e5c080e7          	jalr	-420(ra) # 80001042 <proc_pagetable>
    800011ee:	892a                	mv	s2,a0
    800011f0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800011f2:	c921                	beqz	a0,80001242 <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    800011f4:	07000613          	li	a2,112
    800011f8:	4581                	li	a1,0
    800011fa:	06048513          	addi	a0,s1,96
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	fc6080e7          	jalr	-58(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    80001206:	00000797          	auipc	a5,0x0
    8000120a:	dac78793          	addi	a5,a5,-596 # 80000fb2 <forkret>
    8000120e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001210:	60bc                	ld	a5,64(s1)
    80001212:	6705                	lui	a4,0x1
    80001214:	97ba                	add	a5,a5,a4
    80001216:	f4bc                	sd	a5,104(s1)
  p->syscallMask = 0;
    80001218:	1604a423          	sw	zero,360(s1)
}
    8000121c:	8526                	mv	a0,s1
    8000121e:	60e2                	ld	ra,24(sp)
    80001220:	6442                	ld	s0,16(sp)
    80001222:	64a2                	ld	s1,8(sp)
    80001224:	6902                	ld	s2,0(sp)
    80001226:	6105                	addi	sp,sp,32
    80001228:	8082                	ret
    freeproc(p);
    8000122a:	8526                	mv	a0,s1
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	f04080e7          	jalr	-252(ra) # 80001130 <freeproc>
    release(&p->lock);
    80001234:	8526                	mv	a0,s1
    80001236:	00005097          	auipc	ra,0x5
    8000123a:	356080e7          	jalr	854(ra) # 8000658c <release>
    return 0;
    8000123e:	84ca                	mv	s1,s2
    80001240:	bff1                	j	8000121c <allocproc+0x94>
    freeproc(p);
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	eec080e7          	jalr	-276(ra) # 80001130 <freeproc>
    release(&p->lock);
    8000124c:	8526                	mv	a0,s1
    8000124e:	00005097          	auipc	ra,0x5
    80001252:	33e080e7          	jalr	830(ra) # 8000658c <release>
    return 0;
    80001256:	84ca                	mv	s1,s2
    80001258:	b7d1                	j	8000121c <allocproc+0x94>

000000008000125a <userinit>:
{
    8000125a:	1101                	addi	sp,sp,-32
    8000125c:	ec06                	sd	ra,24(sp)
    8000125e:	e822                	sd	s0,16(sp)
    80001260:	e426                	sd	s1,8(sp)
    80001262:	1000                	addi	s0,sp,32
  p = allocproc();
    80001264:	00000097          	auipc	ra,0x0
    80001268:	f24080e7          	jalr	-220(ra) # 80001188 <allocproc>
    8000126c:	84aa                	mv	s1,a0
  initproc = p;
    8000126e:	0000a797          	auipc	a5,0xa
    80001272:	26a7b123          	sd	a0,610(a5) # 8000b4d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001276:	03400613          	li	a2,52
    8000127a:	0000a597          	auipc	a1,0xa
    8000127e:	1e658593          	addi	a1,a1,486 # 8000b460 <initcode>
    80001282:	6928                	ld	a0,80(a0)
    80001284:	fffff097          	auipc	ra,0xfffff
    80001288:	610080e7          	jalr	1552(ra) # 80000894 <uvmfirst>
  p->sz = PGSIZE;
    8000128c:	6785                	lui	a5,0x1
    8000128e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001290:	6cb8                	ld	a4,88(s1)
    80001292:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001296:	6cb8                	ld	a4,88(s1)
    80001298:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000129a:	4641                	li	a2,16
    8000129c:	00007597          	auipc	a1,0x7
    800012a0:	f2458593          	addi	a1,a1,-220 # 800081c0 <etext+0x1c0>
    800012a4:	15848513          	addi	a0,s1,344
    800012a8:	fffff097          	auipc	ra,0xfffff
    800012ac:	072080e7          	jalr	114(ra) # 8000031a <safestrcpy>
  p->cwd = namei("/");
    800012b0:	00007517          	auipc	a0,0x7
    800012b4:	f2050513          	addi	a0,a0,-224 # 800081d0 <etext+0x1d0>
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	1fe080e7          	jalr	510(ra) # 800034b6 <namei>
    800012c0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012c4:	478d                	li	a5,3
    800012c6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012c8:	8526                	mv	a0,s1
    800012ca:	00005097          	auipc	ra,0x5
    800012ce:	2c2080e7          	jalr	706(ra) # 8000658c <release>
}
    800012d2:	60e2                	ld	ra,24(sp)
    800012d4:	6442                	ld	s0,16(sp)
    800012d6:	64a2                	ld	s1,8(sp)
    800012d8:	6105                	addi	sp,sp,32
    800012da:	8082                	ret

00000000800012dc <growproc>:
{
    800012dc:	1101                	addi	sp,sp,-32
    800012de:	ec06                	sd	ra,24(sp)
    800012e0:	e822                	sd	s0,16(sp)
    800012e2:	e426                	sd	s1,8(sp)
    800012e4:	e04a                	sd	s2,0(sp)
    800012e6:	1000                	addi	s0,sp,32
    800012e8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800012ea:	00000097          	auipc	ra,0x0
    800012ee:	c90080e7          	jalr	-880(ra) # 80000f7a <myproc>
    800012f2:	84aa                	mv	s1,a0
  sz = p->sz;
    800012f4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800012f6:	01204c63          	bgtz	s2,8000130e <growproc+0x32>
  } else if(n < 0){
    800012fa:	02094663          	bltz	s2,80001326 <growproc+0x4a>
  p->sz = sz;
    800012fe:	e4ac                	sd	a1,72(s1)
  return 0;
    80001300:	4501                	li	a0,0
}
    80001302:	60e2                	ld	ra,24(sp)
    80001304:	6442                	ld	s0,16(sp)
    80001306:	64a2                	ld	s1,8(sp)
    80001308:	6902                	ld	s2,0(sp)
    8000130a:	6105                	addi	sp,sp,32
    8000130c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000130e:	4691                	li	a3,4
    80001310:	00b90633          	add	a2,s2,a1
    80001314:	6928                	ld	a0,80(a0)
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	638080e7          	jalr	1592(ra) # 8000094e <uvmalloc>
    8000131e:	85aa                	mv	a1,a0
    80001320:	fd79                	bnez	a0,800012fe <growproc+0x22>
      return -1;
    80001322:	557d                	li	a0,-1
    80001324:	bff9                	j	80001302 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001326:	00b90633          	add	a2,s2,a1
    8000132a:	6928                	ld	a0,80(a0)
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	5da080e7          	jalr	1498(ra) # 80000906 <uvmdealloc>
    80001334:	85aa                	mv	a1,a0
    80001336:	b7e1                	j	800012fe <growproc+0x22>

0000000080001338 <fork>:
{
    80001338:	7139                	addi	sp,sp,-64
    8000133a:	fc06                	sd	ra,56(sp)
    8000133c:	f822                	sd	s0,48(sp)
    8000133e:	f04a                	sd	s2,32(sp)
    80001340:	e456                	sd	s5,8(sp)
    80001342:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001344:	00000097          	auipc	ra,0x0
    80001348:	c36080e7          	jalr	-970(ra) # 80000f7a <myproc>
    8000134c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	e3a080e7          	jalr	-454(ra) # 80001188 <allocproc>
    80001356:	12050463          	beqz	a0,8000147e <fork+0x146>
    8000135a:	ec4e                	sd	s3,24(sp)
    8000135c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000135e:	048ab603          	ld	a2,72(s5)
    80001362:	692c                	ld	a1,80(a0)
    80001364:	050ab503          	ld	a0,80(s5)
    80001368:	fffff097          	auipc	ra,0xfffff
    8000136c:	752080e7          	jalr	1874(ra) # 80000aba <uvmcopy>
    80001370:	04054a63          	bltz	a0,800013c4 <fork+0x8c>
    80001374:	f426                	sd	s1,40(sp)
    80001376:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001378:	048ab783          	ld	a5,72(s5)
    8000137c:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001380:	058ab683          	ld	a3,88(s5)
    80001384:	87b6                	mv	a5,a3
    80001386:	0589b703          	ld	a4,88(s3)
    8000138a:	12068693          	addi	a3,a3,288
    8000138e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001392:	6788                	ld	a0,8(a5)
    80001394:	6b8c                	ld	a1,16(a5)
    80001396:	6f90                	ld	a2,24(a5)
    80001398:	01073023          	sd	a6,0(a4)
    8000139c:	e708                	sd	a0,8(a4)
    8000139e:	eb0c                	sd	a1,16(a4)
    800013a0:	ef10                	sd	a2,24(a4)
    800013a2:	02078793          	addi	a5,a5,32
    800013a6:	02070713          	addi	a4,a4,32
    800013aa:	fed792e3          	bne	a5,a3,8000138e <fork+0x56>
  np->trapframe->a0 = 0;
    800013ae:	0589b783          	ld	a5,88(s3)
    800013b2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013b6:	0d0a8493          	addi	s1,s5,208
    800013ba:	0d098913          	addi	s2,s3,208
    800013be:	150a8a13          	addi	s4,s5,336
    800013c2:	a015                	j	800013e6 <fork+0xae>
    freeproc(np);
    800013c4:	854e                	mv	a0,s3
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	d6a080e7          	jalr	-662(ra) # 80001130 <freeproc>
    release(&np->lock);
    800013ce:	854e                	mv	a0,s3
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	1bc080e7          	jalr	444(ra) # 8000658c <release>
    return -1;
    800013d8:	597d                	li	s2,-1
    800013da:	69e2                	ld	s3,24(sp)
    800013dc:	a851                	j	80001470 <fork+0x138>
  for(i = 0; i < NOFILE; i++)
    800013de:	04a1                	addi	s1,s1,8
    800013e0:	0921                	addi	s2,s2,8
    800013e2:	01448b63          	beq	s1,s4,800013f8 <fork+0xc0>
    if(p->ofile[i])
    800013e6:	6088                	ld	a0,0(s1)
    800013e8:	d97d                	beqz	a0,800013de <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800013ea:	00002097          	auipc	ra,0x2
    800013ee:	750080e7          	jalr	1872(ra) # 80003b3a <filedup>
    800013f2:	00a93023          	sd	a0,0(s2)
    800013f6:	b7e5                	j	800013de <fork+0xa6>
  np->cwd = idup(p->cwd);
    800013f8:	150ab503          	ld	a0,336(s5)
    800013fc:	00002097          	auipc	ra,0x2
    80001400:	898080e7          	jalr	-1896(ra) # 80002c94 <idup>
    80001404:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001408:	4641                	li	a2,16
    8000140a:	158a8593          	addi	a1,s5,344
    8000140e:	15898513          	addi	a0,s3,344
    80001412:	fffff097          	auipc	ra,0xfffff
    80001416:	f08080e7          	jalr	-248(ra) # 8000031a <safestrcpy>
  pid = np->pid;
    8000141a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000141e:	854e                	mv	a0,s3
    80001420:	00005097          	auipc	ra,0x5
    80001424:	16c080e7          	jalr	364(ra) # 8000658c <release>
  acquire(&wait_lock);
    80001428:	0000a497          	auipc	s1,0xa
    8000142c:	10048493          	addi	s1,s1,256 # 8000b528 <wait_lock>
    80001430:	8526                	mv	a0,s1
    80001432:	00005097          	auipc	ra,0x5
    80001436:	0aa080e7          	jalr	170(ra) # 800064dc <acquire>
  np->parent = p;
    8000143a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000143e:	8526                	mv	a0,s1
    80001440:	00005097          	auipc	ra,0x5
    80001444:	14c080e7          	jalr	332(ra) # 8000658c <release>
  acquire(&np->lock);
    80001448:	854e                	mv	a0,s3
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	092080e7          	jalr	146(ra) # 800064dc <acquire>
  np->state = RUNNABLE;
    80001452:	478d                	li	a5,3
    80001454:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001458:	854e                	mv	a0,s3
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	132080e7          	jalr	306(ra) # 8000658c <release>
  np->syscallMask = p->syscallMask;
    80001462:	168aa783          	lw	a5,360(s5)
    80001466:	16f9a423          	sw	a5,360(s3)
  return pid;
    8000146a:	74a2                	ld	s1,40(sp)
    8000146c:	69e2                	ld	s3,24(sp)
    8000146e:	6a42                	ld	s4,16(sp)
}
    80001470:	854a                	mv	a0,s2
    80001472:	70e2                	ld	ra,56(sp)
    80001474:	7442                	ld	s0,48(sp)
    80001476:	7902                	ld	s2,32(sp)
    80001478:	6aa2                	ld	s5,8(sp)
    8000147a:	6121                	addi	sp,sp,64
    8000147c:	8082                	ret
    return -1;
    8000147e:	597d                	li	s2,-1
    80001480:	bfc5                	j	80001470 <fork+0x138>

0000000080001482 <scheduler>:
{
    80001482:	715d                	addi	sp,sp,-80
    80001484:	e486                	sd	ra,72(sp)
    80001486:	e0a2                	sd	s0,64(sp)
    80001488:	fc26                	sd	s1,56(sp)
    8000148a:	f84a                	sd	s2,48(sp)
    8000148c:	f44e                	sd	s3,40(sp)
    8000148e:	f052                	sd	s4,32(sp)
    80001490:	ec56                	sd	s5,24(sp)
    80001492:	e85a                	sd	s6,16(sp)
    80001494:	e45e                	sd	s7,8(sp)
    80001496:	e062                	sd	s8,0(sp)
    80001498:	0880                	addi	s0,sp,80
    8000149a:	8792                	mv	a5,tp
  int id = r_tp();
    8000149c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000149e:	00779b13          	slli	s6,a5,0x7
    800014a2:	0000a717          	auipc	a4,0xa
    800014a6:	06e70713          	addi	a4,a4,110 # 8000b510 <pid_lock>
    800014aa:	975a                	add	a4,a4,s6
    800014ac:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014b0:	0000a717          	auipc	a4,0xa
    800014b4:	09870713          	addi	a4,a4,152 # 8000b548 <cpus+0x8>
    800014b8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800014ba:	4c11                	li	s8,4
        c->proc = p;
    800014bc:	079e                	slli	a5,a5,0x7
    800014be:	0000aa17          	auipc	s4,0xa
    800014c2:	052a0a13          	addi	s4,s4,82 # 8000b510 <pid_lock>
    800014c6:	9a3e                	add	s4,s4,a5
        found = 1;
    800014c8:	4b85                	li	s7,1
    800014ca:	a899                	j	80001520 <scheduler+0x9e>
      release(&p->lock);
    800014cc:	8526                	mv	a0,s1
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	0be080e7          	jalr	190(ra) # 8000658c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014d6:	17048493          	addi	s1,s1,368
    800014da:	03248963          	beq	s1,s2,8000150c <scheduler+0x8a>
      acquire(&p->lock);
    800014de:	8526                	mv	a0,s1
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	ffc080e7          	jalr	-4(ra) # 800064dc <acquire>
      if(p->state == RUNNABLE) {
    800014e8:	4c9c                	lw	a5,24(s1)
    800014ea:	ff3791e3          	bne	a5,s3,800014cc <scheduler+0x4a>
        p->state = RUNNING;
    800014ee:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800014f2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014f6:	06048593          	addi	a1,s1,96
    800014fa:	855a                	mv	a0,s6
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	6b6080e7          	jalr	1718(ra) # 80001bb2 <swtch>
        c->proc = 0;
    80001504:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001508:	8ade                	mv	s5,s7
    8000150a:	b7c9                	j	800014cc <scheduler+0x4a>
    if(found == 0) {
    8000150c:	000a9a63          	bnez	s5,80001520 <scheduler+0x9e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001510:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001514:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001518:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000151c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001520:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001524:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001528:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000152c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000152e:	0000a497          	auipc	s1,0xa
    80001532:	41248493          	addi	s1,s1,1042 # 8000b940 <proc>
      if(p->state == RUNNABLE) {
    80001536:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001538:	00010917          	auipc	s2,0x10
    8000153c:	00890913          	addi	s2,s2,8 # 80011540 <tickslock>
    80001540:	bf79                	j	800014de <scheduler+0x5c>

0000000080001542 <sched>:
{
    80001542:	7179                	addi	sp,sp,-48
    80001544:	f406                	sd	ra,40(sp)
    80001546:	f022                	sd	s0,32(sp)
    80001548:	ec26                	sd	s1,24(sp)
    8000154a:	e84a                	sd	s2,16(sp)
    8000154c:	e44e                	sd	s3,8(sp)
    8000154e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001550:	00000097          	auipc	ra,0x0
    80001554:	a2a080e7          	jalr	-1494(ra) # 80000f7a <myproc>
    80001558:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	f08080e7          	jalr	-248(ra) # 80006462 <holding>
    80001562:	c93d                	beqz	a0,800015d8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001564:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001566:	2781                	sext.w	a5,a5
    80001568:	079e                	slli	a5,a5,0x7
    8000156a:	0000a717          	auipc	a4,0xa
    8000156e:	fa670713          	addi	a4,a4,-90 # 8000b510 <pid_lock>
    80001572:	97ba                	add	a5,a5,a4
    80001574:	0a87a703          	lw	a4,168(a5)
    80001578:	4785                	li	a5,1
    8000157a:	06f71763          	bne	a4,a5,800015e8 <sched+0xa6>
  if(p->state == RUNNING)
    8000157e:	4c98                	lw	a4,24(s1)
    80001580:	4791                	li	a5,4
    80001582:	06f70b63          	beq	a4,a5,800015f8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001586:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000158a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000158c:	efb5                	bnez	a5,80001608 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000158e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001590:	0000a917          	auipc	s2,0xa
    80001594:	f8090913          	addi	s2,s2,-128 # 8000b510 <pid_lock>
    80001598:	2781                	sext.w	a5,a5
    8000159a:	079e                	slli	a5,a5,0x7
    8000159c:	97ca                	add	a5,a5,s2
    8000159e:	0ac7a983          	lw	s3,172(a5)
    800015a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015a4:	2781                	sext.w	a5,a5
    800015a6:	079e                	slli	a5,a5,0x7
    800015a8:	0000a597          	auipc	a1,0xa
    800015ac:	fa058593          	addi	a1,a1,-96 # 8000b548 <cpus+0x8>
    800015b0:	95be                	add	a1,a1,a5
    800015b2:	06048513          	addi	a0,s1,96
    800015b6:	00000097          	auipc	ra,0x0
    800015ba:	5fc080e7          	jalr	1532(ra) # 80001bb2 <swtch>
    800015be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015c0:	2781                	sext.w	a5,a5
    800015c2:	079e                	slli	a5,a5,0x7
    800015c4:	993e                	add	s2,s2,a5
    800015c6:	0b392623          	sw	s3,172(s2)
}
    800015ca:	70a2                	ld	ra,40(sp)
    800015cc:	7402                	ld	s0,32(sp)
    800015ce:	64e2                	ld	s1,24(sp)
    800015d0:	6942                	ld	s2,16(sp)
    800015d2:	69a2                	ld	s3,8(sp)
    800015d4:	6145                	addi	sp,sp,48
    800015d6:	8082                	ret
    panic("sched p->lock");
    800015d8:	00007517          	auipc	a0,0x7
    800015dc:	c0050513          	addi	a0,a0,-1024 # 800081d8 <etext+0x1d8>
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	b7e080e7          	jalr	-1154(ra) # 8000615e <panic>
    panic("sched locks");
    800015e8:	00007517          	auipc	a0,0x7
    800015ec:	c0050513          	addi	a0,a0,-1024 # 800081e8 <etext+0x1e8>
    800015f0:	00005097          	auipc	ra,0x5
    800015f4:	b6e080e7          	jalr	-1170(ra) # 8000615e <panic>
    panic("sched running");
    800015f8:	00007517          	auipc	a0,0x7
    800015fc:	c0050513          	addi	a0,a0,-1024 # 800081f8 <etext+0x1f8>
    80001600:	00005097          	auipc	ra,0x5
    80001604:	b5e080e7          	jalr	-1186(ra) # 8000615e <panic>
    panic("sched interruptible");
    80001608:	00007517          	auipc	a0,0x7
    8000160c:	c0050513          	addi	a0,a0,-1024 # 80008208 <etext+0x208>
    80001610:	00005097          	auipc	ra,0x5
    80001614:	b4e080e7          	jalr	-1202(ra) # 8000615e <panic>

0000000080001618 <yield>:
{
    80001618:	1101                	addi	sp,sp,-32
    8000161a:	ec06                	sd	ra,24(sp)
    8000161c:	e822                	sd	s0,16(sp)
    8000161e:	e426                	sd	s1,8(sp)
    80001620:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001622:	00000097          	auipc	ra,0x0
    80001626:	958080e7          	jalr	-1704(ra) # 80000f7a <myproc>
    8000162a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	eb0080e7          	jalr	-336(ra) # 800064dc <acquire>
  p->state = RUNNABLE;
    80001634:	478d                	li	a5,3
    80001636:	cc9c                	sw	a5,24(s1)
  sched();
    80001638:	00000097          	auipc	ra,0x0
    8000163c:	f0a080e7          	jalr	-246(ra) # 80001542 <sched>
  release(&p->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	f4a080e7          	jalr	-182(ra) # 8000658c <release>
}
    8000164a:	60e2                	ld	ra,24(sp)
    8000164c:	6442                	ld	s0,16(sp)
    8000164e:	64a2                	ld	s1,8(sp)
    80001650:	6105                	addi	sp,sp,32
    80001652:	8082                	ret

0000000080001654 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001654:	7179                	addi	sp,sp,-48
    80001656:	f406                	sd	ra,40(sp)
    80001658:	f022                	sd	s0,32(sp)
    8000165a:	ec26                	sd	s1,24(sp)
    8000165c:	e84a                	sd	s2,16(sp)
    8000165e:	e44e                	sd	s3,8(sp)
    80001660:	1800                	addi	s0,sp,48
    80001662:	89aa                	mv	s3,a0
    80001664:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	914080e7          	jalr	-1772(ra) # 80000f7a <myproc>
    8000166e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001670:	00005097          	auipc	ra,0x5
    80001674:	e6c080e7          	jalr	-404(ra) # 800064dc <acquire>
  release(lk);
    80001678:	854a                	mv	a0,s2
    8000167a:	00005097          	auipc	ra,0x5
    8000167e:	f12080e7          	jalr	-238(ra) # 8000658c <release>

  // Go to sleep.
  p->chan = chan;
    80001682:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001686:	4789                	li	a5,2
    80001688:	cc9c                	sw	a5,24(s1)

  sched();
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	eb8080e7          	jalr	-328(ra) # 80001542 <sched>

  // Tidy up.
  p->chan = 0;
    80001692:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	ef4080e7          	jalr	-268(ra) # 8000658c <release>
  acquire(lk);
    800016a0:	854a                	mv	a0,s2
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	e3a080e7          	jalr	-454(ra) # 800064dc <acquire>
}
    800016aa:	70a2                	ld	ra,40(sp)
    800016ac:	7402                	ld	s0,32(sp)
    800016ae:	64e2                	ld	s1,24(sp)
    800016b0:	6942                	ld	s2,16(sp)
    800016b2:	69a2                	ld	s3,8(sp)
    800016b4:	6145                	addi	sp,sp,48
    800016b6:	8082                	ret

00000000800016b8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016b8:	7139                	addi	sp,sp,-64
    800016ba:	fc06                	sd	ra,56(sp)
    800016bc:	f822                	sd	s0,48(sp)
    800016be:	f426                	sd	s1,40(sp)
    800016c0:	f04a                	sd	s2,32(sp)
    800016c2:	ec4e                	sd	s3,24(sp)
    800016c4:	e852                	sd	s4,16(sp)
    800016c6:	e456                	sd	s5,8(sp)
    800016c8:	0080                	addi	s0,sp,64
    800016ca:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016cc:	0000a497          	auipc	s1,0xa
    800016d0:	27448493          	addi	s1,s1,628 # 8000b940 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d8:	00010917          	auipc	s2,0x10
    800016dc:	e6890913          	addi	s2,s2,-408 # 80011540 <tickslock>
    800016e0:	a811                	j	800016f4 <wakeup+0x3c>
      }
      release(&p->lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	ea8080e7          	jalr	-344(ra) # 8000658c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ec:	17048493          	addi	s1,s1,368
    800016f0:	03248663          	beq	s1,s2,8000171c <wakeup+0x64>
    if(p != myproc()){
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	886080e7          	jalr	-1914(ra) # 80000f7a <myproc>
    800016fc:	fea488e3          	beq	s1,a0,800016ec <wakeup+0x34>
      acquire(&p->lock);
    80001700:	8526                	mv	a0,s1
    80001702:	00005097          	auipc	ra,0x5
    80001706:	dda080e7          	jalr	-550(ra) # 800064dc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000170a:	4c9c                	lw	a5,24(s1)
    8000170c:	fd379be3          	bne	a5,s3,800016e2 <wakeup+0x2a>
    80001710:	709c                	ld	a5,32(s1)
    80001712:	fd4798e3          	bne	a5,s4,800016e2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001716:	0154ac23          	sw	s5,24(s1)
    8000171a:	b7e1                	j	800016e2 <wakeup+0x2a>
    }
  }
}
    8000171c:	70e2                	ld	ra,56(sp)
    8000171e:	7442                	ld	s0,48(sp)
    80001720:	74a2                	ld	s1,40(sp)
    80001722:	7902                	ld	s2,32(sp)
    80001724:	69e2                	ld	s3,24(sp)
    80001726:	6a42                	ld	s4,16(sp)
    80001728:	6aa2                	ld	s5,8(sp)
    8000172a:	6121                	addi	sp,sp,64
    8000172c:	8082                	ret

000000008000172e <reparent>:
{
    8000172e:	7179                	addi	sp,sp,-48
    80001730:	f406                	sd	ra,40(sp)
    80001732:	f022                	sd	s0,32(sp)
    80001734:	ec26                	sd	s1,24(sp)
    80001736:	e84a                	sd	s2,16(sp)
    80001738:	e44e                	sd	s3,8(sp)
    8000173a:	e052                	sd	s4,0(sp)
    8000173c:	1800                	addi	s0,sp,48
    8000173e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001740:	0000a497          	auipc	s1,0xa
    80001744:	20048493          	addi	s1,s1,512 # 8000b940 <proc>
      pp->parent = initproc;
    80001748:	0000aa17          	auipc	s4,0xa
    8000174c:	d88a0a13          	addi	s4,s4,-632 # 8000b4d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001750:	00010997          	auipc	s3,0x10
    80001754:	df098993          	addi	s3,s3,-528 # 80011540 <tickslock>
    80001758:	a029                	j	80001762 <reparent+0x34>
    8000175a:	17048493          	addi	s1,s1,368
    8000175e:	01348d63          	beq	s1,s3,80001778 <reparent+0x4a>
    if(pp->parent == p){
    80001762:	7c9c                	ld	a5,56(s1)
    80001764:	ff279be3          	bne	a5,s2,8000175a <reparent+0x2c>
      pp->parent = initproc;
    80001768:	000a3503          	ld	a0,0(s4)
    8000176c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000176e:	00000097          	auipc	ra,0x0
    80001772:	f4a080e7          	jalr	-182(ra) # 800016b8 <wakeup>
    80001776:	b7d5                	j	8000175a <reparent+0x2c>
}
    80001778:	70a2                	ld	ra,40(sp)
    8000177a:	7402                	ld	s0,32(sp)
    8000177c:	64e2                	ld	s1,24(sp)
    8000177e:	6942                	ld	s2,16(sp)
    80001780:	69a2                	ld	s3,8(sp)
    80001782:	6a02                	ld	s4,0(sp)
    80001784:	6145                	addi	sp,sp,48
    80001786:	8082                	ret

0000000080001788 <exit>:
{
    80001788:	7179                	addi	sp,sp,-48
    8000178a:	f406                	sd	ra,40(sp)
    8000178c:	f022                	sd	s0,32(sp)
    8000178e:	ec26                	sd	s1,24(sp)
    80001790:	e84a                	sd	s2,16(sp)
    80001792:	e44e                	sd	s3,8(sp)
    80001794:	e052                	sd	s4,0(sp)
    80001796:	1800                	addi	s0,sp,48
    80001798:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000179a:	fffff097          	auipc	ra,0xfffff
    8000179e:	7e0080e7          	jalr	2016(ra) # 80000f7a <myproc>
    800017a2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017a4:	0000a797          	auipc	a5,0xa
    800017a8:	d2c7b783          	ld	a5,-724(a5) # 8000b4d0 <initproc>
    800017ac:	0d050493          	addi	s1,a0,208
    800017b0:	15050913          	addi	s2,a0,336
    800017b4:	00a79d63          	bne	a5,a0,800017ce <exit+0x46>
    panic("init exiting");
    800017b8:	00007517          	auipc	a0,0x7
    800017bc:	a6850513          	addi	a0,a0,-1432 # 80008220 <etext+0x220>
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	99e080e7          	jalr	-1634(ra) # 8000615e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800017c8:	04a1                	addi	s1,s1,8
    800017ca:	01248b63          	beq	s1,s2,800017e0 <exit+0x58>
    if(p->ofile[fd]){
    800017ce:	6088                	ld	a0,0(s1)
    800017d0:	dd65                	beqz	a0,800017c8 <exit+0x40>
      fileclose(f);
    800017d2:	00002097          	auipc	ra,0x2
    800017d6:	3ba080e7          	jalr	954(ra) # 80003b8c <fileclose>
      p->ofile[fd] = 0;
    800017da:	0004b023          	sd	zero,0(s1)
    800017de:	b7ed                	j	800017c8 <exit+0x40>
  begin_op();
    800017e0:	00002097          	auipc	ra,0x2
    800017e4:	edc080e7          	jalr	-292(ra) # 800036bc <begin_op>
  iput(p->cwd);
    800017e8:	1509b503          	ld	a0,336(s3)
    800017ec:	00001097          	auipc	ra,0x1
    800017f0:	6a4080e7          	jalr	1700(ra) # 80002e90 <iput>
  end_op();
    800017f4:	00002097          	auipc	ra,0x2
    800017f8:	f42080e7          	jalr	-190(ra) # 80003736 <end_op>
  p->cwd = 0;
    800017fc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001800:	0000a497          	auipc	s1,0xa
    80001804:	d2848493          	addi	s1,s1,-728 # 8000b528 <wait_lock>
    80001808:	8526                	mv	a0,s1
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	cd2080e7          	jalr	-814(ra) # 800064dc <acquire>
  reparent(p);
    80001812:	854e                	mv	a0,s3
    80001814:	00000097          	auipc	ra,0x0
    80001818:	f1a080e7          	jalr	-230(ra) # 8000172e <reparent>
  wakeup(p->parent);
    8000181c:	0389b503          	ld	a0,56(s3)
    80001820:	00000097          	auipc	ra,0x0
    80001824:	e98080e7          	jalr	-360(ra) # 800016b8 <wakeup>
  acquire(&p->lock);
    80001828:	854e                	mv	a0,s3
    8000182a:	00005097          	auipc	ra,0x5
    8000182e:	cb2080e7          	jalr	-846(ra) # 800064dc <acquire>
  p->xstate = status;
    80001832:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001836:	4795                	li	a5,5
    80001838:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000183c:	8526                	mv	a0,s1
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	d4e080e7          	jalr	-690(ra) # 8000658c <release>
  sched();
    80001846:	00000097          	auipc	ra,0x0
    8000184a:	cfc080e7          	jalr	-772(ra) # 80001542 <sched>
  panic("zombie exit");
    8000184e:	00007517          	auipc	a0,0x7
    80001852:	9e250513          	addi	a0,a0,-1566 # 80008230 <etext+0x230>
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	908080e7          	jalr	-1784(ra) # 8000615e <panic>

000000008000185e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000185e:	7179                	addi	sp,sp,-48
    80001860:	f406                	sd	ra,40(sp)
    80001862:	f022                	sd	s0,32(sp)
    80001864:	ec26                	sd	s1,24(sp)
    80001866:	e84a                	sd	s2,16(sp)
    80001868:	e44e                	sd	s3,8(sp)
    8000186a:	1800                	addi	s0,sp,48
    8000186c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000186e:	0000a497          	auipc	s1,0xa
    80001872:	0d248493          	addi	s1,s1,210 # 8000b940 <proc>
    80001876:	00010997          	auipc	s3,0x10
    8000187a:	cca98993          	addi	s3,s3,-822 # 80011540 <tickslock>
    acquire(&p->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	c5c080e7          	jalr	-932(ra) # 800064dc <acquire>
    if(p->pid == pid){
    80001888:	589c                	lw	a5,48(s1)
    8000188a:	01278d63          	beq	a5,s2,800018a4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000188e:	8526                	mv	a0,s1
    80001890:	00005097          	auipc	ra,0x5
    80001894:	cfc080e7          	jalr	-772(ra) # 8000658c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001898:	17048493          	addi	s1,s1,368
    8000189c:	ff3491e3          	bne	s1,s3,8000187e <kill+0x20>
  }
  return -1;
    800018a0:	557d                	li	a0,-1
    800018a2:	a829                	j	800018bc <kill+0x5e>
      p->killed = 1;
    800018a4:	4785                	li	a5,1
    800018a6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018a8:	4c98                	lw	a4,24(s1)
    800018aa:	4789                	li	a5,2
    800018ac:	00f70f63          	beq	a4,a5,800018ca <kill+0x6c>
      release(&p->lock);
    800018b0:	8526                	mv	a0,s1
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	cda080e7          	jalr	-806(ra) # 8000658c <release>
      return 0;
    800018ba:	4501                	li	a0,0
}
    800018bc:	70a2                	ld	ra,40(sp)
    800018be:	7402                	ld	s0,32(sp)
    800018c0:	64e2                	ld	s1,24(sp)
    800018c2:	6942                	ld	s2,16(sp)
    800018c4:	69a2                	ld	s3,8(sp)
    800018c6:	6145                	addi	sp,sp,48
    800018c8:	8082                	ret
        p->state = RUNNABLE;
    800018ca:	478d                	li	a5,3
    800018cc:	cc9c                	sw	a5,24(s1)
    800018ce:	b7cd                	j	800018b0 <kill+0x52>

00000000800018d0 <setkilled>:

void
setkilled(struct proc *p)
{
    800018d0:	1101                	addi	sp,sp,-32
    800018d2:	ec06                	sd	ra,24(sp)
    800018d4:	e822                	sd	s0,16(sp)
    800018d6:	e426                	sd	s1,8(sp)
    800018d8:	1000                	addi	s0,sp,32
    800018da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	c00080e7          	jalr	-1024(ra) # 800064dc <acquire>
  p->killed = 1;
    800018e4:	4785                	li	a5,1
    800018e6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800018e8:	8526                	mv	a0,s1
    800018ea:	00005097          	auipc	ra,0x5
    800018ee:	ca2080e7          	jalr	-862(ra) # 8000658c <release>
}
    800018f2:	60e2                	ld	ra,24(sp)
    800018f4:	6442                	ld	s0,16(sp)
    800018f6:	64a2                	ld	s1,8(sp)
    800018f8:	6105                	addi	sp,sp,32
    800018fa:	8082                	ret

00000000800018fc <killed>:

int
killed(struct proc *p)
{
    800018fc:	1101                	addi	sp,sp,-32
    800018fe:	ec06                	sd	ra,24(sp)
    80001900:	e822                	sd	s0,16(sp)
    80001902:	e426                	sd	s1,8(sp)
    80001904:	e04a                	sd	s2,0(sp)
    80001906:	1000                	addi	s0,sp,32
    80001908:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	bd2080e7          	jalr	-1070(ra) # 800064dc <acquire>
  k = p->killed;
    80001912:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001916:	8526                	mv	a0,s1
    80001918:	00005097          	auipc	ra,0x5
    8000191c:	c74080e7          	jalr	-908(ra) # 8000658c <release>
  return k;
}
    80001920:	854a                	mv	a0,s2
    80001922:	60e2                	ld	ra,24(sp)
    80001924:	6442                	ld	s0,16(sp)
    80001926:	64a2                	ld	s1,8(sp)
    80001928:	6902                	ld	s2,0(sp)
    8000192a:	6105                	addi	sp,sp,32
    8000192c:	8082                	ret

000000008000192e <wait>:
{
    8000192e:	715d                	addi	sp,sp,-80
    80001930:	e486                	sd	ra,72(sp)
    80001932:	e0a2                	sd	s0,64(sp)
    80001934:	fc26                	sd	s1,56(sp)
    80001936:	f84a                	sd	s2,48(sp)
    80001938:	f44e                	sd	s3,40(sp)
    8000193a:	f052                	sd	s4,32(sp)
    8000193c:	ec56                	sd	s5,24(sp)
    8000193e:	e85a                	sd	s6,16(sp)
    80001940:	e45e                	sd	s7,8(sp)
    80001942:	0880                	addi	s0,sp,80
    80001944:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	634080e7          	jalr	1588(ra) # 80000f7a <myproc>
    8000194e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001950:	0000a517          	auipc	a0,0xa
    80001954:	bd850513          	addi	a0,a0,-1064 # 8000b528 <wait_lock>
    80001958:	00005097          	auipc	ra,0x5
    8000195c:	b84080e7          	jalr	-1148(ra) # 800064dc <acquire>
        if(pp->state == ZOMBIE){
    80001960:	4a15                	li	s4,5
        havekids = 1;
    80001962:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001964:	00010997          	auipc	s3,0x10
    80001968:	bdc98993          	addi	s3,s3,-1060 # 80011540 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000196c:	0000ab97          	auipc	s7,0xa
    80001970:	bbcb8b93          	addi	s7,s7,-1092 # 8000b528 <wait_lock>
    80001974:	a0c9                	j	80001a36 <wait+0x108>
          pid = pp->pid;
    80001976:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000197a:	000b0e63          	beqz	s6,80001996 <wait+0x68>
    8000197e:	4691                	li	a3,4
    80001980:	02c48613          	addi	a2,s1,44
    80001984:	85da                	mv	a1,s6
    80001986:	05093503          	ld	a0,80(s2)
    8000198a:	fffff097          	auipc	ra,0xfffff
    8000198e:	238080e7          	jalr	568(ra) # 80000bc2 <copyout>
    80001992:	04054063          	bltz	a0,800019d2 <wait+0xa4>
          freeproc(pp);
    80001996:	8526                	mv	a0,s1
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	798080e7          	jalr	1944(ra) # 80001130 <freeproc>
          release(&pp->lock);
    800019a0:	8526                	mv	a0,s1
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	bea080e7          	jalr	-1046(ra) # 8000658c <release>
          release(&wait_lock);
    800019aa:	0000a517          	auipc	a0,0xa
    800019ae:	b7e50513          	addi	a0,a0,-1154 # 8000b528 <wait_lock>
    800019b2:	00005097          	auipc	ra,0x5
    800019b6:	bda080e7          	jalr	-1062(ra) # 8000658c <release>
}
    800019ba:	854e                	mv	a0,s3
    800019bc:	60a6                	ld	ra,72(sp)
    800019be:	6406                	ld	s0,64(sp)
    800019c0:	74e2                	ld	s1,56(sp)
    800019c2:	7942                	ld	s2,48(sp)
    800019c4:	79a2                	ld	s3,40(sp)
    800019c6:	7a02                	ld	s4,32(sp)
    800019c8:	6ae2                	ld	s5,24(sp)
    800019ca:	6b42                	ld	s6,16(sp)
    800019cc:	6ba2                	ld	s7,8(sp)
    800019ce:	6161                	addi	sp,sp,80
    800019d0:	8082                	ret
            release(&pp->lock);
    800019d2:	8526                	mv	a0,s1
    800019d4:	00005097          	auipc	ra,0x5
    800019d8:	bb8080e7          	jalr	-1096(ra) # 8000658c <release>
            release(&wait_lock);
    800019dc:	0000a517          	auipc	a0,0xa
    800019e0:	b4c50513          	addi	a0,a0,-1204 # 8000b528 <wait_lock>
    800019e4:	00005097          	auipc	ra,0x5
    800019e8:	ba8080e7          	jalr	-1112(ra) # 8000658c <release>
            return -1;
    800019ec:	59fd                	li	s3,-1
    800019ee:	b7f1                	j	800019ba <wait+0x8c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019f0:	17048493          	addi	s1,s1,368
    800019f4:	03348463          	beq	s1,s3,80001a1c <wait+0xee>
      if(pp->parent == p){
    800019f8:	7c9c                	ld	a5,56(s1)
    800019fa:	ff279be3          	bne	a5,s2,800019f0 <wait+0xc2>
        acquire(&pp->lock);
    800019fe:	8526                	mv	a0,s1
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	adc080e7          	jalr	-1316(ra) # 800064dc <acquire>
        if(pp->state == ZOMBIE){
    80001a08:	4c9c                	lw	a5,24(s1)
    80001a0a:	f74786e3          	beq	a5,s4,80001976 <wait+0x48>
        release(&pp->lock);
    80001a0e:	8526                	mv	a0,s1
    80001a10:	00005097          	auipc	ra,0x5
    80001a14:	b7c080e7          	jalr	-1156(ra) # 8000658c <release>
        havekids = 1;
    80001a18:	8756                	mv	a4,s5
    80001a1a:	bfd9                	j	800019f0 <wait+0xc2>
    if(!havekids || killed(p)){
    80001a1c:	c31d                	beqz	a4,80001a42 <wait+0x114>
    80001a1e:	854a                	mv	a0,s2
    80001a20:	00000097          	auipc	ra,0x0
    80001a24:	edc080e7          	jalr	-292(ra) # 800018fc <killed>
    80001a28:	ed09                	bnez	a0,80001a42 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a2a:	85de                	mv	a1,s7
    80001a2c:	854a                	mv	a0,s2
    80001a2e:	00000097          	auipc	ra,0x0
    80001a32:	c26080e7          	jalr	-986(ra) # 80001654 <sleep>
    havekids = 0;
    80001a36:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a38:	0000a497          	auipc	s1,0xa
    80001a3c:	f0848493          	addi	s1,s1,-248 # 8000b940 <proc>
    80001a40:	bf65                	j	800019f8 <wait+0xca>
      release(&wait_lock);
    80001a42:	0000a517          	auipc	a0,0xa
    80001a46:	ae650513          	addi	a0,a0,-1306 # 8000b528 <wait_lock>
    80001a4a:	00005097          	auipc	ra,0x5
    80001a4e:	b42080e7          	jalr	-1214(ra) # 8000658c <release>
      return -1;
    80001a52:	59fd                	li	s3,-1
    80001a54:	b79d                	j	800019ba <wait+0x8c>

0000000080001a56 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a56:	7179                	addi	sp,sp,-48
    80001a58:	f406                	sd	ra,40(sp)
    80001a5a:	f022                	sd	s0,32(sp)
    80001a5c:	ec26                	sd	s1,24(sp)
    80001a5e:	e84a                	sd	s2,16(sp)
    80001a60:	e44e                	sd	s3,8(sp)
    80001a62:	e052                	sd	s4,0(sp)
    80001a64:	1800                	addi	s0,sp,48
    80001a66:	84aa                	mv	s1,a0
    80001a68:	892e                	mv	s2,a1
    80001a6a:	89b2                	mv	s3,a2
    80001a6c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a6e:	fffff097          	auipc	ra,0xfffff
    80001a72:	50c080e7          	jalr	1292(ra) # 80000f7a <myproc>
  if(user_dst){
    80001a76:	c08d                	beqz	s1,80001a98 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a78:	86d2                	mv	a3,s4
    80001a7a:	864e                	mv	a2,s3
    80001a7c:	85ca                	mv	a1,s2
    80001a7e:	6928                	ld	a0,80(a0)
    80001a80:	fffff097          	auipc	ra,0xfffff
    80001a84:	142080e7          	jalr	322(ra) # 80000bc2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a88:	70a2                	ld	ra,40(sp)
    80001a8a:	7402                	ld	s0,32(sp)
    80001a8c:	64e2                	ld	s1,24(sp)
    80001a8e:	6942                	ld	s2,16(sp)
    80001a90:	69a2                	ld	s3,8(sp)
    80001a92:	6a02                	ld	s4,0(sp)
    80001a94:	6145                	addi	sp,sp,48
    80001a96:	8082                	ret
    memmove((char *)dst, src, len);
    80001a98:	000a061b          	sext.w	a2,s4
    80001a9c:	85ce                	mv	a1,s3
    80001a9e:	854a                	mv	a0,s2
    80001aa0:	ffffe097          	auipc	ra,0xffffe
    80001aa4:	788080e7          	jalr	1928(ra) # 80000228 <memmove>
    return 0;
    80001aa8:	8526                	mv	a0,s1
    80001aaa:	bff9                	j	80001a88 <either_copyout+0x32>

0000000080001aac <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aac:	7179                	addi	sp,sp,-48
    80001aae:	f406                	sd	ra,40(sp)
    80001ab0:	f022                	sd	s0,32(sp)
    80001ab2:	ec26                	sd	s1,24(sp)
    80001ab4:	e84a                	sd	s2,16(sp)
    80001ab6:	e44e                	sd	s3,8(sp)
    80001ab8:	e052                	sd	s4,0(sp)
    80001aba:	1800                	addi	s0,sp,48
    80001abc:	892a                	mv	s2,a0
    80001abe:	84ae                	mv	s1,a1
    80001ac0:	89b2                	mv	s3,a2
    80001ac2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ac4:	fffff097          	auipc	ra,0xfffff
    80001ac8:	4b6080e7          	jalr	1206(ra) # 80000f7a <myproc>
  if(user_src){
    80001acc:	c08d                	beqz	s1,80001aee <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ace:	86d2                	mv	a3,s4
    80001ad0:	864e                	mv	a2,s3
    80001ad2:	85ca                	mv	a1,s2
    80001ad4:	6928                	ld	a0,80(a0)
    80001ad6:	fffff097          	auipc	ra,0xfffff
    80001ada:	1a4080e7          	jalr	420(ra) # 80000c7a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ade:	70a2                	ld	ra,40(sp)
    80001ae0:	7402                	ld	s0,32(sp)
    80001ae2:	64e2                	ld	s1,24(sp)
    80001ae4:	6942                	ld	s2,16(sp)
    80001ae6:	69a2                	ld	s3,8(sp)
    80001ae8:	6a02                	ld	s4,0(sp)
    80001aea:	6145                	addi	sp,sp,48
    80001aec:	8082                	ret
    memmove(dst, (char*)src, len);
    80001aee:	000a061b          	sext.w	a2,s4
    80001af2:	85ce                	mv	a1,s3
    80001af4:	854a                	mv	a0,s2
    80001af6:	ffffe097          	auipc	ra,0xffffe
    80001afa:	732080e7          	jalr	1842(ra) # 80000228 <memmove>
    return 0;
    80001afe:	8526                	mv	a0,s1
    80001b00:	bff9                	j	80001ade <either_copyin+0x32>

0000000080001b02 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b02:	715d                	addi	sp,sp,-80
    80001b04:	e486                	sd	ra,72(sp)
    80001b06:	e0a2                	sd	s0,64(sp)
    80001b08:	fc26                	sd	s1,56(sp)
    80001b0a:	f84a                	sd	s2,48(sp)
    80001b0c:	f44e                	sd	s3,40(sp)
    80001b0e:	f052                	sd	s4,32(sp)
    80001b10:	ec56                	sd	s5,24(sp)
    80001b12:	e85a                	sd	s6,16(sp)
    80001b14:	e45e                	sd	s7,8(sp)
    80001b16:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b18:	00006517          	auipc	a0,0x6
    80001b1c:	50050513          	addi	a0,a0,1280 # 80008018 <etext+0x18>
    80001b20:	00004097          	auipc	ra,0x4
    80001b24:	322080e7          	jalr	802(ra) # 80005e42 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b28:	0000a497          	auipc	s1,0xa
    80001b2c:	f7048493          	addi	s1,s1,-144 # 8000ba98 <proc+0x158>
    80001b30:	00010917          	auipc	s2,0x10
    80001b34:	b6890913          	addi	s2,s2,-1176 # 80011698 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b38:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b3a:	00006997          	auipc	s3,0x6
    80001b3e:	70698993          	addi	s3,s3,1798 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001b42:	00006a97          	auipc	s5,0x6
    80001b46:	706a8a93          	addi	s5,s5,1798 # 80008248 <etext+0x248>
    printf("\n");
    80001b4a:	00006a17          	auipc	s4,0x6
    80001b4e:	4cea0a13          	addi	s4,s4,1230 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b52:	00007b97          	auipc	s7,0x7
    80001b56:	cdeb8b93          	addi	s7,s7,-802 # 80008830 <states.0>
    80001b5a:	a00d                	j	80001b7c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b5c:	ed86a583          	lw	a1,-296(a3)
    80001b60:	8556                	mv	a0,s5
    80001b62:	00004097          	auipc	ra,0x4
    80001b66:	2e0080e7          	jalr	736(ra) # 80005e42 <printf>
    printf("\n");
    80001b6a:	8552                	mv	a0,s4
    80001b6c:	00004097          	auipc	ra,0x4
    80001b70:	2d6080e7          	jalr	726(ra) # 80005e42 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b74:	17048493          	addi	s1,s1,368
    80001b78:	03248263          	beq	s1,s2,80001b9c <procdump+0x9a>
    if(p->state == UNUSED)
    80001b7c:	86a6                	mv	a3,s1
    80001b7e:	ec04a783          	lw	a5,-320(s1)
    80001b82:	dbed                	beqz	a5,80001b74 <procdump+0x72>
      state = "???";
    80001b84:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b86:	fcfb6be3          	bltu	s6,a5,80001b5c <procdump+0x5a>
    80001b8a:	02079713          	slli	a4,a5,0x20
    80001b8e:	01d75793          	srli	a5,a4,0x1d
    80001b92:	97de                	add	a5,a5,s7
    80001b94:	6390                	ld	a2,0(a5)
    80001b96:	f279                	bnez	a2,80001b5c <procdump+0x5a>
      state = "???";
    80001b98:	864e                	mv	a2,s3
    80001b9a:	b7c9                	j	80001b5c <procdump+0x5a>
  }
}
    80001b9c:	60a6                	ld	ra,72(sp)
    80001b9e:	6406                	ld	s0,64(sp)
    80001ba0:	74e2                	ld	s1,56(sp)
    80001ba2:	7942                	ld	s2,48(sp)
    80001ba4:	79a2                	ld	s3,40(sp)
    80001ba6:	7a02                	ld	s4,32(sp)
    80001ba8:	6ae2                	ld	s5,24(sp)
    80001baa:	6b42                	ld	s6,16(sp)
    80001bac:	6ba2                	ld	s7,8(sp)
    80001bae:	6161                	addi	sp,sp,80
    80001bb0:	8082                	ret

0000000080001bb2 <swtch>:
    80001bb2:	00153023          	sd	ra,0(a0)
    80001bb6:	00253423          	sd	sp,8(a0)
    80001bba:	e900                	sd	s0,16(a0)
    80001bbc:	ed04                	sd	s1,24(a0)
    80001bbe:	03253023          	sd	s2,32(a0)
    80001bc2:	03353423          	sd	s3,40(a0)
    80001bc6:	03453823          	sd	s4,48(a0)
    80001bca:	03553c23          	sd	s5,56(a0)
    80001bce:	05653023          	sd	s6,64(a0)
    80001bd2:	05753423          	sd	s7,72(a0)
    80001bd6:	05853823          	sd	s8,80(a0)
    80001bda:	05953c23          	sd	s9,88(a0)
    80001bde:	07a53023          	sd	s10,96(a0)
    80001be2:	07b53423          	sd	s11,104(a0)
    80001be6:	0005b083          	ld	ra,0(a1)
    80001bea:	0085b103          	ld	sp,8(a1)
    80001bee:	6980                	ld	s0,16(a1)
    80001bf0:	6d84                	ld	s1,24(a1)
    80001bf2:	0205b903          	ld	s2,32(a1)
    80001bf6:	0285b983          	ld	s3,40(a1)
    80001bfa:	0305ba03          	ld	s4,48(a1)
    80001bfe:	0385ba83          	ld	s5,56(a1)
    80001c02:	0405bb03          	ld	s6,64(a1)
    80001c06:	0485bb83          	ld	s7,72(a1)
    80001c0a:	0505bc03          	ld	s8,80(a1)
    80001c0e:	0585bc83          	ld	s9,88(a1)
    80001c12:	0605bd03          	ld	s10,96(a1)
    80001c16:	0685bd83          	ld	s11,104(a1)
    80001c1a:	8082                	ret

0000000080001c1c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c1c:	1141                	addi	sp,sp,-16
    80001c1e:	e406                	sd	ra,8(sp)
    80001c20:	e022                	sd	s0,0(sp)
    80001c22:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c24:	00006597          	auipc	a1,0x6
    80001c28:	66458593          	addi	a1,a1,1636 # 80008288 <etext+0x288>
    80001c2c:	00010517          	auipc	a0,0x10
    80001c30:	91450513          	addi	a0,a0,-1772 # 80011540 <tickslock>
    80001c34:	00005097          	auipc	ra,0x5
    80001c38:	814080e7          	jalr	-2028(ra) # 80006448 <initlock>
}
    80001c3c:	60a2                	ld	ra,8(sp)
    80001c3e:	6402                	ld	s0,0(sp)
    80001c40:	0141                	addi	sp,sp,16
    80001c42:	8082                	ret

0000000080001c44 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c44:	1141                	addi	sp,sp,-16
    80001c46:	e406                	sd	ra,8(sp)
    80001c48:	e022                	sd	s0,0(sp)
    80001c4a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c4c:	00003797          	auipc	a5,0x3
    80001c50:	68478793          	addi	a5,a5,1668 # 800052d0 <kernelvec>
    80001c54:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c58:	60a2                	ld	ra,8(sp)
    80001c5a:	6402                	ld	s0,0(sp)
    80001c5c:	0141                	addi	sp,sp,16
    80001c5e:	8082                	ret

0000000080001c60 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c60:	1141                	addi	sp,sp,-16
    80001c62:	e406                	sd	ra,8(sp)
    80001c64:	e022                	sd	s0,0(sp)
    80001c66:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	312080e7          	jalr	786(ra) # 80000f7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c70:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c74:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c76:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c7a:	00005697          	auipc	a3,0x5
    80001c7e:	38668693          	addi	a3,a3,902 # 80007000 <_trampoline>
    80001c82:	00005717          	auipc	a4,0x5
    80001c86:	37e70713          	addi	a4,a4,894 # 80007000 <_trampoline>
    80001c8a:	8f15                	sub	a4,a4,a3
    80001c8c:	040007b7          	lui	a5,0x4000
    80001c90:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c92:	07b2                	slli	a5,a5,0xc
    80001c94:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c96:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c9a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c9c:	18002673          	csrr	a2,satp
    80001ca0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ca2:	6d30                	ld	a2,88(a0)
    80001ca4:	6138                	ld	a4,64(a0)
    80001ca6:	6585                	lui	a1,0x1
    80001ca8:	972e                	add	a4,a4,a1
    80001caa:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cac:	6d38                	ld	a4,88(a0)
    80001cae:	00000617          	auipc	a2,0x0
    80001cb2:	13860613          	addi	a2,a2,312 # 80001de6 <usertrap>
    80001cb6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cb8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cba:	8612                	mv	a2,tp
    80001cbc:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cbe:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cc2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cc6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cca:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cce:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cd0:	6f18                	ld	a4,24(a4)
    80001cd2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cd6:	6928                	ld	a0,80(a0)
    80001cd8:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001cda:	00005717          	auipc	a4,0x5
    80001cde:	3c270713          	addi	a4,a4,962 # 8000709c <userret>
    80001ce2:	8f15                	sub	a4,a4,a3
    80001ce4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001ce6:	577d                	li	a4,-1
    80001ce8:	177e                	slli	a4,a4,0x3f
    80001cea:	8d59                	or	a0,a0,a4
    80001cec:	9782                	jalr	a5
}
    80001cee:	60a2                	ld	ra,8(sp)
    80001cf0:	6402                	ld	s0,0(sp)
    80001cf2:	0141                	addi	sp,sp,16
    80001cf4:	8082                	ret

0000000080001cf6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cf6:	1101                	addi	sp,sp,-32
    80001cf8:	ec06                	sd	ra,24(sp)
    80001cfa:	e822                	sd	s0,16(sp)
    80001cfc:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001cfe:	fffff097          	auipc	ra,0xfffff
    80001d02:	248080e7          	jalr	584(ra) # 80000f46 <cpuid>
    80001d06:	cd11                	beqz	a0,80001d22 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001d08:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001d0c:	000f4737          	lui	a4,0xf4
    80001d10:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001d14:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001d16:	14d79073          	csrw	stimecmp,a5
}
    80001d1a:	60e2                	ld	ra,24(sp)
    80001d1c:	6442                	ld	s0,16(sp)
    80001d1e:	6105                	addi	sp,sp,32
    80001d20:	8082                	ret
    80001d22:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001d24:	00010497          	auipc	s1,0x10
    80001d28:	81c48493          	addi	s1,s1,-2020 # 80011540 <tickslock>
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	00004097          	auipc	ra,0x4
    80001d32:	7ae080e7          	jalr	1966(ra) # 800064dc <acquire>
    ticks++;
    80001d36:	00009517          	auipc	a0,0x9
    80001d3a:	7a250513          	addi	a0,a0,1954 # 8000b4d8 <ticks>
    80001d3e:	411c                	lw	a5,0(a0)
    80001d40:	2785                	addiw	a5,a5,1
    80001d42:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	974080e7          	jalr	-1676(ra) # 800016b8 <wakeup>
    release(&tickslock);
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	00005097          	auipc	ra,0x5
    80001d52:	83e080e7          	jalr	-1986(ra) # 8000658c <release>
    80001d56:	64a2                	ld	s1,8(sp)
    80001d58:	bf45                	j	80001d08 <clockintr+0x12>

0000000080001d5a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d5a:	1101                	addi	sp,sp,-32
    80001d5c:	ec06                	sd	ra,24(sp)
    80001d5e:	e822                	sd	s0,16(sp)
    80001d60:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d62:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001d66:	57fd                	li	a5,-1
    80001d68:	17fe                	slli	a5,a5,0x3f
    80001d6a:	07a5                	addi	a5,a5,9
    80001d6c:	00f70c63          	beq	a4,a5,80001d84 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001d70:	57fd                	li	a5,-1
    80001d72:	17fe                	slli	a5,a5,0x3f
    80001d74:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001d76:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001d78:	06f70163          	beq	a4,a5,80001dda <devintr+0x80>
  }
}
    80001d7c:	60e2                	ld	ra,24(sp)
    80001d7e:	6442                	ld	s0,16(sp)
    80001d80:	6105                	addi	sp,sp,32
    80001d82:	8082                	ret
    80001d84:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d86:	00003097          	auipc	ra,0x3
    80001d8a:	5fa080e7          	jalr	1530(ra) # 80005380 <plic_claim>
    80001d8e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d90:	47a9                	li	a5,10
    80001d92:	00f50963          	beq	a0,a5,80001da4 <devintr+0x4a>
    } else if(irq == VIRTIO0_IRQ){
    80001d96:	4785                	li	a5,1
    80001d98:	00f50b63          	beq	a0,a5,80001dae <devintr+0x54>
    return 1;
    80001d9c:	4505                	li	a0,1
    } else if(irq){
    80001d9e:	ec89                	bnez	s1,80001db8 <devintr+0x5e>
    80001da0:	64a2                	ld	s1,8(sp)
    80001da2:	bfe9                	j	80001d7c <devintr+0x22>
      uartintr();
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	654080e7          	jalr	1620(ra) # 800063f8 <uartintr>
    if(irq)
    80001dac:	a839                	j	80001dca <devintr+0x70>
      virtio_disk_intr();
    80001dae:	00004097          	auipc	ra,0x4
    80001db2:	ac6080e7          	jalr	-1338(ra) # 80005874 <virtio_disk_intr>
    if(irq)
    80001db6:	a811                	j	80001dca <devintr+0x70>
      printf("unexpected interrupt irq=%d\n", irq);
    80001db8:	85a6                	mv	a1,s1
    80001dba:	00006517          	auipc	a0,0x6
    80001dbe:	4d650513          	addi	a0,a0,1238 # 80008290 <etext+0x290>
    80001dc2:	00004097          	auipc	ra,0x4
    80001dc6:	080080e7          	jalr	128(ra) # 80005e42 <printf>
      plic_complete(irq);
    80001dca:	8526                	mv	a0,s1
    80001dcc:	00003097          	auipc	ra,0x3
    80001dd0:	5d8080e7          	jalr	1496(ra) # 800053a4 <plic_complete>
    return 1;
    80001dd4:	4505                	li	a0,1
    80001dd6:	64a2                	ld	s1,8(sp)
    80001dd8:	b755                	j	80001d7c <devintr+0x22>
    clockintr();
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	f1c080e7          	jalr	-228(ra) # 80001cf6 <clockintr>
    return 2;
    80001de2:	4509                	li	a0,2
    80001de4:	bf61                	j	80001d7c <devintr+0x22>

0000000080001de6 <usertrap>:
{
    80001de6:	1101                	addi	sp,sp,-32
    80001de8:	ec06                	sd	ra,24(sp)
    80001dea:	e822                	sd	s0,16(sp)
    80001dec:	e426                	sd	s1,8(sp)
    80001dee:	e04a                	sd	s2,0(sp)
    80001df0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001df6:	1007f793          	andi	a5,a5,256
    80001dfa:	e3b1                	bnez	a5,80001e3e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dfc:	00003797          	auipc	a5,0x3
    80001e00:	4d478793          	addi	a5,a5,1236 # 800052d0 <kernelvec>
    80001e04:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e08:	fffff097          	auipc	ra,0xfffff
    80001e0c:	172080e7          	jalr	370(ra) # 80000f7a <myproc>
    80001e10:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e12:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e14:	14102773          	csrr	a4,sepc
    80001e18:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e1a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e1e:	47a1                	li	a5,8
    80001e20:	02f70763          	beq	a4,a5,80001e4e <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	f36080e7          	jalr	-202(ra) # 80001d5a <devintr>
    80001e2c:	892a                	mv	s2,a0
    80001e2e:	c151                	beqz	a0,80001eb2 <usertrap+0xcc>
  if(killed(p))
    80001e30:	8526                	mv	a0,s1
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	aca080e7          	jalr	-1334(ra) # 800018fc <killed>
    80001e3a:	c929                	beqz	a0,80001e8c <usertrap+0xa6>
    80001e3c:	a099                	j	80001e82 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	47250513          	addi	a0,a0,1138 # 800082b0 <etext+0x2b0>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	318080e7          	jalr	792(ra) # 8000615e <panic>
    if(killed(p))
    80001e4e:	00000097          	auipc	ra,0x0
    80001e52:	aae080e7          	jalr	-1362(ra) # 800018fc <killed>
    80001e56:	e921                	bnez	a0,80001ea6 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e58:	6cb8                	ld	a4,88(s1)
    80001e5a:	6f1c                	ld	a5,24(a4)
    80001e5c:	0791                	addi	a5,a5,4
    80001e5e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e68:	10079073          	csrw	sstatus,a5
    syscall();
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	2ac080e7          	jalr	684(ra) # 80002118 <syscall>
  if(killed(p))
    80001e74:	8526                	mv	a0,s1
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	a86080e7          	jalr	-1402(ra) # 800018fc <killed>
    80001e7e:	c911                	beqz	a0,80001e92 <usertrap+0xac>
    80001e80:	4901                	li	s2,0
    exit(-1);
    80001e82:	557d                	li	a0,-1
    80001e84:	00000097          	auipc	ra,0x0
    80001e88:	904080e7          	jalr	-1788(ra) # 80001788 <exit>
  if(which_dev == 2)
    80001e8c:	4789                	li	a5,2
    80001e8e:	04f90f63          	beq	s2,a5,80001eec <usertrap+0x106>
  usertrapret();
    80001e92:	00000097          	auipc	ra,0x0
    80001e96:	dce080e7          	jalr	-562(ra) # 80001c60 <usertrapret>
}
    80001e9a:	60e2                	ld	ra,24(sp)
    80001e9c:	6442                	ld	s0,16(sp)
    80001e9e:	64a2                	ld	s1,8(sp)
    80001ea0:	6902                	ld	s2,0(sp)
    80001ea2:	6105                	addi	sp,sp,32
    80001ea4:	8082                	ret
      exit(-1);
    80001ea6:	557d                	li	a0,-1
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	8e0080e7          	jalr	-1824(ra) # 80001788 <exit>
    80001eb0:	b765                	j	80001e58 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eb2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001eb6:	5890                	lw	a2,48(s1)
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	41850513          	addi	a0,a0,1048 # 800082d0 <etext+0x2d0>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	f82080e7          	jalr	-126(ra) # 80005e42 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ecc:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001ed0:	00006517          	auipc	a0,0x6
    80001ed4:	43050513          	addi	a0,a0,1072 # 80008300 <etext+0x300>
    80001ed8:	00004097          	auipc	ra,0x4
    80001edc:	f6a080e7          	jalr	-150(ra) # 80005e42 <printf>
    setkilled(p);
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	00000097          	auipc	ra,0x0
    80001ee6:	9ee080e7          	jalr	-1554(ra) # 800018d0 <setkilled>
    80001eea:	b769                	j	80001e74 <usertrap+0x8e>
    yield();
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	72c080e7          	jalr	1836(ra) # 80001618 <yield>
    80001ef4:	bf79                	j	80001e92 <usertrap+0xac>

0000000080001ef6 <kerneltrap>:
{
    80001ef6:	7179                	addi	sp,sp,-48
    80001ef8:	f406                	sd	ra,40(sp)
    80001efa:	f022                	sd	s0,32(sp)
    80001efc:	ec26                	sd	s1,24(sp)
    80001efe:	e84a                	sd	s2,16(sp)
    80001f00:	e44e                	sd	s3,8(sp)
    80001f02:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f04:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f08:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f0c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f10:	1004f793          	andi	a5,s1,256
    80001f14:	cb85                	beqz	a5,80001f44 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f16:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f1a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f1c:	ef85                	bnez	a5,80001f54 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	e3c080e7          	jalr	-452(ra) # 80001d5a <devintr>
    80001f26:	cd1d                	beqz	a0,80001f64 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0)
    80001f28:	4789                	li	a5,2
    80001f2a:	06f50263          	beq	a0,a5,80001f8e <kerneltrap+0x98>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f2e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f32:	10049073          	csrw	sstatus,s1
}
    80001f36:	70a2                	ld	ra,40(sp)
    80001f38:	7402                	ld	s0,32(sp)
    80001f3a:	64e2                	ld	s1,24(sp)
    80001f3c:	6942                	ld	s2,16(sp)
    80001f3e:	69a2                	ld	s3,8(sp)
    80001f40:	6145                	addi	sp,sp,48
    80001f42:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	3e450513          	addi	a0,a0,996 # 80008328 <etext+0x328>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	212080e7          	jalr	530(ra) # 8000615e <panic>
    panic("kerneltrap: interrupts enabled");
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	3fc50513          	addi	a0,a0,1020 # 80008350 <etext+0x350>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	202080e7          	jalr	514(ra) # 8000615e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f64:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f68:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001f6c:	85ce                	mv	a1,s3
    80001f6e:	00006517          	auipc	a0,0x6
    80001f72:	40250513          	addi	a0,a0,1026 # 80008370 <etext+0x370>
    80001f76:	00004097          	auipc	ra,0x4
    80001f7a:	ecc080e7          	jalr	-308(ra) # 80005e42 <printf>
    panic("kerneltrap");
    80001f7e:	00006517          	auipc	a0,0x6
    80001f82:	41a50513          	addi	a0,a0,1050 # 80008398 <etext+0x398>
    80001f86:	00004097          	auipc	ra,0x4
    80001f8a:	1d8080e7          	jalr	472(ra) # 8000615e <panic>
  if(which_dev == 2 && myproc() != 0)
    80001f8e:	fffff097          	auipc	ra,0xfffff
    80001f92:	fec080e7          	jalr	-20(ra) # 80000f7a <myproc>
    80001f96:	dd41                	beqz	a0,80001f2e <kerneltrap+0x38>
    yield();
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	680080e7          	jalr	1664(ra) # 80001618 <yield>
    80001fa0:	b779                	j	80001f2e <kerneltrap+0x38>

0000000080001fa2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fa2:	1101                	addi	sp,sp,-32
    80001fa4:	ec06                	sd	ra,24(sp)
    80001fa6:	e822                	sd	s0,16(sp)
    80001fa8:	e426                	sd	s1,8(sp)
    80001faa:	1000                	addi	s0,sp,32
    80001fac:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	fcc080e7          	jalr	-52(ra) # 80000f7a <myproc>
  switch (n) {
    80001fb6:	4795                	li	a5,5
    80001fb8:	0497e163          	bltu	a5,s1,80001ffa <argraw+0x58>
    80001fbc:	048a                	slli	s1,s1,0x2
    80001fbe:	00007717          	auipc	a4,0x7
    80001fc2:	8a270713          	addi	a4,a4,-1886 # 80008860 <states.0+0x30>
    80001fc6:	94ba                	add	s1,s1,a4
    80001fc8:	409c                	lw	a5,0(s1)
    80001fca:	97ba                	add	a5,a5,a4
    80001fcc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fce:	6d3c                	ld	a5,88(a0)
    80001fd0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fd2:	60e2                	ld	ra,24(sp)
    80001fd4:	6442                	ld	s0,16(sp)
    80001fd6:	64a2                	ld	s1,8(sp)
    80001fd8:	6105                	addi	sp,sp,32
    80001fda:	8082                	ret
    return p->trapframe->a1;
    80001fdc:	6d3c                	ld	a5,88(a0)
    80001fde:	7fa8                	ld	a0,120(a5)
    80001fe0:	bfcd                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a2;
    80001fe2:	6d3c                	ld	a5,88(a0)
    80001fe4:	63c8                	ld	a0,128(a5)
    80001fe6:	b7f5                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a3;
    80001fe8:	6d3c                	ld	a5,88(a0)
    80001fea:	67c8                	ld	a0,136(a5)
    80001fec:	b7dd                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a4;
    80001fee:	6d3c                	ld	a5,88(a0)
    80001ff0:	6bc8                	ld	a0,144(a5)
    80001ff2:	b7c5                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a5;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	6fc8                	ld	a0,152(a5)
    80001ff8:	bfe9                	j	80001fd2 <argraw+0x30>
  panic("argraw");
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	3ae50513          	addi	a0,a0,942 # 800083a8 <etext+0x3a8>
    80002002:	00004097          	auipc	ra,0x4
    80002006:	15c080e7          	jalr	348(ra) # 8000615e <panic>

000000008000200a <fetchaddr>:
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	e04a                	sd	s2,0(sp)
    80002014:	1000                	addi	s0,sp,32
    80002016:	84aa                	mv	s1,a0
    80002018:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	f60080e7          	jalr	-160(ra) # 80000f7a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002022:	653c                	ld	a5,72(a0)
    80002024:	02f4f863          	bgeu	s1,a5,80002054 <fetchaddr+0x4a>
    80002028:	00848713          	addi	a4,s1,8
    8000202c:	02e7e663          	bltu	a5,a4,80002058 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002030:	46a1                	li	a3,8
    80002032:	8626                	mv	a2,s1
    80002034:	85ca                	mv	a1,s2
    80002036:	6928                	ld	a0,80(a0)
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	c42080e7          	jalr	-958(ra) # 80000c7a <copyin>
    80002040:	00a03533          	snez	a0,a0
    80002044:	40a0053b          	negw	a0,a0
}
    80002048:	60e2                	ld	ra,24(sp)
    8000204a:	6442                	ld	s0,16(sp)
    8000204c:	64a2                	ld	s1,8(sp)
    8000204e:	6902                	ld	s2,0(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret
    return -1;
    80002054:	557d                	li	a0,-1
    80002056:	bfcd                	j	80002048 <fetchaddr+0x3e>
    80002058:	557d                	li	a0,-1
    8000205a:	b7fd                	j	80002048 <fetchaddr+0x3e>

000000008000205c <fetchstr>:
{
    8000205c:	7179                	addi	sp,sp,-48
    8000205e:	f406                	sd	ra,40(sp)
    80002060:	f022                	sd	s0,32(sp)
    80002062:	ec26                	sd	s1,24(sp)
    80002064:	e84a                	sd	s2,16(sp)
    80002066:	e44e                	sd	s3,8(sp)
    80002068:	1800                	addi	s0,sp,48
    8000206a:	892a                	mv	s2,a0
    8000206c:	84ae                	mv	s1,a1
    8000206e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	f0a080e7          	jalr	-246(ra) # 80000f7a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002078:	86ce                	mv	a3,s3
    8000207a:	864a                	mv	a2,s2
    8000207c:	85a6                	mv	a1,s1
    8000207e:	6928                	ld	a0,80(a0)
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	c88080e7          	jalr	-888(ra) # 80000d08 <copyinstr>
    80002088:	00054e63          	bltz	a0,800020a4 <fetchstr+0x48>
  return strlen(buf);
    8000208c:	8526                	mv	a0,s1
    8000208e:	ffffe097          	auipc	ra,0xffffe
    80002092:	2c2080e7          	jalr	706(ra) # 80000350 <strlen>
}
    80002096:	70a2                	ld	ra,40(sp)
    80002098:	7402                	ld	s0,32(sp)
    8000209a:	64e2                	ld	s1,24(sp)
    8000209c:	6942                	ld	s2,16(sp)
    8000209e:	69a2                	ld	s3,8(sp)
    800020a0:	6145                	addi	sp,sp,48
    800020a2:	8082                	ret
    return -1;
    800020a4:	557d                	li	a0,-1
    800020a6:	bfc5                	j	80002096 <fetchstr+0x3a>

00000000800020a8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	e426                	sd	s1,8(sp)
    800020b0:	1000                	addi	s0,sp,32
    800020b2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	eee080e7          	jalr	-274(ra) # 80001fa2 <argraw>
    800020bc:	c088                	sw	a0,0(s1)
}
    800020be:	60e2                	ld	ra,24(sp)
    800020c0:	6442                	ld	s0,16(sp)
    800020c2:	64a2                	ld	s1,8(sp)
    800020c4:	6105                	addi	sp,sp,32
    800020c6:	8082                	ret

00000000800020c8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020c8:	1101                	addi	sp,sp,-32
    800020ca:	ec06                	sd	ra,24(sp)
    800020cc:	e822                	sd	s0,16(sp)
    800020ce:	e426                	sd	s1,8(sp)
    800020d0:	1000                	addi	s0,sp,32
    800020d2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020d4:	00000097          	auipc	ra,0x0
    800020d8:	ece080e7          	jalr	-306(ra) # 80001fa2 <argraw>
    800020dc:	e088                	sd	a0,0(s1)
}
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	64a2                	ld	s1,8(sp)
    800020e4:	6105                	addi	sp,sp,32
    800020e6:	8082                	ret

00000000800020e8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020e8:	1101                	addi	sp,sp,-32
    800020ea:	ec06                	sd	ra,24(sp)
    800020ec:	e822                	sd	s0,16(sp)
    800020ee:	e426                	sd	s1,8(sp)
    800020f0:	e04a                	sd	s2,0(sp)
    800020f2:	1000                	addi	s0,sp,32
    800020f4:	84ae                	mv	s1,a1
    800020f6:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020f8:	00000097          	auipc	ra,0x0
    800020fc:	eaa080e7          	jalr	-342(ra) # 80001fa2 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002100:	864a                	mv	a2,s2
    80002102:	85a6                	mv	a1,s1
    80002104:	00000097          	auipc	ra,0x0
    80002108:	f58080e7          	jalr	-168(ra) # 8000205c <fetchstr>
}
    8000210c:	60e2                	ld	ra,24(sp)
    8000210e:	6442                	ld	s0,16(sp)
    80002110:	64a2                	ld	s1,8(sp)
    80002112:	6902                	ld	s2,0(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret

0000000080002118 <syscall>:
};


void
syscall(void)
{
    80002118:	7179                	addi	sp,sp,-48
    8000211a:	f406                	sd	ra,40(sp)
    8000211c:	f022                	sd	s0,32(sp)
    8000211e:	ec26                	sd	s1,24(sp)
    80002120:	e84a                	sd	s2,16(sp)
    80002122:	e44e                	sd	s3,8(sp)
    80002124:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	e54080e7          	jalr	-428(ra) # 80000f7a <myproc>
    8000212e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002130:	05853903          	ld	s2,88(a0)
    80002134:	0a893783          	ld	a5,168(s2)
    80002138:	0007899b          	sext.w	s3,a5
  // printf("%d: syscall %s -> %ld\n", p->pid, syscallNames[num], p->trapframe->a0);
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000213c:	37fd                	addiw	a5,a5,-1
    8000213e:	4759                	li	a4,22
    80002140:	04f76763          	bltu	a4,a5,8000218e <syscall+0x76>
    80002144:	00399713          	slli	a4,s3,0x3
    80002148:	00006797          	auipc	a5,0x6
    8000214c:	73078793          	addi	a5,a5,1840 # 80008878 <syscalls>
    80002150:	97ba                	add	a5,a5,a4
    80002152:	639c                	ld	a5,0(a5)
    80002154:	cf8d                	beqz	a5,8000218e <syscall+0x76>
    // printf("After");
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002156:	9782                	jalr	a5
    80002158:	06a93823          	sd	a0,112(s2)

    // Log the syscall if its number is in the process's syscall mask.
    if ((1 << num) & p->syscallMask)
    8000215c:	1684a783          	lw	a5,360(s1)
    80002160:	4137d7bb          	sraw	a5,a5,s3
    80002164:	8b85                	andi	a5,a5,1
    80002166:	c3b9                	beqz	a5,800021ac <syscall+0x94>
      printf("%d: syscall %s -> %ld\n", p->pid, syscallNames[num], p->trapframe->a0);
    80002168:	6cb8                	ld	a4,88(s1)
    8000216a:	098e                	slli	s3,s3,0x3
    8000216c:	00006797          	auipc	a5,0x6
    80002170:	70c78793          	addi	a5,a5,1804 # 80008878 <syscalls>
    80002174:	97ce                	add	a5,a5,s3
    80002176:	7b34                	ld	a3,112(a4)
    80002178:	63f0                	ld	a2,192(a5)
    8000217a:	588c                	lw	a1,48(s1)
    8000217c:	00006517          	auipc	a0,0x6
    80002180:	23450513          	addi	a0,a0,564 # 800083b0 <etext+0x3b0>
    80002184:	00004097          	auipc	ra,0x4
    80002188:	cbe080e7          	jalr	-834(ra) # 80005e42 <printf>
    8000218c:	a005                	j	800021ac <syscall+0x94>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000218e:	86ce                	mv	a3,s3
    80002190:	15848613          	addi	a2,s1,344
    80002194:	588c                	lw	a1,48(s1)
    80002196:	00006517          	auipc	a0,0x6
    8000219a:	23250513          	addi	a0,a0,562 # 800083c8 <etext+0x3c8>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	ca4080e7          	jalr	-860(ra) # 80005e42 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021a6:	6cbc                	ld	a5,88(s1)
    800021a8:	577d                	li	a4,-1
    800021aa:	fbb8                	sd	a4,112(a5)
  }
}
    800021ac:	70a2                	ld	ra,40(sp)
    800021ae:	7402                	ld	s0,32(sp)
    800021b0:	64e2                	ld	s1,24(sp)
    800021b2:	6942                	ld	s2,16(sp)
    800021b4:	69a2                	ld	s3,8(sp)
    800021b6:	6145                	addi	sp,sp,48
    800021b8:	8082                	ret

00000000800021ba <sys_exit>:
uint64 getFreeMem(void);
int getNProc();

uint64
sys_exit(void)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021c2:	fec40593          	addi	a1,s0,-20
    800021c6:	4501                	li	a0,0
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	ee0080e7          	jalr	-288(ra) # 800020a8 <argint>
  exit(n);
    800021d0:	fec42503          	lw	a0,-20(s0)
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	5b4080e7          	jalr	1460(ra) # 80001788 <exit>
  return 0;  // not reached
}
    800021dc:	4501                	li	a0,0
    800021de:	60e2                	ld	ra,24(sp)
    800021e0:	6442                	ld	s0,16(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret

00000000800021e6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021e6:	1141                	addi	sp,sp,-16
    800021e8:	e406                	sd	ra,8(sp)
    800021ea:	e022                	sd	s0,0(sp)
    800021ec:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	d8c080e7          	jalr	-628(ra) # 80000f7a <myproc>
}
    800021f6:	5908                	lw	a0,48(a0)
    800021f8:	60a2                	ld	ra,8(sp)
    800021fa:	6402                	ld	s0,0(sp)
    800021fc:	0141                	addi	sp,sp,16
    800021fe:	8082                	ret

0000000080002200 <sys_fork>:

uint64
sys_fork(void)
{
    80002200:	1141                	addi	sp,sp,-16
    80002202:	e406                	sd	ra,8(sp)
    80002204:	e022                	sd	s0,0(sp)
    80002206:	0800                	addi	s0,sp,16
  return fork();
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	130080e7          	jalr	304(ra) # 80001338 <fork>
}
    80002210:	60a2                	ld	ra,8(sp)
    80002212:	6402                	ld	s0,0(sp)
    80002214:	0141                	addi	sp,sp,16
    80002216:	8082                	ret

0000000080002218 <sys_wait>:

uint64
sys_wait(void)
{
    80002218:	1101                	addi	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002220:	fe840593          	addi	a1,s0,-24
    80002224:	4501                	li	a0,0
    80002226:	00000097          	auipc	ra,0x0
    8000222a:	ea2080e7          	jalr	-350(ra) # 800020c8 <argaddr>
  return wait(p);
    8000222e:	fe843503          	ld	a0,-24(s0)
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	6fc080e7          	jalr	1788(ra) # 8000192e <wait>
}
    8000223a:	60e2                	ld	ra,24(sp)
    8000223c:	6442                	ld	s0,16(sp)
    8000223e:	6105                	addi	sp,sp,32
    80002240:	8082                	ret

0000000080002242 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002242:	7179                	addi	sp,sp,-48
    80002244:	f406                	sd	ra,40(sp)
    80002246:	f022                	sd	s0,32(sp)
    80002248:	ec26                	sd	s1,24(sp)
    8000224a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000224c:	fdc40593          	addi	a1,s0,-36
    80002250:	4501                	li	a0,0
    80002252:	00000097          	auipc	ra,0x0
    80002256:	e56080e7          	jalr	-426(ra) # 800020a8 <argint>
  addr = myproc()->sz;
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	d20080e7          	jalr	-736(ra) # 80000f7a <myproc>
    80002262:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002264:	fdc42503          	lw	a0,-36(s0)
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	074080e7          	jalr	116(ra) # 800012dc <growproc>
    80002270:	00054863          	bltz	a0,80002280 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002274:	8526                	mv	a0,s1
    80002276:	70a2                	ld	ra,40(sp)
    80002278:	7402                	ld	s0,32(sp)
    8000227a:	64e2                	ld	s1,24(sp)
    8000227c:	6145                	addi	sp,sp,48
    8000227e:	8082                	ret
    return -1;
    80002280:	54fd                	li	s1,-1
    80002282:	bfcd                	j	80002274 <sys_sbrk+0x32>

0000000080002284 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002284:	7139                	addi	sp,sp,-64
    80002286:	fc06                	sd	ra,56(sp)
    80002288:	f822                	sd	s0,48(sp)
    8000228a:	f04a                	sd	s2,32(sp)
    8000228c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000228e:	fcc40593          	addi	a1,s0,-52
    80002292:	4501                	li	a0,0
    80002294:	00000097          	auipc	ra,0x0
    80002298:	e14080e7          	jalr	-492(ra) # 800020a8 <argint>
  if(n < 0)
    8000229c:	fcc42783          	lw	a5,-52(s0)
    800022a0:	0807c163          	bltz	a5,80002322 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800022a4:	0000f517          	auipc	a0,0xf
    800022a8:	29c50513          	addi	a0,a0,668 # 80011540 <tickslock>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	230080e7          	jalr	560(ra) # 800064dc <acquire>
  ticks0 = ticks;
    800022b4:	00009917          	auipc	s2,0x9
    800022b8:	22492903          	lw	s2,548(s2) # 8000b4d8 <ticks>
  while(ticks - ticks0 < n){
    800022bc:	fcc42783          	lw	a5,-52(s0)
    800022c0:	c3b9                	beqz	a5,80002306 <sys_sleep+0x82>
    800022c2:	f426                	sd	s1,40(sp)
    800022c4:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022c6:	0000f997          	auipc	s3,0xf
    800022ca:	27a98993          	addi	s3,s3,634 # 80011540 <tickslock>
    800022ce:	00009497          	auipc	s1,0x9
    800022d2:	20a48493          	addi	s1,s1,522 # 8000b4d8 <ticks>
    if(killed(myproc())){
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	ca4080e7          	jalr	-860(ra) # 80000f7a <myproc>
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	61e080e7          	jalr	1566(ra) # 800018fc <killed>
    800022e6:	e129                	bnez	a0,80002328 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800022e8:	85ce                	mv	a1,s3
    800022ea:	8526                	mv	a0,s1
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	368080e7          	jalr	872(ra) # 80001654 <sleep>
  while(ticks - ticks0 < n){
    800022f4:	409c                	lw	a5,0(s1)
    800022f6:	412787bb          	subw	a5,a5,s2
    800022fa:	fcc42703          	lw	a4,-52(s0)
    800022fe:	fce7ece3          	bltu	a5,a4,800022d6 <sys_sleep+0x52>
    80002302:	74a2                	ld	s1,40(sp)
    80002304:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002306:	0000f517          	auipc	a0,0xf
    8000230a:	23a50513          	addi	a0,a0,570 # 80011540 <tickslock>
    8000230e:	00004097          	auipc	ra,0x4
    80002312:	27e080e7          	jalr	638(ra) # 8000658c <release>
  return 0;
    80002316:	4501                	li	a0,0
}
    80002318:	70e2                	ld	ra,56(sp)
    8000231a:	7442                	ld	s0,48(sp)
    8000231c:	7902                	ld	s2,32(sp)
    8000231e:	6121                	addi	sp,sp,64
    80002320:	8082                	ret
    n = 0;
    80002322:	fc042623          	sw	zero,-52(s0)
    80002326:	bfbd                	j	800022a4 <sys_sleep+0x20>
      release(&tickslock);
    80002328:	0000f517          	auipc	a0,0xf
    8000232c:	21850513          	addi	a0,a0,536 # 80011540 <tickslock>
    80002330:	00004097          	auipc	ra,0x4
    80002334:	25c080e7          	jalr	604(ra) # 8000658c <release>
      return -1;
    80002338:	557d                	li	a0,-1
    8000233a:	74a2                	ld	s1,40(sp)
    8000233c:	69e2                	ld	s3,24(sp)
    8000233e:	bfe9                	j	80002318 <sys_sleep+0x94>

0000000080002340 <sys_kill>:

uint64
sys_kill(void)
{
    80002340:	1101                	addi	sp,sp,-32
    80002342:	ec06                	sd	ra,24(sp)
    80002344:	e822                	sd	s0,16(sp)
    80002346:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002348:	fec40593          	addi	a1,s0,-20
    8000234c:	4501                	li	a0,0
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	d5a080e7          	jalr	-678(ra) # 800020a8 <argint>
  return kill(pid);
    80002356:	fec42503          	lw	a0,-20(s0)
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	504080e7          	jalr	1284(ra) # 8000185e <kill>
}
    80002362:	60e2                	ld	ra,24(sp)
    80002364:	6442                	ld	s0,16(sp)
    80002366:	6105                	addi	sp,sp,32
    80002368:	8082                	ret

000000008000236a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000236a:	1101                	addi	sp,sp,-32
    8000236c:	ec06                	sd	ra,24(sp)
    8000236e:	e822                	sd	s0,16(sp)
    80002370:	e426                	sd	s1,8(sp)
    80002372:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002374:	0000f517          	auipc	a0,0xf
    80002378:	1cc50513          	addi	a0,a0,460 # 80011540 <tickslock>
    8000237c:	00004097          	auipc	ra,0x4
    80002380:	160080e7          	jalr	352(ra) # 800064dc <acquire>
  xticks = ticks;
    80002384:	00009497          	auipc	s1,0x9
    80002388:	1544a483          	lw	s1,340(s1) # 8000b4d8 <ticks>
  release(&tickslock);
    8000238c:	0000f517          	auipc	a0,0xf
    80002390:	1b450513          	addi	a0,a0,436 # 80011540 <tickslock>
    80002394:	00004097          	auipc	ra,0x4
    80002398:	1f8080e7          	jalr	504(ra) # 8000658c <release>
  return xticks;
}
    8000239c:	02049513          	slli	a0,s1,0x20
    800023a0:	9101                	srli	a0,a0,0x20
    800023a2:	60e2                	ld	ra,24(sp)
    800023a4:	6442                	ld	s0,16(sp)
    800023a6:	64a2                	ld	s1,8(sp)
    800023a8:	6105                	addi	sp,sp,32
    800023aa:	8082                	ret

00000000800023ac <sys_trace>:

uint64
sys_trace(void)
{
    800023ac:	1101                	addi	sp,sp,-32
    800023ae:	ec06                	sd	ra,24(sp)
    800023b0:	e822                	sd	s0,16(sp)
    800023b2:	1000                	addi	s0,sp,32
  int syscallMask;
  argint(0, &syscallMask);
    800023b4:	fec40593          	addi	a1,s0,-20
    800023b8:	4501                	li	a0,0
    800023ba:	00000097          	auipc	ra,0x0
    800023be:	cee080e7          	jalr	-786(ra) # 800020a8 <argint>
  myproc()->syscallMask = syscallMask;
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	bb8080e7          	jalr	-1096(ra) # 80000f7a <myproc>
    800023ca:	fec42783          	lw	a5,-20(s0)
    800023ce:	16f52423          	sw	a5,360(a0)
  return 0;
}
    800023d2:	4501                	li	a0,0
    800023d4:	60e2                	ld	ra,24(sp)
    800023d6:	6442                	ld	s0,16(sp)
    800023d8:	6105                	addi	sp,sp,32
    800023da:	8082                	ret

00000000800023dc <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800023dc:	7139                	addi	sp,sp,-64
    800023de:	fc06                	sd	ra,56(sp)
    800023e0:	f822                	sd	s0,48(sp)
    800023e2:	f426                	sd	s1,40(sp)
    800023e4:	0080                	addi	s0,sp,64
  struct proc* p = myproc();
    800023e6:	fffff097          	auipc	ra,0xfffff
    800023ea:	b94080e7          	jalr	-1132(ra) # 80000f7a <myproc>
    800023ee:	84aa                	mv	s1,a0

  uint64 addr;
  argaddr(0, &addr);
    800023f0:	fd840593          	addi	a1,s0,-40
    800023f4:	4501                	li	a0,0
    800023f6:	00000097          	auipc	ra,0x0
    800023fa:	cd2080e7          	jalr	-814(ra) # 800020c8 <argaddr>

  struct sysinfo si;
  si.freemem = getFreeMem();
    800023fe:	ffffe097          	auipc	ra,0xffffe
    80002402:	d7c080e7          	jalr	-644(ra) # 8000017a <getFreeMem>
    80002406:	fca43423          	sd	a0,-56(s0)
  si.nproc = getNProc();
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	9a2080e7          	jalr	-1630(ra) # 80000dac <getNProc>
    80002412:	fca43823          	sd	a0,-48(s0)

  if (copyout(p->pagetable, addr, (char*)&si, sizeof(si)) < 0)
    80002416:	46c1                	li	a3,16
    80002418:	fc840613          	addi	a2,s0,-56
    8000241c:	fd843583          	ld	a1,-40(s0)
    80002420:	68a8                	ld	a0,80(s1)
    80002422:	ffffe097          	auipc	ra,0xffffe
    80002426:	7a0080e7          	jalr	1952(ra) # 80000bc2 <copyout>
    return -1;
  return 0;
}
    8000242a:	957d                	srai	a0,a0,0x3f
    8000242c:	70e2                	ld	ra,56(sp)
    8000242e:	7442                	ld	s0,48(sp)
    80002430:	74a2                	ld	s1,40(sp)
    80002432:	6121                	addi	sp,sp,64
    80002434:	8082                	ret

0000000080002436 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002436:	7179                	addi	sp,sp,-48
    80002438:	f406                	sd	ra,40(sp)
    8000243a:	f022                	sd	s0,32(sp)
    8000243c:	ec26                	sd	s1,24(sp)
    8000243e:	e84a                	sd	s2,16(sp)
    80002440:	e44e                	sd	s3,8(sp)
    80002442:	e052                	sd	s4,0(sp)
    80002444:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002446:	00006597          	auipc	a1,0x6
    8000244a:	05258593          	addi	a1,a1,82 # 80008498 <etext+0x498>
    8000244e:	0000f517          	auipc	a0,0xf
    80002452:	10a50513          	addi	a0,a0,266 # 80011558 <bcache>
    80002456:	00004097          	auipc	ra,0x4
    8000245a:	ff2080e7          	jalr	-14(ra) # 80006448 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000245e:	00017797          	auipc	a5,0x17
    80002462:	0fa78793          	addi	a5,a5,250 # 80019558 <bcache+0x8000>
    80002466:	00017717          	auipc	a4,0x17
    8000246a:	35a70713          	addi	a4,a4,858 # 800197c0 <bcache+0x8268>
    8000246e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002472:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002476:	0000f497          	auipc	s1,0xf
    8000247a:	0fa48493          	addi	s1,s1,250 # 80011570 <bcache+0x18>
    b->next = bcache.head.next;
    8000247e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002480:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002482:	00006a17          	auipc	s4,0x6
    80002486:	01ea0a13          	addi	s4,s4,30 # 800084a0 <etext+0x4a0>
    b->next = bcache.head.next;
    8000248a:	2b893783          	ld	a5,696(s2)
    8000248e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002490:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002494:	85d2                	mv	a1,s4
    80002496:	01048513          	addi	a0,s1,16
    8000249a:	00001097          	auipc	ra,0x1
    8000249e:	4e4080e7          	jalr	1252(ra) # 8000397e <initsleeplock>
    bcache.head.next->prev = b;
    800024a2:	2b893783          	ld	a5,696(s2)
    800024a6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024a8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ac:	45848493          	addi	s1,s1,1112
    800024b0:	fd349de3          	bne	s1,s3,8000248a <binit+0x54>
  }
}
    800024b4:	70a2                	ld	ra,40(sp)
    800024b6:	7402                	ld	s0,32(sp)
    800024b8:	64e2                	ld	s1,24(sp)
    800024ba:	6942                	ld	s2,16(sp)
    800024bc:	69a2                	ld	s3,8(sp)
    800024be:	6a02                	ld	s4,0(sp)
    800024c0:	6145                	addi	sp,sp,48
    800024c2:	8082                	ret

00000000800024c4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024c4:	7179                	addi	sp,sp,-48
    800024c6:	f406                	sd	ra,40(sp)
    800024c8:	f022                	sd	s0,32(sp)
    800024ca:	ec26                	sd	s1,24(sp)
    800024cc:	e84a                	sd	s2,16(sp)
    800024ce:	e44e                	sd	s3,8(sp)
    800024d0:	1800                	addi	s0,sp,48
    800024d2:	892a                	mv	s2,a0
    800024d4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800024d6:	0000f517          	auipc	a0,0xf
    800024da:	08250513          	addi	a0,a0,130 # 80011558 <bcache>
    800024de:	00004097          	auipc	ra,0x4
    800024e2:	ffe080e7          	jalr	-2(ra) # 800064dc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024e6:	00017497          	auipc	s1,0x17
    800024ea:	32a4b483          	ld	s1,810(s1) # 80019810 <bcache+0x82b8>
    800024ee:	00017797          	auipc	a5,0x17
    800024f2:	2d278793          	addi	a5,a5,722 # 800197c0 <bcache+0x8268>
    800024f6:	02f48f63          	beq	s1,a5,80002534 <bread+0x70>
    800024fa:	873e                	mv	a4,a5
    800024fc:	a021                	j	80002504 <bread+0x40>
    800024fe:	68a4                	ld	s1,80(s1)
    80002500:	02e48a63          	beq	s1,a4,80002534 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002504:	449c                	lw	a5,8(s1)
    80002506:	ff279ce3          	bne	a5,s2,800024fe <bread+0x3a>
    8000250a:	44dc                	lw	a5,12(s1)
    8000250c:	ff3799e3          	bne	a5,s3,800024fe <bread+0x3a>
      b->refcnt++;
    80002510:	40bc                	lw	a5,64(s1)
    80002512:	2785                	addiw	a5,a5,1
    80002514:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002516:	0000f517          	auipc	a0,0xf
    8000251a:	04250513          	addi	a0,a0,66 # 80011558 <bcache>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	06e080e7          	jalr	110(ra) # 8000658c <release>
      acquiresleep(&b->lock);
    80002526:	01048513          	addi	a0,s1,16
    8000252a:	00001097          	auipc	ra,0x1
    8000252e:	48e080e7          	jalr	1166(ra) # 800039b8 <acquiresleep>
      return b;
    80002532:	a8b9                	j	80002590 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002534:	00017497          	auipc	s1,0x17
    80002538:	2d44b483          	ld	s1,724(s1) # 80019808 <bcache+0x82b0>
    8000253c:	00017797          	auipc	a5,0x17
    80002540:	28478793          	addi	a5,a5,644 # 800197c0 <bcache+0x8268>
    80002544:	00f48863          	beq	s1,a5,80002554 <bread+0x90>
    80002548:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000254a:	40bc                	lw	a5,64(s1)
    8000254c:	cf81                	beqz	a5,80002564 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000254e:	64a4                	ld	s1,72(s1)
    80002550:	fee49de3          	bne	s1,a4,8000254a <bread+0x86>
  panic("bget: no buffers");
    80002554:	00006517          	auipc	a0,0x6
    80002558:	f5450513          	addi	a0,a0,-172 # 800084a8 <etext+0x4a8>
    8000255c:	00004097          	auipc	ra,0x4
    80002560:	c02080e7          	jalr	-1022(ra) # 8000615e <panic>
      b->dev = dev;
    80002564:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002568:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000256c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002570:	4785                	li	a5,1
    80002572:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002574:	0000f517          	auipc	a0,0xf
    80002578:	fe450513          	addi	a0,a0,-28 # 80011558 <bcache>
    8000257c:	00004097          	auipc	ra,0x4
    80002580:	010080e7          	jalr	16(ra) # 8000658c <release>
      acquiresleep(&b->lock);
    80002584:	01048513          	addi	a0,s1,16
    80002588:	00001097          	auipc	ra,0x1
    8000258c:	430080e7          	jalr	1072(ra) # 800039b8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002590:	409c                	lw	a5,0(s1)
    80002592:	cb89                	beqz	a5,800025a4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002594:	8526                	mv	a0,s1
    80002596:	70a2                	ld	ra,40(sp)
    80002598:	7402                	ld	s0,32(sp)
    8000259a:	64e2                	ld	s1,24(sp)
    8000259c:	6942                	ld	s2,16(sp)
    8000259e:	69a2                	ld	s3,8(sp)
    800025a0:	6145                	addi	sp,sp,48
    800025a2:	8082                	ret
    virtio_disk_rw(b, 0);
    800025a4:	4581                	li	a1,0
    800025a6:	8526                	mv	a0,s1
    800025a8:	00003097          	auipc	ra,0x3
    800025ac:	0a4080e7          	jalr	164(ra) # 8000564c <virtio_disk_rw>
    b->valid = 1;
    800025b0:	4785                	li	a5,1
    800025b2:	c09c                	sw	a5,0(s1)
  return b;
    800025b4:	b7c5                	j	80002594 <bread+0xd0>

00000000800025b6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025b6:	1101                	addi	sp,sp,-32
    800025b8:	ec06                	sd	ra,24(sp)
    800025ba:	e822                	sd	s0,16(sp)
    800025bc:	e426                	sd	s1,8(sp)
    800025be:	1000                	addi	s0,sp,32
    800025c0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025c2:	0541                	addi	a0,a0,16
    800025c4:	00001097          	auipc	ra,0x1
    800025c8:	48e080e7          	jalr	1166(ra) # 80003a52 <holdingsleep>
    800025cc:	cd01                	beqz	a0,800025e4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025ce:	4585                	li	a1,1
    800025d0:	8526                	mv	a0,s1
    800025d2:	00003097          	auipc	ra,0x3
    800025d6:	07a080e7          	jalr	122(ra) # 8000564c <virtio_disk_rw>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6105                	addi	sp,sp,32
    800025e2:	8082                	ret
    panic("bwrite");
    800025e4:	00006517          	auipc	a0,0x6
    800025e8:	edc50513          	addi	a0,a0,-292 # 800084c0 <etext+0x4c0>
    800025ec:	00004097          	auipc	ra,0x4
    800025f0:	b72080e7          	jalr	-1166(ra) # 8000615e <panic>

00000000800025f4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025f4:	1101                	addi	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	e04a                	sd	s2,0(sp)
    800025fe:	1000                	addi	s0,sp,32
    80002600:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002602:	01050913          	addi	s2,a0,16
    80002606:	854a                	mv	a0,s2
    80002608:	00001097          	auipc	ra,0x1
    8000260c:	44a080e7          	jalr	1098(ra) # 80003a52 <holdingsleep>
    80002610:	c535                	beqz	a0,8000267c <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80002612:	854a                	mv	a0,s2
    80002614:	00001097          	auipc	ra,0x1
    80002618:	3fa080e7          	jalr	1018(ra) # 80003a0e <releasesleep>

  acquire(&bcache.lock);
    8000261c:	0000f517          	auipc	a0,0xf
    80002620:	f3c50513          	addi	a0,a0,-196 # 80011558 <bcache>
    80002624:	00004097          	auipc	ra,0x4
    80002628:	eb8080e7          	jalr	-328(ra) # 800064dc <acquire>
  b->refcnt--;
    8000262c:	40bc                	lw	a5,64(s1)
    8000262e:	37fd                	addiw	a5,a5,-1
    80002630:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002632:	e79d                	bnez	a5,80002660 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002634:	68b8                	ld	a4,80(s1)
    80002636:	64bc                	ld	a5,72(s1)
    80002638:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000263a:	68b8                	ld	a4,80(s1)
    8000263c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000263e:	00017797          	auipc	a5,0x17
    80002642:	f1a78793          	addi	a5,a5,-230 # 80019558 <bcache+0x8000>
    80002646:	2b87b703          	ld	a4,696(a5)
    8000264a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000264c:	00017717          	auipc	a4,0x17
    80002650:	17470713          	addi	a4,a4,372 # 800197c0 <bcache+0x8268>
    80002654:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002656:	2b87b703          	ld	a4,696(a5)
    8000265a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000265c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002660:	0000f517          	auipc	a0,0xf
    80002664:	ef850513          	addi	a0,a0,-264 # 80011558 <bcache>
    80002668:	00004097          	auipc	ra,0x4
    8000266c:	f24080e7          	jalr	-220(ra) # 8000658c <release>
}
    80002670:	60e2                	ld	ra,24(sp)
    80002672:	6442                	ld	s0,16(sp)
    80002674:	64a2                	ld	s1,8(sp)
    80002676:	6902                	ld	s2,0(sp)
    80002678:	6105                	addi	sp,sp,32
    8000267a:	8082                	ret
    panic("brelse");
    8000267c:	00006517          	auipc	a0,0x6
    80002680:	e4c50513          	addi	a0,a0,-436 # 800084c8 <etext+0x4c8>
    80002684:	00004097          	auipc	ra,0x4
    80002688:	ada080e7          	jalr	-1318(ra) # 8000615e <panic>

000000008000268c <bpin>:

void
bpin(struct buf *b) {
    8000268c:	1101                	addi	sp,sp,-32
    8000268e:	ec06                	sd	ra,24(sp)
    80002690:	e822                	sd	s0,16(sp)
    80002692:	e426                	sd	s1,8(sp)
    80002694:	1000                	addi	s0,sp,32
    80002696:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002698:	0000f517          	auipc	a0,0xf
    8000269c:	ec050513          	addi	a0,a0,-320 # 80011558 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	e3c080e7          	jalr	-452(ra) # 800064dc <acquire>
  b->refcnt++;
    800026a8:	40bc                	lw	a5,64(s1)
    800026aa:	2785                	addiw	a5,a5,1
    800026ac:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ae:	0000f517          	auipc	a0,0xf
    800026b2:	eaa50513          	addi	a0,a0,-342 # 80011558 <bcache>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	ed6080e7          	jalr	-298(ra) # 8000658c <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret

00000000800026c8 <bunpin>:

void
bunpin(struct buf *b) {
    800026c8:	1101                	addi	sp,sp,-32
    800026ca:	ec06                	sd	ra,24(sp)
    800026cc:	e822                	sd	s0,16(sp)
    800026ce:	e426                	sd	s1,8(sp)
    800026d0:	1000                	addi	s0,sp,32
    800026d2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026d4:	0000f517          	auipc	a0,0xf
    800026d8:	e8450513          	addi	a0,a0,-380 # 80011558 <bcache>
    800026dc:	00004097          	auipc	ra,0x4
    800026e0:	e00080e7          	jalr	-512(ra) # 800064dc <acquire>
  b->refcnt--;
    800026e4:	40bc                	lw	a5,64(s1)
    800026e6:	37fd                	addiw	a5,a5,-1
    800026e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ea:	0000f517          	auipc	a0,0xf
    800026ee:	e6e50513          	addi	a0,a0,-402 # 80011558 <bcache>
    800026f2:	00004097          	auipc	ra,0x4
    800026f6:	e9a080e7          	jalr	-358(ra) # 8000658c <release>
}
    800026fa:	60e2                	ld	ra,24(sp)
    800026fc:	6442                	ld	s0,16(sp)
    800026fe:	64a2                	ld	s1,8(sp)
    80002700:	6105                	addi	sp,sp,32
    80002702:	8082                	ret

0000000080002704 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002704:	1101                	addi	sp,sp,-32
    80002706:	ec06                	sd	ra,24(sp)
    80002708:	e822                	sd	s0,16(sp)
    8000270a:	e426                	sd	s1,8(sp)
    8000270c:	e04a                	sd	s2,0(sp)
    8000270e:	1000                	addi	s0,sp,32
    80002710:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002712:	00d5d79b          	srliw	a5,a1,0xd
    80002716:	00017597          	auipc	a1,0x17
    8000271a:	51e5a583          	lw	a1,1310(a1) # 80019c34 <sb+0x1c>
    8000271e:	9dbd                	addw	a1,a1,a5
    80002720:	00000097          	auipc	ra,0x0
    80002724:	da4080e7          	jalr	-604(ra) # 800024c4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002728:	0074f713          	andi	a4,s1,7
    8000272c:	4785                	li	a5,1
    8000272e:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002732:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002734:	90d9                	srli	s1,s1,0x36
    80002736:	00950733          	add	a4,a0,s1
    8000273a:	05874703          	lbu	a4,88(a4)
    8000273e:	00e7f6b3          	and	a3,a5,a4
    80002742:	c69d                	beqz	a3,80002770 <bfree+0x6c>
    80002744:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002746:	94aa                	add	s1,s1,a0
    80002748:	fff7c793          	not	a5,a5
    8000274c:	8f7d                	and	a4,a4,a5
    8000274e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002752:	00001097          	auipc	ra,0x1
    80002756:	148080e7          	jalr	328(ra) # 8000389a <log_write>
  brelse(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	e98080e7          	jalr	-360(ra) # 800025f4 <brelse>
}
    80002764:	60e2                	ld	ra,24(sp)
    80002766:	6442                	ld	s0,16(sp)
    80002768:	64a2                	ld	s1,8(sp)
    8000276a:	6902                	ld	s2,0(sp)
    8000276c:	6105                	addi	sp,sp,32
    8000276e:	8082                	ret
    panic("freeing free block");
    80002770:	00006517          	auipc	a0,0x6
    80002774:	d6050513          	addi	a0,a0,-672 # 800084d0 <etext+0x4d0>
    80002778:	00004097          	auipc	ra,0x4
    8000277c:	9e6080e7          	jalr	-1562(ra) # 8000615e <panic>

0000000080002780 <balloc>:
{
    80002780:	715d                	addi	sp,sp,-80
    80002782:	e486                	sd	ra,72(sp)
    80002784:	e0a2                	sd	s0,64(sp)
    80002786:	fc26                	sd	s1,56(sp)
    80002788:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000278a:	00017797          	auipc	a5,0x17
    8000278e:	4927a783          	lw	a5,1170(a5) # 80019c1c <sb+0x4>
    80002792:	10078863          	beqz	a5,800028a2 <balloc+0x122>
    80002796:	f84a                	sd	s2,48(sp)
    80002798:	f44e                	sd	s3,40(sp)
    8000279a:	f052                	sd	s4,32(sp)
    8000279c:	ec56                	sd	s5,24(sp)
    8000279e:	e85a                	sd	s6,16(sp)
    800027a0:	e45e                	sd	s7,8(sp)
    800027a2:	e062                	sd	s8,0(sp)
    800027a4:	8baa                	mv	s7,a0
    800027a6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027a8:	00017b17          	auipc	s6,0x17
    800027ac:	470b0b13          	addi	s6,s6,1136 # 80019c18 <sb>
      m = 1 << (bi % 8);
    800027b0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027b2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027b4:	6c09                	lui	s8,0x2
    800027b6:	a049                	j	80002838 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027b8:	97ca                	add	a5,a5,s2
    800027ba:	8e55                	or	a2,a2,a3
    800027bc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027c0:	854a                	mv	a0,s2
    800027c2:	00001097          	auipc	ra,0x1
    800027c6:	0d8080e7          	jalr	216(ra) # 8000389a <log_write>
        brelse(bp);
    800027ca:	854a                	mv	a0,s2
    800027cc:	00000097          	auipc	ra,0x0
    800027d0:	e28080e7          	jalr	-472(ra) # 800025f4 <brelse>
  bp = bread(dev, bno);
    800027d4:	85a6                	mv	a1,s1
    800027d6:	855e                	mv	a0,s7
    800027d8:	00000097          	auipc	ra,0x0
    800027dc:	cec080e7          	jalr	-788(ra) # 800024c4 <bread>
    800027e0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027e2:	40000613          	li	a2,1024
    800027e6:	4581                	li	a1,0
    800027e8:	05850513          	addi	a0,a0,88
    800027ec:	ffffe097          	auipc	ra,0xffffe
    800027f0:	9d8080e7          	jalr	-1576(ra) # 800001c4 <memset>
  log_write(bp);
    800027f4:	854a                	mv	a0,s2
    800027f6:	00001097          	auipc	ra,0x1
    800027fa:	0a4080e7          	jalr	164(ra) # 8000389a <log_write>
  brelse(bp);
    800027fe:	854a                	mv	a0,s2
    80002800:	00000097          	auipc	ra,0x0
    80002804:	df4080e7          	jalr	-524(ra) # 800025f4 <brelse>
}
    80002808:	7942                	ld	s2,48(sp)
    8000280a:	79a2                	ld	s3,40(sp)
    8000280c:	7a02                	ld	s4,32(sp)
    8000280e:	6ae2                	ld	s5,24(sp)
    80002810:	6b42                	ld	s6,16(sp)
    80002812:	6ba2                	ld	s7,8(sp)
    80002814:	6c02                	ld	s8,0(sp)
}
    80002816:	8526                	mv	a0,s1
    80002818:	60a6                	ld	ra,72(sp)
    8000281a:	6406                	ld	s0,64(sp)
    8000281c:	74e2                	ld	s1,56(sp)
    8000281e:	6161                	addi	sp,sp,80
    80002820:	8082                	ret
    brelse(bp);
    80002822:	854a                	mv	a0,s2
    80002824:	00000097          	auipc	ra,0x0
    80002828:	dd0080e7          	jalr	-560(ra) # 800025f4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000282c:	015c0abb          	addw	s5,s8,s5
    80002830:	004b2783          	lw	a5,4(s6)
    80002834:	06faf063          	bgeu	s5,a5,80002894 <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    80002838:	41fad79b          	sraiw	a5,s5,0x1f
    8000283c:	0137d79b          	srliw	a5,a5,0x13
    80002840:	015787bb          	addw	a5,a5,s5
    80002844:	40d7d79b          	sraiw	a5,a5,0xd
    80002848:	01cb2583          	lw	a1,28(s6)
    8000284c:	9dbd                	addw	a1,a1,a5
    8000284e:	855e                	mv	a0,s7
    80002850:	00000097          	auipc	ra,0x0
    80002854:	c74080e7          	jalr	-908(ra) # 800024c4 <bread>
    80002858:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000285a:	004b2503          	lw	a0,4(s6)
    8000285e:	84d6                	mv	s1,s5
    80002860:	4701                	li	a4,0
    80002862:	fca4f0e3          	bgeu	s1,a0,80002822 <balloc+0xa2>
      m = 1 << (bi % 8);
    80002866:	00777693          	andi	a3,a4,7
    8000286a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000286e:	41f7579b          	sraiw	a5,a4,0x1f
    80002872:	01d7d79b          	srliw	a5,a5,0x1d
    80002876:	9fb9                	addw	a5,a5,a4
    80002878:	4037d79b          	sraiw	a5,a5,0x3
    8000287c:	00f90633          	add	a2,s2,a5
    80002880:	05864603          	lbu	a2,88(a2)
    80002884:	00c6f5b3          	and	a1,a3,a2
    80002888:	d985                	beqz	a1,800027b8 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000288a:	2705                	addiw	a4,a4,1
    8000288c:	2485                	addiw	s1,s1,1
    8000288e:	fd471ae3          	bne	a4,s4,80002862 <balloc+0xe2>
    80002892:	bf41                	j	80002822 <balloc+0xa2>
    80002894:	7942                	ld	s2,48(sp)
    80002896:	79a2                	ld	s3,40(sp)
    80002898:	7a02                	ld	s4,32(sp)
    8000289a:	6ae2                	ld	s5,24(sp)
    8000289c:	6b42                	ld	s6,16(sp)
    8000289e:	6ba2                	ld	s7,8(sp)
    800028a0:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800028a2:	00006517          	auipc	a0,0x6
    800028a6:	c4650513          	addi	a0,a0,-954 # 800084e8 <etext+0x4e8>
    800028aa:	00003097          	auipc	ra,0x3
    800028ae:	598080e7          	jalr	1432(ra) # 80005e42 <printf>
  return 0;
    800028b2:	4481                	li	s1,0
    800028b4:	b78d                	j	80002816 <balloc+0x96>

00000000800028b6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800028b6:	7179                	addi	sp,sp,-48
    800028b8:	f406                	sd	ra,40(sp)
    800028ba:	f022                	sd	s0,32(sp)
    800028bc:	ec26                	sd	s1,24(sp)
    800028be:	e84a                	sd	s2,16(sp)
    800028c0:	e44e                	sd	s3,8(sp)
    800028c2:	1800                	addi	s0,sp,48
    800028c4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028c6:	47ad                	li	a5,11
    800028c8:	02b7e563          	bltu	a5,a1,800028f2 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    800028cc:	02059793          	slli	a5,a1,0x20
    800028d0:	01e7d593          	srli	a1,a5,0x1e
    800028d4:	00b504b3          	add	s1,a0,a1
    800028d8:	0504a903          	lw	s2,80(s1)
    800028dc:	06091b63          	bnez	s2,80002952 <bmap+0x9c>
      addr = balloc(ip->dev);
    800028e0:	4108                	lw	a0,0(a0)
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	e9e080e7          	jalr	-354(ra) # 80002780 <balloc>
    800028ea:	892a                	mv	s2,a0
      if(addr == 0)
    800028ec:	c13d                	beqz	a0,80002952 <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    800028ee:	c8a8                	sw	a0,80(s1)
    800028f0:	a08d                	j	80002952 <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028f2:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800028f6:	0ff00793          	li	a5,255
    800028fa:	0897e363          	bltu	a5,s1,80002980 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028fe:	08052903          	lw	s2,128(a0)
    80002902:	00091d63          	bnez	s2,8000291c <bmap+0x66>
      addr = balloc(ip->dev);
    80002906:	4108                	lw	a0,0(a0)
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	e78080e7          	jalr	-392(ra) # 80002780 <balloc>
    80002910:	892a                	mv	s2,a0
      if(addr == 0)
    80002912:	c121                	beqz	a0,80002952 <bmap+0x9c>
    80002914:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002916:	08a9a023          	sw	a0,128(s3)
    8000291a:	a011                	j	8000291e <bmap+0x68>
    8000291c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000291e:	85ca                	mv	a1,s2
    80002920:	0009a503          	lw	a0,0(s3)
    80002924:	00000097          	auipc	ra,0x0
    80002928:	ba0080e7          	jalr	-1120(ra) # 800024c4 <bread>
    8000292c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000292e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002932:	02049713          	slli	a4,s1,0x20
    80002936:	01e75593          	srli	a1,a4,0x1e
    8000293a:	00b784b3          	add	s1,a5,a1
    8000293e:	0004a903          	lw	s2,0(s1)
    80002942:	02090063          	beqz	s2,80002962 <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002946:	8552                	mv	a0,s4
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	cac080e7          	jalr	-852(ra) # 800025f4 <brelse>
    return addr;
    80002950:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002952:	854a                	mv	a0,s2
    80002954:	70a2                	ld	ra,40(sp)
    80002956:	7402                	ld	s0,32(sp)
    80002958:	64e2                	ld	s1,24(sp)
    8000295a:	6942                	ld	s2,16(sp)
    8000295c:	69a2                	ld	s3,8(sp)
    8000295e:	6145                	addi	sp,sp,48
    80002960:	8082                	ret
      addr = balloc(ip->dev);
    80002962:	0009a503          	lw	a0,0(s3)
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	e1a080e7          	jalr	-486(ra) # 80002780 <balloc>
    8000296e:	892a                	mv	s2,a0
      if(addr){
    80002970:	d979                	beqz	a0,80002946 <bmap+0x90>
        a[bn] = addr;
    80002972:	c088                	sw	a0,0(s1)
        log_write(bp);
    80002974:	8552                	mv	a0,s4
    80002976:	00001097          	auipc	ra,0x1
    8000297a:	f24080e7          	jalr	-220(ra) # 8000389a <log_write>
    8000297e:	b7e1                	j	80002946 <bmap+0x90>
    80002980:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002982:	00006517          	auipc	a0,0x6
    80002986:	b7e50513          	addi	a0,a0,-1154 # 80008500 <etext+0x500>
    8000298a:	00003097          	auipc	ra,0x3
    8000298e:	7d4080e7          	jalr	2004(ra) # 8000615e <panic>

0000000080002992 <iget>:
{
    80002992:	7179                	addi	sp,sp,-48
    80002994:	f406                	sd	ra,40(sp)
    80002996:	f022                	sd	s0,32(sp)
    80002998:	ec26                	sd	s1,24(sp)
    8000299a:	e84a                	sd	s2,16(sp)
    8000299c:	e44e                	sd	s3,8(sp)
    8000299e:	e052                	sd	s4,0(sp)
    800029a0:	1800                	addi	s0,sp,48
    800029a2:	89aa                	mv	s3,a0
    800029a4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029a6:	00017517          	auipc	a0,0x17
    800029aa:	29250513          	addi	a0,a0,658 # 80019c38 <itable>
    800029ae:	00004097          	auipc	ra,0x4
    800029b2:	b2e080e7          	jalr	-1234(ra) # 800064dc <acquire>
  empty = 0;
    800029b6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029b8:	00017497          	auipc	s1,0x17
    800029bc:	29848493          	addi	s1,s1,664 # 80019c50 <itable+0x18>
    800029c0:	00019697          	auipc	a3,0x19
    800029c4:	d2068693          	addi	a3,a3,-736 # 8001b6e0 <log>
    800029c8:	a039                	j	800029d6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029ca:	02090b63          	beqz	s2,80002a00 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ce:	08848493          	addi	s1,s1,136
    800029d2:	02d48a63          	beq	s1,a3,80002a06 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029d6:	449c                	lw	a5,8(s1)
    800029d8:	fef059e3          	blez	a5,800029ca <iget+0x38>
    800029dc:	4098                	lw	a4,0(s1)
    800029de:	ff3716e3          	bne	a4,s3,800029ca <iget+0x38>
    800029e2:	40d8                	lw	a4,4(s1)
    800029e4:	ff4713e3          	bne	a4,s4,800029ca <iget+0x38>
      ip->ref++;
    800029e8:	2785                	addiw	a5,a5,1
    800029ea:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029ec:	00017517          	auipc	a0,0x17
    800029f0:	24c50513          	addi	a0,a0,588 # 80019c38 <itable>
    800029f4:	00004097          	auipc	ra,0x4
    800029f8:	b98080e7          	jalr	-1128(ra) # 8000658c <release>
      return ip;
    800029fc:	8926                	mv	s2,s1
    800029fe:	a03d                	j	80002a2c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a00:	f7f9                	bnez	a5,800029ce <iget+0x3c>
      empty = ip;
    80002a02:	8926                	mv	s2,s1
    80002a04:	b7e9                	j	800029ce <iget+0x3c>
  if(empty == 0)
    80002a06:	02090c63          	beqz	s2,80002a3e <iget+0xac>
  ip->dev = dev;
    80002a0a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a0e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a12:	4785                	li	a5,1
    80002a14:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a18:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a1c:	00017517          	auipc	a0,0x17
    80002a20:	21c50513          	addi	a0,a0,540 # 80019c38 <itable>
    80002a24:	00004097          	auipc	ra,0x4
    80002a28:	b68080e7          	jalr	-1176(ra) # 8000658c <release>
}
    80002a2c:	854a                	mv	a0,s2
    80002a2e:	70a2                	ld	ra,40(sp)
    80002a30:	7402                	ld	s0,32(sp)
    80002a32:	64e2                	ld	s1,24(sp)
    80002a34:	6942                	ld	s2,16(sp)
    80002a36:	69a2                	ld	s3,8(sp)
    80002a38:	6a02                	ld	s4,0(sp)
    80002a3a:	6145                	addi	sp,sp,48
    80002a3c:	8082                	ret
    panic("iget: no inodes");
    80002a3e:	00006517          	auipc	a0,0x6
    80002a42:	ada50513          	addi	a0,a0,-1318 # 80008518 <etext+0x518>
    80002a46:	00003097          	auipc	ra,0x3
    80002a4a:	718080e7          	jalr	1816(ra) # 8000615e <panic>

0000000080002a4e <fsinit>:
fsinit(int dev) {
    80002a4e:	7179                	addi	sp,sp,-48
    80002a50:	f406                	sd	ra,40(sp)
    80002a52:	f022                	sd	s0,32(sp)
    80002a54:	ec26                	sd	s1,24(sp)
    80002a56:	e84a                	sd	s2,16(sp)
    80002a58:	e44e                	sd	s3,8(sp)
    80002a5a:	1800                	addi	s0,sp,48
    80002a5c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a5e:	4585                	li	a1,1
    80002a60:	00000097          	auipc	ra,0x0
    80002a64:	a64080e7          	jalr	-1436(ra) # 800024c4 <bread>
    80002a68:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a6a:	00017997          	auipc	s3,0x17
    80002a6e:	1ae98993          	addi	s3,s3,430 # 80019c18 <sb>
    80002a72:	02000613          	li	a2,32
    80002a76:	05850593          	addi	a1,a0,88
    80002a7a:	854e                	mv	a0,s3
    80002a7c:	ffffd097          	auipc	ra,0xffffd
    80002a80:	7ac080e7          	jalr	1964(ra) # 80000228 <memmove>
  brelse(bp);
    80002a84:	8526                	mv	a0,s1
    80002a86:	00000097          	auipc	ra,0x0
    80002a8a:	b6e080e7          	jalr	-1170(ra) # 800025f4 <brelse>
  if(sb.magic != FSMAGIC)
    80002a8e:	0009a703          	lw	a4,0(s3)
    80002a92:	102037b7          	lui	a5,0x10203
    80002a96:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a9a:	02f71263          	bne	a4,a5,80002abe <fsinit+0x70>
  initlog(dev, &sb);
    80002a9e:	00017597          	auipc	a1,0x17
    80002aa2:	17a58593          	addi	a1,a1,378 # 80019c18 <sb>
    80002aa6:	854a                	mv	a0,s2
    80002aa8:	00001097          	auipc	ra,0x1
    80002aac:	b7c080e7          	jalr	-1156(ra) # 80003624 <initlog>
}
    80002ab0:	70a2                	ld	ra,40(sp)
    80002ab2:	7402                	ld	s0,32(sp)
    80002ab4:	64e2                	ld	s1,24(sp)
    80002ab6:	6942                	ld	s2,16(sp)
    80002ab8:	69a2                	ld	s3,8(sp)
    80002aba:	6145                	addi	sp,sp,48
    80002abc:	8082                	ret
    panic("invalid file system");
    80002abe:	00006517          	auipc	a0,0x6
    80002ac2:	a6a50513          	addi	a0,a0,-1430 # 80008528 <etext+0x528>
    80002ac6:	00003097          	auipc	ra,0x3
    80002aca:	698080e7          	jalr	1688(ra) # 8000615e <panic>

0000000080002ace <iinit>:
{
    80002ace:	7179                	addi	sp,sp,-48
    80002ad0:	f406                	sd	ra,40(sp)
    80002ad2:	f022                	sd	s0,32(sp)
    80002ad4:	ec26                	sd	s1,24(sp)
    80002ad6:	e84a                	sd	s2,16(sp)
    80002ad8:	e44e                	sd	s3,8(sp)
    80002ada:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002adc:	00006597          	auipc	a1,0x6
    80002ae0:	a6458593          	addi	a1,a1,-1436 # 80008540 <etext+0x540>
    80002ae4:	00017517          	auipc	a0,0x17
    80002ae8:	15450513          	addi	a0,a0,340 # 80019c38 <itable>
    80002aec:	00004097          	auipc	ra,0x4
    80002af0:	95c080e7          	jalr	-1700(ra) # 80006448 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002af4:	00017497          	auipc	s1,0x17
    80002af8:	16c48493          	addi	s1,s1,364 # 80019c60 <itable+0x28>
    80002afc:	00019997          	auipc	s3,0x19
    80002b00:	bf498993          	addi	s3,s3,-1036 # 8001b6f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b04:	00006917          	auipc	s2,0x6
    80002b08:	a4490913          	addi	s2,s2,-1468 # 80008548 <etext+0x548>
    80002b0c:	85ca                	mv	a1,s2
    80002b0e:	8526                	mv	a0,s1
    80002b10:	00001097          	auipc	ra,0x1
    80002b14:	e6e080e7          	jalr	-402(ra) # 8000397e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b18:	08848493          	addi	s1,s1,136
    80002b1c:	ff3498e3          	bne	s1,s3,80002b0c <iinit+0x3e>
}
    80002b20:	70a2                	ld	ra,40(sp)
    80002b22:	7402                	ld	s0,32(sp)
    80002b24:	64e2                	ld	s1,24(sp)
    80002b26:	6942                	ld	s2,16(sp)
    80002b28:	69a2                	ld	s3,8(sp)
    80002b2a:	6145                	addi	sp,sp,48
    80002b2c:	8082                	ret

0000000080002b2e <ialloc>:
{
    80002b2e:	7139                	addi	sp,sp,-64
    80002b30:	fc06                	sd	ra,56(sp)
    80002b32:	f822                	sd	s0,48(sp)
    80002b34:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b36:	00017717          	auipc	a4,0x17
    80002b3a:	0ee72703          	lw	a4,238(a4) # 80019c24 <sb+0xc>
    80002b3e:	4785                	li	a5,1
    80002b40:	06e7f463          	bgeu	a5,a4,80002ba8 <ialloc+0x7a>
    80002b44:	f426                	sd	s1,40(sp)
    80002b46:	f04a                	sd	s2,32(sp)
    80002b48:	ec4e                	sd	s3,24(sp)
    80002b4a:	e852                	sd	s4,16(sp)
    80002b4c:	e456                	sd	s5,8(sp)
    80002b4e:	e05a                	sd	s6,0(sp)
    80002b50:	8aaa                	mv	s5,a0
    80002b52:	8b2e                	mv	s6,a1
    80002b54:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002b56:	00017a17          	auipc	s4,0x17
    80002b5a:	0c2a0a13          	addi	s4,s4,194 # 80019c18 <sb>
    80002b5e:	00495593          	srli	a1,s2,0x4
    80002b62:	018a2783          	lw	a5,24(s4)
    80002b66:	9dbd                	addw	a1,a1,a5
    80002b68:	8556                	mv	a0,s5
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	95a080e7          	jalr	-1702(ra) # 800024c4 <bread>
    80002b72:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b74:	05850993          	addi	s3,a0,88
    80002b78:	00f97793          	andi	a5,s2,15
    80002b7c:	079a                	slli	a5,a5,0x6
    80002b7e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b80:	00099783          	lh	a5,0(s3)
    80002b84:	cf9d                	beqz	a5,80002bc2 <ialloc+0x94>
    brelse(bp);
    80002b86:	00000097          	auipc	ra,0x0
    80002b8a:	a6e080e7          	jalr	-1426(ra) # 800025f4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b8e:	0905                	addi	s2,s2,1
    80002b90:	00ca2703          	lw	a4,12(s4)
    80002b94:	0009079b          	sext.w	a5,s2
    80002b98:	fce7e3e3          	bltu	a5,a4,80002b5e <ialloc+0x30>
    80002b9c:	74a2                	ld	s1,40(sp)
    80002b9e:	7902                	ld	s2,32(sp)
    80002ba0:	69e2                	ld	s3,24(sp)
    80002ba2:	6a42                	ld	s4,16(sp)
    80002ba4:	6aa2                	ld	s5,8(sp)
    80002ba6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002ba8:	00006517          	auipc	a0,0x6
    80002bac:	9a850513          	addi	a0,a0,-1624 # 80008550 <etext+0x550>
    80002bb0:	00003097          	auipc	ra,0x3
    80002bb4:	292080e7          	jalr	658(ra) # 80005e42 <printf>
  return 0;
    80002bb8:	4501                	li	a0,0
}
    80002bba:	70e2                	ld	ra,56(sp)
    80002bbc:	7442                	ld	s0,48(sp)
    80002bbe:	6121                	addi	sp,sp,64
    80002bc0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002bc2:	04000613          	li	a2,64
    80002bc6:	4581                	li	a1,0
    80002bc8:	854e                	mv	a0,s3
    80002bca:	ffffd097          	auipc	ra,0xffffd
    80002bce:	5fa080e7          	jalr	1530(ra) # 800001c4 <memset>
      dip->type = type;
    80002bd2:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bd6:	8526                	mv	a0,s1
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	cc2080e7          	jalr	-830(ra) # 8000389a <log_write>
      brelse(bp);
    80002be0:	8526                	mv	a0,s1
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	a12080e7          	jalr	-1518(ra) # 800025f4 <brelse>
      return iget(dev, inum);
    80002bea:	0009059b          	sext.w	a1,s2
    80002bee:	8556                	mv	a0,s5
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	da2080e7          	jalr	-606(ra) # 80002992 <iget>
    80002bf8:	74a2                	ld	s1,40(sp)
    80002bfa:	7902                	ld	s2,32(sp)
    80002bfc:	69e2                	ld	s3,24(sp)
    80002bfe:	6a42                	ld	s4,16(sp)
    80002c00:	6aa2                	ld	s5,8(sp)
    80002c02:	6b02                	ld	s6,0(sp)
    80002c04:	bf5d                	j	80002bba <ialloc+0x8c>

0000000080002c06 <iupdate>:
{
    80002c06:	1101                	addi	sp,sp,-32
    80002c08:	ec06                	sd	ra,24(sp)
    80002c0a:	e822                	sd	s0,16(sp)
    80002c0c:	e426                	sd	s1,8(sp)
    80002c0e:	e04a                	sd	s2,0(sp)
    80002c10:	1000                	addi	s0,sp,32
    80002c12:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c14:	415c                	lw	a5,4(a0)
    80002c16:	0047d79b          	srliw	a5,a5,0x4
    80002c1a:	00017597          	auipc	a1,0x17
    80002c1e:	0165a583          	lw	a1,22(a1) # 80019c30 <sb+0x18>
    80002c22:	9dbd                	addw	a1,a1,a5
    80002c24:	4108                	lw	a0,0(a0)
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	89e080e7          	jalr	-1890(ra) # 800024c4 <bread>
    80002c2e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c30:	05850793          	addi	a5,a0,88
    80002c34:	40d8                	lw	a4,4(s1)
    80002c36:	8b3d                	andi	a4,a4,15
    80002c38:	071a                	slli	a4,a4,0x6
    80002c3a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c3c:	04449703          	lh	a4,68(s1)
    80002c40:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c44:	04649703          	lh	a4,70(s1)
    80002c48:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c4c:	04849703          	lh	a4,72(s1)
    80002c50:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c54:	04a49703          	lh	a4,74(s1)
    80002c58:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c5c:	44f8                	lw	a4,76(s1)
    80002c5e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c60:	03400613          	li	a2,52
    80002c64:	05048593          	addi	a1,s1,80
    80002c68:	00c78513          	addi	a0,a5,12
    80002c6c:	ffffd097          	auipc	ra,0xffffd
    80002c70:	5bc080e7          	jalr	1468(ra) # 80000228 <memmove>
  log_write(bp);
    80002c74:	854a                	mv	a0,s2
    80002c76:	00001097          	auipc	ra,0x1
    80002c7a:	c24080e7          	jalr	-988(ra) # 8000389a <log_write>
  brelse(bp);
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	974080e7          	jalr	-1676(ra) # 800025f4 <brelse>
}
    80002c88:	60e2                	ld	ra,24(sp)
    80002c8a:	6442                	ld	s0,16(sp)
    80002c8c:	64a2                	ld	s1,8(sp)
    80002c8e:	6902                	ld	s2,0(sp)
    80002c90:	6105                	addi	sp,sp,32
    80002c92:	8082                	ret

0000000080002c94 <idup>:
{
    80002c94:	1101                	addi	sp,sp,-32
    80002c96:	ec06                	sd	ra,24(sp)
    80002c98:	e822                	sd	s0,16(sp)
    80002c9a:	e426                	sd	s1,8(sp)
    80002c9c:	1000                	addi	s0,sp,32
    80002c9e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca0:	00017517          	auipc	a0,0x17
    80002ca4:	f9850513          	addi	a0,a0,-104 # 80019c38 <itable>
    80002ca8:	00004097          	auipc	ra,0x4
    80002cac:	834080e7          	jalr	-1996(ra) # 800064dc <acquire>
  ip->ref++;
    80002cb0:	449c                	lw	a5,8(s1)
    80002cb2:	2785                	addiw	a5,a5,1
    80002cb4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cb6:	00017517          	auipc	a0,0x17
    80002cba:	f8250513          	addi	a0,a0,-126 # 80019c38 <itable>
    80002cbe:	00004097          	auipc	ra,0x4
    80002cc2:	8ce080e7          	jalr	-1842(ra) # 8000658c <release>
}
    80002cc6:	8526                	mv	a0,s1
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6105                	addi	sp,sp,32
    80002cd0:	8082                	ret

0000000080002cd2 <ilock>:
{
    80002cd2:	1101                	addi	sp,sp,-32
    80002cd4:	ec06                	sd	ra,24(sp)
    80002cd6:	e822                	sd	s0,16(sp)
    80002cd8:	e426                	sd	s1,8(sp)
    80002cda:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cdc:	c10d                	beqz	a0,80002cfe <ilock+0x2c>
    80002cde:	84aa                	mv	s1,a0
    80002ce0:	451c                	lw	a5,8(a0)
    80002ce2:	00f05e63          	blez	a5,80002cfe <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002ce6:	0541                	addi	a0,a0,16
    80002ce8:	00001097          	auipc	ra,0x1
    80002cec:	cd0080e7          	jalr	-816(ra) # 800039b8 <acquiresleep>
  if(ip->valid == 0){
    80002cf0:	40bc                	lw	a5,64(s1)
    80002cf2:	cf99                	beqz	a5,80002d10 <ilock+0x3e>
}
    80002cf4:	60e2                	ld	ra,24(sp)
    80002cf6:	6442                	ld	s0,16(sp)
    80002cf8:	64a2                	ld	s1,8(sp)
    80002cfa:	6105                	addi	sp,sp,32
    80002cfc:	8082                	ret
    80002cfe:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d00:	00006517          	auipc	a0,0x6
    80002d04:	86850513          	addi	a0,a0,-1944 # 80008568 <etext+0x568>
    80002d08:	00003097          	auipc	ra,0x3
    80002d0c:	456080e7          	jalr	1110(ra) # 8000615e <panic>
    80002d10:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d12:	40dc                	lw	a5,4(s1)
    80002d14:	0047d79b          	srliw	a5,a5,0x4
    80002d18:	00017597          	auipc	a1,0x17
    80002d1c:	f185a583          	lw	a1,-232(a1) # 80019c30 <sb+0x18>
    80002d20:	9dbd                	addw	a1,a1,a5
    80002d22:	4088                	lw	a0,0(s1)
    80002d24:	fffff097          	auipc	ra,0xfffff
    80002d28:	7a0080e7          	jalr	1952(ra) # 800024c4 <bread>
    80002d2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d2e:	05850593          	addi	a1,a0,88
    80002d32:	40dc                	lw	a5,4(s1)
    80002d34:	8bbd                	andi	a5,a5,15
    80002d36:	079a                	slli	a5,a5,0x6
    80002d38:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d3a:	00059783          	lh	a5,0(a1)
    80002d3e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d42:	00259783          	lh	a5,2(a1)
    80002d46:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d4a:	00459783          	lh	a5,4(a1)
    80002d4e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d52:	00659783          	lh	a5,6(a1)
    80002d56:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d5a:	459c                	lw	a5,8(a1)
    80002d5c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d5e:	03400613          	li	a2,52
    80002d62:	05b1                	addi	a1,a1,12
    80002d64:	05048513          	addi	a0,s1,80
    80002d68:	ffffd097          	auipc	ra,0xffffd
    80002d6c:	4c0080e7          	jalr	1216(ra) # 80000228 <memmove>
    brelse(bp);
    80002d70:	854a                	mv	a0,s2
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	882080e7          	jalr	-1918(ra) # 800025f4 <brelse>
    ip->valid = 1;
    80002d7a:	4785                	li	a5,1
    80002d7c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d7e:	04449783          	lh	a5,68(s1)
    80002d82:	c399                	beqz	a5,80002d88 <ilock+0xb6>
    80002d84:	6902                	ld	s2,0(sp)
    80002d86:	b7bd                	j	80002cf4 <ilock+0x22>
      panic("ilock: no type");
    80002d88:	00005517          	auipc	a0,0x5
    80002d8c:	7e850513          	addi	a0,a0,2024 # 80008570 <etext+0x570>
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	3ce080e7          	jalr	974(ra) # 8000615e <panic>

0000000080002d98 <iunlock>:
{
    80002d98:	1101                	addi	sp,sp,-32
    80002d9a:	ec06                	sd	ra,24(sp)
    80002d9c:	e822                	sd	s0,16(sp)
    80002d9e:	e426                	sd	s1,8(sp)
    80002da0:	e04a                	sd	s2,0(sp)
    80002da2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002da4:	c905                	beqz	a0,80002dd4 <iunlock+0x3c>
    80002da6:	84aa                	mv	s1,a0
    80002da8:	01050913          	addi	s2,a0,16
    80002dac:	854a                	mv	a0,s2
    80002dae:	00001097          	auipc	ra,0x1
    80002db2:	ca4080e7          	jalr	-860(ra) # 80003a52 <holdingsleep>
    80002db6:	cd19                	beqz	a0,80002dd4 <iunlock+0x3c>
    80002db8:	449c                	lw	a5,8(s1)
    80002dba:	00f05d63          	blez	a5,80002dd4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dbe:	854a                	mv	a0,s2
    80002dc0:	00001097          	auipc	ra,0x1
    80002dc4:	c4e080e7          	jalr	-946(ra) # 80003a0e <releasesleep>
}
    80002dc8:	60e2                	ld	ra,24(sp)
    80002dca:	6442                	ld	s0,16(sp)
    80002dcc:	64a2                	ld	s1,8(sp)
    80002dce:	6902                	ld	s2,0(sp)
    80002dd0:	6105                	addi	sp,sp,32
    80002dd2:	8082                	ret
    panic("iunlock");
    80002dd4:	00005517          	auipc	a0,0x5
    80002dd8:	7ac50513          	addi	a0,a0,1964 # 80008580 <etext+0x580>
    80002ddc:	00003097          	auipc	ra,0x3
    80002de0:	382080e7          	jalr	898(ra) # 8000615e <panic>

0000000080002de4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002de4:	7179                	addi	sp,sp,-48
    80002de6:	f406                	sd	ra,40(sp)
    80002de8:	f022                	sd	s0,32(sp)
    80002dea:	ec26                	sd	s1,24(sp)
    80002dec:	e84a                	sd	s2,16(sp)
    80002dee:	e44e                	sd	s3,8(sp)
    80002df0:	1800                	addi	s0,sp,48
    80002df2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002df4:	05050493          	addi	s1,a0,80
    80002df8:	08050913          	addi	s2,a0,128
    80002dfc:	a021                	j	80002e04 <itrunc+0x20>
    80002dfe:	0491                	addi	s1,s1,4
    80002e00:	01248d63          	beq	s1,s2,80002e1a <itrunc+0x36>
    if(ip->addrs[i]){
    80002e04:	408c                	lw	a1,0(s1)
    80002e06:	dde5                	beqz	a1,80002dfe <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e08:	0009a503          	lw	a0,0(s3)
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	8f8080e7          	jalr	-1800(ra) # 80002704 <bfree>
      ip->addrs[i] = 0;
    80002e14:	0004a023          	sw	zero,0(s1)
    80002e18:	b7dd                	j	80002dfe <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e1a:	0809a583          	lw	a1,128(s3)
    80002e1e:	ed99                	bnez	a1,80002e3c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e20:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e24:	854e                	mv	a0,s3
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	de0080e7          	jalr	-544(ra) # 80002c06 <iupdate>
}
    80002e2e:	70a2                	ld	ra,40(sp)
    80002e30:	7402                	ld	s0,32(sp)
    80002e32:	64e2                	ld	s1,24(sp)
    80002e34:	6942                	ld	s2,16(sp)
    80002e36:	69a2                	ld	s3,8(sp)
    80002e38:	6145                	addi	sp,sp,48
    80002e3a:	8082                	ret
    80002e3c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e3e:	0009a503          	lw	a0,0(s3)
    80002e42:	fffff097          	auipc	ra,0xfffff
    80002e46:	682080e7          	jalr	1666(ra) # 800024c4 <bread>
    80002e4a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e4c:	05850493          	addi	s1,a0,88
    80002e50:	45850913          	addi	s2,a0,1112
    80002e54:	a021                	j	80002e5c <itrunc+0x78>
    80002e56:	0491                	addi	s1,s1,4
    80002e58:	01248b63          	beq	s1,s2,80002e6e <itrunc+0x8a>
      if(a[j])
    80002e5c:	408c                	lw	a1,0(s1)
    80002e5e:	dde5                	beqz	a1,80002e56 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e60:	0009a503          	lw	a0,0(s3)
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	8a0080e7          	jalr	-1888(ra) # 80002704 <bfree>
    80002e6c:	b7ed                	j	80002e56 <itrunc+0x72>
    brelse(bp);
    80002e6e:	8552                	mv	a0,s4
    80002e70:	fffff097          	auipc	ra,0xfffff
    80002e74:	784080e7          	jalr	1924(ra) # 800025f4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e78:	0809a583          	lw	a1,128(s3)
    80002e7c:	0009a503          	lw	a0,0(s3)
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	884080e7          	jalr	-1916(ra) # 80002704 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e88:	0809a023          	sw	zero,128(s3)
    80002e8c:	6a02                	ld	s4,0(sp)
    80002e8e:	bf49                	j	80002e20 <itrunc+0x3c>

0000000080002e90 <iput>:
{
    80002e90:	1101                	addi	sp,sp,-32
    80002e92:	ec06                	sd	ra,24(sp)
    80002e94:	e822                	sd	s0,16(sp)
    80002e96:	e426                	sd	s1,8(sp)
    80002e98:	1000                	addi	s0,sp,32
    80002e9a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e9c:	00017517          	auipc	a0,0x17
    80002ea0:	d9c50513          	addi	a0,a0,-612 # 80019c38 <itable>
    80002ea4:	00003097          	auipc	ra,0x3
    80002ea8:	638080e7          	jalr	1592(ra) # 800064dc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eac:	4498                	lw	a4,8(s1)
    80002eae:	4785                	li	a5,1
    80002eb0:	02f70263          	beq	a4,a5,80002ed4 <iput+0x44>
  ip->ref--;
    80002eb4:	449c                	lw	a5,8(s1)
    80002eb6:	37fd                	addiw	a5,a5,-1
    80002eb8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eba:	00017517          	auipc	a0,0x17
    80002ebe:	d7e50513          	addi	a0,a0,-642 # 80019c38 <itable>
    80002ec2:	00003097          	auipc	ra,0x3
    80002ec6:	6ca080e7          	jalr	1738(ra) # 8000658c <release>
}
    80002eca:	60e2                	ld	ra,24(sp)
    80002ecc:	6442                	ld	s0,16(sp)
    80002ece:	64a2                	ld	s1,8(sp)
    80002ed0:	6105                	addi	sp,sp,32
    80002ed2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ed4:	40bc                	lw	a5,64(s1)
    80002ed6:	dff9                	beqz	a5,80002eb4 <iput+0x24>
    80002ed8:	04a49783          	lh	a5,74(s1)
    80002edc:	ffe1                	bnez	a5,80002eb4 <iput+0x24>
    80002ede:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002ee0:	01048913          	addi	s2,s1,16
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	00001097          	auipc	ra,0x1
    80002eea:	ad2080e7          	jalr	-1326(ra) # 800039b8 <acquiresleep>
    release(&itable.lock);
    80002eee:	00017517          	auipc	a0,0x17
    80002ef2:	d4a50513          	addi	a0,a0,-694 # 80019c38 <itable>
    80002ef6:	00003097          	auipc	ra,0x3
    80002efa:	696080e7          	jalr	1686(ra) # 8000658c <release>
    itrunc(ip);
    80002efe:	8526                	mv	a0,s1
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	ee4080e7          	jalr	-284(ra) # 80002de4 <itrunc>
    ip->type = 0;
    80002f08:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	cf8080e7          	jalr	-776(ra) # 80002c06 <iupdate>
    ip->valid = 0;
    80002f16:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	00001097          	auipc	ra,0x1
    80002f20:	af2080e7          	jalr	-1294(ra) # 80003a0e <releasesleep>
    acquire(&itable.lock);
    80002f24:	00017517          	auipc	a0,0x17
    80002f28:	d1450513          	addi	a0,a0,-748 # 80019c38 <itable>
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	5b0080e7          	jalr	1456(ra) # 800064dc <acquire>
    80002f34:	6902                	ld	s2,0(sp)
    80002f36:	bfbd                	j	80002eb4 <iput+0x24>

0000000080002f38 <iunlockput>:
{
    80002f38:	1101                	addi	sp,sp,-32
    80002f3a:	ec06                	sd	ra,24(sp)
    80002f3c:	e822                	sd	s0,16(sp)
    80002f3e:	e426                	sd	s1,8(sp)
    80002f40:	1000                	addi	s0,sp,32
    80002f42:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f44:	00000097          	auipc	ra,0x0
    80002f48:	e54080e7          	jalr	-428(ra) # 80002d98 <iunlock>
  iput(ip);
    80002f4c:	8526                	mv	a0,s1
    80002f4e:	00000097          	auipc	ra,0x0
    80002f52:	f42080e7          	jalr	-190(ra) # 80002e90 <iput>
}
    80002f56:	60e2                	ld	ra,24(sp)
    80002f58:	6442                	ld	s0,16(sp)
    80002f5a:	64a2                	ld	s1,8(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret

0000000080002f60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f60:	1141                	addi	sp,sp,-16
    80002f62:	e406                	sd	ra,8(sp)
    80002f64:	e022                	sd	s0,0(sp)
    80002f66:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f68:	411c                	lw	a5,0(a0)
    80002f6a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f6c:	415c                	lw	a5,4(a0)
    80002f6e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f70:	04451783          	lh	a5,68(a0)
    80002f74:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f78:	04a51783          	lh	a5,74(a0)
    80002f7c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f80:	04c56783          	lwu	a5,76(a0)
    80002f84:	e99c                	sd	a5,16(a1)
}
    80002f86:	60a2                	ld	ra,8(sp)
    80002f88:	6402                	ld	s0,0(sp)
    80002f8a:	0141                	addi	sp,sp,16
    80002f8c:	8082                	ret

0000000080002f8e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f8e:	457c                	lw	a5,76(a0)
    80002f90:	10d7e063          	bltu	a5,a3,80003090 <readi+0x102>
{
    80002f94:	7159                	addi	sp,sp,-112
    80002f96:	f486                	sd	ra,104(sp)
    80002f98:	f0a2                	sd	s0,96(sp)
    80002f9a:	eca6                	sd	s1,88(sp)
    80002f9c:	e0d2                	sd	s4,64(sp)
    80002f9e:	fc56                	sd	s5,56(sp)
    80002fa0:	f85a                	sd	s6,48(sp)
    80002fa2:	f45e                	sd	s7,40(sp)
    80002fa4:	1880                	addi	s0,sp,112
    80002fa6:	8b2a                	mv	s6,a0
    80002fa8:	8bae                	mv	s7,a1
    80002faa:	8a32                	mv	s4,a2
    80002fac:	84b6                	mv	s1,a3
    80002fae:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002fb0:	9f35                	addw	a4,a4,a3
    return 0;
    80002fb2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fb4:	0cd76563          	bltu	a4,a3,8000307e <readi+0xf0>
    80002fb8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002fba:	00e7f463          	bgeu	a5,a4,80002fc2 <readi+0x34>
    n = ip->size - off;
    80002fbe:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc2:	0a0a8563          	beqz	s5,8000306c <readi+0xde>
    80002fc6:	e8ca                	sd	s2,80(sp)
    80002fc8:	f062                	sd	s8,32(sp)
    80002fca:	ec66                	sd	s9,24(sp)
    80002fcc:	e86a                	sd	s10,16(sp)
    80002fce:	e46e                	sd	s11,8(sp)
    80002fd0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fd6:	5c7d                	li	s8,-1
    80002fd8:	a82d                	j	80003012 <readi+0x84>
    80002fda:	020d1d93          	slli	s11,s10,0x20
    80002fde:	020ddd93          	srli	s11,s11,0x20
    80002fe2:	05890613          	addi	a2,s2,88
    80002fe6:	86ee                	mv	a3,s11
    80002fe8:	963e                	add	a2,a2,a5
    80002fea:	85d2                	mv	a1,s4
    80002fec:	855e                	mv	a0,s7
    80002fee:	fffff097          	auipc	ra,0xfffff
    80002ff2:	a68080e7          	jalr	-1432(ra) # 80001a56 <either_copyout>
    80002ff6:	05850963          	beq	a0,s8,80003048 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	5f8080e7          	jalr	1528(ra) # 800025f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003004:	013d09bb          	addw	s3,s10,s3
    80003008:	009d04bb          	addw	s1,s10,s1
    8000300c:	9a6e                	add	s4,s4,s11
    8000300e:	0559f963          	bgeu	s3,s5,80003060 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80003012:	00a4d59b          	srliw	a1,s1,0xa
    80003016:	855a                	mv	a0,s6
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	89e080e7          	jalr	-1890(ra) # 800028b6 <bmap>
    80003020:	85aa                	mv	a1,a0
    if(addr == 0)
    80003022:	c539                	beqz	a0,80003070 <readi+0xe2>
    bp = bread(ip->dev, addr);
    80003024:	000b2503          	lw	a0,0(s6)
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	49c080e7          	jalr	1180(ra) # 800024c4 <bread>
    80003030:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003032:	3ff4f793          	andi	a5,s1,1023
    80003036:	40fc873b          	subw	a4,s9,a5
    8000303a:	413a86bb          	subw	a3,s5,s3
    8000303e:	8d3a                	mv	s10,a4
    80003040:	f8e6fde3          	bgeu	a3,a4,80002fda <readi+0x4c>
    80003044:	8d36                	mv	s10,a3
    80003046:	bf51                	j	80002fda <readi+0x4c>
      brelse(bp);
    80003048:	854a                	mv	a0,s2
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	5aa080e7          	jalr	1450(ra) # 800025f4 <brelse>
      tot = -1;
    80003052:	59fd                	li	s3,-1
      break;
    80003054:	6946                	ld	s2,80(sp)
    80003056:	7c02                	ld	s8,32(sp)
    80003058:	6ce2                	ld	s9,24(sp)
    8000305a:	6d42                	ld	s10,16(sp)
    8000305c:	6da2                	ld	s11,8(sp)
    8000305e:	a831                	j	8000307a <readi+0xec>
    80003060:	6946                	ld	s2,80(sp)
    80003062:	7c02                	ld	s8,32(sp)
    80003064:	6ce2                	ld	s9,24(sp)
    80003066:	6d42                	ld	s10,16(sp)
    80003068:	6da2                	ld	s11,8(sp)
    8000306a:	a801                	j	8000307a <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000306c:	89d6                	mv	s3,s5
    8000306e:	a031                	j	8000307a <readi+0xec>
    80003070:	6946                	ld	s2,80(sp)
    80003072:	7c02                	ld	s8,32(sp)
    80003074:	6ce2                	ld	s9,24(sp)
    80003076:	6d42                	ld	s10,16(sp)
    80003078:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000307a:	854e                	mv	a0,s3
    8000307c:	69a6                	ld	s3,72(sp)
}
    8000307e:	70a6                	ld	ra,104(sp)
    80003080:	7406                	ld	s0,96(sp)
    80003082:	64e6                	ld	s1,88(sp)
    80003084:	6a06                	ld	s4,64(sp)
    80003086:	7ae2                	ld	s5,56(sp)
    80003088:	7b42                	ld	s6,48(sp)
    8000308a:	7ba2                	ld	s7,40(sp)
    8000308c:	6165                	addi	sp,sp,112
    8000308e:	8082                	ret
    return 0;
    80003090:	4501                	li	a0,0
}
    80003092:	8082                	ret

0000000080003094 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003094:	457c                	lw	a5,76(a0)
    80003096:	10d7e963          	bltu	a5,a3,800031a8 <writei+0x114>
{
    8000309a:	7159                	addi	sp,sp,-112
    8000309c:	f486                	sd	ra,104(sp)
    8000309e:	f0a2                	sd	s0,96(sp)
    800030a0:	e8ca                	sd	s2,80(sp)
    800030a2:	e0d2                	sd	s4,64(sp)
    800030a4:	fc56                	sd	s5,56(sp)
    800030a6:	f85a                	sd	s6,48(sp)
    800030a8:	f45e                	sd	s7,40(sp)
    800030aa:	1880                	addi	s0,sp,112
    800030ac:	8aaa                	mv	s5,a0
    800030ae:	8bae                	mv	s7,a1
    800030b0:	8a32                	mv	s4,a2
    800030b2:	8936                	mv	s2,a3
    800030b4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030b6:	00e687bb          	addw	a5,a3,a4
    800030ba:	0ed7e963          	bltu	a5,a3,800031ac <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030be:	00043737          	lui	a4,0x43
    800030c2:	0ef76763          	bltu	a4,a5,800031b0 <writei+0x11c>
    800030c6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c8:	0c0b0863          	beqz	s6,80003198 <writei+0x104>
    800030cc:	eca6                	sd	s1,88(sp)
    800030ce:	f062                	sd	s8,32(sp)
    800030d0:	ec66                	sd	s9,24(sp)
    800030d2:	e86a                	sd	s10,16(sp)
    800030d4:	e46e                	sd	s11,8(sp)
    800030d6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030dc:	5c7d                	li	s8,-1
    800030de:	a091                	j	80003122 <writei+0x8e>
    800030e0:	020d1d93          	slli	s11,s10,0x20
    800030e4:	020ddd93          	srli	s11,s11,0x20
    800030e8:	05848513          	addi	a0,s1,88
    800030ec:	86ee                	mv	a3,s11
    800030ee:	8652                	mv	a2,s4
    800030f0:	85de                	mv	a1,s7
    800030f2:	953e                	add	a0,a0,a5
    800030f4:	fffff097          	auipc	ra,0xfffff
    800030f8:	9b8080e7          	jalr	-1608(ra) # 80001aac <either_copyin>
    800030fc:	05850e63          	beq	a0,s8,80003158 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003100:	8526                	mv	a0,s1
    80003102:	00000097          	auipc	ra,0x0
    80003106:	798080e7          	jalr	1944(ra) # 8000389a <log_write>
    brelse(bp);
    8000310a:	8526                	mv	a0,s1
    8000310c:	fffff097          	auipc	ra,0xfffff
    80003110:	4e8080e7          	jalr	1256(ra) # 800025f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003114:	013d09bb          	addw	s3,s10,s3
    80003118:	012d093b          	addw	s2,s10,s2
    8000311c:	9a6e                	add	s4,s4,s11
    8000311e:	0569f263          	bgeu	s3,s6,80003162 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003122:	00a9559b          	srliw	a1,s2,0xa
    80003126:	8556                	mv	a0,s5
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	78e080e7          	jalr	1934(ra) # 800028b6 <bmap>
    80003130:	85aa                	mv	a1,a0
    if(addr == 0)
    80003132:	c905                	beqz	a0,80003162 <writei+0xce>
    bp = bread(ip->dev, addr);
    80003134:	000aa503          	lw	a0,0(s5)
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	38c080e7          	jalr	908(ra) # 800024c4 <bread>
    80003140:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003142:	3ff97793          	andi	a5,s2,1023
    80003146:	40fc873b          	subw	a4,s9,a5
    8000314a:	413b06bb          	subw	a3,s6,s3
    8000314e:	8d3a                	mv	s10,a4
    80003150:	f8e6f8e3          	bgeu	a3,a4,800030e0 <writei+0x4c>
    80003154:	8d36                	mv	s10,a3
    80003156:	b769                	j	800030e0 <writei+0x4c>
      brelse(bp);
    80003158:	8526                	mv	a0,s1
    8000315a:	fffff097          	auipc	ra,0xfffff
    8000315e:	49a080e7          	jalr	1178(ra) # 800025f4 <brelse>
  }

  if(off > ip->size)
    80003162:	04caa783          	lw	a5,76(s5)
    80003166:	0327fb63          	bgeu	a5,s2,8000319c <writei+0x108>
    ip->size = off;
    8000316a:	052aa623          	sw	s2,76(s5)
    8000316e:	64e6                	ld	s1,88(sp)
    80003170:	7c02                	ld	s8,32(sp)
    80003172:	6ce2                	ld	s9,24(sp)
    80003174:	6d42                	ld	s10,16(sp)
    80003176:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003178:	8556                	mv	a0,s5
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	a8c080e7          	jalr	-1396(ra) # 80002c06 <iupdate>

  return tot;
    80003182:	854e                	mv	a0,s3
    80003184:	69a6                	ld	s3,72(sp)
}
    80003186:	70a6                	ld	ra,104(sp)
    80003188:	7406                	ld	s0,96(sp)
    8000318a:	6946                	ld	s2,80(sp)
    8000318c:	6a06                	ld	s4,64(sp)
    8000318e:	7ae2                	ld	s5,56(sp)
    80003190:	7b42                	ld	s6,48(sp)
    80003192:	7ba2                	ld	s7,40(sp)
    80003194:	6165                	addi	sp,sp,112
    80003196:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003198:	89da                	mv	s3,s6
    8000319a:	bff9                	j	80003178 <writei+0xe4>
    8000319c:	64e6                	ld	s1,88(sp)
    8000319e:	7c02                	ld	s8,32(sp)
    800031a0:	6ce2                	ld	s9,24(sp)
    800031a2:	6d42                	ld	s10,16(sp)
    800031a4:	6da2                	ld	s11,8(sp)
    800031a6:	bfc9                	j	80003178 <writei+0xe4>
    return -1;
    800031a8:	557d                	li	a0,-1
}
    800031aa:	8082                	ret
    return -1;
    800031ac:	557d                	li	a0,-1
    800031ae:	bfe1                	j	80003186 <writei+0xf2>
    return -1;
    800031b0:	557d                	li	a0,-1
    800031b2:	bfd1                	j	80003186 <writei+0xf2>

00000000800031b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031b4:	1141                	addi	sp,sp,-16
    800031b6:	e406                	sd	ra,8(sp)
    800031b8:	e022                	sd	s0,0(sp)
    800031ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031bc:	4639                	li	a2,14
    800031be:	ffffd097          	auipc	ra,0xffffd
    800031c2:	0e2080e7          	jalr	226(ra) # 800002a0 <strncmp>
}
    800031c6:	60a2                	ld	ra,8(sp)
    800031c8:	6402                	ld	s0,0(sp)
    800031ca:	0141                	addi	sp,sp,16
    800031cc:	8082                	ret

00000000800031ce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031ce:	711d                	addi	sp,sp,-96
    800031d0:	ec86                	sd	ra,88(sp)
    800031d2:	e8a2                	sd	s0,80(sp)
    800031d4:	e4a6                	sd	s1,72(sp)
    800031d6:	e0ca                	sd	s2,64(sp)
    800031d8:	fc4e                	sd	s3,56(sp)
    800031da:	f852                	sd	s4,48(sp)
    800031dc:	f456                	sd	s5,40(sp)
    800031de:	f05a                	sd	s6,32(sp)
    800031e0:	ec5e                	sd	s7,24(sp)
    800031e2:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031e4:	04451703          	lh	a4,68(a0)
    800031e8:	4785                	li	a5,1
    800031ea:	00f71f63          	bne	a4,a5,80003208 <dirlookup+0x3a>
    800031ee:	892a                	mv	s2,a0
    800031f0:	8aae                	mv	s5,a1
    800031f2:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f4:	457c                	lw	a5,76(a0)
    800031f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f8:	fa040a13          	addi	s4,s0,-96
    800031fc:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800031fe:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003202:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003204:	e79d                	bnez	a5,80003232 <dirlookup+0x64>
    80003206:	a88d                	j	80003278 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80003208:	00005517          	auipc	a0,0x5
    8000320c:	38050513          	addi	a0,a0,896 # 80008588 <etext+0x588>
    80003210:	00003097          	auipc	ra,0x3
    80003214:	f4e080e7          	jalr	-178(ra) # 8000615e <panic>
      panic("dirlookup read");
    80003218:	00005517          	auipc	a0,0x5
    8000321c:	38850513          	addi	a0,a0,904 # 800085a0 <etext+0x5a0>
    80003220:	00003097          	auipc	ra,0x3
    80003224:	f3e080e7          	jalr	-194(ra) # 8000615e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003228:	24c1                	addiw	s1,s1,16
    8000322a:	04c92783          	lw	a5,76(s2)
    8000322e:	04f4f463          	bgeu	s1,a5,80003276 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003232:	874e                	mv	a4,s3
    80003234:	86a6                	mv	a3,s1
    80003236:	8652                	mv	a2,s4
    80003238:	4581                	li	a1,0
    8000323a:	854a                	mv	a0,s2
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	d52080e7          	jalr	-686(ra) # 80002f8e <readi>
    80003244:	fd351ae3          	bne	a0,s3,80003218 <dirlookup+0x4a>
    if(de.inum == 0)
    80003248:	fa045783          	lhu	a5,-96(s0)
    8000324c:	dff1                	beqz	a5,80003228 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    8000324e:	85da                	mv	a1,s6
    80003250:	8556                	mv	a0,s5
    80003252:	00000097          	auipc	ra,0x0
    80003256:	f62080e7          	jalr	-158(ra) # 800031b4 <namecmp>
    8000325a:	f579                	bnez	a0,80003228 <dirlookup+0x5a>
      if(poff)
    8000325c:	000b8463          	beqz	s7,80003264 <dirlookup+0x96>
        *poff = off;
    80003260:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003264:	fa045583          	lhu	a1,-96(s0)
    80003268:	00092503          	lw	a0,0(s2)
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	726080e7          	jalr	1830(ra) # 80002992 <iget>
    80003274:	a011                	j	80003278 <dirlookup+0xaa>
  return 0;
    80003276:	4501                	li	a0,0
}
    80003278:	60e6                	ld	ra,88(sp)
    8000327a:	6446                	ld	s0,80(sp)
    8000327c:	64a6                	ld	s1,72(sp)
    8000327e:	6906                	ld	s2,64(sp)
    80003280:	79e2                	ld	s3,56(sp)
    80003282:	7a42                	ld	s4,48(sp)
    80003284:	7aa2                	ld	s5,40(sp)
    80003286:	7b02                	ld	s6,32(sp)
    80003288:	6be2                	ld	s7,24(sp)
    8000328a:	6125                	addi	sp,sp,96
    8000328c:	8082                	ret

000000008000328e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000328e:	711d                	addi	sp,sp,-96
    80003290:	ec86                	sd	ra,88(sp)
    80003292:	e8a2                	sd	s0,80(sp)
    80003294:	e4a6                	sd	s1,72(sp)
    80003296:	e0ca                	sd	s2,64(sp)
    80003298:	fc4e                	sd	s3,56(sp)
    8000329a:	f852                	sd	s4,48(sp)
    8000329c:	f456                	sd	s5,40(sp)
    8000329e:	f05a                	sd	s6,32(sp)
    800032a0:	ec5e                	sd	s7,24(sp)
    800032a2:	e862                	sd	s8,16(sp)
    800032a4:	e466                	sd	s9,8(sp)
    800032a6:	e06a                	sd	s10,0(sp)
    800032a8:	1080                	addi	s0,sp,96
    800032aa:	84aa                	mv	s1,a0
    800032ac:	8b2e                	mv	s6,a1
    800032ae:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032b0:	00054703          	lbu	a4,0(a0)
    800032b4:	02f00793          	li	a5,47
    800032b8:	02f70363          	beq	a4,a5,800032de <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	cbe080e7          	jalr	-834(ra) # 80000f7a <myproc>
    800032c4:	15053503          	ld	a0,336(a0)
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	9cc080e7          	jalr	-1588(ra) # 80002c94 <idup>
    800032d0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032d2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032d6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800032d8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032da:	4b85                	li	s7,1
    800032dc:	a87d                	j	8000339a <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800032de:	4585                	li	a1,1
    800032e0:	852e                	mv	a0,a1
    800032e2:	fffff097          	auipc	ra,0xfffff
    800032e6:	6b0080e7          	jalr	1712(ra) # 80002992 <iget>
    800032ea:	8a2a                	mv	s4,a0
    800032ec:	b7dd                	j	800032d2 <namex+0x44>
      iunlockput(ip);
    800032ee:	8552                	mv	a0,s4
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	c48080e7          	jalr	-952(ra) # 80002f38 <iunlockput>
      return 0;
    800032f8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032fa:	8552                	mv	a0,s4
    800032fc:	60e6                	ld	ra,88(sp)
    800032fe:	6446                	ld	s0,80(sp)
    80003300:	64a6                	ld	s1,72(sp)
    80003302:	6906                	ld	s2,64(sp)
    80003304:	79e2                	ld	s3,56(sp)
    80003306:	7a42                	ld	s4,48(sp)
    80003308:	7aa2                	ld	s5,40(sp)
    8000330a:	7b02                	ld	s6,32(sp)
    8000330c:	6be2                	ld	s7,24(sp)
    8000330e:	6c42                	ld	s8,16(sp)
    80003310:	6ca2                	ld	s9,8(sp)
    80003312:	6d02                	ld	s10,0(sp)
    80003314:	6125                	addi	sp,sp,96
    80003316:	8082                	ret
      iunlock(ip);
    80003318:	8552                	mv	a0,s4
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	a7e080e7          	jalr	-1410(ra) # 80002d98 <iunlock>
      return ip;
    80003322:	bfe1                	j	800032fa <namex+0x6c>
      iunlockput(ip);
    80003324:	8552                	mv	a0,s4
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	c12080e7          	jalr	-1006(ra) # 80002f38 <iunlockput>
      return 0;
    8000332e:	8a4e                	mv	s4,s3
    80003330:	b7e9                	j	800032fa <namex+0x6c>
  len = path - s;
    80003332:	40998633          	sub	a2,s3,s1
    80003336:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000333a:	09ac5863          	bge	s8,s10,800033ca <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000333e:	8666                	mv	a2,s9
    80003340:	85a6                	mv	a1,s1
    80003342:	8556                	mv	a0,s5
    80003344:	ffffd097          	auipc	ra,0xffffd
    80003348:	ee4080e7          	jalr	-284(ra) # 80000228 <memmove>
    8000334c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000334e:	0004c783          	lbu	a5,0(s1)
    80003352:	01279763          	bne	a5,s2,80003360 <namex+0xd2>
    path++;
    80003356:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003358:	0004c783          	lbu	a5,0(s1)
    8000335c:	ff278de3          	beq	a5,s2,80003356 <namex+0xc8>
    ilock(ip);
    80003360:	8552                	mv	a0,s4
    80003362:	00000097          	auipc	ra,0x0
    80003366:	970080e7          	jalr	-1680(ra) # 80002cd2 <ilock>
    if(ip->type != T_DIR){
    8000336a:	044a1783          	lh	a5,68(s4)
    8000336e:	f97790e3          	bne	a5,s7,800032ee <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003372:	000b0563          	beqz	s6,8000337c <namex+0xee>
    80003376:	0004c783          	lbu	a5,0(s1)
    8000337a:	dfd9                	beqz	a5,80003318 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000337c:	4601                	li	a2,0
    8000337e:	85d6                	mv	a1,s5
    80003380:	8552                	mv	a0,s4
    80003382:	00000097          	auipc	ra,0x0
    80003386:	e4c080e7          	jalr	-436(ra) # 800031ce <dirlookup>
    8000338a:	89aa                	mv	s3,a0
    8000338c:	dd41                	beqz	a0,80003324 <namex+0x96>
    iunlockput(ip);
    8000338e:	8552                	mv	a0,s4
    80003390:	00000097          	auipc	ra,0x0
    80003394:	ba8080e7          	jalr	-1112(ra) # 80002f38 <iunlockput>
    ip = next;
    80003398:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000339a:	0004c783          	lbu	a5,0(s1)
    8000339e:	01279763          	bne	a5,s2,800033ac <namex+0x11e>
    path++;
    800033a2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033a4:	0004c783          	lbu	a5,0(s1)
    800033a8:	ff278de3          	beq	a5,s2,800033a2 <namex+0x114>
  if(*path == 0)
    800033ac:	cb9d                	beqz	a5,800033e2 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033ae:	0004c783          	lbu	a5,0(s1)
    800033b2:	89a6                	mv	s3,s1
  len = path - s;
    800033b4:	4d01                	li	s10,0
    800033b6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800033b8:	01278963          	beq	a5,s2,800033ca <namex+0x13c>
    800033bc:	dbbd                	beqz	a5,80003332 <namex+0xa4>
    path++;
    800033be:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033c0:	0009c783          	lbu	a5,0(s3)
    800033c4:	ff279ce3          	bne	a5,s2,800033bc <namex+0x12e>
    800033c8:	b7ad                	j	80003332 <namex+0xa4>
    memmove(name, s, len);
    800033ca:	2601                	sext.w	a2,a2
    800033cc:	85a6                	mv	a1,s1
    800033ce:	8556                	mv	a0,s5
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	e58080e7          	jalr	-424(ra) # 80000228 <memmove>
    name[len] = 0;
    800033d8:	9d56                	add	s10,s10,s5
    800033da:	000d0023          	sb	zero,0(s10)
    800033de:	84ce                	mv	s1,s3
    800033e0:	b7bd                	j	8000334e <namex+0xc0>
  if(nameiparent){
    800033e2:	f00b0ce3          	beqz	s6,800032fa <namex+0x6c>
    iput(ip);
    800033e6:	8552                	mv	a0,s4
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	aa8080e7          	jalr	-1368(ra) # 80002e90 <iput>
    return 0;
    800033f0:	4a01                	li	s4,0
    800033f2:	b721                	j	800032fa <namex+0x6c>

00000000800033f4 <dirlink>:
{
    800033f4:	715d                	addi	sp,sp,-80
    800033f6:	e486                	sd	ra,72(sp)
    800033f8:	e0a2                	sd	s0,64(sp)
    800033fa:	f84a                	sd	s2,48(sp)
    800033fc:	ec56                	sd	s5,24(sp)
    800033fe:	e85a                	sd	s6,16(sp)
    80003400:	0880                	addi	s0,sp,80
    80003402:	892a                	mv	s2,a0
    80003404:	8aae                	mv	s5,a1
    80003406:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003408:	4601                	li	a2,0
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	dc4080e7          	jalr	-572(ra) # 800031ce <dirlookup>
    80003412:	e129                	bnez	a0,80003454 <dirlink+0x60>
    80003414:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003416:	04c92483          	lw	s1,76(s2)
    8000341a:	cca9                	beqz	s1,80003474 <dirlink+0x80>
    8000341c:	f44e                	sd	s3,40(sp)
    8000341e:	f052                	sd	s4,32(sp)
    80003420:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003422:	fb040a13          	addi	s4,s0,-80
    80003426:	49c1                	li	s3,16
    80003428:	874e                	mv	a4,s3
    8000342a:	86a6                	mv	a3,s1
    8000342c:	8652                	mv	a2,s4
    8000342e:	4581                	li	a1,0
    80003430:	854a                	mv	a0,s2
    80003432:	00000097          	auipc	ra,0x0
    80003436:	b5c080e7          	jalr	-1188(ra) # 80002f8e <readi>
    8000343a:	03351363          	bne	a0,s3,80003460 <dirlink+0x6c>
    if(de.inum == 0)
    8000343e:	fb045783          	lhu	a5,-80(s0)
    80003442:	c79d                	beqz	a5,80003470 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003444:	24c1                	addiw	s1,s1,16
    80003446:	04c92783          	lw	a5,76(s2)
    8000344a:	fcf4efe3          	bltu	s1,a5,80003428 <dirlink+0x34>
    8000344e:	79a2                	ld	s3,40(sp)
    80003450:	7a02                	ld	s4,32(sp)
    80003452:	a00d                	j	80003474 <dirlink+0x80>
    iput(ip);
    80003454:	00000097          	auipc	ra,0x0
    80003458:	a3c080e7          	jalr	-1476(ra) # 80002e90 <iput>
    return -1;
    8000345c:	557d                	li	a0,-1
    8000345e:	a0a9                	j	800034a8 <dirlink+0xb4>
      panic("dirlink read");
    80003460:	00005517          	auipc	a0,0x5
    80003464:	15050513          	addi	a0,a0,336 # 800085b0 <etext+0x5b0>
    80003468:	00003097          	auipc	ra,0x3
    8000346c:	cf6080e7          	jalr	-778(ra) # 8000615e <panic>
    80003470:	79a2                	ld	s3,40(sp)
    80003472:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003474:	4639                	li	a2,14
    80003476:	85d6                	mv	a1,s5
    80003478:	fb240513          	addi	a0,s0,-78
    8000347c:	ffffd097          	auipc	ra,0xffffd
    80003480:	e5e080e7          	jalr	-418(ra) # 800002da <strncpy>
  de.inum = inum;
    80003484:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003488:	4741                	li	a4,16
    8000348a:	86a6                	mv	a3,s1
    8000348c:	fb040613          	addi	a2,s0,-80
    80003490:	4581                	li	a1,0
    80003492:	854a                	mv	a0,s2
    80003494:	00000097          	auipc	ra,0x0
    80003498:	c00080e7          	jalr	-1024(ra) # 80003094 <writei>
    8000349c:	1541                	addi	a0,a0,-16
    8000349e:	00a03533          	snez	a0,a0
    800034a2:	40a0053b          	negw	a0,a0
    800034a6:	74e2                	ld	s1,56(sp)
}
    800034a8:	60a6                	ld	ra,72(sp)
    800034aa:	6406                	ld	s0,64(sp)
    800034ac:	7942                	ld	s2,48(sp)
    800034ae:	6ae2                	ld	s5,24(sp)
    800034b0:	6b42                	ld	s6,16(sp)
    800034b2:	6161                	addi	sp,sp,80
    800034b4:	8082                	ret

00000000800034b6 <namei>:

struct inode*
namei(char *path)
{
    800034b6:	1101                	addi	sp,sp,-32
    800034b8:	ec06                	sd	ra,24(sp)
    800034ba:	e822                	sd	s0,16(sp)
    800034bc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034be:	fe040613          	addi	a2,s0,-32
    800034c2:	4581                	li	a1,0
    800034c4:	00000097          	auipc	ra,0x0
    800034c8:	dca080e7          	jalr	-566(ra) # 8000328e <namex>
}
    800034cc:	60e2                	ld	ra,24(sp)
    800034ce:	6442                	ld	s0,16(sp)
    800034d0:	6105                	addi	sp,sp,32
    800034d2:	8082                	ret

00000000800034d4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034d4:	1141                	addi	sp,sp,-16
    800034d6:	e406                	sd	ra,8(sp)
    800034d8:	e022                	sd	s0,0(sp)
    800034da:	0800                	addi	s0,sp,16
    800034dc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034de:	4585                	li	a1,1
    800034e0:	00000097          	auipc	ra,0x0
    800034e4:	dae080e7          	jalr	-594(ra) # 8000328e <namex>
}
    800034e8:	60a2                	ld	ra,8(sp)
    800034ea:	6402                	ld	s0,0(sp)
    800034ec:	0141                	addi	sp,sp,16
    800034ee:	8082                	ret

00000000800034f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034f0:	1101                	addi	sp,sp,-32
    800034f2:	ec06                	sd	ra,24(sp)
    800034f4:	e822                	sd	s0,16(sp)
    800034f6:	e426                	sd	s1,8(sp)
    800034f8:	e04a                	sd	s2,0(sp)
    800034fa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034fc:	00018917          	auipc	s2,0x18
    80003500:	1e490913          	addi	s2,s2,484 # 8001b6e0 <log>
    80003504:	01892583          	lw	a1,24(s2)
    80003508:	02892503          	lw	a0,40(s2)
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	fb8080e7          	jalr	-72(ra) # 800024c4 <bread>
    80003514:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003516:	02c92603          	lw	a2,44(s2)
    8000351a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000351c:	00c05f63          	blez	a2,8000353a <write_head+0x4a>
    80003520:	00018717          	auipc	a4,0x18
    80003524:	1f070713          	addi	a4,a4,496 # 8001b710 <log+0x30>
    80003528:	87aa                	mv	a5,a0
    8000352a:	060a                	slli	a2,a2,0x2
    8000352c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000352e:	4314                	lw	a3,0(a4)
    80003530:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003532:	0711                	addi	a4,a4,4
    80003534:	0791                	addi	a5,a5,4
    80003536:	fec79ce3          	bne	a5,a2,8000352e <write_head+0x3e>
  }
  bwrite(buf);
    8000353a:	8526                	mv	a0,s1
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	07a080e7          	jalr	122(ra) # 800025b6 <bwrite>
  brelse(buf);
    80003544:	8526                	mv	a0,s1
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	0ae080e7          	jalr	174(ra) # 800025f4 <brelse>
}
    8000354e:	60e2                	ld	ra,24(sp)
    80003550:	6442                	ld	s0,16(sp)
    80003552:	64a2                	ld	s1,8(sp)
    80003554:	6902                	ld	s2,0(sp)
    80003556:	6105                	addi	sp,sp,32
    80003558:	8082                	ret

000000008000355a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000355a:	00018797          	auipc	a5,0x18
    8000355e:	1b27a783          	lw	a5,434(a5) # 8001b70c <log+0x2c>
    80003562:	0cf05063          	blez	a5,80003622 <install_trans+0xc8>
{
    80003566:	715d                	addi	sp,sp,-80
    80003568:	e486                	sd	ra,72(sp)
    8000356a:	e0a2                	sd	s0,64(sp)
    8000356c:	fc26                	sd	s1,56(sp)
    8000356e:	f84a                	sd	s2,48(sp)
    80003570:	f44e                	sd	s3,40(sp)
    80003572:	f052                	sd	s4,32(sp)
    80003574:	ec56                	sd	s5,24(sp)
    80003576:	e85a                	sd	s6,16(sp)
    80003578:	e45e                	sd	s7,8(sp)
    8000357a:	0880                	addi	s0,sp,80
    8000357c:	8b2a                	mv	s6,a0
    8000357e:	00018a97          	auipc	s5,0x18
    80003582:	192a8a93          	addi	s5,s5,402 # 8001b710 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003586:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003588:	00018997          	auipc	s3,0x18
    8000358c:	15898993          	addi	s3,s3,344 # 8001b6e0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003590:	40000b93          	li	s7,1024
    80003594:	a00d                	j	800035b6 <install_trans+0x5c>
    brelse(lbuf);
    80003596:	854a                	mv	a0,s2
    80003598:	fffff097          	auipc	ra,0xfffff
    8000359c:	05c080e7          	jalr	92(ra) # 800025f4 <brelse>
    brelse(dbuf);
    800035a0:	8526                	mv	a0,s1
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	052080e7          	jalr	82(ra) # 800025f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035aa:	2a05                	addiw	s4,s4,1
    800035ac:	0a91                	addi	s5,s5,4
    800035ae:	02c9a783          	lw	a5,44(s3)
    800035b2:	04fa5d63          	bge	s4,a5,8000360c <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035b6:	0189a583          	lw	a1,24(s3)
    800035ba:	014585bb          	addw	a1,a1,s4
    800035be:	2585                	addiw	a1,a1,1
    800035c0:	0289a503          	lw	a0,40(s3)
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	f00080e7          	jalr	-256(ra) # 800024c4 <bread>
    800035cc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035ce:	000aa583          	lw	a1,0(s5)
    800035d2:	0289a503          	lw	a0,40(s3)
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	eee080e7          	jalr	-274(ra) # 800024c4 <bread>
    800035de:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035e0:	865e                	mv	a2,s7
    800035e2:	05890593          	addi	a1,s2,88
    800035e6:	05850513          	addi	a0,a0,88
    800035ea:	ffffd097          	auipc	ra,0xffffd
    800035ee:	c3e080e7          	jalr	-962(ra) # 80000228 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035f2:	8526                	mv	a0,s1
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	fc2080e7          	jalr	-62(ra) # 800025b6 <bwrite>
    if(recovering == 0)
    800035fc:	f80b1de3          	bnez	s6,80003596 <install_trans+0x3c>
      bunpin(dbuf);
    80003600:	8526                	mv	a0,s1
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	0c6080e7          	jalr	198(ra) # 800026c8 <bunpin>
    8000360a:	b771                	j	80003596 <install_trans+0x3c>
}
    8000360c:	60a6                	ld	ra,72(sp)
    8000360e:	6406                	ld	s0,64(sp)
    80003610:	74e2                	ld	s1,56(sp)
    80003612:	7942                	ld	s2,48(sp)
    80003614:	79a2                	ld	s3,40(sp)
    80003616:	7a02                	ld	s4,32(sp)
    80003618:	6ae2                	ld	s5,24(sp)
    8000361a:	6b42                	ld	s6,16(sp)
    8000361c:	6ba2                	ld	s7,8(sp)
    8000361e:	6161                	addi	sp,sp,80
    80003620:	8082                	ret
    80003622:	8082                	ret

0000000080003624 <initlog>:
{
    80003624:	7179                	addi	sp,sp,-48
    80003626:	f406                	sd	ra,40(sp)
    80003628:	f022                	sd	s0,32(sp)
    8000362a:	ec26                	sd	s1,24(sp)
    8000362c:	e84a                	sd	s2,16(sp)
    8000362e:	e44e                	sd	s3,8(sp)
    80003630:	1800                	addi	s0,sp,48
    80003632:	892a                	mv	s2,a0
    80003634:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003636:	00018497          	auipc	s1,0x18
    8000363a:	0aa48493          	addi	s1,s1,170 # 8001b6e0 <log>
    8000363e:	00005597          	auipc	a1,0x5
    80003642:	f8258593          	addi	a1,a1,-126 # 800085c0 <etext+0x5c0>
    80003646:	8526                	mv	a0,s1
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	e00080e7          	jalr	-512(ra) # 80006448 <initlock>
  log.start = sb->logstart;
    80003650:	0149a583          	lw	a1,20(s3)
    80003654:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003656:	0109a783          	lw	a5,16(s3)
    8000365a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000365c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003660:	854a                	mv	a0,s2
    80003662:	fffff097          	auipc	ra,0xfffff
    80003666:	e62080e7          	jalr	-414(ra) # 800024c4 <bread>
  log.lh.n = lh->n;
    8000366a:	4d30                	lw	a2,88(a0)
    8000366c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000366e:	00c05f63          	blez	a2,8000368c <initlog+0x68>
    80003672:	87aa                	mv	a5,a0
    80003674:	00018717          	auipc	a4,0x18
    80003678:	09c70713          	addi	a4,a4,156 # 8001b710 <log+0x30>
    8000367c:	060a                	slli	a2,a2,0x2
    8000367e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003680:	4ff4                	lw	a3,92(a5)
    80003682:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003684:	0791                	addi	a5,a5,4
    80003686:	0711                	addi	a4,a4,4
    80003688:	fec79ce3          	bne	a5,a2,80003680 <initlog+0x5c>
  brelse(buf);
    8000368c:	fffff097          	auipc	ra,0xfffff
    80003690:	f68080e7          	jalr	-152(ra) # 800025f4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003694:	4505                	li	a0,1
    80003696:	00000097          	auipc	ra,0x0
    8000369a:	ec4080e7          	jalr	-316(ra) # 8000355a <install_trans>
  log.lh.n = 0;
    8000369e:	00018797          	auipc	a5,0x18
    800036a2:	0607a723          	sw	zero,110(a5) # 8001b70c <log+0x2c>
  write_head(); // clear the log
    800036a6:	00000097          	auipc	ra,0x0
    800036aa:	e4a080e7          	jalr	-438(ra) # 800034f0 <write_head>
}
    800036ae:	70a2                	ld	ra,40(sp)
    800036b0:	7402                	ld	s0,32(sp)
    800036b2:	64e2                	ld	s1,24(sp)
    800036b4:	6942                	ld	s2,16(sp)
    800036b6:	69a2                	ld	s3,8(sp)
    800036b8:	6145                	addi	sp,sp,48
    800036ba:	8082                	ret

00000000800036bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036bc:	1101                	addi	sp,sp,-32
    800036be:	ec06                	sd	ra,24(sp)
    800036c0:	e822                	sd	s0,16(sp)
    800036c2:	e426                	sd	s1,8(sp)
    800036c4:	e04a                	sd	s2,0(sp)
    800036c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036c8:	00018517          	auipc	a0,0x18
    800036cc:	01850513          	addi	a0,a0,24 # 8001b6e0 <log>
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	e0c080e7          	jalr	-500(ra) # 800064dc <acquire>
  while(1){
    if(log.committing){
    800036d8:	00018497          	auipc	s1,0x18
    800036dc:	00848493          	addi	s1,s1,8 # 8001b6e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036e0:	4979                	li	s2,30
    800036e2:	a039                	j	800036f0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036e4:	85a6                	mv	a1,s1
    800036e6:	8526                	mv	a0,s1
    800036e8:	ffffe097          	auipc	ra,0xffffe
    800036ec:	f6c080e7          	jalr	-148(ra) # 80001654 <sleep>
    if(log.committing){
    800036f0:	50dc                	lw	a5,36(s1)
    800036f2:	fbed                	bnez	a5,800036e4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036f4:	5098                	lw	a4,32(s1)
    800036f6:	2705                	addiw	a4,a4,1
    800036f8:	0027179b          	slliw	a5,a4,0x2
    800036fc:	9fb9                	addw	a5,a5,a4
    800036fe:	0017979b          	slliw	a5,a5,0x1
    80003702:	54d4                	lw	a3,44(s1)
    80003704:	9fb5                	addw	a5,a5,a3
    80003706:	00f95963          	bge	s2,a5,80003718 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000370a:	85a6                	mv	a1,s1
    8000370c:	8526                	mv	a0,s1
    8000370e:	ffffe097          	auipc	ra,0xffffe
    80003712:	f46080e7          	jalr	-186(ra) # 80001654 <sleep>
    80003716:	bfe9                	j	800036f0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003718:	00018517          	auipc	a0,0x18
    8000371c:	fc850513          	addi	a0,a0,-56 # 8001b6e0 <log>
    80003720:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003722:	00003097          	auipc	ra,0x3
    80003726:	e6a080e7          	jalr	-406(ra) # 8000658c <release>
      break;
    }
  }
}
    8000372a:	60e2                	ld	ra,24(sp)
    8000372c:	6442                	ld	s0,16(sp)
    8000372e:	64a2                	ld	s1,8(sp)
    80003730:	6902                	ld	s2,0(sp)
    80003732:	6105                	addi	sp,sp,32
    80003734:	8082                	ret

0000000080003736 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003736:	7139                	addi	sp,sp,-64
    80003738:	fc06                	sd	ra,56(sp)
    8000373a:	f822                	sd	s0,48(sp)
    8000373c:	f426                	sd	s1,40(sp)
    8000373e:	f04a                	sd	s2,32(sp)
    80003740:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003742:	00018497          	auipc	s1,0x18
    80003746:	f9e48493          	addi	s1,s1,-98 # 8001b6e0 <log>
    8000374a:	8526                	mv	a0,s1
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	d90080e7          	jalr	-624(ra) # 800064dc <acquire>
  log.outstanding -= 1;
    80003754:	509c                	lw	a5,32(s1)
    80003756:	37fd                	addiw	a5,a5,-1
    80003758:	893e                	mv	s2,a5
    8000375a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000375c:	50dc                	lw	a5,36(s1)
    8000375e:	e7b9                	bnez	a5,800037ac <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80003760:	06091263          	bnez	s2,800037c4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003764:	00018497          	auipc	s1,0x18
    80003768:	f7c48493          	addi	s1,s1,-132 # 8001b6e0 <log>
    8000376c:	4785                	li	a5,1
    8000376e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003770:	8526                	mv	a0,s1
    80003772:	00003097          	auipc	ra,0x3
    80003776:	e1a080e7          	jalr	-486(ra) # 8000658c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000377a:	54dc                	lw	a5,44(s1)
    8000377c:	06f04863          	bgtz	a5,800037ec <end_op+0xb6>
    acquire(&log.lock);
    80003780:	00018497          	auipc	s1,0x18
    80003784:	f6048493          	addi	s1,s1,-160 # 8001b6e0 <log>
    80003788:	8526                	mv	a0,s1
    8000378a:	00003097          	auipc	ra,0x3
    8000378e:	d52080e7          	jalr	-686(ra) # 800064dc <acquire>
    log.committing = 0;
    80003792:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003796:	8526                	mv	a0,s1
    80003798:	ffffe097          	auipc	ra,0xffffe
    8000379c:	f20080e7          	jalr	-224(ra) # 800016b8 <wakeup>
    release(&log.lock);
    800037a0:	8526                	mv	a0,s1
    800037a2:	00003097          	auipc	ra,0x3
    800037a6:	dea080e7          	jalr	-534(ra) # 8000658c <release>
}
    800037aa:	a81d                	j	800037e0 <end_op+0xaa>
    800037ac:	ec4e                	sd	s3,24(sp)
    800037ae:	e852                	sd	s4,16(sp)
    800037b0:	e456                	sd	s5,8(sp)
    800037b2:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800037b4:	00005517          	auipc	a0,0x5
    800037b8:	e1450513          	addi	a0,a0,-492 # 800085c8 <etext+0x5c8>
    800037bc:	00003097          	auipc	ra,0x3
    800037c0:	9a2080e7          	jalr	-1630(ra) # 8000615e <panic>
    wakeup(&log);
    800037c4:	00018497          	auipc	s1,0x18
    800037c8:	f1c48493          	addi	s1,s1,-228 # 8001b6e0 <log>
    800037cc:	8526                	mv	a0,s1
    800037ce:	ffffe097          	auipc	ra,0xffffe
    800037d2:	eea080e7          	jalr	-278(ra) # 800016b8 <wakeup>
  release(&log.lock);
    800037d6:	8526                	mv	a0,s1
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	db4080e7          	jalr	-588(ra) # 8000658c <release>
}
    800037e0:	70e2                	ld	ra,56(sp)
    800037e2:	7442                	ld	s0,48(sp)
    800037e4:	74a2                	ld	s1,40(sp)
    800037e6:	7902                	ld	s2,32(sp)
    800037e8:	6121                	addi	sp,sp,64
    800037ea:	8082                	ret
    800037ec:	ec4e                	sd	s3,24(sp)
    800037ee:	e852                	sd	s4,16(sp)
    800037f0:	e456                	sd	s5,8(sp)
    800037f2:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f4:	00018a97          	auipc	s5,0x18
    800037f8:	f1ca8a93          	addi	s5,s5,-228 # 8001b710 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037fc:	00018a17          	auipc	s4,0x18
    80003800:	ee4a0a13          	addi	s4,s4,-284 # 8001b6e0 <log>
    memmove(to->data, from->data, BSIZE);
    80003804:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003808:	018a2583          	lw	a1,24(s4)
    8000380c:	012585bb          	addw	a1,a1,s2
    80003810:	2585                	addiw	a1,a1,1
    80003812:	028a2503          	lw	a0,40(s4)
    80003816:	fffff097          	auipc	ra,0xfffff
    8000381a:	cae080e7          	jalr	-850(ra) # 800024c4 <bread>
    8000381e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003820:	000aa583          	lw	a1,0(s5)
    80003824:	028a2503          	lw	a0,40(s4)
    80003828:	fffff097          	auipc	ra,0xfffff
    8000382c:	c9c080e7          	jalr	-868(ra) # 800024c4 <bread>
    80003830:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003832:	865a                	mv	a2,s6
    80003834:	05850593          	addi	a1,a0,88
    80003838:	05848513          	addi	a0,s1,88
    8000383c:	ffffd097          	auipc	ra,0xffffd
    80003840:	9ec080e7          	jalr	-1556(ra) # 80000228 <memmove>
    bwrite(to);  // write the log
    80003844:	8526                	mv	a0,s1
    80003846:	fffff097          	auipc	ra,0xfffff
    8000384a:	d70080e7          	jalr	-656(ra) # 800025b6 <bwrite>
    brelse(from);
    8000384e:	854e                	mv	a0,s3
    80003850:	fffff097          	auipc	ra,0xfffff
    80003854:	da4080e7          	jalr	-604(ra) # 800025f4 <brelse>
    brelse(to);
    80003858:	8526                	mv	a0,s1
    8000385a:	fffff097          	auipc	ra,0xfffff
    8000385e:	d9a080e7          	jalr	-614(ra) # 800025f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003862:	2905                	addiw	s2,s2,1
    80003864:	0a91                	addi	s5,s5,4
    80003866:	02ca2783          	lw	a5,44(s4)
    8000386a:	f8f94fe3          	blt	s2,a5,80003808 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000386e:	00000097          	auipc	ra,0x0
    80003872:	c82080e7          	jalr	-894(ra) # 800034f0 <write_head>
    install_trans(0); // Now install writes to home locations
    80003876:	4501                	li	a0,0
    80003878:	00000097          	auipc	ra,0x0
    8000387c:	ce2080e7          	jalr	-798(ra) # 8000355a <install_trans>
    log.lh.n = 0;
    80003880:	00018797          	auipc	a5,0x18
    80003884:	e807a623          	sw	zero,-372(a5) # 8001b70c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003888:	00000097          	auipc	ra,0x0
    8000388c:	c68080e7          	jalr	-920(ra) # 800034f0 <write_head>
    80003890:	69e2                	ld	s3,24(sp)
    80003892:	6a42                	ld	s4,16(sp)
    80003894:	6aa2                	ld	s5,8(sp)
    80003896:	6b02                	ld	s6,0(sp)
    80003898:	b5e5                	j	80003780 <end_op+0x4a>

000000008000389a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000389a:	1101                	addi	sp,sp,-32
    8000389c:	ec06                	sd	ra,24(sp)
    8000389e:	e822                	sd	s0,16(sp)
    800038a0:	e426                	sd	s1,8(sp)
    800038a2:	e04a                	sd	s2,0(sp)
    800038a4:	1000                	addi	s0,sp,32
    800038a6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038a8:	00018917          	auipc	s2,0x18
    800038ac:	e3890913          	addi	s2,s2,-456 # 8001b6e0 <log>
    800038b0:	854a                	mv	a0,s2
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	c2a080e7          	jalr	-982(ra) # 800064dc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038ba:	02c92603          	lw	a2,44(s2)
    800038be:	47f5                	li	a5,29
    800038c0:	06c7c563          	blt	a5,a2,8000392a <log_write+0x90>
    800038c4:	00018797          	auipc	a5,0x18
    800038c8:	e387a783          	lw	a5,-456(a5) # 8001b6fc <log+0x1c>
    800038cc:	37fd                	addiw	a5,a5,-1
    800038ce:	04f65e63          	bge	a2,a5,8000392a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038d2:	00018797          	auipc	a5,0x18
    800038d6:	e2e7a783          	lw	a5,-466(a5) # 8001b700 <log+0x20>
    800038da:	06f05063          	blez	a5,8000393a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038de:	4781                	li	a5,0
    800038e0:	06c05563          	blez	a2,8000394a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038e4:	44cc                	lw	a1,12(s1)
    800038e6:	00018717          	auipc	a4,0x18
    800038ea:	e2a70713          	addi	a4,a4,-470 # 8001b710 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038ee:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f0:	4314                	lw	a3,0(a4)
    800038f2:	04b68c63          	beq	a3,a1,8000394a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038f6:	2785                	addiw	a5,a5,1
    800038f8:	0711                	addi	a4,a4,4
    800038fa:	fef61be3          	bne	a2,a5,800038f0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038fe:	0621                	addi	a2,a2,8
    80003900:	060a                	slli	a2,a2,0x2
    80003902:	00018797          	auipc	a5,0x18
    80003906:	dde78793          	addi	a5,a5,-546 # 8001b6e0 <log>
    8000390a:	97b2                	add	a5,a5,a2
    8000390c:	44d8                	lw	a4,12(s1)
    8000390e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003910:	8526                	mv	a0,s1
    80003912:	fffff097          	auipc	ra,0xfffff
    80003916:	d7a080e7          	jalr	-646(ra) # 8000268c <bpin>
    log.lh.n++;
    8000391a:	00018717          	auipc	a4,0x18
    8000391e:	dc670713          	addi	a4,a4,-570 # 8001b6e0 <log>
    80003922:	575c                	lw	a5,44(a4)
    80003924:	2785                	addiw	a5,a5,1
    80003926:	d75c                	sw	a5,44(a4)
    80003928:	a82d                	j	80003962 <log_write+0xc8>
    panic("too big a transaction");
    8000392a:	00005517          	auipc	a0,0x5
    8000392e:	cae50513          	addi	a0,a0,-850 # 800085d8 <etext+0x5d8>
    80003932:	00003097          	auipc	ra,0x3
    80003936:	82c080e7          	jalr	-2004(ra) # 8000615e <panic>
    panic("log_write outside of trans");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	cb650513          	addi	a0,a0,-842 # 800085f0 <etext+0x5f0>
    80003942:	00003097          	auipc	ra,0x3
    80003946:	81c080e7          	jalr	-2020(ra) # 8000615e <panic>
  log.lh.block[i] = b->blockno;
    8000394a:	00878693          	addi	a3,a5,8
    8000394e:	068a                	slli	a3,a3,0x2
    80003950:	00018717          	auipc	a4,0x18
    80003954:	d9070713          	addi	a4,a4,-624 # 8001b6e0 <log>
    80003958:	9736                	add	a4,a4,a3
    8000395a:	44d4                	lw	a3,12(s1)
    8000395c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000395e:	faf609e3          	beq	a2,a5,80003910 <log_write+0x76>
  }
  release(&log.lock);
    80003962:	00018517          	auipc	a0,0x18
    80003966:	d7e50513          	addi	a0,a0,-642 # 8001b6e0 <log>
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	c22080e7          	jalr	-990(ra) # 8000658c <release>
}
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	64a2                	ld	s1,8(sp)
    80003978:	6902                	ld	s2,0(sp)
    8000397a:	6105                	addi	sp,sp,32
    8000397c:	8082                	ret

000000008000397e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000397e:	1101                	addi	sp,sp,-32
    80003980:	ec06                	sd	ra,24(sp)
    80003982:	e822                	sd	s0,16(sp)
    80003984:	e426                	sd	s1,8(sp)
    80003986:	e04a                	sd	s2,0(sp)
    80003988:	1000                	addi	s0,sp,32
    8000398a:	84aa                	mv	s1,a0
    8000398c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000398e:	00005597          	auipc	a1,0x5
    80003992:	c8258593          	addi	a1,a1,-894 # 80008610 <etext+0x610>
    80003996:	0521                	addi	a0,a0,8
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	ab0080e7          	jalr	-1360(ra) # 80006448 <initlock>
  lk->name = name;
    800039a0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039a8:	0204a423          	sw	zero,40(s1)
}
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	64a2                	ld	s1,8(sp)
    800039b2:	6902                	ld	s2,0(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret

00000000800039b8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	e426                	sd	s1,8(sp)
    800039c0:	e04a                	sd	s2,0(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c6:	00850913          	addi	s2,a0,8
    800039ca:	854a                	mv	a0,s2
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	b10080e7          	jalr	-1264(ra) # 800064dc <acquire>
  while (lk->locked) {
    800039d4:	409c                	lw	a5,0(s1)
    800039d6:	cb89                	beqz	a5,800039e8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039d8:	85ca                	mv	a1,s2
    800039da:	8526                	mv	a0,s1
    800039dc:	ffffe097          	auipc	ra,0xffffe
    800039e0:	c78080e7          	jalr	-904(ra) # 80001654 <sleep>
  while (lk->locked) {
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	fbed                	bnez	a5,800039d8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039e8:	4785                	li	a5,1
    800039ea:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039ec:	ffffd097          	auipc	ra,0xffffd
    800039f0:	58e080e7          	jalr	1422(ra) # 80000f7a <myproc>
    800039f4:	591c                	lw	a5,48(a0)
    800039f6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039f8:	854a                	mv	a0,s2
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	b92080e7          	jalr	-1134(ra) # 8000658c <release>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6902                	ld	s2,0(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret

0000000080003a0e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	e04a                	sd	s2,0(sp)
    80003a18:	1000                	addi	s0,sp,32
    80003a1a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a1c:	00850913          	addi	s2,a0,8
    80003a20:	854a                	mv	a0,s2
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	aba080e7          	jalr	-1350(ra) # 800064dc <acquire>
  lk->locked = 0;
    80003a2a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a2e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a32:	8526                	mv	a0,s1
    80003a34:	ffffe097          	auipc	ra,0xffffe
    80003a38:	c84080e7          	jalr	-892(ra) # 800016b8 <wakeup>
  release(&lk->lk);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	b4e080e7          	jalr	-1202(ra) # 8000658c <release>
}
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6902                	ld	s2,0(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret

0000000080003a52 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a52:	7179                	addi	sp,sp,-48
    80003a54:	f406                	sd	ra,40(sp)
    80003a56:	f022                	sd	s0,32(sp)
    80003a58:	ec26                	sd	s1,24(sp)
    80003a5a:	e84a                	sd	s2,16(sp)
    80003a5c:	1800                	addi	s0,sp,48
    80003a5e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a60:	00850913          	addi	s2,a0,8
    80003a64:	854a                	mv	a0,s2
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	a76080e7          	jalr	-1418(ra) # 800064dc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a6e:	409c                	lw	a5,0(s1)
    80003a70:	ef91                	bnez	a5,80003a8c <holdingsleep+0x3a>
    80003a72:	4481                	li	s1,0
  release(&lk->lk);
    80003a74:	854a                	mv	a0,s2
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	b16080e7          	jalr	-1258(ra) # 8000658c <release>
  return r;
}
    80003a7e:	8526                	mv	a0,s1
    80003a80:	70a2                	ld	ra,40(sp)
    80003a82:	7402                	ld	s0,32(sp)
    80003a84:	64e2                	ld	s1,24(sp)
    80003a86:	6942                	ld	s2,16(sp)
    80003a88:	6145                	addi	sp,sp,48
    80003a8a:	8082                	ret
    80003a8c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a8e:	0284a983          	lw	s3,40(s1)
    80003a92:	ffffd097          	auipc	ra,0xffffd
    80003a96:	4e8080e7          	jalr	1256(ra) # 80000f7a <myproc>
    80003a9a:	5904                	lw	s1,48(a0)
    80003a9c:	413484b3          	sub	s1,s1,s3
    80003aa0:	0014b493          	seqz	s1,s1
    80003aa4:	69a2                	ld	s3,8(sp)
    80003aa6:	b7f9                	j	80003a74 <holdingsleep+0x22>

0000000080003aa8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003aa8:	1141                	addi	sp,sp,-16
    80003aaa:	e406                	sd	ra,8(sp)
    80003aac:	e022                	sd	s0,0(sp)
    80003aae:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ab0:	00005597          	auipc	a1,0x5
    80003ab4:	b7058593          	addi	a1,a1,-1168 # 80008620 <etext+0x620>
    80003ab8:	00018517          	auipc	a0,0x18
    80003abc:	d7050513          	addi	a0,a0,-656 # 8001b828 <ftable>
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	988080e7          	jalr	-1656(ra) # 80006448 <initlock>
}
    80003ac8:	60a2                	ld	ra,8(sp)
    80003aca:	6402                	ld	s0,0(sp)
    80003acc:	0141                	addi	sp,sp,16
    80003ace:	8082                	ret

0000000080003ad0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ad0:	1101                	addi	sp,sp,-32
    80003ad2:	ec06                	sd	ra,24(sp)
    80003ad4:	e822                	sd	s0,16(sp)
    80003ad6:	e426                	sd	s1,8(sp)
    80003ad8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ada:	00018517          	auipc	a0,0x18
    80003ade:	d4e50513          	addi	a0,a0,-690 # 8001b828 <ftable>
    80003ae2:	00003097          	auipc	ra,0x3
    80003ae6:	9fa080e7          	jalr	-1542(ra) # 800064dc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aea:	00018497          	auipc	s1,0x18
    80003aee:	d5648493          	addi	s1,s1,-682 # 8001b840 <ftable+0x18>
    80003af2:	00019717          	auipc	a4,0x19
    80003af6:	cee70713          	addi	a4,a4,-786 # 8001c7e0 <disk>
    if(f->ref == 0){
    80003afa:	40dc                	lw	a5,4(s1)
    80003afc:	cf99                	beqz	a5,80003b1a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003afe:	02848493          	addi	s1,s1,40
    80003b02:	fee49ce3          	bne	s1,a4,80003afa <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b06:	00018517          	auipc	a0,0x18
    80003b0a:	d2250513          	addi	a0,a0,-734 # 8001b828 <ftable>
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	a7e080e7          	jalr	-1410(ra) # 8000658c <release>
  return 0;
    80003b16:	4481                	li	s1,0
    80003b18:	a819                	j	80003b2e <filealloc+0x5e>
      f->ref = 1;
    80003b1a:	4785                	li	a5,1
    80003b1c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b1e:	00018517          	auipc	a0,0x18
    80003b22:	d0a50513          	addi	a0,a0,-758 # 8001b828 <ftable>
    80003b26:	00003097          	auipc	ra,0x3
    80003b2a:	a66080e7          	jalr	-1434(ra) # 8000658c <release>
}
    80003b2e:	8526                	mv	a0,s1
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6105                	addi	sp,sp,32
    80003b38:	8082                	ret

0000000080003b3a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b3a:	1101                	addi	sp,sp,-32
    80003b3c:	ec06                	sd	ra,24(sp)
    80003b3e:	e822                	sd	s0,16(sp)
    80003b40:	e426                	sd	s1,8(sp)
    80003b42:	1000                	addi	s0,sp,32
    80003b44:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b46:	00018517          	auipc	a0,0x18
    80003b4a:	ce250513          	addi	a0,a0,-798 # 8001b828 <ftable>
    80003b4e:	00003097          	auipc	ra,0x3
    80003b52:	98e080e7          	jalr	-1650(ra) # 800064dc <acquire>
  if(f->ref < 1)
    80003b56:	40dc                	lw	a5,4(s1)
    80003b58:	02f05263          	blez	a5,80003b7c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b5c:	2785                	addiw	a5,a5,1
    80003b5e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b60:	00018517          	auipc	a0,0x18
    80003b64:	cc850513          	addi	a0,a0,-824 # 8001b828 <ftable>
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	a24080e7          	jalr	-1500(ra) # 8000658c <release>
  return f;
}
    80003b70:	8526                	mv	a0,s1
    80003b72:	60e2                	ld	ra,24(sp)
    80003b74:	6442                	ld	s0,16(sp)
    80003b76:	64a2                	ld	s1,8(sp)
    80003b78:	6105                	addi	sp,sp,32
    80003b7a:	8082                	ret
    panic("filedup");
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	aac50513          	addi	a0,a0,-1364 # 80008628 <etext+0x628>
    80003b84:	00002097          	auipc	ra,0x2
    80003b88:	5da080e7          	jalr	1498(ra) # 8000615e <panic>

0000000080003b8c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b8c:	7139                	addi	sp,sp,-64
    80003b8e:	fc06                	sd	ra,56(sp)
    80003b90:	f822                	sd	s0,48(sp)
    80003b92:	f426                	sd	s1,40(sp)
    80003b94:	0080                	addi	s0,sp,64
    80003b96:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b98:	00018517          	auipc	a0,0x18
    80003b9c:	c9050513          	addi	a0,a0,-880 # 8001b828 <ftable>
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	93c080e7          	jalr	-1732(ra) # 800064dc <acquire>
  if(f->ref < 1)
    80003ba8:	40dc                	lw	a5,4(s1)
    80003baa:	04f05a63          	blez	a5,80003bfe <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003bae:	37fd                	addiw	a5,a5,-1
    80003bb0:	c0dc                	sw	a5,4(s1)
    80003bb2:	06f04263          	bgtz	a5,80003c16 <fileclose+0x8a>
    80003bb6:	f04a                	sd	s2,32(sp)
    80003bb8:	ec4e                	sd	s3,24(sp)
    80003bba:	e852                	sd	s4,16(sp)
    80003bbc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bbe:	0004a903          	lw	s2,0(s1)
    80003bc2:	0094ca83          	lbu	s5,9(s1)
    80003bc6:	0104ba03          	ld	s4,16(s1)
    80003bca:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bce:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bd2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bd6:	00018517          	auipc	a0,0x18
    80003bda:	c5250513          	addi	a0,a0,-942 # 8001b828 <ftable>
    80003bde:	00003097          	auipc	ra,0x3
    80003be2:	9ae080e7          	jalr	-1618(ra) # 8000658c <release>

  if(ff.type == FD_PIPE){
    80003be6:	4785                	li	a5,1
    80003be8:	04f90463          	beq	s2,a5,80003c30 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bec:	3979                	addiw	s2,s2,-2
    80003bee:	4785                	li	a5,1
    80003bf0:	0527fb63          	bgeu	a5,s2,80003c46 <fileclose+0xba>
    80003bf4:	7902                	ld	s2,32(sp)
    80003bf6:	69e2                	ld	s3,24(sp)
    80003bf8:	6a42                	ld	s4,16(sp)
    80003bfa:	6aa2                	ld	s5,8(sp)
    80003bfc:	a02d                	j	80003c26 <fileclose+0x9a>
    80003bfe:	f04a                	sd	s2,32(sp)
    80003c00:	ec4e                	sd	s3,24(sp)
    80003c02:	e852                	sd	s4,16(sp)
    80003c04:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c06:	00005517          	auipc	a0,0x5
    80003c0a:	a2a50513          	addi	a0,a0,-1494 # 80008630 <etext+0x630>
    80003c0e:	00002097          	auipc	ra,0x2
    80003c12:	550080e7          	jalr	1360(ra) # 8000615e <panic>
    release(&ftable.lock);
    80003c16:	00018517          	auipc	a0,0x18
    80003c1a:	c1250513          	addi	a0,a0,-1006 # 8001b828 <ftable>
    80003c1e:	00003097          	auipc	ra,0x3
    80003c22:	96e080e7          	jalr	-1682(ra) # 8000658c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c26:	70e2                	ld	ra,56(sp)
    80003c28:	7442                	ld	s0,48(sp)
    80003c2a:	74a2                	ld	s1,40(sp)
    80003c2c:	6121                	addi	sp,sp,64
    80003c2e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c30:	85d6                	mv	a1,s5
    80003c32:	8552                	mv	a0,s4
    80003c34:	00000097          	auipc	ra,0x0
    80003c38:	3ac080e7          	jalr	940(ra) # 80003fe0 <pipeclose>
    80003c3c:	7902                	ld	s2,32(sp)
    80003c3e:	69e2                	ld	s3,24(sp)
    80003c40:	6a42                	ld	s4,16(sp)
    80003c42:	6aa2                	ld	s5,8(sp)
    80003c44:	b7cd                	j	80003c26 <fileclose+0x9a>
    begin_op();
    80003c46:	00000097          	auipc	ra,0x0
    80003c4a:	a76080e7          	jalr	-1418(ra) # 800036bc <begin_op>
    iput(ff.ip);
    80003c4e:	854e                	mv	a0,s3
    80003c50:	fffff097          	auipc	ra,0xfffff
    80003c54:	240080e7          	jalr	576(ra) # 80002e90 <iput>
    end_op();
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	ade080e7          	jalr	-1314(ra) # 80003736 <end_op>
    80003c60:	7902                	ld	s2,32(sp)
    80003c62:	69e2                	ld	s3,24(sp)
    80003c64:	6a42                	ld	s4,16(sp)
    80003c66:	6aa2                	ld	s5,8(sp)
    80003c68:	bf7d                	j	80003c26 <fileclose+0x9a>

0000000080003c6a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c6a:	715d                	addi	sp,sp,-80
    80003c6c:	e486                	sd	ra,72(sp)
    80003c6e:	e0a2                	sd	s0,64(sp)
    80003c70:	fc26                	sd	s1,56(sp)
    80003c72:	f44e                	sd	s3,40(sp)
    80003c74:	0880                	addi	s0,sp,80
    80003c76:	84aa                	mv	s1,a0
    80003c78:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c7a:	ffffd097          	auipc	ra,0xffffd
    80003c7e:	300080e7          	jalr	768(ra) # 80000f7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c82:	409c                	lw	a5,0(s1)
    80003c84:	37f9                	addiw	a5,a5,-2
    80003c86:	4705                	li	a4,1
    80003c88:	04f76a63          	bltu	a4,a5,80003cdc <filestat+0x72>
    80003c8c:	f84a                	sd	s2,48(sp)
    80003c8e:	f052                	sd	s4,32(sp)
    80003c90:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c92:	6c88                	ld	a0,24(s1)
    80003c94:	fffff097          	auipc	ra,0xfffff
    80003c98:	03e080e7          	jalr	62(ra) # 80002cd2 <ilock>
    stati(f->ip, &st);
    80003c9c:	fb840a13          	addi	s4,s0,-72
    80003ca0:	85d2                	mv	a1,s4
    80003ca2:	6c88                	ld	a0,24(s1)
    80003ca4:	fffff097          	auipc	ra,0xfffff
    80003ca8:	2bc080e7          	jalr	700(ra) # 80002f60 <stati>
    iunlock(f->ip);
    80003cac:	6c88                	ld	a0,24(s1)
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	0ea080e7          	jalr	234(ra) # 80002d98 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cb6:	46e1                	li	a3,24
    80003cb8:	8652                	mv	a2,s4
    80003cba:	85ce                	mv	a1,s3
    80003cbc:	05093503          	ld	a0,80(s2)
    80003cc0:	ffffd097          	auipc	ra,0xffffd
    80003cc4:	f02080e7          	jalr	-254(ra) # 80000bc2 <copyout>
    80003cc8:	41f5551b          	sraiw	a0,a0,0x1f
    80003ccc:	7942                	ld	s2,48(sp)
    80003cce:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003cd0:	60a6                	ld	ra,72(sp)
    80003cd2:	6406                	ld	s0,64(sp)
    80003cd4:	74e2                	ld	s1,56(sp)
    80003cd6:	79a2                	ld	s3,40(sp)
    80003cd8:	6161                	addi	sp,sp,80
    80003cda:	8082                	ret
  return -1;
    80003cdc:	557d                	li	a0,-1
    80003cde:	bfcd                	j	80003cd0 <filestat+0x66>

0000000080003ce0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ce0:	7179                	addi	sp,sp,-48
    80003ce2:	f406                	sd	ra,40(sp)
    80003ce4:	f022                	sd	s0,32(sp)
    80003ce6:	e84a                	sd	s2,16(sp)
    80003ce8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cea:	00854783          	lbu	a5,8(a0)
    80003cee:	cbc5                	beqz	a5,80003d9e <fileread+0xbe>
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e44e                	sd	s3,8(sp)
    80003cf4:	84aa                	mv	s1,a0
    80003cf6:	89ae                	mv	s3,a1
    80003cf8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cfa:	411c                	lw	a5,0(a0)
    80003cfc:	4705                	li	a4,1
    80003cfe:	04e78963          	beq	a5,a4,80003d50 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d02:	470d                	li	a4,3
    80003d04:	04e78f63          	beq	a5,a4,80003d62 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d08:	4709                	li	a4,2
    80003d0a:	08e79263          	bne	a5,a4,80003d8e <fileread+0xae>
    ilock(f->ip);
    80003d0e:	6d08                	ld	a0,24(a0)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	fc2080e7          	jalr	-62(ra) # 80002cd2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d18:	874a                	mv	a4,s2
    80003d1a:	5094                	lw	a3,32(s1)
    80003d1c:	864e                	mv	a2,s3
    80003d1e:	4585                	li	a1,1
    80003d20:	6c88                	ld	a0,24(s1)
    80003d22:	fffff097          	auipc	ra,0xfffff
    80003d26:	26c080e7          	jalr	620(ra) # 80002f8e <readi>
    80003d2a:	892a                	mv	s2,a0
    80003d2c:	00a05563          	blez	a0,80003d36 <fileread+0x56>
      f->off += r;
    80003d30:	509c                	lw	a5,32(s1)
    80003d32:	9fa9                	addw	a5,a5,a0
    80003d34:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d36:	6c88                	ld	a0,24(s1)
    80003d38:	fffff097          	auipc	ra,0xfffff
    80003d3c:	060080e7          	jalr	96(ra) # 80002d98 <iunlock>
    80003d40:	64e2                	ld	s1,24(sp)
    80003d42:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d44:	854a                	mv	a0,s2
    80003d46:	70a2                	ld	ra,40(sp)
    80003d48:	7402                	ld	s0,32(sp)
    80003d4a:	6942                	ld	s2,16(sp)
    80003d4c:	6145                	addi	sp,sp,48
    80003d4e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d50:	6908                	ld	a0,16(a0)
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	41a080e7          	jalr	1050(ra) # 8000416c <piperead>
    80003d5a:	892a                	mv	s2,a0
    80003d5c:	64e2                	ld	s1,24(sp)
    80003d5e:	69a2                	ld	s3,8(sp)
    80003d60:	b7d5                	j	80003d44 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d62:	02451783          	lh	a5,36(a0)
    80003d66:	03079693          	slli	a3,a5,0x30
    80003d6a:	92c1                	srli	a3,a3,0x30
    80003d6c:	4725                	li	a4,9
    80003d6e:	02d76a63          	bltu	a4,a3,80003da2 <fileread+0xc2>
    80003d72:	0792                	slli	a5,a5,0x4
    80003d74:	00018717          	auipc	a4,0x18
    80003d78:	a1470713          	addi	a4,a4,-1516 # 8001b788 <devsw>
    80003d7c:	97ba                	add	a5,a5,a4
    80003d7e:	639c                	ld	a5,0(a5)
    80003d80:	c78d                	beqz	a5,80003daa <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d82:	4505                	li	a0,1
    80003d84:	9782                	jalr	a5
    80003d86:	892a                	mv	s2,a0
    80003d88:	64e2                	ld	s1,24(sp)
    80003d8a:	69a2                	ld	s3,8(sp)
    80003d8c:	bf65                	j	80003d44 <fileread+0x64>
    panic("fileread");
    80003d8e:	00005517          	auipc	a0,0x5
    80003d92:	8b250513          	addi	a0,a0,-1870 # 80008640 <etext+0x640>
    80003d96:	00002097          	auipc	ra,0x2
    80003d9a:	3c8080e7          	jalr	968(ra) # 8000615e <panic>
    return -1;
    80003d9e:	597d                	li	s2,-1
    80003da0:	b755                	j	80003d44 <fileread+0x64>
      return -1;
    80003da2:	597d                	li	s2,-1
    80003da4:	64e2                	ld	s1,24(sp)
    80003da6:	69a2                	ld	s3,8(sp)
    80003da8:	bf71                	j	80003d44 <fileread+0x64>
    80003daa:	597d                	li	s2,-1
    80003dac:	64e2                	ld	s1,24(sp)
    80003dae:	69a2                	ld	s3,8(sp)
    80003db0:	bf51                	j	80003d44 <fileread+0x64>

0000000080003db2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003db2:	00954783          	lbu	a5,9(a0)
    80003db6:	12078c63          	beqz	a5,80003eee <filewrite+0x13c>
{
    80003dba:	711d                	addi	sp,sp,-96
    80003dbc:	ec86                	sd	ra,88(sp)
    80003dbe:	e8a2                	sd	s0,80(sp)
    80003dc0:	e0ca                	sd	s2,64(sp)
    80003dc2:	f456                	sd	s5,40(sp)
    80003dc4:	f05a                	sd	s6,32(sp)
    80003dc6:	1080                	addi	s0,sp,96
    80003dc8:	892a                	mv	s2,a0
    80003dca:	8b2e                	mv	s6,a1
    80003dcc:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dce:	411c                	lw	a5,0(a0)
    80003dd0:	4705                	li	a4,1
    80003dd2:	02e78963          	beq	a5,a4,80003e04 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dd6:	470d                	li	a4,3
    80003dd8:	02e78c63          	beq	a5,a4,80003e10 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ddc:	4709                	li	a4,2
    80003dde:	0ee79a63          	bne	a5,a4,80003ed2 <filewrite+0x120>
    80003de2:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de4:	0cc05563          	blez	a2,80003eae <filewrite+0xfc>
    80003de8:	e4a6                	sd	s1,72(sp)
    80003dea:	fc4e                	sd	s3,56(sp)
    80003dec:	ec5e                	sd	s7,24(sp)
    80003dee:	e862                	sd	s8,16(sp)
    80003df0:	e466                	sd	s9,8(sp)
    int i = 0;
    80003df2:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003df4:	6b85                	lui	s7,0x1
    80003df6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003dfa:	6c85                	lui	s9,0x1
    80003dfc:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e00:	4c05                	li	s8,1
    80003e02:	a849                	j	80003e94 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003e04:	6908                	ld	a0,16(a0)
    80003e06:	00000097          	auipc	ra,0x0
    80003e0a:	24a080e7          	jalr	586(ra) # 80004050 <pipewrite>
    80003e0e:	a85d                	j	80003ec4 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e10:	02451783          	lh	a5,36(a0)
    80003e14:	03079693          	slli	a3,a5,0x30
    80003e18:	92c1                	srli	a3,a3,0x30
    80003e1a:	4725                	li	a4,9
    80003e1c:	0cd76b63          	bltu	a4,a3,80003ef2 <filewrite+0x140>
    80003e20:	0792                	slli	a5,a5,0x4
    80003e22:	00018717          	auipc	a4,0x18
    80003e26:	96670713          	addi	a4,a4,-1690 # 8001b788 <devsw>
    80003e2a:	97ba                	add	a5,a5,a4
    80003e2c:	679c                	ld	a5,8(a5)
    80003e2e:	c7e1                	beqz	a5,80003ef6 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003e30:	4505                	li	a0,1
    80003e32:	9782                	jalr	a5
    80003e34:	a841                	j	80003ec4 <filewrite+0x112>
      if(n1 > max)
    80003e36:	2981                	sext.w	s3,s3
      begin_op();
    80003e38:	00000097          	auipc	ra,0x0
    80003e3c:	884080e7          	jalr	-1916(ra) # 800036bc <begin_op>
      ilock(f->ip);
    80003e40:	01893503          	ld	a0,24(s2)
    80003e44:	fffff097          	auipc	ra,0xfffff
    80003e48:	e8e080e7          	jalr	-370(ra) # 80002cd2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e4c:	874e                	mv	a4,s3
    80003e4e:	02092683          	lw	a3,32(s2)
    80003e52:	016a0633          	add	a2,s4,s6
    80003e56:	85e2                	mv	a1,s8
    80003e58:	01893503          	ld	a0,24(s2)
    80003e5c:	fffff097          	auipc	ra,0xfffff
    80003e60:	238080e7          	jalr	568(ra) # 80003094 <writei>
    80003e64:	84aa                	mv	s1,a0
    80003e66:	00a05763          	blez	a0,80003e74 <filewrite+0xc2>
        f->off += r;
    80003e6a:	02092783          	lw	a5,32(s2)
    80003e6e:	9fa9                	addw	a5,a5,a0
    80003e70:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e74:	01893503          	ld	a0,24(s2)
    80003e78:	fffff097          	auipc	ra,0xfffff
    80003e7c:	f20080e7          	jalr	-224(ra) # 80002d98 <iunlock>
      end_op();
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	8b6080e7          	jalr	-1866(ra) # 80003736 <end_op>

      if(r != n1){
    80003e88:	02999563          	bne	s3,s1,80003eb2 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003e8c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003e90:	015a5963          	bge	s4,s5,80003ea2 <filewrite+0xf0>
      int n1 = n - i;
    80003e94:	414a87bb          	subw	a5,s5,s4
    80003e98:	89be                	mv	s3,a5
      if(n1 > max)
    80003e9a:	f8fbdee3          	bge	s7,a5,80003e36 <filewrite+0x84>
    80003e9e:	89e6                	mv	s3,s9
    80003ea0:	bf59                	j	80003e36 <filewrite+0x84>
    80003ea2:	64a6                	ld	s1,72(sp)
    80003ea4:	79e2                	ld	s3,56(sp)
    80003ea6:	6be2                	ld	s7,24(sp)
    80003ea8:	6c42                	ld	s8,16(sp)
    80003eaa:	6ca2                	ld	s9,8(sp)
    80003eac:	a801                	j	80003ebc <filewrite+0x10a>
    int i = 0;
    80003eae:	4a01                	li	s4,0
    80003eb0:	a031                	j	80003ebc <filewrite+0x10a>
    80003eb2:	64a6                	ld	s1,72(sp)
    80003eb4:	79e2                	ld	s3,56(sp)
    80003eb6:	6be2                	ld	s7,24(sp)
    80003eb8:	6c42                	ld	s8,16(sp)
    80003eba:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003ebc:	034a9f63          	bne	s5,s4,80003efa <filewrite+0x148>
    80003ec0:	8556                	mv	a0,s5
    80003ec2:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ec4:	60e6                	ld	ra,88(sp)
    80003ec6:	6446                	ld	s0,80(sp)
    80003ec8:	6906                	ld	s2,64(sp)
    80003eca:	7aa2                	ld	s5,40(sp)
    80003ecc:	7b02                	ld	s6,32(sp)
    80003ece:	6125                	addi	sp,sp,96
    80003ed0:	8082                	ret
    80003ed2:	e4a6                	sd	s1,72(sp)
    80003ed4:	fc4e                	sd	s3,56(sp)
    80003ed6:	f852                	sd	s4,48(sp)
    80003ed8:	ec5e                	sd	s7,24(sp)
    80003eda:	e862                	sd	s8,16(sp)
    80003edc:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003ede:	00004517          	auipc	a0,0x4
    80003ee2:	77250513          	addi	a0,a0,1906 # 80008650 <etext+0x650>
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	278080e7          	jalr	632(ra) # 8000615e <panic>
    return -1;
    80003eee:	557d                	li	a0,-1
}
    80003ef0:	8082                	ret
      return -1;
    80003ef2:	557d                	li	a0,-1
    80003ef4:	bfc1                	j	80003ec4 <filewrite+0x112>
    80003ef6:	557d                	li	a0,-1
    80003ef8:	b7f1                	j	80003ec4 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003efa:	557d                	li	a0,-1
    80003efc:	7a42                	ld	s4,48(sp)
    80003efe:	b7d9                	j	80003ec4 <filewrite+0x112>

0000000080003f00 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f00:	7179                	addi	sp,sp,-48
    80003f02:	f406                	sd	ra,40(sp)
    80003f04:	f022                	sd	s0,32(sp)
    80003f06:	ec26                	sd	s1,24(sp)
    80003f08:	e052                	sd	s4,0(sp)
    80003f0a:	1800                	addi	s0,sp,48
    80003f0c:	84aa                	mv	s1,a0
    80003f0e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f10:	0005b023          	sd	zero,0(a1)
    80003f14:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	bb8080e7          	jalr	-1096(ra) # 80003ad0 <filealloc>
    80003f20:	e088                	sd	a0,0(s1)
    80003f22:	cd49                	beqz	a0,80003fbc <pipealloc+0xbc>
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	bac080e7          	jalr	-1108(ra) # 80003ad0 <filealloc>
    80003f2c:	00aa3023          	sd	a0,0(s4)
    80003f30:	c141                	beqz	a0,80003fb0 <pipealloc+0xb0>
    80003f32:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f34:	ffffc097          	auipc	ra,0xffffc
    80003f38:	1e6080e7          	jalr	486(ra) # 8000011a <kalloc>
    80003f3c:	892a                	mv	s2,a0
    80003f3e:	c13d                	beqz	a0,80003fa4 <pipealloc+0xa4>
    80003f40:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f42:	4985                	li	s3,1
    80003f44:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f48:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f4c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f50:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f54:	00004597          	auipc	a1,0x4
    80003f58:	4ac58593          	addi	a1,a1,1196 # 80008400 <etext+0x400>
    80003f5c:	00002097          	auipc	ra,0x2
    80003f60:	4ec080e7          	jalr	1260(ra) # 80006448 <initlock>
  (*f0)->type = FD_PIPE;
    80003f64:	609c                	ld	a5,0(s1)
    80003f66:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f6a:	609c                	ld	a5,0(s1)
    80003f6c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f70:	609c                	ld	a5,0(s1)
    80003f72:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f76:	609c                	ld	a5,0(s1)
    80003f78:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f7c:	000a3783          	ld	a5,0(s4)
    80003f80:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f84:	000a3783          	ld	a5,0(s4)
    80003f88:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f8c:	000a3783          	ld	a5,0(s4)
    80003f90:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f94:	000a3783          	ld	a5,0(s4)
    80003f98:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f9c:	4501                	li	a0,0
    80003f9e:	6942                	ld	s2,16(sp)
    80003fa0:	69a2                	ld	s3,8(sp)
    80003fa2:	a03d                	j	80003fd0 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fa4:	6088                	ld	a0,0(s1)
    80003fa6:	c119                	beqz	a0,80003fac <pipealloc+0xac>
    80003fa8:	6942                	ld	s2,16(sp)
    80003faa:	a029                	j	80003fb4 <pipealloc+0xb4>
    80003fac:	6942                	ld	s2,16(sp)
    80003fae:	a039                	j	80003fbc <pipealloc+0xbc>
    80003fb0:	6088                	ld	a0,0(s1)
    80003fb2:	c50d                	beqz	a0,80003fdc <pipealloc+0xdc>
    fileclose(*f0);
    80003fb4:	00000097          	auipc	ra,0x0
    80003fb8:	bd8080e7          	jalr	-1064(ra) # 80003b8c <fileclose>
  if(*f1)
    80003fbc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fc0:	557d                	li	a0,-1
  if(*f1)
    80003fc2:	c799                	beqz	a5,80003fd0 <pipealloc+0xd0>
    fileclose(*f1);
    80003fc4:	853e                	mv	a0,a5
    80003fc6:	00000097          	auipc	ra,0x0
    80003fca:	bc6080e7          	jalr	-1082(ra) # 80003b8c <fileclose>
  return -1;
    80003fce:	557d                	li	a0,-1
}
    80003fd0:	70a2                	ld	ra,40(sp)
    80003fd2:	7402                	ld	s0,32(sp)
    80003fd4:	64e2                	ld	s1,24(sp)
    80003fd6:	6a02                	ld	s4,0(sp)
    80003fd8:	6145                	addi	sp,sp,48
    80003fda:	8082                	ret
  return -1;
    80003fdc:	557d                	li	a0,-1
    80003fde:	bfcd                	j	80003fd0 <pipealloc+0xd0>

0000000080003fe0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fe0:	1101                	addi	sp,sp,-32
    80003fe2:	ec06                	sd	ra,24(sp)
    80003fe4:	e822                	sd	s0,16(sp)
    80003fe6:	e426                	sd	s1,8(sp)
    80003fe8:	e04a                	sd	s2,0(sp)
    80003fea:	1000                	addi	s0,sp,32
    80003fec:	84aa                	mv	s1,a0
    80003fee:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ff0:	00002097          	auipc	ra,0x2
    80003ff4:	4ec080e7          	jalr	1260(ra) # 800064dc <acquire>
  if(writable){
    80003ff8:	02090d63          	beqz	s2,80004032 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ffc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004000:	21848513          	addi	a0,s1,536
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	6b4080e7          	jalr	1716(ra) # 800016b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000400c:	2204b783          	ld	a5,544(s1)
    80004010:	eb95                	bnez	a5,80004044 <pipeclose+0x64>
    release(&pi->lock);
    80004012:	8526                	mv	a0,s1
    80004014:	00002097          	auipc	ra,0x2
    80004018:	578080e7          	jalr	1400(ra) # 8000658c <release>
    kfree((char*)pi);
    8000401c:	8526                	mv	a0,s1
    8000401e:	ffffc097          	auipc	ra,0xffffc
    80004022:	ffe080e7          	jalr	-2(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004026:	60e2                	ld	ra,24(sp)
    80004028:	6442                	ld	s0,16(sp)
    8000402a:	64a2                	ld	s1,8(sp)
    8000402c:	6902                	ld	s2,0(sp)
    8000402e:	6105                	addi	sp,sp,32
    80004030:	8082                	ret
    pi->readopen = 0;
    80004032:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004036:	21c48513          	addi	a0,s1,540
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	67e080e7          	jalr	1662(ra) # 800016b8 <wakeup>
    80004042:	b7e9                	j	8000400c <pipeclose+0x2c>
    release(&pi->lock);
    80004044:	8526                	mv	a0,s1
    80004046:	00002097          	auipc	ra,0x2
    8000404a:	546080e7          	jalr	1350(ra) # 8000658c <release>
}
    8000404e:	bfe1                	j	80004026 <pipeclose+0x46>

0000000080004050 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004050:	7159                	addi	sp,sp,-112
    80004052:	f486                	sd	ra,104(sp)
    80004054:	f0a2                	sd	s0,96(sp)
    80004056:	eca6                	sd	s1,88(sp)
    80004058:	e8ca                	sd	s2,80(sp)
    8000405a:	e4ce                	sd	s3,72(sp)
    8000405c:	e0d2                	sd	s4,64(sp)
    8000405e:	fc56                	sd	s5,56(sp)
    80004060:	1880                	addi	s0,sp,112
    80004062:	84aa                	mv	s1,a0
    80004064:	8aae                	mv	s5,a1
    80004066:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	f12080e7          	jalr	-238(ra) # 80000f7a <myproc>
    80004070:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	468080e7          	jalr	1128(ra) # 800064dc <acquire>
  while(i < n){
    8000407c:	0f405063          	blez	s4,8000415c <pipewrite+0x10c>
    80004080:	f85a                	sd	s6,48(sp)
    80004082:	f45e                	sd	s7,40(sp)
    80004084:	f062                	sd	s8,32(sp)
    80004086:	ec66                	sd	s9,24(sp)
    80004088:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000408a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000408c:	f9f40c13          	addi	s8,s0,-97
    80004090:	4b85                	li	s7,1
    80004092:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004094:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004098:	21c48c93          	addi	s9,s1,540
    8000409c:	a099                	j	800040e2 <pipewrite+0x92>
      release(&pi->lock);
    8000409e:	8526                	mv	a0,s1
    800040a0:	00002097          	auipc	ra,0x2
    800040a4:	4ec080e7          	jalr	1260(ra) # 8000658c <release>
      return -1;
    800040a8:	597d                	li	s2,-1
    800040aa:	7b42                	ld	s6,48(sp)
    800040ac:	7ba2                	ld	s7,40(sp)
    800040ae:	7c02                	ld	s8,32(sp)
    800040b0:	6ce2                	ld	s9,24(sp)
    800040b2:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040b4:	854a                	mv	a0,s2
    800040b6:	70a6                	ld	ra,104(sp)
    800040b8:	7406                	ld	s0,96(sp)
    800040ba:	64e6                	ld	s1,88(sp)
    800040bc:	6946                	ld	s2,80(sp)
    800040be:	69a6                	ld	s3,72(sp)
    800040c0:	6a06                	ld	s4,64(sp)
    800040c2:	7ae2                	ld	s5,56(sp)
    800040c4:	6165                	addi	sp,sp,112
    800040c6:	8082                	ret
      wakeup(&pi->nread);
    800040c8:	856a                	mv	a0,s10
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	5ee080e7          	jalr	1518(ra) # 800016b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040d2:	85a6                	mv	a1,s1
    800040d4:	8566                	mv	a0,s9
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	57e080e7          	jalr	1406(ra) # 80001654 <sleep>
  while(i < n){
    800040de:	05495e63          	bge	s2,s4,8000413a <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800040e2:	2204a783          	lw	a5,544(s1)
    800040e6:	dfc5                	beqz	a5,8000409e <pipewrite+0x4e>
    800040e8:	854e                	mv	a0,s3
    800040ea:	ffffe097          	auipc	ra,0xffffe
    800040ee:	812080e7          	jalr	-2030(ra) # 800018fc <killed>
    800040f2:	f555                	bnez	a0,8000409e <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040f4:	2184a783          	lw	a5,536(s1)
    800040f8:	21c4a703          	lw	a4,540(s1)
    800040fc:	2007879b          	addiw	a5,a5,512
    80004100:	fcf704e3          	beq	a4,a5,800040c8 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004104:	86de                	mv	a3,s7
    80004106:	01590633          	add	a2,s2,s5
    8000410a:	85e2                	mv	a1,s8
    8000410c:	0509b503          	ld	a0,80(s3)
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	b6a080e7          	jalr	-1174(ra) # 80000c7a <copyin>
    80004118:	05650463          	beq	a0,s6,80004160 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000411c:	21c4a783          	lw	a5,540(s1)
    80004120:	0017871b          	addiw	a4,a5,1
    80004124:	20e4ae23          	sw	a4,540(s1)
    80004128:	1ff7f793          	andi	a5,a5,511
    8000412c:	97a6                	add	a5,a5,s1
    8000412e:	f9f44703          	lbu	a4,-97(s0)
    80004132:	00e78c23          	sb	a4,24(a5)
      i++;
    80004136:	2905                	addiw	s2,s2,1
    80004138:	b75d                	j	800040de <pipewrite+0x8e>
    8000413a:	7b42                	ld	s6,48(sp)
    8000413c:	7ba2                	ld	s7,40(sp)
    8000413e:	7c02                	ld	s8,32(sp)
    80004140:	6ce2                	ld	s9,24(sp)
    80004142:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004144:	21848513          	addi	a0,s1,536
    80004148:	ffffd097          	auipc	ra,0xffffd
    8000414c:	570080e7          	jalr	1392(ra) # 800016b8 <wakeup>
  release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	43a080e7          	jalr	1082(ra) # 8000658c <release>
  return i;
    8000415a:	bfa9                	j	800040b4 <pipewrite+0x64>
  int i = 0;
    8000415c:	4901                	li	s2,0
    8000415e:	b7dd                	j	80004144 <pipewrite+0xf4>
    80004160:	7b42                	ld	s6,48(sp)
    80004162:	7ba2                	ld	s7,40(sp)
    80004164:	7c02                	ld	s8,32(sp)
    80004166:	6ce2                	ld	s9,24(sp)
    80004168:	6d42                	ld	s10,16(sp)
    8000416a:	bfe9                	j	80004144 <pipewrite+0xf4>

000000008000416c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000416c:	711d                	addi	sp,sp,-96
    8000416e:	ec86                	sd	ra,88(sp)
    80004170:	e8a2                	sd	s0,80(sp)
    80004172:	e4a6                	sd	s1,72(sp)
    80004174:	e0ca                	sd	s2,64(sp)
    80004176:	fc4e                	sd	s3,56(sp)
    80004178:	f852                	sd	s4,48(sp)
    8000417a:	f456                	sd	s5,40(sp)
    8000417c:	1080                	addi	s0,sp,96
    8000417e:	84aa                	mv	s1,a0
    80004180:	892e                	mv	s2,a1
    80004182:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	df6080e7          	jalr	-522(ra) # 80000f7a <myproc>
    8000418c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000418e:	8526                	mv	a0,s1
    80004190:	00002097          	auipc	ra,0x2
    80004194:	34c080e7          	jalr	844(ra) # 800064dc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004198:	2184a703          	lw	a4,536(s1)
    8000419c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041a0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a4:	02f71b63          	bne	a4,a5,800041da <piperead+0x6e>
    800041a8:	2244a783          	lw	a5,548(s1)
    800041ac:	c3b1                	beqz	a5,800041f0 <piperead+0x84>
    if(killed(pr)){
    800041ae:	8552                	mv	a0,s4
    800041b0:	ffffd097          	auipc	ra,0xffffd
    800041b4:	74c080e7          	jalr	1868(ra) # 800018fc <killed>
    800041b8:	e50d                	bnez	a0,800041e2 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ba:	85a6                	mv	a1,s1
    800041bc:	854e                	mv	a0,s3
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	496080e7          	jalr	1174(ra) # 80001654 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041c6:	2184a703          	lw	a4,536(s1)
    800041ca:	21c4a783          	lw	a5,540(s1)
    800041ce:	fcf70de3          	beq	a4,a5,800041a8 <piperead+0x3c>
    800041d2:	f05a                	sd	s6,32(sp)
    800041d4:	ec5e                	sd	s7,24(sp)
    800041d6:	e862                	sd	s8,16(sp)
    800041d8:	a839                	j	800041f6 <piperead+0x8a>
    800041da:	f05a                	sd	s6,32(sp)
    800041dc:	ec5e                	sd	s7,24(sp)
    800041de:	e862                	sd	s8,16(sp)
    800041e0:	a819                	j	800041f6 <piperead+0x8a>
      release(&pi->lock);
    800041e2:	8526                	mv	a0,s1
    800041e4:	00002097          	auipc	ra,0x2
    800041e8:	3a8080e7          	jalr	936(ra) # 8000658c <release>
      return -1;
    800041ec:	59fd                	li	s3,-1
    800041ee:	a895                	j	80004262 <piperead+0xf6>
    800041f0:	f05a                	sd	s6,32(sp)
    800041f2:	ec5e                	sd	s7,24(sp)
    800041f4:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041f6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041f8:	faf40c13          	addi	s8,s0,-81
    800041fc:	4b85                	li	s7,1
    800041fe:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004200:	05505363          	blez	s5,80004246 <piperead+0xda>
    if(pi->nread == pi->nwrite)
    80004204:	2184a783          	lw	a5,536(s1)
    80004208:	21c4a703          	lw	a4,540(s1)
    8000420c:	02f70d63          	beq	a4,a5,80004246 <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004210:	0017871b          	addiw	a4,a5,1
    80004214:	20e4ac23          	sw	a4,536(s1)
    80004218:	1ff7f793          	andi	a5,a5,511
    8000421c:	97a6                	add	a5,a5,s1
    8000421e:	0187c783          	lbu	a5,24(a5)
    80004222:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004226:	86de                	mv	a3,s7
    80004228:	8662                	mv	a2,s8
    8000422a:	85ca                	mv	a1,s2
    8000422c:	050a3503          	ld	a0,80(s4)
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	992080e7          	jalr	-1646(ra) # 80000bc2 <copyout>
    80004238:	01650763          	beq	a0,s6,80004246 <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000423c:	2985                	addiw	s3,s3,1
    8000423e:	0905                	addi	s2,s2,1
    80004240:	fd3a92e3          	bne	s5,s3,80004204 <piperead+0x98>
    80004244:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004246:	21c48513          	addi	a0,s1,540
    8000424a:	ffffd097          	auipc	ra,0xffffd
    8000424e:	46e080e7          	jalr	1134(ra) # 800016b8 <wakeup>
  release(&pi->lock);
    80004252:	8526                	mv	a0,s1
    80004254:	00002097          	auipc	ra,0x2
    80004258:	338080e7          	jalr	824(ra) # 8000658c <release>
    8000425c:	7b02                	ld	s6,32(sp)
    8000425e:	6be2                	ld	s7,24(sp)
    80004260:	6c42                	ld	s8,16(sp)
  return i;
}
    80004262:	854e                	mv	a0,s3
    80004264:	60e6                	ld	ra,88(sp)
    80004266:	6446                	ld	s0,80(sp)
    80004268:	64a6                	ld	s1,72(sp)
    8000426a:	6906                	ld	s2,64(sp)
    8000426c:	79e2                	ld	s3,56(sp)
    8000426e:	7a42                	ld	s4,48(sp)
    80004270:	7aa2                	ld	s5,40(sp)
    80004272:	6125                	addi	sp,sp,96
    80004274:	8082                	ret

0000000080004276 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004276:	1141                	addi	sp,sp,-16
    80004278:	e406                	sd	ra,8(sp)
    8000427a:	e022                	sd	s0,0(sp)
    8000427c:	0800                	addi	s0,sp,16
    8000427e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004280:	0035151b          	slliw	a0,a0,0x3
    80004284:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004286:	8b89                	andi	a5,a5,2
    80004288:	c399                	beqz	a5,8000428e <flags2perm+0x18>
      perm |= PTE_W;
    8000428a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000428e:	60a2                	ld	ra,8(sp)
    80004290:	6402                	ld	s0,0(sp)
    80004292:	0141                	addi	sp,sp,16
    80004294:	8082                	ret

0000000080004296 <exec>:

int
exec(char *path, char **argv)
{
    80004296:	de010113          	addi	sp,sp,-544
    8000429a:	20113c23          	sd	ra,536(sp)
    8000429e:	20813823          	sd	s0,528(sp)
    800042a2:	20913423          	sd	s1,520(sp)
    800042a6:	21213023          	sd	s2,512(sp)
    800042aa:	1400                	addi	s0,sp,544
    800042ac:	892a                	mv	s2,a0
    800042ae:	dea43823          	sd	a0,-528(s0)
    800042b2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042b6:	ffffd097          	auipc	ra,0xffffd
    800042ba:	cc4080e7          	jalr	-828(ra) # 80000f7a <myproc>
    800042be:	84aa                	mv	s1,a0

  begin_op();
    800042c0:	fffff097          	auipc	ra,0xfffff
    800042c4:	3fc080e7          	jalr	1020(ra) # 800036bc <begin_op>

  if((ip = namei(path)) == 0){
    800042c8:	854a                	mv	a0,s2
    800042ca:	fffff097          	auipc	ra,0xfffff
    800042ce:	1ec080e7          	jalr	492(ra) # 800034b6 <namei>
    800042d2:	c525                	beqz	a0,8000433a <exec+0xa4>
    800042d4:	fbd2                	sd	s4,496(sp)
    800042d6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	9fa080e7          	jalr	-1542(ra) # 80002cd2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042e0:	04000713          	li	a4,64
    800042e4:	4681                	li	a3,0
    800042e6:	e5040613          	addi	a2,s0,-432
    800042ea:	4581                	li	a1,0
    800042ec:	8552                	mv	a0,s4
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	ca0080e7          	jalr	-864(ra) # 80002f8e <readi>
    800042f6:	04000793          	li	a5,64
    800042fa:	00f51a63          	bne	a0,a5,8000430e <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042fe:	e5042703          	lw	a4,-432(s0)
    80004302:	464c47b7          	lui	a5,0x464c4
    80004306:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000430a:	02f70e63          	beq	a4,a5,80004346 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000430e:	8552                	mv	a0,s4
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	c28080e7          	jalr	-984(ra) # 80002f38 <iunlockput>
    end_op();
    80004318:	fffff097          	auipc	ra,0xfffff
    8000431c:	41e080e7          	jalr	1054(ra) # 80003736 <end_op>
  }
  return -1;
    80004320:	557d                	li	a0,-1
    80004322:	7a5e                	ld	s4,496(sp)
}
    80004324:	21813083          	ld	ra,536(sp)
    80004328:	21013403          	ld	s0,528(sp)
    8000432c:	20813483          	ld	s1,520(sp)
    80004330:	20013903          	ld	s2,512(sp)
    80004334:	22010113          	addi	sp,sp,544
    80004338:	8082                	ret
    end_op();
    8000433a:	fffff097          	auipc	ra,0xfffff
    8000433e:	3fc080e7          	jalr	1020(ra) # 80003736 <end_op>
    return -1;
    80004342:	557d                	li	a0,-1
    80004344:	b7c5                	j	80004324 <exec+0x8e>
    80004346:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004348:	8526                	mv	a0,s1
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	cf8080e7          	jalr	-776(ra) # 80001042 <proc_pagetable>
    80004352:	8b2a                	mv	s6,a0
    80004354:	2c050163          	beqz	a0,80004616 <exec+0x380>
    80004358:	ffce                	sd	s3,504(sp)
    8000435a:	f7d6                	sd	s5,488(sp)
    8000435c:	efde                	sd	s7,472(sp)
    8000435e:	ebe2                	sd	s8,464(sp)
    80004360:	e7e6                	sd	s9,456(sp)
    80004362:	e3ea                	sd	s10,448(sp)
    80004364:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004366:	e7042683          	lw	a3,-400(s0)
    8000436a:	e8845783          	lhu	a5,-376(s0)
    8000436e:	10078363          	beqz	a5,80004474 <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004372:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004374:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004376:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000437a:	6c85                	lui	s9,0x1
    8000437c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004380:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004384:	6a85                	lui	s5,0x1
    80004386:	a0b5                	j	800043f2 <exec+0x15c>
      panic("loadseg: address should exist");
    80004388:	00004517          	auipc	a0,0x4
    8000438c:	2d850513          	addi	a0,a0,728 # 80008660 <etext+0x660>
    80004390:	00002097          	auipc	ra,0x2
    80004394:	dce080e7          	jalr	-562(ra) # 8000615e <panic>
    if(sz - i < PGSIZE)
    80004398:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000439a:	874a                	mv	a4,s2
    8000439c:	009c06bb          	addw	a3,s8,s1
    800043a0:	4581                	li	a1,0
    800043a2:	8552                	mv	a0,s4
    800043a4:	fffff097          	auipc	ra,0xfffff
    800043a8:	bea080e7          	jalr	-1046(ra) # 80002f8e <readi>
    800043ac:	26a91963          	bne	s2,a0,8000461e <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800043b0:	009a84bb          	addw	s1,s5,s1
    800043b4:	0334f463          	bgeu	s1,s3,800043dc <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    800043b8:	02049593          	slli	a1,s1,0x20
    800043bc:	9181                	srli	a1,a1,0x20
    800043be:	95de                	add	a1,a1,s7
    800043c0:	855a                	mv	a0,s6
    800043c2:	ffffc097          	auipc	ra,0xffffc
    800043c6:	1a4080e7          	jalr	420(ra) # 80000566 <walkaddr>
    800043ca:	862a                	mv	a2,a0
    if(pa == 0)
    800043cc:	dd55                	beqz	a0,80004388 <exec+0xf2>
    if(sz - i < PGSIZE)
    800043ce:	409987bb          	subw	a5,s3,s1
    800043d2:	893e                	mv	s2,a5
    800043d4:	fcfcf2e3          	bgeu	s9,a5,80004398 <exec+0x102>
    800043d8:	8956                	mv	s2,s5
    800043da:	bf7d                	j	80004398 <exec+0x102>
    sz = sz1;
    800043dc:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e0:	2d05                	addiw	s10,s10,1
    800043e2:	e0843783          	ld	a5,-504(s0)
    800043e6:	0387869b          	addiw	a3,a5,56
    800043ea:	e8845783          	lhu	a5,-376(s0)
    800043ee:	08fd5463          	bge	s10,a5,80004476 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043f2:	e0d43423          	sd	a3,-504(s0)
    800043f6:	876e                	mv	a4,s11
    800043f8:	e1840613          	addi	a2,s0,-488
    800043fc:	4581                	li	a1,0
    800043fe:	8552                	mv	a0,s4
    80004400:	fffff097          	auipc	ra,0xfffff
    80004404:	b8e080e7          	jalr	-1138(ra) # 80002f8e <readi>
    80004408:	21b51963          	bne	a0,s11,8000461a <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    8000440c:	e1842783          	lw	a5,-488(s0)
    80004410:	4705                	li	a4,1
    80004412:	fce797e3          	bne	a5,a4,800043e0 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80004416:	e4043483          	ld	s1,-448(s0)
    8000441a:	e3843783          	ld	a5,-456(s0)
    8000441e:	22f4e063          	bltu	s1,a5,8000463e <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004422:	e2843783          	ld	a5,-472(s0)
    80004426:	94be                	add	s1,s1,a5
    80004428:	20f4ee63          	bltu	s1,a5,80004644 <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    8000442c:	de843703          	ld	a4,-536(s0)
    80004430:	8ff9                	and	a5,a5,a4
    80004432:	20079c63          	bnez	a5,8000464a <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004436:	e1c42503          	lw	a0,-484(s0)
    8000443a:	00000097          	auipc	ra,0x0
    8000443e:	e3c080e7          	jalr	-452(ra) # 80004276 <flags2perm>
    80004442:	86aa                	mv	a3,a0
    80004444:	8626                	mv	a2,s1
    80004446:	85ca                	mv	a1,s2
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	504080e7          	jalr	1284(ra) # 8000094e <uvmalloc>
    80004452:	dea43c23          	sd	a0,-520(s0)
    80004456:	1e050d63          	beqz	a0,80004650 <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000445a:	e2843b83          	ld	s7,-472(s0)
    8000445e:	e2042c03          	lw	s8,-480(s0)
    80004462:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004466:	00098463          	beqz	s3,8000446e <exec+0x1d8>
    8000446a:	4481                	li	s1,0
    8000446c:	b7b1                	j	800043b8 <exec+0x122>
    sz = sz1;
    8000446e:	df843903          	ld	s2,-520(s0)
    80004472:	b7bd                	j	800043e0 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004474:	4901                	li	s2,0
  iunlockput(ip);
    80004476:	8552                	mv	a0,s4
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	ac0080e7          	jalr	-1344(ra) # 80002f38 <iunlockput>
  end_op();
    80004480:	fffff097          	auipc	ra,0xfffff
    80004484:	2b6080e7          	jalr	694(ra) # 80003736 <end_op>
  p = myproc();
    80004488:	ffffd097          	auipc	ra,0xffffd
    8000448c:	af2080e7          	jalr	-1294(ra) # 80000f7a <myproc>
    80004490:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004492:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004496:	6985                	lui	s3,0x1
    80004498:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000449a:	99ca                	add	s3,s3,s2
    8000449c:	77fd                	lui	a5,0xfffff
    8000449e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800044a2:	4691                	li	a3,4
    800044a4:	6609                	lui	a2,0x2
    800044a6:	964e                	add	a2,a2,s3
    800044a8:	85ce                	mv	a1,s3
    800044aa:	855a                	mv	a0,s6
    800044ac:	ffffc097          	auipc	ra,0xffffc
    800044b0:	4a2080e7          	jalr	1186(ra) # 8000094e <uvmalloc>
    800044b4:	8a2a                	mv	s4,a0
    800044b6:	e115                	bnez	a0,800044da <exec+0x244>
    proc_freepagetable(pagetable, sz);
    800044b8:	85ce                	mv	a1,s3
    800044ba:	855a                	mv	a0,s6
    800044bc:	ffffd097          	auipc	ra,0xffffd
    800044c0:	c22080e7          	jalr	-990(ra) # 800010de <proc_freepagetable>
  return -1;
    800044c4:	557d                	li	a0,-1
    800044c6:	79fe                	ld	s3,504(sp)
    800044c8:	7a5e                	ld	s4,496(sp)
    800044ca:	7abe                	ld	s5,488(sp)
    800044cc:	7b1e                	ld	s6,480(sp)
    800044ce:	6bfe                	ld	s7,472(sp)
    800044d0:	6c5e                	ld	s8,464(sp)
    800044d2:	6cbe                	ld	s9,456(sp)
    800044d4:	6d1e                	ld	s10,448(sp)
    800044d6:	7dfa                	ld	s11,440(sp)
    800044d8:	b5b1                	j	80004324 <exec+0x8e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800044da:	75f9                	lui	a1,0xffffe
    800044dc:	95aa                	add	a1,a1,a0
    800044de:	855a                	mv	a0,s6
    800044e0:	ffffc097          	auipc	ra,0xffffc
    800044e4:	6b0080e7          	jalr	1712(ra) # 80000b90 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800044e8:	7bfd                	lui	s7,0xfffff
    800044ea:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800044ec:	e0043783          	ld	a5,-512(s0)
    800044f0:	6388                	ld	a0,0(a5)
  sp = sz;
    800044f2:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800044f4:	4481                	li	s1,0
    ustack[argc] = sp;
    800044f6:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800044fa:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800044fe:	c135                	beqz	a0,80004562 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80004500:	ffffc097          	auipc	ra,0xffffc
    80004504:	e50080e7          	jalr	-432(ra) # 80000350 <strlen>
    80004508:	0015079b          	addiw	a5,a0,1
    8000450c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004510:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004514:	15796163          	bltu	s2,s7,80004656 <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004518:	e0043d83          	ld	s11,-512(s0)
    8000451c:	000db983          	ld	s3,0(s11)
    80004520:	854e                	mv	a0,s3
    80004522:	ffffc097          	auipc	ra,0xffffc
    80004526:	e2e080e7          	jalr	-466(ra) # 80000350 <strlen>
    8000452a:	0015069b          	addiw	a3,a0,1
    8000452e:	864e                	mv	a2,s3
    80004530:	85ca                	mv	a1,s2
    80004532:	855a                	mv	a0,s6
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	68e080e7          	jalr	1678(ra) # 80000bc2 <copyout>
    8000453c:	10054f63          	bltz	a0,8000465a <exec+0x3c4>
    ustack[argc] = sp;
    80004540:	00349793          	slli	a5,s1,0x3
    80004544:	97e6                	add	a5,a5,s9
    80004546:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffda5e0>
  for(argc = 0; argv[argc]; argc++) {
    8000454a:	0485                	addi	s1,s1,1
    8000454c:	008d8793          	addi	a5,s11,8
    80004550:	e0f43023          	sd	a5,-512(s0)
    80004554:	008db503          	ld	a0,8(s11)
    80004558:	c509                	beqz	a0,80004562 <exec+0x2cc>
    if(argc >= MAXARG)
    8000455a:	fb8493e3          	bne	s1,s8,80004500 <exec+0x26a>
  sz = sz1;
    8000455e:	89d2                	mv	s3,s4
    80004560:	bfa1                	j	800044b8 <exec+0x222>
  ustack[argc] = 0;
    80004562:	00349793          	slli	a5,s1,0x3
    80004566:	f9078793          	addi	a5,a5,-112
    8000456a:	97a2                	add	a5,a5,s0
    8000456c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004570:	00148693          	addi	a3,s1,1
    80004574:	068e                	slli	a3,a3,0x3
    80004576:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000457a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000457e:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004580:	f3796ce3          	bltu	s2,s7,800044b8 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004584:	e9040613          	addi	a2,s0,-368
    80004588:	85ca                	mv	a1,s2
    8000458a:	855a                	mv	a0,s6
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	636080e7          	jalr	1590(ra) # 80000bc2 <copyout>
    80004594:	f20542e3          	bltz	a0,800044b8 <exec+0x222>
  p->trapframe->a1 = sp;
    80004598:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000459c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045a0:	df043783          	ld	a5,-528(s0)
    800045a4:	0007c703          	lbu	a4,0(a5)
    800045a8:	cf11                	beqz	a4,800045c4 <exec+0x32e>
    800045aa:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045ac:	02f00693          	li	a3,47
    800045b0:	a029                	j	800045ba <exec+0x324>
  for(last=s=path; *s; s++)
    800045b2:	0785                	addi	a5,a5,1
    800045b4:	fff7c703          	lbu	a4,-1(a5)
    800045b8:	c711                	beqz	a4,800045c4 <exec+0x32e>
    if(*s == '/')
    800045ba:	fed71ce3          	bne	a4,a3,800045b2 <exec+0x31c>
      last = s+1;
    800045be:	def43823          	sd	a5,-528(s0)
    800045c2:	bfc5                	j	800045b2 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    800045c4:	4641                	li	a2,16
    800045c6:	df043583          	ld	a1,-528(s0)
    800045ca:	158a8513          	addi	a0,s5,344
    800045ce:	ffffc097          	auipc	ra,0xffffc
    800045d2:	d4c080e7          	jalr	-692(ra) # 8000031a <safestrcpy>
  oldpagetable = p->pagetable;
    800045d6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800045da:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800045de:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045e2:	058ab783          	ld	a5,88(s5)
    800045e6:	e6843703          	ld	a4,-408(s0)
    800045ea:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045ec:	058ab783          	ld	a5,88(s5)
    800045f0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045f4:	85ea                	mv	a1,s10
    800045f6:	ffffd097          	auipc	ra,0xffffd
    800045fa:	ae8080e7          	jalr	-1304(ra) # 800010de <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045fe:	0004851b          	sext.w	a0,s1
    80004602:	79fe                	ld	s3,504(sp)
    80004604:	7a5e                	ld	s4,496(sp)
    80004606:	7abe                	ld	s5,488(sp)
    80004608:	7b1e                	ld	s6,480(sp)
    8000460a:	6bfe                	ld	s7,472(sp)
    8000460c:	6c5e                	ld	s8,464(sp)
    8000460e:	6cbe                	ld	s9,456(sp)
    80004610:	6d1e                	ld	s10,448(sp)
    80004612:	7dfa                	ld	s11,440(sp)
    80004614:	bb01                	j	80004324 <exec+0x8e>
    80004616:	7b1e                	ld	s6,480(sp)
    80004618:	b9dd                	j	8000430e <exec+0x78>
    8000461a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000461e:	df843583          	ld	a1,-520(s0)
    80004622:	855a                	mv	a0,s6
    80004624:	ffffd097          	auipc	ra,0xffffd
    80004628:	aba080e7          	jalr	-1350(ra) # 800010de <proc_freepagetable>
  if(ip){
    8000462c:	79fe                	ld	s3,504(sp)
    8000462e:	7abe                	ld	s5,488(sp)
    80004630:	7b1e                	ld	s6,480(sp)
    80004632:	6bfe                	ld	s7,472(sp)
    80004634:	6c5e                	ld	s8,464(sp)
    80004636:	6cbe                	ld	s9,456(sp)
    80004638:	6d1e                	ld	s10,448(sp)
    8000463a:	7dfa                	ld	s11,440(sp)
    8000463c:	b9c9                	j	8000430e <exec+0x78>
    8000463e:	df243c23          	sd	s2,-520(s0)
    80004642:	bff1                	j	8000461e <exec+0x388>
    80004644:	df243c23          	sd	s2,-520(s0)
    80004648:	bfd9                	j	8000461e <exec+0x388>
    8000464a:	df243c23          	sd	s2,-520(s0)
    8000464e:	bfc1                	j	8000461e <exec+0x388>
    80004650:	df243c23          	sd	s2,-520(s0)
    80004654:	b7e9                	j	8000461e <exec+0x388>
  sz = sz1;
    80004656:	89d2                	mv	s3,s4
    80004658:	b585                	j	800044b8 <exec+0x222>
    8000465a:	89d2                	mv	s3,s4
    8000465c:	bdb1                	j	800044b8 <exec+0x222>

000000008000465e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000465e:	7179                	addi	sp,sp,-48
    80004660:	f406                	sd	ra,40(sp)
    80004662:	f022                	sd	s0,32(sp)
    80004664:	ec26                	sd	s1,24(sp)
    80004666:	e84a                	sd	s2,16(sp)
    80004668:	1800                	addi	s0,sp,48
    8000466a:	892e                	mv	s2,a1
    8000466c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000466e:	fdc40593          	addi	a1,s0,-36
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	a36080e7          	jalr	-1482(ra) # 800020a8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000467a:	fdc42703          	lw	a4,-36(s0)
    8000467e:	47bd                	li	a5,15
    80004680:	02e7eb63          	bltu	a5,a4,800046b6 <argfd+0x58>
    80004684:	ffffd097          	auipc	ra,0xffffd
    80004688:	8f6080e7          	jalr	-1802(ra) # 80000f7a <myproc>
    8000468c:	fdc42703          	lw	a4,-36(s0)
    80004690:	01a70793          	addi	a5,a4,26
    80004694:	078e                	slli	a5,a5,0x3
    80004696:	953e                	add	a0,a0,a5
    80004698:	611c                	ld	a5,0(a0)
    8000469a:	c385                	beqz	a5,800046ba <argfd+0x5c>
    return -1;
  if(pfd)
    8000469c:	00090463          	beqz	s2,800046a4 <argfd+0x46>
    *pfd = fd;
    800046a0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046a4:	4501                	li	a0,0
  if(pf)
    800046a6:	c091                	beqz	s1,800046aa <argfd+0x4c>
    *pf = f;
    800046a8:	e09c                	sd	a5,0(s1)
}
    800046aa:	70a2                	ld	ra,40(sp)
    800046ac:	7402                	ld	s0,32(sp)
    800046ae:	64e2                	ld	s1,24(sp)
    800046b0:	6942                	ld	s2,16(sp)
    800046b2:	6145                	addi	sp,sp,48
    800046b4:	8082                	ret
    return -1;
    800046b6:	557d                	li	a0,-1
    800046b8:	bfcd                	j	800046aa <argfd+0x4c>
    800046ba:	557d                	li	a0,-1
    800046bc:	b7fd                	j	800046aa <argfd+0x4c>

00000000800046be <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046be:	1101                	addi	sp,sp,-32
    800046c0:	ec06                	sd	ra,24(sp)
    800046c2:	e822                	sd	s0,16(sp)
    800046c4:	e426                	sd	s1,8(sp)
    800046c6:	1000                	addi	s0,sp,32
    800046c8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046ca:	ffffd097          	auipc	ra,0xffffd
    800046ce:	8b0080e7          	jalr	-1872(ra) # 80000f7a <myproc>
    800046d2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046d4:	0d050793          	addi	a5,a0,208
    800046d8:	4501                	li	a0,0
    800046da:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046dc:	6398                	ld	a4,0(a5)
    800046de:	cb19                	beqz	a4,800046f4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046e0:	2505                	addiw	a0,a0,1
    800046e2:	07a1                	addi	a5,a5,8
    800046e4:	fed51ce3          	bne	a0,a3,800046dc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046e8:	557d                	li	a0,-1
}
    800046ea:	60e2                	ld	ra,24(sp)
    800046ec:	6442                	ld	s0,16(sp)
    800046ee:	64a2                	ld	s1,8(sp)
    800046f0:	6105                	addi	sp,sp,32
    800046f2:	8082                	ret
      p->ofile[fd] = f;
    800046f4:	01a50793          	addi	a5,a0,26
    800046f8:	078e                	slli	a5,a5,0x3
    800046fa:	963e                	add	a2,a2,a5
    800046fc:	e204                	sd	s1,0(a2)
      return fd;
    800046fe:	b7f5                	j	800046ea <fdalloc+0x2c>

0000000080004700 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004700:	715d                	addi	sp,sp,-80
    80004702:	e486                	sd	ra,72(sp)
    80004704:	e0a2                	sd	s0,64(sp)
    80004706:	fc26                	sd	s1,56(sp)
    80004708:	f84a                	sd	s2,48(sp)
    8000470a:	f44e                	sd	s3,40(sp)
    8000470c:	ec56                	sd	s5,24(sp)
    8000470e:	e85a                	sd	s6,16(sp)
    80004710:	0880                	addi	s0,sp,80
    80004712:	8b2e                	mv	s6,a1
    80004714:	89b2                	mv	s3,a2
    80004716:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004718:	fb040593          	addi	a1,s0,-80
    8000471c:	fffff097          	auipc	ra,0xfffff
    80004720:	db8080e7          	jalr	-584(ra) # 800034d4 <nameiparent>
    80004724:	84aa                	mv	s1,a0
    80004726:	14050e63          	beqz	a0,80004882 <create+0x182>
    return 0;

  ilock(dp);
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	5a8080e7          	jalr	1448(ra) # 80002cd2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004732:	4601                	li	a2,0
    80004734:	fb040593          	addi	a1,s0,-80
    80004738:	8526                	mv	a0,s1
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	a94080e7          	jalr	-1388(ra) # 800031ce <dirlookup>
    80004742:	8aaa                	mv	s5,a0
    80004744:	c539                	beqz	a0,80004792 <create+0x92>
    iunlockput(dp);
    80004746:	8526                	mv	a0,s1
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	7f0080e7          	jalr	2032(ra) # 80002f38 <iunlockput>
    ilock(ip);
    80004750:	8556                	mv	a0,s5
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	580080e7          	jalr	1408(ra) # 80002cd2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000475a:	4789                	li	a5,2
    8000475c:	02fb1463          	bne	s6,a5,80004784 <create+0x84>
    80004760:	044ad783          	lhu	a5,68(s5)
    80004764:	37f9                	addiw	a5,a5,-2
    80004766:	17c2                	slli	a5,a5,0x30
    80004768:	93c1                	srli	a5,a5,0x30
    8000476a:	4705                	li	a4,1
    8000476c:	00f76c63          	bltu	a4,a5,80004784 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004770:	8556                	mv	a0,s5
    80004772:	60a6                	ld	ra,72(sp)
    80004774:	6406                	ld	s0,64(sp)
    80004776:	74e2                	ld	s1,56(sp)
    80004778:	7942                	ld	s2,48(sp)
    8000477a:	79a2                	ld	s3,40(sp)
    8000477c:	6ae2                	ld	s5,24(sp)
    8000477e:	6b42                	ld	s6,16(sp)
    80004780:	6161                	addi	sp,sp,80
    80004782:	8082                	ret
    iunlockput(ip);
    80004784:	8556                	mv	a0,s5
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	7b2080e7          	jalr	1970(ra) # 80002f38 <iunlockput>
    return 0;
    8000478e:	4a81                	li	s5,0
    80004790:	b7c5                	j	80004770 <create+0x70>
    80004792:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004794:	85da                	mv	a1,s6
    80004796:	4088                	lw	a0,0(s1)
    80004798:	ffffe097          	auipc	ra,0xffffe
    8000479c:	396080e7          	jalr	918(ra) # 80002b2e <ialloc>
    800047a0:	8a2a                	mv	s4,a0
    800047a2:	c531                	beqz	a0,800047ee <create+0xee>
  ilock(ip);
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	52e080e7          	jalr	1326(ra) # 80002cd2 <ilock>
  ip->major = major;
    800047ac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047b0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047b4:	4905                	li	s2,1
    800047b6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800047ba:	8552                	mv	a0,s4
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	44a080e7          	jalr	1098(ra) # 80002c06 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047c4:	032b0d63          	beq	s6,s2,800047fe <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800047c8:	004a2603          	lw	a2,4(s4)
    800047cc:	fb040593          	addi	a1,s0,-80
    800047d0:	8526                	mv	a0,s1
    800047d2:	fffff097          	auipc	ra,0xfffff
    800047d6:	c22080e7          	jalr	-990(ra) # 800033f4 <dirlink>
    800047da:	08054163          	bltz	a0,8000485c <create+0x15c>
  iunlockput(dp);
    800047de:	8526                	mv	a0,s1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	758080e7          	jalr	1880(ra) # 80002f38 <iunlockput>
  return ip;
    800047e8:	8ad2                	mv	s5,s4
    800047ea:	7a02                	ld	s4,32(sp)
    800047ec:	b751                	j	80004770 <create+0x70>
    iunlockput(dp);
    800047ee:	8526                	mv	a0,s1
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	748080e7          	jalr	1864(ra) # 80002f38 <iunlockput>
    return 0;
    800047f8:	8ad2                	mv	s5,s4
    800047fa:	7a02                	ld	s4,32(sp)
    800047fc:	bf95                	j	80004770 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047fe:	004a2603          	lw	a2,4(s4)
    80004802:	00004597          	auipc	a1,0x4
    80004806:	e7e58593          	addi	a1,a1,-386 # 80008680 <etext+0x680>
    8000480a:	8552                	mv	a0,s4
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	be8080e7          	jalr	-1048(ra) # 800033f4 <dirlink>
    80004814:	04054463          	bltz	a0,8000485c <create+0x15c>
    80004818:	40d0                	lw	a2,4(s1)
    8000481a:	00004597          	auipc	a1,0x4
    8000481e:	e6e58593          	addi	a1,a1,-402 # 80008688 <etext+0x688>
    80004822:	8552                	mv	a0,s4
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	bd0080e7          	jalr	-1072(ra) # 800033f4 <dirlink>
    8000482c:	02054863          	bltz	a0,8000485c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004830:	004a2603          	lw	a2,4(s4)
    80004834:	fb040593          	addi	a1,s0,-80
    80004838:	8526                	mv	a0,s1
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	bba080e7          	jalr	-1094(ra) # 800033f4 <dirlink>
    80004842:	00054d63          	bltz	a0,8000485c <create+0x15c>
    dp->nlink++;  // for ".."
    80004846:	04a4d783          	lhu	a5,74(s1)
    8000484a:	2785                	addiw	a5,a5,1
    8000484c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004850:	8526                	mv	a0,s1
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	3b4080e7          	jalr	948(ra) # 80002c06 <iupdate>
    8000485a:	b751                	j	800047de <create+0xde>
  ip->nlink = 0;
    8000485c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004860:	8552                	mv	a0,s4
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	3a4080e7          	jalr	932(ra) # 80002c06 <iupdate>
  iunlockput(ip);
    8000486a:	8552                	mv	a0,s4
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	6cc080e7          	jalr	1740(ra) # 80002f38 <iunlockput>
  iunlockput(dp);
    80004874:	8526                	mv	a0,s1
    80004876:	ffffe097          	auipc	ra,0xffffe
    8000487a:	6c2080e7          	jalr	1730(ra) # 80002f38 <iunlockput>
  return 0;
    8000487e:	7a02                	ld	s4,32(sp)
    80004880:	bdc5                	j	80004770 <create+0x70>
    return 0;
    80004882:	8aaa                	mv	s5,a0
    80004884:	b5f5                	j	80004770 <create+0x70>

0000000080004886 <sys_dup>:
{
    80004886:	7179                	addi	sp,sp,-48
    80004888:	f406                	sd	ra,40(sp)
    8000488a:	f022                	sd	s0,32(sp)
    8000488c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000488e:	fd840613          	addi	a2,s0,-40
    80004892:	4581                	li	a1,0
    80004894:	4501                	li	a0,0
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	dc8080e7          	jalr	-568(ra) # 8000465e <argfd>
    return -1;
    8000489e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048a0:	02054763          	bltz	a0,800048ce <sys_dup+0x48>
    800048a4:	ec26                	sd	s1,24(sp)
    800048a6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800048a8:	fd843903          	ld	s2,-40(s0)
    800048ac:	854a                	mv	a0,s2
    800048ae:	00000097          	auipc	ra,0x0
    800048b2:	e10080e7          	jalr	-496(ra) # 800046be <fdalloc>
    800048b6:	84aa                	mv	s1,a0
    return -1;
    800048b8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048ba:	00054f63          	bltz	a0,800048d8 <sys_dup+0x52>
  filedup(f);
    800048be:	854a                	mv	a0,s2
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	27a080e7          	jalr	634(ra) # 80003b3a <filedup>
  return fd;
    800048c8:	87a6                	mv	a5,s1
    800048ca:	64e2                	ld	s1,24(sp)
    800048cc:	6942                	ld	s2,16(sp)
}
    800048ce:	853e                	mv	a0,a5
    800048d0:	70a2                	ld	ra,40(sp)
    800048d2:	7402                	ld	s0,32(sp)
    800048d4:	6145                	addi	sp,sp,48
    800048d6:	8082                	ret
    800048d8:	64e2                	ld	s1,24(sp)
    800048da:	6942                	ld	s2,16(sp)
    800048dc:	bfcd                	j	800048ce <sys_dup+0x48>

00000000800048de <sys_read>:
{
    800048de:	7179                	addi	sp,sp,-48
    800048e0:	f406                	sd	ra,40(sp)
    800048e2:	f022                	sd	s0,32(sp)
    800048e4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048e6:	fd840593          	addi	a1,s0,-40
    800048ea:	4505                	li	a0,1
    800048ec:	ffffd097          	auipc	ra,0xffffd
    800048f0:	7dc080e7          	jalr	2012(ra) # 800020c8 <argaddr>
  argint(2, &n);
    800048f4:	fe440593          	addi	a1,s0,-28
    800048f8:	4509                	li	a0,2
    800048fa:	ffffd097          	auipc	ra,0xffffd
    800048fe:	7ae080e7          	jalr	1966(ra) # 800020a8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004902:	fe840613          	addi	a2,s0,-24
    80004906:	4581                	li	a1,0
    80004908:	4501                	li	a0,0
    8000490a:	00000097          	auipc	ra,0x0
    8000490e:	d54080e7          	jalr	-684(ra) # 8000465e <argfd>
    80004912:	87aa                	mv	a5,a0
    return -1;
    80004914:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004916:	0007cc63          	bltz	a5,8000492e <sys_read+0x50>
  return fileread(f, p, n);
    8000491a:	fe442603          	lw	a2,-28(s0)
    8000491e:	fd843583          	ld	a1,-40(s0)
    80004922:	fe843503          	ld	a0,-24(s0)
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	3ba080e7          	jalr	954(ra) # 80003ce0 <fileread>
}
    8000492e:	70a2                	ld	ra,40(sp)
    80004930:	7402                	ld	s0,32(sp)
    80004932:	6145                	addi	sp,sp,48
    80004934:	8082                	ret

0000000080004936 <sys_write>:
{
    80004936:	7179                	addi	sp,sp,-48
    80004938:	f406                	sd	ra,40(sp)
    8000493a:	f022                	sd	s0,32(sp)
    8000493c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000493e:	fd840593          	addi	a1,s0,-40
    80004942:	4505                	li	a0,1
    80004944:	ffffd097          	auipc	ra,0xffffd
    80004948:	784080e7          	jalr	1924(ra) # 800020c8 <argaddr>
  argint(2, &n);
    8000494c:	fe440593          	addi	a1,s0,-28
    80004950:	4509                	li	a0,2
    80004952:	ffffd097          	auipc	ra,0xffffd
    80004956:	756080e7          	jalr	1878(ra) # 800020a8 <argint>
  if(argfd(0, 0, &f) < 0)
    8000495a:	fe840613          	addi	a2,s0,-24
    8000495e:	4581                	li	a1,0
    80004960:	4501                	li	a0,0
    80004962:	00000097          	auipc	ra,0x0
    80004966:	cfc080e7          	jalr	-772(ra) # 8000465e <argfd>
    8000496a:	87aa                	mv	a5,a0
    return -1;
    8000496c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000496e:	0007cc63          	bltz	a5,80004986 <sys_write+0x50>
  return filewrite(f, p, n);
    80004972:	fe442603          	lw	a2,-28(s0)
    80004976:	fd843583          	ld	a1,-40(s0)
    8000497a:	fe843503          	ld	a0,-24(s0)
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	434080e7          	jalr	1076(ra) # 80003db2 <filewrite>
}
    80004986:	70a2                	ld	ra,40(sp)
    80004988:	7402                	ld	s0,32(sp)
    8000498a:	6145                	addi	sp,sp,48
    8000498c:	8082                	ret

000000008000498e <sys_close>:
{
    8000498e:	1101                	addi	sp,sp,-32
    80004990:	ec06                	sd	ra,24(sp)
    80004992:	e822                	sd	s0,16(sp)
    80004994:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004996:	fe040613          	addi	a2,s0,-32
    8000499a:	fec40593          	addi	a1,s0,-20
    8000499e:	4501                	li	a0,0
    800049a0:	00000097          	auipc	ra,0x0
    800049a4:	cbe080e7          	jalr	-834(ra) # 8000465e <argfd>
    return -1;
    800049a8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049aa:	02054463          	bltz	a0,800049d2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	5cc080e7          	jalr	1484(ra) # 80000f7a <myproc>
    800049b6:	fec42783          	lw	a5,-20(s0)
    800049ba:	07e9                	addi	a5,a5,26
    800049bc:	078e                	slli	a5,a5,0x3
    800049be:	953e                	add	a0,a0,a5
    800049c0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800049c4:	fe043503          	ld	a0,-32(s0)
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	1c4080e7          	jalr	452(ra) # 80003b8c <fileclose>
  return 0;
    800049d0:	4781                	li	a5,0
}
    800049d2:	853e                	mv	a0,a5
    800049d4:	60e2                	ld	ra,24(sp)
    800049d6:	6442                	ld	s0,16(sp)
    800049d8:	6105                	addi	sp,sp,32
    800049da:	8082                	ret

00000000800049dc <sys_fstat>:
{
    800049dc:	1101                	addi	sp,sp,-32
    800049de:	ec06                	sd	ra,24(sp)
    800049e0:	e822                	sd	s0,16(sp)
    800049e2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049e4:	fe040593          	addi	a1,s0,-32
    800049e8:	4505                	li	a0,1
    800049ea:	ffffd097          	auipc	ra,0xffffd
    800049ee:	6de080e7          	jalr	1758(ra) # 800020c8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049f2:	fe840613          	addi	a2,s0,-24
    800049f6:	4581                	li	a1,0
    800049f8:	4501                	li	a0,0
    800049fa:	00000097          	auipc	ra,0x0
    800049fe:	c64080e7          	jalr	-924(ra) # 8000465e <argfd>
    80004a02:	87aa                	mv	a5,a0
    return -1;
    80004a04:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a06:	0007ca63          	bltz	a5,80004a1a <sys_fstat+0x3e>
  return filestat(f, st);
    80004a0a:	fe043583          	ld	a1,-32(s0)
    80004a0e:	fe843503          	ld	a0,-24(s0)
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	258080e7          	jalr	600(ra) # 80003c6a <filestat>
}
    80004a1a:	60e2                	ld	ra,24(sp)
    80004a1c:	6442                	ld	s0,16(sp)
    80004a1e:	6105                	addi	sp,sp,32
    80004a20:	8082                	ret

0000000080004a22 <sys_link>:
{
    80004a22:	7169                	addi	sp,sp,-304
    80004a24:	f606                	sd	ra,296(sp)
    80004a26:	f222                	sd	s0,288(sp)
    80004a28:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a2a:	08000613          	li	a2,128
    80004a2e:	ed040593          	addi	a1,s0,-304
    80004a32:	4501                	li	a0,0
    80004a34:	ffffd097          	auipc	ra,0xffffd
    80004a38:	6b4080e7          	jalr	1716(ra) # 800020e8 <argstr>
    return -1;
    80004a3c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a3e:	12054663          	bltz	a0,80004b6a <sys_link+0x148>
    80004a42:	08000613          	li	a2,128
    80004a46:	f5040593          	addi	a1,s0,-176
    80004a4a:	4505                	li	a0,1
    80004a4c:	ffffd097          	auipc	ra,0xffffd
    80004a50:	69c080e7          	jalr	1692(ra) # 800020e8 <argstr>
    return -1;
    80004a54:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a56:	10054a63          	bltz	a0,80004b6a <sys_link+0x148>
    80004a5a:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	c60080e7          	jalr	-928(ra) # 800036bc <begin_op>
  if((ip = namei(old)) == 0){
    80004a64:	ed040513          	addi	a0,s0,-304
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	a4e080e7          	jalr	-1458(ra) # 800034b6 <namei>
    80004a70:	84aa                	mv	s1,a0
    80004a72:	c949                	beqz	a0,80004b04 <sys_link+0xe2>
  ilock(ip);
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	25e080e7          	jalr	606(ra) # 80002cd2 <ilock>
  if(ip->type == T_DIR){
    80004a7c:	04449703          	lh	a4,68(s1)
    80004a80:	4785                	li	a5,1
    80004a82:	08f70863          	beq	a4,a5,80004b12 <sys_link+0xf0>
    80004a86:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a88:	04a4d783          	lhu	a5,74(s1)
    80004a8c:	2785                	addiw	a5,a5,1
    80004a8e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	172080e7          	jalr	370(ra) # 80002c06 <iupdate>
  iunlock(ip);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	2fa080e7          	jalr	762(ra) # 80002d98 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004aa6:	fd040593          	addi	a1,s0,-48
    80004aaa:	f5040513          	addi	a0,s0,-176
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	a26080e7          	jalr	-1498(ra) # 800034d4 <nameiparent>
    80004ab6:	892a                	mv	s2,a0
    80004ab8:	cd35                	beqz	a0,80004b34 <sys_link+0x112>
  ilock(dp);
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	218080e7          	jalr	536(ra) # 80002cd2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ac2:	00092703          	lw	a4,0(s2)
    80004ac6:	409c                	lw	a5,0(s1)
    80004ac8:	06f71163          	bne	a4,a5,80004b2a <sys_link+0x108>
    80004acc:	40d0                	lw	a2,4(s1)
    80004ace:	fd040593          	addi	a1,s0,-48
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	fffff097          	auipc	ra,0xfffff
    80004ad8:	920080e7          	jalr	-1760(ra) # 800033f4 <dirlink>
    80004adc:	04054763          	bltz	a0,80004b2a <sys_link+0x108>
  iunlockput(dp);
    80004ae0:	854a                	mv	a0,s2
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	456080e7          	jalr	1110(ra) # 80002f38 <iunlockput>
  iput(ip);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	3a4080e7          	jalr	932(ra) # 80002e90 <iput>
  end_op();
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	c42080e7          	jalr	-958(ra) # 80003736 <end_op>
  return 0;
    80004afc:	4781                	li	a5,0
    80004afe:	64f2                	ld	s1,280(sp)
    80004b00:	6952                	ld	s2,272(sp)
    80004b02:	a0a5                	j	80004b6a <sys_link+0x148>
    end_op();
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	c32080e7          	jalr	-974(ra) # 80003736 <end_op>
    return -1;
    80004b0c:	57fd                	li	a5,-1
    80004b0e:	64f2                	ld	s1,280(sp)
    80004b10:	a8a9                	j	80004b6a <sys_link+0x148>
    iunlockput(ip);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	424080e7          	jalr	1060(ra) # 80002f38 <iunlockput>
    end_op();
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	c1a080e7          	jalr	-998(ra) # 80003736 <end_op>
    return -1;
    80004b24:	57fd                	li	a5,-1
    80004b26:	64f2                	ld	s1,280(sp)
    80004b28:	a089                	j	80004b6a <sys_link+0x148>
    iunlockput(dp);
    80004b2a:	854a                	mv	a0,s2
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	40c080e7          	jalr	1036(ra) # 80002f38 <iunlockput>
  ilock(ip);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	19c080e7          	jalr	412(ra) # 80002cd2 <ilock>
  ip->nlink--;
    80004b3e:	04a4d783          	lhu	a5,74(s1)
    80004b42:	37fd                	addiw	a5,a5,-1
    80004b44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	0bc080e7          	jalr	188(ra) # 80002c06 <iupdate>
  iunlockput(ip);
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	3e4080e7          	jalr	996(ra) # 80002f38 <iunlockput>
  end_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	bda080e7          	jalr	-1062(ra) # 80003736 <end_op>
  return -1;
    80004b64:	57fd                	li	a5,-1
    80004b66:	64f2                	ld	s1,280(sp)
    80004b68:	6952                	ld	s2,272(sp)
}
    80004b6a:	853e                	mv	a0,a5
    80004b6c:	70b2                	ld	ra,296(sp)
    80004b6e:	7412                	ld	s0,288(sp)
    80004b70:	6155                	addi	sp,sp,304
    80004b72:	8082                	ret

0000000080004b74 <sys_unlink>:
{
    80004b74:	7111                	addi	sp,sp,-256
    80004b76:	fd86                	sd	ra,248(sp)
    80004b78:	f9a2                	sd	s0,240(sp)
    80004b7a:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004b7c:	08000613          	li	a2,128
    80004b80:	f2040593          	addi	a1,s0,-224
    80004b84:	4501                	li	a0,0
    80004b86:	ffffd097          	auipc	ra,0xffffd
    80004b8a:	562080e7          	jalr	1378(ra) # 800020e8 <argstr>
    80004b8e:	1c054063          	bltz	a0,80004d4e <sys_unlink+0x1da>
    80004b92:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004b94:	fffff097          	auipc	ra,0xfffff
    80004b98:	b28080e7          	jalr	-1240(ra) # 800036bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b9c:	fa040593          	addi	a1,s0,-96
    80004ba0:	f2040513          	addi	a0,s0,-224
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	930080e7          	jalr	-1744(ra) # 800034d4 <nameiparent>
    80004bac:	84aa                	mv	s1,a0
    80004bae:	c165                	beqz	a0,80004c8e <sys_unlink+0x11a>
  ilock(dp);
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	122080e7          	jalr	290(ra) # 80002cd2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bb8:	00004597          	auipc	a1,0x4
    80004bbc:	ac858593          	addi	a1,a1,-1336 # 80008680 <etext+0x680>
    80004bc0:	fa040513          	addi	a0,s0,-96
    80004bc4:	ffffe097          	auipc	ra,0xffffe
    80004bc8:	5f0080e7          	jalr	1520(ra) # 800031b4 <namecmp>
    80004bcc:	16050263          	beqz	a0,80004d30 <sys_unlink+0x1bc>
    80004bd0:	00004597          	auipc	a1,0x4
    80004bd4:	ab858593          	addi	a1,a1,-1352 # 80008688 <etext+0x688>
    80004bd8:	fa040513          	addi	a0,s0,-96
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	5d8080e7          	jalr	1496(ra) # 800031b4 <namecmp>
    80004be4:	14050663          	beqz	a0,80004d30 <sys_unlink+0x1bc>
    80004be8:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bea:	f1c40613          	addi	a2,s0,-228
    80004bee:	fa040593          	addi	a1,s0,-96
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	5da080e7          	jalr	1498(ra) # 800031ce <dirlookup>
    80004bfc:	892a                	mv	s2,a0
    80004bfe:	12050863          	beqz	a0,80004d2e <sys_unlink+0x1ba>
    80004c02:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	0ce080e7          	jalr	206(ra) # 80002cd2 <ilock>
  if(ip->nlink < 1)
    80004c0c:	04a91783          	lh	a5,74(s2)
    80004c10:	08f05663          	blez	a5,80004c9c <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c14:	04491703          	lh	a4,68(s2)
    80004c18:	4785                	li	a5,1
    80004c1a:	08f70b63          	beq	a4,a5,80004cb0 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80004c1e:	fb040993          	addi	s3,s0,-80
    80004c22:	4641                	li	a2,16
    80004c24:	4581                	li	a1,0
    80004c26:	854e                	mv	a0,s3
    80004c28:	ffffb097          	auipc	ra,0xffffb
    80004c2c:	59c080e7          	jalr	1436(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c30:	4741                	li	a4,16
    80004c32:	f1c42683          	lw	a3,-228(s0)
    80004c36:	864e                	mv	a2,s3
    80004c38:	4581                	li	a1,0
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	458080e7          	jalr	1112(ra) # 80003094 <writei>
    80004c44:	47c1                	li	a5,16
    80004c46:	0af51f63          	bne	a0,a5,80004d04 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80004c4a:	04491703          	lh	a4,68(s2)
    80004c4e:	4785                	li	a5,1
    80004c50:	0cf70463          	beq	a4,a5,80004d18 <sys_unlink+0x1a4>
  iunlockput(dp);
    80004c54:	8526                	mv	a0,s1
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	2e2080e7          	jalr	738(ra) # 80002f38 <iunlockput>
  ip->nlink--;
    80004c5e:	04a95783          	lhu	a5,74(s2)
    80004c62:	37fd                	addiw	a5,a5,-1
    80004c64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c68:	854a                	mv	a0,s2
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	f9c080e7          	jalr	-100(ra) # 80002c06 <iupdate>
  iunlockput(ip);
    80004c72:	854a                	mv	a0,s2
    80004c74:	ffffe097          	auipc	ra,0xffffe
    80004c78:	2c4080e7          	jalr	708(ra) # 80002f38 <iunlockput>
  end_op();
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	aba080e7          	jalr	-1350(ra) # 80003736 <end_op>
  return 0;
    80004c84:	4501                	li	a0,0
    80004c86:	74ae                	ld	s1,232(sp)
    80004c88:	790e                	ld	s2,224(sp)
    80004c8a:	69ee                	ld	s3,216(sp)
    80004c8c:	a86d                	j	80004d46 <sys_unlink+0x1d2>
    end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	aa8080e7          	jalr	-1368(ra) # 80003736 <end_op>
    return -1;
    80004c96:	557d                	li	a0,-1
    80004c98:	74ae                	ld	s1,232(sp)
    80004c9a:	a075                	j	80004d46 <sys_unlink+0x1d2>
    80004c9c:	e9d2                	sd	s4,208(sp)
    80004c9e:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004ca0:	00004517          	auipc	a0,0x4
    80004ca4:	9f050513          	addi	a0,a0,-1552 # 80008690 <etext+0x690>
    80004ca8:	00001097          	auipc	ra,0x1
    80004cac:	4b6080e7          	jalr	1206(ra) # 8000615e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cb0:	04c92703          	lw	a4,76(s2)
    80004cb4:	02000793          	li	a5,32
    80004cb8:	f6e7f3e3          	bgeu	a5,a4,80004c1e <sys_unlink+0xaa>
    80004cbc:	e9d2                	sd	s4,208(sp)
    80004cbe:	e5d6                	sd	s5,200(sp)
    80004cc0:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cc2:	f0840a93          	addi	s5,s0,-248
    80004cc6:	4a41                	li	s4,16
    80004cc8:	8752                	mv	a4,s4
    80004cca:	86ce                	mv	a3,s3
    80004ccc:	8656                	mv	a2,s5
    80004cce:	4581                	li	a1,0
    80004cd0:	854a                	mv	a0,s2
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	2bc080e7          	jalr	700(ra) # 80002f8e <readi>
    80004cda:	01451d63          	bne	a0,s4,80004cf4 <sys_unlink+0x180>
    if(de.inum != 0)
    80004cde:	f0845783          	lhu	a5,-248(s0)
    80004ce2:	eba5                	bnez	a5,80004d52 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce4:	29c1                	addiw	s3,s3,16
    80004ce6:	04c92783          	lw	a5,76(s2)
    80004cea:	fcf9efe3          	bltu	s3,a5,80004cc8 <sys_unlink+0x154>
    80004cee:	6a4e                	ld	s4,208(sp)
    80004cf0:	6aae                	ld	s5,200(sp)
    80004cf2:	b735                	j	80004c1e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cf4:	00004517          	auipc	a0,0x4
    80004cf8:	9b450513          	addi	a0,a0,-1612 # 800086a8 <etext+0x6a8>
    80004cfc:	00001097          	auipc	ra,0x1
    80004d00:	462080e7          	jalr	1122(ra) # 8000615e <panic>
    80004d04:	e9d2                	sd	s4,208(sp)
    80004d06:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004d08:	00004517          	auipc	a0,0x4
    80004d0c:	9b850513          	addi	a0,a0,-1608 # 800086c0 <etext+0x6c0>
    80004d10:	00001097          	auipc	ra,0x1
    80004d14:	44e080e7          	jalr	1102(ra) # 8000615e <panic>
    dp->nlink--;
    80004d18:	04a4d783          	lhu	a5,74(s1)
    80004d1c:	37fd                	addiw	a5,a5,-1
    80004d1e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d22:	8526                	mv	a0,s1
    80004d24:	ffffe097          	auipc	ra,0xffffe
    80004d28:	ee2080e7          	jalr	-286(ra) # 80002c06 <iupdate>
    80004d2c:	b725                	j	80004c54 <sys_unlink+0xe0>
    80004d2e:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004d30:	8526                	mv	a0,s1
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	206080e7          	jalr	518(ra) # 80002f38 <iunlockput>
  end_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	9fc080e7          	jalr	-1540(ra) # 80003736 <end_op>
  return -1;
    80004d42:	557d                	li	a0,-1
    80004d44:	74ae                	ld	s1,232(sp)
}
    80004d46:	70ee                	ld	ra,248(sp)
    80004d48:	744e                	ld	s0,240(sp)
    80004d4a:	6111                	addi	sp,sp,256
    80004d4c:	8082                	ret
    return -1;
    80004d4e:	557d                	li	a0,-1
    80004d50:	bfdd                	j	80004d46 <sys_unlink+0x1d2>
    iunlockput(ip);
    80004d52:	854a                	mv	a0,s2
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	1e4080e7          	jalr	484(ra) # 80002f38 <iunlockput>
    goto bad;
    80004d5c:	790e                	ld	s2,224(sp)
    80004d5e:	69ee                	ld	s3,216(sp)
    80004d60:	6a4e                	ld	s4,208(sp)
    80004d62:	6aae                	ld	s5,200(sp)
    80004d64:	b7f1                	j	80004d30 <sys_unlink+0x1bc>

0000000080004d66 <sys_open>:

uint64
sys_open(void)
{
    80004d66:	7131                	addi	sp,sp,-192
    80004d68:	fd06                	sd	ra,184(sp)
    80004d6a:	f922                	sd	s0,176(sp)
    80004d6c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d6e:	f4c40593          	addi	a1,s0,-180
    80004d72:	4505                	li	a0,1
    80004d74:	ffffd097          	auipc	ra,0xffffd
    80004d78:	334080e7          	jalr	820(ra) # 800020a8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d7c:	08000613          	li	a2,128
    80004d80:	f5040593          	addi	a1,s0,-176
    80004d84:	4501                	li	a0,0
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	362080e7          	jalr	866(ra) # 800020e8 <argstr>
    80004d8e:	87aa                	mv	a5,a0
    return -1;
    80004d90:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d92:	0a07cf63          	bltz	a5,80004e50 <sys_open+0xea>
    80004d96:	f526                	sd	s1,168(sp)

  begin_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	924080e7          	jalr	-1756(ra) # 800036bc <begin_op>

  if(omode & O_CREATE){
    80004da0:	f4c42783          	lw	a5,-180(s0)
    80004da4:	2007f793          	andi	a5,a5,512
    80004da8:	cfdd                	beqz	a5,80004e66 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004daa:	4681                	li	a3,0
    80004dac:	4601                	li	a2,0
    80004dae:	4589                	li	a1,2
    80004db0:	f5040513          	addi	a0,s0,-176
    80004db4:	00000097          	auipc	ra,0x0
    80004db8:	94c080e7          	jalr	-1716(ra) # 80004700 <create>
    80004dbc:	84aa                	mv	s1,a0
    if(ip == 0){
    80004dbe:	cd49                	beqz	a0,80004e58 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004dc0:	04449703          	lh	a4,68(s1)
    80004dc4:	478d                	li	a5,3
    80004dc6:	00f71763          	bne	a4,a5,80004dd4 <sys_open+0x6e>
    80004dca:	0464d703          	lhu	a4,70(s1)
    80004dce:	47a5                	li	a5,9
    80004dd0:	0ee7e263          	bltu	a5,a4,80004eb4 <sys_open+0x14e>
    80004dd4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	cfa080e7          	jalr	-774(ra) # 80003ad0 <filealloc>
    80004dde:	892a                	mv	s2,a0
    80004de0:	cd65                	beqz	a0,80004ed8 <sys_open+0x172>
    80004de2:	ed4e                	sd	s3,152(sp)
    80004de4:	00000097          	auipc	ra,0x0
    80004de8:	8da080e7          	jalr	-1830(ra) # 800046be <fdalloc>
    80004dec:	89aa                	mv	s3,a0
    80004dee:	0c054f63          	bltz	a0,80004ecc <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004df2:	04449703          	lh	a4,68(s1)
    80004df6:	478d                	li	a5,3
    80004df8:	0ef70d63          	beq	a4,a5,80004ef2 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dfc:	4789                	li	a5,2
    80004dfe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e02:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e06:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e0a:	f4c42783          	lw	a5,-180(s0)
    80004e0e:	0017f713          	andi	a4,a5,1
    80004e12:	00174713          	xori	a4,a4,1
    80004e16:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e1a:	0037f713          	andi	a4,a5,3
    80004e1e:	00e03733          	snez	a4,a4
    80004e22:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e26:	4007f793          	andi	a5,a5,1024
    80004e2a:	c791                	beqz	a5,80004e36 <sys_open+0xd0>
    80004e2c:	04449703          	lh	a4,68(s1)
    80004e30:	4789                	li	a5,2
    80004e32:	0cf70763          	beq	a4,a5,80004f00 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80004e36:	8526                	mv	a0,s1
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	f60080e7          	jalr	-160(ra) # 80002d98 <iunlock>
  end_op();
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	8f6080e7          	jalr	-1802(ra) # 80003736 <end_op>

  return fd;
    80004e48:	854e                	mv	a0,s3
    80004e4a:	74aa                	ld	s1,168(sp)
    80004e4c:	790a                	ld	s2,160(sp)
    80004e4e:	69ea                	ld	s3,152(sp)
}
    80004e50:	70ea                	ld	ra,184(sp)
    80004e52:	744a                	ld	s0,176(sp)
    80004e54:	6129                	addi	sp,sp,192
    80004e56:	8082                	ret
      end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	8de080e7          	jalr	-1826(ra) # 80003736 <end_op>
      return -1;
    80004e60:	557d                	li	a0,-1
    80004e62:	74aa                	ld	s1,168(sp)
    80004e64:	b7f5                	j	80004e50 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80004e66:	f5040513          	addi	a0,s0,-176
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	64c080e7          	jalr	1612(ra) # 800034b6 <namei>
    80004e72:	84aa                	mv	s1,a0
    80004e74:	c90d                	beqz	a0,80004ea6 <sys_open+0x140>
    ilock(ip);
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	e5c080e7          	jalr	-420(ra) # 80002cd2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e7e:	04449703          	lh	a4,68(s1)
    80004e82:	4785                	li	a5,1
    80004e84:	f2f71ee3          	bne	a4,a5,80004dc0 <sys_open+0x5a>
    80004e88:	f4c42783          	lw	a5,-180(s0)
    80004e8c:	d7a1                	beqz	a5,80004dd4 <sys_open+0x6e>
      iunlockput(ip);
    80004e8e:	8526                	mv	a0,s1
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	0a8080e7          	jalr	168(ra) # 80002f38 <iunlockput>
      end_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	89e080e7          	jalr	-1890(ra) # 80003736 <end_op>
      return -1;
    80004ea0:	557d                	li	a0,-1
    80004ea2:	74aa                	ld	s1,168(sp)
    80004ea4:	b775                	j	80004e50 <sys_open+0xea>
      end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	890080e7          	jalr	-1904(ra) # 80003736 <end_op>
      return -1;
    80004eae:	557d                	li	a0,-1
    80004eb0:	74aa                	ld	s1,168(sp)
    80004eb2:	bf79                	j	80004e50 <sys_open+0xea>
    iunlockput(ip);
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	082080e7          	jalr	130(ra) # 80002f38 <iunlockput>
    end_op();
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	878080e7          	jalr	-1928(ra) # 80003736 <end_op>
    return -1;
    80004ec6:	557d                	li	a0,-1
    80004ec8:	74aa                	ld	s1,168(sp)
    80004eca:	b759                	j	80004e50 <sys_open+0xea>
      fileclose(f);
    80004ecc:	854a                	mv	a0,s2
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	cbe080e7          	jalr	-834(ra) # 80003b8c <fileclose>
    80004ed6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004ed8:	8526                	mv	a0,s1
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	05e080e7          	jalr	94(ra) # 80002f38 <iunlockput>
    end_op();
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	854080e7          	jalr	-1964(ra) # 80003736 <end_op>
    return -1;
    80004eea:	557d                	li	a0,-1
    80004eec:	74aa                	ld	s1,168(sp)
    80004eee:	790a                	ld	s2,160(sp)
    80004ef0:	b785                	j	80004e50 <sys_open+0xea>
    f->type = FD_DEVICE;
    80004ef2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ef6:	04649783          	lh	a5,70(s1)
    80004efa:	02f91223          	sh	a5,36(s2)
    80004efe:	b721                	j	80004e06 <sys_open+0xa0>
    itrunc(ip);
    80004f00:	8526                	mv	a0,s1
    80004f02:	ffffe097          	auipc	ra,0xffffe
    80004f06:	ee2080e7          	jalr	-286(ra) # 80002de4 <itrunc>
    80004f0a:	b735                	j	80004e36 <sys_open+0xd0>

0000000080004f0c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f0c:	7175                	addi	sp,sp,-144
    80004f0e:	e506                	sd	ra,136(sp)
    80004f10:	e122                	sd	s0,128(sp)
    80004f12:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	7a8080e7          	jalr	1960(ra) # 800036bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f1c:	08000613          	li	a2,128
    80004f20:	f7040593          	addi	a1,s0,-144
    80004f24:	4501                	li	a0,0
    80004f26:	ffffd097          	auipc	ra,0xffffd
    80004f2a:	1c2080e7          	jalr	450(ra) # 800020e8 <argstr>
    80004f2e:	02054963          	bltz	a0,80004f60 <sys_mkdir+0x54>
    80004f32:	4681                	li	a3,0
    80004f34:	4601                	li	a2,0
    80004f36:	4585                	li	a1,1
    80004f38:	f7040513          	addi	a0,s0,-144
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	7c4080e7          	jalr	1988(ra) # 80004700 <create>
    80004f44:	cd11                	beqz	a0,80004f60 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f46:	ffffe097          	auipc	ra,0xffffe
    80004f4a:	ff2080e7          	jalr	-14(ra) # 80002f38 <iunlockput>
  end_op();
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	7e8080e7          	jalr	2024(ra) # 80003736 <end_op>
  return 0;
    80004f56:	4501                	li	a0,0
}
    80004f58:	60aa                	ld	ra,136(sp)
    80004f5a:	640a                	ld	s0,128(sp)
    80004f5c:	6149                	addi	sp,sp,144
    80004f5e:	8082                	ret
    end_op();
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	7d6080e7          	jalr	2006(ra) # 80003736 <end_op>
    return -1;
    80004f68:	557d                	li	a0,-1
    80004f6a:	b7fd                	j	80004f58 <sys_mkdir+0x4c>

0000000080004f6c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f6c:	7135                	addi	sp,sp,-160
    80004f6e:	ed06                	sd	ra,152(sp)
    80004f70:	e922                	sd	s0,144(sp)
    80004f72:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	748080e7          	jalr	1864(ra) # 800036bc <begin_op>
  argint(1, &major);
    80004f7c:	f6c40593          	addi	a1,s0,-148
    80004f80:	4505                	li	a0,1
    80004f82:	ffffd097          	auipc	ra,0xffffd
    80004f86:	126080e7          	jalr	294(ra) # 800020a8 <argint>
  argint(2, &minor);
    80004f8a:	f6840593          	addi	a1,s0,-152
    80004f8e:	4509                	li	a0,2
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	118080e7          	jalr	280(ra) # 800020a8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f98:	08000613          	li	a2,128
    80004f9c:	f7040593          	addi	a1,s0,-144
    80004fa0:	4501                	li	a0,0
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	146080e7          	jalr	326(ra) # 800020e8 <argstr>
    80004faa:	02054b63          	bltz	a0,80004fe0 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fae:	f6841683          	lh	a3,-152(s0)
    80004fb2:	f6c41603          	lh	a2,-148(s0)
    80004fb6:	458d                	li	a1,3
    80004fb8:	f7040513          	addi	a0,s0,-144
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	744080e7          	jalr	1860(ra) # 80004700 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fc4:	cd11                	beqz	a0,80004fe0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	f72080e7          	jalr	-142(ra) # 80002f38 <iunlockput>
  end_op();
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	768080e7          	jalr	1896(ra) # 80003736 <end_op>
  return 0;
    80004fd6:	4501                	li	a0,0
}
    80004fd8:	60ea                	ld	ra,152(sp)
    80004fda:	644a                	ld	s0,144(sp)
    80004fdc:	610d                	addi	sp,sp,160
    80004fde:	8082                	ret
    end_op();
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	756080e7          	jalr	1878(ra) # 80003736 <end_op>
    return -1;
    80004fe8:	557d                	li	a0,-1
    80004fea:	b7fd                	j	80004fd8 <sys_mknod+0x6c>

0000000080004fec <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fec:	7135                	addi	sp,sp,-160
    80004fee:	ed06                	sd	ra,152(sp)
    80004ff0:	e922                	sd	s0,144(sp)
    80004ff2:	e14a                	sd	s2,128(sp)
    80004ff4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ff6:	ffffc097          	auipc	ra,0xffffc
    80004ffa:	f84080e7          	jalr	-124(ra) # 80000f7a <myproc>
    80004ffe:	892a                	mv	s2,a0
  
  begin_op();
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	6bc080e7          	jalr	1724(ra) # 800036bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005008:	08000613          	li	a2,128
    8000500c:	f6040593          	addi	a1,s0,-160
    80005010:	4501                	li	a0,0
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	0d6080e7          	jalr	214(ra) # 800020e8 <argstr>
    8000501a:	04054d63          	bltz	a0,80005074 <sys_chdir+0x88>
    8000501e:	e526                	sd	s1,136(sp)
    80005020:	f6040513          	addi	a0,s0,-160
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	492080e7          	jalr	1170(ra) # 800034b6 <namei>
    8000502c:	84aa                	mv	s1,a0
    8000502e:	c131                	beqz	a0,80005072 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005030:	ffffe097          	auipc	ra,0xffffe
    80005034:	ca2080e7          	jalr	-862(ra) # 80002cd2 <ilock>
  if(ip->type != T_DIR){
    80005038:	04449703          	lh	a4,68(s1)
    8000503c:	4785                	li	a5,1
    8000503e:	04f71163          	bne	a4,a5,80005080 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005042:	8526                	mv	a0,s1
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	d54080e7          	jalr	-684(ra) # 80002d98 <iunlock>
  iput(p->cwd);
    8000504c:	15093503          	ld	a0,336(s2)
    80005050:	ffffe097          	auipc	ra,0xffffe
    80005054:	e40080e7          	jalr	-448(ra) # 80002e90 <iput>
  end_op();
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	6de080e7          	jalr	1758(ra) # 80003736 <end_op>
  p->cwd = ip;
    80005060:	14993823          	sd	s1,336(s2)
  return 0;
    80005064:	4501                	li	a0,0
    80005066:	64aa                	ld	s1,136(sp)
}
    80005068:	60ea                	ld	ra,152(sp)
    8000506a:	644a                	ld	s0,144(sp)
    8000506c:	690a                	ld	s2,128(sp)
    8000506e:	610d                	addi	sp,sp,160
    80005070:	8082                	ret
    80005072:	64aa                	ld	s1,136(sp)
    end_op();
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	6c2080e7          	jalr	1730(ra) # 80003736 <end_op>
    return -1;
    8000507c:	557d                	li	a0,-1
    8000507e:	b7ed                	j	80005068 <sys_chdir+0x7c>
    iunlockput(ip);
    80005080:	8526                	mv	a0,s1
    80005082:	ffffe097          	auipc	ra,0xffffe
    80005086:	eb6080e7          	jalr	-330(ra) # 80002f38 <iunlockput>
    end_op();
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	6ac080e7          	jalr	1708(ra) # 80003736 <end_op>
    return -1;
    80005092:	557d                	li	a0,-1
    80005094:	64aa                	ld	s1,136(sp)
    80005096:	bfc9                	j	80005068 <sys_chdir+0x7c>

0000000080005098 <sys_exec>:

uint64
sys_exec(void)
{
    80005098:	7105                	addi	sp,sp,-480
    8000509a:	ef86                	sd	ra,472(sp)
    8000509c:	eba2                	sd	s0,464(sp)
    8000509e:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050a0:	e2840593          	addi	a1,s0,-472
    800050a4:	4505                	li	a0,1
    800050a6:	ffffd097          	auipc	ra,0xffffd
    800050aa:	022080e7          	jalr	34(ra) # 800020c8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800050ae:	08000613          	li	a2,128
    800050b2:	f3040593          	addi	a1,s0,-208
    800050b6:	4501                	li	a0,0
    800050b8:	ffffd097          	auipc	ra,0xffffd
    800050bc:	030080e7          	jalr	48(ra) # 800020e8 <argstr>
    800050c0:	87aa                	mv	a5,a0
    return -1;
    800050c2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800050c4:	0e07ce63          	bltz	a5,800051c0 <sys_exec+0x128>
    800050c8:	e7a6                	sd	s1,456(sp)
    800050ca:	e3ca                	sd	s2,448(sp)
    800050cc:	ff4e                	sd	s3,440(sp)
    800050ce:	fb52                	sd	s4,432(sp)
    800050d0:	f756                	sd	s5,424(sp)
    800050d2:	f35a                	sd	s6,416(sp)
    800050d4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050d6:	e3040a13          	addi	s4,s0,-464
    800050da:	10000613          	li	a2,256
    800050de:	4581                	li	a1,0
    800050e0:	8552                	mv	a0,s4
    800050e2:	ffffb097          	auipc	ra,0xffffb
    800050e6:	0e2080e7          	jalr	226(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050ea:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800050ec:	89d2                	mv	s3,s4
    800050ee:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050f0:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050f4:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800050f6:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050fa:	00391513          	slli	a0,s2,0x3
    800050fe:	85d6                	mv	a1,s5
    80005100:	e2843783          	ld	a5,-472(s0)
    80005104:	953e                	add	a0,a0,a5
    80005106:	ffffd097          	auipc	ra,0xffffd
    8000510a:	f04080e7          	jalr	-252(ra) # 8000200a <fetchaddr>
    8000510e:	02054a63          	bltz	a0,80005142 <sys_exec+0xaa>
    if(uarg == 0){
    80005112:	e2043783          	ld	a5,-480(s0)
    80005116:	cbb1                	beqz	a5,8000516a <sys_exec+0xd2>
    argv[i] = kalloc();
    80005118:	ffffb097          	auipc	ra,0xffffb
    8000511c:	002080e7          	jalr	2(ra) # 8000011a <kalloc>
    80005120:	85aa                	mv	a1,a0
    80005122:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005126:	cd11                	beqz	a0,80005142 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005128:	865a                	mv	a2,s6
    8000512a:	e2043503          	ld	a0,-480(s0)
    8000512e:	ffffd097          	auipc	ra,0xffffd
    80005132:	f2e080e7          	jalr	-210(ra) # 8000205c <fetchstr>
    80005136:	00054663          	bltz	a0,80005142 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    8000513a:	0905                	addi	s2,s2,1
    8000513c:	09a1                	addi	s3,s3,8
    8000513e:	fb791ee3          	bne	s2,s7,800050fa <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005142:	100a0a13          	addi	s4,s4,256
    80005146:	6088                	ld	a0,0(s1)
    80005148:	c525                	beqz	a0,800051b0 <sys_exec+0x118>
    kfree(argv[i]);
    8000514a:	ffffb097          	auipc	ra,0xffffb
    8000514e:	ed2080e7          	jalr	-302(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005152:	04a1                	addi	s1,s1,8
    80005154:	ff4499e3          	bne	s1,s4,80005146 <sys_exec+0xae>
  return -1;
    80005158:	557d                	li	a0,-1
    8000515a:	64be                	ld	s1,456(sp)
    8000515c:	691e                	ld	s2,448(sp)
    8000515e:	79fa                	ld	s3,440(sp)
    80005160:	7a5a                	ld	s4,432(sp)
    80005162:	7aba                	ld	s5,424(sp)
    80005164:	7b1a                	ld	s6,416(sp)
    80005166:	6bfa                	ld	s7,408(sp)
    80005168:	a8a1                	j	800051c0 <sys_exec+0x128>
      argv[i] = 0;
    8000516a:	0009079b          	sext.w	a5,s2
    8000516e:	e3040593          	addi	a1,s0,-464
    80005172:	078e                	slli	a5,a5,0x3
    80005174:	97ae                	add	a5,a5,a1
    80005176:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    8000517a:	f3040513          	addi	a0,s0,-208
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	118080e7          	jalr	280(ra) # 80004296 <exec>
    80005186:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005188:	100a0a13          	addi	s4,s4,256
    8000518c:	6088                	ld	a0,0(s1)
    8000518e:	c901                	beqz	a0,8000519e <sys_exec+0x106>
    kfree(argv[i]);
    80005190:	ffffb097          	auipc	ra,0xffffb
    80005194:	e8c080e7          	jalr	-372(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005198:	04a1                	addi	s1,s1,8
    8000519a:	ff4499e3          	bne	s1,s4,8000518c <sys_exec+0xf4>
  return ret;
    8000519e:	854a                	mv	a0,s2
    800051a0:	64be                	ld	s1,456(sp)
    800051a2:	691e                	ld	s2,448(sp)
    800051a4:	79fa                	ld	s3,440(sp)
    800051a6:	7a5a                	ld	s4,432(sp)
    800051a8:	7aba                	ld	s5,424(sp)
    800051aa:	7b1a                	ld	s6,416(sp)
    800051ac:	6bfa                	ld	s7,408(sp)
    800051ae:	a809                	j	800051c0 <sys_exec+0x128>
  return -1;
    800051b0:	557d                	li	a0,-1
    800051b2:	64be                	ld	s1,456(sp)
    800051b4:	691e                	ld	s2,448(sp)
    800051b6:	79fa                	ld	s3,440(sp)
    800051b8:	7a5a                	ld	s4,432(sp)
    800051ba:	7aba                	ld	s5,424(sp)
    800051bc:	7b1a                	ld	s6,416(sp)
    800051be:	6bfa                	ld	s7,408(sp)
}
    800051c0:	60fe                	ld	ra,472(sp)
    800051c2:	645e                	ld	s0,464(sp)
    800051c4:	613d                	addi	sp,sp,480
    800051c6:	8082                	ret

00000000800051c8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051c8:	7139                	addi	sp,sp,-64
    800051ca:	fc06                	sd	ra,56(sp)
    800051cc:	f822                	sd	s0,48(sp)
    800051ce:	f426                	sd	s1,40(sp)
    800051d0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051d2:	ffffc097          	auipc	ra,0xffffc
    800051d6:	da8080e7          	jalr	-600(ra) # 80000f7a <myproc>
    800051da:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800051dc:	fd840593          	addi	a1,s0,-40
    800051e0:	4501                	li	a0,0
    800051e2:	ffffd097          	auipc	ra,0xffffd
    800051e6:	ee6080e7          	jalr	-282(ra) # 800020c8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800051ea:	fc840593          	addi	a1,s0,-56
    800051ee:	fd040513          	addi	a0,s0,-48
    800051f2:	fffff097          	auipc	ra,0xfffff
    800051f6:	d0e080e7          	jalr	-754(ra) # 80003f00 <pipealloc>
    return -1;
    800051fa:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051fc:	0c054463          	bltz	a0,800052c4 <sys_pipe+0xfc>
  fd0 = -1;
    80005200:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005204:	fd043503          	ld	a0,-48(s0)
    80005208:	fffff097          	auipc	ra,0xfffff
    8000520c:	4b6080e7          	jalr	1206(ra) # 800046be <fdalloc>
    80005210:	fca42223          	sw	a0,-60(s0)
    80005214:	08054b63          	bltz	a0,800052aa <sys_pipe+0xe2>
    80005218:	fc843503          	ld	a0,-56(s0)
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	4a2080e7          	jalr	1186(ra) # 800046be <fdalloc>
    80005224:	fca42023          	sw	a0,-64(s0)
    80005228:	06054863          	bltz	a0,80005298 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000522c:	4691                	li	a3,4
    8000522e:	fc440613          	addi	a2,s0,-60
    80005232:	fd843583          	ld	a1,-40(s0)
    80005236:	68a8                	ld	a0,80(s1)
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	98a080e7          	jalr	-1654(ra) # 80000bc2 <copyout>
    80005240:	02054063          	bltz	a0,80005260 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005244:	4691                	li	a3,4
    80005246:	fc040613          	addi	a2,s0,-64
    8000524a:	fd843583          	ld	a1,-40(s0)
    8000524e:	95b6                	add	a1,a1,a3
    80005250:	68a8                	ld	a0,80(s1)
    80005252:	ffffc097          	auipc	ra,0xffffc
    80005256:	970080e7          	jalr	-1680(ra) # 80000bc2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000525a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000525c:	06055463          	bgez	a0,800052c4 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005260:	fc442783          	lw	a5,-60(s0)
    80005264:	07e9                	addi	a5,a5,26
    80005266:	078e                	slli	a5,a5,0x3
    80005268:	97a6                	add	a5,a5,s1
    8000526a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000526e:	fc042783          	lw	a5,-64(s0)
    80005272:	07e9                	addi	a5,a5,26
    80005274:	078e                	slli	a5,a5,0x3
    80005276:	94be                	add	s1,s1,a5
    80005278:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000527c:	fd043503          	ld	a0,-48(s0)
    80005280:	fffff097          	auipc	ra,0xfffff
    80005284:	90c080e7          	jalr	-1780(ra) # 80003b8c <fileclose>
    fileclose(wf);
    80005288:	fc843503          	ld	a0,-56(s0)
    8000528c:	fffff097          	auipc	ra,0xfffff
    80005290:	900080e7          	jalr	-1792(ra) # 80003b8c <fileclose>
    return -1;
    80005294:	57fd                	li	a5,-1
    80005296:	a03d                	j	800052c4 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005298:	fc442783          	lw	a5,-60(s0)
    8000529c:	0007c763          	bltz	a5,800052aa <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800052a0:	07e9                	addi	a5,a5,26
    800052a2:	078e                	slli	a5,a5,0x3
    800052a4:	97a6                	add	a5,a5,s1
    800052a6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800052aa:	fd043503          	ld	a0,-48(s0)
    800052ae:	fffff097          	auipc	ra,0xfffff
    800052b2:	8de080e7          	jalr	-1826(ra) # 80003b8c <fileclose>
    fileclose(wf);
    800052b6:	fc843503          	ld	a0,-56(s0)
    800052ba:	fffff097          	auipc	ra,0xfffff
    800052be:	8d2080e7          	jalr	-1838(ra) # 80003b8c <fileclose>
    return -1;
    800052c2:	57fd                	li	a5,-1
}
    800052c4:	853e                	mv	a0,a5
    800052c6:	70e2                	ld	ra,56(sp)
    800052c8:	7442                	ld	s0,48(sp)
    800052ca:	74a2                	ld	s1,40(sp)
    800052cc:	6121                	addi	sp,sp,64
    800052ce:	8082                	ret

00000000800052d0 <kernelvec>:
    800052d0:	7111                	addi	sp,sp,-256
    800052d2:	e006                	sd	ra,0(sp)
    800052d4:	e40a                	sd	sp,8(sp)
    800052d6:	e80e                	sd	gp,16(sp)
    800052d8:	ec12                	sd	tp,24(sp)
    800052da:	f016                	sd	t0,32(sp)
    800052dc:	f41a                	sd	t1,40(sp)
    800052de:	f81e                	sd	t2,48(sp)
    800052e0:	e4aa                	sd	a0,72(sp)
    800052e2:	e8ae                	sd	a1,80(sp)
    800052e4:	ecb2                	sd	a2,88(sp)
    800052e6:	f0b6                	sd	a3,96(sp)
    800052e8:	f4ba                	sd	a4,104(sp)
    800052ea:	f8be                	sd	a5,112(sp)
    800052ec:	fcc2                	sd	a6,120(sp)
    800052ee:	e146                	sd	a7,128(sp)
    800052f0:	edf2                	sd	t3,216(sp)
    800052f2:	f1f6                	sd	t4,224(sp)
    800052f4:	f5fa                	sd	t5,232(sp)
    800052f6:	f9fe                	sd	t6,240(sp)
    800052f8:	bfffc0ef          	jal	80001ef6 <kerneltrap>
    800052fc:	6082                	ld	ra,0(sp)
    800052fe:	6122                	ld	sp,8(sp)
    80005300:	61c2                	ld	gp,16(sp)
    80005302:	7282                	ld	t0,32(sp)
    80005304:	7322                	ld	t1,40(sp)
    80005306:	73c2                	ld	t2,48(sp)
    80005308:	6526                	ld	a0,72(sp)
    8000530a:	65c6                	ld	a1,80(sp)
    8000530c:	6666                	ld	a2,88(sp)
    8000530e:	7686                	ld	a3,96(sp)
    80005310:	7726                	ld	a4,104(sp)
    80005312:	77c6                	ld	a5,112(sp)
    80005314:	7866                	ld	a6,120(sp)
    80005316:	688a                	ld	a7,128(sp)
    80005318:	6e6e                	ld	t3,216(sp)
    8000531a:	7e8e                	ld	t4,224(sp)
    8000531c:	7f2e                	ld	t5,232(sp)
    8000531e:	7fce                	ld	t6,240(sp)
    80005320:	6111                	addi	sp,sp,256
    80005322:	10200073          	sret
	...

000000008000532e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000532e:	1141                	addi	sp,sp,-16
    80005330:	e406                	sd	ra,8(sp)
    80005332:	e022                	sd	s0,0(sp)
    80005334:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005336:	0c000737          	lui	a4,0xc000
    8000533a:	4785                	li	a5,1
    8000533c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000533e:	c35c                	sw	a5,4(a4)
}
    80005340:	60a2                	ld	ra,8(sp)
    80005342:	6402                	ld	s0,0(sp)
    80005344:	0141                	addi	sp,sp,16
    80005346:	8082                	ret

0000000080005348 <plicinithart>:

void
plicinithart(void)
{
    80005348:	1141                	addi	sp,sp,-16
    8000534a:	e406                	sd	ra,8(sp)
    8000534c:	e022                	sd	s0,0(sp)
    8000534e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005350:	ffffc097          	auipc	ra,0xffffc
    80005354:	bf6080e7          	jalr	-1034(ra) # 80000f46 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005358:	0085171b          	slliw	a4,a0,0x8
    8000535c:	0c0027b7          	lui	a5,0xc002
    80005360:	97ba                	add	a5,a5,a4
    80005362:	40200713          	li	a4,1026
    80005366:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000536a:	00d5151b          	slliw	a0,a0,0xd
    8000536e:	0c2017b7          	lui	a5,0xc201
    80005372:	97aa                	add	a5,a5,a0
    80005374:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005378:	60a2                	ld	ra,8(sp)
    8000537a:	6402                	ld	s0,0(sp)
    8000537c:	0141                	addi	sp,sp,16
    8000537e:	8082                	ret

0000000080005380 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005380:	1141                	addi	sp,sp,-16
    80005382:	e406                	sd	ra,8(sp)
    80005384:	e022                	sd	s0,0(sp)
    80005386:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005388:	ffffc097          	auipc	ra,0xffffc
    8000538c:	bbe080e7          	jalr	-1090(ra) # 80000f46 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005390:	00d5151b          	slliw	a0,a0,0xd
    80005394:	0c2017b7          	lui	a5,0xc201
    80005398:	97aa                	add	a5,a5,a0
  return irq;
}
    8000539a:	43c8                	lw	a0,4(a5)
    8000539c:	60a2                	ld	ra,8(sp)
    8000539e:	6402                	ld	s0,0(sp)
    800053a0:	0141                	addi	sp,sp,16
    800053a2:	8082                	ret

00000000800053a4 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053a4:	1101                	addi	sp,sp,-32
    800053a6:	ec06                	sd	ra,24(sp)
    800053a8:	e822                	sd	s0,16(sp)
    800053aa:	e426                	sd	s1,8(sp)
    800053ac:	1000                	addi	s0,sp,32
    800053ae:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053b0:	ffffc097          	auipc	ra,0xffffc
    800053b4:	b96080e7          	jalr	-1130(ra) # 80000f46 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053b8:	00d5179b          	slliw	a5,a0,0xd
    800053bc:	0c201737          	lui	a4,0xc201
    800053c0:	97ba                	add	a5,a5,a4
    800053c2:	c3c4                	sw	s1,4(a5)
}
    800053c4:	60e2                	ld	ra,24(sp)
    800053c6:	6442                	ld	s0,16(sp)
    800053c8:	64a2                	ld	s1,8(sp)
    800053ca:	6105                	addi	sp,sp,32
    800053cc:	8082                	ret

00000000800053ce <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053ce:	1141                	addi	sp,sp,-16
    800053d0:	e406                	sd	ra,8(sp)
    800053d2:	e022                	sd	s0,0(sp)
    800053d4:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053d6:	479d                	li	a5,7
    800053d8:	04a7cc63          	blt	a5,a0,80005430 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053dc:	00017797          	auipc	a5,0x17
    800053e0:	40478793          	addi	a5,a5,1028 # 8001c7e0 <disk>
    800053e4:	97aa                	add	a5,a5,a0
    800053e6:	0187c783          	lbu	a5,24(a5)
    800053ea:	ebb9                	bnez	a5,80005440 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053ec:	00451693          	slli	a3,a0,0x4
    800053f0:	00017797          	auipc	a5,0x17
    800053f4:	3f078793          	addi	a5,a5,1008 # 8001c7e0 <disk>
    800053f8:	6398                	ld	a4,0(a5)
    800053fa:	9736                	add	a4,a4,a3
    800053fc:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005400:	6398                	ld	a4,0(a5)
    80005402:	9736                	add	a4,a4,a3
    80005404:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005408:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000540c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005410:	97aa                	add	a5,a5,a0
    80005412:	4705                	li	a4,1
    80005414:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005418:	00017517          	auipc	a0,0x17
    8000541c:	3e050513          	addi	a0,a0,992 # 8001c7f8 <disk+0x18>
    80005420:	ffffc097          	auipc	ra,0xffffc
    80005424:	298080e7          	jalr	664(ra) # 800016b8 <wakeup>
}
    80005428:	60a2                	ld	ra,8(sp)
    8000542a:	6402                	ld	s0,0(sp)
    8000542c:	0141                	addi	sp,sp,16
    8000542e:	8082                	ret
    panic("free_desc 1");
    80005430:	00003517          	auipc	a0,0x3
    80005434:	2a050513          	addi	a0,a0,672 # 800086d0 <etext+0x6d0>
    80005438:	00001097          	auipc	ra,0x1
    8000543c:	d26080e7          	jalr	-730(ra) # 8000615e <panic>
    panic("free_desc 2");
    80005440:	00003517          	auipc	a0,0x3
    80005444:	2a050513          	addi	a0,a0,672 # 800086e0 <etext+0x6e0>
    80005448:	00001097          	auipc	ra,0x1
    8000544c:	d16080e7          	jalr	-746(ra) # 8000615e <panic>

0000000080005450 <virtio_disk_init>:
{
    80005450:	1101                	addi	sp,sp,-32
    80005452:	ec06                	sd	ra,24(sp)
    80005454:	e822                	sd	s0,16(sp)
    80005456:	e426                	sd	s1,8(sp)
    80005458:	e04a                	sd	s2,0(sp)
    8000545a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000545c:	00003597          	auipc	a1,0x3
    80005460:	29458593          	addi	a1,a1,660 # 800086f0 <etext+0x6f0>
    80005464:	00017517          	auipc	a0,0x17
    80005468:	4a450513          	addi	a0,a0,1188 # 8001c908 <disk+0x128>
    8000546c:	00001097          	auipc	ra,0x1
    80005470:	fdc080e7          	jalr	-36(ra) # 80006448 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	4398                	lw	a4,0(a5)
    8000547a:	2701                	sext.w	a4,a4
    8000547c:	747277b7          	lui	a5,0x74727
    80005480:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005484:	16f71463          	bne	a4,a5,800055ec <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005488:	100017b7          	lui	a5,0x10001
    8000548c:	43dc                	lw	a5,4(a5)
    8000548e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005490:	4709                	li	a4,2
    80005492:	14e79d63          	bne	a5,a4,800055ec <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	479c                	lw	a5,8(a5)
    8000549c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000549e:	14e79763          	bne	a5,a4,800055ec <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054a2:	100017b7          	lui	a5,0x10001
    800054a6:	47d8                	lw	a4,12(a5)
    800054a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054aa:	554d47b7          	lui	a5,0x554d4
    800054ae:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054b2:	12f71d63          	bne	a4,a5,800055ec <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b6:	100017b7          	lui	a5,0x10001
    800054ba:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054be:	4705                	li	a4,1
    800054c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c2:	470d                	li	a4,3
    800054c4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054c6:	10001737          	lui	a4,0x10001
    800054ca:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054cc:	c7ffe6b7          	lui	a3,0xc7ffe
    800054d0:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9d3f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054d4:	8f75                	and	a4,a4,a3
    800054d6:	100016b7          	lui	a3,0x10001
    800054da:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054dc:	472d                	li	a4,11
    800054de:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e0:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800054e4:	439c                	lw	a5,0(a5)
    800054e6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054ea:	8ba1                	andi	a5,a5,8
    800054ec:	10078863          	beqz	a5,800055fc <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054f0:	100017b7          	lui	a5,0x10001
    800054f4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054f8:	43fc                	lw	a5,68(a5)
    800054fa:	2781                	sext.w	a5,a5
    800054fc:	10079863          	bnez	a5,8000560c <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005500:	100017b7          	lui	a5,0x10001
    80005504:	5bdc                	lw	a5,52(a5)
    80005506:	2781                	sext.w	a5,a5
  if(max == 0)
    80005508:	10078a63          	beqz	a5,8000561c <virtio_disk_init+0x1cc>
  if(max < NUM)
    8000550c:	471d                	li	a4,7
    8000550e:	10f77f63          	bgeu	a4,a5,8000562c <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80005512:	ffffb097          	auipc	ra,0xffffb
    80005516:	c08080e7          	jalr	-1016(ra) # 8000011a <kalloc>
    8000551a:	00017497          	auipc	s1,0x17
    8000551e:	2c648493          	addi	s1,s1,710 # 8001c7e0 <disk>
    80005522:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005524:	ffffb097          	auipc	ra,0xffffb
    80005528:	bf6080e7          	jalr	-1034(ra) # 8000011a <kalloc>
    8000552c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000552e:	ffffb097          	auipc	ra,0xffffb
    80005532:	bec080e7          	jalr	-1044(ra) # 8000011a <kalloc>
    80005536:	87aa                	mv	a5,a0
    80005538:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000553a:	6088                	ld	a0,0(s1)
    8000553c:	10050063          	beqz	a0,8000563c <virtio_disk_init+0x1ec>
    80005540:	00017717          	auipc	a4,0x17
    80005544:	2a873703          	ld	a4,680(a4) # 8001c7e8 <disk+0x8>
    80005548:	cb75                	beqz	a4,8000563c <virtio_disk_init+0x1ec>
    8000554a:	cbed                	beqz	a5,8000563c <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    8000554c:	6605                	lui	a2,0x1
    8000554e:	4581                	li	a1,0
    80005550:	ffffb097          	auipc	ra,0xffffb
    80005554:	c74080e7          	jalr	-908(ra) # 800001c4 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005558:	00017497          	auipc	s1,0x17
    8000555c:	28848493          	addi	s1,s1,648 # 8001c7e0 <disk>
    80005560:	6605                	lui	a2,0x1
    80005562:	4581                	li	a1,0
    80005564:	6488                	ld	a0,8(s1)
    80005566:	ffffb097          	auipc	ra,0xffffb
    8000556a:	c5e080e7          	jalr	-930(ra) # 800001c4 <memset>
  memset(disk.used, 0, PGSIZE);
    8000556e:	6605                	lui	a2,0x1
    80005570:	4581                	li	a1,0
    80005572:	6888                	ld	a0,16(s1)
    80005574:	ffffb097          	auipc	ra,0xffffb
    80005578:	c50080e7          	jalr	-944(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	4721                	li	a4,8
    80005582:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005584:	4098                	lw	a4,0(s1)
    80005586:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000558a:	40d8                	lw	a4,4(s1)
    8000558c:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005590:	649c                	ld	a5,8(s1)
    80005592:	0007869b          	sext.w	a3,a5
    80005596:	10001737          	lui	a4,0x10001
    8000559a:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000559e:	9781                	srai	a5,a5,0x20
    800055a0:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055a4:	689c                	ld	a5,16(s1)
    800055a6:	0007869b          	sext.w	a3,a5
    800055aa:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055ae:	9781                	srai	a5,a5,0x20
    800055b0:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055b4:	4785                	li	a5,1
    800055b6:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800055b8:	00f48c23          	sb	a5,24(s1)
    800055bc:	00f48ca3          	sb	a5,25(s1)
    800055c0:	00f48d23          	sb	a5,26(s1)
    800055c4:	00f48da3          	sb	a5,27(s1)
    800055c8:	00f48e23          	sb	a5,28(s1)
    800055cc:	00f48ea3          	sb	a5,29(s1)
    800055d0:	00f48f23          	sb	a5,30(s1)
    800055d4:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055d8:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055dc:	07272823          	sw	s2,112(a4)
}
    800055e0:	60e2                	ld	ra,24(sp)
    800055e2:	6442                	ld	s0,16(sp)
    800055e4:	64a2                	ld	s1,8(sp)
    800055e6:	6902                	ld	s2,0(sp)
    800055e8:	6105                	addi	sp,sp,32
    800055ea:	8082                	ret
    panic("could not find virtio disk");
    800055ec:	00003517          	auipc	a0,0x3
    800055f0:	11450513          	addi	a0,a0,276 # 80008700 <etext+0x700>
    800055f4:	00001097          	auipc	ra,0x1
    800055f8:	b6a080e7          	jalr	-1174(ra) # 8000615e <panic>
    panic("virtio disk FEATURES_OK unset");
    800055fc:	00003517          	auipc	a0,0x3
    80005600:	12450513          	addi	a0,a0,292 # 80008720 <etext+0x720>
    80005604:	00001097          	auipc	ra,0x1
    80005608:	b5a080e7          	jalr	-1190(ra) # 8000615e <panic>
    panic("virtio disk should not be ready");
    8000560c:	00003517          	auipc	a0,0x3
    80005610:	13450513          	addi	a0,a0,308 # 80008740 <etext+0x740>
    80005614:	00001097          	auipc	ra,0x1
    80005618:	b4a080e7          	jalr	-1206(ra) # 8000615e <panic>
    panic("virtio disk has no queue 0");
    8000561c:	00003517          	auipc	a0,0x3
    80005620:	14450513          	addi	a0,a0,324 # 80008760 <etext+0x760>
    80005624:	00001097          	auipc	ra,0x1
    80005628:	b3a080e7          	jalr	-1222(ra) # 8000615e <panic>
    panic("virtio disk max queue too short");
    8000562c:	00003517          	auipc	a0,0x3
    80005630:	15450513          	addi	a0,a0,340 # 80008780 <etext+0x780>
    80005634:	00001097          	auipc	ra,0x1
    80005638:	b2a080e7          	jalr	-1238(ra) # 8000615e <panic>
    panic("virtio disk kalloc");
    8000563c:	00003517          	auipc	a0,0x3
    80005640:	16450513          	addi	a0,a0,356 # 800087a0 <etext+0x7a0>
    80005644:	00001097          	auipc	ra,0x1
    80005648:	b1a080e7          	jalr	-1254(ra) # 8000615e <panic>

000000008000564c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000564c:	711d                	addi	sp,sp,-96
    8000564e:	ec86                	sd	ra,88(sp)
    80005650:	e8a2                	sd	s0,80(sp)
    80005652:	e4a6                	sd	s1,72(sp)
    80005654:	e0ca                	sd	s2,64(sp)
    80005656:	fc4e                	sd	s3,56(sp)
    80005658:	f852                	sd	s4,48(sp)
    8000565a:	f456                	sd	s5,40(sp)
    8000565c:	f05a                	sd	s6,32(sp)
    8000565e:	ec5e                	sd	s7,24(sp)
    80005660:	e862                	sd	s8,16(sp)
    80005662:	1080                	addi	s0,sp,96
    80005664:	89aa                	mv	s3,a0
    80005666:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005668:	00c52b83          	lw	s7,12(a0)
    8000566c:	001b9b9b          	slliw	s7,s7,0x1
    80005670:	1b82                	slli	s7,s7,0x20
    80005672:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005676:	00017517          	auipc	a0,0x17
    8000567a:	29250513          	addi	a0,a0,658 # 8001c908 <disk+0x128>
    8000567e:	00001097          	auipc	ra,0x1
    80005682:	e5e080e7          	jalr	-418(ra) # 800064dc <acquire>
  for(int i = 0; i < NUM; i++){
    80005686:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005688:	00017a97          	auipc	s5,0x17
    8000568c:	158a8a93          	addi	s5,s5,344 # 8001c7e0 <disk>
  for(int i = 0; i < 3; i++){
    80005690:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005692:	5c7d                	li	s8,-1
    80005694:	a885                	j	80005704 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005696:	00fa8733          	add	a4,s5,a5
    8000569a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000569e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056a0:	0207c563          	bltz	a5,800056ca <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    800056a4:	2905                	addiw	s2,s2,1
    800056a6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800056a8:	07490263          	beq	s2,s4,8000570c <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    800056ac:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056ae:	00017717          	auipc	a4,0x17
    800056b2:	13270713          	addi	a4,a4,306 # 8001c7e0 <disk>
    800056b6:	4781                	li	a5,0
    if(disk.free[i]){
    800056b8:	01874683          	lbu	a3,24(a4)
    800056bc:	fee9                	bnez	a3,80005696 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    800056be:	2785                	addiw	a5,a5,1
    800056c0:	0705                	addi	a4,a4,1
    800056c2:	fe979be3          	bne	a5,s1,800056b8 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    800056c6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800056ca:	03205163          	blez	s2,800056ec <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    800056ce:	fa042503          	lw	a0,-96(s0)
    800056d2:	00000097          	auipc	ra,0x0
    800056d6:	cfc080e7          	jalr	-772(ra) # 800053ce <free_desc>
      for(int j = 0; j < i; j++)
    800056da:	4785                	li	a5,1
    800056dc:	0127d863          	bge	a5,s2,800056ec <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    800056e0:	fa442503          	lw	a0,-92(s0)
    800056e4:	00000097          	auipc	ra,0x0
    800056e8:	cea080e7          	jalr	-790(ra) # 800053ce <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056ec:	00017597          	auipc	a1,0x17
    800056f0:	21c58593          	addi	a1,a1,540 # 8001c908 <disk+0x128>
    800056f4:	00017517          	auipc	a0,0x17
    800056f8:	10450513          	addi	a0,a0,260 # 8001c7f8 <disk+0x18>
    800056fc:	ffffc097          	auipc	ra,0xffffc
    80005700:	f58080e7          	jalr	-168(ra) # 80001654 <sleep>
  for(int i = 0; i < 3; i++){
    80005704:	fa040613          	addi	a2,s0,-96
    80005708:	4901                	li	s2,0
    8000570a:	b74d                	j	800056ac <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000570c:	fa042503          	lw	a0,-96(s0)
    80005710:	00451693          	slli	a3,a0,0x4

  if(write)
    80005714:	00017797          	auipc	a5,0x17
    80005718:	0cc78793          	addi	a5,a5,204 # 8001c7e0 <disk>
    8000571c:	00a50713          	addi	a4,a0,10
    80005720:	0712                	slli	a4,a4,0x4
    80005722:	973e                	add	a4,a4,a5
    80005724:	01603633          	snez	a2,s6
    80005728:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000572a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000572e:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005732:	6398                	ld	a4,0(a5)
    80005734:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005736:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    8000573a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000573c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000573e:	6390                	ld	a2,0(a5)
    80005740:	00d605b3          	add	a1,a2,a3
    80005744:	4741                	li	a4,16
    80005746:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005748:	4805                	li	a6,1
    8000574a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000574e:	fa442703          	lw	a4,-92(s0)
    80005752:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005756:	0712                	slli	a4,a4,0x4
    80005758:	963a                	add	a2,a2,a4
    8000575a:	05898593          	addi	a1,s3,88
    8000575e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005760:	0007b883          	ld	a7,0(a5)
    80005764:	9746                	add	a4,a4,a7
    80005766:	40000613          	li	a2,1024
    8000576a:	c710                	sw	a2,8(a4)
  if(write)
    8000576c:	001b3613          	seqz	a2,s6
    80005770:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005774:	01066633          	or	a2,a2,a6
    80005778:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000577c:	fa842583          	lw	a1,-88(s0)
    80005780:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005784:	00250613          	addi	a2,a0,2
    80005788:	0612                	slli	a2,a2,0x4
    8000578a:	963e                	add	a2,a2,a5
    8000578c:	577d                	li	a4,-1
    8000578e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005792:	0592                	slli	a1,a1,0x4
    80005794:	98ae                	add	a7,a7,a1
    80005796:	03068713          	addi	a4,a3,48
    8000579a:	973e                	add	a4,a4,a5
    8000579c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800057a0:	6398                	ld	a4,0(a5)
    800057a2:	972e                	add	a4,a4,a1
    800057a4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057a8:	4689                	li	a3,2
    800057aa:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800057ae:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057b2:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800057b6:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057ba:	6794                	ld	a3,8(a5)
    800057bc:	0026d703          	lhu	a4,2(a3)
    800057c0:	8b1d                	andi	a4,a4,7
    800057c2:	0706                	slli	a4,a4,0x1
    800057c4:	96ba                	add	a3,a3,a4
    800057c6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057ca:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ce:	6798                	ld	a4,8(a5)
    800057d0:	00275783          	lhu	a5,2(a4)
    800057d4:	2785                	addiw	a5,a5,1
    800057d6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057da:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057de:	100017b7          	lui	a5,0x10001
    800057e2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057e6:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800057ea:	00017917          	auipc	s2,0x17
    800057ee:	11e90913          	addi	s2,s2,286 # 8001c908 <disk+0x128>
  while(b->disk == 1) {
    800057f2:	84c2                	mv	s1,a6
    800057f4:	01079c63          	bne	a5,a6,8000580c <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    800057f8:	85ca                	mv	a1,s2
    800057fa:	854e                	mv	a0,s3
    800057fc:	ffffc097          	auipc	ra,0xffffc
    80005800:	e58080e7          	jalr	-424(ra) # 80001654 <sleep>
  while(b->disk == 1) {
    80005804:	0049a783          	lw	a5,4(s3)
    80005808:	fe9788e3          	beq	a5,s1,800057f8 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    8000580c:	fa042903          	lw	s2,-96(s0)
    80005810:	00290713          	addi	a4,s2,2
    80005814:	0712                	slli	a4,a4,0x4
    80005816:	00017797          	auipc	a5,0x17
    8000581a:	fca78793          	addi	a5,a5,-54 # 8001c7e0 <disk>
    8000581e:	97ba                	add	a5,a5,a4
    80005820:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005824:	00017997          	auipc	s3,0x17
    80005828:	fbc98993          	addi	s3,s3,-68 # 8001c7e0 <disk>
    8000582c:	00491713          	slli	a4,s2,0x4
    80005830:	0009b783          	ld	a5,0(s3)
    80005834:	97ba                	add	a5,a5,a4
    80005836:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000583a:	854a                	mv	a0,s2
    8000583c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005840:	00000097          	auipc	ra,0x0
    80005844:	b8e080e7          	jalr	-1138(ra) # 800053ce <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005848:	8885                	andi	s1,s1,1
    8000584a:	f0ed                	bnez	s1,8000582c <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000584c:	00017517          	auipc	a0,0x17
    80005850:	0bc50513          	addi	a0,a0,188 # 8001c908 <disk+0x128>
    80005854:	00001097          	auipc	ra,0x1
    80005858:	d38080e7          	jalr	-712(ra) # 8000658c <release>
}
    8000585c:	60e6                	ld	ra,88(sp)
    8000585e:	6446                	ld	s0,80(sp)
    80005860:	64a6                	ld	s1,72(sp)
    80005862:	6906                	ld	s2,64(sp)
    80005864:	79e2                	ld	s3,56(sp)
    80005866:	7a42                	ld	s4,48(sp)
    80005868:	7aa2                	ld	s5,40(sp)
    8000586a:	7b02                	ld	s6,32(sp)
    8000586c:	6be2                	ld	s7,24(sp)
    8000586e:	6c42                	ld	s8,16(sp)
    80005870:	6125                	addi	sp,sp,96
    80005872:	8082                	ret

0000000080005874 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005874:	1101                	addi	sp,sp,-32
    80005876:	ec06                	sd	ra,24(sp)
    80005878:	e822                	sd	s0,16(sp)
    8000587a:	e426                	sd	s1,8(sp)
    8000587c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000587e:	00017497          	auipc	s1,0x17
    80005882:	f6248493          	addi	s1,s1,-158 # 8001c7e0 <disk>
    80005886:	00017517          	auipc	a0,0x17
    8000588a:	08250513          	addi	a0,a0,130 # 8001c908 <disk+0x128>
    8000588e:	00001097          	auipc	ra,0x1
    80005892:	c4e080e7          	jalr	-946(ra) # 800064dc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005896:	100017b7          	lui	a5,0x10001
    8000589a:	53bc                	lw	a5,96(a5)
    8000589c:	8b8d                	andi	a5,a5,3
    8000589e:	10001737          	lui	a4,0x10001
    800058a2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058a4:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058a8:	689c                	ld	a5,16(s1)
    800058aa:	0204d703          	lhu	a4,32(s1)
    800058ae:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800058b2:	04f70863          	beq	a4,a5,80005902 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800058b6:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058ba:	6898                	ld	a4,16(s1)
    800058bc:	0204d783          	lhu	a5,32(s1)
    800058c0:	8b9d                	andi	a5,a5,7
    800058c2:	078e                	slli	a5,a5,0x3
    800058c4:	97ba                	add	a5,a5,a4
    800058c6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058c8:	00278713          	addi	a4,a5,2
    800058cc:	0712                	slli	a4,a4,0x4
    800058ce:	9726                	add	a4,a4,s1
    800058d0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058d4:	e721                	bnez	a4,8000591c <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058d6:	0789                	addi	a5,a5,2
    800058d8:	0792                	slli	a5,a5,0x4
    800058da:	97a6                	add	a5,a5,s1
    800058dc:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058de:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058e2:	ffffc097          	auipc	ra,0xffffc
    800058e6:	dd6080e7          	jalr	-554(ra) # 800016b8 <wakeup>

    disk.used_idx += 1;
    800058ea:	0204d783          	lhu	a5,32(s1)
    800058ee:	2785                	addiw	a5,a5,1
    800058f0:	17c2                	slli	a5,a5,0x30
    800058f2:	93c1                	srli	a5,a5,0x30
    800058f4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058f8:	6898                	ld	a4,16(s1)
    800058fa:	00275703          	lhu	a4,2(a4)
    800058fe:	faf71ce3          	bne	a4,a5,800058b6 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005902:	00017517          	auipc	a0,0x17
    80005906:	00650513          	addi	a0,a0,6 # 8001c908 <disk+0x128>
    8000590a:	00001097          	auipc	ra,0x1
    8000590e:	c82080e7          	jalr	-894(ra) # 8000658c <release>
}
    80005912:	60e2                	ld	ra,24(sp)
    80005914:	6442                	ld	s0,16(sp)
    80005916:	64a2                	ld	s1,8(sp)
    80005918:	6105                	addi	sp,sp,32
    8000591a:	8082                	ret
      panic("virtio_disk_intr status");
    8000591c:	00003517          	auipc	a0,0x3
    80005920:	e9c50513          	addi	a0,a0,-356 # 800087b8 <etext+0x7b8>
    80005924:	00001097          	auipc	ra,0x1
    80005928:	83a080e7          	jalr	-1990(ra) # 8000615e <panic>

000000008000592c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000592c:	1141                	addi	sp,sp,-16
    8000592e:	e406                	sd	ra,8(sp)
    80005930:	e022                	sd	s0,0(sp)
    80005932:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005934:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005938:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    8000593c:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80005940:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005944:	577d                	li	a4,-1
    80005946:	177e                	slli	a4,a4,0x3f
    80005948:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000594a:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000594e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005952:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005956:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    8000595a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000595e:	000f4737          	lui	a4,0xf4
    80005962:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005966:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005968:	14d79073          	csrw	stimecmp,a5
}
    8000596c:	60a2                	ld	ra,8(sp)
    8000596e:	6402                	ld	s0,0(sp)
    80005970:	0141                	addi	sp,sp,16
    80005972:	8082                	ret

0000000080005974 <start>:
{
    80005974:	1141                	addi	sp,sp,-16
    80005976:	e406                	sd	ra,8(sp)
    80005978:	e022                	sd	s0,0(sp)
    8000597a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000597c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005980:	7779                	lui	a4,0xffffe
    80005982:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9ddf>
    80005986:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005988:	6705                	lui	a4,0x1
    8000598a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000598e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005990:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005994:	ffffb797          	auipc	a5,0xffffb
    80005998:	9ea78793          	addi	a5,a5,-1558 # 8000037e <main>
    8000599c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059a0:	4781                	li	a5,0
    800059a2:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059a6:	67c1                	lui	a5,0x10
    800059a8:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800059aa:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059ae:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059b2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059b6:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059ba:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059be:	57fd                	li	a5,-1
    800059c0:	83a9                	srli	a5,a5,0xa
    800059c2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059c6:	47bd                	li	a5,15
    800059c8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059cc:	00000097          	auipc	ra,0x0
    800059d0:	f60080e7          	jalr	-160(ra) # 8000592c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059d4:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059d8:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059da:	823e                	mv	tp,a5
  asm volatile("mret");
    800059dc:	30200073          	mret
}
    800059e0:	60a2                	ld	ra,8(sp)
    800059e2:	6402                	ld	s0,0(sp)
    800059e4:	0141                	addi	sp,sp,16
    800059e6:	8082                	ret

00000000800059e8 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059e8:	711d                	addi	sp,sp,-96
    800059ea:	ec86                	sd	ra,88(sp)
    800059ec:	e8a2                	sd	s0,80(sp)
    800059ee:	e0ca                	sd	s2,64(sp)
    800059f0:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    800059f2:	04c05c63          	blez	a2,80005a4a <consolewrite+0x62>
    800059f6:	e4a6                	sd	s1,72(sp)
    800059f8:	fc4e                	sd	s3,56(sp)
    800059fa:	f852                	sd	s4,48(sp)
    800059fc:	f456                	sd	s5,40(sp)
    800059fe:	f05a                	sd	s6,32(sp)
    80005a00:	ec5e                	sd	s7,24(sp)
    80005a02:	8a2a                	mv	s4,a0
    80005a04:	84ae                	mv	s1,a1
    80005a06:	89b2                	mv	s3,a2
    80005a08:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a0a:	faf40b93          	addi	s7,s0,-81
    80005a0e:	4b05                	li	s6,1
    80005a10:	5afd                	li	s5,-1
    80005a12:	86da                	mv	a3,s6
    80005a14:	8626                	mv	a2,s1
    80005a16:	85d2                	mv	a1,s4
    80005a18:	855e                	mv	a0,s7
    80005a1a:	ffffc097          	auipc	ra,0xffffc
    80005a1e:	092080e7          	jalr	146(ra) # 80001aac <either_copyin>
    80005a22:	03550663          	beq	a0,s5,80005a4e <consolewrite+0x66>
      break;
    uartputc(c);
    80005a26:	faf44503          	lbu	a0,-81(s0)
    80005a2a:	00001097          	auipc	ra,0x1
    80005a2e:	8f0080e7          	jalr	-1808(ra) # 8000631a <uartputc>
  for(i = 0; i < n; i++){
    80005a32:	2905                	addiw	s2,s2,1
    80005a34:	0485                	addi	s1,s1,1
    80005a36:	fd299ee3          	bne	s3,s2,80005a12 <consolewrite+0x2a>
    80005a3a:	894e                	mv	s2,s3
    80005a3c:	64a6                	ld	s1,72(sp)
    80005a3e:	79e2                	ld	s3,56(sp)
    80005a40:	7a42                	ld	s4,48(sp)
    80005a42:	7aa2                	ld	s5,40(sp)
    80005a44:	7b02                	ld	s6,32(sp)
    80005a46:	6be2                	ld	s7,24(sp)
    80005a48:	a809                	j	80005a5a <consolewrite+0x72>
    80005a4a:	4901                	li	s2,0
    80005a4c:	a039                	j	80005a5a <consolewrite+0x72>
    80005a4e:	64a6                	ld	s1,72(sp)
    80005a50:	79e2                	ld	s3,56(sp)
    80005a52:	7a42                	ld	s4,48(sp)
    80005a54:	7aa2                	ld	s5,40(sp)
    80005a56:	7b02                	ld	s6,32(sp)
    80005a58:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80005a5a:	854a                	mv	a0,s2
    80005a5c:	60e6                	ld	ra,88(sp)
    80005a5e:	6446                	ld	s0,80(sp)
    80005a60:	6906                	ld	s2,64(sp)
    80005a62:	6125                	addi	sp,sp,96
    80005a64:	8082                	ret

0000000080005a66 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a66:	711d                	addi	sp,sp,-96
    80005a68:	ec86                	sd	ra,88(sp)
    80005a6a:	e8a2                	sd	s0,80(sp)
    80005a6c:	e4a6                	sd	s1,72(sp)
    80005a6e:	e0ca                	sd	s2,64(sp)
    80005a70:	fc4e                	sd	s3,56(sp)
    80005a72:	f852                	sd	s4,48(sp)
    80005a74:	f456                	sd	s5,40(sp)
    80005a76:	f05a                	sd	s6,32(sp)
    80005a78:	1080                	addi	s0,sp,96
    80005a7a:	8aaa                	mv	s5,a0
    80005a7c:	8a2e                	mv	s4,a1
    80005a7e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a80:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80005a82:	0001f517          	auipc	a0,0x1f
    80005a86:	e9e50513          	addi	a0,a0,-354 # 80024920 <cons>
    80005a8a:	00001097          	auipc	ra,0x1
    80005a8e:	a52080e7          	jalr	-1454(ra) # 800064dc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a92:	0001f497          	auipc	s1,0x1f
    80005a96:	e8e48493          	addi	s1,s1,-370 # 80024920 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a9a:	0001f917          	auipc	s2,0x1f
    80005a9e:	f1e90913          	addi	s2,s2,-226 # 800249b8 <cons+0x98>
  while(n > 0){
    80005aa2:	0d305563          	blez	s3,80005b6c <consoleread+0x106>
    while(cons.r == cons.w){
    80005aa6:	0984a783          	lw	a5,152(s1)
    80005aaa:	09c4a703          	lw	a4,156(s1)
    80005aae:	0af71a63          	bne	a4,a5,80005b62 <consoleread+0xfc>
      if(killed(myproc())){
    80005ab2:	ffffb097          	auipc	ra,0xffffb
    80005ab6:	4c8080e7          	jalr	1224(ra) # 80000f7a <myproc>
    80005aba:	ffffc097          	auipc	ra,0xffffc
    80005abe:	e42080e7          	jalr	-446(ra) # 800018fc <killed>
    80005ac2:	e52d                	bnez	a0,80005b2c <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    80005ac4:	85a6                	mv	a1,s1
    80005ac6:	854a                	mv	a0,s2
    80005ac8:	ffffc097          	auipc	ra,0xffffc
    80005acc:	b8c080e7          	jalr	-1140(ra) # 80001654 <sleep>
    while(cons.r == cons.w){
    80005ad0:	0984a783          	lw	a5,152(s1)
    80005ad4:	09c4a703          	lw	a4,156(s1)
    80005ad8:	fcf70de3          	beq	a4,a5,80005ab2 <consoleread+0x4c>
    80005adc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005ade:	0001f717          	auipc	a4,0x1f
    80005ae2:	e4270713          	addi	a4,a4,-446 # 80024920 <cons>
    80005ae6:	0017869b          	addiw	a3,a5,1
    80005aea:	08d72c23          	sw	a3,152(a4)
    80005aee:	07f7f693          	andi	a3,a5,127
    80005af2:	9736                	add	a4,a4,a3
    80005af4:	01874703          	lbu	a4,24(a4)
    80005af8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005afc:	4691                	li	a3,4
    80005afe:	04db8a63          	beq	s7,a3,80005b52 <consoleread+0xec>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b02:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b06:	4685                	li	a3,1
    80005b08:	faf40613          	addi	a2,s0,-81
    80005b0c:	85d2                	mv	a1,s4
    80005b0e:	8556                	mv	a0,s5
    80005b10:	ffffc097          	auipc	ra,0xffffc
    80005b14:	f46080e7          	jalr	-186(ra) # 80001a56 <either_copyout>
    80005b18:	57fd                	li	a5,-1
    80005b1a:	04f50863          	beq	a0,a5,80005b6a <consoleread+0x104>
      break;

    dst++;
    80005b1e:	0a05                	addi	s4,s4,1
    --n;
    80005b20:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005b22:	47a9                	li	a5,10
    80005b24:	04fb8f63          	beq	s7,a5,80005b82 <consoleread+0x11c>
    80005b28:	6be2                	ld	s7,24(sp)
    80005b2a:	bfa5                	j	80005aa2 <consoleread+0x3c>
        release(&cons.lock);
    80005b2c:	0001f517          	auipc	a0,0x1f
    80005b30:	df450513          	addi	a0,a0,-524 # 80024920 <cons>
    80005b34:	00001097          	auipc	ra,0x1
    80005b38:	a58080e7          	jalr	-1448(ra) # 8000658c <release>
        return -1;
    80005b3c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005b3e:	60e6                	ld	ra,88(sp)
    80005b40:	6446                	ld	s0,80(sp)
    80005b42:	64a6                	ld	s1,72(sp)
    80005b44:	6906                	ld	s2,64(sp)
    80005b46:	79e2                	ld	s3,56(sp)
    80005b48:	7a42                	ld	s4,48(sp)
    80005b4a:	7aa2                	ld	s5,40(sp)
    80005b4c:	7b02                	ld	s6,32(sp)
    80005b4e:	6125                	addi	sp,sp,96
    80005b50:	8082                	ret
      if(n < target){
    80005b52:	0169fa63          	bgeu	s3,s6,80005b66 <consoleread+0x100>
        cons.r--;
    80005b56:	0001f717          	auipc	a4,0x1f
    80005b5a:	e6f72123          	sw	a5,-414(a4) # 800249b8 <cons+0x98>
    80005b5e:	6be2                	ld	s7,24(sp)
    80005b60:	a031                	j	80005b6c <consoleread+0x106>
    80005b62:	ec5e                	sd	s7,24(sp)
    80005b64:	bfad                	j	80005ade <consoleread+0x78>
    80005b66:	6be2                	ld	s7,24(sp)
    80005b68:	a011                	j	80005b6c <consoleread+0x106>
    80005b6a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005b6c:	0001f517          	auipc	a0,0x1f
    80005b70:	db450513          	addi	a0,a0,-588 # 80024920 <cons>
    80005b74:	00001097          	auipc	ra,0x1
    80005b78:	a18080e7          	jalr	-1512(ra) # 8000658c <release>
  return target - n;
    80005b7c:	413b053b          	subw	a0,s6,s3
    80005b80:	bf7d                	j	80005b3e <consoleread+0xd8>
    80005b82:	6be2                	ld	s7,24(sp)
    80005b84:	b7e5                	j	80005b6c <consoleread+0x106>

0000000080005b86 <consputc>:
{
    80005b86:	1141                	addi	sp,sp,-16
    80005b88:	e406                	sd	ra,8(sp)
    80005b8a:	e022                	sd	s0,0(sp)
    80005b8c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b8e:	10000793          	li	a5,256
    80005b92:	00f50a63          	beq	a0,a5,80005ba6 <consputc+0x20>
    uartputc_sync(c);
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	696080e7          	jalr	1686(ra) # 8000622c <uartputc_sync>
}
    80005b9e:	60a2                	ld	ra,8(sp)
    80005ba0:	6402                	ld	s0,0(sp)
    80005ba2:	0141                	addi	sp,sp,16
    80005ba4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ba6:	4521                	li	a0,8
    80005ba8:	00000097          	auipc	ra,0x0
    80005bac:	684080e7          	jalr	1668(ra) # 8000622c <uartputc_sync>
    80005bb0:	02000513          	li	a0,32
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	678080e7          	jalr	1656(ra) # 8000622c <uartputc_sync>
    80005bbc:	4521                	li	a0,8
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	66e080e7          	jalr	1646(ra) # 8000622c <uartputc_sync>
    80005bc6:	bfe1                	j	80005b9e <consputc+0x18>

0000000080005bc8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bc8:	7179                	addi	sp,sp,-48
    80005bca:	f406                	sd	ra,40(sp)
    80005bcc:	f022                	sd	s0,32(sp)
    80005bce:	ec26                	sd	s1,24(sp)
    80005bd0:	1800                	addi	s0,sp,48
    80005bd2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bd4:	0001f517          	auipc	a0,0x1f
    80005bd8:	d4c50513          	addi	a0,a0,-692 # 80024920 <cons>
    80005bdc:	00001097          	auipc	ra,0x1
    80005be0:	900080e7          	jalr	-1792(ra) # 800064dc <acquire>

  switch(c){
    80005be4:	47d5                	li	a5,21
    80005be6:	0af48463          	beq	s1,a5,80005c8e <consoleintr+0xc6>
    80005bea:	0297c963          	blt	a5,s1,80005c1c <consoleintr+0x54>
    80005bee:	47a1                	li	a5,8
    80005bf0:	10f48063          	beq	s1,a5,80005cf0 <consoleintr+0x128>
    80005bf4:	47c1                	li	a5,16
    80005bf6:	12f49363          	bne	s1,a5,80005d1c <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80005bfa:	ffffc097          	auipc	ra,0xffffc
    80005bfe:	f08080e7          	jalr	-248(ra) # 80001b02 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c02:	0001f517          	auipc	a0,0x1f
    80005c06:	d1e50513          	addi	a0,a0,-738 # 80024920 <cons>
    80005c0a:	00001097          	auipc	ra,0x1
    80005c0e:	982080e7          	jalr	-1662(ra) # 8000658c <release>
}
    80005c12:	70a2                	ld	ra,40(sp)
    80005c14:	7402                	ld	s0,32(sp)
    80005c16:	64e2                	ld	s1,24(sp)
    80005c18:	6145                	addi	sp,sp,48
    80005c1a:	8082                	ret
  switch(c){
    80005c1c:	07f00793          	li	a5,127
    80005c20:	0cf48863          	beq	s1,a5,80005cf0 <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c24:	0001f717          	auipc	a4,0x1f
    80005c28:	cfc70713          	addi	a4,a4,-772 # 80024920 <cons>
    80005c2c:	0a072783          	lw	a5,160(a4)
    80005c30:	09872703          	lw	a4,152(a4)
    80005c34:	9f99                	subw	a5,a5,a4
    80005c36:	07f00713          	li	a4,127
    80005c3a:	fcf764e3          	bltu	a4,a5,80005c02 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005c3e:	47b5                	li	a5,13
    80005c40:	0ef48163          	beq	s1,a5,80005d22 <consoleintr+0x15a>
      consputc(c);
    80005c44:	8526                	mv	a0,s1
    80005c46:	00000097          	auipc	ra,0x0
    80005c4a:	f40080e7          	jalr	-192(ra) # 80005b86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c4e:	0001f797          	auipc	a5,0x1f
    80005c52:	cd278793          	addi	a5,a5,-814 # 80024920 <cons>
    80005c56:	0a07a683          	lw	a3,160(a5)
    80005c5a:	0016871b          	addiw	a4,a3,1
    80005c5e:	863a                	mv	a2,a4
    80005c60:	0ae7a023          	sw	a4,160(a5)
    80005c64:	07f6f693          	andi	a3,a3,127
    80005c68:	97b6                	add	a5,a5,a3
    80005c6a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c6e:	47a9                	li	a5,10
    80005c70:	0cf48f63          	beq	s1,a5,80005d4e <consoleintr+0x186>
    80005c74:	4791                	li	a5,4
    80005c76:	0cf48c63          	beq	s1,a5,80005d4e <consoleintr+0x186>
    80005c7a:	0001f797          	auipc	a5,0x1f
    80005c7e:	d3e7a783          	lw	a5,-706(a5) # 800249b8 <cons+0x98>
    80005c82:	9f1d                	subw	a4,a4,a5
    80005c84:	08000793          	li	a5,128
    80005c88:	f6f71de3          	bne	a4,a5,80005c02 <consoleintr+0x3a>
    80005c8c:	a0c9                	j	80005d4e <consoleintr+0x186>
    80005c8e:	e84a                	sd	s2,16(sp)
    80005c90:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005c92:	0001f717          	auipc	a4,0x1f
    80005c96:	c8e70713          	addi	a4,a4,-882 # 80024920 <cons>
    80005c9a:	0a072783          	lw	a5,160(a4)
    80005c9e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ca2:	0001f497          	auipc	s1,0x1f
    80005ca6:	c7e48493          	addi	s1,s1,-898 # 80024920 <cons>
    while(cons.e != cons.w &&
    80005caa:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005cac:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005cb0:	02f70a63          	beq	a4,a5,80005ce4 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cb4:	37fd                	addiw	a5,a5,-1
    80005cb6:	07f7f713          	andi	a4,a5,127
    80005cba:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cbc:	01874703          	lbu	a4,24(a4)
    80005cc0:	03270563          	beq	a4,s2,80005cea <consoleintr+0x122>
      cons.e--;
    80005cc4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cc8:	854e                	mv	a0,s3
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	ebc080e7          	jalr	-324(ra) # 80005b86 <consputc>
    while(cons.e != cons.w &&
    80005cd2:	0a04a783          	lw	a5,160(s1)
    80005cd6:	09c4a703          	lw	a4,156(s1)
    80005cda:	fcf71de3          	bne	a4,a5,80005cb4 <consoleintr+0xec>
    80005cde:	6942                	ld	s2,16(sp)
    80005ce0:	69a2                	ld	s3,8(sp)
    80005ce2:	b705                	j	80005c02 <consoleintr+0x3a>
    80005ce4:	6942                	ld	s2,16(sp)
    80005ce6:	69a2                	ld	s3,8(sp)
    80005ce8:	bf29                	j	80005c02 <consoleintr+0x3a>
    80005cea:	6942                	ld	s2,16(sp)
    80005cec:	69a2                	ld	s3,8(sp)
    80005cee:	bf11                	j	80005c02 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005cf0:	0001f717          	auipc	a4,0x1f
    80005cf4:	c3070713          	addi	a4,a4,-976 # 80024920 <cons>
    80005cf8:	0a072783          	lw	a5,160(a4)
    80005cfc:	09c72703          	lw	a4,156(a4)
    80005d00:	f0f701e3          	beq	a4,a5,80005c02 <consoleintr+0x3a>
      cons.e--;
    80005d04:	37fd                	addiw	a5,a5,-1
    80005d06:	0001f717          	auipc	a4,0x1f
    80005d0a:	caf72d23          	sw	a5,-838(a4) # 800249c0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d0e:	10000513          	li	a0,256
    80005d12:	00000097          	auipc	ra,0x0
    80005d16:	e74080e7          	jalr	-396(ra) # 80005b86 <consputc>
    80005d1a:	b5e5                	j	80005c02 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d1c:	ee0483e3          	beqz	s1,80005c02 <consoleintr+0x3a>
    80005d20:	b711                	j	80005c24 <consoleintr+0x5c>
      consputc(c);
    80005d22:	4529                	li	a0,10
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	e62080e7          	jalr	-414(ra) # 80005b86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d2c:	0001f797          	auipc	a5,0x1f
    80005d30:	bf478793          	addi	a5,a5,-1036 # 80024920 <cons>
    80005d34:	0a07a703          	lw	a4,160(a5)
    80005d38:	0017069b          	addiw	a3,a4,1
    80005d3c:	8636                	mv	a2,a3
    80005d3e:	0ad7a023          	sw	a3,160(a5)
    80005d42:	07f77713          	andi	a4,a4,127
    80005d46:	97ba                	add	a5,a5,a4
    80005d48:	4729                	li	a4,10
    80005d4a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d4e:	0001f797          	auipc	a5,0x1f
    80005d52:	c6c7a723          	sw	a2,-914(a5) # 800249bc <cons+0x9c>
        wakeup(&cons.r);
    80005d56:	0001f517          	auipc	a0,0x1f
    80005d5a:	c6250513          	addi	a0,a0,-926 # 800249b8 <cons+0x98>
    80005d5e:	ffffc097          	auipc	ra,0xffffc
    80005d62:	95a080e7          	jalr	-1702(ra) # 800016b8 <wakeup>
    80005d66:	bd71                	j	80005c02 <consoleintr+0x3a>

0000000080005d68 <consoleinit>:

void
consoleinit(void)
{
    80005d68:	1141                	addi	sp,sp,-16
    80005d6a:	e406                	sd	ra,8(sp)
    80005d6c:	e022                	sd	s0,0(sp)
    80005d6e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d70:	00003597          	auipc	a1,0x3
    80005d74:	a6058593          	addi	a1,a1,-1440 # 800087d0 <etext+0x7d0>
    80005d78:	0001f517          	auipc	a0,0x1f
    80005d7c:	ba850513          	addi	a0,a0,-1112 # 80024920 <cons>
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	6c8080e7          	jalr	1736(ra) # 80006448 <initlock>

  uartinit();
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	44a080e7          	jalr	1098(ra) # 800061d2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d90:	00016797          	auipc	a5,0x16
    80005d94:	9f878793          	addi	a5,a5,-1544 # 8001b788 <devsw>
    80005d98:	00000717          	auipc	a4,0x0
    80005d9c:	cce70713          	addi	a4,a4,-818 # 80005a66 <consoleread>
    80005da0:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005da2:	00000717          	auipc	a4,0x0
    80005da6:	c4670713          	addi	a4,a4,-954 # 800059e8 <consolewrite>
    80005daa:	ef98                	sd	a4,24(a5)
}
    80005dac:	60a2                	ld	ra,8(sp)
    80005dae:	6402                	ld	s0,0(sp)
    80005db0:	0141                	addi	sp,sp,16
    80005db2:	8082                	ret

0000000080005db4 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005db4:	7179                	addi	sp,sp,-48
    80005db6:	f406                	sd	ra,40(sp)
    80005db8:	f022                	sd	s0,32(sp)
    80005dba:	ec26                	sd	s1,24(sp)
    80005dbc:	e84a                	sd	s2,16(sp)
    80005dbe:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005dc0:	c219                	beqz	a2,80005dc6 <printint+0x12>
    80005dc2:	06054c63          	bltz	a0,80005e3a <printint+0x86>
    x = -xx;
  else
    x = xx;
    80005dc6:	4e01                	li	t3,0

  i = 0;
    80005dc8:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005dcc:	869a                	mv	a3,t1
  i = 0;
    80005dce:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005dd0:	00003817          	auipc	a6,0x3
    80005dd4:	c2880813          	addi	a6,a6,-984 # 800089f8 <digits>
    80005dd8:	88be                	mv	a7,a5
    80005dda:	0017861b          	addiw	a2,a5,1
    80005dde:	87b2                	mv	a5,a2
    80005de0:	02b57733          	remu	a4,a0,a1
    80005de4:	9742                	add	a4,a4,a6
    80005de6:	00074703          	lbu	a4,0(a4)
    80005dea:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005dee:	872a                	mv	a4,a0
    80005df0:	02b55533          	divu	a0,a0,a1
    80005df4:	0685                	addi	a3,a3,1
    80005df6:	feb771e3          	bgeu	a4,a1,80005dd8 <printint+0x24>

  if(sign)
    80005dfa:	000e0c63          	beqz	t3,80005e12 <printint+0x5e>
    buf[i++] = '-';
    80005dfe:	fe060793          	addi	a5,a2,-32
    80005e02:	00878633          	add	a2,a5,s0
    80005e06:	02d00793          	li	a5,45
    80005e0a:	fef60823          	sb	a5,-16(a2)
    80005e0e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005e12:	fff7891b          	addiw	s2,a5,-1
    80005e16:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005e1a:	fff4c503          	lbu	a0,-1(s1)
    80005e1e:	00000097          	auipc	ra,0x0
    80005e22:	d68080e7          	jalr	-664(ra) # 80005b86 <consputc>
  while(--i >= 0)
    80005e26:	397d                	addiw	s2,s2,-1
    80005e28:	14fd                	addi	s1,s1,-1
    80005e2a:	fe0958e3          	bgez	s2,80005e1a <printint+0x66>
}
    80005e2e:	70a2                	ld	ra,40(sp)
    80005e30:	7402                	ld	s0,32(sp)
    80005e32:	64e2                	ld	s1,24(sp)
    80005e34:	6942                	ld	s2,16(sp)
    80005e36:	6145                	addi	sp,sp,48
    80005e38:	8082                	ret
    x = -xx;
    80005e3a:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005e3e:	4e05                	li	t3,1
    x = -xx;
    80005e40:	b761                	j	80005dc8 <printint+0x14>

0000000080005e42 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005e42:	7155                	addi	sp,sp,-208
    80005e44:	e506                	sd	ra,136(sp)
    80005e46:	e122                	sd	s0,128(sp)
    80005e48:	f0d2                	sd	s4,96(sp)
    80005e4a:	0900                	addi	s0,sp,144
    80005e4c:	8a2a                	mv	s4,a0
    80005e4e:	e40c                	sd	a1,8(s0)
    80005e50:	e810                	sd	a2,16(s0)
    80005e52:	ec14                	sd	a3,24(s0)
    80005e54:	f018                	sd	a4,32(s0)
    80005e56:	f41c                	sd	a5,40(s0)
    80005e58:	03043823          	sd	a6,48(s0)
    80005e5c:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005e60:	0001f797          	auipc	a5,0x1f
    80005e64:	b807a783          	lw	a5,-1152(a5) # 800249e0 <pr+0x18>
    80005e68:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005e6c:	e3a1                	bnez	a5,80005eac <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005e6e:	00840793          	addi	a5,s0,8
    80005e72:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005e76:	00054503          	lbu	a0,0(a0)
    80005e7a:	2a050a63          	beqz	a0,8000612e <printf+0x2ec>
    80005e7e:	fca6                	sd	s1,120(sp)
    80005e80:	f8ca                	sd	s2,112(sp)
    80005e82:	f4ce                	sd	s3,104(sp)
    80005e84:	ecd6                	sd	s5,88(sp)
    80005e86:	e8da                	sd	s6,80(sp)
    80005e88:	e0e2                	sd	s8,64(sp)
    80005e8a:	fc66                	sd	s9,56(sp)
    80005e8c:	f86a                	sd	s10,48(sp)
    80005e8e:	f46e                	sd	s11,40(sp)
    80005e90:	4981                	li	s3,0
    if(cx != '%'){
    80005e92:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005e96:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005e9a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005e9e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005ea2:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005ea6:	07000d93          	li	s11,112
    80005eaa:	a82d                	j	80005ee4 <printf+0xa2>
    acquire(&pr.lock);
    80005eac:	0001f517          	auipc	a0,0x1f
    80005eb0:	b1c50513          	addi	a0,a0,-1252 # 800249c8 <pr>
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	628080e7          	jalr	1576(ra) # 800064dc <acquire>
  va_start(ap, fmt);
    80005ebc:	00840793          	addi	a5,s0,8
    80005ec0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005ec4:	000a4503          	lbu	a0,0(s4)
    80005ec8:	f95d                	bnez	a0,80005e7e <printf+0x3c>
    80005eca:	a449                	j	8000614c <printf+0x30a>
      consputc(cx);
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	cba080e7          	jalr	-838(ra) # 80005b86 <consputc>
      continue;
    80005ed4:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005ed6:	2485                	addiw	s1,s1,1
    80005ed8:	89a6                	mv	s3,s1
    80005eda:	94d2                	add	s1,s1,s4
    80005edc:	0004c503          	lbu	a0,0(s1)
    80005ee0:	22050b63          	beqz	a0,80006116 <printf+0x2d4>
    if(cx != '%'){
    80005ee4:	ff5514e3          	bne	a0,s5,80005ecc <printf+0x8a>
    i++;
    80005ee8:	0019879b          	addiw	a5,s3,1
    80005eec:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80005eee:	00fa0733          	add	a4,s4,a5
    80005ef2:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005ef6:	22090063          	beqz	s2,80006116 <printf+0x2d4>
    80005efa:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    80005efe:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    80005f00:	c701                	beqz	a4,80005f08 <printf+0xc6>
    80005f02:	97d2                	add	a5,a5,s4
    80005f04:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005f08:	03690b63          	beq	s2,s6,80005f3e <printf+0xfc>
    } else if(c0 == 'l' && c1 == 'd'){
    80005f0c:	05890763          	beq	s2,s8,80005f5a <printf+0x118>
    } else if(c0 == 'u'){
    80005f10:	0f990963          	beq	s2,s9,80006002 <printf+0x1c0>
    } else if(c0 == 'x'){
    80005f14:	15a90563          	beq	s2,s10,8000605e <printf+0x21c>
    } else if(c0 == 'p'){
    80005f18:	17b90163          	beq	s2,s11,8000607a <printf+0x238>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005f1c:	07300793          	li	a5,115
    80005f20:	1af90663          	beq	s2,a5,800060cc <printf+0x28a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005f24:	1f590263          	beq	s2,s5,80006108 <printf+0x2c6>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005f28:	8556                	mv	a0,s5
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	c5c080e7          	jalr	-932(ra) # 80005b86 <consputc>
      consputc(c0);
    80005f32:	854a                	mv	a0,s2
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	c52080e7          	jalr	-942(ra) # 80005b86 <consputc>
    80005f3c:	bf69                	j	80005ed6 <printf+0x94>
      printint(va_arg(ap, int), 10, 1);
    80005f3e:	f8843783          	ld	a5,-120(s0)
    80005f42:	00878713          	addi	a4,a5,8
    80005f46:	f8e43423          	sd	a4,-120(s0)
    80005f4a:	4605                	li	a2,1
    80005f4c:	45a9                	li	a1,10
    80005f4e:	4388                	lw	a0,0(a5)
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	e64080e7          	jalr	-412(ra) # 80005db4 <printint>
    80005f58:	bfbd                	j	80005ed6 <printf+0x94>
    } else if(c0 == 'l' && c1 == 'd'){
    80005f5a:	03670863          	beq	a4,s6,80005f8a <printf+0x148>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005f5e:	05870663          	beq	a4,s8,80005faa <printf+0x168>
    } else if(c0 == 'l' && c1 == 'u'){
    80005f62:	0b970e63          	beq	a4,s9,8000601e <printf+0x1dc>
    } else if(c0 == 'l' && c1 == 'x'){
    80005f66:	fda711e3          	bne	a4,s10,80005f28 <printf+0xe6>
      printint(va_arg(ap, uint64), 16, 0);
    80005f6a:	f8843783          	ld	a5,-120(s0)
    80005f6e:	00878713          	addi	a4,a5,8
    80005f72:	f8e43423          	sd	a4,-120(s0)
    80005f76:	4601                	li	a2,0
    80005f78:	45c1                	li	a1,16
    80005f7a:	6388                	ld	a0,0(a5)
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	e38080e7          	jalr	-456(ra) # 80005db4 <printint>
      i += 1;
    80005f84:	0029849b          	addiw	s1,s3,2
    80005f88:	b7b9                	j	80005ed6 <printf+0x94>
      printint(va_arg(ap, uint64), 10, 1);
    80005f8a:	f8843783          	ld	a5,-120(s0)
    80005f8e:	00878713          	addi	a4,a5,8
    80005f92:	f8e43423          	sd	a4,-120(s0)
    80005f96:	4605                	li	a2,1
    80005f98:	45a9                	li	a1,10
    80005f9a:	6388                	ld	a0,0(a5)
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	e18080e7          	jalr	-488(ra) # 80005db4 <printint>
      i += 1;
    80005fa4:	0029849b          	addiw	s1,s3,2
    80005fa8:	b73d                	j	80005ed6 <printf+0x94>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005faa:	06400793          	li	a5,100
    80005fae:	02f68a63          	beq	a3,a5,80005fe2 <printf+0x1a0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005fb2:	07500793          	li	a5,117
    80005fb6:	08f68463          	beq	a3,a5,8000603e <printf+0x1fc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005fba:	07800793          	li	a5,120
    80005fbe:	f6f695e3          	bne	a3,a5,80005f28 <printf+0xe6>
      printint(va_arg(ap, uint64), 16, 0);
    80005fc2:	f8843783          	ld	a5,-120(s0)
    80005fc6:	00878713          	addi	a4,a5,8
    80005fca:	f8e43423          	sd	a4,-120(s0)
    80005fce:	4601                	li	a2,0
    80005fd0:	45c1                	li	a1,16
    80005fd2:	6388                	ld	a0,0(a5)
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	de0080e7          	jalr	-544(ra) # 80005db4 <printint>
      i += 2;
    80005fdc:	0039849b          	addiw	s1,s3,3
    80005fe0:	bddd                	j	80005ed6 <printf+0x94>
      printint(va_arg(ap, uint64), 10, 1);
    80005fe2:	f8843783          	ld	a5,-120(s0)
    80005fe6:	00878713          	addi	a4,a5,8
    80005fea:	f8e43423          	sd	a4,-120(s0)
    80005fee:	4605                	li	a2,1
    80005ff0:	45a9                	li	a1,10
    80005ff2:	6388                	ld	a0,0(a5)
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	dc0080e7          	jalr	-576(ra) # 80005db4 <printint>
      i += 2;
    80005ffc:	0039849b          	addiw	s1,s3,3
    80006000:	bdd9                	j	80005ed6 <printf+0x94>
      printint(va_arg(ap, int), 10, 0);
    80006002:	f8843783          	ld	a5,-120(s0)
    80006006:	00878713          	addi	a4,a5,8
    8000600a:	f8e43423          	sd	a4,-120(s0)
    8000600e:	4601                	li	a2,0
    80006010:	45a9                	li	a1,10
    80006012:	4388                	lw	a0,0(a5)
    80006014:	00000097          	auipc	ra,0x0
    80006018:	da0080e7          	jalr	-608(ra) # 80005db4 <printint>
    8000601c:	bd6d                	j	80005ed6 <printf+0x94>
      printint(va_arg(ap, uint64), 10, 0);
    8000601e:	f8843783          	ld	a5,-120(s0)
    80006022:	00878713          	addi	a4,a5,8
    80006026:	f8e43423          	sd	a4,-120(s0)
    8000602a:	4601                	li	a2,0
    8000602c:	45a9                	li	a1,10
    8000602e:	6388                	ld	a0,0(a5)
    80006030:	00000097          	auipc	ra,0x0
    80006034:	d84080e7          	jalr	-636(ra) # 80005db4 <printint>
      i += 1;
    80006038:	0029849b          	addiw	s1,s3,2
    8000603c:	bd69                	j	80005ed6 <printf+0x94>
      printint(va_arg(ap, uint64), 10, 0);
    8000603e:	f8843783          	ld	a5,-120(s0)
    80006042:	00878713          	addi	a4,a5,8
    80006046:	f8e43423          	sd	a4,-120(s0)
    8000604a:	4601                	li	a2,0
    8000604c:	45a9                	li	a1,10
    8000604e:	6388                	ld	a0,0(a5)
    80006050:	00000097          	auipc	ra,0x0
    80006054:	d64080e7          	jalr	-668(ra) # 80005db4 <printint>
      i += 2;
    80006058:	0039849b          	addiw	s1,s3,3
    8000605c:	bdad                	j	80005ed6 <printf+0x94>
      printint(va_arg(ap, int), 16, 0);
    8000605e:	f8843783          	ld	a5,-120(s0)
    80006062:	00878713          	addi	a4,a5,8
    80006066:	f8e43423          	sd	a4,-120(s0)
    8000606a:	4601                	li	a2,0
    8000606c:	45c1                	li	a1,16
    8000606e:	4388                	lw	a0,0(a5)
    80006070:	00000097          	auipc	ra,0x0
    80006074:	d44080e7          	jalr	-700(ra) # 80005db4 <printint>
    80006078:	bdb9                	j	80005ed6 <printf+0x94>
    8000607a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000607c:	f8843783          	ld	a5,-120(s0)
    80006080:	00878713          	addi	a4,a5,8
    80006084:	f8e43423          	sd	a4,-120(s0)
    80006088:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000608c:	03000513          	li	a0,48
    80006090:	00000097          	auipc	ra,0x0
    80006094:	af6080e7          	jalr	-1290(ra) # 80005b86 <consputc>
  consputc('x');
    80006098:	07800513          	li	a0,120
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	aea080e7          	jalr	-1302(ra) # 80005b86 <consputc>
    800060a4:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060a6:	00003b97          	auipc	s7,0x3
    800060aa:	952b8b93          	addi	s7,s7,-1710 # 800089f8 <digits>
    800060ae:	03c9d793          	srli	a5,s3,0x3c
    800060b2:	97de                	add	a5,a5,s7
    800060b4:	0007c503          	lbu	a0,0(a5)
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	ace080e7          	jalr	-1330(ra) # 80005b86 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060c0:	0992                	slli	s3,s3,0x4
    800060c2:	397d                	addiw	s2,s2,-1
    800060c4:	fe0915e3          	bnez	s2,800060ae <printf+0x26c>
    800060c8:	6ba6                	ld	s7,72(sp)
    800060ca:	b531                	j	80005ed6 <printf+0x94>
      if((s = va_arg(ap, char*)) == 0)
    800060cc:	f8843783          	ld	a5,-120(s0)
    800060d0:	00878713          	addi	a4,a5,8
    800060d4:	f8e43423          	sd	a4,-120(s0)
    800060d8:	0007b903          	ld	s2,0(a5)
    800060dc:	00090f63          	beqz	s2,800060fa <printf+0x2b8>
      for(; *s; s++)
    800060e0:	00094503          	lbu	a0,0(s2)
    800060e4:	de0509e3          	beqz	a0,80005ed6 <printf+0x94>
        consputc(*s);
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	a9e080e7          	jalr	-1378(ra) # 80005b86 <consputc>
      for(; *s; s++)
    800060f0:	0905                	addi	s2,s2,1
    800060f2:	00094503          	lbu	a0,0(s2)
    800060f6:	f96d                	bnez	a0,800060e8 <printf+0x2a6>
    800060f8:	bbf9                	j	80005ed6 <printf+0x94>
        s = "(null)";
    800060fa:	00002917          	auipc	s2,0x2
    800060fe:	6de90913          	addi	s2,s2,1758 # 800087d8 <etext+0x7d8>
      for(; *s; s++)
    80006102:	02800513          	li	a0,40
    80006106:	b7cd                	j	800060e8 <printf+0x2a6>
      consputc('%');
    80006108:	02500513          	li	a0,37
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	a7a080e7          	jalr	-1414(ra) # 80005b86 <consputc>
    80006114:	b3c9                	j	80005ed6 <printf+0x94>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80006116:	f7843783          	ld	a5,-136(s0)
    8000611a:	e385                	bnez	a5,8000613a <printf+0x2f8>
    8000611c:	74e6                	ld	s1,120(sp)
    8000611e:	7946                	ld	s2,112(sp)
    80006120:	79a6                	ld	s3,104(sp)
    80006122:	6ae6                	ld	s5,88(sp)
    80006124:	6b46                	ld	s6,80(sp)
    80006126:	6c06                	ld	s8,64(sp)
    80006128:	7ce2                	ld	s9,56(sp)
    8000612a:	7d42                	ld	s10,48(sp)
    8000612c:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    8000612e:	4501                	li	a0,0
    80006130:	60aa                	ld	ra,136(sp)
    80006132:	640a                	ld	s0,128(sp)
    80006134:	7a06                	ld	s4,96(sp)
    80006136:	6169                	addi	sp,sp,208
    80006138:	8082                	ret
    8000613a:	74e6                	ld	s1,120(sp)
    8000613c:	7946                	ld	s2,112(sp)
    8000613e:	79a6                	ld	s3,104(sp)
    80006140:	6ae6                	ld	s5,88(sp)
    80006142:	6b46                	ld	s6,80(sp)
    80006144:	6c06                	ld	s8,64(sp)
    80006146:	7ce2                	ld	s9,56(sp)
    80006148:	7d42                	ld	s10,48(sp)
    8000614a:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    8000614c:	0001f517          	auipc	a0,0x1f
    80006150:	87c50513          	addi	a0,a0,-1924 # 800249c8 <pr>
    80006154:	00000097          	auipc	ra,0x0
    80006158:	438080e7          	jalr	1080(ra) # 8000658c <release>
    8000615c:	bfc9                	j	8000612e <printf+0x2ec>

000000008000615e <panic>:

void
panic(char *s)
{
    8000615e:	1101                	addi	sp,sp,-32
    80006160:	ec06                	sd	ra,24(sp)
    80006162:	e822                	sd	s0,16(sp)
    80006164:	e426                	sd	s1,8(sp)
    80006166:	1000                	addi	s0,sp,32
    80006168:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000616a:	0001f797          	auipc	a5,0x1f
    8000616e:	8607ab23          	sw	zero,-1930(a5) # 800249e0 <pr+0x18>
  printf("panic: ");
    80006172:	00002517          	auipc	a0,0x2
    80006176:	66e50513          	addi	a0,a0,1646 # 800087e0 <etext+0x7e0>
    8000617a:	00000097          	auipc	ra,0x0
    8000617e:	cc8080e7          	jalr	-824(ra) # 80005e42 <printf>
  printf("%s\n", s);
    80006182:	85a6                	mv	a1,s1
    80006184:	00002517          	auipc	a0,0x2
    80006188:	66450513          	addi	a0,a0,1636 # 800087e8 <etext+0x7e8>
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	cb6080e7          	jalr	-842(ra) # 80005e42 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006194:	4785                	li	a5,1
    80006196:	00005717          	auipc	a4,0x5
    8000619a:	34f72323          	sw	a5,838(a4) # 8000b4dc <panicked>
  for(;;)
    8000619e:	a001                	j	8000619e <panic+0x40>

00000000800061a0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800061a0:	1101                	addi	sp,sp,-32
    800061a2:	ec06                	sd	ra,24(sp)
    800061a4:	e822                	sd	s0,16(sp)
    800061a6:	e426                	sd	s1,8(sp)
    800061a8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800061aa:	0001f497          	auipc	s1,0x1f
    800061ae:	81e48493          	addi	s1,s1,-2018 # 800249c8 <pr>
    800061b2:	00002597          	auipc	a1,0x2
    800061b6:	63e58593          	addi	a1,a1,1598 # 800087f0 <etext+0x7f0>
    800061ba:	8526                	mv	a0,s1
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	28c080e7          	jalr	652(ra) # 80006448 <initlock>
  pr.locking = 1;
    800061c4:	4785                	li	a5,1
    800061c6:	cc9c                	sw	a5,24(s1)
}
    800061c8:	60e2                	ld	ra,24(sp)
    800061ca:	6442                	ld	s0,16(sp)
    800061cc:	64a2                	ld	s1,8(sp)
    800061ce:	6105                	addi	sp,sp,32
    800061d0:	8082                	ret

00000000800061d2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061d2:	1141                	addi	sp,sp,-16
    800061d4:	e406                	sd	ra,8(sp)
    800061d6:	e022                	sd	s0,0(sp)
    800061d8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061da:	100007b7          	lui	a5,0x10000
    800061de:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061e2:	10000737          	lui	a4,0x10000
    800061e6:	f8000693          	li	a3,-128
    800061ea:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061ee:	468d                	li	a3,3
    800061f0:	10000637          	lui	a2,0x10000
    800061f4:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061f8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061fc:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006200:	8732                	mv	a4,a2
    80006202:	461d                	li	a2,7
    80006204:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006208:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000620c:	00002597          	auipc	a1,0x2
    80006210:	5ec58593          	addi	a1,a1,1516 # 800087f8 <etext+0x7f8>
    80006214:	0001e517          	auipc	a0,0x1e
    80006218:	7d450513          	addi	a0,a0,2004 # 800249e8 <uart_tx_lock>
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	22c080e7          	jalr	556(ra) # 80006448 <initlock>
}
    80006224:	60a2                	ld	ra,8(sp)
    80006226:	6402                	ld	s0,0(sp)
    80006228:	0141                	addi	sp,sp,16
    8000622a:	8082                	ret

000000008000622c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000622c:	1101                	addi	sp,sp,-32
    8000622e:	ec06                	sd	ra,24(sp)
    80006230:	e822                	sd	s0,16(sp)
    80006232:	e426                	sd	s1,8(sp)
    80006234:	1000                	addi	s0,sp,32
    80006236:	84aa                	mv	s1,a0
  push_off();
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	258080e7          	jalr	600(ra) # 80006490 <push_off>

  if(panicked){
    80006240:	00005797          	auipc	a5,0x5
    80006244:	29c7a783          	lw	a5,668(a5) # 8000b4dc <panicked>
    80006248:	eb85                	bnez	a5,80006278 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000624a:	10000737          	lui	a4,0x10000
    8000624e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006250:	00074783          	lbu	a5,0(a4)
    80006254:	0207f793          	andi	a5,a5,32
    80006258:	dfe5                	beqz	a5,80006250 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000625a:	0ff4f513          	zext.b	a0,s1
    8000625e:	100007b7          	lui	a5,0x10000
    80006262:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	2ca080e7          	jalr	714(ra) # 80006530 <pop_off>
}
    8000626e:	60e2                	ld	ra,24(sp)
    80006270:	6442                	ld	s0,16(sp)
    80006272:	64a2                	ld	s1,8(sp)
    80006274:	6105                	addi	sp,sp,32
    80006276:	8082                	ret
    for(;;)
    80006278:	a001                	j	80006278 <uartputc_sync+0x4c>

000000008000627a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000627a:	00005797          	auipc	a5,0x5
    8000627e:	2667b783          	ld	a5,614(a5) # 8000b4e0 <uart_tx_r>
    80006282:	00005717          	auipc	a4,0x5
    80006286:	26673703          	ld	a4,614(a4) # 8000b4e8 <uart_tx_w>
    8000628a:	08f70363          	beq	a4,a5,80006310 <uartstart+0x96>
{
    8000628e:	7139                	addi	sp,sp,-64
    80006290:	fc06                	sd	ra,56(sp)
    80006292:	f822                	sd	s0,48(sp)
    80006294:	f426                	sd	s1,40(sp)
    80006296:	f04a                	sd	s2,32(sp)
    80006298:	ec4e                	sd	s3,24(sp)
    8000629a:	e852                	sd	s4,16(sp)
    8000629c:	e456                	sd	s5,8(sp)
    8000629e:	e05a                	sd	s6,0(sp)
    800062a0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062a2:	10000937          	lui	s2,0x10000
    800062a6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062a8:	0001ea97          	auipc	s5,0x1e
    800062ac:	740a8a93          	addi	s5,s5,1856 # 800249e8 <uart_tx_lock>
    uart_tx_r += 1;
    800062b0:	00005497          	auipc	s1,0x5
    800062b4:	23048493          	addi	s1,s1,560 # 8000b4e0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800062b8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800062bc:	00005997          	auipc	s3,0x5
    800062c0:	22c98993          	addi	s3,s3,556 # 8000b4e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062c4:	00094703          	lbu	a4,0(s2)
    800062c8:	02077713          	andi	a4,a4,32
    800062cc:	cb05                	beqz	a4,800062fc <uartstart+0x82>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062ce:	01f7f713          	andi	a4,a5,31
    800062d2:	9756                	add	a4,a4,s5
    800062d4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800062d8:	0785                	addi	a5,a5,1
    800062da:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800062dc:	8526                	mv	a0,s1
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	3da080e7          	jalr	986(ra) # 800016b8 <wakeup>
    WriteReg(THR, c);
    800062e6:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800062ea:	609c                	ld	a5,0(s1)
    800062ec:	0009b703          	ld	a4,0(s3)
    800062f0:	fcf71ae3          	bne	a4,a5,800062c4 <uartstart+0x4a>
      ReadReg(ISR);
    800062f4:	100007b7          	lui	a5,0x10000
    800062f8:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800062fc:	70e2                	ld	ra,56(sp)
    800062fe:	7442                	ld	s0,48(sp)
    80006300:	74a2                	ld	s1,40(sp)
    80006302:	7902                	ld	s2,32(sp)
    80006304:	69e2                	ld	s3,24(sp)
    80006306:	6a42                	ld	s4,16(sp)
    80006308:	6aa2                	ld	s5,8(sp)
    8000630a:	6b02                	ld	s6,0(sp)
    8000630c:	6121                	addi	sp,sp,64
    8000630e:	8082                	ret
      ReadReg(ISR);
    80006310:	100007b7          	lui	a5,0x10000
    80006314:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80006318:	8082                	ret

000000008000631a <uartputc>:
{
    8000631a:	7179                	addi	sp,sp,-48
    8000631c:	f406                	sd	ra,40(sp)
    8000631e:	f022                	sd	s0,32(sp)
    80006320:	ec26                	sd	s1,24(sp)
    80006322:	e84a                	sd	s2,16(sp)
    80006324:	e44e                	sd	s3,8(sp)
    80006326:	e052                	sd	s4,0(sp)
    80006328:	1800                	addi	s0,sp,48
    8000632a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000632c:	0001e517          	auipc	a0,0x1e
    80006330:	6bc50513          	addi	a0,a0,1724 # 800249e8 <uart_tx_lock>
    80006334:	00000097          	auipc	ra,0x0
    80006338:	1a8080e7          	jalr	424(ra) # 800064dc <acquire>
  if(panicked){
    8000633c:	00005797          	auipc	a5,0x5
    80006340:	1a07a783          	lw	a5,416(a5) # 8000b4dc <panicked>
    80006344:	e7c9                	bnez	a5,800063ce <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006346:	00005717          	auipc	a4,0x5
    8000634a:	1a273703          	ld	a4,418(a4) # 8000b4e8 <uart_tx_w>
    8000634e:	00005797          	auipc	a5,0x5
    80006352:	1927b783          	ld	a5,402(a5) # 8000b4e0 <uart_tx_r>
    80006356:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000635a:	0001e997          	auipc	s3,0x1e
    8000635e:	68e98993          	addi	s3,s3,1678 # 800249e8 <uart_tx_lock>
    80006362:	00005497          	auipc	s1,0x5
    80006366:	17e48493          	addi	s1,s1,382 # 8000b4e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000636a:	00005917          	auipc	s2,0x5
    8000636e:	17e90913          	addi	s2,s2,382 # 8000b4e8 <uart_tx_w>
    80006372:	00e79f63          	bne	a5,a4,80006390 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006376:	85ce                	mv	a1,s3
    80006378:	8526                	mv	a0,s1
    8000637a:	ffffb097          	auipc	ra,0xffffb
    8000637e:	2da080e7          	jalr	730(ra) # 80001654 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006382:	00093703          	ld	a4,0(s2)
    80006386:	609c                	ld	a5,0(s1)
    80006388:	02078793          	addi	a5,a5,32
    8000638c:	fee785e3          	beq	a5,a4,80006376 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006390:	0001e497          	auipc	s1,0x1e
    80006394:	65848493          	addi	s1,s1,1624 # 800249e8 <uart_tx_lock>
    80006398:	01f77793          	andi	a5,a4,31
    8000639c:	97a6                	add	a5,a5,s1
    8000639e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800063a2:	0705                	addi	a4,a4,1
    800063a4:	00005797          	auipc	a5,0x5
    800063a8:	14e7b223          	sd	a4,324(a5) # 8000b4e8 <uart_tx_w>
  uartstart();
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	ece080e7          	jalr	-306(ra) # 8000627a <uartstart>
  release(&uart_tx_lock);
    800063b4:	8526                	mv	a0,s1
    800063b6:	00000097          	auipc	ra,0x0
    800063ba:	1d6080e7          	jalr	470(ra) # 8000658c <release>
}
    800063be:	70a2                	ld	ra,40(sp)
    800063c0:	7402                	ld	s0,32(sp)
    800063c2:	64e2                	ld	s1,24(sp)
    800063c4:	6942                	ld	s2,16(sp)
    800063c6:	69a2                	ld	s3,8(sp)
    800063c8:	6a02                	ld	s4,0(sp)
    800063ca:	6145                	addi	sp,sp,48
    800063cc:	8082                	ret
    for(;;)
    800063ce:	a001                	j	800063ce <uartputc+0xb4>

00000000800063d0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063d0:	1141                	addi	sp,sp,-16
    800063d2:	e406                	sd	ra,8(sp)
    800063d4:	e022                	sd	s0,0(sp)
    800063d6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063d8:	100007b7          	lui	a5,0x10000
    800063dc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800063e0:	8b85                	andi	a5,a5,1
    800063e2:	cb89                	beqz	a5,800063f4 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800063e4:	100007b7          	lui	a5,0x10000
    800063e8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800063ec:	60a2                	ld	ra,8(sp)
    800063ee:	6402                	ld	s0,0(sp)
    800063f0:	0141                	addi	sp,sp,16
    800063f2:	8082                	ret
    return -1;
    800063f4:	557d                	li	a0,-1
    800063f6:	bfdd                	j	800063ec <uartgetc+0x1c>

00000000800063f8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800063f8:	1101                	addi	sp,sp,-32
    800063fa:	ec06                	sd	ra,24(sp)
    800063fc:	e822                	sd	s0,16(sp)
    800063fe:	e426                	sd	s1,8(sp)
    80006400:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006402:	54fd                	li	s1,-1
    int c = uartgetc();
    80006404:	00000097          	auipc	ra,0x0
    80006408:	fcc080e7          	jalr	-52(ra) # 800063d0 <uartgetc>
    if(c == -1)
    8000640c:	00950763          	beq	a0,s1,8000641a <uartintr+0x22>
      break;
    consoleintr(c);
    80006410:	fffff097          	auipc	ra,0xfffff
    80006414:	7b8080e7          	jalr	1976(ra) # 80005bc8 <consoleintr>
  while(1){
    80006418:	b7f5                	j	80006404 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000641a:	0001e497          	auipc	s1,0x1e
    8000641e:	5ce48493          	addi	s1,s1,1486 # 800249e8 <uart_tx_lock>
    80006422:	8526                	mv	a0,s1
    80006424:	00000097          	auipc	ra,0x0
    80006428:	0b8080e7          	jalr	184(ra) # 800064dc <acquire>
  uartstart();
    8000642c:	00000097          	auipc	ra,0x0
    80006430:	e4e080e7          	jalr	-434(ra) # 8000627a <uartstart>
  release(&uart_tx_lock);
    80006434:	8526                	mv	a0,s1
    80006436:	00000097          	auipc	ra,0x0
    8000643a:	156080e7          	jalr	342(ra) # 8000658c <release>
}
    8000643e:	60e2                	ld	ra,24(sp)
    80006440:	6442                	ld	s0,16(sp)
    80006442:	64a2                	ld	s1,8(sp)
    80006444:	6105                	addi	sp,sp,32
    80006446:	8082                	ret

0000000080006448 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006448:	1141                	addi	sp,sp,-16
    8000644a:	e406                	sd	ra,8(sp)
    8000644c:	e022                	sd	s0,0(sp)
    8000644e:	0800                	addi	s0,sp,16
  lk->name = name;
    80006450:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006452:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006456:	00053823          	sd	zero,16(a0)
}
    8000645a:	60a2                	ld	ra,8(sp)
    8000645c:	6402                	ld	s0,0(sp)
    8000645e:	0141                	addi	sp,sp,16
    80006460:	8082                	ret

0000000080006462 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006462:	411c                	lw	a5,0(a0)
    80006464:	e399                	bnez	a5,8000646a <holding+0x8>
    80006466:	4501                	li	a0,0
  return r;
}
    80006468:	8082                	ret
{
    8000646a:	1101                	addi	sp,sp,-32
    8000646c:	ec06                	sd	ra,24(sp)
    8000646e:	e822                	sd	s0,16(sp)
    80006470:	e426                	sd	s1,8(sp)
    80006472:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006474:	6904                	ld	s1,16(a0)
    80006476:	ffffb097          	auipc	ra,0xffffb
    8000647a:	ae4080e7          	jalr	-1308(ra) # 80000f5a <mycpu>
    8000647e:	40a48533          	sub	a0,s1,a0
    80006482:	00153513          	seqz	a0,a0
}
    80006486:	60e2                	ld	ra,24(sp)
    80006488:	6442                	ld	s0,16(sp)
    8000648a:	64a2                	ld	s1,8(sp)
    8000648c:	6105                	addi	sp,sp,32
    8000648e:	8082                	ret

0000000080006490 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006490:	1101                	addi	sp,sp,-32
    80006492:	ec06                	sd	ra,24(sp)
    80006494:	e822                	sd	s0,16(sp)
    80006496:	e426                	sd	s1,8(sp)
    80006498:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000649a:	100024f3          	csrr	s1,sstatus
    8000649e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064a2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064a4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064a8:	ffffb097          	auipc	ra,0xffffb
    800064ac:	ab2080e7          	jalr	-1358(ra) # 80000f5a <mycpu>
    800064b0:	5d3c                	lw	a5,120(a0)
    800064b2:	cf89                	beqz	a5,800064cc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800064b4:	ffffb097          	auipc	ra,0xffffb
    800064b8:	aa6080e7          	jalr	-1370(ra) # 80000f5a <mycpu>
    800064bc:	5d3c                	lw	a5,120(a0)
    800064be:	2785                	addiw	a5,a5,1
    800064c0:	dd3c                	sw	a5,120(a0)
}
    800064c2:	60e2                	ld	ra,24(sp)
    800064c4:	6442                	ld	s0,16(sp)
    800064c6:	64a2                	ld	s1,8(sp)
    800064c8:	6105                	addi	sp,sp,32
    800064ca:	8082                	ret
    mycpu()->intena = old;
    800064cc:	ffffb097          	auipc	ra,0xffffb
    800064d0:	a8e080e7          	jalr	-1394(ra) # 80000f5a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800064d4:	8085                	srli	s1,s1,0x1
    800064d6:	8885                	andi	s1,s1,1
    800064d8:	dd64                	sw	s1,124(a0)
    800064da:	bfe9                	j	800064b4 <push_off+0x24>

00000000800064dc <acquire>:
{
    800064dc:	1101                	addi	sp,sp,-32
    800064de:	ec06                	sd	ra,24(sp)
    800064e0:	e822                	sd	s0,16(sp)
    800064e2:	e426                	sd	s1,8(sp)
    800064e4:	1000                	addi	s0,sp,32
    800064e6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800064e8:	00000097          	auipc	ra,0x0
    800064ec:	fa8080e7          	jalr	-88(ra) # 80006490 <push_off>
  if(holding(lk))
    800064f0:	8526                	mv	a0,s1
    800064f2:	00000097          	auipc	ra,0x0
    800064f6:	f70080e7          	jalr	-144(ra) # 80006462 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064fa:	4705                	li	a4,1
  if(holding(lk))
    800064fc:	e115                	bnez	a0,80006520 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064fe:	87ba                	mv	a5,a4
    80006500:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006504:	2781                	sext.w	a5,a5
    80006506:	ffe5                	bnez	a5,800064fe <acquire+0x22>
  __sync_synchronize();
    80006508:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000650c:	ffffb097          	auipc	ra,0xffffb
    80006510:	a4e080e7          	jalr	-1458(ra) # 80000f5a <mycpu>
    80006514:	e888                	sd	a0,16(s1)
}
    80006516:	60e2                	ld	ra,24(sp)
    80006518:	6442                	ld	s0,16(sp)
    8000651a:	64a2                	ld	s1,8(sp)
    8000651c:	6105                	addi	sp,sp,32
    8000651e:	8082                	ret
    panic("acquire");
    80006520:	00002517          	auipc	a0,0x2
    80006524:	2e050513          	addi	a0,a0,736 # 80008800 <etext+0x800>
    80006528:	00000097          	auipc	ra,0x0
    8000652c:	c36080e7          	jalr	-970(ra) # 8000615e <panic>

0000000080006530 <pop_off>:

void
pop_off(void)
{
    80006530:	1141                	addi	sp,sp,-16
    80006532:	e406                	sd	ra,8(sp)
    80006534:	e022                	sd	s0,0(sp)
    80006536:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006538:	ffffb097          	auipc	ra,0xffffb
    8000653c:	a22080e7          	jalr	-1502(ra) # 80000f5a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006540:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006544:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006546:	e39d                	bnez	a5,8000656c <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006548:	5d3c                	lw	a5,120(a0)
    8000654a:	02f05963          	blez	a5,8000657c <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    8000654e:	37fd                	addiw	a5,a5,-1
    80006550:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006552:	eb89                	bnez	a5,80006564 <pop_off+0x34>
    80006554:	5d7c                	lw	a5,124(a0)
    80006556:	c799                	beqz	a5,80006564 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006558:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000655c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006560:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006564:	60a2                	ld	ra,8(sp)
    80006566:	6402                	ld	s0,0(sp)
    80006568:	0141                	addi	sp,sp,16
    8000656a:	8082                	ret
    panic("pop_off - interruptible");
    8000656c:	00002517          	auipc	a0,0x2
    80006570:	29c50513          	addi	a0,a0,668 # 80008808 <etext+0x808>
    80006574:	00000097          	auipc	ra,0x0
    80006578:	bea080e7          	jalr	-1046(ra) # 8000615e <panic>
    panic("pop_off");
    8000657c:	00002517          	auipc	a0,0x2
    80006580:	2a450513          	addi	a0,a0,676 # 80008820 <etext+0x820>
    80006584:	00000097          	auipc	ra,0x0
    80006588:	bda080e7          	jalr	-1062(ra) # 8000615e <panic>

000000008000658c <release>:
{
    8000658c:	1101                	addi	sp,sp,-32
    8000658e:	ec06                	sd	ra,24(sp)
    80006590:	e822                	sd	s0,16(sp)
    80006592:	e426                	sd	s1,8(sp)
    80006594:	1000                	addi	s0,sp,32
    80006596:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006598:	00000097          	auipc	ra,0x0
    8000659c:	eca080e7          	jalr	-310(ra) # 80006462 <holding>
    800065a0:	c115                	beqz	a0,800065c4 <release+0x38>
  lk->cpu = 0;
    800065a2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800065a6:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800065aa:	0310000f          	fence	rw,w
    800065ae:	0004a023          	sw	zero,0(s1)
  pop_off();
    800065b2:	00000097          	auipc	ra,0x0
    800065b6:	f7e080e7          	jalr	-130(ra) # 80006530 <pop_off>
}
    800065ba:	60e2                	ld	ra,24(sp)
    800065bc:	6442                	ld	s0,16(sp)
    800065be:	64a2                	ld	s1,8(sp)
    800065c0:	6105                	addi	sp,sp,32
    800065c2:	8082                	ret
    panic("release");
    800065c4:	00002517          	auipc	a0,0x2
    800065c8:	26450513          	addi	a0,a0,612 # 80008828 <etext+0x828>
    800065cc:	00000097          	auipc	ra,0x0
    800065d0:	b92080e7          	jalr	-1134(ra) # 8000615e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
