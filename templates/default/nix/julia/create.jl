using ArgParse
using Pluto: Cell, Notebook, save_notebook, run

template = """
# Do not modify or remove this cell!
begin
    import Pkg

    # activate the shared project environment
    Pkg.activate(Base.current_project())
    Pkg.instantiate()
end"""

function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "file"
        help = "name of the file to create"
        required = true
    end

    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    file = parsed_args["file"]

    save_notebook(Notebook([Cell(template)]), file)

    run(notebook = file)
end

main()
