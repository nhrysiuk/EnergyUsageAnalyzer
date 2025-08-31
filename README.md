# EnergyUsageAnalyzer
EnergyUsageAnalyzer is a static code analyzer for Swift. Developed as a diploma project, it's designed to help developers identify and fix common code patterns that lead to high energy consumption. It integrates into your development workflow either through the command line or directly within Xcode.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
  - [1. Integration with Xcode (Recommended)](#1-integration-with-xcode-recommended)
  - [2. Using the Command Line](#2-using-the-command-line)

## Features
EnergyUsageAnalyzer detects common energy-inefficient antipatterns across five categories, providing detailed warnings and suggestions for refactoring.

**Location:** Detects improper usage of location services.

**Bluetooth:** Identifies inefficient Bluetooth scanning practices (e.g., scanning without stopping).

**Timers:** Finds issues with timer usage, such as missing invalidation or undefined tolerance.

**Excessive CPU usage:** Spots CPU-intensive code, including non-static functions that don't access class properties or methods without a parameterized object.

**Excessive GPU usage:** Pinpoints excessive use of GPU-heavy modifications like shadows, transparency, and blurs.

## Technologies Used
**Swift:** The core programming language for the analyzer.

**Swift Package Manager:** Used for creating, distributing, and integrating the tool as a Swift package.

**SwiftSyntax:** A powerful library for parsing, inspecting, and transforming Swift source code, which serves as the foundation for the analyzer's static analysis.

**Swift-Argument-Parser:** A library for creating an intuitive and easy-to-use command-line interface.

**YAML:** Used for configuration files, allowing you to easily disable specific analysis rules.

## Getting Started
### 1. Integration with Xcode (Recommended)

Integrating EnergyUsageAnalyzer as a Build Tool Plugin allows it to automatically analyze your code on every build.

**Step 1: Add the Package Dependency**
1. In Xcode, go to **File > Add Packages...**
2. Enter `https://github.com/nhrysiuk/EnergyUsageAnalyzer.git` in the search bar.
3. Select the desired version and click **Add Package**.

**Step 2: Add the Build Tool Plugin**
1. In your project settings, navigate to the **target** you want to analyze.
2. Select the **Build Phases** tab.
3. Expand the **Run Build Tool Plug-ins** section.
4. Click the **+** button and choose `EnergyUsageAnalyzerPlugin` from the list.

**Step 3:  Configure Rules (Optional)**

To disable specific rules, create a file named  `energy-analyzer.yml`  in the root directory of your project with the following format:
```
disabled_rules:
  - inline_method_rule
  - publish_timer_rule
```
The name of each rule is stored in the identifier property of its coordinator.

Now, every time you build your project, the analyzer will run and display warnings directly in Xcode

### 2. Using the Command Line

This method is useful for quick checks of individual files or for debugging the tool itself.

**Step 1: Clone the Repository**

Clone the project from its GitHub repository:

```
git clone https://github.com/nhrysiuk/EnergyUsageAnalyzer.git
```

**Step 2: Run the Analyzer**

Navigate to the project directory in your terminal and run the analyzer using the following command:

```
swift run EnergyUsageAnalyzer -i <path_to_swift_file>
```

To use a custom configuration file, add the -c flag:

```
swift run EnergyUsageAnalyzer -i <path_to_swift_file> -c <path_to_yml_file>
```

The analysis results, including the file name, line number, and a message with refactoring advice, will be printed to the terminal.
