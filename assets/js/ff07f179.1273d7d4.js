(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[515],{2692:(e,i,a)=>{"use strict";a.r(i),a.d(i,{assets:()=>d,contentTitle:()=>r,default:()=>p,frontMatter:()=>o,graph:()=>c,metadata:()=>l,toc:()=>h});var t=a(4848),s=a(8453),n=a(4782);const o={sidebar_position:3},r="Introduction",l={id:"build_system/intro",title:"Introduction",description:"SoCMake is built on top of CMake.",source:"@site/docs/build_system/intro.mdx",sourceDirName:"build_system",slug:"/build_system/intro",permalink:"/docs/build_system/intro",draft:!1,unlisted:!1,editUrl:"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/build_system/intro.mdx",tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3},sidebar:"tutorialSidebar",previous:{title:"Build System",permalink:"/docs/category/build-system"},next:{title:"Examples",permalink:"/docs/category/examples"}},d={},c=a(3443).A,h=[{value:"CMake",id:"cmake",level:2},{value:"CMake Useful links",id:"cmake-useful-links",level:3},{value:"Modern CMake",id:"modern-cmake",level:3},{value:"SoCMake",id:"socmake",level:2},{value:"SoCMake IP libraries",id:"socmake-ip-libraries",level:3},{value:"SoCMake linking IPs example",id:"socmake-linking-ips-example",level:3}];function m(e){const i={a:"a",code:"code",h1:"h1",h2:"h2",h3:"h3",li:"li",p:"p",ul:"ul",...(0,s.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(i.h1,{id:"introduction",children:"Introduction"}),"\n",(0,t.jsxs)(i.p,{children:["SoCMake is built on top of ",(0,t.jsx)(i.a,{href:"https://cmake.org/documentation/",children:"CMake"}),"."]}),"\n",(0,t.jsx)(i.h2,{id:"cmake",children:"CMake"}),"\n",(0,t.jsx)(i.p,{children:'CMake stands for "Cross-Platform Make" and is a build system generator.\nBeing a build system generator CMake is not building the software on its own, but instead it generates Make/Ninja files that are used for the real compilation.'}),"\n",(0,t.jsx)(i.p,{children:"CMake build descriptions are described in a declarative CMake domain-specific language (DSL).\nAlthough the CMake language has a lot of issues, it is still a very powerful tool, and the biggest advantage is its maturity and widespread usage.\nAlthough C++ does not have a standard build system, CMake is surely the closest to being one."}),"\n",(0,t.jsx)(i.h3,{id:"cmake-useful-links",children:"CMake Useful links"}),"\n",(0,t.jsx)(i.p,{children:"There is plenty of CMake tutorials online and the documentation is decent, some useful links:"}),"\n",(0,t.jsxs)(i.ul,{children:["\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://cmake.org/documentation/",children:"Documentation"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://cmake.org/cmake/help/latest/guide/tutorial/index.html",children:"Official Tutorial"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/",children:"It's Time To Do CMake Right"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://www.youtube.com/watch?v=HPMvU64RUTY",children:"Jason Turner Intro Video"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://cliutils.gitlab.io/modern-cmake/",children:"Modern CMake"})}),"\n"]}),"\n",(0,t.jsx)(i.h3,{id:"modern-cmake",children:"Modern CMake"}),"\n",(0,t.jsx)(i.p,{children:"CMake has a bad reputation for it's DSL, which could do things much better.\nIn CMake DSL every variable is a string, which can be pretty awkward and error prone at times.\nSetting aside those problems, it is still a very good build tool, and it provides a lot of flexibility compared to other available build systems."}),"\n",(0,t.jsx)(i.p,{children:"There is a big distinction between earlier versions of CMake and what is recommended today.\nThere are plenty of bad examples online of CMake code, typically coming from older CMake versions that one should avoid."}),"\n",(0,t.jsx)(i.p,{children:"Modern CMake is all about creating targets instead of global variables, and this fits really well into hardware IP hierarchy as it will be explained later.\nThis page will not give a tutorial to CMake as it is already done really well in previously linked tutorials."}),"\n",(0,t.jsx)(i.h2,{id:"socmake",children:"SoCMake"}),"\n",(0,t.jsx)(i.p,{children:"SoCMake is a set of functions for creating hardware IP blocks, composing them, packaging them and executing EDA tools on them."}),"\n",(0,t.jsxs)(i.p,{children:["The advantage to build systems like FuseSoC or hdlmake is that there is a native C++ compilation support through CMake itself.\nThis makes it that using SoCMake for verifying Systems On Chip (SoC), where it is needed to compile some application code for the processor, it is not needed to have another build system for C++ or C compilation.",(0,t.jsx)("br",{}),"\nVery often today testbenches are written in C++ and simulated with Verilator, SoCMake also provides an easy way to create these testbenches and use common C++ build system for this task."]}),"\n",(0,t.jsx)(i.h3,{id:"socmake-ip-libraries",children:"SoCMake IP libraries"}),"\n",(0,t.jsxs)(i.p,{children:["The basic building block of SoCMake build system is an ",(0,t.jsx)(i.code,{children:"IP library"}),", which is just a wrapper around CMake ",(0,t.jsx)(i.a,{href:"https://cmake.org/cmake/help/latest/command/add_library.html#interface-libraries",children:"Interface Library"}),".\nThese library do not compile to any objects or executables, they are only used to carry files and information.\nIn case of Hardware designs, they can contain list of Verilog files."]}),"\n",(0,t.jsxs)(i.p,{children:['Although it is possible to support additional languages like Verilog and "compilers" like Verilator in CMake, in SoCMake for simplicity reasons ',(0,t.jsx)(i.a,{href:"https://cmake.org/cmake/help/book/mastering-cmake/chapter/Custom%20Commands.html",children:"approach"})," of ",(0,t.jsx)(i.a,{href:"https://cmake.org/cmake/help/latest/command/add_custom_target.html",children:"add_custom_target()"})," and ",(0,t.jsx)(i.a,{href:"https://cmake.org/cmake/help/latest/command/add_custom_command.html",children:"add_custom_command()"})," pairs is used to provide support for different tools like Verilator, Yosys, Vivado \u2026"]}),"\n",(0,t.jsxs)(i.p,{children:["Modern CMake encourages the use of Targets instead of setting global variables. This way in SoCMake the way of passing different tool information and files along with your IP libraries is by setting different ",(0,t.jsx)(i.a,{href:"https://cmake.org/cmake/help/latest/command/set_property.html",children:"properties"})," to IP library targets."]}),"\n",(0,t.jsx)(i.p,{children:"The SoCMake provides an API to abstract the usage of these CMake concepts."}),"\n",(0,t.jsx)(i.h3,{id:"socmake-linking-ips-example",children:"SoCMake linking IPs example"}),"\n","\n","\n",(0,t.jsx)(i.p,{children:"SoCMake promotes hierarchical design, by organizing IP blocks into IP libraries, we can easily reuse IP blocks into different designs.\nA simple example of such a IP hierarchy is shown below."}),"\n",(0,t.jsx)(n.i,{dot:c}),"\n",(0,t.jsxs)(i.p,{children:["The full example is provided in the examples section ",(0,t.jsx)(i.a,{href:"../examples/linking_ips",children:"here"})]})]})}function p(e={}){const{wrapper:i}={...(0,s.R)(),...e.components};return i?(0,t.jsx)(i,{...e,children:(0,t.jsx)(m,{...e})}):m(e)}},3443:(e,i,a)=>{"use strict";a.d(i,{A:()=>t});const t='digraph "example" {\nnode [\n  fontsize = "12"\n];\n\n\n\n    "node3" [ label = "prim00", shape = pentagon ];\n    "node4" [ label = "prim01", shape = pentagon ];\n    "node5" [ label = "prim10", shape = pentagon ];\n    "node5" -> "node3" [ style = dashed ] // prim10 -> prim00\n    "node6" [ label = "prim11", shape = pentagon ];\n    "node6" -> "node3" [ style = dashed ] // prim11 -> prim00\n    "node6" -> "node4" [ style = dashed ] // prim11 -> prim01\n    "node7" [ label = "top", shape = pentagon ];\n    "node7" -> "node5" [ style = dashed ] // top -> prim10\n    "node7" -> "node6" [ style = dashed ] // top -> prim11\n}\n'},2938:()=>{},6120:()=>{},6984:()=>{},8453:(e,i,a)=>{"use strict";a.d(i,{R:()=>o,x:()=>r});var t=a(6540);const s={},n=t.createContext(s);function o(e){const i=t.useContext(n);return t.useMemo((function(){return"function"==typeof e?e(i):{...i,...e}}),[i,e])}function r(e){let i;return i=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:o(e.components),t.createElement(n.Provider,{value:i},e.children)}}}]);