import java.util.Properties;
import java.util.Scanner;
import java.util.InputMismatchException;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;

// Note: This program was only intended to be used by developer user.
public class Main {
    public static void main(String[] args) {
        System.out.println("[NOTE]: This program was only meant to be used by developer user.");
        System.out.println("[NOTE]: This program assumes \"../db/schema.sql\",   \"../db/triggers.sql\", \"../db/procedures.sql\" and \"../db/users.sql\", was run.");
        System.out.println("[NOTE]: For convienence run \"../db/allsql.script, with cwd as \"../\"");

        Scanner sc = new Scanner(System.in);

        // A easy way to store and load key-value pairs..
        Properties connprops = new Properties();

        // Load from file .config
        try {
            connprops.load(new FileInputStream(".config"));
        }
        catch(IOException e) {
            System.out.println("Could not read .config file!!");
            return;
        }

        boolean running = true;

        try (
            // Prepare connection, specifying:
            // URL: Where to connect to
            // User: As who you are accessing the database
            // Password: for authentication.
            Connection conn = DriverManager.getConnection(
                connprops.getProperty("url"),
                connprops.getProperty("user"),
                connprops.getProperty("pwd")
            );
        ) {
            // Simple, Menu Driven Program.
            while(true) {
                System.out.println("0. Exit");
                System.out.println("1. List all unresolved crashes");
                System.out.println("2. Set a crash fingerprint to be resolved");
                System.out.println("3. Insert a new program");
                System.out.println("4. Install a program into a server");
                System.out.println("5. Delete a program from a server");
                System.out.println("6. Show number of crashes for a given fingerprint");

                try {
                    // Transaction control, don't commit immediately.
                    conn.setAutoCommit(false);

                    switch(sc.nextInt()) {
                        case 0: {
                            running  = false;
                            break;
                        }
                        case 1: {
                            try(
                                PreparedStatement ps = conn.prepareStatement("SELECT program_id, program_name, hash, stack_trace, resolution_state FROM Program NATURAL JOIN Crash NATURAL JOIN CrashFingerprint WHERE resolution_state<>\'RESOLVED\'");
                                ResultSet rs = ps.executeQuery()
                            ) {
                                while(rs.next()) {
                                    int program_id = rs.getInt("program_id");
                                    String program_name = rs.getString("program_name");
                                    String hash = rs.getString("hash");
                                    String stack_trace = rs.getString("stack_trace");
                                    String rest = rs.getString("resolution_state");

                                    System.out.println("Program ID: " + program_id);
                                    System.out.println("Program Name: " + program_name);
                                    System.out.println("Hash: " + hash);
                                    System.out.println("Resolution State: " + rest);
                                    System.out.println("Stack Trace:\n" + stack_trace);
                                    System.out.println();
                                }
                            }
                            break;
                        }
                        case 2: {
                            try(PreparedStatement ps = conn.prepareStatement("UPDATE CrashFingerprint SET resolution_state=\"RESOLVED\" WHERE hash = ?")) {
                                System.out.print("hash: ");
                                ps.setString(1, sc.next());
                                int rows = ps.executeUpdate();

                                System.out.println(rows + " rows affected.");
                            }
                            break;
                        }
                        case 3: {
                            try(PreparedStatement ps = conn.prepareStatement("INSERT INTO Program (program_id, program_name, program_type) VALUES (?, ?, ?)")) {
                                System.out.print("Program ID: ");
                                ps.setInt(1, sc.nextInt());
                                System.out.print("Program Name: ");
                                ps.setString(2, sc.next());
                                System.out.print("Program Type: ");
                                ps.setString(3, sc.next());

                                int rows = ps.executeUpdate();

                                System.out.println(rows + " rows affected.");
                            }
                            break;
                        }
                        case 4: {
                            try(PreparedStatement ps = conn.prepareStatement("INSERT INTO ServerProgram (server_id, program_id, update_timestamp, version) VALUES (?, ?, ?, ?)")) {
                                System.out.print("Server ID: ");
                                ps.setInt(1, sc.nextInt());
                                System.out.print("Program ID: ");
                                ps.setInt(2, sc.nextInt());
                                Timestamp ts = new Timestamp(System.currentTimeMillis());
                                ps.setTimestamp(3, ts);
                                System.out.print("Version: ");
                                ps.setString(4, sc.next());

                                int rows = ps.executeUpdate();

                                System.out.println(rows + " rows affected.");
                            }
                            break;
                        }
                        case 5: {
                            try(PreparedStatement ps = conn.prepareStatement("DELETE FROM ServerProgram WHERE server_id = ? AND program_id = ?"))  {
                                System.out.print("Server ID: ");
                                ps.setInt(1, sc.nextInt());
                                System.out.print("Program ID: ");
                                ps.setInt(2, sc.nextInt());

                                int rows = ps.executeUpdate();

                                System.out.println(rows + " rows affected.");
                            }
                            break;
                        }
                        case 6: {
                            System.out.print("Hash: ");
                            String inputHash = sc.next();

                            try (CallableStatement cstmt = conn.prepareCall("CALL num_crashes(?)")) {
                                cstmt.setString(1, inputHash);

                                try (ResultSet rs = cstmt.executeQuery()) {
                                    while (rs.next()) {
                                        int count = rs.getInt(1);
                                        System.out.println("Total crashes for hash " + inputHash + ": " + count);
                                    }
                                }
                            }

                            break;
                        }
                        default: {
                            System.out.println("INVALID CHOICE");
                        }
                    }

                    // Commit the transaction explicitly
                    conn.commit();
                    System.out.println("Transaction committed successfully.");
                    System.out.println();
                }
                catch (SQLException e) {
                    // Rollback if any failure occurs
                    try {
                        conn.rollback();
                        System.out.println("Transaction rolled back due to error.");
                    } catch (SQLException rollbackEx) {
                        rollbackEx.printStackTrace();
                    }
                    e.printStackTrace();
                }
                catch(InputMismatchException e) {
                    System.out.println("INVALID INPUT");
                    sc.next();
                }
                finally {
                    // Restore default auto-commit state
                    try {
                        conn.setAutoCommit(true);
                    } catch (SQLException autoCommitEx) {
                        autoCommitEx.printStackTrace();
                    }
                }

                if(!running)
                    return;
            }
        }
        catch(SQLException e) {
            // Give verbose messages for possible error reasons.
            System.out.println("Error occured at connection. Make sure your URL in .config is correct, and have installed the correct driver binaries.");
            System.out.println("Tip: use java -cp /path/to/lib:. Main");
            e.printStackTrace();
            return;
        }

    }
}
