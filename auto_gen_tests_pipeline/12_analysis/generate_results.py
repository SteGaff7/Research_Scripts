import csv

f_valid_bugs = open("/home/people/12309511/scripts/auto_gen_tests_pipeline/12_analysis/valid_bugs", "r")
f_report = open("/home/people/12309511/mutation_analysis/report.csv", "w")
f_report_mutators = open("/home/people/12309511/mutation_analysis/mutators.csv", "w")

major_dir = "/home/people/12309511/mutation_analysis/major"
pit_dir = "/home/people/12309511/mutation_analysis/pit"

with f_valid_bugs, f_report, f_report_mutators:
    report_writer = csv.writer(f_report)
    mutators_writer = csv.writer(f_report_mutators)

    report_writer.writerow(["Bug-ID", "MAJOR fault-revealed", "MAJOR # revealing mutants", "MAJOR # mutants",
                            "PIT fault-revealed", "PIT # revealing mutants", "PIT # mutants",
                            "Total # revealing mutants", "MAJOR Revealing Mutant Operators", "PIT Revealing Mutant Operators"])

    mutators_writer.writerow(["Bug-ID", "Mutation Tool"])

    for line in f_valid_bugs:
        PID = line.split("-")[0]
        VID = line.split("-")[1]

        print(PID, VID)

        major_stats = major_dir + "/" + PID + "/" + VID + "/stats_MAJOR"
        major_reveal = major_dir + "/" + PID + "/" + VID + "/revealing_mutants_MAJOR"
        pit_stats = pit_dir + "/" + PID + "/" + VID + "/stats_PIT"
        pit_reveal = pit_dir + "/" + PID + "/" + VID + "/revealing_mutants_PIT"

        major_stats_reader = csv.reader(open(major_stats, "r"))
        major_reveal_reader = csv.reader(open(major_reveal, "r"))
        pit_stats_reader = csv.reader(open(pit_stats, "r"))
        pit_reveal_reader = csv.reader(open(pit_reveal, "r"))

        major_revealed = False
        pit_revealed = False

        pit_revealing_operators = ""
        pit_revealing_list = []
        major_revealing_operators = ""
        major_revealing_list = []

        for row in major_stats_reader:
            if row[0] == "Total":
                major_total_mutants = int(row[1])
            if row[0] == "Revealing":
                major_revealing = int(row[1])
                if major_revealing > 0:
                    major_revealed = True

        for row in pit_stats_reader:
            if row[0] == "Total":
                pit_total_mutants = int(row[1])
            if row[0] == "Revealing":
                pit_revealing = int(row[1])
                if pit_revealing > 0:
                    pit_revealed = True

        for row in major_reveal_reader:
            mut_op = row[0].split(":")[1]
            major_revealing_operators += mut_op + "|"
            major_revealing_list += [mut_op]

        for row in pit_reveal_reader:
            s = row[0].split(".")
            mut_op = s[len(s) - 1].split("-")[0]
            pit_revealing_operators += mut_op + "|"
            pit_revealing_list += [mut_op]

        report_writer.writerow([PID + "-" + VID, major_revealed, major_revealing, major_total_mutants, pit_revealed,
                                pit_revealing, pit_total_mutants, major_revealing + pit_revealing,
                                major_revealing_operators, pit_revealing_operators])
        mutators_writer.writerow([PID + "-" + VID, "MAJOR"] + major_revealing_list)
        mutators_writer.writerow([PID + "-" + VID, "PIT"] + pit_revealing_list)
