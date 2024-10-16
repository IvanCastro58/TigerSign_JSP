<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Top Navigation for Pending Claims, Claimer Table, and Audit Logs -->

<div class="top-nav">
    <div class="nav-item1">
        <div class="item1-label">Show</div>
        <select id="rows-per-page" class="number">
            <option value="20">20</option>
            <option value="10" selected>10</option>
            <option value="5">5</option>
            <option value="2">2</option>
        </select>
        <div class="drop-icon">
            <i class="fa-solid fa-caret-down"></i>
        </div>
    </div>

    <div class="nav-item2">
        <div class="item2-label">Start Date</div>
        <div class="date-box">
            <div class="date start-date">10 Aug 2024</div>
            <div class="calendar-icon" data-target="start-date">
                <i class="fa-regular fa-calendar"></i>
            </div>
        </div>
        <div class="item2-label">End Date</div>
        <div class="date-box">
            <div class="date end-date">10 Aug 2024</div>
            <div class="calendar-icon" data-target="end-date">
                <i class="fa-regular fa-calendar"></i>
            </div>
        </div>
    </div>
    <div class="nav-item3">
        <div class="search-container">
            <input type="text" class="search-input" id="search-admin" placeholder="Search...">
            <button class="search-button"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
    </div>
</div>