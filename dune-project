(lang dune 3.10)

(name cpmkocaml)

(generate_opam_files true)

(source
 (github Sampie159/cpmkocaml.git))

(authors "Sampie")

(maintainers "Sampie")

(license MIT)

(package
 (name cpmkocaml)
 (synopsis "C/C++ project maker.")
 (description "Generate a C/C++ project with CMake.")
 (depends ocaml dune)
 (tags
  (c cpp cli)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
