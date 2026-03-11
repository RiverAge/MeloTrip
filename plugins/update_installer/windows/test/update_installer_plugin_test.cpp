#include <gtest/gtest.h>

#include "../update_installer_plugin.cpp"

namespace {

WindowsUpdaterStrings BuildStrings() {
  return WindowsUpdaterStrings{
      L"Updater",
      L"Preparing",
      L"Version 1.0.1 (2)",
      L"Waiting",
      L"Extracting",
      L"Installing",
      L"Restarting",
      L"Failed",
      L"Invalid arguments",
      L"Init failed",
      L"Wait failed",
      L"Temp path failed",
      L"Temp dir failed",
      L"Extract failed",
      L"Copy failed",
  };
}

}  // namespace

TEST(UpdateInstallerPluginNativeTest, Utf8ToWideConvertsUtf8Text) {
  EXPECT_EQ(Utf8ToWide("MeloTrip 更新"), L"MeloTrip 更新");
}

TEST(UpdateInstallerPluginNativeTest, BuildCommandLineIncludesRequiredArguments) {
  const std::wstring command_line = BuildCommandLine(
      L"C:\\Temp\\MeloTripUpdater.exe",
      L"C:\\Temp\\melotrip-windows-x64.zip",
      L"C:\\Apps\\MeloTrip",
      L"C:\\Apps\\MeloTrip\\MeloTrip.exe",
      4242,
      BuildStrings());

  EXPECT_NE(command_line.find(L"--archive \"C:\\Temp\\melotrip-windows-x64.zip\""),
            std::wstring::npos);
  EXPECT_NE(command_line.find(L"--install-dir \"C:\\Apps\\MeloTrip\""),
            std::wstring::npos);
  EXPECT_NE(command_line.find(L"--executable \"C:\\Apps\\MeloTrip\\MeloTrip.exe\""),
            std::wstring::npos);
  EXPECT_NE(command_line.find(L"--pid 4242"), std::wstring::npos);
  EXPECT_NE(command_line.find(L"--window-title \"Updater\""),
            std::wstring::npos);
  EXPECT_EQ(command_line.find(L"--mock-install"), std::wstring::npos);
}