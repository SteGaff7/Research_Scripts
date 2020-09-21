import csv

f_valid_bugs = open("/home/people/12309511/scripts/auto_gen_tests_pipeline/12_analysis/valid_bugs", "r")
f_report = open("/home/people/12309511/mutation_analysis/report.csv", "w")

major_dir = "/home/people/12309511/mutation_analysis/major"
pit_dir = "/home/people/12309511/mutation_analysis/pit"

with f_valid_bugs, f_report:
    report_writer = csv.writer(f_report)
    report_writer.writerow(["Bug-ID", "MAJOR: fault-revealed", "MAJOR # revealing mutants", "PIT: fault-revealed", "PIT # revealing mutants",
                            "Total # revealing mutants"])
    #, "Revealing Operators"

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

        revealing_operators = ""

        for row in major_stats_reader:
            if row[0] == "Revealing":
                major_revealing = int(row[1])
                if major_revealing > 0:
                    major_revealed = True

        for row in pit_stats_reader:
            if row[0] == "Revealing":
                pit_revealing = int(row[1])
                if pit_revealing > 0:
                    pit_revealed = True

        for row in major_reveal_reader:
            revealing_operators += row[0] + "|"

        for row in pit_reveal_reader:
            revealing_operators += row[0] + "|"

        report_writer.writerow([PID + "-" + VID, major_revealed, major_revealing, pit_revealed, pit_revealing,
                                major_revealing + pit_revealing])
        #, revealing_operators
