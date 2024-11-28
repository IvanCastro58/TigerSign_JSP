package com.tigersign.dao;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class PendingClaimsServiceContextListener implements ServletContextListener {
    private static boolean isSchedulerStarted = false;
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Start the scheduler when the application starts
        if (!isSchedulerStarted) {
                    PendingClaimsScheduler.startScheduler();
                    isSchedulerStarted = true; // Mark that the scheduler has been started
                    System.out.println("Scheduler started from context listener.");
                }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Clean up resources if necessary
    }
}
