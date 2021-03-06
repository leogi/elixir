Code.require_file "../../test_helper.exs", __DIR__

defmodule Mix.Tasks.CmdTest do
  use MixTest.Case

  test "runs the command for each app" do
    in_fixture "umbrella_dep/deps/umbrella", fn ->
      Mix.Project.in_project(:umbrella, ".", fn _ ->
        Mix.Task.run "cmd", ["echo", "hello"]
        nl = os_newline()
        assert_received {:mix_shell, :info, ["==> bar"]}
        assert_received {:mix_shell, :run, ["hello" <> ^nl]}
        assert_received {:mix_shell, :info, ["==> foo"]}
        assert_received {:mix_shell, :run, ["hello" <> ^nl]}
      end)
    end
  end

  test "only run the cmd for specified apps" do
    in_fixture "umbrella_dep/deps/umbrella", fn ->
      Mix.Project.in_project(:umbrella, ".", fn _ ->
        Mix.Task.run "cmd", ["--app", "bar", "echo", "hello"]
        nl = os_newline()
        assert_received {:mix_shell, :info, ["==> bar"]}
        assert_received {:mix_shell, :run, ["hello" <> ^nl]}
        refute_received {:mix_shell, :info, ["==> foo"]}
        refute_received {:mix_shell, :run, ["hello" <> ^nl]}
      end)
    end
  end
end
