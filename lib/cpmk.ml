type proj =
  { project_name : string
  ; language : string
  }

let is_valid = function
  | "c" -> true
  | "cpp" -> true
  | _ -> false
;;

let create_dirs project_path =
  let open Sys in
  try
    mkdir project_path 0o755;
    mkdir (project_path ^ "/src") 0o755
  with
  | Sys_error _ -> print_endline "Directory already exists"
;;

let create_files project_path proj =
  try
    let main_file = open_out (project_path ^ "/src/main." ^ proj.language) in
    let main_content =
      if proj.language = "c"
      then
        "#include <stdio.h>\n\n\
         int main() {\n\
         \tprintf(\"Hello World!\\n\");\n\n\
         \treturn 0;\n\
         }"
      else
        "#include <iostream>\n\n\
         int main() {\n\
         \tstd::cout << \"Hello World!\" << \"\\n\";\n\n\
         \treturn 0;\n\
         }"
    in
    output_string main_file main_content;
    close_out main_file;
    let cmake_file = open_out (project_path ^ "/CMakeLists.txt") in
    let cmake_extra =
      if proj.language = "c"
      then
        "set(CMAKE_C_STANDARD 17)\n\
         set(CMAKE_C_STANDARD_REQUIRED True)\n\
         set(CMAKE_C_FLAGS \"${CMAKE_C_FLAGS} -Wall -Wextra -Wpedantic\")\n\n"
      else ""
    in
    let cmake_content =
      "cmake_minimum_required(VERSION 3.10)\n\nproject("
      ^ proj.project_name
      ^ ")\n\n"
      ^ cmake_extra
      ^ "set(CMAKE_CXX_STANDARD 20)\n\
         set(CMAKE_CXX_STANDARD_REQUIRED True)\n\
         set(CMAKE_CXX_FLAGS \"${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic\")\n\n\
         set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})\n\n\
         add_subdirectory(src)"
    in
    output_string cmake_file cmake_content;
    close_out cmake_file;
    let cmake_srcs = open_out (project_path ^ "/src/CMakeLists.txt") in
    let cmake_srcs_content =
      "cmake_minimum_required(VERSION 3.10)\n\nadd_executable(\n\t"
      ^ proj.project_name
      ^ "\n\tmain."
      ^ proj.language
      ^ "\n)"
    in
    output_string cmake_srcs cmake_srcs_content;
    close_out cmake_srcs
  with
  | Sys_error _ -> print_endline "File already exists"
;;

let setup_project proj =
  if is_valid proj.language
  then (
    let cwd = Sys.getcwd () in
    let project_path = cwd ^ "/" ^ proj.project_name in
    create_dirs project_path;
    create_files project_path proj;
    Printf.printf "Project %s created successfully\n" proj.project_name)
  else print_endline "Invalid language, please use c or cpp"
;;

let init () =
  let project_name = ref "" in
  let language = ref "" in
  let speclist =
    [ "-p", Arg.Set_string project_name, "The name of the project"
    ; "-l", Arg.Set_string language, "The language of the project"
    ]
  in
  Arg.parse speclist (fun _ -> ()) "Usage: cpmk -p <project_name> -l <language>";
  let proj = { project_name = !project_name; language = !language } in
  setup_project proj
;;
