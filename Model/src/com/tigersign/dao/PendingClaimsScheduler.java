package com.tigersign.dao;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class PendingClaimsScheduler {

    private static final long INITIAL_DELAY = 0L;
    private static final long PERIOD = 1L; // Period in minutes
    private static boolean isSchedulerStarted = false; // Static flag to track scheduler initialization

    public static synchronized void startScheduler() {
        if (isSchedulerStarted) {
            System.out.println("Scheduler is already running.");
            return; // Prevent multiple scheduler initializations
        }

        // Mark the scheduler as started
        isSchedulerStarted = true;

        // Creating a scheduled executor service
        ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

        // Schedule the task to run every 1 minute
        scheduler.scheduleAtFixedRate(() -> {
            try {
                // Indicate that the scheduler has started its run
                System.out.println("Scheduler started...");

                // Call the method to process the pending claims
                PendingClaimsService service = new PendingClaimsService();
                service.processPendingClaims();

                // Indicate that the process for this run is complete
                System.out.println("Scheduler run complete.");
            } catch (Exception e) {
                e.printStackTrace();
                // Optionally log failure for visibility
                System.out.println("Error during scheduler run: " + e.getMessage());
            }
        }, INITIAL_DELAY, PERIOD, TimeUnit.MINUTES); // Repeats every 1 minute
    }
}
