//
//  CodeLanguage.swift
//  
//
//  Created by Nanashi Li on 2022/07/16.
//

import Foundation.NSURL

/// The language of a code codument.
public struct CodeLanguage {
    /// The language name used in highlightr.
    let id: HighlightrLanguage
    /// The human readable name of the langauage.
    let displayName: String
    /// The file name extensions of the language (in lowercase).
    let extensions: Set<String>
    /// Detects the language of the files form a given `URL`.
    /// - Parameter url: The `URL` of the file.
    /// - Returns: The `CodeLanguage` of the file.
    static func detectLanguageFromUrl(url: URL) -> CodeLanguage {
        let fileExtension = url.pathExtension.lowercased()
        let fileName = url.pathComponents.last?.lowercased()
        // This is to handle special file types without an extension (e.g., Makefile, Dockerfile)
        let fileNameOrExtension = fileExtension.isEmpty ? (fileName != nil ? fileName! : "") : fileExtension
        if let lang = knownLanguages.first(where: { lang in lang.extensions.contains(fileNameOrExtension) }) {
            return lang
        } else {
            return .default
        }
    }
    /// The default `CodeLanguage`, which is plain text.
    static let `default` = CodeLanguage(
        id: HighlightrLanguage.plaintext,
        displayName: "Plain Text",
        extensions: ["txt"]
    )
}
extension CodeLanguage {
    static let knownLanguages = [
        CodeLanguage(id: HighlightrLanguage.abnf, displayName: "Abnf", extensions: ["abnf"]),
        CodeLanguage(id: HighlightrLanguage.accesslog, displayName: "Access Log", extensions: ["accesslog"]),
        CodeLanguage(id: HighlightrLanguage.actionscript, displayName: "Action Script", extensions: ["actionscript"]),
        CodeLanguage(id: HighlightrLanguage.ada, displayName: "Ada", extensions: ["ada"]),
        CodeLanguage(id: HighlightrLanguage.angelscript, displayName: "Angel Script", extensions: ["angelscript"]),
        CodeLanguage(id: HighlightrLanguage.apache, displayName: "Apache Configuration", extensions: ["apache"]),
        CodeLanguage(
            id: HighlightrLanguage.applescript,
            displayName: "Apple Script",
            extensions: ["applescript", "scpt", "scptd"]
        ),
        CodeLanguage(id: HighlightrLanguage.arcade, displayName: "Arcade", extensions: ["arcade"]),
        CodeLanguage(id: HighlightrLanguage.c, displayName: "C", extensions: ["c", "h"]),
        CodeLanguage(id: HighlightrLanguage.cpp, displayName: "C++", extensions: ["cpp", "cc", "hpp", "hxx"]),
        CodeLanguage(id: HighlightrLanguage.arduino, displayName: "Arduino", extensions: ["arduino"]),
        CodeLanguage(id: HighlightrLanguage.armasm, displayName: "ARM Assembly", extensions: ["armasm"]),
        CodeLanguage(id: HighlightrLanguage.xml, displayName: "XML", extensions: ["xml"]),
        CodeLanguage(id: HighlightrLanguage.asciidoc, displayName: "ASCII Doc", extensions: ["asciidoc"]),
        CodeLanguage(id: HighlightrLanguage.aspectj, displayName: "Aspectj", extensions: ["aspectj"]),
        CodeLanguage(id: HighlightrLanguage.autohotkey, displayName: "Auto Hotkey", extensions: ["autohotkey"]),
        CodeLanguage(id: HighlightrLanguage.autoit, displayName: "Autoit", extensions: ["autoit"]),
        CodeLanguage(id: HighlightrLanguage.avrasm, displayName: "Avrasm", extensions: ["avrasm"]),
        CodeLanguage(id: HighlightrLanguage.awk, displayName: "Awk", extensions: ["awk"]),
        CodeLanguage(id: HighlightrLanguage.axapta, displayName: "Axapta", extensions: ["axapta"]),
        CodeLanguage(id: HighlightrLanguage.bash, displayName: "Bash", extensions: ["bash"]),
        CodeLanguage(id: HighlightrLanguage.basic, displayName: "Basic", extensions: ["basic"]),
        CodeLanguage(id: HighlightrLanguage.bnf, displayName: "Bnf", extensions: ["bnf"]),
        CodeLanguage(id: HighlightrLanguage.brainfuck, displayName: "Brainfuck", extensions: ["brainfuck"]),
        CodeLanguage(id: HighlightrLanguage.cal, displayName: "Cal", extensions: ["cal"]),
        CodeLanguage(id: HighlightrLanguage.capnproto, displayName: "Capnproto", extensions: ["capnproto"]),
        CodeLanguage(id: HighlightrLanguage.ceylon, displayName: "Ceylon", extensions: ["ceylon"]),
        CodeLanguage(id: HighlightrLanguage.clean, displayName: "Clean", extensions: ["clean"]),
        CodeLanguage(id: HighlightrLanguage.clojure, displayName: "Clojure", extensions: ["clojure"]),
        CodeLanguage(id: HighlightrLanguage.cmake, displayName: "CMake", extensions: ["cmake"]),
        CodeLanguage(id: HighlightrLanguage.coffeescript, displayName: "Coffeescript", extensions: ["coffeescript"]),
        CodeLanguage(id: HighlightrLanguage.coq, displayName: "Coq", extensions: ["coq"]),
        CodeLanguage(id: HighlightrLanguage.cos, displayName: "Cos", extensions: ["cos"]),
        CodeLanguage(id: HighlightrLanguage.crmsh, displayName: "Crmsh", extensions: ["crmsh"]),
        CodeLanguage(id: HighlightrLanguage.crystal, displayName: "Crystal", extensions: ["crystal"]),
        CodeLanguage(id: HighlightrLanguage.cs, displayName: "C#", extensions: ["cs"]),
        CodeLanguage(id: HighlightrLanguage.csp, displayName: "Csp", extensions: ["csp"]),
        CodeLanguage(id: HighlightrLanguage.css, displayName: "CSS", extensions: ["css"]),
        CodeLanguage(id: HighlightrLanguage.d, displayName: "D", extensions: ["d"]),
        CodeLanguage(id: HighlightrLanguage.markdown, displayName: "Markdown", extensions: ["md", "markdown"]),
        CodeLanguage(id: HighlightrLanguage.dart, displayName: "Dart", extensions: ["dart"]),
        CodeLanguage(id: HighlightrLanguage.delphi, displayName: "Delphi", extensions: ["delphi"]),
        CodeLanguage(id: HighlightrLanguage.diff, displayName: "Diff", extensions: ["diff"]),
        CodeLanguage(id: HighlightrLanguage.django, displayName: "Django", extensions: ["django"]),
        CodeLanguage(id: HighlightrLanguage.dns, displayName: "Dns", extensions: ["dns"]),
        CodeLanguage(id: HighlightrLanguage.dockerfile, displayName: "Dockerfile", extensions: ["dockerfile"]),
        CodeLanguage(id: HighlightrLanguage.dos, displayName: "Dos", extensions: ["bat", "cmd"]),
        CodeLanguage(id: HighlightrLanguage.dsconfig, displayName: "Dsconfig", extensions: ["dsconfig"]),
        CodeLanguage(id: HighlightrLanguage.dts, displayName: "Dts", extensions: ["dts"]),
        CodeLanguage(id: HighlightrLanguage.dust, displayName: "Dust", extensions: ["dust"]),
        CodeLanguage(id: HighlightrLanguage.ebnf, displayName: "Ebnf", extensions: ["ebnf"]),
        CodeLanguage(id: HighlightrLanguage.elixir, displayName: "Elixir", extensions: ["ex"]),
        CodeLanguage(id: HighlightrLanguage.elm, displayName: "Elm", extensions: ["elm"]),
        CodeLanguage(id: HighlightrLanguage.ruby, displayName: "Ruby", extensions: ["rb"]),
        CodeLanguage(id: HighlightrLanguage.erb, displayName: "Erb", extensions: ["erb"]),
        CodeLanguage(id: HighlightrLanguage.erlang, displayName: "Erlang", extensions: ["erl"]),
        CodeLanguage(id: HighlightrLanguage.excel, displayName: "Excel", extensions: ["excel"]),
        CodeLanguage(id: HighlightrLanguage.fix, displayName: "Fix", extensions: ["fix"]),
        CodeLanguage(id: HighlightrLanguage.flix, displayName: "Flix", extensions: ["flix"]),
        CodeLanguage(id: HighlightrLanguage.fortran, displayName: "Fortran", extensions: ["fortran"]),
        CodeLanguage(id: HighlightrLanguage.fsharp, displayName: "F#", extensions: ["fsharp"]),
        CodeLanguage(id: HighlightrLanguage.gams, displayName: "Gams", extensions: ["gams"]),
        CodeLanguage(id: HighlightrLanguage.gauss, displayName: "Gauss", extensions: ["gauss"]),
        CodeLanguage(id: HighlightrLanguage.gcode, displayName: "Gcode", extensions: ["gcode"]),
        CodeLanguage(id: HighlightrLanguage.gherkin, displayName: "Gherkin", extensions: ["gherkin"]),
        CodeLanguage(id: HighlightrLanguage.glsl, displayName: "GLSL", extensions: ["glsl"]),
        CodeLanguage(id: HighlightrLanguage.gml, displayName: "Gml", extensions: ["gml"]),
        CodeLanguage(id: HighlightrLanguage.go, displayName: "Go", extensions: ["go"]),
        CodeLanguage(id: HighlightrLanguage.golo, displayName: "Golo", extensions: ["golo"]),
        CodeLanguage(id: HighlightrLanguage.gradle, displayName: "Gradle", extensions: ["gradle"]),
        CodeLanguage(id: HighlightrLanguage.groovy, displayName: "Groovy", extensions: ["groovy"]),
        CodeLanguage(id: HighlightrLanguage.haml, displayName: "Haml", extensions: ["haml"]),
        CodeLanguage(id: HighlightrLanguage.handlebars, displayName: "Handlebars", extensions: ["handlebars"]),
        CodeLanguage(id: HighlightrLanguage.haskell, displayName: "Haskell", extensions: ["haskell"]),
        CodeLanguage(id: HighlightrLanguage.haxe, displayName: "Haxe", extensions: ["haxe"]),
        CodeLanguage(id: HighlightrLanguage.hsp, displayName: "Hsp", extensions: ["hsp"]),
        CodeLanguage(id: HighlightrLanguage.htmlbars, displayName: "Htmlbars", extensions: ["htmlbars"]),
        CodeLanguage(id: HighlightrLanguage.html, displayName: "HTML", extensions: ["html"]),
        CodeLanguage(id: HighlightrLanguage.http, displayName: "HTTP", extensions: ["http"]),
        CodeLanguage(id: HighlightrLanguage.hy, displayName: "Hy", extensions: ["hy"]),
        CodeLanguage(id: HighlightrLanguage.inform7, displayName: "Inform7", extensions: ["inform7"]),
        CodeLanguage(id: HighlightrLanguage.ini, displayName: "INI", extensions: ["ini"]),
        CodeLanguage(id: HighlightrLanguage.irpf90, displayName: "Irpf90", extensions: ["irpf90"]),
        CodeLanguage(id: HighlightrLanguage.isbl, displayName: "Isbl", extensions: ["isbl"]),
        CodeLanguage(id: HighlightrLanguage.java, displayName: "Java", extensions: ["java"]),
        CodeLanguage(id: HighlightrLanguage.javascript, displayName: "JavaScript", extensions: ["js"]),
        CodeLanguage(id: HighlightrLanguage.json, displayName: "Json", extensions: ["json"]),
        CodeLanguage(id: HighlightrLanguage.julia, displayName: "Julia", extensions: ["julia"]),
        CodeLanguage(id: HighlightrLanguage.kotlin, displayName: "Kotlin", extensions: ["kt"]),
        CodeLanguage(id: HighlightrLanguage.lasso, displayName: "Lasso", extensions: ["lasso"]),
        CodeLanguage(id: HighlightrLanguage.ldif, displayName: "Ldif", extensions: ["ldif"]),
        CodeLanguage(id: HighlightrLanguage.leaf, displayName: "Leaf", extensions: ["leaf"]),
        CodeLanguage(id: HighlightrLanguage.less, displayName: "Less", extensions: ["less"]),
        CodeLanguage(id: HighlightrLanguage.lisp, displayName: "Lisp", extensions: ["lisp"]),
        CodeLanguage(
            id: HighlightrLanguage.livecodeserver,
            displayName: "LiveCode Server",
            extensions: ["livecodeserver"]
        ),
        CodeLanguage(id: HighlightrLanguage.livescript, displayName: "Livescript", extensions: ["livescript"]),
        CodeLanguage(id: HighlightrLanguage.llvm, displayName: "LLVM", extensions: ["llvm"]),
        CodeLanguage(id: HighlightrLanguage.lsl, displayName: "Lsl", extensions: ["lsl"]),
        CodeLanguage(id: HighlightrLanguage.lua, displayName: "Lua", extensions: ["lua"]),
        CodeLanguage(id: HighlightrLanguage.makefile, displayName: "Makefile", extensions: ["makefile"]),
        CodeLanguage(id: HighlightrLanguage.mathematica, displayName: "Mathematica", extensions: ["mathematica"]),
        CodeLanguage(id: HighlightrLanguage.matlab, displayName: "Matlab", extensions: ["matlab"]),
        CodeLanguage(id: HighlightrLanguage.maxima, displayName: "Maxima", extensions: ["maxima"]),
        CodeLanguage(id: HighlightrLanguage.mel, displayName: "Mel", extensions: ["mel"]),
        CodeLanguage(id: HighlightrLanguage.mercury, displayName: "Mercury", extensions: ["mercury"]),
        CodeLanguage(id: HighlightrLanguage.mipsasm, displayName: "Mipsasm", extensions: ["mipsasm"]),
        CodeLanguage(id: HighlightrLanguage.mizar, displayName: "Mizar", extensions: ["mizar"]),
        CodeLanguage(id: HighlightrLanguage.perl, displayName: "Perl", extensions: ["pl"]),
        CodeLanguage(id: HighlightrLanguage.mojolicious, displayName: "Mojolicious", extensions: ["mojolicious"]),
        CodeLanguage(id: HighlightrLanguage.monkey, displayName: "Monkey", extensions: ["monkey"]),
        CodeLanguage(id: HighlightrLanguage.moonscript, displayName: "Moonscript", extensions: ["moonscript"]),
        CodeLanguage(id: HighlightrLanguage.n1ql, displayName: "N1ql", extensions: ["n1ql"]),
        CodeLanguage(id: HighlightrLanguage.nginx, displayName: "Nginx", extensions: ["nginx"]),
        CodeLanguage(id: HighlightrLanguage.nimrod, displayName: "Nimrod", extensions: ["nimrod"]),
        CodeLanguage(id: HighlightrLanguage.nix, displayName: "Nix", extensions: ["nix"]),
        CodeLanguage(id: HighlightrLanguage.nsis, displayName: "NSIS", extensions: ["nsis"]),
        CodeLanguage(id: HighlightrLanguage.objectivec, displayName: "Objective-C", extensions: ["objectivec"]),
        CodeLanguage(id: HighlightrLanguage.ocaml, displayName: "OCaml", extensions: ["ocaml"]),
        CodeLanguage(id: HighlightrLanguage.openscad, displayName: "Openscad", extensions: ["openscad"]),
        CodeLanguage(id: HighlightrLanguage.oxygene, displayName: "Oxygene", extensions: ["oxygene"]),
        CodeLanguage(id: HighlightrLanguage.parser3, displayName: "Parser3", extensions: ["parser3"]),
        CodeLanguage(id: HighlightrLanguage.pf, displayName: "Pf", extensions: ["pf"]),
        CodeLanguage(id: HighlightrLanguage.pgsql, displayName: "Pgsql", extensions: ["pgsql"]),
        CodeLanguage(id: HighlightrLanguage.php, displayName: "PHP", extensions: ["php"]),
        .default, // Plain text
        CodeLanguage(id: HighlightrLanguage.pony, displayName: "Pony", extensions: ["pony"]),
        CodeLanguage(id: HighlightrLanguage.powershell, displayName: "PowerShell", extensions: ["powershell"]),
        CodeLanguage(id: HighlightrLanguage.processing, displayName: "Processing", extensions: ["processing"]),
        CodeLanguage(id: HighlightrLanguage.profile, displayName: "Profile", extensions: ["profile"]),
        CodeLanguage(id: HighlightrLanguage.prolog, displayName: "Prolog", extensions: ["prolog"]),
        CodeLanguage(id: HighlightrLanguage.properties, displayName: "Properties", extensions: ["properties"]),
        CodeLanguage(id: HighlightrLanguage.protobuf, displayName: "Protobuf", extensions: ["protobuf"]),
        CodeLanguage(id: HighlightrLanguage.puppet, displayName: "Puppet", extensions: ["puppet"]),
        CodeLanguage(id: HighlightrLanguage.purebasic, displayName: "Purebasic", extensions: ["purebasic"]),
        CodeLanguage(id: HighlightrLanguage.python, displayName: "Python", extensions: ["py"]),
        CodeLanguage(id: HighlightrLanguage.q, displayName: "Q", extensions: ["q"]),
        CodeLanguage(id: HighlightrLanguage.qml, displayName: "Qml", extensions: ["qml"]),
        CodeLanguage(id: HighlightrLanguage.r, displayName: "R", extensions: ["r"]),
        CodeLanguage(id: HighlightrLanguage.reasonml, displayName: "Reasonml", extensions: ["reasonml"]),
        CodeLanguage(id: HighlightrLanguage.rib, displayName: "Rib", extensions: ["rib"]),
        CodeLanguage(id: HighlightrLanguage.roboconf, displayName: "Roboconf", extensions: ["roboconf"]),
        CodeLanguage(id: HighlightrLanguage.routeros, displayName: "Routeros", extensions: ["routeros"]),
        CodeLanguage(id: HighlightrLanguage.rsl, displayName: "Rsl", extensions: ["rsl"]),
        CodeLanguage(id: HighlightrLanguage.ruleslanguage, displayName: "Ruleslanguage", extensions: ["ruleslanguage"]),
        CodeLanguage(id: HighlightrLanguage.rust, displayName: "Rust", extensions: ["rs"]),
        CodeLanguage(id: HighlightrLanguage.sas, displayName: "Sas", extensions: ["sas"]),
        CodeLanguage(id: HighlightrLanguage.scala, displayName: "Scala", extensions: ["scala"]),
        CodeLanguage(id: HighlightrLanguage.scheme, displayName: "Scheme", extensions: ["scheme"]),
        CodeLanguage(id: HighlightrLanguage.scilab, displayName: "Scilab", extensions: ["scilab"]),
        CodeLanguage(id: HighlightrLanguage.scss, displayName: "SCSS", extensions: ["scss"]),
        CodeLanguage(id: HighlightrLanguage.shell, displayName: "Shell", extensions: ["shell"]),
        CodeLanguage(id: HighlightrLanguage.smali, displayName: "Smali", extensions: ["smali"]),
        CodeLanguage(id: HighlightrLanguage.smalltalk, displayName: "Smalltalk", extensions: ["smalltalk"]),
        CodeLanguage(id: HighlightrLanguage.sml, displayName: "Sml", extensions: ["sml"]),
        CodeLanguage(id: HighlightrLanguage.sqf, displayName: "Sqf", extensions: ["sqf"]),
        CodeLanguage(id: HighlightrLanguage.sql, displayName: "SQL", extensions: ["sql"]),
        CodeLanguage(id: HighlightrLanguage.stan, displayName: "Stan", extensions: ["stan"]),
        CodeLanguage(id: HighlightrLanguage.stata, displayName: "Stata", extensions: ["stata"]),
        CodeLanguage(id: HighlightrLanguage.step21, displayName: "Step21", extensions: ["step21"]),
        CodeLanguage(id: HighlightrLanguage.stylus, displayName: "Stylus", extensions: ["stylus"]),
        CodeLanguage(id: HighlightrLanguage.subunit, displayName: "Subunit", extensions: ["subunit"]),
        CodeLanguage(id: HighlightrLanguage.swift, displayName: "Swift", extensions: ["swift"]),
        CodeLanguage(id: HighlightrLanguage.taggerscript, displayName: "Taggerscript", extensions: ["taggerscript"]),
        CodeLanguage(id: HighlightrLanguage.yaml, displayName: "YAML", extensions: ["yaml", "yml"]),
        CodeLanguage(id: HighlightrLanguage.tap, displayName: "Tap", extensions: ["tap"]),
        CodeLanguage(id: HighlightrLanguage.tcl, displayName: "Tcl", extensions: ["tcl"]),
        CodeLanguage(id: HighlightrLanguage.tex, displayName: "TeX", extensions: ["tex"]),
        CodeLanguage(id: HighlightrLanguage.thrift, displayName: "Thrift", extensions: ["thrift"]),
        CodeLanguage(id: HighlightrLanguage.tp, displayName: "Tp", extensions: ["tp"]),
        CodeLanguage(id: HighlightrLanguage.twig, displayName: "Twig", extensions: ["twig"]),
        CodeLanguage(id: HighlightrLanguage.typescript, displayName: "Typescript", extensions: ["ts"]),
        CodeLanguage(id: HighlightrLanguage.vala, displayName: "Vala", extensions: ["vala"]),
        CodeLanguage(id: HighlightrLanguage.vbnet, displayName: "Vbnet", extensions: ["vbnet"]),
        CodeLanguage(id: HighlightrLanguage.vbscript, displayName: "Vbscript", extensions: ["vbscript"]),
        CodeLanguage(id: HighlightrLanguage.verilog, displayName: "Verilog", extensions: ["verilog"]),
        CodeLanguage(id: HighlightrLanguage.vhdl, displayName: "Vhdl", extensions: ["vhdl"]),
        CodeLanguage(id: HighlightrLanguage.vim, displayName: "Vim", extensions: ["vim"]),
        CodeLanguage(id: HighlightrLanguage.x86asm, displayName: "x86 Assembly", extensions: ["x86asm"]),
        CodeLanguage(id: HighlightrLanguage.xl, displayName: "Xl", extensions: ["xl"]),
        CodeLanguage(id: HighlightrLanguage.xquery, displayName: "Xquery", extensions: ["xquery"]),
        CodeLanguage(id: HighlightrLanguage.zephir, displayName: "Zephir", extensions: ["zephir"])
    ]
}
