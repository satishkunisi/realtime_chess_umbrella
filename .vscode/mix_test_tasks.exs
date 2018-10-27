defmodule TestTasks do
  @file_location ".vscode/.last-elixir-test-command"

  def command_list({options, _, _}) do
    scope = Keyword.get(options, :scope)

    case scope do
      "suite" ->
        ["test", "--color"]
      "file" ->
        file_name = get_file_name(options)
        command_if_test_file(file_name, ["test", "#{file_name}","--color"])
      "nearest" ->
        line_number = Keyword.get(options, :line_number)
        file_name = get_file_name(options)
        command_if_test_file(file_name, ["test", "#{file_name}:#{line_number}", "--color"])
      "last" ->
        fetch_last_command()
    end
  end

  def command_if_test_file(file_name, command) do
    is_test_file = String.match?(file_name, ~r/test\.exs$/)

    if is_test_file do
      command
    else
      fetch_last_command()
    end
  end

  def write_to_file(command_list) do
    :ok = File.touch @file_location
    {:ok, file} = File.open @file_location, [:write]
    IO.binwrite(file, Enum.join(command_list, "|"))
    File.close(file)
    command_list
  end

  def fetch_last_command() do
    {:ok, serialized_command} = File.read @file_location
    String.split(serialized_command, "|")
  end

  def get_file_name(options) do
    is_umbrella = Keyword.get(options, :is_umbrella, false)

    if is_umbrella do
      Keyword.get(options, :file_name)
      |> String.replace(~r/apps(.)+(?=test\/)/, "")
    else
      Keyword.get(options, :file_name)
    end
  end
end


System.argv()
|> OptionParser.parse(
  switches: [scope: :string, file_name: :string, line_number: :string, is_umbrella: :boolean]
)
|> TestTasks.command_list()
|> TestTasks.write_to_file()
|> (fn opts -> System.cmd("mix", opts, into: IO.stream(:stdio, :line)) end).()
