### 数据类型

> ##### 基础类型

Boolean类型

```
let isDone: boolean = false; 
```

Number类型

```
let count: number = 10;
```

String类型

```
let name: string = "Mike";
```

Array类型

```
let list1: number[] = [1, 2, 3];
let list2: Array<number> = [1, 2, 3];
```

enum 枚举
枚举是真实的对象

```
// 数字枚举
enum Direction {  NORTH,  SOUTH,  EAST,  WEST, }
let dir: Direction = Direction.NORTH;

// 字符串枚举
enum Direction {  NORTH = "north",  SOUTH = "south",  EAST = "east",  WEST = "west", }

// 异构枚举 (数字和字符串的混合)
enum Enum {  A,  B,  C = "C",  D = "D",  E = 8,  F,}

// 数字枚举相对字符串枚举多了 “反向映射”，可以通过枚举的值获取到对应的键key
console.log(Enum.A)  // 输出：0
console.log(Enum[0]) // 输出："A"

枚举成员是只读的
Enum.A = 2; // Error: Cannot assign to A because it is read-only property
```

数字枚举默认从0起始，也可以指定初始值

```
enum Direction {  NORTH = 6,  SOUTH,  EAST,  WEST, }
```

Any 类型
在 TS中，任何类型都可归为 any 类型。 any 类型为类型系统的顶级类型（全局超级类型）

```
let notSure: any = 666;
console.log(notSure) // 666
notSure = "Semlinker";
console.log(notSure) // "Semlinker" 
notSure = false;
console.log(notSure) // false
```

Unknown 类型

有时候使用 any 类型，容易编写出类型正确但在运行时有问题的代码，无法使用 TS 提供的大量的保护机制。为了解决 any 带来的问题，TypeScript 3.0 引入了 unknown 类型。unknown 成为 TS类型系统的另一种顶级类型。

```
 let value: unknown;
 ​
 value = true; // OK
 console.log(value)
 value = 42; // OK
 console.log(value)
 value = "Hello World"; // OK
 console.log(value)
 value = []; // OK
 console.log(value)
 value = {}; // OK
 console.log(value)
 value = Math.random; // OK
 console.log(value)
 value = null; // OK
 console.log(value)
 value = undefined; // OK
 console.log(value)
 value = new TypeError(); // OK
 console.log(value)
 value = Symbol("type"); // OK
 console.log(value)
```

unknown 类型只能被赋值给 any 类型和 unknown 类型本身

```
let value: unknown;
let value1: unknown = value; // OK
let value2: any = value; // OK
let value3: boolean = value; // Error
let value4: number = value; // Error
let value5: string = value; // Error
let value6: object = value; // Error
let value7: any[] = value; // Error
let value8: Function = value; // Error
```

Tuple 元组类型
数组一般由同种类型的值组成，但有时我们需要在单个变量中存储不同类型的值，这时候我们就可以使用元组

```
let tupleType: [string, boolean];
tupleType = ["Semlinker", true];
console.log(tupleType[0]); // "Semlinker"
console.log(tupleType[1]); // true

由于一般元组是知道元素数量和对应类型，所以可以对元组的下标访问是否越界和具体元素的操作是否合法做检查。
function  doSomething(pair: [string, number]) {
	console.log('First value:', pair[0]);
	console.log('Third value:', pair[2]); // Error:Tuple type [string, number] of length 2 has np element at index 2;
	console.log(pair[1].split('-')); // Error:property split does not exist on type number
}

上面说一般情况是因为，元组 支持可选元素和扩展元素，造成元组实际长度不定。
可选元素只出现在队尾
type MyTuple = [number, string, bool?];
const tuple1: MyTuple = [1,  '2'];
const tuple2: MyTuple = [1,  '2', true];

扩展元素，类型前添加 ... 表示他是一个扩展元素
type StringNumberBooleans = [string, number, ...boolean]; //前两个元素为string,number,剩下元素都为boolean
type StringNumbersBoolean = [string, ...number, boolean]; //首尾两个元素为string,boolean,中间元素都为number
type StringsNumberBoolean = [...string, number, boolean]; // 最后两个元素为number,boolean，前面元素为string
```


Void类型
某种程度上来说，void 类型像是与 any 类型相反，它表示没有任何类型。

```
// 声明函数返回值为void
function warnUser(): void {  
	console.log("This is my warning message");
}

// 注意：声明 void 类型的变量没有什么作用，因为它的值只能为 undefined 或 null：
let unusable: void = undefined;
```

Null 和 Undefined 类型

默认情况下 null 和 undefined 是所有类型的子类型。 就是说你可以把 null 和 undefined 赋值给 number 类型的变量。然而，如果你指定了--strictNullChecks 标记，null 和 undefined 只能赋值给 void 和它们各自的类型。

```
let u: undefined = undefined;
let n: null = null;
```

Never 类型

never 类型表示的是那些永不存在的值的类型。 例如，never 类型是那些总是会抛出异常或根本就不会有返回值的函数表达式或箭头函数表达式的返回值类型。

```
// 返回never的函数必须存在无法达到的终点
 function error(message: string): never {
   throw new Error(message);
 }
 ​
 function infiniteLoop(): never {
   while (true) {}
 }
```


在 TypeScript 中，可以利用 never 类型的特性来实现全面性检查

```
type Foo = string | number;
 ​
 function controlFlowAnalysisWithNever(foo: Foo) {
   if (typeof foo === "string") {
     // 这里 foo 被收窄为 string 类型
   } else if (typeof foo === "number") {
     // 这里 foo 被收窄为 number 类型
   } else {
     // foo 在这里是 never
     const check: never = foo;
   }
 }
 
 注意在 else 分支里面，我们把收窄为 never 的 foo 赋值给一个显示声明的 never 变量。如果一切逻辑正确，那么这里应该能够编译通过。但是假如后来有一天你的同事修改了 Foo 的类型：

 type Foo = string | number | boolean;
然而他忘记同时修改 controlFlowAnalysisWithNever 方法中的控制流程，这时候 else 分支的 foo 类型会被收窄为 boolean 类型，导致无法赋值给 never 类型，这时就会产生一个编译错误。通过这个方式，我们可以确保

controlFlowAnalysisWithNever 方法总是穷尽了 Foo 的所有可能类型。 通过这个示例，我们可以得出一个结论：使用 never 避免出现新增了联合类型没有对应的实现，目的就是写出类型绝对安全的代码。
```

> ##### 复杂类型

union联合类型
表示其中任意一种类型都可以，除了类型联合还可以联合具体值

```
function printId(id: number | string) {
	console.log('Your  ID is:', id);
}

function printText(s: string, alignment: 'left' | 'right' | 'center') {

}
```

注意：联合类型时，只有共有的属性或方法才可以直接用

```
function printInfo(val: string | number) {
	if (typeof val:split === 'function') { // Error:property  split doest not exist on type number
		console.log(val.split(','));
	}
}
```

type 类型别名

```
// 可以给任意类型添加命名
type Point = { x: number;  y: number; }
function printCoord(pt: Point) {
	console.log("coordinate's x and y is:", pt.x, pt.y);
}

// 还可以用 & 将多个类型组合
type Animal = { name: string; eat: () => void; }
type DogAction = { bark: () => void; walk: () => void; }
type Dog = Animal & DogAction; // 组合
let dog: Dog;
dog.walk();
```

interface 接口类型

```
interface Point {
	x: number;
	y: number;
}
function printCoord(pt: Point) {
	console.log("coordinate's x and y is:", pt.x, pt.y);
}
```

extends 继承

```
interface Animal {
	name: string;
	eat: () => void;
}

interface Dog extends Animal {
	bark: () => void;
}

let dog: Dog;
dog.bark();
```

type 和 interface 区别

```
1. interface只能声明对象类型，type能声明对象类型，或起别名简单类型和union联合类型
interface Info {
	name: string;
}
type Info = {
	desc: string;
}
type TimeInterval = number;
type ValueType = string | number; 

2. interface重复声明会合并，type不能重复声明
interface Info {
	name:  string;
}
interface Info {
	desc: string;
}

type Person = {
	name: string;
}
// 再声明相同名称会报错
type Person =  {
	desc: string;
}

3. type  使用 & 实现类型合并，interface使用 extends 实现继承

interface Animal {
	name: string;
	eat: () => void;
}

interface Dog extends Animal {
	bark: () => void;
}

type Person = Animal & {
	age: number;
}
```

> ##### 对象

```
inteface Person {
	readonly id: string; // 只读修饰符，属性初始化后不能再修改
	phone?: number; // 可选修饰符，该属性可以不赋值
}
let student: Person = {
 id: '111111';
}
student.id = '22222'; // error

使用可选属性前要检查存在性
function printName(obj: { first: string, last?: string}) {
	console.log(obj.last.toUpperCase()); // Error obj.last is possibly undefined
	// 可使用下面两种形式
	if (obj.laset !== undefined) {
		console.log(obj.last.toUpperCase()); 
	}
	console.log(obj.last?.toUpperCase()); 
}

readonly 是不能更新引用，并不是不能更改值
type PersonalInfo = {
	readonly baseInfo: {
		name: string;
		age: number;
	}
}

function getPersonInfo(person: PersonalInfo) {
	person.baseInfo.age++; // 可以
	person.baseInfo = { name: "LiBai", } // error
}
```

> ##### 类型转换断言

```
有时候你会遇到这样的情况，你会比 TypeScript 更了解某个值的详细信息。通常这会发生在你清楚地知道一个实体具有比它现有类型更确切的类型。

通过类型断言这种方式可以告诉编译器，“相信我，我知道自己在干什么”。类型断言好比其他语言里的类型转换，但是不进行特殊的数据检查和解构。它没有运行时的影响，只是在编译阶段起作用。

类型断言有两种形式：
“尖括号” 语法
let someValue: any = "this is a string";
 let strLength: number = (<string>someValue).length;
 
 as 语法
 let someValue: any = "this is a string";
 let strLength: number = (someValue as string).length;
```

> ##### 类型守卫

```
类型保护是可执行运行时检查的一种表达式，用于确保该类型在一定的范围内。换句话说，类型保护可以保证一个字符串是一个字符串，尽管它的值也可以是一个数值。类型保护与特性检测并不是完全不同，其主要思想是尝试检测属性、方法或原型，以确定如何处理值。目前主要有四种的方式来实现类型保护：

in 关键字
interface Admin {
   name: string;
   privileges: string[];
 }
 ​
 interface Employee {
   name: string;
   startDate: Date;
 }
 ​
 type UnknownEmployee = Employee | Admin;
 ​
 function printEmployeeInformation(emp: UnknownEmployee) {
   console.log("Name: " + emp.name);
   if ("privileges" in emp) {
     console.log("Privileges: " + emp.privileges);
   }
   if ("startDate" in emp) {
     console.log("Start Date: " + emp.startDate);
   }
 }
 
 typeof 关键字
 function padLeft(value: string, padding: string | number) {
   if (typeof padding === "number") {
       return Array(padding + 1).join(" ") + value;
   }
   if (typeof padding === "string") {
       return padding + value;
   }
   throw new Error(`Expected string or number, got '${padding}'.`);
 }
 typeof 类型保护只支持两种形式：typeof v === "typename" 和 typeof v !== typename，"typename" 必须是 "number"， "string"， "boolean" 或 "symbol"。 但是 TypeScript 并不会阻止你与其它字符串比较，语言不会把那些表达式识别为类型保护。
 
 instanceof 关键字​
 interface Padder {
   getPaddingString(): string;
 }
 ​
 class SpaceRepeatingPadder implements Padder {
   constructor(private numSpaces: number) {}
   getPaddingString() {
     return Array(this.numSpaces + 1).join(" ");
   }
 }
 ​
 class StringPadder implements Padder {
   constructor(private value: string) {}
   getPaddingString() {
     return this.value;
   }
 }
 ​
 let padder: Padder = new SpaceRepeatingPadder(6);
 ​
 if (padder instanceof SpaceRepeatingPadder) {
   // padder的类型收窄为 'SpaceRepeatingPadder'
 }
 
 自定义类型保护的类型谓词
 function isNumber(x: any): x is number {
   return typeof x === "number";
 }
 ​
 function isString(x: any): x is string {
   return typeof x === "string";
 }
 
 
 function isFish(pet: Fish | Bird): pet is Fish {
  return  (pet as Fish).swim !== undefined; // 验证pet变量上是否存在swim属性
 }
 if （isFish(pet)）{
 	pet.swim();
 } else {
 	pet.fly();
 }
```

数组

```
两种方式
string[]
Array<string>

对于只读数组，同样两种方式
readonly string[]
ReadonlyArray<string>

const arr: readonly string[] = ['apple', 'banana'];
arr[1] =  'orange'; // error
arr.push('orange'); // error
```

函数

```
function 函数名(函数参数) 函数返回值 { return xxx; }
同样可以声明可选参数和只读参数
function fixed(n: number, digit?: string) {
	if (digit != undefined) {
		return n.toFixed(digit);
	}
	return '0';
}

func person(obj: { readonly id: number}) {
	obj.id ++; // error
}
```

TS支持函数重载：同名但参数类型或者数量不同

```
// 函数签名声明
function makeDate(timestamp: number): Date;
function makeDate(year: number, month: number, day: number): Date;

// 函数实现
function makeDate(yOrTimestamp: number, month?: number, day?: number): Date {
	if (month  !== undefined && day  !== undefined) {
		return new Date(yOrTimestamp, month, day);
	}
	return new Date(yOrTimestamp);
}

// 函数调用
const d1 = makeDate(1111111);
const d2 = makeDate(2024, 1, 1);
const d3 = makeDate(2024, 10); // Error:No overload expects 2 arguments.

// 但是能用union联合类型声明的，就不用重载声明，重载会把简单问题复杂化
// 函数签名声明
function len(s: string): number;
function len(arr: any[]): number;
// 函数实现
function len(x: any) {
	return x.length;
}
// 函数调用
len('hello');
len([1, 2, 3]);
len(age > 10 ? 'hello' : [1, 2, 3]); // Error, 编译时无法确定参数类型

如果用union就可以
function len2(x: string | any[]): number {
	return x.length;
}
len2(age > 10 ? 'hello' : [1, 2, 3]);  // 完美
```

泛型

```
// 泛型是用来描述同一类型在多个值之间的关联性
function getFirstElement(arr: any[]) {
    return arr[0];
}

// 如果返回值的类型能明确地与入参数组的元素类型关联上就好了
function getFirstElement<Type>(arr: Type[]): Type {
    return arr[0];
}

// 同时我们还可以使用 extends 关键字 对泛型增加限制
// 比如我们需要实现一个 在两元素中返回 length 属性最大的那个元素 方法
function getLonger<Type extends { length: number }>(a: Type, b: Type): Type {
    if (a.length > b.length) {
        return a;
    }
    return b;
}
getLonger(10, 20); // ❌ Error: Argument of type 'number' is not assignable to parameter of type '{ length: number; }'.
getLonger([10], [20]); // ✅ OK.
```

对象

```
索引签名 index signature

在实际项目中会存在这样一种情况: 咱不知道一个类型里所有的属性值，但巧的是咱知道属性 key 和对应值的类型
此时就可以用索引签名来进行类型声明
比如可以这样声明一个下标是数字、值是字符串的对象:
interface StringArray {
    [index: number]: string;
}

const myArray: StringArray = getStringArray();
myArrsy[0]; // type: string;

But 只有 string、number 和 symbol 可以用作对象 key 的类型，这也符合 JS 语言中对象 key 类型的范围
如果对象的属性有不同类型，我们可以用 union 联合类型来声明值的类型:
interface NumberOrStringDic {
    [key: string]: number | string;
    length: number;
    name: string; // ✅ It's OK.
}

最后，我们也可以给索引签名增加 readonly 前缀来防止属性被重新赋值
interface ReadonlyStringArray {
    readonly [index: number]: string;
}

const myArray: ReadonlyStringArray = getReadonlyStringArray();
myArray[0] = 'Daniel'; // ❌ Error: Index signature in type 'ReadonlyStringArray' only permits reading.
```

* [来吧，一起对 TypeScript 扫盲吧！](https://mp.weixin.qq.com/s/cPUVZxlr7oPS1VyQNdsPSA)
* [最全TypeScript 入门基础教程，看完就会，了不起](https://zhuanlan.zhihu.com/p/302333324)